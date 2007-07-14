/*
 * Copyright (C) 2005,2007  Stefan Siegl <stesie@brokenpipe.de>, Germany
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
#include "context.h"

#include <assert.h>
#include <string.h>
#include <stdio.h>

#include <libxml/tree.h>
#include <libxml/parser.h>

#include "find_node.h"
#include "dsig.h"



/* XPath expression pointing to the parent node, where to add the signature */
static char *add_signature_xpathexpr =
	"/elster:Elster/elster:DatenTeil/elster:Nutzdatenblock"
	"/elster:NutzdatenHeader/elster:Empfaenger";

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
	if(find_node(tree, add_signature_xpathexpr, &sig_sibling)) {
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


int
geier_dsig_sign_softpse(geier_context *context,
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

	if(geier_dsig_rewrite_datenlieferant(*output)) goto out;
	if(geier_dsig_rewrite_vorgang(*output)) goto out;
	if(geier_dsig_sign_add_template(context, *output)) goto out;
	if(geier_dsig_sign_strip_ns(context, output)) goto out;
	
	retval = geier_dsig_sign_cruft_softpse(context, output, softpse,
					       pincode);
			
out:
	if(retval) xmlFreeDoc(*output);
	return retval;
}



int geier_dsig_sign_softpse_text(geier_context *context,
				 const unsigned char *input, size_t inlen,
				 unsigned char **output, size_t *outlen,
				 const char *pse, const char *pincode)
{
	int retval;
	xmlDoc *indoc;
	xmlDoc *outdoc;

	if((retval = geier_text_to_xml(context, input, inlen, &indoc)))
		goto out0;

	if((retval = geier_dsig_sign_softpse(context, indoc, &outdoc,
					     pse, pincode)))
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



/* wrapper for deprecated function */
int
geier_dsig_sign(geier_context *context,
		const xmlDoc *input, xmlDoc **output,
		const char *softpse, const char *pincode)
{
	return geier_dsig_sign_softpse(context, input, output,
				       softpse, pincode);
}


/* wrapper for deprecated function */
int geier_dsig_sign_text(geier_context *context,
			 const unsigned char *input, size_t inlen,
			 unsigned char **output, size_t *outlen,
			 const char *pse, const char *pincode)
{
	return geier_dsig_sign_softpse_text(context, input, inlen,
					    output, outlen, pse, pincode);
}



int
geier_dsig_sign_opensc(geier_context *context,
		       const xmlDoc *input, xmlDoc **output,
		       unsigned int cert_id)
{
	int retval = -1;

	assert(context);
	assert(input);
	assert(output);

#ifdef XMLSEC_CRYPTO_OPENSSL
	*output = xmlCopyDoc((xmlDoc *) input, 1);
	if(! *output) return -1; /* pre-fail */

	if(geier_dsig_rewrite_datenlieferant(*output)) goto out;
	if(geier_dsig_rewrite_vorgang(*output)) goto out;
	if(geier_dsig_sign_add_template(context, *output)) goto out;
	if(geier_dsig_sign_strip_ns(context, output)) goto out;
	
	retval = geier_dsig_sign_cruft_opensc(context, output, cert_id);
			
out:
	if(retval) xmlFreeDoc(*output);
#endif /* XMLSEC_CRYPTO_OPENSSL */
	return retval;
}



int 
geier_dsig_sign_opensc_text(geier_context *context,
			    const unsigned char *input, size_t inlen,
			    unsigned char **output, size_t *outlen,
			    unsigned int cert_id)
{
	int retval = -1;

#ifdef XMLSEC_CRYPTO_OPENSSL
	xmlDoc *indoc;
	xmlDoc *outdoc;

	if((retval = geier_text_to_xml(context, input, inlen, &indoc)))
		goto out0;

	if((retval = geier_dsig_sign_opensc(context, indoc, &outdoc,
					    cert_id)))
		goto out1;

	if((retval = geier_xml_to_text(context, outdoc, output, outlen)))
		goto out2;

 out2:
	xmlFreeDoc(outdoc);
 out1:
	xmlFreeDoc(indoc);
 out0:
#endif /* XMLSEC_CRYPTO_OPENSSL */
	return retval;
}
