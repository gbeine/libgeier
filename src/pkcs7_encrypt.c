/*
 * Copyright (C) 2004,2005,2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
 *               2005  Jürgen Stuber <juergen@jstuber.net>, Germany
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

#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>

#include <geier.h>

/* Mozilla header files */
#include <nss/nss.h>
#include <nss/cert.h>
#include <nss/secpkcs7.h>
#include <nss/pk11func.h>

#include "context.h"
#include "pkcs7_encrypt.h"
#include "encoder.h"
#include "globals.h"

/* XXX free cinfo on error, maybe others as well */
static SEC_PKCS7ContentInfo *
geier_create_content_info(void)
{
	/*
	 * sec_pkcs7_create_content_info is not available externally,
	 * therefore let's use SEC_PKCS7CreateData and overwrite thing manually
	 */
	SEC_PKCS7ContentInfo *cinfo = SEC_PKCS7CreateData ();

	if (cinfo == NULL)
		return NULL;

	/*
	 * change content type from OID data to enveloped-data
	 */
	cinfo->contentTypeTag =
		SECOID_FindOIDByTag (SEC_OID_PKCS7_ENVELOPED_DATA);
	PORT_Assert (cinfo->contentTypeTag
		     && cinfo->contentTypeTag->offset == kind);
	SECStatus rv = SECITEM_CopyItem (cinfo->poolp, &(cinfo->contentType),
					 &(cinfo->contentTypeTag->oid));
	if (rv != SECSuccess)
		return NULL;

	/*
	 * how to free the data structure which has been created?
	 */
	void *thing = PORT_ArenaZAlloc
		(cinfo->poolp, sizeof(SEC_PKCS7EnvelopedData));

	/*
	 * imitate sec_pkcs7_init_content_info
	 */
	cinfo->content.envelopedData = (SEC_PKCS7EnvelopedData*)thing;
	SECItem *versionp = &(cinfo->content.envelopedData->version);
	int version = SEC_PKCS7_ENVELOPED_DATA_VERSION;

	if (thing == NULL)
		return NULL;

	if (versionp != NULL) {
		SECItem *dummy;

		PORT_Assert (version >= 0);
		dummy = SEC_ASN1EncodeInteger(cinfo->poolp, versionp, version);

		if (dummy == NULL)
			return NULL;

		PORT_Assert (dummy == versionp);
	}

	return cinfo;
}



static SECStatus
sec_pkcs7_add_recipient (SEC_PKCS7ContentInfo *cinfo,
			 CERTCertificate *cert)
{
	//recipientinfo, **recipientinfos, ***recipientinfosp;
	//SECItem *dummy;
	//int count;

	SECOidTag kind = SEC_PKCS7ContentType (cinfo);
	assert(kind == SEC_OID_PKCS7_ENVELOPED_DATA);
	
	SEC_PKCS7EnvelopedData *edp = cinfo->content.envelopedData;
	SEC_PKCS7RecipientInfo ***recipientinfosp = &(edp->recipientInfos);
	
	void *mark = PORT_ArenaMark(cinfo->poolp);

	SEC_PKCS7RecipientInfo *recipientinfo = (SEC_PKCS7RecipientInfo*)
		PORT_ArenaZAlloc(cinfo->poolp, sizeof(SEC_PKCS7RecipientInfo));

	if(recipientinfo == NULL) {
		PORT_ArenaRelease(cinfo->poolp, mark);
		return SECFailure;
	}

	SECItem *dummy =
		SEC_ASN1EncodeInteger(cinfo->poolp, &recipientinfo->version,
				      SEC_PKCS7_RECIPIENT_INFO_VERSION);
	if (dummy == NULL) {
		PORT_ArenaRelease (cinfo->poolp, mark);
		return SECFailure;
	}

	PORT_Assert (dummy == &recipientinfo->version);

	recipientinfo->cert = CERT_DupCertificate (cert);
	if (recipientinfo->cert == NULL) {
		PORT_ArenaRelease (cinfo->poolp, mark);
		return SECFailure;
	}

	recipientinfo->issuerAndSN =
		CERT_GetCertIssuerAndSN (cinfo->poolp, cert);
	if (recipientinfo->issuerAndSN == NULL) {
		PORT_ArenaRelease (cinfo->poolp, mark);
		return SECFailure;
	}


	/*
	 * Okay, now recipientinfo is all set.  We just need to put it into
	 * the main structure.
	 *
	 * If this is the first recipient, allocate a new recipientinfos array;
	 * otherwise, reallocate the array, making room for the new entry.
	 */
	SEC_PKCS7RecipientInfo **recipientinfos = *recipientinfosp;
	int count;

	if (recipientinfos == NULL) {
		count = 0;
		recipientinfos = (SEC_PKCS7RecipientInfo **)PORT_ArenaAlloc
			(cinfo->poolp, 2 * sizeof(SEC_PKCS7RecipientInfo *));
	} else {
		for (count = 0; recipientinfos[count] != NULL; count++)
			;
		PORT_Assert (count);	/* should be at least one already */
		recipientinfos = (SEC_PKCS7RecipientInfo **)PORT_ArenaGrow (
			cinfo->poolp, recipientinfos,
			(count + 1) * sizeof(SEC_PKCS7RecipientInfo *),
			(count + 2) * sizeof(SEC_PKCS7RecipientInfo *));
	}

	if (recipientinfos == NULL) {
		PORT_ArenaRelease (cinfo->poolp, mark);
		return SECFailure;
	}

	recipientinfos[count] = recipientinfo;
	recipientinfos[count + 1] = NULL;
	
	*recipientinfosp = recipientinfos;
	
	PORT_ArenaUnmark (cinfo->poolp, mark);
	return SECSuccess;
}



