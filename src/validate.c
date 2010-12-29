/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
 *               2005,2006,2008  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#include <stdio.h>
#include <string.h>

#include <libxml/tree.h>
#include <libxml/parser.h>
#include <libxml/xmlschemas.h>

#include "context.h"
#include "xpath.h"

#include <geier.h>

static int validate(char *schema_url, const xmlDoc *doc);

/* return the file:// URI of the XML Schema file, needed to validate
 * the provided document doc, NULL on error */
static char *get_xsd_path(geier_context *context, xmlDoc *doc);



int geier_validate_text(geier_context *context, geier_format f,
                        const unsigned char *input, size_t inlen)
{
	int retval;
	xmlDoc *indoc;

	if((retval = geier_text_to_xml(context, input, inlen, &indoc)))
		goto out0;

	retval = geier_validate(context, f, indoc);
	xmlFreeDoc(indoc);

 out0:
	return retval;

}



int geier_validate(geier_context *context,
		   geier_format f, const xmlDoc *input)
{
	int retval = 0;
	char *schema_url = NULL;

	switch (f) {
	case geier_format_unencrypted:
		schema_url = get_xsd_path(context, (xmlDoc *) input);
		break;
	default:
		retval = GEIER_ERROR_FORMAT;
		goto exit0;
	}

	retval = validate(schema_url, input);
	if (retval) { goto exit1; }

 exit1:
 exit0:
	free(schema_url);
	return retval;
}


/* validate doc against schema */
static int validate(char *schema_url, const xmlDoc *doc)
{
	int retval = 0;
	xmlSchemaParserCtxtPtr parser_context = NULL;
	xmlSchemaPtr schema = NULL;
	xmlSchemaValidCtxtPtr validation_context = NULL;
	int res = 0;
	
	/* load schema */
	parser_context = xmlSchemaNewParserCtxt(schema_url);
	if (!parser_context) {
		retval = GEIER_ERROR_NEW_PARSER_CTXT;
		goto exit0;
	}
	schema = xmlSchemaParse(parser_context);
	if (!schema) {
		retval = GEIER_ERROR_SCHEMA_PARSE;
		goto exit1;
	}
	validation_context = xmlSchemaNewValidCtxt(schema);
	if (!validation_context) {
		retval = GEIER_ERROR_NEW_VALID_CTXT;
		goto exit2;
	}
	
	/* validate */
	res = xmlSchemaValidateDoc(validation_context, (xmlDoc *)doc);
	if (res) {
		fprintf(stderr, "schema validation failed with return code %d\n", res);
		retval = GEIER_ERROR_SCHEMA_VALIDATE_DOC;
		goto exit3;
	}

 exit3:
	xmlSchemaFreeValidCtxt(validation_context);
 exit2:
	xmlSchemaFree(schema);
 exit1:
	xmlSchemaFreeParserCtxt(parser_context);
 exit0:
	return retval;
}


static const char *val_th_xpathexpr =
"/elster:Elster/elster:TransferHeader";
static const char *val_verfahren_xpathexpr =
"/elster:Elster/elster:TransferHeader/elster:Verfahren";
static const char *val_datenart_xpathexpr =
"/elster:Elster/elster:TransferHeader/elster:DatenArt";

static const char *val_nh_xpathexpr =
"/elster:Elster/elster:DatenTeil/elster:Nutzdatenblock/elster:NutzdatenHeader";
static const char *val_anmeldungssteuern_xpathexpr = 
"/elster:Elster/elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten"
"/elster:Anmeldungssteuern";


/* Return the version specified in the TransferHeader tag,
   -1 if extraction is not possible. */
static int validate_get_th_version(geier_context *context, xmlDoc *doc)
{
	const char *val_vers =
		elster_xpath_get_attr(context, doc, val_th_xpathexpr,
				      "version");
	if(! val_vers) return -1;

	return atoi(val_vers);
}


/* Return the version specified in the NutzdatenHeader tag,
   -1 if extraction is not possible. */
