#!/usr/bin/perl -w
# Run some tests on our externals file to see if it makes sense
# $HeadURL:$
# $Id:$
#
#
# The line below will find duplicate module definitions.
# externalsLint.pl ctools_2-4-xS.externals  | sort | uniq -c | grep -v '  1'

while(<>) {
  next if (/^\s*#/ | /^\s*$/);
  ($module) = m|\s*(\S+)\s|;
  print "$module\n";
}
#end
