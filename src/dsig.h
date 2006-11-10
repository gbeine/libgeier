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

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <geier.h>
#include <geier-dsig.h>
#include "context.h"

#ifndef GEIER_DSIG_H
#define GEIER_DSIG_H


/* 
 * make sure `ElsterOnline-Portal: ' is in the DatenLieferant field
 */
int geier_dsig_rewrite_datenlieferant(xmlDoc *doc);


/* 
 * replace `NoSig' in `Vorgang' by `Sig'
 */ 
int geier_dsig_rewrite_vorgang(xmlDoc *doc);


/* 
 * perform actual signing process 
 */
int geier_dsig_sign_doit(geier_context *context, xmlDoc **output,
			 const char *softpse, const char *pin);


/*
 * find the attribute `want' from the X509_ATTRIBUTE stack
 *
 * You need to free the returned memory (if not NULL, which means
 * that there is no attribute with that name)
 */
char *geier_dsig_get_attr(STACK_OF(X509_ATTRIBUTE) *attrs, const char *want);



#endif
