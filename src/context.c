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
#include <geier.h>
#include "context.h"

unsigned char *elster_clearing_uri_list[] = {
	"http://80.146.179.2:80/Elster2/EMS",
	"http://80.146.179.3:80/Elster2/EMS",
	"http://193.109.238.58:80/Elster2/EMS",
	"http://193.109.238.59:80/Elster2/EMS",
	NULL
};

/* XPath expression for the nodes whose content shall be encrypted.
 * Note that only the content is encrypted, the enclosing element
 * must be preserved.
 */
unsigned char *encrypt_xpathexprs[] = {
	"/Elster/TransferHeader/DatenLieferant",
	"/Elster/DatenTeil",
	NULL
};


geier_context *geier_context_new(void)
{
	geier_context *context = malloc(sizeof(struct _geier_context));

	context->clearing_uri_list = elster_clearing_uri_list;
	context->cert_filename = DEFAULT_CERT_FILE;
	context->encrypt_xpathexprs = encrypt_xpathexprs;

	context->session_key = NULL;
	context->encrypt_ivs = NULL;
	context->iv = NULL;

	return context;
};

void geier_context_free(geier_context *context)
{
	int i = 0;

	if (context->session_key) {
		free(context->session_key);
	}
	if (context->iv) {
		free(context->iv);
	}
	if (context->encrypt_ivs) {
		for (i=0; context->encrypt_ivs[i]; i++) {
			free(context->encrypt_ivs[i]);
		}
		free(context->encrypt_ivs);
	}
	free(context);
}
