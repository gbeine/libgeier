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

#include <libxml/tree.h>

#include "context.h"
#include "find_node.h"
#include "node_contents_to_text.h"
#include "base64.h"
#include "gzip_inflate.h"

#include <geier.h>

#include "pkcs7_decrypt.h"

static int decrypt_at_xpathexpr(geier_context *context,
				const unsigned char *xpathexpr,
				xmlDoc *doc);
static int decrypt_content(geier_context *context,
			   xmlDoc *doc, xmlNode *node,
			   xmlNode **new_node);

#define INDENT_LEVEL 4
#define ALLOW_FORMAT 0


int geier_decrypt(geier_context *context,
		  const xmlDoc *input, xmlDoc **output)
{
	int retval = 0;
	xmlDoc *copy = NULL;

	if (!context || !input || !output) {
		retval = -1;
		goto exit0;
	}
	copy = xmlCopyDoc((xmlDoc *)input, 1);
	if (!copy) {
		retval = -1;
		goto exit1;
	}

	/* Decrypt fields */
	retval = decrypt_at_xpathexpr(context,
				      context->datenlieferant_xpathexpr,
				      copy);
	if (retval) { goto exit2; }
	retval = decrypt_at_xpathexpr(context,
				      context->datenteil_xpathexpr,
				      copy);
	if (retval) { goto exit3; }
	retval = decrypt_at_xpathexpr(context,
				      context->transportschluessel_xpathexpr,
				      copy);
	if (retval) { goto exit4; }

	/* publish the decrypted document */
	*output = copy;

 exit4:
 exit3:
 exit2:
	if (retval) { xmlFreeDoc(copy); }
 exit1:
 exit0:
	return retval;
}

/* destructively decrypt the content of the element at xpathexpr */
static int decrypt_at_xpathexpr(geier_context *context,
				const unsigned char *xpathexpr,
				xmlDoc *doc)
{
	int retval = 0;
	xmlNode *node = NULL;
	xmlNode *new_node = NULL;

	retval = find_node(doc, xpathexpr, &node);
	if (retval) { goto exit0; }

	/* create new node with decrypted content */
	retval = decrypt_content(context, doc, node, &new_node);
	if (retval) { goto exit1; }
	
	/* replace it */
	xmlReplaceNode(node, new_node);

	/* clean up */
	xmlFreeNode(node);
 exit1:
 exit0:
	return retval;
}


static int decrypt_content(geier_context *context,
			   xmlDoc *doc, xmlNode *node,
			   xmlNode **new_node)
{
	int retval = 0;
	unsigned char *content = NULL;
	size_t content_len = 0;
	unsigned char *gzipped = NULL;
	size_t gzipped_len = 0;
	unsigned char *encrypted = NULL;
	size_t encrypted_len = 0;
	unsigned char *decrypted = NULL;
	size_t decrypted_len = 0;
	xmlNode *text_node = NULL;

	/* convert contents of selected node to text */
	retval = geier_node_contents_to_text(doc, node,
					     &content, &content_len);
	if (retval) { goto exit0; }

	/* convert base64 to gzip */
	retval = geier_base64_decode(content, content_len,
				     &gzipped, &gzipped_len);
	if (retval) { goto exit1; }

	/* ungzip it */
	retval = geier_gzip_inflate(gzipped, gzipped_len,
				    &encrypted, &encrypted_len);
	if (retval) { goto exit2; }
	
	/* decrypt it */
	retval = geier_pkcs7_decrypt(context,
				     encrypted, encrypted_len,
				     &decrypted, &decrypted_len);
	if (retval) { goto exit3; }

	/* build new node */
	/* FIXME: we need to parse it! */
	*new_node = xmlNewNode(node->ns, node->name);
	text_node = xmlNewTextLen(decrypted, decrypted_len);
	xmlAddChild(*new_node, text_node);

	free(decrypted);
 exit3:
	free(encrypted);
 exit2:
	free(gzipped);
 exit1:
	free(content);
 exit0:
	return retval;
}
