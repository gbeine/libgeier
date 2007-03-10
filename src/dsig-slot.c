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

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <pk11pub.h>
#include <geier.h>
#include "dsig.h"
#include "context.h"

PK11SlotInfo * 
geier_get_internal_key_slot(void)
{
	PK11SlotInfo *slot = NULL;
	SECStatus rv;
        
	slot = PK11_GetInternalKeySlot();
	if (slot == NULL) {
		fprintf(stderr, "PK11_GetInternalKeySlot failed.\n");
		return NULL;
	}

	if (PK11_NeedUserInit(slot)) {
		rv = PK11_InitPin(slot, NULL, NULL);
		if (rv != SECSuccess) {
			fprintf(stderr, "PK11_InitPin failed.\n");
			return NULL;
		}
	}

	if(PK11_IsLoggedIn(slot, NULL) != PR_TRUE) {
		rv = PK11_Authenticate(slot, PR_TRUE, NULL);
		if (rv != SECSuccess) {
			fprintf(stderr, "PK11_Authenticate failed.\n");
			return NULL;
		}
	}

	return(slot);
}
