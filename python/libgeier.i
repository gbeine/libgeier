// -*- mode: c -*-
//
// Swig interface module for libgeier
//
// Copyright (C) 2006 Hartmut Goebel <h.goebel@goebel-consult.de>
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

// todo: docstring is not at begining of module and thus no docstring :-(
%define DOCSTRING
"Python interface for libgeier.

libgeier is a library for exchanging data with the german ELSTER tax
system."
%enddef

%module(docstring=DOCSTRING) geier
//%feature("autodoc", "1");

%{
#include "geier.h"

#define new_geier_context geier_context_new
#define delete_geier_context geier_context_free
%}

// overwrite geier_context with fake class
typedef struct { } geier_context;

// --- renames and ignores ---
%include "libgeier-ignores.i"
%ignore GEIER_ERROR_BASE;
%ignore GEIER_WBITS_GZIP;
%ignore geier_format;
%ignore geier_send_encrypted;
%ignore geier_send_encrypted_text;
%ignore geier_encrypt;
%ignore geier_encrypt_text;
%ignore geier_decrypt;
%ignore geier_decrypt_text;
%ignore geier_xml_to_text;
%ignore geier_xml_to_encoded_text;
%ignore geier_text_to_xml;


// ==== typemaps =====

// --- string inputs ---
%typemap(in, numinputs=1) (const unsigned char *input, size_t inlen) {
  if (!PyString_Check($input)) { // todo: allow unicode?
    PyErr_SetString(PyExc_ValueError, "Expecting a string");
    return NULL;
  }
  $1 = (void *) PyString_AsString($input);
  $2 = PyString_Size($input);
};

// --- string results ---
%typemap(in, numinputs=0) (unsigned char **output, size_t *outlen) (unsigned char *temp, size_t temp1) {
  $1 = &temp;
  $2 = &temp1;
};
%typemap(argout) (unsigned char **output, size_t *outlen) {
  Py_XDECREF($result);   /* Blow away any previous result */
  if (result != 0) { // an error occured
    Py_INCREF(Py_None);
    $result = Py_None;
  } else {
    $result = PyString_FromStringAndSize((char *)*$1,*$2);
    if (*$1) { xmlFree(*$1); };
  };
};

//
// Interfacing to libxml2.xmlDoc:
//
// The Python implementation of libxml2 implements a class 'xmlDoc'.
// The pointer to the underlying PyCObject is kept in the attribute
// '_o'. For the geier interface this means:
//   - the Python wrapper has to pass '_o' to the C layer
//   - the C layer checks whether this is realy a pointer to xmlDoc
//   - resulting xmlDocs have to be wrapped info a PyCObject
//     and the Python layer has to instantiate an libxmls.xmlDoc of it.
//

// --- xmlDoc *input ---
%typemap(in) (xmlDoc *input) (PyCObject *) {
  if ((!PyCObject_Check($input)) || strcmp(PyCObject_GetDesc($input), "xmlDocPtr")) {
    PyErr_SetString(PyExc_ValueError, "Expecting a xmlDoc wrapped into a PyCObject ");
    return NULL;
  };
  $1 = PyCObject_AsVoidPtr($input);

};

// --- xmlDoc **output ---
%typemap(in, numinputs=0) (xmlDoc **output) (xmlDoc * temp) {
  $1 = &temp;
};
%typemap(argout) (xmlDoc **output) {
  if (result == 0) {  // okay
    Py_XDECREF($result);   /* Blow away any previous result */
    $result = PyCObject_FromVoidPtr(*$1, NULL);
  }
};

// ==== end of typemaps ===

// --- include geier.h ---
%include "geier.h"

// get automatic condtructors/destructors for geier_context
%extend geier_context {
  geier_context();
  ~geier_context();
};

// --- include Python class extension for Context --
%include "geier-Context.py.i"
