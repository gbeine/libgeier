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
#include <WWWUtil.h>

#include <geier.h>

#include "gzip_inflate.h"

#define BUF_SIZE  DEFAULT_HTCHUNK_GROWBY

int geier_gzip_inflate(const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen)
{
	int retval = 0;
	HTChunk *out_chunk = HTChunk_new(DEFAULT_HTCHUNK_GROWBY);
	z_stream strm;
	unsigned char *buf;
	int err = Z_OK;

	/* Ensure that data is not NULL. */
	HTChunk_ensure(out_chunk, 1);

	if (!input || !output || !outlen) {
		retval = -1;
		goto exit0;
	}
	strm.next_in = (unsigned char *)input;
	strm.avail_in = inlen;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = NULL;

	buf = malloc(BUF_SIZE);
	if (!buf) {
		retval = -ENOMEM;
		goto exit1;
	}
	err = inflateInit2(&strm, GEIER_WBITS_GZIP);
	if (err != Z_OK) {
		retval = -1;
		goto exit2;
	}
	while (err != Z_STREAM_END) {
		strm.next_out = buf;
		strm.avail_out = BUF_SIZE;
		err = inflate(&strm, Z_NO_FLUSH);
		if (err != Z_OK && err != Z_STREAM_END) {
			retval = -1;
			goto exit3;
		}
		/* Append filled part of buffer to output. */
		HTChunk_putb(out_chunk, buf, strm.next_out-buf);
	}
	err = inflateEnd(&strm);
	if (err != Z_OK) {
		retval = -1;
		goto exit4;
	}
	*outlen = HTChunk_size(out_chunk);
	*output = HTChunk_toCString(out_chunk); /* free chunk, keep contents */

 exit4:
 exit3:
 exit2:
 exit1:
	free(buf);
 exit0:
	if (retval) { HTChunk_delete(out_chunk); }
	return retval;
}
