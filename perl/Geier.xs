/*
 * Copyright (C) 2005  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include <geier.h>

typedef geier_context * Geier_context;

MODULE = Geier 		PACKAGE = Geier		




int
init(debug)
	int debug
    CODE:
	RETVAL = geier_init(debug);
    OUTPUT:
	RETVAL


	
int
exit()
    CODE:
	RETVAL = geier_exit();
    OUTPUT:
	RETVAL


	
Geier_context
context_new()
    CODE:
	RETVAL = geier_context_new();
    OUTPUT:
	RETVAL


	
void
context_free(context)
	Geier_context context;
    CODE:
	geier_context_free(context);


	
SV *
_encrypt(context, indata)
	Geier_context context;
	SV *indata;
    INIT:
	const unsigned char *input;
	unsigned char *output;
	size_t inlen, outlen;
	int result;
	
    CODE:
	input = (const unsigned char *) SvPV(indata, inlen);
	
	result = geier_encrypt_text(context, input, inlen, &output, &outlen);
	if(result) {
	    // FIXME, return error number somewhere in $! or so ...
	    XSRETURN_UNDEF;
	}

	RETVAL = newSVpvn((char *) output, outlen);
	free(output);
	
    OUTPUT:
	RETVAL


	
SV *
_send_encrypted(context, indata)
	Geier_context context;
	SV *indata;
    INIT:
	const unsigned char *input;
	unsigned char *output;
	size_t inlen, outlen;
	int result;
	
    CODE:
	input = (const unsigned char *) SvPV(indata, inlen);
	
	result = geier_send_encrypted_text(context, input, inlen, 
					   &output, &outlen);
	if(result) {
	    // FIXME, return error number somewhere in $! or so ...
	    XSRETURN_UNDEF;
	}

	RETVAL = newSVpvn((char *) output, outlen);
	free(output);
	
    OUTPUT:
	RETVAL



SV *
_send(context, indata)
        Geier_context context;
	SV *indata;
    INIT:
	const unsigned char *input;
	unsigned char *output;
	size_t inlen, outlen;
	int result;
	
    CODE:
	input = (const unsigned char *) SvPV(indata, inlen);
	
	result = geier_send_text(context, input, inlen, &output, &outlen);
	if(result) {
	    // FIXME, return error number somewhere in $! or so ...
	    XSRETURN_UNDEF;
	}

	RETVAL = newSVpvn((char *) output, outlen);
	free(output);
	
    OUTPUT:
	RETVAL



#// FIXME _validate assumes that `indata' is unencrypted, add some kind 
#//       of flag here, like real geier's function has one ...
#//
int
_validate(context, indata)
	Geier_context context;
	SV *indata;
    INIT:
	const unsigned char *input;
	size_t inlen;
	
    CODE:
	input = (const unsigned char *) SvPV(indata, inlen);
	
	RETVAL = geier_validate_text(context, geier_format_unencrypted, 
		                     input, inlen);
	
    OUTPUT:
	RETVAL


SV *
_xsltify(context, indata)
        Geier_context context;
	SV *indata;
    INIT:
	const unsigned char *input;
	unsigned char *output;
	size_t inlen, outlen;
	int result;
	
    CODE:
	input = (const unsigned char *) SvPV(indata, inlen);
	
	result = geier_xsltify_text(context, input, inlen, &output, &outlen);
	if(result) {
	    // FIXME, return error number somewhere in $! or so ...
	    XSRETURN_UNDEF;
	}

	RETVAL = newSVpvn((char *) output, outlen);
	free(output);
	
    OUTPUT:
	RETVAL

	
SV *
_get_clearing_error(context, indata)
	Geier_context context;
	SV *indata;
    INIT:
	const unsigned char *input;
	size_t inlen;
	char *message;
	
    CODE:
	input = (const unsigned char *) SvPV(indata, inlen);
	
	message = geier_get_clearing_error_text(context, input, inlen);
	if(! message)
	    XSRETURN_UNDEF;
	    
	RETVAL = newSVpv(message, 0);
	free(message);
	
    OUTPUT:
	RETVAL


