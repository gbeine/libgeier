/**********************************************************
 * tcpip.c
 *
 * Copyright 2004, Stefan Siegl <ssiegl@gmx.de>, Germany
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Publice License,
 * version 2 or any later. The license is contained in the COPYING
 * file that comes with the cvsfs4hurd distribution.
 *
 * speak tcp/ip protocol, aka connect to tcp/ip sockets
 *
 *
 *
 * adjustments made to fit libgeier
 * Copyright (C) 2005, by Stefan Siegl <stesie@brokenpipe.de>, Germany
 */

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <stdio.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#include "tcpip.h"

/* tcpip_connect
 *
 * try to connect to the specified tcp/ip socket, wrap to stdio.h's FILE*
 * structure and turn on line buffering
 */
FILE *
geier_tcpip_connect(const char *hostname, const char *port)
{
  int error;
  int sockfd;
  FILE *handle;
  struct addrinfo addrinfo, *addrinfo_res;
  struct protoent *tcp_proto;

  if(! (tcp_proto = getprotobyname("tcp"))) {
    perror(PACKAGE_NAME ": necessary protocol 'tcp' not available");
    return NULL;
  }  

  addrinfo.ai_flags = 0;
  addrinfo.ai_family = AF_INET;
  addrinfo.ai_socktype = SOCK_STREAM;
  addrinfo.ai_protocol = tcp_proto->p_proto;

  if((error = getaddrinfo(hostname, port, &addrinfo, &addrinfo_res))) {
    fprintf(stderr, PACKAGE_NAME ": %s for service '%s'\n", 
	    gai_strerror(error), hostname);
    return NULL;
  }
  
  if((sockfd = socket(addrinfo_res->ai_family, addrinfo_res->ai_socktype,
		      addrinfo_res->ai_protocol)) < 0)
    {
      perror(PACKAGE_NAME ": unable to create socket");
      freeaddrinfo(addrinfo_res);
      return NULL;
    }

  if(connect(sockfd, addrinfo_res->ai_addr, addrinfo_res->ai_addrlen))
    {
      perror(PACKAGE_NAME ": unable to connect to socket");
      freeaddrinfo(addrinfo_res);
      return NULL;
    }

  /* get rid of addrinfo, which was allocated by getaddrinfo */
  freeaddrinfo(addrinfo_res);

  handle = fdopen(sockfd, "r+");
  if(! handle)
    {
      perror(PACKAGE_NAME ": unable to fdopen tcp-socket");
      close(sockfd);
      return NULL;
    }

  if(setvbuf(handle, NULL, _IOLBF, 0))
    {
      perror(PACKAGE_NAME ": unable to enable line buffering on socket");
      fclose(handle);
      return NULL;
    }

  return handle;
}


