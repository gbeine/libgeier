// -*- mode: c -*-
//
// Swig interface module for libgeier
//
// Copyright (C) 2006 Stefan Siegl <stesiebrokenpipe.de>
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//

%module geier
%{ #include <geier.h> %}

/*
 * initialisation of the library
 */
int geier_init(int debug);
int geier_exit(void);


/*
 * context handling
 */
typedef struct { } geier_context;
%extend geier_context {
  geier_context();
  ~geier_context();
};
%{
#define new_geier_context geier_context_new
#define delete_geier_context geier_context_free
%};


/*
 * swig type mapping
 */
%typemap(in, numinputs=1) (const unsigned char *input, size_t inlen) {
  if(! scm_string_p($input)) {
    scm_error_scm(scm_c_lookup_ref("wrong-type-arg"),
                  scm_makfrom0str(FUNC_NAME),
                  scm_makfrom0str("invalid argument, string expected."),
                  SCM_EOL, SCM_BOOL(0));
  } else {
    $1 = SCM_STRING_CHARS($input);
    $2 = scm_string_length($input);
  }
};

/* don't expect any input for **output and *outlen fields */
%typemap(in, numinputs=0) (unsigned char **output, size_t *outlen) (unsigned char *temp, size_t temp1) {
  $1 = &temp;
  $2 = &temp1;
};

/* on success, push **output back as string result */
%typemap(argout) (unsigned char **output, size_t *outlen) {
  if(! result)
    /* zero means success! let's silently overwrite gswig_result ... */
    gswig_result = scm_take_str(*$1, *$2);
};


/*
 * sending 
 */
%rename (geier_send) geier_send_text;
int geier_send_text(geier_context *context, const unsigned char *input, size_t inlen, unsigned char **output, size_t *outlen);
%rename (geier_get_clearing_error) geier_get_clearing_error_text;
char *geier_get_clearing_error_text(geier_context *context, const unsigned char *input, size_t inlen);


/*
 * validation
 */
typedef enum _geier_format { geier_format_encrypted, geier_format_unencrypted, } geier_format;
%rename (geier_validate) geier_validate_text;
int geier_validate_text(geier_context *context, geier_format f, const unsigned char *input, size_t inlen);


/*
 * protocol generation
 */
%rename (geier_xsltify) geier_xsltify_text;
int geier_xsltify_text(geier_context *context, const unsigned char *input, size_t inlen, unsigned char **output, size_t *outlen);


/*
 * digital signature handling
 */
%rename (geier_sign) geier_dsig_sign_text;
int geier_dsig_sign_text(geier_context *context, const unsigned char *input, size_t inlen, unsigned char **output, size_t *outlen, const char *softpse_filename, const char *pincode);


/*
 * scheme code
 */
%scheme %{ 
(load-extension "libguilegeier.so" "SWIG_init") 

%}
