/*
 * Elster/Coala public key crypto routines
 *
 * Copyright (C) 2004,2005  Stefan Siegl <ssiegl@gmx.de>, Germany
 *               2005       Jürgen Stuber <juergen@jstuber.net>, Germany
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <openssl/pem.h>
#include <openssl/stack.h>
#include <openssl/bio.h>
#include <openssl/err.h>
#include <openssl/rand.h>

#include <stdio.h>
#include <unistd.h>
#include <assert.h>

#include <geier.h>

#include "pkcs7_encrypt.h"
#include "asn1hack.h"

#ifdef OPENSSL_NO_DES
#error "OpenSSL 3DES-cipher not available. GEIER won't work that way!"
#endif

static X509 *geier_encrypt_get_cert(const char *filename);

static PKCS7 *p7_build(const geier_session_key *key,
		       const X509 *x509_cert,
		       const unsigned char *input, size_t inlen);
static int p7_set_cipher(const EVP_CIPHER *cipher, PKCS7 *p7);
static int p7_set_enc_key(const geier_session_key *key,
			  const X509 *x509_cert,
			  PKCS7 *p7);
static int p7_set_iv(EVP_CIPHER_CTX *context, PKCS7 *p7);
static int p7_set_enc_data(EVP_CIPHER_CTX *context,
			   const unsigned char *input, size_t inlen,
			   PKCS7 *p7);

/**
 * Allocate and initialize a session key.
 * Returns NULL on failure.
 */
geier_session_key *geier_make_session_key(void)
{
	geier_session_key *key = NULL;

	key = malloc(sizeof(geier_session_key));
	if (!key) {
		goto exit0;
	}
	/* generate key and iv */
	if (RAND_bytes(key->des3_key, sizeof(key->des3_key)) != 1
	    || RAND_bytes(key->des3_iv, sizeof(key->des3_iv)) != 1) {
		free(key);
		key = NULL;
		goto exit1;
	}
 exit1:
 exit0:
	return key;
}

/* Do PKCS#7 public key crypto (encrypting inlen bytes from *input on)
 * and apply our ASN.1 patch. Return result in **output, a buffer of length
 * *outlen bytes, allocated with malloc().
 *
 * Return: 0 on success, **output and *outlen are only valid in case of success
 * 
 * Caller has to call free() on **output buffer
 */
int geier_pkcs7_encrypt(const char *cert_filename,
			const geier_session_key *key,
			const unsigned char *input, size_t inlen,
			unsigned char **output, size_t *outlen)
{
	int retval = 0;
	PKCS7 *p7;
	X509 *x509_cert;

	if (!key || !output || !outlen) {
		retval = -1;
		goto exit0;
	}

	x509_cert = geier_encrypt_get_cert(cert_filename);
	if (!x509_cert) {
		retval = -1;
		goto exit1;
	}

	/* build PKCS#7 structure */
	p7 = p7_build(key, x509_cert, input, inlen);
	if (!p7) {
		retval = -1;
		goto exit2;
	}

	/* output data */
	{
		size_t len = i2d_PKCS7(p7, NULL);

		/* allocate 4 more bytes needed for the ASN.1 hack */
		*output = malloc(len + 4); 
		if (!*output) {
			retval = -1;
			goto exit3;
		}

		{
			unsigned char *p = *output;
			len = i2d_PKCS7(p7, &p);
		}
		*outlen = asn1hack_doit(asn1hack_octet_string_patch, *output);
	}
 exit3:
	PKCS7_free(p7);
 exit2:
	X509_free(x509_cert);
 exit1:
 exit0:
	if (retval) {
		ERR_load_PKCS7_strings();
		ERR_print_errors_fp(stderr);
	}
	return retval;
}



static X509 *geier_encrypt_get_cert(const char *filename)
{
	FILE *handle;
	X509 *x509_cert;

	/* open file holding certificate  */
	handle = fopen(filename, "r");

	if (!handle) {
		/* perror(PACKAGE_NAME);	 */
		return NULL;
	}

	x509_cert = PEM_read_X509(handle, NULL, NULL, NULL);
	if(! x509_cert) {
		ERR_load_PKCS7_strings();
		ERR_print_errors_fp(stderr);
		return NULL;
	}
	fclose(handle);
	return x509_cert;
}


