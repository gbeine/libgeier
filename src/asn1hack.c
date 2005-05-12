/*
 * Copyright (C) 2005  Stefan Siegl <ssiegl@gmx.de>, Germany
 *               2005  Juergen Stuber <juergen@jstuber.net>, Germany
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
 *
 */

/* The output of OpenSSL PKCS#7 encryption may be incorrect,
 * an OCTET STRING around the encrypted data is missing as of 0.9.7e.
 * We patch it in here.
 */

#include <stdio.h>
#include <errno.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>

#include "asn1hack.h"



/* forward declaration of asn1hack_stack type */
typedef struct _asn1hack_stack asn1hack_stack;



/* function type called for each stack level in asn1hack_stack */
typedef int (*asn1hack_stack_callee)(const unsigned char *input,
				     size_t inlen, unsigned char *output,
				     size_t *outlen,
				     const asn1hack_stack *patch);



/* skip ASN.1 element and look for next sub element (next stack level) */
static int asn1hack_forward(const unsigned char *input, size_t inlen,
			    unsigned char *output, size_t *outlen,
			    const asn1hack_stack *stack_level);

/* patch ASN.1 element and return */
static int asn1hack_do_octet_string_patch(const unsigned char *input,
					  size_t inlen, unsigned char *output,
					  size_t *outlen,
					  const asn1hack_stack *stack_level);

/* return the length of the encoding of len, including specifier */
static int len_to_llen(size_t len);

/* read length of ASN.1 element */
static int get_len(const unsigned char *asn1_buf_ptr);

/* write length of ASN.1 element */
static void set_len(unsigned char *asn1_len_ptr, int new_length);

/* return the length of this ASN.1 element's header */
#define head_len(a) (lenspec_len(&(a)[1]) + 1)

/* return the length of this ASN.1 lenspec */
#define lenspec_len(a) ( 1 + (*(a) <= 0x80 ? 0 : *(a) - 0x80) )



/* hackstack definitions */
struct _asn1hack_stack{
	unsigned char asn1_type_id;
	asn1hack_stack_callee callee;
};

static asn1hack_stack asn1hack_octet_string_patch[] = {
	{ 0x30 /* root sequence           */, asn1hack_forward },
	{ 0xA0 /* [0] tag                 */, asn1hack_forward },
	{ 0x30 /* envelope sequence       */, asn1hack_forward },
	{ 0x30 /* enc.data sequence       */, asn1hack_do_octet_string_patch },
	{ 0x80 /* [0] holding enc.data    */, NULL }
};



int geier_asn1hack(const unsigned char *input, size_t inlen,
		   unsigned char **output, size_t *outlen)
{
	if(!input || !output || !outlen) return -1;

	/* apply octet_string_patch ... */
	size_t depth = sizeof(asn1hack_octet_string_patch) /
		sizeof(asn1hack_stack);

	/* make room for inlen characters, plus four extra for each level,
	 * (this is the maximum amount of bytes, the struct may grow by,
	 * from undef (1 byte) to (0x84 + 4 len. bytes)) 
	 * plus 6 extra bytes for OCTET_STRING patch
	 */
	*outlen = inlen + 4 * depth + 6;
	if(! (*output = malloc(*outlen))) return -ENOMEM;

	return asn1hack_forward(input, inlen, *output, outlen, 
				asn1hack_octet_string_patch);
}



/* apply level of the hack stack and try to recurse... 
 * return 0 on success, error number on failure */
