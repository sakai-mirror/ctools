#!/usr/bin/perl 
use strict;
use Fcntl;
use POSIX;
use File::Path;

#use Test::Simple tests=>3;
use Test::More qw(no_plan);

require "removeBuildParts.pl";

#verbose(1);
#dryRun(1);

my ($scriptName) = ( $0 =~ m|.*/(.*)| );

my $testDir = "/tmp/$scriptName.test.$$";

#print "testDir: $testDir\n";

makeTestDir($testDir);
is( -d $testDir, 1, "create test directory" );

testRemoveFile($testDir);

testRemoveFileWithoutPermission($testDir.".noperm");

testRemoveDir($testDir);

# make sure it can remove files
testRemoveFileList($testDir);
# make sure it can remove files recursively
testRemoveFileListRecursive($testDir);

#################

sub testRemoveFile {
  my($testDir) = shift;
  my $file1 = "$testDir/TEST";
  makeTestFile($file1);
  is( -e $file1, 1, "file created" );

  my $rc;
  my $badFile = $file1 . "X";
  $rc = removeFile($badFile);
  is(
     ( -e $badFile ),
     ( $rc == 0 ? undef: 1 ),
     "don't remove file that doesn't exist [$badFile]"
    );
  $rc = removeFile($file1);
  is( ( -e $file1 ), ( $rc == 0 ? undef: 1 ), "remove added file [$file1]" );
}

sub testRemoveFileWithoutPermission {
  my($testDir) = shift;
  my $file1 = "$testDir/TESTNoPermission";
  makeTestDir($testDir);
  is( -d $testDir, 1, "create test directory without permissions." );
  `chmod a-w $testDir`;	
  eval {
    makeTestFile($file1);
  };
  isnt( -e $file1, 1, "no permission file created" );
  `chmod a+w $testDir`;	
  testRemoveDir($testDir);
}

sub testRemoveDir {
  my $dir1   = shift;
  my $badDir = $dir1 . "X";

  is( -d $dir1, 1, "dir exists" );
  isnt( -d $badDir, 1, "badDir is absent" );

  my $rc;
  #	my $badDir = $dir1 . "X";
  $rc = removeDir($badDir);
  is(
     ( -d $badDir ),
     ( $rc == 0 ? undef: 1 ),
     "don't remove dir that doesn't exist [$badDir]"
    );

  $rc = removeDir($dir1);

  is( ( -d $dir1 ), ( $rc == 0 ? undef: 1 ), "removed test dir [$dir1]" );
}

sub testRemoveFileList {
  my ($dir1) = @_;
  
  # make some directories and files 
  my $testDir = "$dir1/RemoveFileListDir";
  my $file1 = "$testDir/TestFileOne";
  my $file2 = "$testDir/TestFileTwo";
  makeTestDir($dir1);
  is( -d $dir1, 1, "dir 1 exists" );
  makeTestDir($testDir);
  is( -d $testDir, 1, "dir 2 exists" );
  makeTestFile($file1);
  is (-e $file1,1,"list remove file 1 exists");
  makeTestFile($file2);
  is (-e $file2,1,"list remove file 2 exists");

  # remove the files
  removeBuildPartsList($dir1,"$file1,$file2");
  is (-e $file1,undef,"file 1 removed");
  is (-e $file2,undef,"file 2 removed");
  # but keep the directory
  is (-d $testDir,1,"directory remains");
  # remove the directory
  my $rc = removeBuildPartsList($dir1,"$testDir");
  is (-d $testDir,undef,"remove test sub dir: [$testDir]");
  is (-d $dir1,1,"keep test dir: [$dir1]");

  # clean up
  $rc = removeDir($dir1);
  is( ( -d $dir1 ), ( $rc == 0 ? undef: 1 ), "removed test dir [$dir1]" );

}

sub testRemoveFileListRecursive {
  my ($dir1) = @_;
  
  # make some directories and files 
  my $testDir = "$dir1/RemoveFileListDir";
  my $file1 = "$testDir/TestFileOne";
  my $file2 = "$testDir/TestFileTwo";
  makeTestDir($dir1);
  is( -d $dir1, 1, "dir 1 exists" );
  makeTestDir($testDir);
  is( -d $testDir, 1, "dir 2 exists" );
  makeTestFile($file1);
  is (-e $file1,1,"list remove file 1 exists");
  makeTestFile($file2);
  is (-e $file2,1,"list remove file 2 exists");


  # remove the directory and sub directories
  my $rc = removeBuildPartsList($dir1,"$testDir");
  is (-e $file1,undef,"file 1 removed");
  is (-e $file2,undef,"file 2 removed");

  is (-d $testDir,undef,"remove test sub dir: [$testDir]");
  is (-d $dir1,1,"keep test dir: [$dir1]");

  # clean up
  $rc = removeDir($dir1);
  is( ( -d $dir1 ), ( $rc == 0 ? undef: 1 ), "removed test dir [$dir1]" );

}


sub makeTestFile {
  my ($fileName) = shift;
  # print "makeTestFile: fileName: [$fileName]\n";
  open TESTFILE, "+>$fileName" || die("Can't open file: [$fileName] $!");
  print TESTFILE "test file: [$fileName] created from $0 at ", `date`;
  close TESTFILE || die("Can't close file: [$fileName] $!");
}

sub makeTestDir {
  my ($testDir) = @_;
  mkdir( $testDir, 0777 )
    || die("Can not make test directory: [$testDir] $!");
}

#end

