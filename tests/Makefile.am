AUTOMAKE_OPTIONS = foreign

TESTS = test_base64 test_pkcs7_encrypt

check_PROGRAMS = $(TESTS)

AM_CPPFLAGS = \
	-I/usr/include/libxml2 \
	-I/usr/include/w3c-libwww \
	-I../src \
	-I../include \
	-DHAVE_CONFIG_H

CLEANFILES = *~

test_base64_LDADD = ../src/base64.o ../src/bsd-base64.o

test_pkcs7_encrypt_LDADD = -lwwwutils -lssl \
	../src/pkcs7_encrypt.o ../src/asn1hack.o
