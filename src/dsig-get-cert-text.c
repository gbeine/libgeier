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





int
geier_dsig_get_signaturecert_text(geier_context *context,
				  const char *pse, const char *pin,
				  char **output, size_t *outlen,
				  char **fN)
{
	X509 *cert = geier_dsig_get_signaturecert(context, pse, pin, fN);
	if(! cert) return 1;

	BIO *bio = BIO_new(BIO_s_mem());
	if(! bio) {
		X509_free(cert);
		return 1;
	}

	PEM_write_bio_X509(bio, cert);
	X509_free(cert);

	*outlen = BIO_get_mem_data(bio, output);
	BIO_set_close(bio, BIO_NOCLOSE);
	BIO_free(bio);

	return 0;
}

