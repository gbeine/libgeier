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

#include <libxml/xpath.h>
#include <libxml/parser.h>
#include <libxml/xpathInternals.h>
#include <libxml/tree.h>

#include "context.h"

#include <geier.h>

static int encrypt_at_xpathexpr(geier_context *context,
				const unsigned char *xpathexpr,
				xmlDoc *copy);

#define INDENT_LEVEL 4
#define ALLOW_FORMAT 0


int geier_encrypt(geier_context *context,
		  const xmlDoc *input, xmlDoc **output)
{
	int retval = 0;
	xmlDoc *copy = NULL;
	int i = 0;

	if (!context || context->iv || !input || !output) {
		retval = -1;
		goto exit0;
	}
	copy = xmlCopyDoc((xmlDoc *)input, 1);
	if (!copy) {
		retval = -1;
		goto exit1;
	}
	for (i=0; context->encrypt_xpathexprs[i]; i++) {
		if (context->encrypt_ivs) {
			context->iv = context->encrypt_ivs[i];
		}
		retval = encrypt_at_xpathexpr(context,
					      context->encrypt_xpathexprs[i],
					      copy);
		context->iv = NULL;
		if (retval) { goto exit2; }
	}

	/* publish the encrypted document */
	*output = copy;

 exit2:
	if (retval) { xmlFreeDoc(copy); }
 exit1:
 exit0:
	return retval;
}

/* destructively encrypt the content of the element at xpathexpr */
static int encrypt_at_xpathexpr(geier_context *context,
				const unsigned char *xpathexpr,
				xmlDoc *doc)
{
	int retval = 0;
	xmlXPathContext *xpath_ctxt = NULL;
	xmlXPathObject *xpath_obj = NULL;
	xmlNode *node = NULL;
	xmlBuffer *buf = NULL;
	unsigned char *content = NULL;
	size_t content_len = 0;
	unsigned char *gzipped = NULL;
	size_t gzipped_len = 0;
	unsigned char *encrypted = NULL;
	size_t encrypted_len = 0;
	unsigned char *base64 = NULL;
	size_t base64_len = 0;

	xpath_ctxt = xmlXPathNewContext(doc);
	if (!xpath_ctxt) {
		retval = -1;
		goto exit0;
	}
	xpath_obj = xmlXPathEvalExpression(xpathexpr, xpath_ctxt);
	if (!xpath_obj) {
		retval = -1;
		goto exit1;
	}
	/* check for single node */
	if (xpath_obj->nodesetval->nodeNr != 1) {
		retval = -1;
		goto exit2;
	}
	/* extract it */
	node = xpath_obj->nodesetval->nodeTab[0];
	if (!node) {
		retval = -1;
		goto exit3;
	}
	
	/* convert contents of selected node to text */
	buf = xmlBufferCreate();
	content_len = xmlNodeDump(buf, doc, node, INDENT_LEVEL, ALLOW_FORMAT);
	if (content_len < 0) {
		retval = -1;
		goto exit4;
	}
	content = xmlBufferContent(buf);
	
	/* gzip it */
	retval = geier_gzip_deflate(content, content_len,
				    &gzipped, &gzipped_len);
	if (retval) { goto exit5; }
	
	/* encrypt it */
	retval = geier_pkcs7_encrypt(context,
				     gzipped, gzipped_len,
				     &encrypted, &encrypted_len);
	if (retval) { goto exit6; }

	/* convert it to base64 */
	retval = geier_base64_encode(encrypted, encrypted_len,
				     &base64, &base64_len);
	if (retval) { goto exit7; }

	/* replace content */
	xmlNodeSetContentLen(node, base64, base64_len);

	/* clean up */
	free(base64);
 exit7:
	free(encrypted);
 exit6:
	free(gzipped);
 exit5:
 exit4:
	xmlBufferFree(buf);
 exit3:
	xmlFreeNode(node);
 exit2:
	xmlXPathFreeObject(xpath_obj);
 exit1:
	xmlXPathFreeContext(xpath_ctxt);
 exit0:
	return retval;
}
