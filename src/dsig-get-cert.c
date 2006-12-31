/*
 * Copyright (C) 2005, 2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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
#include <nss/certt.h>

static CERTCertificate *
geier_dsig_get_cert(geier_context *context, 
		    const char *filename, 
		    const char *pin,
		    /* const char *bagname, */
		    unsigned char usage,
		    char **fn)
{
	CERTCertificate *result = NULL;
	SEC_PKCS12DecoderContext *p12 = NULL;
	CERTCertList *clist = NULL;

	if(! fn) return NULL;
	*fn = NULL;

	if(! p12) p12 = geier_dsig_open(filename, pin, 0);
	if(! p12) goto out;

	clist = SEC_PKCS12DecoderGetCerts(p12);
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

		/* fprintf(stderr, "%s: available certificate: %s\n",
		 *	filename, cert->nickname);
		 */

		SECKEYPrivateKey *privkey = PK11_FindKeyByAnyCert(cert, NULL); 
		if(! privkey) {
			/* fprintf(stderr, "... no private key available.\n");
			 */
			continue;
		}

		SECKEY_DestroyPrivateKey(privkey);

		if(CERT_CheckCertUsage(cert, usage) != SECSuccess) {
			/* fprintf(stderr, "... CheckCertUsage failed.\n");
			 */
			continue;
		}
	
		*fn = strdup(cert->nickname + 3);
		if(! *fn) {
			perror(PACKAGE_NAME);
			goto out;
		}
	
		/* if(strcmp(cert->nickname, bagname))
		 *	continue;
		 */
		result = CERT_DupCertificate(cert);
		if(! result) {
			fprintf(stderr, PACKAGE_NAME ": unable to duplicate "
				"certificate.\n");
			goto out;
		}
		
		break;
	}

	if(! result)
		fprintf(stderr, PACKAGE_NAME ": unable to match "
			"certificate.  this should not happen.\n");

 out:
	SEC_PKCS12DecoderFinish(p12);

	/* strip the friendlyName we return,
	 * it's of the form "CN=Stefan\,Siegl,2.5.4.5=#blablabla"
	 */
	if(*fn) {
		char *ptr = *fn;
		for(; *ptr; ptr ++) {
			if(*ptr != ',') continue;
			if(ptr[-1] == '\\') continue; /* quoted comma */

			*ptr = 0; /* terminate */
			break;
		}
	}

	if(clist)
		CERT_DestroyCertList(clist);

	return result;
}


CERTCertificate *
geier_dsig_get_signaturecert(geier_context *context,
			     const char *filename,
			     const char *password,
			     char **friendlyName) 
{
	return geier_dsig_get_cert(context, filename, password, 
				   KU_DIGITAL_SIGNATURE, friendlyName);
}




CERTCertificate *
geier_dsig_get_encryptioncert(geier_context *context,
			      const char *filename,
			      const char *password,
			      char **friendlyName) 
{
	return geier_dsig_get_cert(context, filename, password, 
				   KU_KEY_ENCIPHERMENT, friendlyName);
}




