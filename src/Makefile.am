lib_LTLIBRARIES = libgeier.la
libgeier_la_SOURCES = \
	send_encrypted_text.c \
	base64.c base64.h bsd-base64.c bsd-base64.h \
	pkcs7_encrypt.c pkcs7_encrypt.h \
	asn1hack.c asn1hack.h
#	send.c \
#	send_text.c \
#	text_to_xml.c \
#	xml_to_text.c \
#	decrypt.c \
#	encrypt.c

AM_CPPFLAGS = \
	-I/usr/include/libxml2 \
	-I/usr/include/w3c-libwww \
	-I../include \
	-DHAVE_CONFIG_H

CLEANFILES = *~
