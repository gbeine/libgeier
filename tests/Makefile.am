AUTOMAKE_OPTIONS = foreign

TESTS = test_base64 test_pkcs7_encrypt test_gzip_deflate test_gzip_inflate

check_PROGRAMS = $(TESTS)

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

test_pkcs7_encrypt_LDADD = -lwwwutils -lssl \
	../src/pkcs7_encrypt.o ../src/asn1hack.o

test_gzip_deflate_LDADD = -lwwwutils -lz \
	../src/gzip_deflate.o

test_gzip_inflate_LDADD = -lwwwutils -lz \
	../src/gzip_inflate.o
