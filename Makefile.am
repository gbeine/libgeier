SUBDIRS = src include etc config

pkgconfigdir = $(prefix)/lib/pkgconfig/
pkgconfig_DATA = \
        libgeier.pc

man_MANS=geier.1

EXTRA_DIST = \
	srcdir_marker \
	libgeier.pc.in \
	libgeier.spec \
	COPYING.OpenSSL_exception \
	${man_MANS} 

CLEANFILES = *~

# Rule for building the rpm
rpm:    $(PACKAGE).spec dist
	rpmbuild="rpm" && \
	if [ `rpm --version | awk '{ print $$3 }'` > /dev/null ]; then rpmbuild="rpmbuild"; fi && \
	$$rpmbuild -ta $(PACKAGE)-$(VERSION).tar.gz

# Rule for only building the source rpm
srpm: $(PACKAGE).spec dist
	rpmbuild="rpm" && \
	if [ `rpm --version | awk '{ print $$3 }'` > /dev/null ]; then rpmbuild="rpmbuild"; fi && \
	$$rpmbuild --nodeps -ts $(PACKAGE)-$(VERSION).tar.gz

