lib_LTLIBRARIES = libgeier.la
libgeier_la_SOURCES = \
	init.c \
	exit.c \
	context.c context.h \
	send_encrypted_text.c \
	encrypt.c \
	decrypt.c \
	validate.c \
	text_to_xml.c \
	xml_to_text.c \
	globals.c globals.h \
	find_node.c find_node.h \
	base64.c base64.h bsd-base64.c bsd-base64.h \
	pkcs7_encrypt.c pkcs7_encrypt.h \
	pkcs7_decrypt.c pkcs7_decrypt.h \
	asn1hack.c asn1hack.h \
	gzip_deflate.c gzip_deflate.h \
	gzip_inflate.c gzip_inflate.h
#	send.c \
#	send_text.c \
#	decrypt.c

AM_CPPFLAGS = \
	-I/usr/include/libxml2 \
	-I/usr/include/w3c-libwww \
	-I../include \
	-DDEFAULT_CERT_FILE=\"$(datadir)/Elster2Cry.b64.cer\" \
	-DDEFAULT_CLEARING_TIMEOUT=30000

CLEANFILES = *~
