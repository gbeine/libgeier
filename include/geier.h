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

#ifndef GEIER_H
#define GEIER_H

#include <libxml/tree.h>

/* Kontext, enthält Konfigurationsparameter, Sitzungsschlüssel, ... */
typedef struct _geier_context geier_context;

/* Parameter for gzip */
#define GEIER_WBITS_GZIP 31

/* Kontext erzeugen und mit Defaultwerten initialisierten */
/* Rückgabewert NULL bedeutet Fehler */
geier_context *geier_context_new(void);
void geier_context_free(geier_context *context);

/* Kompletten Elster-Datensatz verschlüsseln, senden, Rückgabe entschlüsseln */
int geier_send_text(geier_context *context,
		    const unsigned char *input, size_t inlen,
		    unsigned char **output, size_t *outlen);
int geier_send(geier_context *context,
	       const xmlDoc *input, xmlDoc **output);

int geier_send_encrypted_text(geier_context *context,
			      const unsigned char *input, size_t inlen,
			      unsigned char **output, size_t *outlen);

/* Verschlüsselung */

/* In komplettem zu sendendem Datensatz die nötigen Teile verschlüsseln */
int geier_encrypt(geier_context *context,
		  const xmlDoc *input, xmlDoc **output);

/* In komplettem empfangenen Datensatz die nötigen Teile entschlüsseln */
int geier_decrypt(geier_context *context,
		  const xmlDoc *input, xmlDoc **output);

/* Konversionen zwischen XML und Text */
int geier_xml_to_text(const xmlDoc *doc,
		      unsigned char **output, size_t *outlen);
int geier_text_to_xml(const unsigned char *input, size_t inlen,
		      xmlDoc **doc);

/* später mehr */
#if 0
int geier_validate(const xmlDoc *input);
#endif

#endif 
