/*
 * Copyright (C) 2005  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#define GEIER_SIGNATURE_INTERNALS 1
#include <geier.h>
#include "context.h"

#include <openssl/pkcs12.h>
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

static PKCS12 *
geier_dsig_open(const char *filename, const char *pincode)
{
	FILE *handle = fopen(filename, "r");
	if(! handle) return NULL;

	PKCS12 *p12;
	if (!(p12 = d2i_PKCS12_fp(handle, NULL))) {
		ERR_print_errors_fp(stderr);
		return NULL;
	}

	if(! PKCS12_verify_mac(p12, pincode, -1)) 
		return NULL; /* MAC is invalid */
	
	return p12;
}

int
geier_dsig_verify_mac(geier_context *context, 
		      const char *filename, 
		      const char *pincode)
{
	PKCS12 *p12 = geier_dsig_open(filename, pincode);
	if(! p12) return 1;

	PKCS12_free(p12);
	return 0;
}

static char *
get_attr(STACK_OF(X509_ATTRIBUTE) *attrs, const char *want)
{
	if(! attrs) return NULL;
	
	int i;
	for(i = 0; i < sk_X509_ATTRIBUTE_num(attrs); i ++) {
		X509_ATTRIBUTE *attr = sk_X509_ATTRIBUTE_value(attrs, i);
		
		int id = OBJ_obj2nid(attr->object);
		if(id == NID_undef)
			continue; /* unnamed attribute */

		if(strcmp(OBJ_nid2ln(id), want) == 0) {
			if(! sk_ASN1_TYPE_num(attr->value.set)) return NULL;

			ASN1_TYPE *val = sk_ASN1_TYPE_value(attr->value.set,0);

			if(val->type == V_ASN1_BMPSTRING)
				return uni2asc(val->value.bmpstring->data,
					       val->value.bmpstring->length);

			if(val->type == V_ASN1_OCTET_STRING)
				return strdup(val->value.bmpstring->data);


			fprintf(stderr, PACKAGE_NAME ": unsupported "
				"ASN.1 type in get_attr. Sorry.\n");

			return NULL;
		}
	}

	return NULL;
}

				


static EVP_PKEY *
geier_dsig_get_key(geier_context *context, 
		   const char *filename, 
		   const char *pin,
		   const char *keyname)
{
	EVP_PKEY *result = NULL;

	int pinlen = pin ? strlen(pin) : 0;

	PKCS12 *p12 = geier_dsig_open(filename, pin);
	if(! p12) return NULL;
	
	STACK_OF(PKCS7) *safes = PKCS12_unpack_authsafes(p12);
	if(! safes) return NULL;

	int i;
	for(i = 0; i < sk_PKCS7_num(safes); i ++) {
		PKCS7 *p7 = sk_PKCS7_value(safes, i);
		assert(p7);

		STACK_OF(PKCS12_SAFEBAGS) *bags = NULL;

		int id = OBJ_obj2nid(p7->type);
		if(id == NID_pkcs7_data)
			bags = PKCS12_unpack_p7data(p7);

		else if (id == NID_pkcs7_encrypted)
			bags = PKCS12_unpack_p7encdata(p7, pin, pinlen);

		else {
			fprintf(stderr, PACKAGE_NAME "unknown PKCS12_SAFEBAGS "
				"nid discovered.");
			goto out0;
		}

		assert(bags);

		int j;
		for(j = 0; j < sk_PKCS12_SAFEBAG_num(bags); j ++) {
			PKCS12_SAFEBAG *bag = sk_PKCS12_SAFEBAG_value(bags, j);
			assert(bag);
			
			if(M_PKCS12_bag_type(bag) == NID_pkcs8ShroudedKeyBag) {
				char *friendlyname = 
					get_attr(bag->attrib, "friendlyName");

				if(strcmp(friendlyname, keyname) == 0) {
					/* got the key we look for */
					PKCS8_PRIV_KEY_INFO *p8;
					p8 = PKCS12_decrypt_skey(bag, pin, 
								 pinlen);

					if(p8)
						result = EVP_PKCS82PKEY(p8);

					sk_PKCS12_SAFEBAG_pop_free
						(bags, PKCS12_SAFEBAG_free);

					free(friendlyname);
					goto out1;
				}

				free(friendlyname);
			}
		}


		sk_PKCS12_SAFEBAG_pop_free(bags, PKCS12_SAFEBAG_free);
	}

out1:
	

out0:
	sk_PKCS7_pop_free(safes, PKCS7_free);
	PKCS12_free(p12);
	
	return result;
}

