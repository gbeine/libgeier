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
#include "dsig.h"
#include "context.h"

#include <string.h>

#include "dsig.h"

char *
geier_dsig_get_attr(STACK_OF(X509_ATTRIBUTE) *attrs, const char *want)
{
	if(! attrs) return NULL;
	
	int i;
	for(i = 0; i < sk_X509_ATTRIBUTE_num(attrs); i ++) {
		X509_ATTRIBUTE *attr = sk_X509_ATTRIBUTE_value(attrs, i);
		
		int id = OBJ_obj2nid(attr->object);
		if(id == NID_undef)
			continue; /* unnamed attribute */

		if(strcmp(OBJ_nid2ln(id), want) == 0) {
			if(! sk_ASN1_TYPE_num(attr->value.set)) return NULL;

			ASN1_TYPE *val = sk_ASN1_TYPE_value(attr->value.set,0);

			if(val->type == V_ASN1_BMPSTRING)
				return uni2asc(val->value.bmpstring->data,
					       val->value.bmpstring->length);

			if(val->type == V_ASN1_OCTET_STRING)
				return strdup((const char *)
					      val->value.bmpstring->data);


			fprintf(stderr, PACKAGE_NAME ": unsupported "
				"ASN.1 type in get_attr. Sorry.\n");

			return NULL;
		}
	}

	return NULL;
}
