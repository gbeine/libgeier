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

/* Test cases from RFC 3548 */
unsigned char d1[6] = {0x14, 0xfb, 0x9c, 0x03, 0xd9, 0x7e};
unsigned char e1[8] = "FPucA9l+";

unsigned char d2[5] = {0x14, 0xfb, 0x9c, 0x03, 0xd9};
unsigned char e2[8] = "FPucA9k=";

unsigned char d3[4] = {0x14, 0xfb, 0x9c, 0x03};
unsigned char e3[8] = "FPucAw==";

static int test_encode(unsigned char *d, size_t inlen,
		       unsigned char *e, size_t outlen);
static int test_decode(unsigned char *e, size_t inlen,
		       unsigned char *d, size_t outlen);


int main(int argc, char *argv[])
{
	int error_count = 0;

	error_count += test_encode(d1, sizeof(d1), e1, sizeof(e1));
	error_count += test_encode(d2, sizeof(d2), e2, sizeof(e2));
	error_count += test_encode(d3, sizeof(d3), e3, sizeof(e3));

	error_count += test_decode(e1, sizeof(e1), d1, sizeof(d1));
	error_count += test_decode(e2, sizeof(e2), d2, sizeof(d2));
	error_count += test_decode(e3, sizeof(e3), d3, sizeof(d3));

	if (error_count) {
		fprintf(stderr, "%s: %d errors\n", argv[0], error_count);
	}
	return error_count == 0 ? 0 : 1;
}

static int test_encode(unsigned char *d, size_t inlen,
		       unsigned char *e, size_t outlen)
{
	unsigned char *c;
	size_t cl;
	int result;

	result = geier_base64_encode(d, inlen, &c, &cl);
	if (outlen != cl || memcmp(e, c, cl) != 0) {
		int i;

		fprintf(stderr, "Expected: >");
		for (i=0; i<outlen; i++) {
			fprintf(stderr, "%c", e[i]);
		}
		fprintf(stderr, "<\n");

		fprintf(stderr, "result = %d\n", result);
		if (!result) {
			
			fprintf(stderr, "Computed: >");
			for (i=0; i<cl; i++) {
				fprintf(stderr, "%c", c[i]);
			}
			fprintf(stderr, "<\n");
		}
		return 1;
	}
	else {
		return 0;
	}
}


static int test_decode(unsigned char *e, size_t inlen,
		       unsigned char *d, size_t outlen)
{
	unsigned char *c;
	size_t cl;
	int result;

	result = geier_base64_decode(e, inlen, &c, &cl);
	if (outlen != cl || memcmp(d, c, cl) != 0) {
		int i;

		fprintf(stderr, "Expected: >");
		for (i=0; i<outlen; i++) {
			fprintf(stderr, " 0x%02x", d[i]);
		}
		fprintf(stderr, "<\n");

		fprintf(stderr, "result = %d\n", result);

		if (!result) {			
			fprintf(stderr, "Computed: >");
			for (i=0; i<cl; i++) {
				fprintf(stderr, " 0x%02x", c[i]);
			}
			fprintf(stderr, "<\n");
		}
		return 1;
	}
	else {
		return 0;
	}
}
