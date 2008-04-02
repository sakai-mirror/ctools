#!/usr/bin/perl

#use Test::Simple tests=>3;
use Test::More tests=>11;

require "applyPatches.pl";

my ($rc,$list);

#ok (1 eq 1,"test test");

## create a patch command
is (makePatchCmd("input_PATCHFILENAME","input_PATCHDIR"),
    "patch -p0 --verbose --ignore-whitespace --remove-empty-files --input=input_PATCHFILENAME",
    "build patch command");

# is (makePatchCmd("input_PATCHFILENAME","input_PATCHDIR"),
#     "patch -p0 --verbose --ignore-whitespace --remove-empty-files --input=input_PATCHDIR/input_PATCHFILENAME",
#     "build patch command");


######## check the return code and log handling from run command routine

## check testing the return code from run command routine
is (runShellCmdGetResult("[ 1 -eq 2 ] "),"256","shell command should fail (scalar context)");
is (runShellCmdGetResult("[ 1 -eq 1 ] "),"0","shell command success (scalar context)");

## check command handling without checking log
($rc,$list) = runShellCmdGetResult("[ 1 -eq 1 ]");
is ($rc, "0","shell command success rc (array context)");
is ($list,"cmd: [[ 1 -eq 1 ]] cmd result: []","shell command success log (array context)");

($rc,$list) = runShellCmdGetResult("[ 1 -eq 2 ]");
is ($rc, "256","shell command success rc (array context)");
is ($list,"cmd: [[ 1 -eq 2 ]] cmd result: []","shell command success log (array context)");

## check with text output
($rc,$list) = runShellCmdGetResult("echo 'HI' && [ 1 -eq 1 ]");
is ($rc, "0","shell command success rc (array context)");
is ($list,"cmd: [echo 'HI' && [ 1 -eq 1 ]] cmd result: [HI]","shell command success log (array context)");

## check with text output
($rc,$list) = runShellCmdGetResult("echo 'HI' && [ 1 -eq 2 ]");
is ($rc, "256","shell command should fail rc (array context)");
is ($list,"cmd: [echo 'HI' && [ 1 -eq 2 ]] cmd result: [HI]","shell command should fail log (array context)");

#end
