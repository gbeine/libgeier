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
#  include <config.h>
#endif

#include <geier.h>
#include <geier-dsig.h>
#include "context.h"

#include <openssl/err.h>

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
 * load template and attach to Elster XML document 
 */
static int 
geier_dsig_sign_add_template(geier_context *context, xmlDoc *tree)
{
	xmlDoc *doc = xmlParseFile(context->xmlsec_tpl_filename);
	if((doc == NULL) || (xmlDocGetRootElement(doc) == NULL)) {
		fprintf(stderr, PACKAGE_NAME 
			": unable to parse template file \"%s\"\n", 
			context->xmlsec_tpl_filename);
		return 1;
	}

	xmlNode *sig_sibling = NULL;
	if(find_node(tree, context->add_signature_xpathexpr, &sig_sibling)) {
		xmlFreeDoc(doc);
		return 1;
	}

	xmlAddNextSibling(sig_sibling, xmlDocGetRootElement(doc));
	xmlFreeDoc(doc);
	return 0;
}



/*
 * strip namespace from `/elster:Elster' node
 */
static int
geier_dsig_sign_strip_ns(geier_context *context, xmlDoc **output)
{
	/* sic! This is somewhat a hack but I cannot think of another way 
	 * to implement things. Elster's clearing host obviously does not
	 * allow us to set the XPath-expression
	 * `ancestor-or-self::Elster:Nutzdaten' 
	 * (i.e. it does not support a namespace specification there). 
	 */
	xmlNode *rootnode;
	if(find_node(*output, "/elster:Elster", &rootnode)) 
		return 1;

	xmlNs *ns = rootnode->ns;
	rootnode->ns = rootnode->nsDef = NULL;
	
	/* reparse the tree; FIXME why doesn't it work without? */
	unsigned char *buf; size_t buflen;
	geier_xml_to_text(context, *output, &buf, &buflen);
	rootnode->ns = rootnode->nsDef = ns; /* restore .. */
	xmlFreeDoc(*output);                 /* .. and kill everything */

	geier_text_to_xml(context, buf, buflen, output);
	free(buf);

	return 0;
}


/*
 * assign the private key
 */
static int
geier_dsig_sign_add_pkey(geier_context *context, xmlSecDSigCtx *ctx,
			 const char *softpse, const char *pin)
{
	EVP_PKEY *pKey = geier_dsig_get_signaturekey(context, softpse, pin);
	if(! pKey) return 1;

	xmlSecKeyData *keydata = xmlSecOpenSSLEvpKeyAdopt(pKey);
	if(! keydata) return 1;

	xmlSecKey *seckey = xmlSecKeyCreate();
	if(! seckey) {
		xmlSecKeyDataDestroy(keydata);
		return 1;
	}

	if(xmlSecKeySetName(seckey, "signaturekey")
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
int
geier_dsig_sign_add_cert(geier_context *context, xmlSecDSigCtx *ctx, 
			 const char **friendlyName, 
			 const char *softpse, const char *pin)
{
	char *cert = NULL;
	size_t certlen;

	if(geier_dsig_get_signaturecert_text(context, softpse, pin,
					     &cert, &certlen, friendlyName))
		return 1;

	if(! friendlyName) {
		free(cert);
		return 1;
	}

	if(xmlSecCryptoAppKeyCertLoadMemory(ctx->signKey, cert, certlen, 
					    xmlSecKeyDataFormatPem) < 0) {
		free(cert);
		return 1;
	}

	free(cert);
	return 0;
}



/* 
 * fill the <UserInfo> piece of the Elster tree
 */
static int
geier_dsig_sign_fill_user(geier_context *context, xmlDoc *output, 
			  const char *friendlyName)
{
	const char *nam_xpathexpr = 
		"/Elster/DatenTeil/Nutzdatenblock/NutzdatenHeader/"
		"SigUser/UserInfo/User/Name"; /* no namespaces!! */
	xmlNode *nam_node;

	if(find_node(output, nam_xpathexpr, &nam_node))
		return 1;

	/* try to split first and family name "Stefan\,Siegl" */
	char *ptr;
	if((ptr = strstr(friendlyName, "\\,"))) {
		*ptr = 0;

		xmlNode *vornam_node = xmlNewNode(NULL, "Vorname");
		if(! vornam_node) return 1;

		xmlNodeAddContent(vornam_node, friendlyName);
		xmlAddPrevSibling(nam_node, vornam_node);
		xmlNodeAddContent(nam_node, ptr + 2);
	} 

	else /* non-splittable name */
		xmlNodeAddContent(nam_node, friendlyName);

	return 0;
}



/* carry out the actual signing process */
int
geier_dsig_sign_doit(geier_context *context, xmlDoc **output,
		     const char *softpse, const char *pin)
{
	int retval = 1;

	if(geier_dsig_sign_add_template(context, *output)) return 1;
	if(geier_dsig_sign_strip_ns(context, output)) return 1;

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


	if(geier_dsig_sign_add_pkey(context, ctx, softpse, pin))
		goto out;

	char *fn;
	if(geier_dsig_sign_add_cert(context, ctx, &fn, softpse, pin)) 
		goto out;

	/* 
	 * the friendlyName tends to be encoded in ISO-8859-1 format,
	 * however libxml requires us to provide UTF-8, therefore convert
	 * once more ...
	 */
	int fn_len = strlen(fn), fn_utf8_len = fn_len * 2;
	char *fn_utf8 = malloc(fn_utf8_len + 1);
	if(! fn_utf8) {
		free(fn);
		goto out;
	}

	isolat1ToUTF8(fn_utf8, &fn_utf8_len, fn, &fn_len);

	assert(fn_utf8_len < fn_len * 2);
	fn_utf8[fn_utf8_len] = 0;

	/*
	 * fill in user element ...
	 */
	if(geier_dsig_sign_fill_user(context, *output, fn_utf8)) {
		free(fn);
		free(fn_utf8);
		goto out;
	}

	free(fn);
	free(fn_utf8);

	/*
	 * now sign the document
	 */
	if((retval = xmlSecDSigCtxSign(ctx, node)))
		goto out;

	/*
	 * restore the namespace declaration
	 */
	xmlNewNs((* output)->children,
		 "http://www.elster.de/2002/XMLSchema", NULL);

out:
	xmlSecDSigCtxDestroy(ctx);
	return retval;
}
