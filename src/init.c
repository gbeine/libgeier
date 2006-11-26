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
#include "globals.h"

#include <geier.h>

#include <openssl/evp.h>

#include <libxml/tree.h>
#include <libxml/parser.h>

#ifndef XMLSEC_NO_XSLT
#include <libxslt/xslt.h>
#endif

#include <xmlsec/xmlsec.h>
#include <xmlsec/crypto.h>

/* Mozilla header files */
#include <nss/nss.h>

int geier_init(int debug)
{
	/*
	 * set debug level
	 */
	geier_debug = debug;

	/*
	 * initialise libxml. Ugly syntax they use. Add ; for indent.
	 */
	xmlInitParser();
	LIBXML_TEST_VERSION;

	xmlLoadExtDtdDefaultValue = XML_DETECT_IDS | XML_COMPLETE_ATTRS;
	xmlSubstituteEntitiesDefault(1);

	/*
	 * initialize libnss
	 */
	NSS_NoDB_Init(".");
	
	/* 
	 * initialize xmlsec
	 */
#ifndef XMLSEC_NO_XSLT
	xmlIndentTreeOutput = 1;
#endif /* XMLSEC_NO_XSLT */

	/* Initialize xmlsec library */
	if(xmlSecInit() < 0) {
		fprintf(stderr, PACKAGE_NAME 
			": xmlsec initialization failed.\n");
		return 1;
	}

	/* Load default crypto engine if we are supporting dynamic 
	 * loading for xmlsec-crypto libraries. Use the crypto library
	 * name ("openssl", "nss", etc.) to load corresponding 
	 * xmlsec-crypto library 
	 */
#ifdef XMLSEC_CRYPTO_DYNAMIC_LOADING
	if(xmlSecCryptoDLLoadLibrary(BAD_CAST XMLSEC_CRYPTO) < 0) {
		fprintf(stderr, PACKAGE_NAME
			": unable to load default xmlsec-crypto library.\n");
		return 1;
	}
#endif /* XMLSEC_CRYPTO_DYNAMIC_LOADING */

	if(xmlSecCryptoAppInit(NULL) < 0) {
		fprintf(stderr, PACKAGE_NAME
			": xmlsec initialization failed.\n");
		return 1;
	}

	if(xmlSecCryptoInit() < 0) {
		fprintf(stderr, PACKAGE_NAME
			": xmlsec-crypto initialization failed.\n");
		return 1;
	}

	return 0;
}
