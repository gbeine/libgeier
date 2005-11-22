/*
 * Copyright (C) 2005  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#define GEIER_SIGNATURE_INTERNALS 1
#include <geier.h>
#include "context.h"

#include <string.h>
#include <assert.h>

#include "dsig.h"
#include "find_node.h"

/* 
 * replace `NoSig' in `Vorgang' by `Sig'
 */ 
int
geier_dsig_rewrite_vorgang(xmlDoc *doc)
{
	const char *xpathexpr = 
		"/elster:Elster/elster:TransferHeader/elster:Vorgang";
	xmlNode *node;

	if(find_node(doc, xpathexpr, &node))
		return 1;

	assert(node->type == XML_ELEMENT_NODE);
	assert(node->children->type == XML_TEXT_NODE);

	char *ptr;
	if((ptr = strstr(node->children->content, "NoSig")))
		memmove(ptr, ptr + 2, strlen(ptr + 2) + 1);

	return 0;

}
