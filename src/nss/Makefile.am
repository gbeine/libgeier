
noinst_LTLIBRARIES = libgeier_nss.la

libgeier_nss_la_SOURCES = \
	pkcs7_encrypt.c \
	pkcs7_decrypt.c \
	pkcs7_keying.c \
	secpwd.c \
	dsig-open.c \
	dsig-sign.c \
	dsig-slot.c \
	dsig-get-cert.c

noinst_HEADERS = \
	pkcs7_keying.h \
	dsig.h \
	secutil.h

AM_CPPFLAGS = \
	-I$(top_srcdir)/include \
	-I$(top_builddir)/include \
	-I$(top_srcdir)/src

CLEANFILES = *~

