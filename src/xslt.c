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

#include <string.h>
#include <geier.h>
#include "context.h"
#include "xpath.h"

#include <libxml/tree.h>

#include <libxslt/xslt.h>
#include <libxslt/transform.h>
#include <libxslt/xsltutils.h>


/* return the file:// URI of the XSLT Stylesheet file or NULL on error */
static char *get_xslt_path(geier_context *context, xmlDoc *doc);


int geier_xsltify(geier_context *context,
		  const xmlDoc *input, xmlDoc **output)
{
	int retval = 0;
	/* xmlDoc *copy; */
	xsltStylesheet *stylesheet;

        char *stylesheet_fname = get_xslt_path(context, (xmlDoc *) input);
	stylesheet = xsltParseStylesheetFile(stylesheet_fname);
	free(stylesheet_fname);

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


static const char *val_verfahren_xpathexpr =
"/elster:Elster/elster:TransferHeader/elster:Verfahren";
static const char *val_datenart_xpathexpr =
"/elster:Elster/elster:TransferHeader/elster:DatenArt";

/* return the file:// URI of the XSLT Stylesheet file or NULL on error */
static char *get_xslt_path(geier_context *context, xmlDoc *doc)
{
	unsigned char *retval = NULL;

	/* check whether TransferHeader->Verfahren is okay ***/
	char *val_verfahren = 
		elster_xpath_get_content(doc, val_verfahren_xpathexpr);
	if(! val_verfahren) goto out;
	if(strcmp(val_verfahren, "ElsterAnmeldung")) {
		fprintf(stderr, "libgeier: unable to xsltify doctype %s\n",
			val_verfahren);
		goto out0;
	}

	/* check whether TransferHeader->DatenArt is okay ***/
	char *val_datenart = 
		elster_xpath_get_content(doc, val_datenart_xpathexpr);
	if(! val_datenart) goto out0;
	if(strcmp(val_datenart, "UStVA") && strcmp(val_datenart, "LStA")) {
		fprintf(stderr, "libgeier: unable to xsltify doctype %s\n",
			val_datenart);
		goto out1;
	}

	xmlBuffer *buf = xmlBufferCreate();
     	if(! buf) goto out2;

	xmlBufferCCat(buf, context->stylesheet_dir_url);
	xmlBufferCCat(buf, "/");

	if(! strcmp(val_datenart, "UStVA"))
		xmlBufferCCat(buf, "ustva");
	else
		xmlBufferCCat(buf, "lsta");

	xmlBufferCCat(buf, ".xsl");
	retval = strdup(xmlBufferContent(buf));

	xmlBufferFree(buf);
 out2:
 out1:
	free(val_datenart);
 out0:
	free(val_verfahren);
 out:
	return retval;
}