static SECStatus
geier_pkcs7_init_encrypted_content_info(SEC_PKCS7EncryptedContentInfo *enccinfo,
					PRArenaPool *poolp, SECOidTag encalg,
					int keysize)
{
	SECStatus rv;
	
	PORT_Assert (enccinfo != NULL && poolp != NULL);
	if (enccinfo == NULL || poolp == NULL)
		return SECFailure;

	SECOidTag kind = SEC_OID_PKCS7_DATA;

	enccinfo->contentTypeTag = SECOID_FindOIDByTag (kind);
	PORT_Assert (enccinfo->contentTypeTag
		     && enccinfo->contentTypeTag->offset == kind);

	rv = SECITEM_CopyItem (poolp, &(enccinfo->contentType),
			       &(enccinfo->contentTypeTag->oid));

	if (rv != SECSuccess)
		return rv;

	/* Save keysize and algorithm for later. */
	enccinfo->keysize = keysize;
	enccinfo->encalg = encalg;
	
	return SECSuccess;
}



static SEC_PKCS7ContentInfo *
geier_create_enveloped_data (CERTCertificate *cert)
{
	SEC_PKCS7ContentInfo *cinfo = geier_create_content_info();
	SECStatus rv = sec_pkcs7_add_recipient(cinfo, cert);

	if (rv != SECSuccess) {
		SEC_PKCS7DestroyContentInfo (cinfo);
		return NULL;
	}

	SEC_PKCS7EnvelopedData *envd = cinfo->content.envelopedData;
	PORT_Assert (envd != NULL);

	/*
	 * XXX Might we want to allow content types other than data?
	 * If so, via what interface?
	 */
	rv = geier_pkcs7_init_encrypted_content_info
		(&(envd->encContentInfo), cinfo->poolp,
		 SEC_OID_DES_EDE3_CBC, 0);

	if (rv != SECSuccess) {
		SEC_PKCS7DestroyContentInfo (cinfo);
		return NULL;
	}

	/* XXX Anything more to do here? */

	return cinfo;
}



static CERTCertificate *geier_encrypt_get_cert(const char *filename)
{
	char buf[4096];

	/* open file holding certificate  */
	FILE *handle = fopen(filename, "r");
	
	if (!handle) {
		/* perror(PACKAGE_NAME);	 */
		return NULL;
	}

	int len = fread(buf, 1, sizeof(buf), handle);
	if(len < 1) {
		fclose(handle);
		return NULL;
	}

	assert(len < (int) sizeof(buf));
	fclose(handle);

	CERTCertificate *cert = CERT_DecodeCertFromPackage(buf, len);
	if(! cert) {
		fprintf(stderr, "unable to load certificate.\n");
		return NULL;
	}

	return cert;
}


