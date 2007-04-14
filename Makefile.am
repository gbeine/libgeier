SUBDIRS = src include etc config doc tests \
	@PYTHON_SUBDIR@ @GUILE_SUBDIR@

# always include subdir python into dist
DIST_SUBDIRS= config etc include src python perl doc tests guile

# list of modules to build local
all_local_cruft=

if BUILD_PERL
all_local_cruft += perl_module

perl_module: perl/Makefile
	$(MAKE) -C perl

perl/Makefile: perl/Makefile.PL
	cd perl && $(PERL) Makefile.PL $(PERL_MAKE_OPTIONS)
endif

all-local: $(all_local_cruft)

install-data-local: 
	test -f perl/Makefile && $(MAKE) -C perl install || true

clean-local:
	test -f perl/Makefile && $(MAKE) -C perl clean || true



pkgconfigdir = $(libdir)/pkgconfig/
pkgconfig_DATA = \
        libgeier.pc

man_MANS=geier.1

EXTRA_DIST = \
	libgeier.pc.in \
	${man_MANS} 

CLEANFILES = *~

