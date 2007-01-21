#
# Makefile.am for the libgeier python interface
#
# Copyright (C) 2006 Hartmut Goebel <h.goebel@goebel-consult.de>
# Licence: GPL, see www.taxbird.de
#

EXTRA_DIST = libgeier.i geier-Context.py.i gen-ignores.sh

INCLUDES = \
	-I$(PYTHON_INCLUDES) \
	-I$(top_srcdir)/include


all-local: geier.py #_geier.so

python_PYTHON = geier.py
pyexec_LTLIBRARIES = _geier.la
_geier_la_SOURCES = libgeier_wrap.c
_geier_la_LDFLAGS = -module -rpath '$(libdir)'
_geier_la_LIBADD = $(top_srcdir)/src/libgeier.la

GENERATED = libgeier_wrap.c geier.py \
	_geier.a _geier.so* libgeier-ignores.i

libgeier_wrap.c : libgeier.i libgeier-ignores.i geier-Context.py.i
	$(SWIG) -python -I$(top_srcdir)/include -o $@ $<

libgeier-ignores.i: $(top_srcdir)/include/geier.h gen-ignores.sh
	sh ./gen-ignores.sh $<  > $@ 

_geier.so: $(PWD)/_geier.so

$(PWD)/_geier.so : _geier.la
	$(LIBTOOL) --mode=install $(INSTALL) $(INSTALL_STRIP_FLAG) $< $@
	$(LIBTOOL) --finish .


CLEANFILES = $(GENERATED) *.o *.pyc *.pyo *~ 
