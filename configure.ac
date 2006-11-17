# Configure.ac script for libgeier
# Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany
# Copyright (C) 2005,2006  Stefan Siegl <ssiegl@gmx.de>, Germany
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
AC_INIT([libgeier],[0.7],[taxbird@taxbird.de])
AC_CONFIG_AUX_DIR(config)
AM_CONFIG_HEADER(src/config.h)
AM_INIT_AUTOMAKE($PACKAGE_NAME, $PACKAGE_VERSION, $PACKAGE_BUGREPORT)

AC_PREREQ(2.59)
# we need the extra parentheses in order to cope with the comma
AC_COPYRIGHT([configure.ac Copyright (C) 2005  Juergen Stuber <juergen@jstuber.net>, Germany])
AC_REVISION($Revision: 1.29 $)

AC_CONFIG_SRCDIR([srcdir_marker])

# FIXME: Make conditional on C compilers that know -Wall?
if test "x$CFLAGS" = "x"; then CFLAGS="-Wall -ggdb"; fi

# checks for programs
AC_PROG_CC

AC_PROG_LIBTOOL
AC_PROG_RANLIB

GTK_DOC_CHECK(1.0)

# compatibility for automake < 1.8
if test -z "$mkdir_p"; then
	mkdir_p='${top_srcdir}/mkinstalldirs'
	AC_SUBST(mkdir_p)
fi

# checks for libraries ...

# check for openssl and libxml2 using pkg-config
PKG_CHECK_MODULES(PACKAGE, [openssl libxml-2.0 libxslt xmlsec1 xmlsec1-openssl])

# check for zlib
AC_CHECK_LIB([z], [deflateBound],,AC_MSG_ERROR([libz library missing.]))

# check whether we need to link against libiconv if we want to 
# have libiconv_open. recently it seems to be included in the c library.
AC_CHECK_LIB([c], [iconv_open],,
             AC_CHECK_LIB([iconv], [iconv_open], 
	                  LDFLAGS="$LDFLAGS -liconv",
			  AC_MSG_ERROR([iconv cruft missing.])))
	     
CFLAGS="$CFLAGS $PACKAGE_CFLAGS"
LDFLAGS="$LDFLAGS $PACKAGE_LIBS"

#
# check for python
#
AC_ARG_WITH(python, [  --with-python=PATH      Path to specific Python binary],
     PYTHON="$withval")
AM_PATH_PYTHON(2.2,[
    PYTHON_SUBDIR=python

    ### This overwrites pythondir and pyexecdir from AM_PATH_PYTHON
    ### since those do not honour sys.prefix!
    AC_SUBST(pythondir)
    AC_MSG_CHECKING(python libraries are installed into)
    pythondir=`$PYTHON -c 'import distutils.sysconfig; print distutils.sysconfig.get_python_lib(plat_specific=0, standard_lib=0)'`
    AC_MSG_RESULT($pythondir)

    AC_MSG_CHECKING(platform-specific python libraries are installed into)
    pyexecdir=`$PYTHON -c 'import distutils.sysconfig; print distutils.sysconfig.get_python_lib(plat_specific=1, standard_lib=0)'`
    AC_MSG_RESULT($pyexecdir)

    AC_MSG_CHECKING(checking where for python includes)
    PYTHON_INCLUDES=`$PYTHON -c 'import distutils.sysconfig; print distutils.sysconfig.get_python_inc(plat_specific=1)'`
    AC_MSG_RESULT($PYTHON_INCLUDES)
    ])

if test -z "$PYTHON_INCLUDES" ; then
    AC_MSG_WARN([Python-includes not found. Not building Python extension.])
    PYTHON_SUBDIR=
fi
AC_SUBST(PYTHON_SUBDIR)
AC_SUBST(PYTHON_INCLUDES)


# checks for header files

# checks for typedefs

# checks for structures

# checks for compiler characteristics

# checks for library functions

# checks for system services

# output
AC_CONFIG_FILES([Makefile src/Makefile include/Makefile etc/Makefile 
		 etc/stylesheets/Makefile include/geierversion.h
		 etc/schemas/Makefile config/Makefile
		 python/Makefile
		 debian/Makefile
		 doc/Makefile doc/reference/Makefile
		 doc/reference/version.xml
		 libgeier.spec libgeier.pc])
AC_OUTPUT
