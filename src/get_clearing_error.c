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
#include <config.h>
#endif

#include <string.h>
#include <geier.h>
#include "context.h"
#include "xpath.h"

#include <libxml/tree.h>


/* 
 * FIXME: the error message is returned in Latin-1 currently,
 * maybe make sure context->xml_encoding or something is used instead
 */ 
char *geier_get_clearing_error(geier_context *context, const xmlDoc *doc)
{
	const char *xpathexpr;
	char *code, *msg;
	
	/* check for set error status in transferheader first */
	xpathexpr = context->transferheader_rc_code_xpathexpr;
	code = elster_xpath_get_content(context, doc, xpathexpr);

	if(code && atoi(code)) {
		/* an error concerning the transferheader has occured */
		free(code);

		/* extract and return human readable error message */
		xpathexpr = context->transferheader_rc_text_xpathexpr;
		msg = elster_xpath_get_content(context, doc, xpathexpr);

		if(! msg) goto internal_error;
		return msg;
	}

	free(code);

	/* now check for set error status in data part ... */
	xpathexpr = context->datenteil_rc_code_xpathexpr;
	code = elster_xpath_get_content(context, doc, xpathexpr);

	if(code && atoi(code)) {
		/* an error concerning the data part has occured */
		free(code);

		/* extract and return human readable error message */
		xpathexpr = context->datenteil_rc_text_xpathexpr;
		msg = elster_xpath_get_content(context, doc, xpathexpr);

		if(! msg) goto internal_error;
		return msg;
	}

	free(code);
	return NULL; /* everything is fine */

internal_error:
	msg = strdup("Sorry Dude, geier_get_clearing_error failed.");
	if(! msg)
		perror(PACKAGE_NAME);
	return msg;
}

char *geier_get_clearing_error_text(geier_context *context, 
				    const unsigned char *input, size_t inlen)
{
	char *retval;
	xmlDoc *indoc;

	if(geier_text_to_xml(context, input, inlen, &indoc))
		return NULL; /* this is actually misleading, FIXME */

	retval = geier_get_clearing_error(context, indoc);

	xmlFreeDoc(indoc);
out0:
	return retval;
}
