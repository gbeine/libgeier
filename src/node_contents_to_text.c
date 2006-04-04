/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
 * Copyright (C) 2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#include "config.h"

#include <string.h>
#include <assert.h>

#include <libxml/tree.h>

#include "context.h"
#include "find_node.h"


#define INDENT_LEVEL 4
#define ALLOW_FORMAT 0


/*
 * dump a node's content into an unsigned char array
 *
 * The result is guaranteed to be of encoding ISO-8859-1 (or whatever else
 * is specified as context->xml_encoding).
 */
int geier_node_contents_to_text(geier_context *context,
				xmlDoc *doc, xmlNode *node,
				unsigned char **output, size_t *outlen)
{
	int retval = 0;
	xmlBuffer *buf = NULL;
	xmlNode *n = NULL;
	unsigned char *content = NULL;
	size_t content_len = 0;

	/* convert contents of selected node to text */
	buf = xmlBufferCreate();
	xmlCharEncodingHandler *enc =
		xmlFindCharEncodingHandler(context->xml_encoding);
	assert(enc);

	xmlOutputBuffer *outbuf = xmlOutputBufferCreateBuffer(buf, enc);

	/* convert all children */
	for (n = node->children; n != NULL; n = n->next) {
		xmlNodeDumpOutput(outbuf, doc, n, INDENT_LEVEL, ALLOW_FORMAT,
				  context->xml_encoding);
	}

	xmlOutputBufferClose(outbuf);

	content = (unsigned char *)xmlBufferContent(buf);
	content_len = xmlBufferLength(buf);

	*output = malloc(content_len);
	if (!*output) {
		retval = -1;
		goto exit1;
	}
	memcpy(*output, content, content_len);
	*outlen = content_len;
	
 exit1:
 exit0:
	xmlBufferFree(buf);
	return retval;
}
