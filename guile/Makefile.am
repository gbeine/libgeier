#
# Makefile.am for the libgeier python interface
#
# Copyright (C) 2006 Stefan Siegl <stesie@brokenpipe.de>
# Licence: GPL, see www.taxbird.de
#

EXTRA_DIST = libgeier.i

INCLUDES = \
	-I$(top_srcdir)/include

GENERATED = libgeier_wrap.c geier.scm

libgeier_wrap.c : libgeier.i
	swig -guile -scmstub -I$(top_srcdir)/include -o $@ $<

lib_LTLIBRARIES = libguilegeier.la
libguilegeier_la_SOURCES = libgeier_wrap.c
libguilegeier_la_LIBADD = $(top_builddir)/src/libgeier.la

CLEANFILES = $(GENERATED)
