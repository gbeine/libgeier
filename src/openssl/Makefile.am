
noinst_LTLIBRARIES = libgeier_openssl.la

libgeier_openssl_la_SOURCES = \
	asn1hack.c \
	pkcs7_encrypt.c \
	pkcs7_decrypt.c \
	dsig-open.c \
	dsig-sign.c \
	dsig-get-attr.c \
	dsig-get-cert.c \
	dsig-get-cert-text.c \
	dsig-get-key.c

noinst_HEADERS = \
	asn1hack.h \
	dsig.h

AM_CPPFLAGS = \
	-I$(top_srcdir)/include \
	-I$(top_builddir)/include \
	-I$(top_srcdir)/src

CLEANFILES = *~