static PK11SymKey *
geier_pkcs7_encryption_key(geier_context *ctx)
{
	assert(ctx);

	if(! ctx->session_key) {
		ctx->session_key_len = 24;
		ctx->session_key = malloc(ctx->session_key_len);

		SECStatus rv;
		rv = PK11_GenerateRandom(ctx->session_key,
					 ctx->session_key_len);
		if (rv != SECSuccess) 
			return NULL;

		if(geier_debug) {
			fprintf(stderr, PACKAGE_NAME ": new session key: \n");
			int i;
			for (i = 0; i < ctx->session_key_len; i ++)
				fprintf(stderr, "%02x ", ctx->session_key[i]);
			fprintf(stderr, "\n");
		}
	}

        CK_MECHANISM_TYPE cm = CKM_DES3_CBC_PAD; /* FIXME: Is this right? */
        PK11SlotInfo* slot = PK11_GetBestSlot(cm, NULL);

	/* FIXME: store PK11SymKey or SECItem in ctx 
	 * once we use NSS everywhere */
	SECItem key_item;
	key_item.type = siBuffer;
	key_item.data = ctx->session_key;
	key_item.len = ctx->session_key_len;

	PK11SymKey *key = PK11_ImportSymKey
		(slot, cm, PK11_OriginUnwrap, CKA_ENCRYPT, &key_item, NULL);

	return key;
}



/* Do PKCS#7 public key crypto (encrypting inlen bytes from *input on)
 * and apply our ASN.1 patch. Return result in **output, a buffer of length
 * *outlen bytes, allocated with malloc().
 *
 * Return: 0 on success, **output and *outlen are only valid in case of success
 * 
 * Caller has to call free() on **output buffer
 */
int geier_pkcs7_encrypt(geier_context *context,
			const unsigned char *input, size_t inlen,
			unsigned char **output, size_t *outlen)
{
	int retval = -1;

	if (!context || !context->cert_filename || !output || !outlen) 
		goto exit0;

	CERTCertificate *cert = geier_encrypt_get_cert(context->cert_filename);
	if (!cert)
		goto exit1;

	SEC_PKCS7ContentInfo *cinfo = geier_create_enveloped_data(cert);
	if (!cinfo)
		goto exit2;

	PK11SymKey *bulkkey = geier_pkcs7_encryption_key(context);
	if (!bulkkey)
		goto exit3;

	/* SECStatus rv =
	 *   SEC_PKCS7SetContent(cinfo, (const char *) input, inlen);
	 * if (rv != SECSuccess)
	 *   goto exit4;
	 */

	context->encoder_buf_ptr = NULL;
	context->encoder_buf_len = 0;
	context->encoder_buf_alloc = 0;

	SEC_PKCS7EncoderContext *ecx = SEC_PKCS7EncoderStart
		(cinfo, geier_encoder, context, bulkkey);

	if (ecx == NULL) 
		goto exit4;

	/* 
	 * SECItem *p7item = SEC_PKCS7EncodeItem(NULL, NULL, cinfo, bulkkey,
	 * NULL, NULL);
	 * if (!p7item)
	 *	goto exit4;
	 */

	SECStatus rv;
	rv = SEC_PKCS7EncoderUpdate(ecx, (const char *) input, inlen);
	if (rv != SECSuccess)
		goto exit5;

	rv = SEC_PKCS7EncoderFinish(ecx, NULL, NULL);
	if (rv != SECSuccess)
		goto exit5;

	ecx = NULL;

	*output = (unsigned char *) context->encoder_buf_ptr;
	*outlen = context->encoder_buf_len;
	retval = 0;

exit5:
	/* finish encoder, if ecx still set 
	 * free ecx, if not NULL */
exit4:
	/* free bulkkey */
exit3:
	/* free cinfo */
exit2:
	/* free cert */
exit1:
exit0:
	return retval;
}



