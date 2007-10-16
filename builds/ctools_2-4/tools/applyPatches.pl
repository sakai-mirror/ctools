#!/usr/bin/perl -w
# Apply diff patch file to code.
#
# $HeadURL:$
# $Id:$
#
# Routines to apply a patch to files in the current directory.  It
# will run standalone or can be included in another Perl script.

#### TTD: 
#
# - test the logic to allow inclusion on it's own.  It probably will
# NOT deal with the situation where included in another script that
# was invoked with arguments.

### NOTES:
# Have tests for some of the methods, but haven't tested the actual
# application of the patch.  Automating that seems not worth the work
# at the moment, but would be worth it if it turns out to problematic.

use strict;

my ($log,$patchDir);
my ($applyPatchesTrace) = 0;

#my ($patchFileName,$logFileName,$buildDir) = @ARGV;
#my ($patchFileName,$patchfileDir,$logFileName,$buildDir) = @ARGV;
#my ($logFileName,$patchfileDir,$buildDir,$patchFileNames) = @ARGV;

print "ap: args:",join("|",@ARGV),"\n" if ($applyPatchesTrace);

# sub applyPatchFileOld {
#   my $cmd = makePatchCmd($patchFileName);

#   # run the command
#   my $result = `$cmd 2>&1`;
#   my $rc = $?;
#   chomp $result;
#   print "rc: [$rc] result: [$result]\n" if ($applyPatchesTrace);
#   $log .= "cmd result: \n[$result]\n";

#   if ($rc) {
#     print "cmd: [$cmd] failed with rc: [$rc] result: [$result\n";
#     return $rc;
#   }
# }


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
#  my ($logFileName,$patchFileNames) = @_;
  my ($logFileName,$patchesDir,$buildDir,$patchFileNames) = @_;

  exit 0 unless($patchFileNames) ;
  my (@patchFileNames) = split(",",$patchFileNames);
  my ($maxRc,$fullLog);
  $maxRc = 0;
  foreach (@patchFileNames) {
    print "patch file: [$_]\n";
 #    my ($rc,$log) = applyPatchFile($_);
#    my ($rc,$log) = applyOnePatchFile("$patchesDir/$_",$logFileName);
    my $rc = applyOnePatchFile("$patchesDir/$_",$logFileName);
#    print "aPFL: rc: [$rc] log: [$log]\n";
    print "aPFL: rc: [$rc]\n";
#    $fullLog .= $log;
    $maxRc = ($rc != 0 ? abs($rc) : $maxRc);
  }
  print "aPFL: maxRc: [$maxRc]\n";
 #  return 1;
 #  return $maxRc;
#  exit $maxRc;
  exit ($maxRc == 0 ? 0 : 1);
}

# END {
#   return 1;
# }

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
  print "$0: patchFileName: [$patchFileName] logfile: [$logfile]\n"; 
  my($rc,$log) = applyPatchFile($patchFileName);
#  appendTextToFile($logFileName,$log);
  appendTextToFile($logfile,$log);
  print "aOPF: rc: [$rc]\n";
  return($rc);
}


# Run a shell command capturing the return code and the stdout and stderr.
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
  # include debug string cmd string to get more debugging information
  my $patchDebugCmds = " --debug=10 --dry-run ";
  my $patchCmd = "patch -p0 --verbose --ignore-whitespace --remove-empty-files --input=$patchFileName";
}

# Append text to a file.
sub appendTextToFile{
  my($fileName,$text) = @_;
  $text .= `date`;
  print "USING TEXTFILE: [$fileName]\n";
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

#     <sequential>
#     <echo> applying patch @{patchFileName}</echo>
#     <echo file="${logs.dir}/${ant.project.name}.patches.log" append="true" >
#      ********************************************************** 
#      applying patch @{patchFileName}
#      ********************************************************** 
#     </echo>
#     <exec executable="patch"
# 	  dir="${build.dir}"
# 	  failonerror="true"
# 	  output="${logs.dir}/${ant.project.name}.patches.log"
# 	  append="true">
#       <arg value="-p0" />
#       <arg value="--verbose" />
#       <arg value ="--ignore-whitespace" />
#       <!-- <arg value="\-\-debug=10" /> -->
#       <!-- <arg value="\-\-dry-run" />   -->
#       <arg value="--input=${patches.dir}/@{patchFileName}" />
#       <!--      <arg value="\-\-backup" /> -->
#       <arg value="--remove-empty-files" />
#       <!-- <arg value="\-\-debug=15" /> -->
#     </exec>
#     </sequential>

#end
1;
