/*
 * Copyright (C) 2005  Stefan Siegl <ssiegl@gmx.de>, Germany
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
#include <config.h>
#endif

#include <geier.h>
#include "context.h"

#include <libxml/tree.h>

#include <libxslt/xslt.h>
#include <libxslt/transform.h>
#include <libxslt/xsltutils.h>

int geier_xsltify(geier_context *context,
		  const xmlDoc *input, xmlDoc **output)
{
	int retval = 0;
	/* xmlDoc *copy; */
	xmlBuffer *buf = xmlBufferCreate();
	xsltStylesheet *stylesheet;

	/* FIXME, the path of the stylesheet actually depends on the
	 * type of the xml document's declaration, however let's use
	 * UStVA 2005 as a default for now ... */
	xmlBufferCCat(buf, context->stylesheet_dir_url);
	xmlBufferCCat(buf, "/");
	xmlBufferCCat(buf, "ustva.xsl");

	xmlSubstituteEntitiesDefault(2);
        xmlLoadExtDtdDefaultValue = 1;
        
	stylesheet = xsltParseStylesheetFile(xmlBufferContent(buf));
	if(! stylesheet) {
		retval = -1;
		goto out;
	}

	/* copy = xmlCopyDoc((xmlDocPtr)input, 1);
	 * if(! copy) {
	 *	retval = -1;
	 *      goto out1;
	 * }
	 */

	*output = xsltApplyStylesheet(stylesheet, (xmlDocPtr) input, NULL);
	if(! *output) {
		retval = -1;
		goto out2;
	}

 out2:
	xsltFreeStylesheet(stylesheet);

/* out1: */
	/* xmlFreeDoc(copy); */

 out:
	xmlBufferFree(buf);
	return retval;
}



int geier_xsltify_text(geier_context *context,
		       const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen)
{
	int retval;
	xmlDoc *indoc;
	xmlDoc *outdoc;

	if((retval = geier_text_to_xml(context, input, inlen, &indoc)))
		goto out0;

	if((retval = geier_xsltify(context, indoc, &outdoc)))
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
