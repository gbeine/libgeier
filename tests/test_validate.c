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

#include <config.h>

#include <stdio.h>
#include <string.h>

#include <WWWUtil.h>

#include <context.h>

#include <geier.h>


HTChunk *chunk_from_file(const char *filename)
{
	HTChunk *result = HTChunk_new(DEFAULT_HTCHUNK_GROWBY);
	FILE *f;
	unsigned char buf[1024];
	size_t len;

	f = fopen(filename, "r");
	if (!f) { return NULL; }

	while (1) {
		len = fread(&buf, 1, sizeof(buf), f);
		HTChunk_putb(result, buf, len);
		if (len != sizeof(buf)) {
			break;
		}
	}

	if (ferror(f)) {
		perror("");
		HTChunk_delete(result);
		result = NULL;
	}
	return result;
}

int main(int argc, char *argv[])
{
	int retval = 0;
	geier_context *context;
	HTChunk *input = NULL;
	xmlDoc *indoc = NULL;
	int result;

	if (argc != 1) {
		fprintf(stderr, "usage: %s\n", argv[0]);
		exit(1);
	}
	input = chunk_from_file("data/test_ustva_unencrypted.xml");
	if (!input) {
		fprintf(stderr, "Loading input failed\n");
		exit(2);
	}

	/* initialize library */
	result = geier_init(1);
	if (result) { goto exit0; }

	context = geier_context_new();
	if (!context) {
		result = -2;
		goto exit1;
	}
	context->schema_dir_url = "../etc/schemas";

	/* convert to XML */
	result = geier_text_to_xml(context,
				   HTChunk_data(input), HTChunk_size(input),
				   &indoc);
	if (result) { goto exit2; }

	/* do encryption */
 	result = geier_validate(context, geier_format_unencrypted, indoc);
	if (result) { goto exit3; }

	/* wipe out rsa encrypted and base64 encoded keys,
	 * which differ each time due to randomness */
	/* memset(output+202, 0, 256); */
	/* memset(HTChunk_data(expected)+202, 0, 256); */

 exit3:
 exit2:
 exit1:
 exit0:
	/* check result */
	if (result != 0) {
		fprintf(stderr, "result = %d\n", result);
		retval = 1;
	}
	geier_exit();
	return retval;
}
