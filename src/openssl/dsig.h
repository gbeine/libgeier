/*
 * Copyright (C) 2005,2007  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <geier.h>
#include "context.h"

#ifndef GEIER_DSIG_H
#define GEIER_DSIG_H


/* 
 * make sure `ElsterOnline-Portal: ' is in the DatenLieferant field
 */
int geier_dsig_rewrite_datenlieferant(xmlDoc *doc);


/* 
 * replace `NoSig' in `Vorgang' by `Sig'
 */ 
int geier_dsig_rewrite_vorgang(xmlDoc *doc);


/* 
 * perform actual signing process 
 */
int geier_dsig_sign_cruft_softpse(geier_context *context, xmlDoc **output,
				  const char *softpse, const char *pin);
int geier_dsig_sign_cruft_opensc(geier_context *context, xmlDoc **output,
				 unsigned int cert_id);



#include <openssl/x509.h>
/*
 * find the attribute `want' from the X509_ATTRIBUTE stack
 *
 * You need to free the returned memory (if not NULL, which means
 * that there is no attribute with that name)
 */
char *geier_dsig_get_attr(STACK_OF(X509_ATTRIBUTE) *attrs, const char *want);

/* just verify pkcs#12 file's mac, i.e. check whether pin is okay */
int geier_dsig_verify_mac(geier_context *context, 
			  const char *softpse_filename, 
			  const char *password);

#include <openssl/pkcs12.h>
/* open and try to read file (filename, using pincode) and return PKCS#12
 * structure */
PKCS12 *geier_dsig_open(const char *filename, const char *pincode);

#include <openssl/evp.h>
/* return the signature key from the softpse file */
EVP_PKEY *geier_dsig_get_signaturekey(geier_context *context, 
				      const char *softpse_filename, 
				      const char *pincode);

/* return the encryption key, contained in the pkcs#12 softpse file */
EVP_PKEY *geier_dsig_get_encryptionkey(geier_context *context, 
				       const char *softpse_filename, 
				       const char *pincode);

#include <openssl/x509.h>
/* return the encryption certificate, contained in the pkcs#12 file */
X509 *geier_dsig_get_encryptioncert(geier_context *context,
				    const char *filename,
				    const char *password,
				    char **friendlyName);

/* return the signature certificate, held by the PKCS#12 file */
X509 *geier_dsig_get_signaturecert(geier_context *context,
				   const char *filename,
				   const char *password,
				   char **friendlyName);


int geier_dsig_get_signaturecert_text(geier_context *context,
				      const char *pse, const char *pin,
				      char **output, size_t *outlen,
				      char **fN);

int geier_dsig_X509_to_textcert(geier_context *context, X509 *cert,
				char **output, size_t *outlen);

#endif
