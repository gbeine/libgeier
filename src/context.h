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

#ifndef CONTEXT_H
#define CONTEXT_H

struct _geier_context {
	/* configuration */
	unsigned char *xml_encoding; /* the encoding to use for Elster-XML */
	unsigned char **clearing_uri_list;
	int clearing_uri_list_length;
	unsigned char *cert_filename;
	int clearing_timeout_ms;
	unsigned char *schema_dir_url;

	unsigned char *datenlieferant_xpathexpr;
	unsigned char *datenteil_xpathexpr;
	unsigned char *datengroesse_xpathexpr;
	unsigned char *transportschluessel_xpathexpr;
	
	/* state */
	int clearing_uri_index;

	/* session key will be stored by first encryption for decryption */
	/* for testing encryption we can set the session key directly */
	unsigned char *session_key;

	/* use only for testing */
	unsigned char *iv;
};

#endif
