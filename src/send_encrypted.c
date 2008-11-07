/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
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

#include "config.h"

#include <geier.h>

int geier_send_encrypted(geier_context *context,
			 const xmlDoc *input, xmlDoc **output)
{
	int retval = 0;
	unsigned char *in_text;
	size_t in_len;
	unsigned char *out_text;
	size_t out_len;

	retval = geier_xml_to_encoded_text(context, input, "ISO-8859-1",
					   &in_text, &in_len);
	if (retval) { goto exit0; }

	retval = geier_send_encrypted_text(context,
					   in_text, in_len,
					   &out_text, &out_len);
	if (retval) { goto exit1; }

	retval = geier_text_to_xml(context, out_text, out_len, output);
	if (retval) { goto exit2; }

 exit2:
	free(out_text);
 exit1:
	free(in_text);
 exit0:
	return retval;
}
