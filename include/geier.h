/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
 * Copyright (C) 2005,2006,2007  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#ifndef __attribute_deprecated__
#define __attribute_deprecated__
#endif

/**
 * geier_context:
 *
 * A transparent structure, that has to be passed to most of the
 * functions contained in this library.  It mainly is used to store
 * encoder information as well as session keys, needed when sending
 * data to the fiscal authorities.
 *
 * Please make sure not to call two library functions using the same
 * context within two different threads.  Everything else should be
 * threadsafe.
 */
typedef struct _geier_context geier_context;

/* Parameter for gzip */
#define GEIER_WBITS_GZIP 31


GEIER_BEGIN_PROTOS

/**
 * geier_init:
 * @debug: set the debug level (%0 for no debuging output)
 *
 * Initialize GEIER library as well as libxml, libxmlsec, libxslt
 * in turn.  This has to be called first.
 *
 * Returns: %0 on success, %1 on error.
 */
int geier_init(int debug);

/**
 * geier_exit:
 *
 * Shut the GEIER library down.  Ask libxml, libxmlsec, libxslt 
 * to shut down as well.  This should be called last.
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


/*
 * sender functions
 */

/**
 * geier_send_text
 * @context: a #geier_context.
 * @input: the XML document that should be sent, supplied as a C string.
 * @inlen: the length of @input.
 * @output: pointer to where the returned XML document should be written to
 * (as a C string).
 * @outlen: the length of the buffer @output points to.
 * 
 * Send the Elster-XML document, which is supplied as @input, like 
 * #geier_send_encrypted_text, but automatically take care of encryption 
 * and decryption.  Furthermore compression and Base64 encoding is
 * handled automatically.
 *
 * Beware that this functions returns %0 upon successful transmission, this
 * is, if the transmitted data is invalid, %0 is returned no matter what.
 * See #geier_get_clearing_error_text for details.
 *
 * Returns: %0 upon successful transmission, %1 on error.  The returned
 * document is written to @output on success, the length of @output is
 * stored to @outlen.
 */
int geier_send_text(geier_context *context,
		    const unsigned char *input, size_t inlen,
		    unsigned char **output, size_t *outlen);

/**
 * geier_send
 * @context: a #geier_context.
 * @input: the XML document that should be sent.
 * @output: pointer to where the returned XML document should be written to.
 * 
 * Send the Elster-XML document, which is supplied as @input, like 
 * #geier_send_encrypted does, but automatically take care of encryption 
 * and decryption.  Furthermore compression and Base64 encoding is
 * handled internally.
 *
 * Beware that this functions returns %0 upon successful transmission, this
 * is, if the transmitted data is invalid, %0 is returned no matter what.
 * See #geier_get_clearing_error for details.
 *
 * Returns: %0 upon successful transmission, %1 on error.  The returned
 * document is written to @output on success.
 */
int geier_send(geier_context *context,
	       const xmlDoc *input, xmlDoc **output);


/**
 * geier_send_encrypted
 * @context: a #geier_context.
 * @input: the XML document that should be sent.
 * @output: pointer to where the returned XML document should be written to.
 * 
 * Send an already encrypted Elster-XML document, which is supplied as
 * @input, quite like #geier_send does.  But unlike the latter don't
 * care for encipherment.  This is, #geier_send_encrypted relies on
 * @input being encrypted using #geier_encrypt already.
 *
 * Beware that this functions returns %0 upon successful transmission, this
 * is, if the transmitted data is invalid, %0 is returned no matter what.
 * See #geier_get_clearing_error for details.
 *
 * Returns: %0 upon successful transmission, %1 on error.  The returned
 * document is written to @output on success.
 */

int geier_send_encrypted(geier_context *context,
			 const xmlDoc *input, xmlDoc **output);

/**
 * geier_send_encrypted_text
 * @context: a #geier_context.
 * @input: the XML document that should be sent, supplied as a C string.
 * @inlen: the length of @input.
 * @output: pointer to where the returned XML document should be written to
 * (as a C string).
 * @outlen: the length of the buffer @output points to.
 * 
 * Send an already encrypted Elster-XML document, which is supplied as
 * @input, quite like #geier_send_text does.  But unlike the latter
 * don't care for encipherment.  This is, #geier_send_encrypted_text
 * relies on @input being encrypted using #geier_encrypt_text already.
 *
 * Beware that this functions returns %0 upon successful transmission, this
 * is, if the transmitted data is invalid, %0 is returned no matter what.
 * See #geier_get_clearing_error_text for details.
 *
 * Returns: %0 upon successful transmission, %1 on error.  The returned
 * document is written to @output on success, the length of @output is
 * stored to @outlen.
 */
int geier_send_encrypted_text(geier_context *context,
			      const unsigned char *input, size_t inlen,
			      unsigned char **output, size_t *outlen);


/*
 * Encryption and Decryption related functions
 */

