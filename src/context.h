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
	unsigned char **clearing_uri_list;
	unsigned char *cert_filename;
	unsigned char **encrypt_xpathexprs; /* location of nodes to encrypt */

	/* state */
	/* session key will be stored by first encryption for decryption */
	/* for testing encryption we can set the session key directly */
	unsigned char *session_key;

	/* use only for testing */
	unsigned char **encrypt_ivs; /* parallels encrypt_xpathexprs */
	unsigned char *iv;
};

#endif
