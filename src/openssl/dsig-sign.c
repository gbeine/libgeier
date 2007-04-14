/*
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

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <geier.h>
#include "dsig.h"
#include "context.h"

#include <openssl/err.h>
#include <openssl/engine.h>

#include <assert.h>
#include <string.h>
#include <stdio.h>

#include <libxml/tree.h>
#include <libxml/parser.h>

#ifndef XMLSEC_NO_XSLT
#include <libxslt/xslt.h>
#endif

#include <xmlsec/xmldsig.h>
#include <xmlsec/xmlsec.h>
#include <xmlsec/xmltree.h>
#include <xmlsec/crypto.h>
#include <xmlsec/openssl/evp.h>

#include "find_node.h"
#include "dsig.h"



/*
 * assign the private key
 */
static int
geier_dsig_sign_add_pkey(geier_context *context, xmlSecDSigCtx *ctx,
			 EVP_PKEY *pKey)
{
	(void) context;

	xmlSecKeyData *keydata = xmlSecOpenSSLEvpKeyAdopt(pKey);
	if(! keydata) return 1;

	xmlSecKey *seckey = xmlSecKeyCreate();
	if(! seckey) {
		xmlSecKeyDataDestroy(keydata);
		return 1;
	}

	if(xmlSecKeySetName(seckey, (unsigned char *) "signaturekey")
	   || xmlSecKeySetValue(seckey, keydata)) {
		xmlSecKeyDestroy(seckey);
		xmlSecKeyDataDestroy(keydata);
		return 1;
	}

	assert(xmlSecKeyIsValid(seckey));
	ctx->signKey = seckey;
	
	return 0;
}



/*
 * load certificate and add to the key
 */
static int
geier_dsig_sign_add_cert(geier_context *context, xmlSecDSigCtx *ctx, 
			 const char *cert, size_t certlen)
{
	(void) context;

	if(xmlSecCryptoAppKeyCertLoadMemory(ctx->signKey,
					    (const unsigned char *) cert,
					    certlen,
					    xmlSecKeyDataFormatPem) < 0)
		return 1;

	return 0;
}



/* 
 * fill the <UserInfo> piece of the Elster tree
 */
static int
geier_dsig_sign_fill_user(geier_context *context, xmlDoc *output, 
			  const char *sn, const char *gn)
{
	(void) context;

	const char *nam_xpathexpr = 
		"/Elster/DatenTeil/Nutzdatenblock/NutzdatenHeader/"
		"SigUser/UserInfo/User/Name"; /* no namespaces!! */
	xmlNode *nam_node;

	if(find_node(output, nam_xpathexpr, &nam_node))
		return 1;

	if(gn && *gn) {
		xmlNode *vornam_node =
			xmlNewNode(NULL, (unsigned char *) "Vorname");
		if(! vornam_node) return 1;

		xmlNodeAddContent(vornam_node, (const unsigned char *) gn);
		xmlAddPrevSibling(nam_node, vornam_node);
	} 

	xmlNodeAddContent(nam_node, (const unsigned char *) sn);
	return 0;
}



static int
geier_dsig_sign_cruft(geier_context *context, xmlDoc **output,
		      EVP_PKEY *pKey, const char *cert, size_t certlen,
		      const char *sn, const char *gn)
{
	int retval = -1;
	
	/* find start node */
	xmlNode *node = xmlSecFindNode(xmlDocGetRootElement(*output), 
				       xmlSecNodeSignature, xmlSecDSigNs);
	if(! node) {
		fprintf(stderr, PACKAGE_NAME ": start node not found "
			"in template file \"%s\"\n", 
			context->xmlsec_tpl_filename);
		return 1;
	}

	/* create new signature context */
	xmlSecDSigCtx *ctx = xmlSecDSigCtxCreate(NULL);
	if(! ctx) {
		fprintf(stderr, PACKAGE_NAME 
			": failed to create signature context\n");
		return 1;
	}

	if(geier_dsig_sign_add_pkey(context, ctx, pKey))
		goto out;

	if(geier_dsig_sign_add_cert(context, ctx, cert, certlen)) 
		goto out;

	/* 
	 * fill in user element ...
	 */
	if(geier_dsig_sign_fill_user(context, *output, sn, gn))
		goto out;

	/*
	 * now sign the document
	 */
	if((retval = xmlSecDSigCtxSign(ctx, node)))
		goto out;

	/*
	 * restore the namespace declaration
	 */
	xmlNewNs((* output)->children,
		 (const unsigned char *) "http://www.elster.de/2002/XMLSchema",
		 NULL);

out:
	xmlSecDSigCtxDestroy(ctx);
	return retval;
}


