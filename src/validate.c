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
#include <libxml/parser.h>
#include <libxml/xmlschemas.h>

#include "context.h"

#include <geier.h>

/* FIXME: make configurable */
/* FIXME: depends on type of declaration, year */

/* #define GEIER_SCHEMA_UNENCRYPTED  "http://80.146.179.2/elo/xml/schemata/elster_UStA_200501_extern.xsd"*/
#define GEIER_SCHEMA_UNENCRYPTED "file:///home/juergen/Elster/taxbird-cvs/taxbird/libgeier/etc/schemas/new/elster_UStA_200501_extern.xsd"

/* #define GEIER_SCHEMA_UNENCRYPTED "file:///home/juergen/Elster/taxbird-cvs/taxbird/libgeier/etc/schemas/Elster_TH7.xsd" */

static int validate(char *schema_url, const xmlDoc *doc);

int geier_validate(geier_context *context,
		   geier_format f, const xmlDoc *input)
{
	int retval = 0;
	unsigned char *schema_url = NULL;

	switch (f) {
	case geier_format_unencrypted:
		schema_url = GEIER_SCHEMA_UNENCRYPTED;
		break;
	default:
		retval = GEIER_ERROR_FORMAT;
		goto exit0;
	}

	retval = validate(schema_url, input);
	if (retval) { goto exit1; }

 exit1:
 exit0:
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
	res = xmlSchemaValidateDoc(validation_context, doc);
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
