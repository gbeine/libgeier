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

#include <stdio.h>
#include <string.h>

#include <WWWUtil.h>

#include <geier.h>
#include "gzip_deflate.h"


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
	unsigned char *output = NULL;
	size_t outlen;
	HTChunk *input = NULL;
	HTChunk *expected = NULL;
	int result;

	if (argc != 1) {
		fprintf(stderr, "usage: %s\n", argv[0]);
		exit(1);
	}
	input = chunk_from_file("data/pkcs7/teststring");
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
	result = geier_gzip_deflate(HTChunk_data(input), HTChunk_size(input),
				    &output, &outlen);

	/* wipe out known differences */
	memset(output+9, 0, 1);	/* wipe OS (here: unknown) */
	memset(HTChunk_data(expected)+9, 0, 1);

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
			FILE *f = fopen("test_gzip_deflate.result","w");
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
