/*
 * Copyright (C) 2005  Stefan Siegl <ssiegl@gmx.de>, Germany
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

#ifndef GEIER_XPATH_H
#define GEIER_XPATH_H

/* Return the content of the node referenced by the given xpath expression.
 * Mind that a new allocated \0-string will be allocated in case of success
 * and that you're responsible for freeing it */
char *elster_xpath_get_content(xmlDoc *doc, const char *xpath);

/* Return the text, associated to the attribute 'attrname' of the
 * node, referenced by the supplied xpath expression. 
 */
const char *elster_xpath_get_attr(xmlDoc *doc, const char *xpath,
				  const char *attrname);


#endif /* GEIER_XPATH_H */
