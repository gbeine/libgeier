lib_LTLIBRARIES = libgeier.la
libgeier_la_SOURCES = \
	init.c \
	exit.c \
	context.c context.h \
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
	globals.c globals.h \
	find_node.c find_node.h \
	node_contents_to_text.c node_contents_to_text.h \
	base64.c base64.h bsd-base64.c bsd-base64.h \
	pkcs7_encrypt.c pkcs7_encrypt.h \
	pkcs7_decrypt.c pkcs7_decrypt.h \
	pkcs7_keying.c pkcs7_keying.h \
	xslt.c \
	gzip_deflate.c gzip_deflate.h \
	gzip_inflate.c gzip_inflate.h \
	tcpip.c tcpip.h \
	iso_to_utf8.c iso_to_utf8.h \
	get_clearing_error.c \
	version.c \
	xpath.c xpath.h \
	secpwd.c \
	dsig.c \
	dsig-open.c \
	dsig-rewrite-vorgang.c \
	dsig-rewrite-datenlieferant.c \
	dsig-sign.c \
	dsig-slot.c \
	dsig-get-cert.c

libgeier_la_LDFLAGS = -version-info 0

noinst_HEADERS = \
	encoder.h \
	dsig.h secutil.h

AM_CPPFLAGS = \
	-I$(top_srcdir)/include \
	-DDEFAULT_XMLSEC_TEMPLATE=\"$(datadir)/libgeier/xmlsec.tmpl\" \
	-DDEFAULT_CERT_FILE=\"$(datadir)/libgeier/Elster2Cry.b64.cer\" \
	-DDEFAULT_SCHEMA_DIR_URL=\"file://$(datadir)/libgeier/schemas\" \
	-DDEFAULT_STYLESHEET_DIR_URL=\"file://$(datadir)/libgeier/stylesheets\" \
	-DDEFAULT_CLEARING_TIMEOUT=30000

CLEANFILES = *~

bin_PROGRAMS = geier

geier_SOURCES = geier.c
geier_LDADD = libgeier.la

