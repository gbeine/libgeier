/*
 * Copyright (C) 2004,2005,2007  Stefan Siegl <ssiegl@gmx.de>, Germany
 *               2005        Jürgen Stuber <juergen@jstuber.net>, Germany
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
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

#include "config.h"

#include <openssl/pem.h>
#include <openssl/stack.h>
#include <openssl/bio.h>
#include <openssl/err.h>
#include <openssl/rand.h>

#include <stdio.h>
#include <unistd.h>
#include <assert.h>

#include <geier.h>
#include <string.h>

#include "context.h"
#include "asn1hack.h"

#include "pkcs7_encrypt.h"

#ifdef OPENSSL_NO_DES
#error "OpenSSL 3DES-cipher not available. GEIER won't work that way!"
#endif

static X509 *geier_encrypt_get_cert(const char *filename);

static PKCS7 *p7_build(geier_context *context,
		       const X509 *x509_cert,
		       const unsigned char *input, size_t inlen);
static int p7_init_cipher_context(geier_context *context,
				  const EVP_CIPHER *cipher,
				  EVP_CIPHER_CTX *cipher_context);
static int p7_set_cipher(const EVP_CIPHER *cipher, PKCS7 *p7);
static int p7_set_enc_key(const EVP_CIPHER *cipher,
			  unsigned char *key,
			  const X509 *x509_cert,
			  PKCS7 *p7);
static int p7_set_iv(EVP_CIPHER_CTX *context, PKCS7 *p7);
static int p7_set_enc_data(EVP_CIPHER_CTX *context,
			   const unsigned char *input, size_t inlen,
			   PKCS7 *p7);

static unsigned char *rand_malloc(size_t len);


/* Do PKCS#7 public key crypto (encrypting inlen bytes from *input on)
 * and apply our ASN.1 patch. Return result in **output, a buffer of length
 * *outlen bytes, allocated with malloc().
 *
 * Return: 0 on success, **output and *outlen are only valid in case of success
 * 
 * Caller has to call free() on **output buffer
 */
int geier_pkcs7_encrypt(geier_context *context,
			const unsigned char *input, size_t inlen,
			unsigned char **output, size_t *outlen)
{
	int retval = 0;
	PKCS7 *p7;
	X509 *x509_cert;

	if (!context || !context->cert_filename || !output || !outlen) {
		retval = -1;
		goto exit0;
	}

	x509_cert = geier_encrypt_get_cert(context->cert_filename);
	if (!x509_cert) {
		retval = -1;
		goto exit1;
	}

	/* build PKCS#7 structure */
	p7 = p7_build(context, x509_cert, input, inlen);
	if (!p7) {
		retval = -1;
		goto exit2;
	}

	/* output data */
	{
		size_t len = i2d_PKCS7(p7, NULL);
		unsigned char *p7_der_buf = malloc(len);
		unsigned char *p = p7_der_buf;

		if (! p7_der_buf) {
			retval = -1;
			goto exit3;
		}

		len = i2d_PKCS7(p7, &p);
		if (geier_asn1hack(p7_der_buf, len, output, outlen))
			retval = -1;

		free(p7_der_buf);
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
		fprintf(stderr, PACKAGE_NAME ": unable to open X.509 "
			"certificate: %s: %s\n", filename,
			strerror(errno));
		/* perror(PACKAGE_NAME); */
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


static PKCS7 *p7_build(geier_context *context,
		       const X509 *x509_cert,
		       const unsigned char *input, size_t inlen)
{
	PKCS7 *p7 = NULL;
	const EVP_CIPHER *cipher = EVP_des_ede3_cbc();
	EVP_CIPHER_CTX cipher_context;

	/* initialize cipher context */
	
	if (p7_init_cipher_context(context, cipher, &cipher_context)) {
		goto exit0;
	}
	/* create PKCS7 object now */
	p7 = PKCS7_new();
	if (!p7) { goto exit1; }
	if (!PKCS7_set_type(p7, NID_pkcs7_enveloped)) { goto exit2; }
	if (!PKCS7_set_cipher(p7, cipher)) { goto exit3; }

	/* add recipient (only in envelope mode) */
	if (!PKCS7_add_recipient(p7, (X509 *)x509_cert)) { goto exit4; }

	/* we need to initialize PKCS#7 stuff the hard way,
	 * since we have got to remember (and know!) the 3DES key :-( */
	if (p7_set_cipher(cipher, p7)) { goto exit5; }

	/* encrypt 3des key with RSA and attach to PKCS#7 struct */
	if (p7_set_enc_key(cipher, context->session_key,
			   x509_cert,
			   p7)) {
		goto exit6;
	}
	/* store IV in PKCS#7 structure
	 * shalt be done before any encryption!!! */
	if (p7_set_iv(&cipher_context, p7)) { goto exit7; }

	/* now simply *lol* encrypt the data (3DES) ...
	 *  -- can somebody serve my a cup of coffee in the meantime ?? */
	if (p7_set_enc_data(&cipher_context, input, inlen, p7)) { goto exit8; }

	return p7;

 exit8:
 exit7:
 exit6:
 exit5:
 exit4:
 exit3:
 exit2:
	PKCS7_free(p7);
 exit1:
 exit0:
	return NULL;
}


static int p7_init_cipher_context(geier_context *context,
				  const EVP_CIPHER *cipher,
				  EVP_CIPHER_CTX *cipher_context)
{
	int retval = 0;
	unsigned char *key = NULL;
	unsigned char *iv = NULL;
	
	if (context->session_key) {
		key = context->session_key;
	}
	else {
		key = rand_malloc(EVP_CIPHER_key_length(cipher));
		if (!key) {
			retval = -1;
			goto exit0;
		}
		/* save for decryption */
		context->session_key = key;
		context->session_key_len = EVP_CIPHER_key_length(cipher);
	}
	if (context->iv) {
		iv = context->iv;
	}
	else {
		iv = rand_malloc(EVP_CIPHER_iv_length(cipher));
		if (!iv) {
			retval = -1;
			goto exit1;
		}
	}
	if (!EVP_EncryptInit(cipher_context, cipher, key, iv)) {
		retval = -1;
		goto exit2;
	}
 exit2:
 exit1:
	if (!context->iv) { free(iv); }
 exit0:
	return retval;
}

static int p7_set_cipher(const EVP_CIPHER *cipher, PKCS7 *p7)
{
	p7->d.enveloped->enc_data->algorithm->algorithm =
		OBJ_nid2obj(EVP_CIPHER_type(cipher));
	return 0;
}

static int p7_set_enc_key(const EVP_CIPHER *cipher,
			  unsigned char *key,
			  const X509 *x509_cert,
			  PKCS7 *p7)
{
	int retval = 0;
	char buf[512];
	EVP_PKEY *elster_pubkey = X509_get_pubkey((X509 *)x509_cert);

	#if OPENSSL_VERSION_NUMBER >= 0x10000000L
	#define EVP_PKEY_encrypt EVP_PKEY_encrypt_old
	#endif

	int len = EVP_PKEY_encrypt((unsigned char *) buf,
				   key, EVP_CIPHER_key_length(cipher),
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


static unsigned char *rand_malloc(size_t len)
{
	unsigned char *result = malloc(len);
	if (!result) {
		goto exit0;
	}
	if (RAND_bytes(result, len) != 1) {
		free(result);
		result = NULL;
		goto exit1;
	}
 exit1:
 exit0:
	return result;
}