static int asn1hack_forward(const unsigned char *input, size_t inlen,
			    unsigned char *output, size_t *outlen,
			    const asn1hack_stack *patch)
{
	int patched = 0;
	assert(input && output && outlen);
	assert(input[0] == patch->asn1_type_id);

	*outlen = 0;

	/* leave element type untouched ... */
	*output = *input;

	/* store a pointer, where the length spec shall be written out to,
	 * this needs to be done after our children were touched, however  */
	unsigned char *lenspec_ptr = &output[1];

	/* skip the header for the time being ... */
	inlen -= head_len(input);
	input += head_len(input);

	output += 6; /* maximum length, we may need */

	for(; inlen;) {
		size_t el_len = input[1] == 0x80 ? inlen :
			(get_len(&input[1]) + head_len(input));

		if(! patched && *input == patch[1].asn1_type_id) {
			/* we need to further cope with this ASN.1 element */
			size_t el_len_new;

			if(patch->callee(input, el_len, output, &el_len_new,
					 &patch[1]))
				return -1; /* damn. */
			
			input += el_len;
			inlen -= el_len;
			output += el_len_new;
			*outlen += el_len_new;

			patch ++; /* apply patch only once per level */

		} else {
			/* just copy this field, it's of no interest for us */
			memmove(output, input, el_len);

			input += el_len;
			inlen -= el_len;
			output += el_len;
			*outlen += el_len;
		}
	}

	set_len(lenspec_ptr, *outlen);

	if(lenspec_len(lenspec_ptr) < 5)
		memmove(lenspec_ptr + lenspec_len(lenspec_ptr),
			lenspec_ptr + 5, *outlen);

	*outlen += 1 + lenspec_len(lenspec_ptr);
	return 0;	
}



/* return the length of the encoding of len, including specifier */
static int len_to_llen(size_t len)
{
	return len < 0x80 ? 1 :
		len < 0x100 ? 2 :
		len < 0x10000 ? 3 :
		len < 0x1000000 ? 4 :
		5;
}



/* read length of ASN.1 element reference
 * buf points to the beginning of the length specifier
 * returns length up to 2^32-1 (FIXME: this is ambiguous with -1)
 *         -1 on failure
 */
static int get_len(const unsigned char *buf)
{
	unsigned char spec = *buf;

	if (!(spec & 0x80)) {
		return spec;
	}
	else if (spec == 0x80) {
		goto exit0;	/* can't handle unspecified length */
	}
	else {
		unsigned char llen = spec & 0x7f;
		int len = 0;
		int i;

		if (llen > 4) {	/* can't handle length >= 2^32 */
			fprintf(stderr, "get_len: llen %d too big\n", llen);
			goto exit1;
		}
		for (i=0; i<llen; i++) {
			len = (len << 8) | buf[i+1];
		}
		return len;
	}
	
 exit1:
 exit0:
	fprintf(stderr, "get_len: can't handle length specifier '0x%02x'\n", spec);
	return -1; /* failing */
}



/* write length of ASN.1 element */
static void set_len(unsigned char *buf, int new_length) 
{
	size_t llen = len_to_llen(new_length);

	if (llen == 1) {
		buf[0] = (unsigned char)new_length;
	}
	else {
		int i;

		buf[0] = (unsigned char)(0x80 | (llen-1));
		for (i=1; i<llen; i++) {
			buf[i] = (unsigned char)
				(new_length >> (8 * (llen-i-1))) & 0xff;
		}
	}
}



/* patch ASN.1 element and return */
static int asn1hack_do_octet_string_patch(const unsigned char *input,
					  size_t inlen, unsigned char *output,
					  size_t *outlen,
					  const asn1hack_stack *stack_level)
{
	/* at asn1_buf_ptr there should be something like
	 * 0x80 <LENSPEC> 0x?? 0x??   --> [0] <CONTENT>
	 *
	 * replace this by
	 * 0xA0 <LENSPEC> 0x04 <LENSPEC> 0x?? 0x?? 
	 *                             -> [0] OCTET_STRING <CONTENT>
	 */

	assert(input && output && outlen);
	assert(*input == 0x80);

	size_t content_len =
		input[1] == 0x80 ? (inlen - 2) : get_len(&input[1]);

	/* write outer thingy, i.e. [0] struct ... */
	output[0] = 0xA0;
	set_len(&output[1], content_len + len_to_llen(content_len) + 1);

	output += (*outlen = head_len(output));

	/* write the inner OCTET_STRING thingy ... */
	output[0] = 0x04;
	set_len(&output[1], content_len);

	*outlen += head_len(output);
	output += head_len(output);

	/* finally copy the contents ... */
	memmove(output, input + head_len(input), content_len);
	*outlen += content_len;

	return 0;
}
