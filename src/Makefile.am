DIST_SUBDIRS = openssl nss
SUBDIRS = @crypto_module@

lib_LTLIBRARIES = libgeier.la
libgeier_la_SOURCES = \
	init.c \
	exit.c \
	context.c \
	send_encrypted_text.c \
	send_encrypted.c \
	send.c \
	send_text.c \
	encoder.c \
	encrypt.c \
	decrypt.c \
	validate.c \
	text_to_xml.c \
	xml_to_text.c \
	globals.c \
	find_node.c \
	node_contents_to_text.c \
	base64.c \
	bsd-base64.c \
	xslt.c \
	gzip_deflate.c \
	gzip_inflate.c \
	tcpip.c \
	iso_to_utf8.c \
	get_clearing_error.c \
	version.c \
	xpath.c \
	dsig.c \
	dsig-rewrite-vorgang.c \
	dsig-rewrite-datenlieferant.c

libgeier_la_LDFLAGS = -version-info 0
libgeier_la_LIBADD = $(top_builddir)/src/@crypto_module@/libgeier_@crypto_module@.la

noinst_HEADERS = \
	encoder.h \
	tcpip.h \
	xpath.h \
	bsd-base64.h \
	base64.h \
	gzip_deflate.h \
	gzip_inflate.h \
	iso_to_utf8.h \
	find_node.h \
	globals.h \
	context.h \
	node_contents_to_text.h \
	pkcs7_encrypt.h \
	pkcs7_decrypt.h

AM_CPPFLAGS = \
	-I$(top_srcdir)/include -I$(top_builddir)/include \
	-I$(top_srcdir)/src/@crypto_module@ \
	-DDEFAULT_XMLSEC_TEMPLATE=\"$(datadir)/libgeier/xmlsec.tmpl\" \
	-DDEFAULT_CERT_FILE=\"$(datadir)/libgeier/Elster2Cry.b64.cer\" \
	-DDEFAULT_SCHEMA_DIR_URL=\"file://$(datadir)/libgeier/schemas\" \
	-DDEFAULT_STYLESHEET_DIR_URL=\"file://$(datadir)/libgeier/stylesheets\" \
	-DDEFAULT_CLEARING_TIMEOUT=30000

CLEANFILES = *~

bin_PROGRAMS = geier

geier_SOURCES = geier.c
geier_LDADD = libgeier.la

