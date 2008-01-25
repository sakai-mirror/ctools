#!/usr/bin/perl -w
# Run some tests on our build properties files to detect problems or changes.

#
# $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/builds/ctools_2-4/configs/ctools_2-4-x_CANDIDATE/externalsLint.pl $
# $Id: externalsLint.pl 40542 2008-01-25 18:45:04Z dlhaines@umich.edu $
#
# Currently only extracting patch file names.
#
# The line below will find duplicate patch file names and delete those in both files.
# propertiesLint.pl ctools_2-4-xR.properties  ctools_2-4-xS.properties | sort | uniq -c | fgrep -v '  2'

while (<>) {

  next if (/^\s*#/ | /^\s*$/);

  # capture the current file name.  Might want it later.
  unless($filename) {
    #    print "file: [",$ARGV,"]\n";
    $filename = $ARGV;
  }

  if (/^\s*patchFileNames=(.+)/) {
    ($patchFileList) = ($1);
    #    print "patch file name list: [$patchFileList]\n";
    print "\n";
    print join("\n",split(',',$patchFileList));
  }
}

#end
