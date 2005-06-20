/*                                              -*- mode: C; coding: utf-8 -*-
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
 	
#include <iconv.h>
#include <stdlib.h>
#include <errno.h>

int
geier_iso_to_utf8(const unsigned char *input, const size_t inlen,
		  unsigned char **output, size_t *outlen)
{
	size_t my_inlen = inlen;
	unsigned char *buffer, *ptr;

	if(!input || !output || !outlen)
		return -1;

	iconv_t cd = iconv_open("UTF-8", "ISO8859-1");
	if(cd == (iconv_t) -1) 
		return -1; /* sorry, didn't work */

	size_t alloc = inlen + 16, avail = alloc;
	if(! (buffer = ptr = malloc(alloc)))
		return -1;
	
	while(my_inlen) {
		size_t nconv = iconv(cd, (char **) &input, &my_inlen,
				     (char **) &ptr, &avail);
		if(nconv == (size_t) -1) {
			if(errno == E2BIG) {
				/* output buffer is not large enough,
				 * let's allocate some more memory  */
				alloc += 16;
				avail += 16;

				if(! (buffer = realloc(buffer, alloc))) 
					return 1;
				ptr = buffer + alloc - avail;
				
				continue; /* ... calling iconv */
			}

			/* something went wrong, sorry */
			free(buffer);
			return -1;
		}
	}

	iconv_close(cd);

	*output = realloc(buffer, alloc - avail); /* shrink buffer */
	*outlen = alloc - avail;
	return 0;
}
