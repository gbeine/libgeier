AUTOMAKE_OPTIONS = foreign

# tests run for make check
TESTS = \
	test_base64 \
	test_pkcs7_encrypt \
	test_pkcs7_decrypt \
	test_gzip_deflate \
	test_gzip_inflate \
	test_encrypt \
	test_decrypt \
	test_validate

XFAIL_TESTS = \
	test_encrypt

# add tests run by hand here
check_PROGRAMS = $(TESTS) \
	test_send_text \
	test_send \
	test_send_encrypted_text

# FIXME: let configure determine library header locations
AM_CPPFLAGS = -Wall \
	-I/usr/include/libxml2 \
	-I/usr/include/w3c-libwww \
	-I$(top_srcdir)/src \
	-I$(top_srcdir)/include \
	-DETCDIR=\"$(top_srcdir)/etc\" \
	-DTESTDATADIR=\"$(top_srcdir)/tests/data\" \
	-DDEFAULT_HTCHUNK_GROWBY=1024

LDADD = -L../src -lgeier

CLEANFILES = *~ \
	test_send_encrypted_text.result \
	test_encrypt.result \
	test_decrypt.result \
	test_pkcs7_encrypt.result \
	test_pkcs7_decrypt.result \
	test_gzip_inflate.result \
	test_gzip_deflate.result
