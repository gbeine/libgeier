/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
 *               2005,2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>

#include <geier.h>

#include "find_node.h"

/* find a node determined by an XPath expression */
int find_node(xmlDoc *doc, const char *xpathexpr, xmlNode **node)
{
	int retval = 0;
	xmlXPathContext *xpath_ctxt = NULL;
	xmlXPathObject *xpath_obj = NULL;

	xpath_ctxt = xmlXPathNewContext(doc);
	if (!xpath_ctxt) {
		retval = -1;
		goto exit0;
	}


	/* register elster-namespace with default URI,
	 * to make XPath accept files, that don't define xmlns:elster */
	xmlXPathRegisterNs
	  (xpath_ctxt, (unsigned char *) "elster",
	   (unsigned char *) "http://www.elster.de/2002/XMLSchema");

	/* copy namespace declarations from 'doc' to the xpath_ctxt */
	xmlNode *root = doc->children;
	if (!root) {
		retval = -1;
		goto exit1;
	}

	xmlNs *ns = root->nsDef;
	if(ns) do
		xmlXPathRegisterNs(xpath_ctxt, ns->prefix, ns->href);
	while((ns = ns->next));


	/* finally evaluate the xpath expression ... */
	xpath_obj = xmlXPathEvalExpression((unsigned char *) xpathexpr,
					   xpath_ctxt);
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
