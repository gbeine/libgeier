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

#include <geier.h>

#include <context.h>
#include <chunk_from_file.h>

#include <pkcs7_decrypt.h>


static unsigned char key1[] = {
	0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
	0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
	0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
};


int main(int argc, char *argv[])
{
	geier_context *context = geier_context_new();
	unsigned char *output = NULL;
	size_t outlen;
	HTChunk *input = NULL;
	HTChunk *expected = NULL;
	int result;

	if (argc != 1) {
		fprintf(stderr, "usage: %s\n", argv[0]);
		exit(1);
	}
	input = chunk_from_file("data/pkcs7/teststring.gzip.pkcs7-encrypted");
	expected = chunk_from_file("data/pkcs7/teststring.gzip");

	if (!input) {
		fprintf(stderr, "Loading input failed\n");
		exit(2);
	}
	if (!expected) {
		fprintf(stderr, "Loading expected failed\n");
		exit(2);
	}

	/* do encryption */
	context->session_key = key1;
	context->session_key_len = sizeof(key1);

	result = geier_pkcs7_decrypt(context,
				     HTChunk_data(input), HTChunk_size(input),
				     &output, &outlen);

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
			FILE *f = fopen("test_pkcs7_decrypt.result","w");
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
		}
		return 1;
	}
	return 0;
}
