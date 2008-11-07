/*
 * Copyright (C) 2006,2007  Stefan Siegl <stesie@brokenpipe.de>, Germany
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
#include <unistd.h>
#include <assert.h>
#include <string.h>

#include <geier.h>

/* Mozilla header files */
#include <nss.h>
#include <secpkcs7.h>
#include <pk11func.h>

#include "context.h"
#include "pkcs7_keying.h"
#include "globals.h"



static int
generate_session_key(geier_context *ctx)
{
	assert(ctx);

	ctx->session_key_len = 24;
	ctx->session_key = malloc(ctx->session_key_len);

	if(! ctx->session_key)
		return -1;

	SECStatus rv = PK11_GenerateRandom(ctx->session_key,
					   ctx->session_key_len);
	if (rv != SECSuccess)
		return -1;

	if(! geier_debug)
		return 0; /* success */

	/*
	 * dump the key out to the debugging user ...
	 */
	fprintf(stderr, PACKAGE_NAME ": new session key: \n");
	unsigned int i;
	for (i = 0; i < ctx->session_key_len; i ++)
		fprintf(stderr, "%02x ", ctx->session_key[i]);
	fprintf(stderr, "\n");

	return 0; /* success */
}



PK11SymKey *
geier_pkcs7_encryption_key(geier_context *ctx, PK11SlotInfo* slot)
{
	assert(ctx);

	/*
	 * generate new session key, if there isn't one already ...
	 */
	if(! ctx->session_key && generate_session_key(ctx))
		return NULL; /* unable to generate new key */

	/*
	 * create PK11SymKey now ...
	 */
	SECItem key_item;
	key_item.type = siBuffer;
	key_item.data = ctx->session_key;
	key_item.len = ctx->session_key_len;

	return PK11_ImportSymKey(slot, CKM_DES3_CBC_PAD, PK11_OriginUnwrap,
				 CKA_ENCRYPT, &key_item, NULL);
}


