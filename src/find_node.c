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
#include <libxml/xpath.h>

#include <geier.h>

#include "find_node.h"

/* find a node determined by an XPath expression */
int find_node(xmlDoc *doc,
	      const unsigned char *xpathexpr,
	      xmlNode **node)
{
	int retval = 0;
	xmlXPathContext *xpath_ctxt = NULL;
	xmlXPathObject *xpath_obj = NULL;

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
	if (!xpath_obj->nodesetval) {
		retval = -1;
		goto exit2;
	}
	/* check for single node */
	if (xpath_obj->nodesetval->nodeNr != 1) {
		retval = GEIER_ERROR_FIND_NODE_NO_UNIQUE_NODE;
		goto exit3;
	}
	/* extract it */
	*node = xpath_obj->nodesetval->nodeTab[0];
	if (!*node) {
		retval = -1;
		goto exit4;
	}

 exit4:
 exit3:
 exit2:
	xmlXPathFreeObject(xpath_obj);
 exit1:
	xmlXPathFreeContext(xpath_ctxt);
 exit0:
	return retval;
}
