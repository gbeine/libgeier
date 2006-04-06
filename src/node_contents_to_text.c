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

#ifdef HAVE_XMLOUTPUTBUFFERCREATEBUFFER
	xmlOutputBuffer *outbuf = xmlOutputBufferCreateBuffer(buf, enc);
#else
	/*
	 * xmlOutputBufferCreateBuffer is not available in libxml 2.6.16,
	 * which is currently shipped with Debian/Sarge, therefore work 
	 * around ...
	 */
	xmlOutputBuffer *outbuf;
	outbuf = (xmlOutputBufferPtr) xmlMalloc(sizeof(xmlOutputBuffer));
	
	if(! outbuf) {
		retval = -1;
		goto exit0;
	}

	memset(outbuf, 0, (size_t) sizeof(xmlOutputBuffer));
	outbuf->buffer = buf;
#endif

	/* convert all children */
	for (n = node->children; n != NULL; n = n->next) {
		xmlNodeDumpOutput(outbuf, doc, n, INDENT_LEVEL, ALLOW_FORMAT,
				  context->xml_encoding);
	}

	content = (unsigned char *)xmlBufferContent(buf);
	content_len = xmlBufferLength(buf);

	*output = malloc(content_len + 1);
	if (! *output) {
		retval = -1;
		goto exit1;
	}

	xmlOutputBufferFlush(outbuf);

#ifdef HAVE_XMLOUTPUTBUFFERCREATEBUFFER
	/* FIXME: check whether this already frees buf ... */
	xmlOutputBufferClose(outbuf);
	
	memcpy(*output, content, content_len + 1);
	*outlen = content_len;
#else
	/* work around case: we need to convert the buffer's content (which
	 * is in UTF-8 currently) to Latin1 now ... */
	int o = content_len, inlen = content_len;
	*outlen = enc->output(*output, &o, content, &inlen);

	assert(o <= content_len);
	assert(inlen == content_len);

	if(*outlen < 0) {
		retval = -1;
		goto exit1;
	}

	(*output)[o] = 0;
#endif

 exit1:
#ifndef HAVE_XMLOUTPUTBUFFERCREATEBUFFER
	/* work around thingy: get rid of our outbuf hack ... */
	xmlFree(outbuf);
#endif

 exit0:
	xmlBufferFree(buf);
	return retval;
}
