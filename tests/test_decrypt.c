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

/*
static unsigned char iv1[] = {
	0x83, 0x4b, 0x6d, 0xc5, 0xa1, 0xc9, 0x32, 0x4e,
};
*/

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
	geier_context *context = NULL;
	unsigned char *output = NULL;
	size_t outlen;
	HTChunk *input = NULL;
	HTChunk *expected = NULL;
	HTChunk *key = NULL;
	xmlDoc *indoc = NULL;
	xmlDoc *outdoc = NULL;
	int result;

	if (argc != 1) {
		fprintf(stderr, "usage: %s\n", argv[0]);
		exit(1);
	}
	input = chunk_from_file("data/test_ustva_reply_encrypted.xml");
	if (!input) {
		fprintf(stderr, "Loading input failed\n");
		exit(2);
	}
	expected = chunk_from_file("data/test_ustva_reply.xml");
	if (!expected) {
		fprintf(stderr, "Loading expected failed\n");
		exit(2);
	}

	/* initialize library */
	result = geier_init(1);
	if (result) { goto exit; }

	context = geier_context_new();
	if (!context) { result = -2; goto exit;	}

	/* load session key */
	key = chunk_from_file("data/session_key");
	if (!key) {
		fprintf(stderr, "Loading key failed\n");
		exit(2);
	}
	context->session_key = HTChunk_data(key);
	context->session_key_len = HTChunk_size(key);

	/* convert to XML */
	result = geier_text_to_xml(context,
				   HTChunk_data(input), HTChunk_size(input),
				   &indoc);
	if (result) { goto exit; }

	/* do decryption */
 	result = geier_decrypt(context, indoc, &outdoc);
	if (result) { goto exit; }

	/* convert to text */
	result = geier_xml_to_text(context, outdoc, &output, &outlen);
	if (result) { goto exit; }

	/* wipe out rsa encrypted and base64 encoded keys,
	 * which differ each time due to randomness */
	/* memset(output+202, 0, 256); */
	/* memset(HTChunk_data(expected)+202, 0, 256); */

 exit:
	/* check result */
	if (result != 0
	    || outlen != HTChunk_size(expected)
	    || memcmp(HTChunk_data(expected), output, outlen) != 0) {
		
		int i;
		unsigned char *d = HTChunk_data(expected);

		fprintf(stderr, "result = %d\n", result);

		fprintf(stderr, "Expected:\n");
		fprintf(stderr, "length = %d\n", HTChunk_size(expected));
		for (i=0; i<HTChunk_size(expected); i++) {
			fprintf(stderr, " %02x", d[i]);
			if (i%16 == 15) {
				fprintf(stderr, "\n");
			}
		}
		fprintf(stderr, "\n");

		if (!result) {
			/* FIXME: factor out name */
			FILE *f = fopen("test_decrypt.result","w");
			fwrite(output, 1, outlen, f);
			fclose(f);

			fprintf(stderr, "Computed:\n");
			fprintf(stderr, "length = %d\n", outlen);
			for (i=0; i<outlen; i++) {
				fprintf(stderr, " %02x", output[i]);
				if (i%16 == 15) {
					fprintf(stderr, "\n");
				}

			}
			fprintf(stderr, "\n");

			fprintf(stderr, "Session key: ");
			for (i=0; i<24; i++) {
				fprintf(stderr, "%02x", context->session_key[i]);
			}
			fprintf(stderr, "\n");

		}
		return 1;
	}
	geier_exit();
	return 0;
}
