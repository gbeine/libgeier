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

#include <geier.h>
#include "context.h"

#include <assert.h>
#include <string.h>
#include <stdio.h>

#include <libxml/tree.h>
#include <libxml/parser.h>

#include "find_node.h"
#include "dsig.h"



int
geier_dsig_sign(geier_context *context,
		const xmlDoc *input, xmlDoc **output,
		const char *softpse, const char *pincode)
{
	int retval = -1;

	assert(context);
	assert(input);
	assert(output);
	assert(softpse);
	assert(pincode);

	*output = xmlCopyDoc((xmlDoc *) input, 1);
	if(! *output) return -1; /* pre-fail */

	if(geier_dsig_rewrite_datenlieferant(*output)) goto out;
	if(geier_dsig_rewrite_vorgang(*output)) goto out;
	
	retval = geier_dsig_sign_doit(context, output, softpse, pincode);
			
out:
	if(retval) xmlFreeDoc(*output);
	return retval;
}



int geier_dsig_sign_text(geier_context *context,
			 const unsigned char *input, size_t inlen,
			 unsigned char **output, size_t *outlen,
			 const char *pse, const char *pincode)
{
	int retval;
	xmlDoc *indoc;
	xmlDoc *outdoc;

	if((retval = geier_text_to_xml(context, input, inlen, &indoc)))
		goto out0;

	if((retval = geier_dsig_sign(context, indoc, &outdoc, pse, pincode)))
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
