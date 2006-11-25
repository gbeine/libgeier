/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
 * Copyright (C) 2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#include <geier.h>

#include "config.h"

#include <errno.h>
#include "bsd-base64.h"

#include "base64.h"


int geier_base64_encode(const unsigned char *input, size_t inlen,
			 unsigned char **output, size_t *outlen)
{
	int len;

	if (!output || !outlen) {
		return -1;
	}
	*outlen = (inlen+2)*2;
	*output = malloc(*outlen);
	if (!*output) {
		return -1;
	}

	len = b64_ntop(input, inlen, (char *) *output, *outlen);
	if (len < 0) {
		free(*output);
		return -1;
	}
	*output = realloc(*output, len);
	*outlen = len;
	return 0;
}

int geier_base64_decode(const unsigned char *input, size_t inlen,
			unsigned char **output, size_t *outlen)
{
	int len;

	if (!output || !outlen) {
		return -1;
	}
	*outlen = inlen;
	*output = malloc(*outlen);
	if (!*output) {
		return -1;
	}

	len = b64_pton((const char *) input, inlen, *output, *outlen);
	if (len < 0) {
		free(*output);
		return -1;
	}
	*output = realloc(*output, len);
	*outlen = len;
	return 0;
}
