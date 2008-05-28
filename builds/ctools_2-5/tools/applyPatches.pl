#!/usr/bin/perl -w
# Apply diff patch file to code.
#
# $HeadURL$
# $Id$
#
# Routines to apply a patch to files in the current directory.  It
# will run standalone or can be included in another Perl script.
# Since it wraps a bash script it returns bash type return codes.
# I.e. 0 means success, non-zero means failure.

#### TTD: 
#
# - test the logic to allow inclusion on it's own.  It probably will
# NOT deal with the situation where included in another script that
# was invoked with arguments.

### NOTES: Have tests for some of the methods, but haven't tested the
# actual application of the patch.  Automating that test seems not
# worth the work at the moment, but would be worth it if it turns out
# to problematic.

use strict;
use Cwd 'abs_path';
use File::Basename 'dirname';
use IO::File;
use File::Copy;

my ($log,$patchDir);
my $applyPatchesTrace = 1;
#Add when testing to not actually apply the patches
my $dryrun = 1;

print "ap: args:",join("|",@ARGV),"\n" if ($applyPatchesTrace);

if (@ARGV == 0) {
    print "Usage: $0 <log file> <patches directory> <build directory> <comma separated patch files>\n";
    exit;
}

## Take a list of patch files and apply them, accumulating
# the log file and maintaining a non-zero return code if any
# occur.
sub applyPatchFiles {
  my (@patchFileNames) = @_;
  
  my ($maxRc,$fullLog);
  $maxRc = 0;
  foreach (@patchFileNames) {
    my ($rc,$log) = applyPatchFile($_);
        $fullLog .= $log;
    $maxRc = ($rc != 0 ? abs($rc) : $maxRc);
  }
  return $maxRc;
}

# take a list of patch files and apply them.
sub applyPatchFileList {
  my ($logFileName,$patchesDir,$buildDir,$patchFileNames) = @_;
  #Since we might be moving around
  $buildDir = abs_path ($buildDir);
  $patchesDir = abs_path($patchesDir);
      
  die "Please specify a build directory" unless (-d $buildDir);
  die "Please specify a patch directory" unless(-d $patchesDir);
  die "Please specify at least one patch name" unless($patchFileNames) ;
  print "Applying patch files\n";

  my (@patchFileNames) = split(",",$patchFileNames);
  my ($maxRc,$fullLog,$copyFile);
  $maxRc = 0;
  my $patchFile;
  foreach $patchFile (@patchFileNames) {
    print "- patch file: [$_]\n";

    my $rc = applyOnePatchFile(patchfile=>"$patchesDir/$patchFile",builddir=>$buildDir,logfile=>$logFileName);
    print "aPFL: rc: [$rc]\n" if ($applyPatchesTrace);
    if ($rc == 0) {
        $rc = applyOneActionFile(patchfile=>"$patchesDir/$patchFile",builddir=>$buildDir,logfile=>$logFileName);
    }
    else {
	print "Not running actions on patch $patchFile that failed\n";
    }
    $maxRc = ($rc != 0 ? abs($rc) : $maxRc);
  }
  print "aPFL: maxRc: [$maxRc]\n" if ($applyPatchesTrace);
  if ($maxRc !=0 ) {
	print "One or more patches failed, results saved to a log file\n";
  }
  exit ($maxRc == 0 ? 0 : 1);
}

#Opens a file in the format
#=?= <source file>,<destination directory> 
#And performs some action on that file
#Currently the only action supported is the copy action =c=
#All source files are relative to the patch directory and destinations are relative to buildDir
# %args = 'patchfile', 'builddir', 'logfile'
sub applyOneActionFile {
    my %args = @_;

    my $rc;
    print "Applying Action File\n";
    my $fh = new IO::File;
    unless ($fh->open($args{'patchfile'},'r')) {
	print STDERR "Can't open $args{'patchfile'}: $!\n";
	return;
    }

    my $patchDir = dirname($args{'patchfile'});

    my $action;
    while (<$fh>) {	    # note use of indirection
	if (($action) = $_ =~ m/^=(\w)=/) {
	    if ($action eq 'c') {
		my ($srcFile,$destFile) = $_ =~ m/.*=(.*),(.*)/;
		$rc = copy("$patchDir/$srcFile","$args{'builddir'}/$destFile");
	    }
	}   
    }

    $fh->close;
    return $rc;
}

# Apply a single patch file and return the return code.
# The log output will be ignored.
# %args = $'patchfile', $'builddir', $'logfile'
sub applyPatchFile {
  my %args = @_;
  my $cmd = makePatchCmd(patchfile=>$args{'patchfile'},builddir=>$args{'builddir'});
  return runShellCmdGetResult($cmd);
}


# Apply a single patch file, log the output and 
# return the return code.
# %args = $'patchfile', $'builddir', $'logfile'

sub applyOnePatchFile {
  my %args = @_;
  print "$0: patchFileName: [$args{'patchfile'}] logfile: [$args{'logfile'}]\n" if ($applyPatchesTrace);
  
  my($rc,$log) = applyPatchFile(%args);
  if ($rc !=0 ) {
	print "Patching $_ failed with code: $rc\n";
  }

  appendTextToFile(filename=>$args{'logfile'},text=>$log);
  print "aOPF: rc: [$rc]\n" if ($applyPatchesTrace);
  return($rc);
}


# Run a shell command capturing the return code and the stdout and stderr.
# Stderr and stdout will be combined in the same output stream.
# Will return a $rc in scalar context and the $rc and output in list context.
sub runShellCmdGetResult {
  my $cmd = shift;

  my $log = "";
  print "rSCGR: cmd: [$cmd]\n" if ($applyPatchesTrace);

  # run the command
  my $result = `$cmd 2>&1`;
  my $rc = $?;
  chomp $result;
  print "rc: [$rc] result: [$result]\n" if ($applyPatchesTrace);
  $log = "cmd: [$cmd]";
  $log .= " cmd result: [$result]";

  return (wantarray ? ($rc,$log) : $rc);
}

# Create a sh command to apply a patch in the current directory.
# %args = $'patchfile', $'builddir', $'logfile'
sub makePatchCmd {
  my %args=@_;
  
  my $patchDebugCmds;
  # To get more debug information include this string in the command string below.

  if ($dryrun == 1) {
     $patchDebugCmds = " --debug=1 --dry-run ";
  }
  my $patchCmd = "patch -p0 --verbose -d $args{'builddir'} --ignore-whitespace --remove-empty-files --input=$args{'patchfile'} $patchDebugCmds";
}

# Append text to a file.
# %args = $'filename', $'text'
sub appendTextToFile{
  my %args = @_;
  $args{'text'} .= `date`;
  print "USING TEXTFILE: [$args{'filename'}]\n" if ($applyPatchesTrace);
  open(TEXTFILE,">>$args{'filename'}") or die("Can't open text file: [$args{'filename'}] $!");
  print TEXTFILE $args{'text'};
  close(TEXTFILE) or die("can't close text file $!");
}

# If invoke the file as a script and provide the information required
# then apply a patch file.  Otherwise do nothing explicitly.  That
# allows invoking the file by itself to do something useful and allows
# making the routines in this script available to other scripts by
# including the file in other Perl script (via 'require
# "applyPatches.pl";').

# Use this if doing a bunch of patch files.
applyPatchFileList(@ARGV) if (@ARGV);

#end
1;
