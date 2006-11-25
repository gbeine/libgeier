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
#include <geierversion.h>

#include "context.h"
#include "find_node.h"

#include <stdio.h>
#include <argp.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <assert.h>
#include <unistd.h>

#include <sys/stat.h>

#include <libxml/tree.h>

/* documentation, written out when called with either --usage or --help */
const char *argp_program_version = 
"Geier Command Line Interface (" PACKAGE_NAME ") " PACKAGE_VERSION "\n"
"Copyright (C) 2005 Stefan Siegl <ssiegl@gmx.de>, Germany\n"
"This is free software; see the source for copying conditions.  There is NO\n"
"warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
"\n";

static char *args_doc = "[FILE]...";
static char *doc =
"Geier Command Line Interface\v"
"Please mind that " PACKAGE_NAME " is currently very much in alpha alike "
"state, therefore please do not expect a tool working perfectly right now.\n\n"
PACKAGE_NAME " will try to transmit the provided XML document to the German "
"Inland Revenue Office, optionally validating it against provided XML "
"schema.";

/* options our libgeier interface understands, to be used by libc argp */
enum 
{
	OPT_VALIDATE = 'v',
	OPT_DRY_RUN = 'd',
	OPT_XSLTIFY = 'x',
	OPT_ENCRYPT_ONLY = 'e',
	OPT_SOFTPSE = 's',

	OPT_DUMP = 'D' | 0x7f,
};

static const struct argp_option geier_cli_options[] =
{ 
	{ "validate", OPT_VALIDATE, NULL, 0,
	  "validate document before sending to the inland revenue office", 0 },
	{ "dry-run", OPT_DRY_RUN, NULL, 0,
	  "don't send data to the inland revenue office", 0 },
	{ "xsltify", OPT_XSLTIFY, NULL, 0,
	  "process output with xslt stylesheet, to generate HTML output", 0 },
	{ "encrypt-only", OPT_ENCRYPT_ONLY, NULL, 0,
	  "encrypt the provided Coala XML only, nothing more", 0 },
	{ "softpse", OPT_SOFTPSE, "FILE", 0,
	  "sign using soft-pse certificate data", 0 },
	{ "dump", OPT_DUMP, "FILE", 0,
	  "dump data to a certain file, after sending them to the IRO", 0 },

	/* terminate list */
	{ NULL, 0, NULL, 0, NULL, 0 }
};



/* runtime settings */
int config_validate = 0;                /* validate document before sending */
int config_dry_run = 0;                 /* dry-run, don't send to IRO */
int config_xsltify = 0;                 /* filter output through xslt */
int config_encrypt_only = 0;            /* only encrypt the provided xml */
char *softpse_filename = NULL;          /* name of software cert file */
char pincode[24];                       /* pincode */
char *config_dump = NULL;               /* dump received xml doc to a 
					 * certain file, after sending */

int exitcode = 0;                       /* the exit code, we're gonna return */


/* function prototypes */
static error_t parse_geier_opts(int key, char *arg, struct argp_state *state);
static void geier_cli_exec(const char *filename, FILE *handle);

int main(int argc, char **argv) 
{
	struct argp argp = {
		geier_cli_options, parse_geier_opts, 
		args_doc, doc, NULL, NULL, NULL
	};

	LIBGEIER_TEST_VERSION;

	if(geier_init(0)) {
		fprintf(stderr, "%s: unable to initialize libgeier\n", *argv);
		return 2;
	}

	/* parse command line parameters, everything will be done out of
	 * the parse_geier_opts function */
	argp_parse(&argp, argc, argv, 0, 0, 0);

	geier_exit();
	return exitcode;
}



static error_t parse_geier_opts(int key, char *arg, struct argp_state *state)
{
	int i;

	switch(key) {
	case OPT_VALIDATE:
		config_validate = 1;
		break;

	case OPT_DRY_RUN:
		config_dry_run = 1;
		break;

	case OPT_XSLTIFY:
		config_xsltify = 1;
		break;

	case OPT_ENCRYPT_ONLY:
		config_encrypt_only = 1;
		config_dry_run = 1;
		break;

	case OPT_SOFTPSE:
		softpse_filename = strdup(arg);
		if(EVP_read_pw_string(pincode, sizeof pincode, 
				      "Enter Soft-PSE PIN:", 0)) {
			fprintf(stderr, "Can't read Password. Sorry.\n");
			return 1;
		}
		break;

	case OPT_DUMP:
		config_dump = strdup(arg);
		break;

	case ARGP_KEY_ARGS:
		for(i = state->next; i < state->argc; i ++) {
			FILE *handle = fopen(state->argv[i], "r");
			
			if(handle) {
				geier_cli_exec(state->argv[i], handle);
				fclose(handle);
			} else
				perror(state->argv[i]);
		}
		break;

	case ARGP_KEY_NO_ARGS:
		geier_cli_exec("<stdin>", stdin);
		break;

	default:
		return ARGP_ERR_UNKNOWN;
	}
	
	return 0;
}


