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

int geier_send(geier_context *context,
	       const xmlDoc *input, xmlDoc **output)
{
	int retval = 0;
	xmlDoc *in_encr;
	xmlDoc *out_encr;

	retval = geier_encrypt(context, input, &in_encr);
	if (retval) { goto exit0; }

	retval = geier_send_encrypted(context, in_encr, &out_encr);
	if (retval) { goto exit1; }

	retval = geier_decrypt(context, out_encr, output);
	if (retval) { goto exit2; }

	/* FIXME: wipe session key */
 exit2:
	xmlFreeDoc(out_encr);
 exit1:
	xmlFreeDoc(in_encr);
 exit0:
	return retval;
}
