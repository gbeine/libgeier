/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
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

#include <stdlib.h>
#include <errno.h>
#include <zlib.h>

#include <geier.h>

#include "gzip_deflate.h"

#define DEFAULT_MEMLEVEL 8


int geier_gzip_deflate(const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen)
{
	int retval = 0;
	z_stream strm;
	int err = 0;
	size_t bound;
	unsigned char *new;

	if (!input || !output || !outlen) {
		retval = -1;
		goto exit0;
	}
	strm.next_in = (unsigned char *)input;
	strm.avail_in = inlen;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = NULL;

	err = deflateInit2(&strm,
			   Z_DEFAULT_COMPRESSION,
			   Z_DEFLATED,
			   GEIER_WBITS_GZIP,
			   DEFAULT_MEMLEVEL,
			   Z_DEFAULT_STRATEGY);
	if (err != Z_OK) {
		retval = -1;
		goto exit1;
	}
	/* FIXME: should we make this more precise? */
	bound = deflateBound(&strm, inlen)+16;
	*output = malloc(bound);
	if (!*output) {
		retval = -ENOMEM;
		goto exit2;
	}
	strm.next_out = *output;
	strm.avail_out = bound;
	err = deflate(&strm, Z_FINISH);
	if (err != Z_STREAM_END) {
		retval = -1;
		goto exit3;
	}
	err = deflateEnd(&strm);
	if (err != Z_OK) {
		retval = -1;
		goto exit4;
	}
	*outlen = strm.total_out;
	new = realloc(*output, *outlen);
	if (!new) {
		retval = -1;
		goto exit5;
	}
	*output = new;
 exit5:
 exit4:
 exit3:
 exit2:
	if (retval) { free(*output); }
 exit1:
 exit0:
	return retval;
}
