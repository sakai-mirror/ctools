#!/usr/bin/perl -w
# Run some tests on our externals file to see if it makes sense
#
# $HeadURL$
# $Id$
#
#
# The line below will find duplicate module definitions.
# externalsLint.pl ctools_2-4-xS.externals  | sort | uniq -c | grep -v '  1'

# This will produce a list of what modules are different between two externals files.
# externalsLint.pl ctools_2-4-xR.externals ctools_2-4-xS.externals | sort | uniq -c | fgrep -v ' 2'

$MODULE_DEFS=0;
$REVISIONS=1;

while(<>) {
  next if (/^\s*#/ | /^\s*$/);
  ($module,$revision) = m|\s*(\S+)\s+-r(\d+)\s|;
  print "$module\n" if ($MODULE_DEFS);
  print "$module $revision\n" if ($REVISIONS);
}

#end
