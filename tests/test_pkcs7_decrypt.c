/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
 * Copyright (C) 2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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
#include <fcntl.h>
#include <unistd.h>

#include <geier.h>
#include <context.h>
#include <pkcs7_decrypt.h>


static unsigned char key1[] = {
	0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
	0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
	0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
};


static int
chunk_from_file (const char *filename, unsigned char **output, size_t *outlen) 
{
	int fd = open(filename, O_RDONLY);

	int alloc = 4096, len = 0;
	char *ptr = malloc(alloc);

	int readlen;
	for(;;) {
		if(! ptr) {
			close(fd);
			return -1;
		}

		readlen = read(fd, ptr + len, alloc - len);
		len += readlen;

		if(len < alloc) break;
		alloc <<= 1;

		ptr = realloc(ptr, alloc);
	}
	
	close(fd);
	
	*output = realloc(ptr, len);
	*outlen = len;

	return 0;
}


int main(int argc, char *argv[])
{
	geier_context *context = geier_context_new();
	unsigned char *output = NULL;
	unsigned char *input; size_t inlen;
	unsigned char *expected; size_t expected_len;
	size_t outlen;
	int result;

	geier_init(0);

	if (argc != 1) {
		fprintf(stderr, "usage: %s\n", argv[0]);
		exit(1);
	}
	if(chunk_from_file(TESTDATADIR "/pkcs7/teststring.gzip.pkcs7-encrypted",
			   &input, &inlen)) {
		fprintf(stderr, "Loading input failed\n");
		exit(2);
	}
	if(chunk_from_file(TESTDATADIR "/pkcs7/teststring.gzip",
			   &expected, &expected_len)) {
		fprintf(stderr, "Loading expected failed\n");
		exit(2);
	}

	/* do encryption */
	context->session_key = key1;
	context->session_key_len = sizeof(key1);

	result = geier_pkcs7_decrypt(context, input, inlen, &output, &outlen);

	/* check result */
	if (result != 0
	    || outlen != expected_len
	    || memcmp(expected, output, outlen) != 0) {
		
		int i;
		unsigned char *d = expected;

		fprintf(stderr, "result = %d\n", result);

		fprintf(stderr, "Expected:\n");
		fprintf(stderr, "length = %d\n", expected_len);
		for (i = 0; i < expected_len; i++) {
			fprintf(stderr, " %02x", d[i]);
			if (i % 16 == 15) {
				fprintf(stderr, "\n");
			}
		}
		fprintf(stderr, "\n");

		if (! result) {			
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
