/*
 * Copyright (C) 2005,2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#ifndef GEIER_DSIG_H
#define GEIER_DSIG_H

#include <geier.h>

GEIER_BEGIN_PROTOS

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

GEIER_END_PROTOS

#endif /* GEIER_DSIG_H */
