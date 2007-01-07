/*                                              -*- mode: C; coding: utf-8 -*-
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

#include <libxml/encoding.h>
 	
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

/*
 * convert input, which is in ISO-8859-1 encoding, to UTF-8 encoding
 *
 * FIXME: input is probably not in ISO-8859-1 encoding but in 
 *        context->xml_encoding (which for the moment is ISO-8859-1,
 *        but this will fail as soon as the IRO requires either UTF-8
 *        or at least ISO-8859-15)
 */
int
geier_iso_to_utf8(const unsigned char *input, size_t inlen,
		  unsigned char **output, size_t *outlen)
{
	unsigned char *buffer, *ptr;

	if(!input || !output || !outlen)
		return -1;

	size_t alloc = inlen + 16;
	if(! (buffer = ptr = malloc(alloc))) {
		perror(PACKAGE_NAME);
		return -1;
	}
	
	while(inlen) {
		int avail = alloc - (ptr - buffer);
		if(avail < inlen + 16) {
			int offset = ptr - buffer;
			avail += 16;
			alloc = offset + avail;
			buffer = realloc(buffer, alloc);
			if(! buffer) {
				perror(PACKAGE_NAME);
				return -1;
			}
			ptr = buffer + offset;
		}

		int my_inlen = inlen;
		size_t nconv = isolat1ToUTF8(ptr, &avail, input, &my_inlen);

		if(nconv < 0) {
			fprintf(stderr, PACKAGE_NAME ": isolat1ToUTF8 "
				"failed.\n");
			free(buffer);
			return -1;
		}

		inlen -= my_inlen;
		input += my_inlen;

		ptr += avail;
	}

	*outlen = ptr - buffer;
	*output = realloc(buffer, *outlen); /* shrink buffer */
	return 0;
}
