/*
 * Copyright (C) 2005,2006,2007  Stefan Siegl <stesie@brokenpipe.de>, Germany
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
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

#include "config.h"

#include <stdio.h>
#include <errno.h>
#include <assert.h>

#include <geier.h>

/* Mozilla header files */
#include <nss.h>
#include <pk11func.h>
#include <secpkcs7.h>

#include "pkcs7_decrypt.h"
#include "encoder.h"
#include "context.h"
#include "pkcs7_keying.h"


/* Callback from PKCS#7 decoder asking for decryption key */
static PK11SymKey *
get_decryption_key(void *arg, SECAlgorithmID *algid)
{
	(void) algid;

	return (PK11SymKey *)arg;
}



/* Callback from PKCS#7 decoder asking whether decryption is allowed */
static PRBool
allow_decryption(SECAlgorithmID *algid, PK11SymKey *bulkkey)
{
	(void) algid;
	(void) bulkkey;

	return PR_TRUE;
}



/* Decrypt PKCS#7 encrypted content using the session key in the context.
 */
int geier_pkcs7_decrypt(geier_context *context,
			const unsigned char *input, size_t inlen,
			unsigned char **output, size_t *outlen)
{
	int retval = -1;
	SEC_PKCS7ContentInfo *cinfo = NULL;

        PK11SlotInfo* slot = PK11_GetBestSlot(CKM_DES3_CBC_PAD, NULL);
	if (! slot)
		goto exit0a;

	PK11SymKey *key = geier_pkcs7_encryption_key(context, slot);
	if (!key) goto exit0;

	SECItem data_item;
	data_item.type = siCipherDataBuffer;
	data_item.data = (unsigned char *)input;
	data_item.len = inlen;

	context->encoder_buf_ptr = NULL;
	context->encoder_buf_len = 0;
	context->encoder_buf_alloc = 0;

	cinfo = SEC_PKCS7DecodeItem(&data_item,
				    geier_encoder, context,
				    NULL, NULL,
				    get_decryption_key, key,
				    allow_decryption);
	if (! cinfo) {
		retval = -1;
		goto exit1;
	}

	*output = (unsigned char *) context->encoder_buf_ptr;
	*outlen = context->encoder_buf_len;

	context->encoder_buf_ptr = 0;
	retval = 0;

	SEC_PKCS7DestroyContentInfo(cinfo);
 exit1:
	PK11_FreeSymKey(key);
	free(context->encoder_buf_ptr);
	
 exit0:
	PK11_FreeSlot(slot);

 exit0a:
	return retval;
}