static X509 *
geier_dsig_get_cert(geier_context *context, 
		    const char *filename, 
		    const char *pin,
		    const char *certname,
		    char **fn)
{
	char *keyid = NULL;
	X509 *result = NULL;
	*fn = NULL;

	int pinlen = pin ? strlen(pin) : 0;

	PKCS12 *p12 = geier_dsig_open(filename, pin);
	if(! p12) return NULL;
	
	STACK_OF(PKCS7) *safes = PKCS12_unpack_authsafes(p12);
	if(! safes) return NULL;

	int i;
	for(i = 0; i < sk_PKCS7_num(safes); i ++) {
		PKCS7 *p7 = sk_PKCS7_value(safes, i);
		assert(p7);

		STACK_OF(PKCS12_SAFEBAGS) *bags = NULL;

		int id = OBJ_obj2nid(p7->type);
		if(id == NID_pkcs7_data)
			bags = PKCS12_unpack_p7data(p7);

		else if (id == NID_pkcs7_encrypted)
			bags = PKCS12_unpack_p7encdata(p7, pin, pinlen);

		else {
			fprintf(stderr, PACKAGE_NAME "unknown PKCS12_SAFEBAGS "
				"nid discovered.");
			goto out0;
		}

		assert(bags);

		int j;
		for(j = 0; j < sk_PKCS12_SAFEBAG_num(bags); j ++) {
			PKCS12_SAFEBAG *bag = sk_PKCS12_SAFEBAG_value(bags, j);
			assert(bag);
			
			if(M_PKCS12_bag_type(bag) == NID_pkcs8ShroudedKeyBag) {
				char *friendlyname = 
					get_attr(bag->attrib, "friendlyName");

				if(strcmp(friendlyname, certname) == 0) {
					/* got the key we look for */
					keyid = get_attr(bag->attrib,
							 "localKeyID");
				}
			}
			else if(M_PKCS12_bag_type(bag) == NID_certBag
				&& M_PKCS12_cert_bag_type(bag)
				== NID_x509Certificate) {
				char *localKeyID =
					get_attr(bag->attrib, "localKeyID");

				if(localKeyID && keyid &&
				   memcmp(localKeyID, keyid, 18) == 0) {
					if(fn)
						*fn = get_attr(bag->attrib,
							       "friendlyName");

					result = PKCS12_certbag2x509(bag);
					sk_PKCS12_SAFEBAG_pop_free
						(bags, PKCS12_SAFEBAG_free);
					free(localKeyID);

					goto out0;
				}

				free(localKeyID);
			}
		}

		sk_PKCS12_SAFEBAG_pop_free(bags, PKCS12_SAFEBAG_free);
	}

out0:
	sk_PKCS7_pop_free(safes, PKCS7_free);
	PKCS12_free(p12);

	if(fn && *fn) {
		/* strip the friendlyName we return,
		 * it's of the form "CN=Stefan\,Siegl,2.5.4.5=#blablabla"
		 */
		int i, l = strlen(*fn);
		for(i = 1; i < l; i ++)
			if((*fn)[i] == ',' && (*fn)[i - 1] != '\\') {
				(*fn)[i] = 0;
				break;
			}
		memmove(*fn, *fn + 3, strlen(*fn + 3) + 1);
	}
	
	return result;
}


EVP_PKEY *
geier_dsig_get_signaturekey(geier_context *context, 
			    const char *filename, 
			    const char *password)
{
	return geier_dsig_get_key(context, filename, password, "signaturekey");
}

X509 *
geier_dsig_get_signaturecert(geier_context *context,
			     const char *filename,
			     const char *password,
			     char **friendlyName) 
{
	return geier_dsig_get_cert(context, filename, password, 
				   "signaturekey", friendlyName);
}

int
geier_dsig_get_signaturecert_text(geier_context *context,
				  const char *pse, const char *pin,
				  char **output, size_t *outlen,
				  char **fN)
{
	X509 *cert = geier_dsig_get_signaturecert(context, pse, pin, fN);
	if(! cert) return 1;

	BIO *bio = BIO_new(BIO_s_mem());
	if(! bio) {
		X509_free(cert);
		return 1;
	}

	PEM_write_bio_X509(bio, cert);
	X509_free(cert);

	*outlen = BIO_get_mem_data(bio, output);
	BIO_set_close(bio, BIO_NOCLOSE);
	BIO_free(bio);

	return 0;
}

