SUBDIRS = src include etc config doc tests \
	@PYTHON_SUBDIR@

# always include subdir python into dist
DIST_SUBDIRS= config etc include src python doc tests
# todo: perl doc 

pkgconfigdir = $(libdir)/pkgconfig/
pkgconfig_DATA = \
        libgeier.pc

man_MANS=geier.1

EXTRA_DIST = \
	libgeier.pc.in \
	${man_MANS} 

CLEANFILES = *~

