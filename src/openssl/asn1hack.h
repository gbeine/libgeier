/*
 * Copyright (C) 2005  Stefan Siegl <ssiegl@gmx.de>, Germany
 *               2005  Juergen Stuber <juergen@jstuber.net>, Germany
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
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

/* The output of OpenSSL PKCS#7 encryption may be incorrect,
 * an OCTET STRING around the encrypted data is missing as of 0.9.7e.
 * We patch it in here.
 */

#ifndef GEIER_ASN1HACK_H
#define GEIER_ASN1HACK_H

int geier_asn1hack(const unsigned char *input, size_t inlen,
		   unsigned char **output, size_t *outlen);

#endif /* GEIER_ASN1HACK_H */
