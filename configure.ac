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
AC_CONFIG_AUX_DIR([config])
AC_CONFIG_HEADERS([src/config.h])
AM_INIT_AUTOMAKE

AC_PREREQ(2.59)
# we need the extra parentheses in order to cope with the comma
AC_COPYRIGHT([configure.ac Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany])
AC_REVISION($Revision: 1.11 $)

AC_CONFIG_SRCDIR([srcdir_marker])

# checks for programs
AC_PROG_CC
# FIXME: Make conditional on C compilers that know -Wall?
CFLAGS="$CFLAGS -Wall"

AC_PROG_LIBTOOL
AC_PROG_RANLIB

# checks for libraries

# Macros for searching and specifying library header files
# FIXME: Move the macros elsewhere?  Can aclocal help?
# FIXME: Add default for directories to search.

define([AC_SEARCH_DIRECTORY],
dnl $1: variable for directory
dnl $2: file to search for
dnl $3: list of directories to search
for dir in $3; do
    if test -f "$dir/$2"; then
        $1="$dir";
	break;
    fi
done )

define([AC_FIND_HEADERS],
dnl $1: package name (lowercase letters)
dnl $2: message text for headers
dnl $3: file to search for
dnl $4: list of directories to search
[dnl FIXME: Is there a better way to avoid name clashes?
define(ac_fh_default_var,translit($1, [A-Z-], [a-z_])[_headers_default])
define(ac_fh_var,translit($1, [a-z-], [A-Z_])[_HEADERS])
define(ac_fh_with_name,translit($1, [A-Z_], [a-z-])[-headers])
AC_SEARCH_DIRECTORY(ac_fh_default_var,$3,$4)
AC_MSG_CHECKING([for location of ]$2[ headers])
AC_ARG_WITH(ac_fh_with_name,
  AS_HELP_STRING([--with-]ac_fh_with_name[=DIR],$2[ include files location]),
  ac_fh_var[="$withval"],
  [if test -z $]ac_fh_default_var[; then 
    AC_MSG_RESULT([not found])
    AC_MSG_ERROR(]$2[[ headers not found])
  else
    ac_fh_var[="$]ac_fh_default_var"
  fi])
AC_MSG_RESULT([$]ac_fh_var)
AC_SUBST(ac_fh_var)
])

# Crypto libary headers and path

AC_FIND_HEADERS([ssl],[Crypto/SSL],[openssl/ssl.h],[/usr/local/ssl/include /usr/lib/ssl/include /usr/ssl/include /usr/pkg/include /usr/local/include /usr/include])
CPPFLAGS="$CPPFLAGS -I$SSL_HEADERS"
AC_CHECK_HEADERS([openssl/ssl.h])

AC_ARG_WITH([ssl-libs],
   AS_HELP_STRING([--with-ssl-libs=DIR],[Crypto/SSL Library location]),
   [LDFLAGS="$LDFLAGS -L$withval"]
)
AC_CHECK_LIB([crypto], [PEM_read_X509],,AC_MSG_ERROR([Crypto libraries missing.]))
AC_CHECK_LIB([ssl], [SSL_CTX_new],,AC_MSG_ERROR([OpenSSL libraries missing.]))
AC_CHECK_LIB([dl], [dlopen],,AC_MSG_ERROR([libdl librarie missing.]))

# check for zlib
AC_CHECK_LIB([z], [deflateBound],,AC_MSG_ERROR([libz library missing.]))

#check for md5
AC_CHECK_LIB([md5], [MD5_Init],,AC_MSG_ERROR([md5 library missing.]))

# libxml2
AC_FIND_HEADERS([libxml2],[libxml2],[libxml/tree.h],[/usr/local/libxml2/include /usr/lib/libxml2/include /usr/libxml2/include /usr/include/libxml2 /usr/pkg/include /usr/local/include /usr/include])
CPPFLAGS="$CPPFLAGS -I$LIBXML2_HEADERS"
AC_CHECK_HEADERS([libxml/tree.h])

AC_CHECK_LIB([xml2], [xmlNewNode],,AC_MSG_ERROR([libxml2 library missing.]))

# w3c-libwww
AC_FIND_HEADERS([libwww],[W3C libwww],[WWWUtil.h],[/usr/local/w3c-libwww/include /usr/lib/w3c-libwww/include /usr/w3c-libwww/include /usr/include/w3c-libwww /usr/pkg/include /usr/local/include /usr/include])
CPPFLAGS="$CPPFLAGS -I$LIBWWW_HEADERS"
AC_CHECK_HEADERS([WWWUtil.h],,,
dnl There is a clash between system and libwww headers for sys_errlist.
dnl FIXME: Is this ok?
[[#undef sys_errlist
]])

LIBS="$LIBS -lwwwinit -lwwwxml -lxmltok -lxmlparse -lwwwzip -lwwwhtml -lwwwhttp -lwwwtelnet -lwwwnews -lwwwmime -lwwwgopher -lwwwftp -lwwwfile -lwwwdir -lwwwcache -lwwwstream -lwwwmux -lwwwtrans -lwwwcore -lwwwutils -lwwwapp"
AC_CHECK_LIB([wwwutils], [HTChunk_new],,AC_MSG_ERROR([libwwwutils library missing.]))

# Mozilla NSS
AC_FIND_HEADERS([mozilla],[Mozilla NSS],[nss/nss.h],[/usr/local/mozilla/include /usr/lib/mozilla/include /usr/mozilla/include /usr/include/mozilla /usr/pkg/include /usr/local/include /usr/include /opt/mozilla/include])
CPPFLAGS="$CPPFLAGS -I$MOZILLA_HEADERS -I$MOZILLA_HEADERS/nss -I$MOZILLA_HEADERS/nspr"
AC_CHECK_HEADERS([nss.h])

AC_ARG_WITH([mozilla-libs],
   AS_HELP_STRING([--with-mozilla-libs=DIR],[mozilla library location]),
   [LDFLAGS="$LDFLAGS -L$withval"]
)
LIBS="$LIBS -lsoftokn3 -lplc4 -lplds4 -lnspr4"
AC_CHECK_LIB([nss3], NSS_NoDB_Init,,AC_MSG_ERROR([libnss3 missing. Set path using --with-mozilla-libs.]))
AC_CHECK_LIB([smime3], SEC_PKCS7DecodeItem,,AC_MSG_ERROR([libsmime3 missing.]))


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
		 tests/Makefile
		 libgeier.spec])
AC_OUTPUT