static int validate_get_nh_version(geier_context *context, xmlDoc *doc)
{
	const char *val_vers =
		elster_xpath_get_attr(context, doc, val_nh_xpathexpr,
				      "version");
	if(! val_vers) return -1;

	return atoi(val_vers);
}


static char *validate_elsteranmeldung(geier_context *context, xmlDoc *doc)
{
	char *retval = NULL;

	/* check whether TransferHeader->DatenArt is okay ***/
	char *val_datenart = 
		elster_xpath_get_content(context, doc, val_datenart_xpathexpr);
	if(! val_datenart) goto out0;

	if(strcmp(val_datenart, "UStVA") && strcmp(val_datenart, "LStA")) {
		fprintf(stderr, "libgeier: unable to validate doctype %s\n",
			val_datenart);
		goto out1;
	}

	const char *val_vers =
		elster_xpath_get_attr(context, doc,
				      val_anmeldungssteuern_xpathexpr,
				      "version");
	if(! val_vers) goto out1;

	xmlBuffer *buf = xmlBufferCreate();
     	if(! buf) goto out2;

	xmlBufferCCat(buf, context->schema_dir_url);

	int th_version = validate_get_th_version(context, doc);
	int nh_version = validate_get_nh_version(context, doc);

	if(th_version == 8 && nh_version == 10)
		xmlBufferCCat(buf, "/elster0810_");

	else {
		fprintf(stderr, "libgeier: invalid combination of "
			"TransferHeader(%d) and NutzdatenHeader(%d).\n",
			th_version, nh_version);
		goto out3;
	}

	if(! strcmp(val_datenart, "UStVA"))
		xmlBufferCCat(buf, "UStA");
	else
		xmlBufferCCat(buf, val_datenart);

	xmlBufferCCat(buf, "_");
	xmlBufferCCat(buf, val_vers);
	xmlBufferCCat(buf, "_extern.xsd");
	retval = strdup((char *) xmlBufferContent(buf));

out3:
	xmlBufferFree(buf);

out2:
out1:
	free(val_datenart);
out0:
	return retval;
}


static char *validate_elsterkontoabfrage(geier_context *context, xmlDoc *doc)
{
	char *retval = NULL;

	/* check whether TransferHeader->DatenArt is okay ***/
	char *val_datenart = 
		elster_xpath_get_content(context, doc, val_datenart_xpathexpr);
	if(! val_datenart) goto out0;

	xmlBuffer *buf = xmlBufferCreate();
     	if(! buf) goto out1;

	xmlBufferCCat(buf, context->schema_dir_url);
	xmlBufferCCat(buf, "/");

	if(! strcmp(val_datenart, "Registrierung"))
		xmlBufferCCat(buf, "registrierung");
	else if(! strcmp(val_datenart, "Kontoabfrage"))
		xmlBufferCCat(buf, "kontoabfrage");
	else {
		fprintf(stderr, "libgeier: unable to validate doctype %s\n",
			val_datenart);
		goto out2;
	}

	xmlBufferCCat(buf, "_rootish.xsd");

	retval = strdup((char *) xmlBufferContent(buf));

out2:
	xmlBufferFree(buf);
out1:
	free(val_datenart);
out0:
	return retval;
}



/* return the file:// URI of the XML Schema file, needed to validate
 * the provided document doc, NULL on error */
static char *get_xsd_path(geier_context *context, xmlDoc *doc) {
	char *retval = NULL;

	/* check whether TransferHeader->Verfahren is okay ***/
	char *val_verfahren = 
		elster_xpath_get_content(context, doc,
					 val_verfahren_xpathexpr);
	if(! val_verfahren) goto out;

	if(! strcmp(val_verfahren, "ElsterAnmeldung")) {
		retval = validate_elsteranmeldung(context, doc);
	}
	else if(! strcmp(val_verfahren, "ElsterKontoabfrage")) {
		retval = validate_elsterkontoabfrage(context, doc);
	}
	else {
		fprintf(stderr, "libgeier: unable to validate doctype %s\n",
			val_verfahren);
		goto out0;
	}

 out0:
	free(val_verfahren);
 out:
	return retval;
}
