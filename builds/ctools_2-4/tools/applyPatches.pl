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

my ($log,$patchDir);
my $applyPatchesTrace = 0;

print "ap: args:",join("|",@ARGV),"\n" if ($applyPatchesTrace);

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

  exit 0 unless($patchFileNames) ;
  my (@patchFileNames) = split(",",$patchFileNames);
  my ($maxRc,$fullLog);
  $maxRc = 0;
  foreach (@patchFileNames) {
    print "******** patch file: [$_] ***********\n";
    my $rc = applyOnePatchFile("$patchesDir/$_",$logFileName);
    print "aPFL: rc: [$rc]\n" if ($applyPatchesTrace);
    $maxRc = ($rc != 0 ? abs($rc) : $maxRc);
    print "*************************************\n";
  }
  print "aPFL: maxRc: [$maxRc]\n" if ($applyPatchesTrace);
  exit ($maxRc == 0 ? 0 : 1);
}

# Apply a single patch file and return the return code.
# The log output will be ignored.
sub applyPatchFile {
  my ($patchFileName) = shift;
  my $cmd = makePatchCmd($patchFileName);
  return runShellCmdGetResult($cmd);
}


# Apply a single patch file, log the output and 
# return the return code.

sub applyOnePatchFile {
  my($patchFileName,$logfile) = @_;
  print "$0: patchFileName: [$patchFileName] logfile: [$logfile]\n" if ($applyPatchesTrace);
  my($rc,$log) = applyPatchFile($patchFileName);
  appendTextToFile($logfile,$log);
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
sub makePatchCmd {
  my ($patchFileName) = @_;
  # To get more debug information include this string in the command string below.
  my $patchDebugCmds = " --debug=10 --dry-run ";
  my $patchCmd = "patch -p0 --verbose --ignore-whitespace --remove-empty-files --input=$patchFileName";
}

# Append text to a file.
sub appendTextToFile{
  my($fileName,$text) = @_;
  $text .= `date`;
  print "USING TEXTFILE: [$fileName]\n" if ($applyPatchesTrace);
  open(TEXTFILE,">>$fileName") or die("Can't open text file: [$fileName] $!");
  print TEXTFILE $text;
  close(TEXTFILE) or die("can't close text file $!");
}

# If invoke the file as a script and provide the information required
# then apply a patch file.  Otherwise do nothing explicitly.  That
# allows invoking the file by itself to do something useful and allows
# making the routines in this script available to other scripts by
# including the file in other Perl script (via 'require
# "applyPatches.pl";').

# Use this if only doing 1 patch file.
#applyOnePatchFile(@ARGV) if (@ARGV);

# Use this if doing a bunch of patch files.
applyPatchFileList(@ARGV) if (@ARGV);

#end
1;
