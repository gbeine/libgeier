/*
 * Copyright (C) 2005,2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <string.h>

#include <libxml/tree.h>

#include <geier.h>
#include "xpath.h"
#include "find_node.h"
#include "node_contents_to_text.h"

/* Return the content of the node referenced by the given xpath expression.
 * Mind that a new allocated \0-string will be allocated in case of success
 * and that you're responsible for freeing it */
char *elster_xpath_get_content(geier_context *context,
			       xmlDoc *doc, const char *xpath) {
	xmlNode *node;
	if(find_node(doc, xpath, &node)) return NULL; /* not found */

	unsigned char *content;
	size_t content_len;
	if(geier_node_contents_to_text(context, doc, node,
				       &content, &content_len))
		return NULL; /* failed. */

	content = realloc(content, content_len + 1);
	if(! content) return NULL;

	content[content_len] = 0; /* zero terminate string */
	return content;
}



/* Return the text, associated to the attribute 'attrname' of the
 * node, referenced by the supplied xpath expression. 
 */
const char *elster_xpath_get_attr(geier_context *context,
				  xmlDoc *doc, const char *xpath,
				  const char *attrname)
{
	xmlNode *node;
	if(find_node(doc, xpath, &node)) return NULL; /* not found */

	xmlAttr *attr = node->properties;
	if(attr) do
		if(! strcmp(attr->name, attrname)) {
			/* got the attr we'd like to have ... */
			if(attr->children->type != XML_TEXT_NODE)
				return NULL; /* not supported */
			return attr->children->content;
		}
	while((attr = attr->next));

	return NULL;
}
