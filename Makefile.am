SUBDIRS = src include etc config \
	@PYTHON_SUBDIR@

# always include subdir python into dist
DIST_SUBDIRS= config etc include src python
# todo: perl tests doc 

pkgconfigdir = $(prefix)/lib/pkgconfig/
pkgconfig_DATA = \
        libgeier.pc

man_MANS=geier.1

EXTRA_DIST = \
	srcdir_marker \
	libgeier.pc.in \
	${man_MANS} 

CLEANFILES = *~

