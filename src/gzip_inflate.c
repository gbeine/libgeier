/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
 * Copyright (C) 2005  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#include <stdlib.h>
#include <errno.h>
#include <zlib.h>

#include <geier.h>

#include "gzip_inflate.h"

int geier_gzip_inflate(const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen)
{
	int retval = 0;
	z_stream strm;
	unsigned char *buf = NULL;
	size_t alloc = 0;
	size_t len = 0;
	int err = Z_OK;

	if (!input || !output || !outlen) {
		retval = -1;
		goto exit0;
	}

	strm.next_in = (unsigned char *)input;
	strm.avail_in = inlen;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = NULL;

	err = inflateInit2(&strm, GEIER_WBITS_GZIP);
	if (err != Z_OK) {
		retval = -1;
		goto exit0;
	}

	while (err != Z_STREAM_END) {
		if(len == alloc) {
			alloc = alloc ? (alloc << 1) : 4096;
			buf = realloc(buf, alloc);

			if(! buf) {
				retval = -ENOMEM;
				goto exit1;
			}
		}

		strm.next_out = buf + len;
		strm.avail_out = alloc - len;
		err = inflate(&strm, Z_NO_FLUSH);
		if (err != Z_OK && err != Z_STREAM_END) {
			retval = -1;
			goto exit3;
		}

		len += strm.next_out - (buf + len);
	}
	err = inflateEnd(&strm);
	if (err != Z_OK) {
		retval = -1;
		goto exit4;
	}

	if((*outlen = len))
		*output = realloc(buf, len); /* must not fail, 
					      * since we shrink */
	else {
		free(*output);
		*output = NULL;
	}

 exit4:
 exit3:
 exit1:
	if(retval)
		free(buf);
 exit0:
	return retval;
}
