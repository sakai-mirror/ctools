#!/usr/bin/perl

use strict;
use Fcntl;
use POSIX;

#use Test::Simple tests=>3;
use Test::More tests=>11;

require "removeBuildParts.pl";


print "tmpname: [",tmpnam(),"]\n";


$tmpDirName = tmpnam();
# how use tmpnam to also get file names? Won't they have the /var/tmp in them?

mkdir($tmpDirName,0777) || die("can't make temp directory: [$tmpDirName]

#my ($rc,$list);

#ok (1 eq 1,"test test");

## check command handling without checking log
#($rc,$list) = runShellCmdGetResult("[ 1 -eq 1 ]");
#is ($rc, "0","shell command success rc (array context)");
#is ($list,"cmd: [[ 1 -eq 1 ]] cmd result: []","shell command success log (array context)");




#end
