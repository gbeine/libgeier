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
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

#include "asn1hack.h"

typedef struct _asn1hack_stack asn1hack_stack;

/* function type called for each stack level in asn1hack_stack */
typedef int (*asn1hack_stack_callee)(asn1hack_stack *level,
				     unsigned char *asn1_buf_ptr,
				     unsigned int asn1_child_len);

struct _asn1hack_stack {
	unsigned char asn1_type_id;
	asn1hack_stack_callee callee;
};


/* skip ASN.1 element and look for next sub element (next stack level) */
static int asn1hack_forward(asn1hack_stack *stack_level,
			    unsigned char *asn1_buf_ptr,
			    unsigned int asn1_child_len);

/* return the length of the encoding of len, including specifier */
static int len_to_llen(size_t len);

/* read length of ASN.1 element */
static int get_len(const unsigned char *asn1_buf_ptr);

/* write length of ASN.1 element */
static void set_len(unsigned char *asn1_len_ptr, int new_length);

/* adjust length of ASN.1 element from old_layer1_clen to new_layer1_clen bytes,
 * where *asn1_len_ptr points to the start of the length specifier
 * RETURN: new_layer1_clen
 */
static int asn1hack_adjust_child_len(unsigned char *asn1_len_ptr,
				     unsigned int old_layer1_clen,
				     unsigned int new_layer1_clen);


/* patch ASN.1 element and return */
static int asn1hack_do_octet_string_patch(asn1hack_stack *stack_level,
					  unsigned char *asn1_buf_ptr,
					  unsigned int asn1_child_len);

asn1hack_stack asn1hack_octet_string_patch[] = {
	{ 0x30 /* root sequence           */, asn1hack_forward },
	{ 0xA0 /* [0] tag                 */, asn1hack_forward },
	{ 0x30 /* envelope sequence       */, asn1hack_forward },
	{ 0x30 /* enc.data sequence       */, asn1hack_forward },
	{ 0x80 /* [0] holding enc.data    */, asn1hack_do_octet_string_patch },
	{ 0x00 /* STOP HERE               */, NULL }
};


int asn1hack_doit(unsigned char *buf)
{
	int retval = 0;
	asn1hack_stack *patch = asn1hack_octet_string_patch;
	size_t len = get_len(buf+1);
	size_t lhead = 1 + len_to_llen(len);

	if (len < 0) {
		retval = -1;
		goto exit0;
	}

	retval = lhead
		+ asn1hack_adjust_child_len(buf+1, 
					    len,
					    asn1hack_forward(patch, buf, len));
 exit0:
	return retval;
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
	/* FIXME: fails if new length needs different space */
	size_t llen = len_to_llen(new_length);

	if (llen == 1) {
		buf[0] = (unsigned char)new_length;
	}
	else {
		int i;

		buf[0] = (unsigned char)(0x80 | (llen-1));
		for (i=1; i<llen; i++) {
			buf[i] = (unsigned char)(new_length >> (8 * (llen-i-1))) & 0xff;
		}
	}
}



/* skip ASN.1 element and look for next sub element (next stack level) */
static int asn1hack_forward(asn1hack_stack *stack_level,
			    unsigned char *asn1_buf_ptr,
			    unsigned int asn1_child_len)
{
	/* asn1_buf_ptr points to the beginning of this ASN.1 element now */

	asn1_buf_ptr ++; /* skip type specifier */
	asn1_buf_ptr += len_to_llen(asn1_child_len); /* skip length specifier */

	/* FIXME even this scanner should care for memory allocation boundaries */
	for(;;) {
		int layer1_clen = get_len(&asn1_buf_ptr[1]);

		if(asn1_buf_ptr[0] == stack_level[1].asn1_type_id) {
			/* found beginning of the child we're looking for */
			int new_layer1_clen = stack_level[1].callee(&stack_level[1],
								    asn1_buf_ptr, layer1_clen);

			if(new_layer1_clen < 0)
				return -1; /* error occured, get outta here */

			if(asn1hack_adjust_child_len(&asn1_buf_ptr[1],
						     layer1_clen, new_layer1_clen) < 0)
				return -1; /* failed. strange thing. */

			return asn1_child_len + new_layer1_clen - layer1_clen;
		}

		/* skip to next child on same level */
		asn1_buf_ptr ++; /* type specifier */
		asn1_buf_ptr += len_to_llen(layer1_clen); /* length specifier */
		asn1_buf_ptr += layer1_clen;
	}
}


static int asn1hack_adjust_child_len(unsigned char *asn1_len_ptr,
				     unsigned int old_layer1_clen,
				     unsigned int new_layer1_clen)
{
	if(old_layer1_clen == new_layer1_clen)
		return new_layer1_clen;

	if(len_to_llen(old_layer1_clen) != len_to_llen(new_layer1_clen)) {
		/* change room for length specifier */
		fprintf(stderr, "don't know how to change room for length spec.\n");
		return -1;
	}

	/* overwrite length of this ASN.1 child */
	set_len(asn1_len_ptr, new_layer1_clen);
	return new_layer1_clen;
}



/* patch ASN.1 element and return */
static int asn1hack_do_octet_string_patch(asn1hack_stack *stack_level,
					  unsigned char *asn1_buf_ptr,
					  unsigned int asn1_child_len)
{
	(void) stack_level;

	/* at asn1_buf_ptr there should be something like
	 * 0x80 0x82 0x?? 0x??   --> [0] <LENGTH>
	 *
	 * replace this by
	 * 0xA0 0x82 0x?? 0x?? 0x04 0x82 0x?? 0x??   -> [0] <LEN> OCTET_STRING <LEN>
	 */
	unsigned char replacement[8], replacement_len = 1;
	unsigned int oldspec_len = 1 + len_to_llen(asn1_child_len);

	/* prepare replacement ASN.1 structure */
	replacement[0] = 0xA0;
	{
		unsigned int el_length = asn1_child_len + (asn1_child_len < 0x80 ? 2 : 4);
		set_len(&replacement[1], el_length);
		replacement_len += len_to_llen(el_length);
	}
	replacement[replacement_len ++] = 0x04; /* OCTET_STRING */
	set_len(&replacement[replacement_len], asn1_child_len);
	replacement_len += len_to_llen(asn1_child_len);

	/* make room for extra chars */
	memmove(&asn1_buf_ptr[oldspec_len] + replacement_len - oldspec_len,
		&asn1_buf_ptr[oldspec_len], asn1_child_len);

	/* overwrite ASN.1 tag with replacement */
	memmove(asn1_buf_ptr, replacement, replacement_len);

	return asn1_child_len + replacement_len - oldspec_len;
}
