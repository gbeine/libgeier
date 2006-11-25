/*
 * Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
 * Copyright (C) 2005,2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

#include "context.h"
#include "tcpip.h"

#include <geier.h>
#include <string.h>
#include <limits.h>
#include <stdio.h>


static char *clearing_uri_list[] = {
	"http://80.146.179.2:80/Elster2/EMS",
  	"http://80.146.179.3:80/Elster2/EMS",
  	"http://193.109.238.58:80/Elster2/EMS",
  	"http://193.109.238.59:80/Elster2/EMS",
};

static const size_t clearing_uri_list_length =
	sizeof(clearing_uri_list) / sizeof(*clearing_uri_list);



int geier_send_encrypted_text(geier_context *context,
			      const unsigned char *input, size_t inlen,
			      unsigned char **output, size_t *outlen)
{
	(void) context;

	unsigned long int port = 80; /* default to port 80, which is http */
	char *dest_uri = NULL;
	char *port_ptr, *path;
	char buf[128]; /* buffer for parsing the http response */
	unsigned int lineno = 0;
	size_t alloc = 0, bytes_read;
	FILE *handle;
	char *proxy = getenv("http_proxy");
	int clearing_uri_index = rand() % clearing_uri_list_length;


	/* FIXME
	 * Treat context->clearing_timeout_ms correctly, i.e. care for it
	 * at all. For the time being, we just rely on the operating system
	 * to stop the connect() call with ETIMEDOUT
	 */

	if(proxy)
		dest_uri = proxy;
	else {
		/* FIXME: balance load between URIs */
		dest_uri = clearing_uri_list[clearing_uri_index];
	}

	if(! dest_uri || strncmp(dest_uri, "http://", 7)) {
		fprintf(stderr, PACKAGE_NAME ": invalid connect-uri: %s\n",
			dest_uri);
		return -1;
	}

	dest_uri = strdup(dest_uri + 7); /* skip http:// protocol specifier */
	if(! dest_uri) {
		perror(PACKAGE_NAME);
		return -1;
	}

	path = strchr(dest_uri, '/');
	if(! proxy && ! path) {
		fprintf(stderr, PACKAGE_NAME ": clearing-uri doesn't have a "
			"path part: %s\n", dest_uri);
		free(dest_uri);
		return -1;
	}

	if(path)
		*(path ++) = 0; /* split url into hostname:port and path */

	port_ptr = strchr(dest_uri, ':');
	if(port_ptr) {
		/* port number given! */
		*(port_ptr ++) = 0;
		port = strtoul(port_ptr, NULL, 10);

		if(port == ULONG_MAX /* strtoul failed */
		   || port > 65535) {
			fprintf(stderr, PACKAGE_NAME ": port-number specified "
				"in clearing-uri is not valid: %s\n",
				port_ptr);
			free(dest_uri);
			return -1;
		}
	}

	handle = geier_tcpip_connect(dest_uri, port_ptr ? port_ptr : "http");

	if(! handle) {
		/* tcpip_connect routine already notified the user, what
		 * happend, therefore let's just exit */
		free(dest_uri);
		return -1; 
	}

	/*
	 * send http header
	 */
	if(proxy) {
		if(fprintf(handle, "POST %s HTTP/1.0\r\n", 
			   clearing_uri_list[clearing_uri_index]) < 0)
			goto send_failed;
	}
	else {
		if(fprintf(handle, "POST /%s HTTP/1.0\r\n" "Host: %s:%ld\r\n",
			   path, dest_uri, port) < 0)
			goto send_failed;
	}

	if(fprintf(handle,
		   "User-Agent: " PACKAGE_NAME "/" PACKAGE_VERSION "\r\n"
		   "Content-Length: %d\r\n"
		   "Content-Type: text/xml\r\n"
		   "\r\n", inlen) < 0)
		goto send_failed;

	free(dest_uri);

	/* send the data */
	if(fwrite(input, inlen, 1, handle) != 1) {
		perror(PACKAGE_NAME);
		fclose(handle);
		return -1; 
	}

	/* well we've sent what we have to - now wait for the response */

	/* HTTP/1.1 200 OK
	 * Date: Sat, 18 Jun 2005 12:05:43 GMT
	 * Server: Apache/2.0.43 (Unix) DAV/2 mod_jk/1.2.0
	 * Connection: close
	 * Content-Type: text/html; charset=ISO-8859-1
	 */

	for(;;) {
		if(! fgets(buf, sizeof(buf), handle)) {
			fprintf(stderr, PACKAGE_NAME ": unexpected end of "
				"http response\n");
			fclose(handle);
			return -1;
		}

		if(! (lineno ++)) {
			char *strtok_bit, *ptr;

			/* this is the first line of the response,
			 * i.e. the result code line! */

			strtok_r(buf, " ", &strtok_bit);
			if(! (ptr = strtok_r(NULL, " ", &strtok_bit))) {
				fprintf(stderr, PACKAGE_NAME ": received http "
					"response is not valid, sorry\n");
				fclose(handle);
				return -1;
			}

			if(strcmp(ptr, "200")) {
				fprintf(stderr, PACKAGE_NAME ": received http "
					"error code %s, cannot go on\n", ptr);
				fclose(handle);
				return -1;
			}

			/* received '200', i.e. everything's alright */
		}

		if(*buf == 13 || *buf == 10) {
			break; /* this is the empty line delimiting the 
				* response header from the actual data */
		}
	}

	*outlen = 0;
	*output = NULL;

	for(;;) {
		if(alloc == *outlen) {
			alloc = alloc ? (alloc << 1) : 4096;
			*output = realloc(*output, alloc);
			if(! *output) {
				perror(PACKAGE_NAME);
				fclose(handle);
				return -1;
			}
		}

		if(! (bytes_read = fread(*output + *outlen, 1, alloc - *outlen,
				       handle)))
			break; /* error or end-of-file */
		*outlen += bytes_read;
	}

	if(ferror(handle)) {
		fprintf(stderr, PACKAGE_NAME ": cannot read http response\n");
		fclose(handle);
		free(*output);
		return -1;
	}

	*output = realloc(*output, *outlen); /* must not fail, shrinking */
	fclose(handle);
	return 0;

send_failed:
	/* fprintf failed to send the data to the clearing host */
	free(dest_uri);

	perror(PACKAGE_NAME);
	fclose(handle);
	return -1;
}
