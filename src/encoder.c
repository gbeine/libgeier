/*
 * Copyright (C) 2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#include <string.h>

#include <geier.h>

#include "encoder.h"
#include "context.h"

void
geier_encoder(void *arg, const char *buf, unsigned long len)
{
	geier_context *ctx = (geier_context *) arg;
	while (ctx->encoder_buf_len + len > ctx->encoder_buf_alloc) {
		if (! ctx->encoder_buf_alloc)
			ctx->encoder_buf_alloc = 4096;
		else
			ctx->encoder_buf_alloc <<= 1;

		ctx->encoder_buf_ptr = realloc (ctx->encoder_buf_ptr,
						ctx->encoder_buf_alloc);
		if (! ctx->encoder_buf_ptr) {
			/* FIXME set PORT error ?? */
			perror(PACKAGE_NAME);
			return;
		}
	}

	memmove (ctx->encoder_buf_ptr + ctx->encoder_buf_len, buf, len);
	ctx->encoder_buf_len += len;
}
