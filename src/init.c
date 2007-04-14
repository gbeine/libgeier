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

#include "config.h"
#include "globals.h"

#include <geier.h>

#include <libxml/tree.h>
#include <libxml/parser.h>

#ifndef XMLSEC_NO_XSLT
#include <libxslt/xslt.h>
#endif

#include <xmlsec/xmlsec.h>
#include <xmlsec/crypto.h>

#ifdef XMLSEC_CRYPTO_OPENSSL
#include <openssl/engine.h>
#include <openssl/conf.h>
#endif

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

int geier_init(int debug)
{
	/*
	 * set debug level
	 */
	geier_debug = debug;

	const char *env_level_str = getenv("GEIER_DEBUG");
	if (env_level_str) {
		int env_level = atoi (env_level_str);
		if (env_level > geier_debug)
			geier_debug = env_level;
	}


	/*
	 * initialise libxml. Ugly syntax they use. Add ; for indent.
	 */
	xmlInitParser();
	LIBXML_TEST_VERSION;

	xmlLoadExtDtdDefaultValue = XML_DETECT_IDS | XML_COMPLETE_ATTRS;
	xmlSubstituteEntitiesDefault(1);


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

	if(xmlSecCheckVersion() != 1) {
		fprintf(stderr, PACKAGE_NAME ": loaded xmlsec library "
			"version is not compatible.\n");
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



	/*
	 * now initialize the NSS backend, 
	 * create ~/.taxbird/ directory if necessary
	 */
	const char *homedir = getenv("HOME");
	if(! homedir) {
		fprintf(stderr, PACKAGE_NAME ": unable to figure out path to "
			"home directory.\n");
		return 1;
	}

	char *geierdir = malloc(strlen(homedir) + 10);
	if(! geierdir) {
		perror(PACKAGE_NAME);
		return 1;
	}

	sprintf(geierdir, "%s/.taxbird", homedir);

	struct stat geierdir_stat;
	if(stat(geierdir, &geierdir_stat)) {
		if(errno != ENOENT || mkdir(geierdir, 0700) != 0) {
			fprintf(stderr, PACKAGE_NAME ": failed to stat the "
				"taxbird home directory: %s\n", geierdir);
			free(geierdir);
			return 1;
		}
	}

	if(xmlSecCryptoAppInit(geierdir) < 0) {
		fprintf(stderr, PACKAGE_NAME
			": xmlsec crypto initialization failed.\n");
		return 1;
	}

	free(geierdir);

	if(xmlSecCryptoInit() < 0) {
		fprintf(stderr, PACKAGE_NAME
			": xmlsec-crypto initialization failed.\n");
		return 1;
	}


#ifdef XMLSEC_CRYPTO_OPENSSL
#ifndef OPENSSL_NO_ENGINE
	/*
	 * initialize OpenSSL, if necessary
	 */
	OPENSSL_load_builtin_modules();
	OPENSSL_config("/etc/ssl/openssl.cnf");
	ENGINE_load_dynamic();
#endif /* !OPENSSL_NO_ENGINE */
#endif /* XMLSEC_CRYPTO_OPENSSL */

	return 0;
}
