#! /bin/sh

set -x
libtoolize --force --automake
aclocal -I config
autoheader
automake --add-missing --copy
autoconf
