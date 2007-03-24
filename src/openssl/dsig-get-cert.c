/*
 * Copyright (C) 2005  Stefan Siegl <stesie@brokenpipe.de>, Germany
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
#include "dsig.h"
#include "context.h"

#include <string.h>
#include <assert.h>

#include "dsig.h"

static X509 *
geier_dsig_get_cert(geier_context *context, 
		    const char *filename, 
		    const char *pin,
		    const char *certname,
		    char **fn)
{
	char *keyid = NULL;
	X509 *result = NULL;
	*fn = NULL;

	int pinlen = pin ? strlen(pin) : 0;

	PKCS12 *p12 = geier_dsig_open(filename, pin);
	if(! p12) return NULL;
	
	STACK_OF(PKCS7) *safes = PKCS12_unpack_authsafes(p12);
	if(! safes) return NULL;

	int i;
	for(i = 0; i < sk_PKCS7_num(safes); i ++) {
		PKCS7 *p7 = sk_PKCS7_value(safes, i);
		assert(p7);

		STACK_OF(PKCS12_SAFEBAGS) *bags = NULL;

		int id = OBJ_obj2nid(p7->type);
		if(id == NID_pkcs7_data)
			bags = PKCS12_unpack_p7data(p7);

		else if (id == NID_pkcs7_encrypted)
			bags = PKCS12_unpack_p7encdata(p7, pin, pinlen);

		else {
			fprintf(stderr, PACKAGE_NAME "unknown PKCS12_SAFEBAGS "
				"nid discovered.");
			goto out0;
		}

		assert(bags);

		int j;
		for(j = 0; j < sk_PKCS12_SAFEBAG_num(bags); j ++) {
			PKCS12_SAFEBAG *bag = sk_PKCS12_SAFEBAG_value(bags, j);
			assert(bag);
			
			if(M_PKCS12_bag_type(bag) == NID_pkcs8ShroudedKeyBag) {
				char *friendlyname = 
					geier_dsig_get_attr(bag->attrib, 
							    "friendlyName");

				if(strcmp(friendlyname, certname) == 0) {
					/* got the key we look for */
					keyid = geier_dsig_get_attr
						(bag->attrib, "localKeyID");
				}
			}
			else if(M_PKCS12_bag_type(bag) == NID_certBag
				&& M_PKCS12_cert_bag_type(bag)
				== NID_x509Certificate) {
				char *localKeyID =
					geier_dsig_get_attr(bag->attrib, 
							    "localKeyID");

				if(localKeyID && keyid &&
				   memcmp(localKeyID, keyid, 18) == 0) {
					if(fn)
						*fn = geier_dsig_get_attr
							(bag->attrib,
							 "friendlyName");

					result = PKCS12_certbag2x509(bag);
					sk_PKCS12_SAFEBAG_pop_free
						(bags, PKCS12_SAFEBAG_free);
					free(localKeyID);

					goto out0;
				}

				free(localKeyID);
			}
		}

		sk_PKCS12_SAFEBAG_pop_free(bags, PKCS12_SAFEBAG_free);
	}

out0:
	sk_PKCS7_pop_free(safes, PKCS7_free);
	PKCS12_free(p12);

	if(fn && *fn) {
		/* strip the friendlyName we return,
		 * it's of the form "CN=Stefan\,Siegl,2.5.4.5=#blablabla"
		 */
		int i, l = strlen(*fn);
		for(i = 1; i < l; i ++)
			if((*fn)[i] == ',' && (*fn)[i - 1] != '\\') {
				(*fn)[i] = 0;
				break;
			}
		memmove(*fn, *fn + 3, strlen(*fn + 3) + 1);
	}
	
	return result;
}


X509 *
geier_dsig_get_signaturecert(geier_context *context,
			     const char *filename,
			     const char *password,
			     char **friendlyName) 
{
	return geier_dsig_get_cert(context, filename, password, 
				   "signaturekey", friendlyName);
}




X509 *
geier_dsig_get_encryptioncert(geier_context *context,
			      const char *filename,
			      const char *password,
			      char **friendlyName) 
{
	return geier_dsig_get_cert(context, filename, password, 
				   "encryptionkey", friendlyName);
}




