AUTOMAKE_OPTIONS = foreign

TESTS = \
	test_base64 \
	test_encrypt \
	test_pkcs7_encrypt \
	test_gzip_deflate \
	test_gzip_inflate

check_PROGRAMS = $(TESTS) \
	test_send_encrypted_text

AM_CFLAGS = -g -O2

AM_CPPFLAGS = \
	-I/usr/include/libxml2 \
	-I/usr/include/w3c-libwww \
	-I../src \
	-I../include \
	-DHAVE_CONFIG_H

CLEANFILES = *~ test_pkcs7_encrypt.result \
	test_gzip_inflate.result \
	test_gzip_deflate.result

test_base64_LDADD = ../src/base64.o ../src/bsd-base64.o

test_send_encrypted_text_LDADD = \
	-lxml2 \
	-lwwwinit -lwwwutils -lwwwcore -lwwwapp \
	../src/globals.o \
	../src/context.o \
	../src/init.o \
	../src/exit.o \
	../src/send_encrypted_text.o

test_encrypt_LDADD = -lwwwutils -lxml2 -lssl \
	../src/globals.o \
	../src/context.o \
	../src/init.o \
	../src/exit.o \
	../src/gzip_deflate.o \
	../src/pkcs7_encrypt.o ../src/asn1hack.o \
	../src/base64.o ../src/bsd-base64.o \
	../src/xml_to_text.o ../src/text_to_xml.o \
	../src/encrypt.o

test_pkcs7_encrypt_LDADD = -lwwwutils -lssl \
	../src/context.o \
	../src/pkcs7_encrypt.o ../src/asn1hack.o

test_gzip_deflate_LDADD = -lwwwutils -lz \
	../src/gzip_deflate.o

test_gzip_inflate_LDADD = -lwwwutils -lz \
	../src/gzip_inflate.o
