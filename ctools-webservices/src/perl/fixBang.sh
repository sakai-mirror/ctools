# No bang line since this is to fix bang lines
# Run this changing the original and final perl locations as necessary
#find . -name \*.bang -exec fgrep -il '#!' {} /dev/null \; | xargs perl -i.orig -p -e's|/usr/local/perl|/usr/local/bin/perl|'
echo "Read this file to find out how to globally change the hash bang line in the perl scripts."
#
