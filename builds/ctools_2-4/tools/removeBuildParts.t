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

testRemoveDir($testDir);

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

sub testRemoveDir {
	my $dir1   = shift;
	my $badDir = $dir1 . "X";

	is( -d $dir1, 1, "dir exists" );
	isnt( -d $badDir, 1, "badDir is absent" );

	my $rc;
	my $badDir = $dir1 . "X";
	$rc = removeDir($badDir);
	is(
		( -d $badDir ),
		( $rc == 0 ? undef: 1 ),
		"don't remove dir that doesn't exist [$badDir]"
	);

	$rc = removeDir($dir1);

	is( ( -d $dir1 ), ( $rc == 0 ? undef: 1 ), "removed test dir [$dir1]" );
}

sub makeTestFile {
	my ($fileName) = shift;
	open TESTFILE, "+>$fileName" || die("Can't open file: [$fileName] $!");
	print TESTFILE "test file: [$fileName] created from $0 at ", `date`;
	close TESTFILE || die("Can't close file: [$fileName] $!");

	#  print `cat $fileName`;
}

sub makeTestDir {
	my ($testDir) = @_;
	mkdir( $testDir, 0777 )
	  || die("Can not make test directory: [$testDir] $!");
}

#end

