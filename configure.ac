# Configure.ac script for Libgeier
# Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
#
# This file is part of Libgeier.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# 
# Process this file with autoconf to produce a configure script.

# FIXME: we need a proper project bugreport email address
AC_INIT([libgeier],[0.1],[juergen@jstuber.net])
AC_CONFIG_AUX_DIR(config)
AC_CONFIG_HEADERS([src/config.h])
AM_INIT_AUTOMAKE

AC_PREREQ(2.59)
# we need the extra parentheses in order to cope with the comma
AC_COPYRIGHT([configure.ac Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany])
AC_REVISION($Revision: 1.9 $)

AC_CONFIG_SRCDIR(srcdir_marker)

# add options for configure
# FIXME: add options --with-libxxx=dir for locations of libraries

# checks for programs
AC_PROG_CC
AC_PROG_LIBTOOL
AC_PROG_RANLIB

# checks for libraries

# check for OpenSSL
# FIXME: isn't there a more standard way to do this?
# FIXME: should we mess directly with CFLAGS, CXXFLAGS and LDFLAGS?
for dir in $withval /usr/local/ssl /usr/lib/ssl /usr/ssl /usr/pkg /usr/local /usr; do
    if test -f "$dir/include/openssl/ssl.h"; then
	CFLAGS="$CFLAGS -I$dir/include/";
	CXXFLAGS="$CXXFLAGS -I$dir/include/";
	break;
    fi
done

LDFLAGS="$LDFLAGS -L$dir/lib";
AC_CHECK_LIB(crypto, PEM_read_X509,,AC_MSG_ERROR([OpenSSL libraries missing.]))

# check for libwww libraries
AC_CHECK_LIB(wwwinit, HTProfile_newClient,,AC_MSG_ERROR([libwwwinit library missing.]))
AC_CHECK_LIB(wwwutils, HTChunk_new,,AC_MSG_ERROR([libwwwutils library missing.]))
AC_CHECK_LIB(wwwcore, HTRequest_new,,AC_MSG_ERROR([libwwwcore library missing.]))
AC_CHECK_LIB(wwwapp, HTPostAbsolute,,AC_MSG_ERROR([libwwwapp library missing.]))

# check for libxml2
AC_CHECK_LIB(xml2, xmlNewNode,,AC_MSG_ERROR([libxml2 library missing.]))

# check for zlib
AC_CHECK_LIB(z, deflateBound,,AC_MSG_ERROR([libz library missing.]))

# check for libnss
AC_CHECK_LIB(nss3, NSS_NoDB_Init,,AC_MSG_ERROR([libnss3 missing.], [-lnspr4]))
AC_CHECK_LIB(smime3, SEC_PKCS7DecodeItem,,AC_MSG_ERROR([libsmime3 missing.]))

# checks for header files
AC_HEADER_STDC
AC_CHECK_HEADERS([stddef.h])
AC_CHECK_HEADERS([fcntl.h])
AC_CHECK_HEADERS([string.h])
AC_CHECK_HEADERS([unistd.h])
AC_CHECK_HEADERS([arpa/inet.h])
AC_CHECK_HEADERS([netinet/in.h])
AC_CHECK_HEADERS([sys/param.h])
AC_CHECK_HEADERS([sys/socket.h])

# checks for typedefs
AC_TYPE_SIZE_T

# checks for structures

# checks for compiler characteristics
AC_C_CONST

# checks for library functions
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_FUNC_MEMCMP
AC_FUNC_VPRINTF
AC_CHECK_FUNCS([memmove])
AC_CHECK_FUNCS([memset])
AC_CHECK_FUNCS([strchr])

# checks for system services

# output
AC_CONFIG_FILES([Makefile src/Makefile include/Makefile etc/Makefile 
                 tests/Makefile])
AC_OUTPUT
