AUTOMAKE_OPTIONS = foreign

# tests run for make check
TESTS = \
	test_base64 \
	test_pkcs7_encrypt \
	test_pkcs7_decrypt \
	test_gzip_deflate \
	test_gzip_inflate \
	test_validate

# add tests run by hand here
check_PROGRAMS = $(TESTS) \
	test_encrypt \
	test_send_encrypted_text

AM_CPPFLAGS = -Wall \
	-I/usr/include/libxml2 \
	-I/usr/include/w3c-libwww \
	-I../src \
	-I../include \
	-DDEFAULT_HTCHUNK_GROWBY=1024

LDADD = \
	-lwwwinit -lwwwutils -lwwwcore -lwwwapp \
	-lxml2 \
	-lssl \
	-L/lib -lnspr4 -lnss3 -lsmime3 \
	-L../src -lgeier

CLEANFILES = *~ \
	test_send_encrypted_text.result \
	test_encrypt.result \
	test_pkcs7_encrypt.result \
	test_pkcs7_decrypt.result \
	test_gzip_inflate.result \
	test_gzip_deflate.result
