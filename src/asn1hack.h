/* asn1hack.h
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
 * Copyleft(C): 2005 by Stefan Siegl <ssiegl@gmx.de>, Germany
 */

#ifndef GEIER_ASN1HACK_H
#define GEIER_ASN1HACK_H

/* hack-stack forward declaration */
struct asn1hack_stack_t;
extern struct asn1hack_stack_t asn1hack_octet_string_patch[];

/* skip ASN.1 element and look for next sub element (next stack level) */
int asn1hack_forward(struct asn1hack_stack_t *stack_level,
			    unsigned char *asn1_buf_ptr,
			    unsigned int asn1_child_len);

/* read length of ASN.1 element */
int asn1hack_get_len(const unsigned char *asn1_buf_ptr);

/* write length of ASN.1 element */
void asn1hack_set_len(unsigned char *asn1_len_ptr, int new_length);

/* adjust length of ASN.1 element from old_layer1_clen to new_layer1_clen bytes,
 * where *asn1_len_ptr points to the start of the length specifier
 * RETURN: new_layer1_clen
 */
int asn1hack_adjust_child_len(unsigned char *asn1_len_ptr,
			      unsigned int old_layer1_clen,
			      unsigned int new_layer1_clen);

/* apply asn1hack patch to buffer 'buf' */
#define asn1hack_doit(stack,buf)					    \
  (asn1hack_adjust_child_len((buf)+1,                                       \
			     asn1hack_get_len((buf)+1),		            \
			     asn1hack_forward(stack, (buf),	            \
					      asn1hack_get_len((buf)+1)))   \
   + (asn1hack_get_len((buf)+1) < 0x80 ? 2 : 4))

#endif /* GEIER_ASN1HACK_H */
