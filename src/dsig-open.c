/*
 * Copyright (C) 2005, 2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <geier.h>
#include "context.h"
#include "dsig.h"

#include <nss/pk11pub.h>
#include <nss/p12plcy.h>

/*
 * Portions of this file are taken from mozilla libnss, which originally
 * is MPL/GPL dual licensed.  However libgeier is GPL only!
 *
 * The Original Code is the Netscape security libraries.
 *
 * The Initial Developer of the Original Code is Netscape
 * Communications Corporation.  Portions created by Netscape are
 * Copyright (C) 1994-2000 Netscape Communications Corporation.  All
 * Rights Reserved.
 *
 * Portions created by Sun Microsystems, Inc. are Copyright (C) 2003
 * Sun Microsystems, Inc. All Rights Reserved.
 *
 * Contributor(s):
 *      Dr Vipul Gupta <vipul.gupta@sun.com>, Sun Microsystems Laboratories
 */

static SECStatus
SECU_FileToItem(SECItem *dst, PRFileDesc *src)
{
    PRFileInfo info;
    PRInt32 numBytes;
    PRStatus prStatus;

    if (src == PR_STDIN)
	    return SECFailure;

    prStatus = PR_GetOpenFileInfo(src, &info);

    if (prStatus != PR_SUCCESS)
	    return SECFailure;

    /* XXX workaround for 3.1, not all utils zero dst before sending */
    dst->data = 0;
    if (!SECITEM_AllocItem(NULL, dst, info.size))
	goto loser;

    numBytes = PR_Read(src, dst->data, info.size);
    if (numBytes != info.size) 
	goto loser;

    return SECSuccess;

loser:
    SECITEM_FreeItem(dst, PR_FALSE);
    return SECFailure;
}


static SECItem *
geier_nickname_coll_cb(SECItem *old_nick, PRBool *cancel, void *wincx)
{
	fprintf(stderr, PACKAGE_NAME ": nickname collisions in PKCS12 "
		"container.\n");
	return NULL; /* FIXME */
}




SEC_PKCS12DecoderContext *
geier_dsig_open(const char *filename, const char *pincode, int import_bags)
{
	SEC_PKCS12DecoderContext *p12dcx = NULL;
	SECItem p12file = { 0 };
	SECStatus rv = SECFailure;
	
	PK11SlotInfo *slot = geier_get_internal_key_slot();
	if(! slot) {
		fprintf(stderr, PACKAGE_NAME ": unable to get internal "
			"nss slot.\n");
		return NULL;
	}

	/* convert password */
	int pincode_len = strlen(pincode);
	SECItem *pwItem = SECITEM_AllocItem(NULL, NULL,
					    (pincode_len + 1) << 1);
	int i;
	for(i = 0; i <= pincode_len; i ++) {
		pwItem->data[(i << 1) + 0] = 0;
		pwItem->data[(i << 1) + 1] = pincode[i];
	}

	/* init the decoder context */
	p12dcx = SEC_PKCS12DecoderStart(pwItem, slot, NULL, NULL, NULL,
					NULL, NULL, NULL);

	if(!p12dcx) {
		fprintf(stderr, PACKAGE_NAME ": unable to start PKCS12 "
			"decoder.\n");
		goto loser;
	}

	PRFileDesc *handle = PR_Open(filename, PR_RDONLY, 0400);
	if(! handle)
		goto loser;

	/* decode the item */
	rv = SECU_FileToItem(&p12file, handle);
	if (rv != SECSuccess) {
		fprintf(stderr, PACKAGE_NAME ": unable to read from file.\n");
		goto loser;
	}

	rv = SEC_PKCS12DecoderUpdate(p12dcx, p12file.data, p12file.len);
	if(rv != SECSuccess) {
		/* error = PR_GetError();
		 * if(error == SEC_ERROR_DECRYPTION_DISALLOWED) {
		 * 	PR_SetError(error, 0);
		 *	goto loser;
		 * }
		 */

		fprintf(stderr, PACKAGE_NAME ": PKCS12 decoding failed.\n");
	}

	/* does the blob authenticate properly? */
	rv = SEC_PKCS12DecoderVerify(p12dcx);
	if(rv != SECSuccess) {
		fprintf(stderr, PACKAGE_NAME ": PKCS12 blob doesn't "
			"authenticate properly. Maybe the PIN is wrong?\n");
		goto loser;
	}

	if(! import_bags)
		goto out;

	rv = SEC_PKCS12DecoderValidateBags(p12dcx, geier_nickname_coll_cb);
	if(rv != SECSuccess) {
		fprintf(stderr, PACKAGE_NAME ": PKCS12 bags couldn't be "
			"validated successfully.\n");
		goto loser;
	}

	rv = SEC_PKCS12DecoderImportBags(p12dcx);
	if(rv != SECSuccess) {
		fprintf(stderr, PACKAGE_NAME ": PKCS12 bags couldn't be "
			"imported successfully.\n");
		goto loser;
	}

loser:
	if(p12dcx && rv != SECSuccess) {
		SEC_PKCS12DecoderFinish(p12dcx);
		p12dcx = NULL;
	}

 out:
	SECITEM_ZfreeItem(pwItem, PR_TRUE);
	return p12dcx;
}



int
geier_dsig_verify_mac(geier_context *context, 
		      const char *filename, 
		      const char *pincode)
{
        (void) context;

	SEC_PKCS12DecoderContext *p12 = geier_dsig_open(filename, pincode, 0);
	if(! p12) return 1;

	SEC_PKCS12DecoderFinish(p12);
	return 0;
}

