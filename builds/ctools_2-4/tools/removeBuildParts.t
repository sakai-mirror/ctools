#!/usr/bin/perl

#use Test::Simple tests=>3;
use Test::More tests=>11;

require "removeBuildParts.pl";

#my ($rc,$list);

#ok (1 eq 1,"test test");

## check command handling without checking log
#($rc,$list) = runShellCmdGetResult("[ 1 -eq 1 ]");
#is ($rc, "0","shell command success rc (array context)");
#is ($list,"cmd: [[ 1 -eq 1 ]] cmd result: []","shell command success log (array context)");


#end
