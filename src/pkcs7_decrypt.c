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

#include "config.h"
#include "context.h"

#include <WWWUtil.h>

/* FIXME: is this correct? */
#include <mozilla/nss/nss.h>
#include <mozilla/nss/pk11func.h>
#include <mozilla/nss/secpkcs7.h>

#include <geier.h>

#include "pkcs7_decrypt.h"



/* Callback from PKCS#7 decoder asking for decryption key */
static PK11SymKey *get_decryption_key(void *arg, SECAlgorithmID *algid);

/* Callback from PKCS#7 decoder asking whether decryption is allowed */
static PRBool allow_decryption(SECAlgorithmID *algid, PK11SymKey *bulkkey);

/* Callback from PKCS#7 decoder delivering decrypted data */
static void accept_data(void *arg, const char *buf, unsigned long len);


/* Decrypt PKCS#7 encrypted content using the session key in the context.
 */
int geier_pkcs7_decrypt(geier_context *context,
			const unsigned char *input, size_t inlen,
			unsigned char **output, size_t *outlen)
{
	int retval = 0;
	SEC_PKCS7ContentInfo *cinfo = NULL;
	HTChunk *out_chunk = HTChunk_new(DEFAULT_HTCHUNK_GROWBY);

	/* FIXME: Initialize NSS globally in init.c? */
	NSS_NoDB_Init(".");

	/* FIXME: factor out key handling */
	CK_MECHANISM_TYPE cm = CKM_DES3_CBC_PAD; /* FIXME: Is this right? */
	PK11SlotInfo* slot = PK11_GetBestSlot(cm, NULL);

	SECItem key_item;
	SECItem data_item;
	PK11SymKey *key = NULL;

	/* FIXME: store PK11SymKey or SECItem in context 
	 * once we use NSS everywhere */
	key_item.type = siBuffer;
	key_item.data = context->session_key;
	key_item.len = context->session_key_len;

	key = PK11_ImportSymKey(slot, cm,
				PK11_OriginUnwrap, /* key is unwrapped */
				CKA_ENCRYPT, /* key for en- and decryption */
				&key_item, NULL);
	if (!key) {
		retval = -1;
		goto exit0;
	}
	data_item.type = siCipherDataBuffer;
	data_item.data = (unsigned char *)input;
	data_item.len = inlen;

	cinfo = SEC_PKCS7DecodeItem(&data_item,
				    accept_data, out_chunk,
				    NULL, NULL,
				    get_decryption_key, key,
				    allow_decryption);
	if (!cinfo) {
		retval = -1;
		goto exit1;
	}
	*outlen = HTChunk_size(out_chunk);
	*output = HTChunk_toCString(out_chunk); /* frees chunk */

	SEC_PKCS7DestroyContentInfo(cinfo);
 exit1:
	PK11_FreeSymKey(key);
 exit0:
	if (retval) { HTChunk_delete(out_chunk); }

	return retval;
}


/* Callback from PKCS#7 decoder asking for decryption key */
static PK11SymKey *get_decryption_key(void *arg, SECAlgorithmID *algid)
{
	return (PK11SymKey *)arg;
}


/* Callback from PKCS#7 decoder asking whether decryption is allowed */
static PRBool allow_decryption(SECAlgorithmID *algid, PK11SymKey *bulkkey)
{
	/* FIXME: should we be more restrictive? */
	return PR_TRUE;
}


/* Callback from PKCS#7 decoder delivering decrypted data */
static void accept_data(void *arg, const char *buf, unsigned long len)
{
	HTChunk_putb((HTChunk *)arg, buf, len);
}
