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

#include <geier.h>

#include "config.h"

#include <stdlib.h>
#include <string.h>

#include "context.h"

static unsigned char *elster_xml_encoding = "ISO-8859-1";

static unsigned char *elster_clearing_uri_list[] = {
	"http://80.146.179.2:80/Elster2/EMS",
	"http://80.146.179.3:80/Elster2/EMS",
	"http://193.109.238.58:80/Elster2/EMS",
	"http://193.109.238.59:80/Elster2/EMS",
	NULL
};

/* XPath expression for the nodes whose content shall be encrypted
 * and/or decrypted.
 * Note that only the content is encrypted, the enclosing element
 * must be preserved.
 * FIXME: use Elster namespace instead of local-name hack?  How?
 */
static unsigned char *elster_datenlieferant_xpathexpr =
"/*[local-name()='Elster']/*[local-name()='TransferHeader']/*[local-name()='DatenLieferant']";
static unsigned char *elster_datenteil_xpathexpr =
"/*[local-name()='Elster']/*[local-name()='DatenTeil']";
static unsigned char *elster_transportschluessel_xpathexpr =
"/*[local-name()='Elster']/*[local-name()='TransferHeader']/*[local-name()='Datei/*[local-name()='TransportSchluessel']";

/* XPath expression for length of encrypted data part */
static unsigned char *elster_datengroesse_xpathexpr =
"/*[local-name()='Elster']/*[local-name()='TransferHeader']/*[local-name()='Datei']/*[local-name()='DatenGroesse']";

geier_context *geier_context_new(void)
{
	geier_context *context = malloc(sizeof(struct _geier_context));

	context->xml_encoding = elster_xml_encoding;
	context->clearing_uri_list = elster_clearing_uri_list;
	{
		int i;
		for (i=0; context->clearing_uri_list[i]; i++) {
		}
		context->clearing_uri_list_length = i;
	}
	context->cert_filename = DEFAULT_CERT_FILE;
	context->clearing_timeout_ms = DEFAULT_CLEARING_TIMEOUT;
	context->schema_dir_url = DEFAULT_SCHEMA_DIR_URL;

	context->datenlieferant_xpathexpr = elster_datenlieferant_xpathexpr;
	context->datenteil_xpathexpr = elster_datenteil_xpathexpr;
	context->datengroesse_xpathexpr = elster_datengroesse_xpathexpr;
	context->transportschluessel_xpathexpr = elster_transportschluessel_xpathexpr;

	context->clearing_uri_index = rand() % context->clearing_uri_list_length;
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
