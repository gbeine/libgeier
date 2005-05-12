/*
 * Copyright (C) 2005  Stefan Siegl <ssiegl@gmx.de>, Germany
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

	/* initialize context */
	geier_context *context = geier_context_new();
	if(! context) {
		fprintf(stderr, "%s: unable to initialize geier context\n",
			filename);
		exitcode = 1;

		goto out;
	}

	if(geier_text_to_xml(context, buf, buf_len, &doc)) {
		fprintf(stderr, "%s: unable to parse xml\n", filename);
		exitcode = 1;

		goto out;
	}


	if(config_validate) {
		if(geier_validate(context, geier_format_unencrypted, doc)) {
			fprintf(stderr, "%s: does not validate against "
				"schema file\n", filename);
			exitcode = 1;
			
			goto out;
		}
	}


	if(config_encrypt_only) {
		/** user requests to do nothing but encrypt and return */
		xmlDoc *outdoc;
		if(geier_encrypt(context, doc, &outdoc)) {
			fprintf(stderr, "%s: cannot encrypt document.\n",
				filename);
			exitcode = 1;

			goto out;
		}

		xmlFreeDoc(doc);
		doc = outdoc;
	}

	if(! config_dry_run) {
		xmlDoc *outdoc;
		if(geier_send(context, doc, &outdoc)) {
			fprintf(stderr, "%s: cannot send document to IRO.\n",
				filename);
			exitcode = 1;

			goto out;
		}

		xmlFreeDoc(doc);

		doc = outdoc; /* continue with returned document ... */
	}


	if(config_dump) {
		/* debug dump the received data */
		unsigned char *out;
		size_t out_len;

		int fd = open(config_dump, O_WRONLY | O_CREAT |
			      O_TRUNC, S_IRUSR);
		if(! fd) {
			fprintf(stderr, "%s: unable to open dump file",
				config_dump);
			exitcode = 1;

			goto out;
		}

		geier_xml_to_text(context, doc, &out, &out_len);
			
		if(write(fd, out, out_len) != out_len)
			perror(config_dump);

		close(fd);
		free(out);
	}


	if(config_xsltify) {
		/* finally mangle output through xslt thingy ... */
		xmlDoc *outdoc;
		if(geier_xsltify(context, doc, &outdoc)) {
			fprintf(stderr, "%s: unable to xsltify document.\n",
				filename);
			exitcode = 1;
			
			goto out;
		}

		xmlFreeDoc(doc);
		doc = outdoc; /* continue with xsltified document ... */
	}


	/* output the result to stdout for the moment */
	unsigned char *out;
	size_t out_len;

	geier_xml_to_text(context, doc, &out, &out_len);
	if(write(1, out, out_len) != out_len)
		perror(config_dump);

	free(out);
	
 out:
	if(doc) xmlFreeDoc(doc);
	if(context) geier_context_free(context);
	free(buf);
	
}