/**
 * geier_encrypt
 * @context: a #geier_context.
 * @input: the XML document that should be encrypted.
 * @output: pointer to where the encrypted XML document should be written to.
 * 
 * Encrypt the relevant parts (those the Coala specification requires to be
 * crypted) of the provided Elster-XML document (supplied as @input). 
 * Furthermore compression and Base64 encoding is handled automatically.
 *
 * Returns: %0 on success, %1 on error.  The encrypted document is written to
 * @output on success.
 */
int geier_encrypt(geier_context *context,
		  const xmlDoc *input, xmlDoc **output);

/**
 * geier_encrypt_text
 * @context: a #geier_context.
 * @input: the XML document that should be encrypted, supplied as a C string.
 * @inlen: the length of @input.
 * @output: pointer to where the encrypted XML document should be written to
 * (as a C string).
 * @outlen: the length of the buffer @output points to.
 * 
 * Encrypt the relevant parts (those the Coala specification requires to be
 * crypted) of the provided Elster-XML document (supplied as @input). 
 * Furthermore compression and Base64 encoding is handled automatically.
 *
 * Returns: %0 on success, %1 on error.  The encrypted document is written to
 * @output on success, the length of @output is stored to @outlen.
 */
int geier_encrypt_text(geier_context *context,
		       const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen);

/**
 * geier_decrypt
 * @context: a #geier_context.
 * @input: the XML document that should be decrypted.
 * @output: pointer to where the decrypted XML document should be written to.
 *
 * Decrypt the encrypted parts (those that the Coala specification requires
 * to be sent encrypted) of the Elster-XML document provided as @input.
 * Furthermore decompression and Base64 decoding is handled
 * internally.
 *
 * Please mind, that you cannot use #geier_decrypt to decrypt data
 * that has been enciphered and sent using another #geier_context.
 * This is due to the 3DES key to be contained in the #geier_context.
 *
 * Returns: %0 on success, %1 on error.  The decrypted document is written to
 * @output on success.
 */
int geier_decrypt(geier_context *context,
		  const xmlDoc *input, xmlDoc **output);

/**
 * geier_decrypt_text
 * @context: a #geier_context.
 * @input: the XML document that should be decrypted, supplied as a C string.
 * @inlen: the length of @input.
 * @output: pointer to where the decrypted XML document should be written to
 * (as a C string).
 * @outlen: the length of the buffer @output points to.
 *
 * Decrypt the encrypted parts (those that the Coala specification requires
 * to be sent encrypted) of the Elster-XML document provided as @input.
 * Furthermore decompression and Base64 decoding is handled internally.
 *
 * Please mind, that you cannot use #geier_decrypt to decrypt data
 * that has been enciphered and sent using another #geier_context.
 * This is due to the 3DES key to be contained in the #geier_context.
 *
 * Returns: %0 on success, %1 on error.  The decrypted document is written to
 * @output on success, the length of @output is stored to @outlen.
 */
int geier_decrypt_text(geier_context *context,
		       const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen);


/*
 * XML to text conversion and back
 */
/**
 * geier_xml_to_text
 * @context: a #geier_context.
 * @input: the XML document that should be converted
 * @output: pointer to where the document should be written to (as a C string)
 * @outlen: the length of the buffer @output points to.
 *
 * Convert the XML document to a zero-terminated C string.
 *
 * Returns: %0 on success, %1 on error.  The not further modified document is
 * written to @output on success, the length of @output is stored to @outlen.
 */
int geier_xml_to_text(geier_context *context,
		      const xmlDoc *input,
		      unsigned char **output, size_t *outlen);

/**
 * geier_xml_to_encoded_text
 * @context: a #geier_context.
 * @input: the XML document that should be converted
 * @output: pointer to where the document should be written to (as a C string)
 * @outlen: the length of the buffer @output points to.
 *
 * Convert the XML document to a zero-terminated C string, like
 * #geier_xml_to_text does, but furthermore convert to encoding @encoding.
 *
 * Returns: %0 on success, %1 on error.  The resulting document is
 * written to @output on success, the length of @output is stored to @outlen.
 */
int geier_xml_to_encoded_text(geier_context *context,
			      const xmlDoc *input, const char *encoding,
			      unsigned char **output, size_t *outlen);

/**
 * geier_text_to_xml
 * @context: a #geier_context.
 * @input: the XML document that should be converted, supplied as a C string.
 * @inlen: the length of @input.
 * @output: pointer to where the document should be written to
 *
 * Convert the XML document, supplied as a C string as @input, to a libxml
 * XML document.
 *
 * Returns: %0 on success, %1 on error.  The not further modified document is
 * written to @output on success.
 */
int geier_text_to_xml(geier_context *context,
		      const unsigned char *input, size_t inlen,
		      xmlDoc **output);



/*
 * validation routines
 */
/**
 * geier_format:
 *
 * Format specifier that has to be passed to #geier_validate and
 * #geier_validate_text for those to distinct between different
 * Elster-XML tree flavours.
 *
 * Please mind, that currently only geier_format_unencrypted is
 * supported. 
 */
