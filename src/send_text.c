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

#include <geier.h>

int geier_send_text(const unsigned char *input, size_t inlen,
		    unsigned char **output, size_t *outlen)
{
	int retval = 0;
	xmlDoc *in;
	xmlDoc *out;

	retval = geier_text_to_xml(input, inlen, in);
	if (retval) {
		goto exit0;
	}
	retval = geier_send(in, out);
	if (retval) {
		goto exit1;
	}
	retval = geier_xml_to_text(out, output, outlen);
	if (retval) {
		goto exit2;
	}

 exit2:
	xmlFreeDoc(in);
 exit1:
	xmlFreeDoc(out);
 exit0:
	return retval;
}
