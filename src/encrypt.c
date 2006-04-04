/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
 *               2005,2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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
#include "gzip_deflate.h"

#include <geier.h>

#include "pkcs7_encrypt.h"

static int encrypt_at_xpathexpr(geier_context *context,
				const unsigned char *xpathexpr,
				xmlDoc *doc,
				size_t *content_len);
static int store_length_at_xpathexpr(
	geier_context *context,
	const unsigned char *xpathexpr,
	xmlDoc *doc,
	size_t content_len);
static int encrypt_content(geier_context *context,
			   xmlDoc *doc, xmlNode *node,
			   xmlNode **new_node, size_t *new_content_len);

int geier_encrypt(geier_context *context,
		  const xmlDoc *input, xmlDoc **output)
{
	int retval = 0;
	xmlDoc *copy = NULL;
	size_t content_len;

	if (!context || !input || !output) {
		retval = -1;
		goto exit0;
	}
	copy = xmlCopyDoc((xmlDoc *)input, 1);
	if (!copy) {
		retval = -1;
		goto exit1;
	}

	/* Encrypt fields */
	retval = encrypt_at_xpathexpr(context,
				      context->datenlieferant_xpathexpr,
				      copy,
				      &content_len);
	if (retval) { goto exit2; }
	retval = encrypt_at_xpathexpr(context,
				      context->datenteil_xpathexpr,
				      copy,
				      &content_len);
	if (retval) { goto exit3; }

	/* Store length */
	retval = store_length_at_xpathexpr(context,
					   context->datengroesse_xpathexpr,
					   copy,
					   content_len);
	if (retval) { goto exit4; }

	/* publish the encrypted document */
	*output = copy;

 exit4:
 exit3:
 exit2:
	if (retval) { xmlFreeDoc(copy); }
 exit1:
 exit0:
	return retval;
}


int geier_encrypt_text(geier_context *context,
                       const unsigned char *input, size_t inlen,
                       unsigned char **output, size_t *outlen)
{
	int retval;
	xmlDoc *indoc;
	xmlDoc *outdoc;

	if((retval = geier_text_to_xml(context, input, inlen, &indoc)))
		goto out0;

	if((retval = geier_encrypt(context, indoc, &outdoc)))
		goto out1;

	if((retval = geier_xml_to_text(context, outdoc, output, outlen)))
		goto out2;

 out2:
	xmlFreeDoc(outdoc);
 out1:
	xmlFreeDoc(indoc);
 out0:
	return retval;
}


/* destructively encrypt the content of the element at xpathexpr */
static int encrypt_at_xpathexpr(geier_context *context,
				const unsigned char *xpathexpr,
				xmlDoc *doc,
				size_t *content_len)
{
	int retval = 0;
	xmlNode *node = NULL;
	xmlNode *new_node = NULL;

	retval = find_node(doc, xpathexpr, &node);
	if (retval) { goto exit0; }

	/* create new node with encrypted content */
	retval = encrypt_content(context, doc, node, &new_node, content_len);
	if (retval) { goto exit1; }
	
	/* replace it */
	xmlReplaceNode(node, new_node);

	/* clean up */
	xmlFreeNode(node);
 exit1:
 exit0:
	return retval;
}


static int store_length_at_xpathexpr(geier_context *context,
				     const unsigned char *xpathexpr,
				     xmlDoc *doc,
				     size_t content_len)
{
	int retval = 0;
	xmlNode *node = NULL;
	xmlNode *new_node = NULL;
	unsigned char text[32];
	xmlNode *text_node = NULL;

	sprintf(text, "%d", (int)content_len);

	retval = find_node(doc, xpathexpr, &node);
	if (retval) { goto exit0; }

	/* create new node with length as content */
	new_node = xmlNewNode(node->ns, node->name);
	text_node = xmlNewText(text);
	xmlAddChild(new_node, text_node);

	/* replace it */
	xmlReplaceNode(node, new_node);

	/* clean up */
	xmlFreeNode(node);
 exit0:
	return retval;
}

static int encrypt_content(geier_context *context,
			   xmlDoc *doc, xmlNode *node,
			   xmlNode **new_node, size_t *new_content_len)
{
	int retval = 0;
	unsigned char *content = NULL;
	size_t content_len = 0;
	unsigned char *gzipped = NULL;
	size_t gzipped_len = 0;
	unsigned char *encrypted = NULL;
	size_t encrypted_len = 0;
	unsigned char *base64 = NULL;
	size_t base64_len = 0;
	xmlNode *text_node = NULL;

	/* convert contents of selected node to text */
	retval = geier_node_contents_to_text(context, doc, node,
					     &content, &content_len);
	if (retval) { goto exit0; }

	/* gzip it */
	retval = geier_gzip_deflate(content, content_len,
				    &gzipped, &gzipped_len);
	if (retval) { goto exit1; }
	
	/* encrypt it */
	retval = geier_pkcs7_encrypt(context,
				     gzipped, gzipped_len,
				     &encrypted, &encrypted_len);
	if (retval) { goto exit2; }

	/* convert it to base64 */
	retval = geier_base64_encode(encrypted, encrypted_len,
				     &base64, &base64_len);
	if (retval) { goto exit3; }
	*new_content_len = base64_len;

	/* build new node */
	text_node = xmlNewTextLen(base64, base64_len);
	*new_node = xmlNewNode(node->ns, node->name);
	xmlAddChild(*new_node, text_node);

	free(base64);
 exit3:
	free(encrypted);
 exit2:
	free(gzipped);
 exit1:
	free(content);
 exit0:
	return retval;
}
