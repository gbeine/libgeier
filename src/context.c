/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
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

#include <geier.h>

#include "config.h"

#include <stdlib.h>
#include <string.h>

#include "context.h"

static unsigned char *elster_xml_encoding = "UTF-8";

static unsigned char *elster_clearing_uri_list[] = {
	"http://80.146.179.2:80/Elster2/EMS",
  	"http://80.146.179.3:80/Elster2/EMS",
  	"http://193.109.238.58:80/Elster2/EMS",
  	"http://193.109.238.59:80/Elster2/EMS",
};

/* XPath expression for the nodes whose content shall be encrypted
 * and/or decrypted. 
 * Note that only the content is encrypted, the enclosing element
 * must be preserved.
 */
static unsigned char *elster_datenlieferant_xpathexpr =
"/elster:Elster/elster:TransferHeader/elster:DatenLieferant";
static unsigned char *elster_datenteil_xpathexpr =
"/elster:Elster/elster:DatenTeil";
static unsigned char *elster_transportschluessel_xpathexpr =
"/elster:Elster/elster:TransferHeader/elster:Datei/elster:TransportSchluessel";

/* XPath expression for length of encrypted data part */
static unsigned char *elster_datengroesse_xpathexpr =
"/elster:Elster/elster:TransferHeader/elster:Datei/elster:DatenGroesse";

/* XPath expression pointing to the parent node, where to add the signature */
static unsigned char *elster_add_signature_xpathexpr = 
"/elster:Elster/elster:DatenTeil/elster:Nutzdatenblock/elster:NutzdatenHeader/elster:Empfaenger";

/* XPath expression for extraction of return code */
static unsigned char *elster_transferheader_rc_code_xpathexpr =
	"/elster:Elster/elster:TransferHeader/elster:RC/elster:Rueckgabe/"
	"elster:Code";
static unsigned char *elster_transferheader_rc_text_xpathexpr =
	"/elster:Elster/elster:TransferHeader/elster:RC/elster:Rueckgabe/"
	"elster:Text";
static unsigned char *elster_datenteil_rc_code_xpathexpr =
	"/elster:Elster/elster:DatenTeil/elster:Nutzdatenblock/"
	"elster:NutzdatenHeader/elster:RC/elster:Rueckgabe/elster:Code";
static unsigned char *elster_datenteil_rc_text_xpathexpr =
	"/elster:Elster/elster:DatenTeil/elster:Nutzdatenblock/"
	"elster:NutzdatenHeader/elster:RC/elster:Rueckgabe/elster:Text";

geier_context *geier_context_new(void)
{
	geier_context *context = malloc(sizeof(struct _geier_context));
	if(! context) return NULL; /* out of memory */

	context->xml_encoding = elster_xml_encoding;

	context->clearing_uri_list = elster_clearing_uri_list;
	context->clearing_uri_list_length = sizeof(elster_clearing_uri_list) /
		sizeof(*elster_clearing_uri_list);
	context->clearing_uri_index =
		rand() % context->clearing_uri_list_length;

	context->cert_filename = DEFAULT_CERT_FILE;
	context->xmlsec_tpl_filename = DEFAULT_XMLSEC_TEMPLATE;

	context->clearing_timeout_ms = DEFAULT_CLEARING_TIMEOUT;
	context->schema_dir_url = DEFAULT_SCHEMA_DIR_URL;
	context->stylesheet_dir_url = DEFAULT_STYLESHEET_DIR_URL;

	context->datenlieferant_xpathexpr = elster_datenlieferant_xpathexpr;
	context->datenteil_xpathexpr = elster_datenteil_xpathexpr;
	context->datengroesse_xpathexpr = elster_datengroesse_xpathexpr;
	context->add_signature_xpathexpr = elster_add_signature_xpathexpr;
	context->transportschluessel_xpathexpr = 
		elster_transportschluessel_xpathexpr;

	context->transferheader_rc_code_xpathexpr = 
		elster_transferheader_rc_code_xpathexpr;
	context->transferheader_rc_text_xpathexpr =
		elster_transferheader_rc_text_xpathexpr;
	context->datenteil_rc_code_xpathexpr =
		elster_datenteil_rc_code_xpathexpr;
	context->datenteil_rc_text_xpathexpr =
		elster_datenteil_rc_text_xpathexpr;

	context->session_key = NULL;
	context->session_key_len = 0;
	context->iv = NULL;

	return context;
};

void geier_context_free(geier_context *context)
{
	if (context->session_key) {
		/* wipe key first */
		memset(context->session_key, 0, context->session_key_len);
		free(context->session_key);
	}
	if (context->iv) {
		free(context->iv);
	}
	free(context);
}
