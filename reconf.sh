libtoolize --force --automake
aclocal
automake -a -Wall
autoconf
autoheader -Wall
