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


TESTDATADIR = $(top_srcdir)/tests/data

EXTRA_DIST = \
	$(TESTDATADIR)/pkcs7/certificate \
	$(TESTDATADIR)/pkcs7/teststring \
	$(TESTDATADIR)/pkcs7/teststring.gzip \
	$(TESTDATADIR)/pkcs7/teststring.gzip.pkcs7-encrypted \
	$(TESTDATADIR)/pkcs7/teststring.pkcs7-envelope.geier \
	$(TESTDATADIR)/session_key \
	$(TESTDATADIR)/test_ustva_encrypted.xml \
	$(TESTDATADIR)/test_ustva_reply.xml \
	$(TESTDATADIR)/test_ustva_reply_encrypted.xml \
	$(TESTDATADIR)/test_ustva_unencrypted.xml

# FIXME: let configure determine library header locations
AM_CPPFLAGS = -Wall \
	-I$(top_srcdir)/src \
	-I$(top_srcdir)/include \
	-DETCDIR=\"$(top_srcdir)/etc\" \
	-DTESTDATADIR=\"$(TESTDATADIR)\" 

LDADD = $(top_builddir)/src/libgeier.la

CLEANFILES = *~ *.result
