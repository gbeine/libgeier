/* encrypt.h
 * Elster/Coala public key crypto routines
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

#ifndef GEIER_ENCRYPT_H
#define GEIER_ENCRYPT_H

/* Do PKCS#7 public key crypto (encrypting inlen bytes from *input on)
 * and apply our ASN.1 patch. Return result in **output, a buffer of length
 * *outlen bytes, allocated with malloc().
 *
 * Return: 0 on success, **output and *outlen are only valid in case of success
 * 
 * Caller has to call free() on **output buffer
 */
int geier_pkcs7_encrypt(const char *cert_filename,
			const geier_session_key *key,
			const unsigned char *input, size_t inlen,
			unsigned char **output, size_t *outlen);

#endif 
