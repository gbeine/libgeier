/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
 * Copyright (C) 2005,2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#include <libxml/tree.h>
#include <string.h>
#include <unistd.h>

#include "context.h"
#include "find_node.h"
#include "node_contents_to_text.h"
#include "base64.h"
#include "gzip_inflate.h"

#include <geier.h>

#include "pkcs7_decrypt.h"
#include "iso_to_utf8.h"
#include "globals.h"


/*
 * XPath expression for the nodes whose content shall be encrypted
 * and/or decrypted. 
 * Note that only the content is encrypted, the enclosing element
 * must be preserved.
 */
static char *datenlieferant_xpathexpr =
	"/elster:Elster/elster:TransferHeader/elster:DatenLieferant";
static char *datenteil_xpathexpr =
	"/elster:Elster/elster:DatenTeil";
static char *transportschluessel_xpathexpr =
	"/elster:Elster/elster:TransferHeader/elster:Datei/"
	"elster:TransportSchluessel";


static int decrypt_at_xpathexpr(geier_context *context, const char *xpathexpr,
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
	retval = decrypt_at_xpathexpr(context, datenlieferant_xpathexpr, copy);
	if (retval) { goto exit2; }
	retval = decrypt_at_xpathexpr(context, datenteil_xpathexpr, copy);
	if (retval) { goto exit3; }
	retval = decrypt_at_xpathexpr(context, transportschluessel_xpathexpr,
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


int geier_decrypt_text(geier_context *context,
		       const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen)
{
	int retval;
	xmlDoc *indoc;
	xmlDoc *outdoc;

	if((retval = geier_text_to_xml(context, input, inlen, &indoc)))
		goto out0;

	if((retval = geier_decrypt(context, indoc, &outdoc)))
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


/* destructively decrypt the content of the element at xpathexpr */
static int decrypt_at_xpathexpr(geier_context *context, const char *xpathexpr,
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
	unsigned char *encrypted = NULL;
	size_t encrypted_len = 0;
	unsigned char *decrypted = NULL;
	size_t decrypted_len = 0;
	unsigned char *inflated = NULL;
	size_t inflated_len = 0;
	unsigned char *utf8ified = NULL;
	size_t utf8ified_len = 0;
	xmlNode *node_list = NULL;
	int result = 0;
	xmlNode *new = NULL;

	/* convert contents of selected node to text */
	retval = geier_node_contents_to_text(context, doc, node,
					     &content, &content_len);
	if (retval) { goto exit0; }
	if (content_len == 0) goto exit0; /* success */

	if (geier_debug) {
		fprintf(stderr, PACKAGE_NAME ": decrypt_content: ==========\n");
		write(1, content, content_len);
		fprintf(stderr, "==========================================\n");
	}

	/* convert base64 to gzip */
	retval = geier_base64_decode(content, content_len,
				     &encrypted, &encrypted_len);
	if (retval) { goto exit1; }

	/* decrypt it */
	retval = geier_pkcs7_decrypt(context,
				     encrypted, encrypted_len,
				     &decrypted, &decrypted_len);
	if (retval) { goto exit2; }
	
	/* ungzip it */
	retval = geier_gzip_inflate(decrypted, decrypted_len,
				    &inflated, &inflated_len);
	if (retval) { goto exit3; }

	/* convert it to utf-8 encoding */
	if(inflated)
		retval = geier_iso_to_utf8(inflated, inflated_len,
					   &utf8ified, &utf8ified_len);
	if (retval) { goto exit3b; }

	/* parse and build new node */
	new = xmlNewNode(node->ns, node->name);
	if(utf8ified_len > 0) {
		/* we need to declare another charset, 
		 * xmlParseBalancedChunkMemory assumes the input to be 
		 * encoded with UTF-8.  However we cannot just prepend an 
		 * <?xml ?> charset declarator, since this one is only 
		 * allowed at the begining of a document and 
		 * xmlParseBalancedChunkMemory cowardly refuses to accept
		 * it.
		 */
		/* char *prepend = 
		 *         "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>";
		 */

		utf8ified = realloc(utf8ified, utf8ified_len + 1);
		if(! utf8ified) {
			perror(PACKAGE_NAME);
			retval = -1;
			goto exit4;
		}

		utf8ified[utf8ified_len] = 0; /* zero trminate string for
					       * xmlParseBalancedChunkMemory */

		result = xmlParseBalancedChunkMemory(doc, NULL, NULL, 0,
						     utf8ified, &node_list);
		if (result) {
			retval = -1;
			goto exit4;
		}
		xmlAddChildList(new, node_list);
	}

	/* publish the new node */
	*new_node = new;

 exit4:
	if (retval) { xmlFreeNode(new); }
	free(utf8ified);
 exit3b:
	free(inflated);
 exit3:
	free(decrypted);
 exit2:
	free(encrypted);
 exit1:
	free(content);
 exit0:
	return retval;
}