EVP_PKEY *
geier_dsig_get_encryptionkey(geier_context *context, 
			    const char *filename, 
			    const char *password)
{
	return geier_dsig_get_key(context, filename, password, "encryptionkey");
}

X509 *
geier_dsig_get_encryptioncert(geier_context *context,
			      const char *filename,
			      const char *password,
			      char **friendlyName) 
{
	return geier_dsig_get_cert(context, filename, password, 
				   "encryptionkey", friendlyName);
}



int
geier_dsig_sign_doit(geier_context *context, xmlDoc **output,
		     const char *softpse, const char *pin)
{
	int retval = -1;

	/*
	 * load template and attach to Elster XML document 
	 */
	xmlDoc *doc = xmlParseFile(context->xmlsec_tpl_filename);
	if((doc == NULL) || (xmlDocGetRootElement(doc) == NULL)) {
		fprintf(stderr, PACKAGE_NAME 
			": unable to parse file \"%s\"\n", softpse);
		goto out;
	}

	xmlNode *sig_sibling = NULL;
	if(find_node(*output, context->add_signature_xpathexpr, &sig_sibling))
		goto out;

	xmlAddNextSibling(sig_sibling, xmlDocGetRootElement(doc));


	/*
	 * strip namespace from `/elster:Elster' node
	 *
	 * sic! This is somewhat a hack but I cannot think of another way 
	 * to implement things. Elster's clearing host obviously does not
	 * allow us to set the XPath-expression
	 * `ancestor-or-self::Elster:Nutzdaten' 
	 * (i.e. it does not support a namespace specification there). 
	 */
	xmlNode *rootnode;
	if(find_node(*output, "/elster:Elster", &rootnode)) 
		goto out;

	xmlNs *ns = rootnode->ns;
	rootnode->ns = rootnode->nsDef = NULL;
	
	/* reparse the tree; FIXME why doesn't it work without? */
	unsigned char *buf; size_t buflen;
	geier_xml_to_text(context, *output, &buf, &buflen);
	rootnode->ns = rootnode->nsDef = ns; /* restore .. */
	xmlFreeDoc(*output);                 /* .. and kill everything */

	geier_text_to_xml(context, buf, buflen, output);
	free(buf);


	/*
	 * find start node 
	 */
	xmlNode *node = xmlSecFindNode(xmlDocGetRootElement(*output), 
				       xmlSecNodeSignature, xmlSecDSigNs);
	if(! node) {
		fprintf(stderr, PACKAGE_NAME ": start node not found "
			"in template file \"%s\"\n", softpse);
		goto out;
	}



	/* 
	 * create new signature context
	 */
	xmlSecDSigCtx *ctx = xmlSecDSigCtxCreate(NULL);
	if(! ctx) {
		fprintf(stderr, PACKAGE_NAME 
			": failed to create signature context\n");
		goto out;
	}


	/*
	 * assign the private key
	 */
	EVP_PKEY *pKey = geier_dsig_get_signaturekey(context, softpse, pin);
	if(! pKey) goto out1;

	xmlSecKeyData *keydata = xmlSecOpenSSLEvpKeyAdopt(pKey);
	if(! keydata) goto out1;

	xmlSecKey *seckey = xmlSecKeyCreate();
	if(! seckey) goto out2;

	if(xmlSecKeySetName(seckey, "signaturekey")) goto out3;
	if(xmlSecKeySetValue(seckey, keydata)) goto out3;
	keydata = NULL; /* xmlSecDSigCtxDestroy will destroy this ... */

	assert(xmlSecKeyIsValid(seckey));
	ctx->signKey = seckey;
	seckey = NULL; /* referenced now, xmlSecDSigCtxDestroy will destroy */

        /*
	 * load certificate and add to the key
	 */
	char *cert = NULL;
	size_t certlen;
	char *friendlyName;
	if(geier_dsig_get_signaturecert_text(context, softpse, pin,
					     &cert, &certlen, &friendlyName))
		goto out3;
	if(! friendlyName)
		goto out3;

	if(xmlSecCryptoAppKeyCertLoadMemory(ctx->signKey, cert, certlen, 
				      xmlSecKeyDataFormatPem) < 0) {
		fprintf(stderr,"Error: failed to load pem certificate\n");
		goto out3;
	}


	const char *nam_xpathexpr = 
		"/Elster/DatenTeil/Nutzdatenblock/NutzdatenHeader/"
		"SigUser/UserInfo/User/Name"; /* no namespaces!! */
	xmlNode *nam_node;
	if(find_node(*output, nam_xpathexpr, &nam_node))
		goto out3;

	/* try to split first and family name "Stefan\,Siegl" */
	char *ptr;
	if((ptr = strstr(friendlyName, "\\,"))) {
		*ptr = 0;
		xmlNode *vornam_node = xmlNewNode(NULL, "Vorname");
		if(! vornam_node) goto out3;
		xmlNodeAddContent(vornam_node, friendlyName);
		xmlAddPrevSibling(nam_node, vornam_node);
		xmlNodeAddContent(nam_node, ptr + 2);
	} else
		xmlNodeAddContent(nam_node, friendlyName);

	/*
	 * now sign the document
	 */
	if(xmlSecDSigCtxSign(ctx, node)) {
		fprintf(stderr, "failed to sign. fuck.\n");
		goto out3;
	}


	/*
	 * restore the namespace declaration
	 */
	ns = xmlNewNs((* output)->children,
		      "http://www.elster.de/2002/XMLSchema", NULL);

	/* successfully signed the document */
	retval = 0;

out3:
	if(seckey) xmlSecKeyDestroy(seckey);
	if(cert) free(cert);
	if(friendlyName) free(friendlyName);
out2:
	if(keydata) xmlSecKeyDataDestroy(keydata);
out1:
	xmlSecDSigCtxDestroy(ctx);
out:
	if(doc) xmlFreeDoc(doc);
	return retval;
}