static PKCS7 *p7_build(const geier_session_key *key,
		       const X509 *x509_cert,
		       const unsigned char *input, size_t inlen)
{
	PKCS7 *p7 = NULL;
	EVP_CIPHER_CTX context;
	const EVP_CIPHER *cipher = EVP_des_ede3_cbc();

	assert(EVP_CIPHER_key_length(cipher) == sizeof(key->des3_key));
	assert(EVP_CIPHER_iv_length(cipher) == sizeof(key->des3_iv));
  
	/* initialize cipher context */
	if (!EVP_EncryptInit(&context, cipher, key->des3_key, key->des3_iv)) {
		goto exit3;
	}

	/* create PKCS7 object now */
	p7 = PKCS7_new();
	if (!p7) { goto exit0; }
	if (!PKCS7_set_type(p7, NID_pkcs7_enveloped)) { goto exit1; }
	if (!PKCS7_set_cipher(p7, cipher)) { goto exit2; }

	/* add recipient (only in envelope mode) */
	if (!PKCS7_add_recipient(p7, (X509 *)x509_cert)) { goto exit3; }

	/* we need to initialize PKCS#7 stuff the hard way,
	 * since we have got to remember (and know!) the 3DES key :-( */
	if (p7_set_cipher(cipher, p7)) { goto exit4; }

	/* encrypt 3des key with RSA and attach to PKCS#7 struct */
	if (p7_set_enc_key(key, x509_cert, p7)) { goto exit5; }

	/* store IV in PKCS#7 structure
	 * shalt be done before any encryption!!! */
	if (p7_set_iv(&context, p7)) { goto exit6; }

	/* now simply *lol* encrypt the data (3DES) ...
	 *  -- can somebody serve my a cup of coffee in the meantime ?? */
	if (p7_set_enc_data(&context, input, inlen, p7)) { goto exit7; }

	return p7;

 exit7:
 exit6:
 exit5:
 exit4:
 exit3:
 exit2:
 exit1:
	PKCS7_free(p7);
 exit0:
	return NULL;
}

static int p7_set_cipher(const EVP_CIPHER *cipher, PKCS7 *p7)
{
	p7->d.enveloped->enc_data->algorithm->algorithm =
		OBJ_nid2obj(EVP_CIPHER_type(cipher));
	return 0;
}

static int p7_set_enc_key(const geier_session_key *key,
			  const X509 *x509_cert,
			  PKCS7 *p7)
{
	int retval = 0;
	char buf[512];
	EVP_PKEY *elster_pubkey = X509_get_pubkey((X509 *)x509_cert);

	int len = EVP_PKEY_encrypt(buf,
				   ((geier_session_key *)key)->des3_key,
				   sizeof(key->des3_key),
				   elster_pubkey);
	if(len < 0) {
		retval = -1;
		goto exit0;
	}

	/* convert to ASN.1 and store in PKCS#7 structure */
	ASN1_STRING_set(sk_PKCS7_RECIP_INFO_value(p7->d.enveloped->recipientinfo, 0)
			->enc_key, buf, len);
 exit0:
	EVP_PKEY_free(elster_pubkey);
	return retval;
}


/* store IV in PKCS#7 structure */
static int p7_set_iv(EVP_CIPHER_CTX *context, PKCS7 *p7)
{
	p7->d.enveloped->enc_data->algorithm->parameter = ASN1_TYPE_new();
	if (EVP_CIPHER_param_to_asn1
	    (context, p7->d.enveloped->enc_data->algorithm->parameter) < 0) {
		return -1;
	}
	return 0;
}


/* store encrypted data in PKCS#7 structure */
static int p7_set_enc_data(EVP_CIPHER_CTX *context,
			   const unsigned char *input, size_t inlen,
			   PKCS7 *p7)
{
	int retval = 0;
	int outlen;
	unsigned char *buf;
	unsigned char *p;

	buf = malloc(inlen + EVP_CIPHER_CTX_block_size(context));
	if (!buf) {
		retval = -ENOMEM;
		goto exit0;
	}
	if (!EVP_EncryptUpdate(context, buf, &outlen, input, inlen)) {
		retval = -1;
		goto exit1;
	}
	p = buf + outlen;

	if (!EVP_EncryptFinal(context, p, &outlen)) {
		retval = -1;
		goto exit2;
	}
	p += outlen;

	p7->d.enveloped->enc_data->enc_data = M_ASN1_OCTET_STRING_new();
	ASN1_STRING_set(p7->d.enveloped->enc_data->enc_data, buf, p - buf);

 exit2:
 exit1:
	free(buf);
 exit0:
	return retval;
}
