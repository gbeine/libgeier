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

#define GEIER_SIGNATURE_INTERNALS 1
#include <geier.h>
#include "context.h"

#include <openssl/err.h>

PKCS12 *
geier_dsig_open(const char *filename, const char *pincode)
{
	FILE *handle = fopen(filename, "r");
	if(! handle) return NULL;

	PKCS12 *p12 = NULL;
	if (!(p12 = d2i_PKCS12_fp(handle, NULL))) {
		ERR_print_errors_fp(stderr);
		goto out;
	}

	if(! PKCS12_verify_mac(p12, pincode, -1)) 
		p12 = NULL; /* MAC is not valid */

 out:
	fclose(handle);
	return p12;
}



int
geier_dsig_verify_mac(geier_context *context, 
		      const char *filename, 
		      const char *pincode)
{
	PKCS12 *p12 = geier_dsig_open(filename, pincode);
	if(! p12) return 1;

	PKCS12_free(p12);
	return 0;
}