typedef enum _geier_format {
	geier_format_encrypted,
	geier_format_unencrypted,
/*	geier_nutzdatenblock, */
/*	geier_nutzdaten_raw,  */
/*	geier_nutzdaten_user, */
} geier_format;


/**
 * geier_validate
 * @context: a #geier_context.
 * @f: #geier_format specifier.
 * @input: the XML document that should be validated.
 * 
 * Validate the Elster-XML document against the Schema files supplied
 * by the German fiscal authorities and shipped along with libgeier.
 *
 * Please mind the the only #geier_format (@f) that currently is supported
 * by #geier_validate is geier_format_unencrypted.
 *
 * Returns: %0 upon successful validation, %1 on error.
 */
int geier_validate(geier_context *context,
		   geier_format f, const xmlDoc *input);
/**
 * geier_validate_text
 * @context: a #geier_context.
 * @f: #geier_format specifier.
 * @input: the XML document that should be validated, supplied as a C string.
 * @inlen: the length of @input.
 * 
 * Validate the Elster-XML document against the Schema files supplied
 * by the German fiscal authorities and shipped along with libgeier.
 *
 * Please mind the the only #geier_format (@f) that currently is supported
 * by #geier_validate_text is geier_format_unencrypted.
 *
 * Returns: %0 upon successful validation, %1 on error.
 */
int geier_validate_text(geier_context *context, geier_format f,
			const unsigned char *input, size_t inlen);


/*
 * xsltification functions (protocol generation)
 */

/**
 * geier_xsltify_text
 * @context: a #geier_context.
 * @input: the XML document for that a protocol should be generated,
 * supplied as a C string.
 * @inlen: the length of @input.
 * @output: pointer to where the returned XHTML document should be written to
 * (as a C string).
 * @outlen: the length of the buffer @output points to.
 * 
 * Automatically generate a transmission protocol for the Elster-XML
 * document, that is supplied as @input.  The protocol is generated
 * using the XSLT-File that is shipped along with this library.
 *
 * You can call this function even before calling #geier_send_text,
 * this will result in a common protocol that only states that it has
 * been printed before transmission.
 *
 * Returns: %0 upon successful generation, %1 on error.  The returned
 * document is written to @output on success, the length of @output is
 * stored to @outlen.
 */
int geier_xsltify_text(geier_context *context,
		       const unsigned char *input, size_t inlen,
		       unsigned char **output, size_t *outlen);

/**
 * geier_xsltify
 * @context: a #geier_context.
 * @input: the XML document for that a protocol should be generated.
 * @output: pointer to where the returned XHTML document should be written to.
 * 
 * Automatically generate a transmission protocol for the Elster-XML
 * document, that is supplied as @input.  The protocol is generated
 * using the XSLT-File that is shipped along with this library.
 *
 * You can call this function even before calling #geier_send,
 * this will result in a common protocol that only states that it has
 * been printed before transmission.
 *
 * Returns: %0 upon successful transmission, %1 on error.  The returned
 * document is written to @output on success.
 */
int geier_xsltify(geier_context *context,
		  const xmlDoc *input, xmlDoc **output);


/**
 * geier_get_clearing_error
 * @context: a #geier_context.
 * @input: the XML document that should be checked for errors.
 * 
 * Check the provided (unencrypted) Elster-XML document, supplied as @input,
 * for error codes and return suitable error messages.  @input should be
 * a XML document supplied by one of the clearing hosts as returned by
 * #geier_send. 
 *
 * Returns: %NULL upon success, a suitable error message otherwise.  The 
 * error message should be user understandable and is in German language.
 * Call #free on the returned pointer, if the message is not needed anymore.
 */
char *geier_get_clearing_error(geier_context *context, const xmlDoc *input);

/**
 * geier_get_clearing_error_text
 * @context: a #geier_context.
 * @input: the XML document that should be checked for errors,
 * supplied as a C string.
 * @inlen: the length of @input.
 * 
 * Check the provided (unencrypted) Elster-XML document, supplied as @input,
 * for error codes and return suitable error messages.  @input should be
 * a XML document supplied by one of the clearing hosts as returned by
 * #geier_send_text. 
 *
 * Returns: %NULL upon success, a suitable error message otherwise.  The 
 * error message should be user understandable and is in German language.
 * Call #free on the returned pointer, if the message is not needed anymore.
 */
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
 *
 * @deprecated
 */
int geier_dsig_sign(geier_context *context,
		    const xmlDoc *input, xmlDoc **output,
		    const char *softpse_filename, const char *pincode)
     __attribute_deprecated__;

/**
 * geier_dsig_sign_softpse
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
int geier_dsig_sign_softpse(geier_context *context,
			    const xmlDoc *input, xmlDoc **output,
			    const char *softpse_filename, const char *pincode);

/**
 * geier_dsig_sign_softpse_text
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
int geier_dsig_sign_softpse_text(geier_context *context,
				 const unsigned char *input, size_t inlen,
				 unsigned char **output, size_t *outlen,
				 const char *softpse_filename,
				 const char *pincode);

GEIER_END_PROTOS

#endif 
