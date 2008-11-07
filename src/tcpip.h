/**********************************************************
 * tcpip.h
 *
 * Copyright 2004, Stefan Siegl <ssiegl@gmx.de>, Germany
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Publice License,
 * version 3 or any later. The license is contained in the COPYING
 * file that comes with the cvsfs4hurd distribution.
 *
 * speak tcp/ip protocol, aka connect to tcp/ip sockets
 *
 *
 *
 * adjustments made to fit libgeier
 * Copyright (C) 2005, by Stefan Siegl <stesie@brokenpipe.de>, Germany
 */

#ifndef TCPIP_H
#define TCPIP_H

#include <stdio.h>

/* try to connect to the specified tcp/ip socket, wrap to stdio.h's FILE*
 * structure and turn on line buffering
 */
FILE *geier_tcpip_connect(const char *hostname, const char *port);

#endif /* TCPIP_H */
