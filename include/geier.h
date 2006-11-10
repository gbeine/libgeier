/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
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

#ifndef GEIER_H
#define GEIER_H

#ifdef __cplusplus 
#define GEIER_BEGIN_PROTOS	extern "C" {
#define GEIER_END_PROTOS	}
#else
#define GEIER_BEGIN_PROTOS
#define GEIER_END_PROTOS
#endif

#include <libxml/tree.h>

#define GEIER_ERROR_BASE   8000

#define GEIER_ERROR_FORMAT      	 (GEIER_ERROR_BASE+0)
#define GEIER_ERROR_NEW_PARSER_CTXT      (GEIER_ERROR_BASE+1)
#define GEIER_ERROR_SCHEMA_PARSE         (GEIER_ERROR_BASE+2)
#define GEIER_ERROR_NEW_VALID_CTXT       (GEIER_ERROR_BASE+3)
#define GEIER_ERROR_SCHEMA_VALIDATE_DOC  (GEIER_ERROR_BASE+4)
#define GEIER_ERROR_FIND_NODE_NO_UNIQUE_NODE  (GEIER_ERROR_BASE+5)

/* Kontext, enthält Konfigurationsparameter, Sitzungsschlüssel, ... */
typedef struct _geier_context geier_context;

/* Parameter for gzip */
#define GEIER_WBITS_GZIP 31


GEIER_BEGIN_PROTOS

/**
 * geier_init:
 * @debug: set the debug level (%0 for no debuging output)
 *
 * Initialize GEIER library as well as libxml, libxmlsec, libxslt and
 * OpenSSL in turn.  This has to be called first.
 *
 * Returns: %0 on success, %1 on error.
 */
int geier_init(int debug);

/**
 * geier_exit:
 *
 * Shut the GEIER library down.  Ask libxml, libxmlsec, libxslt as well
 * as OpenSSL to shut down as well.  This should be called last.
 *
 * Returns: %0 on success, %1 on error.
 */
int geier_exit(void);

/**
 * geier_context_new:
 *
 * Allocate a new #geier_context.
 *
 * Returns: a new #geier_context.
 */
geier_context *geier_context_new(void);

/**
 * geier_context_free:
 * @context: the #geier_context to free.
 *
 * Deallocates a previously allocated #geier_context.
 */
void geier_context_free(geier_context *context);

/* Kompletten Elster-Datensatz verschlüsseln, senden, Rückgabe entschlüsseln */
int geier_send_text(geier_context *context,
		    const unsigned char *input, size_t inlen,
		    unsigned char **output, size_t *outlen);
int geier_send(geier_context *context,
	       const xmlDoc *input, xmlDoc **output);

/* Kompletten Elster-Datensatz abschicken und Rückgabe abholen */
int geier_send_encrypted(geier_context *context,
			 const xmlDoc *input, xmlDoc **output);
int geier_send_encrypted_text(geier_context *context,
			      const unsigned char *input, size_t inlen,
			      unsigned char **output, size_t *outlen);

/* Verschlüsselung */

/* In komplettem zu sendendem Datensatz die nötigen Teile verschlüsseln */
int geier_encrypt(geier_context *context,
		  const xmlDoc *input, xmlDoc **output);
int geier_encrypt_text(geier_context *context,
		       const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen);

/* In komplettem empfangenen Datensatz die nötigen Teile entschlüsseln */
int geier_decrypt(geier_context *context,
		  const xmlDoc *input, xmlDoc **output);
int geier_decrypt_text(geier_context *context,
		       const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen);

/* Konversionen zwischen XML und Text */
int geier_xml_to_text(geier_context *context,
		      const xmlDoc *input,
		      unsigned char **output, size_t *outlen);
int geier_xml_to_encoded_text(geier_context *context,
			      const xmlDoc *input, const char *encoding,
			      unsigned char **output, size_t *outlen);
int geier_text_to_xml(geier_context *context,
		      const unsigned char *input, size_t inlen,
		      xmlDoc **output);

/* Eingabeformate */
typedef enum _geier_format {
	geier_format_encrypted,
	geier_format_unencrypted,
/*	geier_nutzdatenblock, */
/*	geier_nutzdaten_raw,  */
/*	geier_nutzdaten_user, */
} geier_format;

/* Validiere XML
 * 0 = OK */
int geier_validate(geier_context *context,
		   geier_format f, const xmlDoc *input);
int geier_validate_text(geier_context *context, geier_format f,
			const unsigned char *input, size_t inlen);

/* unverschlüsselten Elster-Datensatz mittels XSLT in HTML aufbereiten */
int geier_xsltify_text(geier_context *context,
		       const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen);
int geier_xsltify(geier_context *context,
		  const xmlDoc *input, xmlDoc **output);

/* Fehlermeldung der Clearingstelle extrahieren, NULL bei Erfolg */
char *geier_get_clearing_error(geier_context *context, const xmlDoc *input);
char *geier_get_clearing_error_text(geier_context *context, 
				    const unsigned char *input, size_t inlen);




/*
 * Digital Signature related cruft
 */

/**
 * geier_dsig_sign
 * @context: a #geier_context.
 * @input: the XML document that should be signed.
 * @output: pointer to where the signed XML document should be written to.
 * @softpse_filename: name of the PKCS&num;12 container file.
 * @pincode: the pincode.
 *
 * Sign the provided Elster-XML document (supplied as @input) with the software
 * certificate, that is automatically extracted from the PKCS&num;12 file with
 * the provided filename.  The @pincode is used to decrypt the container.
 *
 * Returns: %0 on success, %1 on error.  The signed document is written to
 * @output.
 */
int geier_dsig_sign(geier_context *context,
		    const xmlDoc *input, xmlDoc **output,
		    const char *softpse_filename, const char *pincode);

/**
 * geier_dsig_sign_text
 * @context: a #geier_context.
 * @input: the XML document that should be signed, supplied as a C string.
 * @inlen: the length of @input.
 * @output: pointer to where the resulting XML document should be written to
 * (as a C string)
 * @outlen: the length of the buffer @output points to.
 * @softpse_filename: name of the PKCS&num;12 container file.
 * @pincode: the pincode.
 *
 * Sign the provided Elster-XML document (supplied as @input) with the software
 * certificate, that is automatically extracted from the PKCS&num;12 file with
 * the provided filename.  The @pincode is used to decrypt the container.
 *
 * Returns: %0 on success, %1 on error.  The signed document is written to
 * @output, the length of @output is stored to @outlen on success.
 */
int geier_dsig_sign_text(geier_context *context,
			 const unsigned char *input, size_t inlen,
			 unsigned char **output, size_t *outlen,
			 const char *softpse_filename, const char *pincode);

GEIER_END_PROTOS

#endif 
