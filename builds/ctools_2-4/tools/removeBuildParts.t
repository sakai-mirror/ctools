#!/usr/bin/perl
use strict;
use Fcntl;
use POSIX;
use File::Path;
#use Test::Simple tests=>3;
use Test::More tests=>11;

require "removeBuildParts.pl";

my $testDir = "/tmp/$0.test.$$";

print "testDir: $testDir\n";

makeTestDir($testDir);
is (-d $testDir, 1, "create test directory");

testRemoveFileFromBuild();

removeDirFromBuild($testDir);
is (-d $testDir, undef, "removed test directory");

removeTestDir($testDir);
is (-d $testDir, undef, "removed test directory");

#print "tmpname: [",tmpnam(),"]\n";

#$tmpDirName = tmpnam();
# how use tmpnam to also get file names? Won't they have the /var/tmp in them?

#mkdir($tmpDirName,0777) || die("can't make temp directory: [$tmpDirName]");

#my ($rc,$list);
#ok (1 eq 1,"test test");

## check command handling without checking log
#($rc,$list) = runShellCmdGetResult("[ 1 -eq 1 ]");
#is ($rc, "0","shell command success rc (array context)");
#is ($list,"cmd: [[ 1 -eq 1 ]] cmd result: []","shell command success log (array)lskdfjlaskdfjlsa

sub testRemoveFileFromBuild{
  my $file1 = "$testDir/TEST";
  makeTestFile($file1);
  is(-e $file1, 1, "file created");
  removeFileFromBuild($file1);
  is(-e $file1, undef, "file removed");
}

sub makeTestFile {
  my($fileName) = shift;
  open TESTFILE, "+>$fileName" || die("Can't open file: [$fileName] $!");
  print TESTFILE "test file: [$fileName] created from $0 at ",`date`;
  close TESTFILE || die("Can't close file: [$fileName] $!");
  #  print `cat $fileName`;
}

sub removeTestFile {
}

sub makeTestDir {
  my($testDir) = @_;
  mkdir($testDir,0777) || die("Can not make test directory: [$testDir] $!");
}

sub removeTestDir {
  my($testDir) = @_;
#  print "remove: [$testDir]\n";
  rmtree($testDir);
}

#end
