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

#include "config.h"

#include <geier.h>

int geier_send(geier_context *context,
	       const xmlDoc *input, xmlDoc **output)
{
	int retval = 0;
	xmlDoc *in_encr;
	unsigned char *in_text;
	size_t in_len;
	unsigned char *out_text;
	size_t out_len;
	xmlDoc *out_encr;

	retval = geier_encrypt(context, input, &in_encr);
	if (retval) { goto exit0; }

	retval = geier_xml_to_text(context, in_encr, &in_text, &in_len);
	if (retval) { goto exit1; }

	retval = geier_send_encrypted_text(context,
					   in_text, in_len,
					   &out_text, &out_len);
	if (retval) { goto exit2; }

	retval = geier_text_to_xml(context, out_text, out_len, &out_encr);
	if (retval) { goto exit3; }

	retval = geier_decrypt(context, out_encr, output);
	if (retval) { goto exit4; }

	/* FIXME: wipe session key */
 exit4:
	xmlFreeDoc(out_encr);
 exit3:
	free(out_text);
 exit2:
	free(in_text);
 exit1:
	xmlFreeDoc(in_encr);
 exit0:
	return retval;
}
