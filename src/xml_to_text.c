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
#include "context.h"

#include <geier.h>


int geier_xml_to_text(geier_context *context,
		      const xmlDoc *doc,
		      unsigned char **output, size_t *outlen)
{
	int retval = 0;

	if (!doc || !output || !outlen) {
		retval = -1;
		goto exit0;
	}
	xmlDocDumpFormatMemoryEnc(doc, output, outlen,
				  context->xml_encoding, 1);

 exit0:
	return retval;
}
