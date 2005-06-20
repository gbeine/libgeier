# Configure.ac script for libgeier
# Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
# Copyright (C) 2005  Stefan Siegl <ssiegl@gmx.de>, Germany
#
# This file is part of libgeier.
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
AC_INIT([libgeier],[0.2],[taxbird@taxbird.de])
AC_CONFIG_AUX_DIR(config)
AM_CONFIG_HEADER(src/config.h)
AM_INIT_AUTOMAKE($PACKAGE_NAME, $PACKAGE_VERSION, $PACKAGE_BUGREPORT)

AC_PREREQ(2.59)
# we need the extra parentheses in order to cope with the comma
AC_COPYRIGHT([configure.ac Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany])
AC_REVISION($Revision: 1.14 $)

AC_CONFIG_SRCDIR([srcdir_marker])

# FIXME: Make conditional on C compilers that know -Wall?
if test "x$CFLAGS" = "x"; then CFLAGS="-Wall -ggdb"; fi

# checks for programs
AC_PROG_CC

AC_PROG_LIBTOOL
AC_PROG_RANLIB


# checks for libraries ...

# check for openssl and libxml2 using pkg-config
PKG_CHECK_MODULES(PACKAGE, [openssl libxml-2.0 libxslt])

# check for zlib
AC_CHECK_LIB([z], [deflateBound],,AC_MSG_ERROR([libz library missing.]))

CFLAGS="$CFLAGS $PACKAGE_CFLAGS"
LDFLAGS="$LDFLAGS $PACKAGE_LIBS"

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
		 etc/stylesheets/Makefile 
		 etc/schemas/Makefile config/Makefile
		 libgeier.spec])
AC_OUTPUT