int
geier_dsig_sign(geier_context *context,
		const xmlDoc *input, xmlDoc **output,
		const char *softpse, const char *pincode)
{
	int retval = -1;

	assert(context);
	assert(input);
	assert(output);
	assert(softpse);
	assert(pincode);

	*output = xmlCopyDoc((xmlDoc *) input, 1);
	if(! *output) return -1; /* pre-fail */

	/* 
	 * make sure `ElsterOnline-Portal: ' is in the DatenLieferant field
	 */
	const char *xpathexpr = 
		"/elster:Elster/elster:TransferHeader/elster:DatenLieferant";
	xmlNode *node;
	if(find_node(*output, xpathexpr, &node)) goto out;

	const char eoptext[] = "ElsterOnline-Portal: ";
	assert(node->type == XML_ELEMENT_NODE);
	assert(node->children->type == XML_TEXT_NODE);
	if(! strstr(node->children->content, eoptext)) {
		size_t len = strlen(node->children->content);
		node->children->content = realloc(node->children->content,
						  len + sizeof(eoptext));
		if(! node->children->content) goto out;
		
		memmove(node->children->content + sizeof(eoptext) - 1, 
			node->children->content, len + 1);
		memmove(node->children->content, eoptext, sizeof(eoptext) - 1);
	}

	/* 
	 * replace `NoSig' in `Vorgang' by `Sig'
	 */ 
	xpathexpr = "/elster:Elster/elster:TransferHeader/elster:Vorgang";
	if(find_node(*output, xpathexpr, &node))
		goto out;
	assert(node->type == XML_ELEMENT_NODE);
	assert(node->children->type == XML_TEXT_NODE);
	char *ptr;
	if((ptr = strstr(node->children->content, "NoSig")))
		memmove(ptr, ptr + 2, strlen(ptr + 2) + 1);

	/* 
	 * sign the document 
	 */
	retval = geier_dsig_sign_doit(context, output, softpse, pincode);
			
out:
	if(retval) xmlFreeDoc(*output);
	return retval;
}

int geier_dsig_sign_text(geier_context *context,
			 const unsigned char *input, size_t inlen,
			 unsigned char **output, size_t *outlen,
			 const char *pse, const char *pincode)
{
	int retval;
	xmlDoc *indoc;
	xmlDoc *outdoc;

	if((retval = geier_text_to_xml(context, input, inlen, &indoc)))
		goto out0;

	if((retval = geier_dsig_sign(context, indoc, &outdoc, pse, pincode)))
		goto out1;

	if((retval = geier_xml_to_text(context, outdoc, output, outlen)))
		goto out2;

 out2:
	xmlFreeDoc(outdoc);
 out1:
	xmlFreeDoc(indoc);
 out0:
	return retval;
}
