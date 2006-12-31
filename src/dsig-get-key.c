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

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <geier.h>
#include "context.h"

#include <string.h>
#include <assert.h>

#include "dsig.h"

#include <nss/pk11pub.h>
#include <xmlsec/nss/pkikeys.h>

static xmlSecKeyData *
geier_dsig_get_key(geier_context *context, 
		   const char *filename, 
		   const char *pin,
		   const char *bagname)
{
	xmlSecKeyData *result = NULL;
	SEC_PKCS12DecoderContext *p12 = NULL;

	if(geier_dsig_resolve_nickname(context, filename, pin,
				       &p12, &bagname)) {
		fprintf(stderr, PACKAGE_NAME ": unable to resolve " 
			"PKCS#12 bag nickname.\n");
		goto out;
	}

	fprintf(stderr, "need cert: %s\n", bagname);

	CERTCertList *clist = SEC_PKCS12DecoderGetCerts(p12);
	if(! clist) {
		fprintf(stderr, PACKAGE_NAME ": unable to get "
			"certificates list.\n");
		goto out;
	}

	CERTCertListNode *node;
	for(node = CERT_LIST_HEAD(clist);
	    ! CERT_LIST_END(node, clist);
	    node = CERT_LIST_NEXT(node)) {
		CERTCertificate *cert = node->cert;

		if(strcmp(cert->nickname, bagname))
			continue;

		SECKEYPrivateKey *privkey = PK11_FindKeyByAnyCert(cert, NULL); 
		if(! privkey) {
			fprintf(stderr, PACKAGE_NAME ": unable to find "
				"private key.\n");
			goto out;
		}

		SECKEYPublicKey *pubkey = CERT_ExtractPublicKey(cert);
		if(! pubkey) {
			fprintf(stderr, PACKAGE_NAME ": unable to extract "
				"public key from available certificate.\n");
			goto out;
		}

		result = xmlSecNssPKIAdoptKey(privkey, pubkey);
		if(! result) {
			fprintf(stderr, PACKAGE_NAME ": unable to adopt "
				"needed keys.\n");
			goto out;
		}
		
		break;
	}

	if(! result)
		fprintf(stderr, PACKAGE_NAME ": unable to match "
			"certificate.  this should not happen.\n");

 out:
	SEC_PKCS12DecoderFinish(p12);
	return result;
}



xmlSecKeyData *
geier_dsig_get_signaturekey(geier_context *context, 
			    const char *filename, 
			    const char *password)
{
	return geier_dsig_get_key(context, filename, password,
				  "signaturekey");
}




xmlSecKeyData *
geier_dsig_get_encryptionkey(geier_context *context, 
			    const char *filename, 
			    const char *password)
{
	return geier_dsig_get_key(context, filename, password,
				  "encryptionkey");
}