/* carry out the actual signing process */
int
geier_dsig_sign_cruft_softpse(geier_context *context, xmlDoc **output,
			      const char *softpse, const char *pin)
{
	int retval = 1;

	/* get key */
	EVP_PKEY *pKey = geier_dsig_get_signaturekey(context, softpse, pin);
	if(! pKey) return 1;

	/* get certificate */
	char *cert = NULL;
	size_t certlen;

	char *friendlyName;
	if(geier_dsig_get_signaturecert_text(context, softpse, pin,
					     &cert, &certlen, &friendlyName))
		return 1;

	if(! friendlyName) {
		free(cert);
		return 1;
	}

	/* convert friendlyName to UTF-8 */
	int fn_len = strlen(friendlyName), fn_utf8_len = fn_len * 2;
	char *fn_utf8 = malloc(fn_utf8_len + 1);
	if(! fn_utf8) goto out;

	isolat1ToUTF8((unsigned char *) fn_utf8, &fn_utf8_len,
		      (const unsigned char *) friendlyName, &fn_len);

	assert(fn_utf8_len < fn_len * 2);
	fn_utf8[fn_utf8_len] = 0;

	/* split into surname and given name */
	char *ptr, *sn = fn_utf8, *gn = NULL;
	if((ptr = strstr(fn_utf8, "\\,"))) {
		*ptr = 0;
		gn = fn_utf8;
		sn = ptr + 2;
	}

	retval = geier_dsig_sign_cruft(context, output, pKey, cert, certlen,
				       sn, gn);

	free(fn_utf8);

out:
	/* FIXME free pKey */
	free(cert);
	free(friendlyName);

	return retval;
}


static ENGINE *
geier_dsig_get_engine(void)
{
	static ENGINE *e = NULL;
	const char *engine = "pkcs11";

	if(! e)
		e = ENGINE_by_id(engine);

	if(! e) {
		/* smartcard engine still not available,
		 * try to load it dynamically */
		e = ENGINE_by_id("dynamic");
		if(! e) {
			fprintf(stderr, PACKAGE_NAME ": dynamic OpenSSL "
				"engine not available, but required.\n");
			goto error_out;
		}

		if(! ENGINE_ctrl_cmd_string(e, "SO_PATH", engine, 0))
			goto error_out;

		if(! ENGINE_ctrl_cmd_string(e, "LOAD", NULL, 0))
			goto error_out;
	}

	if(! ENGINE_set_default(e, ENGINE_METHOD_ALL)) {
		fprintf(stderr, PACKAGE_NAME ": cannot use engine `%s'\n",
			engine);
		goto error_out;
	}
	
	return e;

error_out:
	ERR_load_ENGINE_strings();
	ERR_print_errors_fp(stderr);
	if(e) ENGINE_free(e);
	return (e = NULL);
}


int
geier_dsig_sign_cruft_opensc(geier_context *context, xmlDoc **output,
			     unsigned int cert_id)
{
	int retval = 1;
	ENGINE *e = geier_dsig_get_engine();

	if(! e) {
		fprintf(stderr, PACKAGE_NAME ": required OpenSSL "
			"engine couldn't be set up.\n");
		return 1;
	}

	/* get key */
	char cert_id_text[8];
	snprintf(cert_id_text, sizeof cert_id_text, "id_%02x", cert_id);
	UI_METHOD *ui = (UI_METHOD *) UI_get_default_method();
	EVP_PKEY *pKey = ENGINE_load_private_key(e, cert_id_text, ui, context);

	if(! pKey) {
		fprintf(stderr, PACKAGE_NAME ": unable to get private key "
			"reference.\n");
		return 1;
	}

	if(pKey->type != EVP_PKEY_RSA) {
		fprintf(stderr, PACKAGE_NAME ": private key is not an "
		        "rsa key.\n");
		return 1;
	}
	
	/* we need to set engine field to make xmlsec aware of the used
	 * engine; otherwise xmlsec will assume that this is a public
	 * key only, and thus fail. 
	 *
	 * This is quite a hack, maybe see [xmlsec]/src/openssl/evp.c
	 * for details
	 */
	pKey->pkey.rsa->engine = e;

	/* get certificate */
	struct {
		const char *cert_id;
		X509 *cert;
        } parms;

        parms.cert_id = cert_id_text;
        parms.cert = NULL;
        ENGINE_ctrl_cmd(e, "LOAD_CERT_CTRL", 0, &parms, NULL, 1);
	if(! parms.cert) {
		fprintf(stderr, PACKAGE_NAME ": unable to get certificate "
			"from your smartcard.\n");
		return 1;
	}

	/* extract name */
	X509_NAME *subj = X509_get_subject_name(parms.cert);

	char sn[128];
	int r_sn = X509_NAME_get_text_by_NID(subj, NID_surname, sn, sizeof sn);
	char gn[128];
	int r_gn = X509_NAME_get_text_by_NID(subj, NID_givenName, 
	                                     gn, sizeof gn);
	
	if(r_sn < 1 || r_gn < 1) {
		/* use commonName instead of splitting */
		r_sn = X509_NAME_get_text_by_NID(subj, NID_commonName, 
						 sn, sizeof sn);
		gn[0] = 0;

		if(r_sn < 1) {
			fprintf(stderr, PACKAGE_NAME ": failed to extract "
				"name from X509 certificate.\n");
			sn[0] = 0;
		}
	}

	/* convert X509 cert to text */
	char *cert = NULL;
	size_t certlen;

	if(geier_dsig_X509_to_textcert(context, parms.cert, &cert, &certlen))
		return 1;

	retval = geier_dsig_sign_cruft(context, output, pKey, cert, certlen,
				       sn, gn);

	/* FIXME free pKey */
	free(cert);

	return retval;
}
