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

#include <WWWLib.h>
#include <WWWInit.h>

#include "context.h"

#include <geier.h>


static int printer(const char *fmt, va_list args)
{
	return vfprintf(stdout, fmt, args);
}

static int tracer(const char *fmt, va_list args)
{
	return vfprintf(stderr, fmt, args);
}

static int terminate_handler(HTRequest *request,
			     HTResponse *response,
			     void *param,
			     int status) 
{
        /* stop event loop to signal termination */
        HTEventList_stopLoop();

	return YES;
}

int geier_send_encrypted_text(geier_context *context,
			      const unsigned char *input, size_t inlen,
			      unsigned char **output, size_t *outlen)
{
	int retval = 0;
	char *dest_uri = NULL;
	HTRequest *request = NULL;
	HTParentAnchor *src = NULL;
	HTChunk *chunk = NULL;
	HTStream *target = NULL;

	/* set timeout */
	HTHost_setEventTimeout(context->clearing_timeout_ms);

	/* FIXME: balance load between URIs */
	dest_uri = context->clearing_uri_list[context->clearing_uri_index];
	HTPrint("Posting to %s\n", dest_uri);

	/* global setup */
	HTProfile_newNoCacheClient("geier", "0.1");
	HTPrint_setCallback(printer);
	HTTrace_setCallback(tracer);
	HTNet_addAfter(terminate_handler, NULL, NULL, HT_ALL, HT_FILTER_LAST);

	/* setup source anchor */
	src = HTTmpAnchor(NULL);
	HTAnchor_setDocument(src, (unsigned char *)input);
	HTAnchor_setLength(src, inlen);
	HTAnchor_setFormat(src, HTAtom_for("application/xml"));
	
	/* setup request */
	request = HTRequest_new();
	/* send output to chunk (allocated here) */
        target = HTStreamToChunk(request, &chunk, 0);
        HTRequest_setOutputStream(request, target);
	/* FIXME: raw output including headers only for testing */
	HTRequest_setOutputFormat(request, WWW_SOURCE);

	/* close connection immediately */
	HTRequest_addConnection(request, "close", "");
	
	/* send it off and get the result as a chunk */
	if (!HTPostAbsolute(src, dest_uri, request)) {
		HTPrint("Post failed\n");
		retval = -1;
		goto exit0;
	}
	/* call event loop to process request */
	/* stopped by terminate_handler when request done */
	HTEventList_loop(request);
	
	*outlen = HTChunk_size(chunk);
	*output = HTChunk_toCString(chunk); /* frees chunk */

 exit0:
	HTRequest_delete(request);
	HTProfile_delete();

	return retval;
}
