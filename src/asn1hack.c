/* asn1hack.c
 * hack ASN.1 data as put out by openssl and patch for Elster server's to
 * accept, i.e. patch in OCTET_STRING mark
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
 * Copyleft(C): 2004,05 by Stefan Siegl <ssiegl@gmx.de>, Germany
 */

#include <netinet/in.h> /* for ntohs() and htons() */
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

#include "asn1hack.h"

/* function type called for each stack level in asn1hack_stack */
typedef int (*asn1hack_stack_callee)(struct asn1hack_stack_t *level,
				     unsigned char *asn1_buf_ptr,
				     unsigned int asn1_child_len);

/* patch ASN.1 element and return */
static int asn1hack_do_octet_string_patch(struct asn1hack_stack_t *stack_level,
					  unsigned char *asn1_buf_ptr,
					  unsigned int asn1_child_len);

struct asn1hack_stack_t {
  unsigned char asn1_type_id;
  asn1hack_stack_callee callee;
};

struct asn1hack_stack_t asn1hack_octet_string_patch[] = {
  { 0x30 /* root sequence           */, asn1hack_forward },
  { 0xA0 /* [0] tag                 */, asn1hack_forward },
  { 0x30 /* envelope sequence       */, asn1hack_forward },
  { 0x30 /* enc.data sequence       */, asn1hack_forward },
  { 0x80 /* [0] holding enc.data    */, asn1hack_do_octet_string_patch },
  { 0x00 /* STOP HERE               */, NULL }
};

/* read length of ASN.1 element reference by asn1_buf_ptr */
int
asn1hack_get_len(const unsigned char *asn1_buf_ptr)
{
  if(*asn1_buf_ptr == 0x80)
    return -1; /* undefined */

  if(*asn1_buf_ptr < 0x80)
    return *asn1_buf_ptr;

  if(*asn1_buf_ptr == 0x82) {
    uint16_t *integer = (void *) &asn1_buf_ptr[1];
    return ntohs(*integer);
  }

  fprintf(stderr, "asn1hack_get_len: read unknown length specifier '%02x'.\n",
	  *asn1_buf_ptr);
  return -1; /* failing */
}

/* write length of ASN.1 element */
void
asn1hack_set_len(unsigned char *asn1_len_ptr, int new_length) 
{
  if(new_length < 0x80)
    *asn1_len_ptr = (unsigned char)new_length;

  else {
    uint16_t *integer = (void *) &asn1_len_ptr[1];
    *asn1_len_ptr = 0x82; /* 16-bit int in network endianess */
    *integer = htons(new_length);
  }
}



/* skip ASN.1 element and look for next sub element (next stack level) */
int
asn1hack_forward(struct asn1hack_stack_t *stack_level,
		 unsigned char *asn1_buf_ptr,
		 unsigned int asn1_child_len)
{
  /* asn1_buf_ptr points to the beginning of this ASN.1 element now */

  asn1_buf_ptr ++; /* skip type specifier */
  asn1_buf_ptr += asn1_child_len < 0x80 ? 1 : 3; /* skip length specifier */

  /* FIXME even this scanner should care for memory allocation boundaries */
  for(;;) {
    int layer1_clen = asn1hack_get_len(&asn1_buf_ptr[1]);

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
    asn1_buf_ptr += layer1_clen < 0x80 ? 1 : 3; /* length specifier */
    asn1_buf_ptr += layer1_clen;
  }
}


int
asn1hack_adjust_child_len(unsigned char *asn1_len_ptr,
			  unsigned int old_layer1_clen,
			  unsigned int new_layer1_clen)
{
  if(old_layer1_clen == new_layer1_clen)
    return new_layer1_clen;

  if(old_layer1_clen < 0x80 && new_layer1_clen >= 0x80) {
    /* enlarge room for length specifier */
    fprintf(stderr, "don't know how to enlarge room for length spec.\n");
    return -1;
  }

  else if(old_layer1_clen >= 0x80 && new_layer1_clen < 0x80) {
    /* shrink room for length specifier */
    fprintf(stderr, "don't know how to shrink room for length spec.\n");
    return -1;
  }

  /* overwrite length of this ASN.1 child */
  asn1hack_set_len(asn1_len_ptr, new_layer1_clen);
  return new_layer1_clen;
}



/* patch ASN.1 element and return */
static int
asn1hack_do_octet_string_patch(struct asn1hack_stack_t *stack_level,
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
  unsigned int oldspec_len = asn1_child_len < 0x80 ? 2 : 4;

  /* prepare replacement ASN.1 structure */
  replacement[0] = 0xA0;
  {
    unsigned int el_length = asn1_child_len + (asn1_child_len < 0x80 ? 2 : 4);
    asn1hack_set_len(&replacement[1], el_length);
    replacement_len += el_length < 0x80 ? 1 : 3;
  }
  replacement[replacement_len ++] = 0x04; /* OCTET_STRING */
  asn1hack_set_len(&replacement[replacement_len], asn1_child_len);
  replacement_len += asn1_child_len < 0x80 ? 1 : 3;

  /* make room for extra chars */
  memmove(&asn1_buf_ptr[oldspec_len] + replacement_len - oldspec_len,
	  &asn1_buf_ptr[oldspec_len], asn1_child_len);

  /* overwrite ASN.1 tag with replacement */
  memmove(asn1_buf_ptr, replacement, replacement_len);

  return asn1_child_len + replacement_len - oldspec_len;
}