static void geier_cli_exec(const char *filename, FILE *handle)
{
	xmlDoc *doc = NULL;
	size_t buf_len = 0;
	size_t buf_alloc = 4096;
	unsigned char *buf = malloc(buf_alloc);

	assert(handle);

	for(;;) {
		if(! buf) {
			perror(PACKAGE_NAME);
			exitcode = 2;

			goto out;
		}

		size_t bytes_read = fread(&buf[buf_len], 1,
					  buf_alloc - buf_len, handle);

		buf_len += bytes_read;

		if(bytes_read == 0) {
			if(ferror(handle)) {
				perror(filename);
				exitcode = 1;

				goto out;
			}

			break;
		}

		if(buf_alloc == buf_len) {
			buf_alloc <<= 1;
			buf = realloc(buf, buf_alloc);
		}
	}

	/*
	 * initialize context 
	 */
	geier_context *context = geier_context_new();
	if(! context) {
		fprintf(stderr, "%s: unable to initialize geier context\n",
			filename);
		exitcode = 1;

		goto out;
	}

	/*
	 * check the namespace of the document 
	 */
	if(geier_text_to_xml(context, buf, buf_len, &doc)) {
		fprintf(stderr, "%s: cannot parse xml document\n", filename);
		exitcode = 1;
		goto out;
	}

	xmlNode *node;
	if(find_node(doc, "/elster:Elster", &node)) {
		fprintf(stderr, "%s: cannot find Elster node\n", filename);
		exitcode = 1;
		goto out;
	}

	if(! node->nsDef) {
		fprintf(stderr, "%s: namespace not declared\n", filename);
		exitcode = 1;
		goto out;
	}

	if(node->nsDef->prefix) {
		fprintf(stderr, "%s: Elster node has prefix `%s' assigned, "
			"clearing host does not accept prefixses though\n",
			filename, node->nsDef->prefix);
		exitcode = 1;
		goto out;
	}

	/*
	 * validate the document against the schema file
	 */
	if(config_validate) {
		if(geier_validate_text(context, geier_format_unencrypted,
				       buf, buf_len)) {
			fprintf(stderr, "%s: does not validate against "
				"schema file\n", filename);
			exitcode = 1;
			
			goto out;
		}
	}

#ifdef GEIER_ENABLE_DSIG
	if(softpse_filename) {
		unsigned char *obuf;
		size_t olen;

		if(geier_dsig_sign_text(context, buf, buf_len, &obuf, &olen,
					softpse_filename, pincode)) {
			fprintf(stderr, "%s: cannot sign document.\n",
				filename);
			exitcode = 1;

			goto out;
		}

		free(buf);

		buf = obuf;
		buf_len = olen;
	}
#endif

	if(config_encrypt_only) {
		/** user requests to do nothing but encrypt and return */
		unsigned char *obuf;
		size_t olen;

		if(geier_encrypt_text(context, buf, buf_len, &obuf, &olen)) {
			fprintf(stderr, "%s: cannot encrypt document.\n",
				filename);
			exitcode = 1;

			goto out;
		}

		free(buf);

		buf = obuf;
		buf_len = olen;
	}

	if(! config_dry_run) {
		unsigned char *obuf;
		size_t olen;

		if(geier_send_text(context, buf, buf_len, &obuf, &olen)) {
			fprintf(stderr, "%s: cannot send document to IRO.\n",
				filename);
			exitcode = 1;

			goto out;
		}

		free(buf);

		buf = obuf;
		buf_len = olen;
	}

	if(config_dump) {
		/* debug dump the received data */
		int fd = open(config_dump, O_WRONLY | O_CREAT |
			      O_TRUNC, S_IRUSR);
		if(! fd) {
			fprintf(stderr, "%s: unable to open dump file\n",
				config_dump);
			exitcode = 1;

			goto out;
		}

		if(write(fd, buf, buf_len) != buf_len)
			perror(config_dump);

		close(fd);
	}

	/* seek for error messages from the clearing host */
	char *clearing_err = 
		config_dry_run ? NULL : 
		geier_get_clearing_error_text(context, buf, buf_len);

	if(clearing_err) {
		fprintf(stderr, "%s: error from clearing host: %s\n",
			filename, clearing_err);

		free(clearing_err);
		exitcode = 1;
	}

	if(config_xsltify) {
		/* finally mangle output through xslt thingy ... */
		unsigned char *obuf;
		size_t olen;

		if(geier_xsltify_text(context, buf, buf_len, &obuf, &olen)) {
			fprintf(stderr, "%s: unable to xsltify document.\n",
				filename);
			exitcode = 1;
			
			goto out;
		}

		free(buf);

		buf = obuf;
		buf_len = olen;
	}

	if(write(1, buf, buf_len) != buf_len)
		perror(config_dump);

 out:
	if(doc) xmlFreeDoc(doc);
	if(context) geier_context_free(context);
	free(buf);
}
