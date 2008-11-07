/*
 * Copyright (C) 2005,2007  Stefan Siegl <stesie@brokenpipe.de>, Germany
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
#include "context.h"

#include <stdio.h>
#include <errno.h>
#include <assert.h>

#include <geier.h>
#include "pkcs7_decrypt.h"

#include <openssl/err.h>
#include <openssl/x509.h>
#include <openssl/pkcs7.h>
#include <openssl/evp.h>

#ifdef OPENSSL_NO_DES
#error "OpenSSL 3DES-cipher not available. GEIER won't work that way!"
#endif

/* Decrypt PKCS#7 encrypted content using the session key in the context.
 */
int geier_pkcs7_decrypt(geier_context *context,
			const unsigned char *input, size_t inlen,
			unsigned char **output, size_t *outlen)
{
	PKCS7 *p7;
	PKCS7_ENC_CONTENT *enc_data; 
	EVP_CIPHER_CTX ctx;
	const EVP_CIPHER *ciph;
	const unsigned char *iv;
	int len;
	unsigned char *p = (unsigned char *) input;
	int retval = 0;

	if (!context || !output || !outlen) {
		retval = -1;
		goto exit0;
	}

	p7 = d2i_PKCS7(NULL, (const unsigned char **) &p, inlen);
	if(! p7) {
		retval = -1;
		goto exit1;
	}

	if(! PKCS7_type_is_encrypted(p7)) {
		retval = -1;
		goto exit2;
	}

	ciph = EVP_des_ede3_cbc();
	EVP_CIPHER_CTX_init(&ctx);

	enc_data = p7->d.encrypted->enc_data;
	iv = enc_data->algorithm->parameter->value.asn1_string->data;
	len = enc_data->enc_data->length + ciph->block_size;
	*output = p = malloc(len);

	if(! *output) {
		retval = -ENOMEM;
		goto exit4;
	}

	if(! EVP_DecryptInit(&ctx, ciph, context->session_key, iv)) {
		retval = -1;
		goto exit5;
	}

	if(! EVP_DecryptUpdate(&ctx, p, &len, enc_data->enc_data->data,
			       enc_data->enc_data->length)) {
		retval = -1;
		goto exit6;
	}

	p += len;

	if(! EVP_DecryptFinal(&ctx, p, &len)) {
		retval = -1;
		goto exit7;
	}

	*outlen = (p - *output) + len;
	*output = realloc(*output, *outlen);

 exit7:
 exit6:
 exit5:
 exit4:
	if(retval)
		free(* output);
/* exit3: */
	/* EVP_CIPHER_CTX_cleanup(&ctx); */
 exit2:
 exit1:
	PKCS7_free(p7);
 exit0:
	if(retval) {
		ERR_load_PKCS7_strings();
		ERR_print_errors_fp(stderr);
	}

	return retval;
}

