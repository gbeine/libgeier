# Configure.ac script for libgeier
# Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
# Copyright (C) 2005,2006,2007,2008  Stefan Siegl <stesie@brokenpipe.de>, Germany
#
# This file is part of libgeier.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
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
AC_INIT([libgeier],[0.10],[taxbird@taxbird.de])
AC_CONFIG_AUX_DIR(config)
AM_CONFIG_HEADER(src/config.h)
AM_INIT_AUTOMAKE($PACKAGE_NAME, $PACKAGE_VERSION, $PACKAGE_BUGREPORT)

AC_PREREQ(2.59)

AC_CONFIG_SRCDIR([libgeier.pc.in])

# checks for programs
AC_PROG_CC

AC_PROG_LIBTOOL

GTK_DOC_CHECK(1.0)

# compatibility for automake < 1.8
if test -z "$mkdir_p"; then
	mkdir_p='${top_srcdir}/mkinstalldirs'
	AC_SUBST(mkdir_p)
fi

# check for mozilla/xmlsec1-nss, libxml2 and libxslt using pkg-config ...
PKG_CHECK_MODULES(libxml, [libxml-2.0])
PKG_CHECK_MODULES(libxslt, [libxslt])

AC_ARG_WITH(nss, [  --with-nss              Use Mozilla NSS for cryptography],[
  if test "${with_nss}" = "no"; then
    crypto_module=nss
  else
    crypto_module=nss
  fi
])

AC_ARG_WITH(openssl, [  --with-openssl          Use OpenSSL for cryptography],[
  if test "${with_openssl}" = "no"; then
    crypto_module=nss
  else
    crypto_module=openssl
  fi
])

# if user didn't specify a module, try to guess ...
if test "x${crypto_module}" = "x"; then
  # PKG_CHECK_EXISTS(MODULES, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
  PKG_CHECK_EXISTS(xmlsec1-nss, [crypto_module=nss], [
    PKG_CHECK_EXISTS(xmlsec1-openssl, [crypto_module=openssl], [
      AC_MSG_ERROR([no suitable crypto module found.])])])
fi

echo "Configured crypto_module: ${crypto_module}"
PKG_CHECK_MODULES(xmlsec, [xmlsec1-${crypto_module}])
#AM_CONDITIONAL(USE_NSS, test "${crypto_module}" = "nss")
AC_SUBST(crypto_module)

CFLAGS="$CFLAGS $libxml_CFLAGS $libxslt_CFLAGS $xmlsec_CFLAGS"
LDFLAGS="$LDFLAGS $libxml_LIBS $libxslt_LIBS $xmlsec_LIBS"

# check for zlib
AC_CHECK_LIB([z], [deflateBound],,AC_MSG_ERROR([libz library missing.]))


# output
AC_CONFIG_FILES([Makefile 
		 src/Makefile 
		 src/nss/Makefile
		 src/openssl/Makefile
		 include/Makefile 
		 include/geierversion.h
		 etc/Makefile 
		 etc/stylesheets/Makefile 
		 etc/schemas/Makefile 
		 config/Makefile
		 doc/Makefile 
		 doc/reference/Makefile
		 doc/reference/version.xml
		 tests/Makefile
		 libgeier.pc])
AC_OUTPUT
