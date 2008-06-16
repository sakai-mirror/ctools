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

=readme
This supports regular diff patches but also extended patches with 2 commands right now
All of the destinations are relative to the build directory. 
The sources are relative to the directory of the patch file directory 
IF they do not begin with a / or a http://.

You can have these in a separate patch or append these to the top of your patch (patch ignores
them).

---- PATCH.FILE ----
=copy= <source>,<destination>
Example: =copy= to-bottom.png,user/user-tool-prefs/tool/src/webapp/prefs/
=svnm= <source>,<source revision>,<destination>,<destination revision>

#Example: =svnm= https://source.sakaiproject.org/svn/user/branches/SAK-12870_2-5-x/user-tool-prefs,43671,user/user-tool-prefs
Put something like this in your patch file to make patch happy:

--- /dev/null
+++ SAK-12870.tmp   <-- This has to be a unique temporary name unless you are patching something
@@ -0,0 +1 @@
+ 

---- END FILE ----
=cut

use strict;
use Cwd 'abs_path';
use File::Basename 'dirname';
use File::Basename;
use File::Path;
use IO::File;
use File::Copy;
use FindBin qw($Bin);
use Data::Dumper;


my ($log,$patchDir);
my $applyPatchesTrace = 0;
#Add when testing to not actually apply the patches
my $dryrun = 0;

print "ap: args:",join("|",@ARGV),"\n" if ($applyPatchesTrace);

if (@ARGV == 0) {
    print "Usage: $0 <log file> <patches directory> <build directory> <comma separated patch files>\n";
    print "Example: $0 out.log ../patches ../work/ctools_2-5-x_CANDIDATE/work.prod/build SAK-12868.patch\n";
    exit;
}

#Trims whitespace from beginning and end of string
sub trim($)
{
    my $string = shift;
    if ($string) {
        $string =~ s/^\s+//;
	$string =~ s/\s+$//;
    }
    return $string;
}

#Returns a hash containing the results of an svn info command
# %args = 'repo'
#Should return an array containing these keys:
#
#Path, URL, Repository Root, Repository UUID, Revision, Node Kind, Schedule, Last Changed Author,Last Changed Rev, Last Changed Date

sub svnInfo(%) {
    my %args = @_;
    my %data;
    my (@results,$result);
    if ($args{'repo'}) {
	@results = `svn info $args{'repo'}`;
	foreach $result (@results) {
	    #Only split on first : . . . Thought about using YAML because it's similar
            my ($key,$value) = split(/:/,$result,2); 
	    if ($key) {
	      $data{trim($key)} = trim($value);
	    }
	}
    }
    return %data;
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

sub cleanTmpFiles($) {
    my $buildDir = shift;
    unlink(glob("$buildDir/*.tmp"));
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
  cleanTmpFiles($buildDir);
  print "Applying patch files\n";

  my (@patchFileNames) = split(",",$patchFileNames);
  my ($maxRc,$fullLog,$copyFile);
  $maxRc = 0;
  my $patchFile;
  foreach $patchFile (@patchFileNames) {
    print "- patch file: [$patchFile]\n";

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
	print "One or more patches failed, results saved to a log file.\n";
  }
  exit ($maxRc == 0 ? 0 : 1);
}

#Opens a file in the format
#=?= <source file>,<destination directory> 
#And performs some action on that file
#Currently the only action supported is the copy action =c=
#All source files are relative to the patch directory and destinations are relative to buildDir
# %args = 'patchfile', 'builddir', 'logfile'
sub applyOneActionFile(%) {
    my %args = @_;

    my $log = "";

    my $rc = 0;
    $log.=print "Applying Action File\n";
    my $fh = new IO::File;
    unless ($fh->open($args{'patchfile'},'r')) {
	print STDERR "Can't open $args{'patchfile'}: $!\n";
	return;
    }


    my $patchDir = dirname($args{'patchfile'});

    my ($action,$target);
    while (<$fh>) {	    # note use of indirection
	if (($action,$target) = $_ =~ m/^=(\w*)=\s*(.*)/) {
	    #If the regex found an action with no target.
	    if ($action && !$target) {
		$log.= "No target found for action\n";
		return 3;
	    }
	    if ($action eq "copy") {
		my ($srcFile,$destFile) = $target =~ m/(.*),(.*)/;
		$log.= "copy action $patchDir/$srcFile->$args{'builddir'}/$destFile\n";
		if ($srcFile&&$destFile) {
			#Might have to make the destination directory
			my ($destLoc) = "$args{'builddir'}/$destFile";
			my ($pFilename,$pDirectory) = fileparse($destLoc);
			if (!-d $pDirectory) {
			    print "$pFilename $pDirectory";
			    mkpath($pDirectory);
			}
			$rc = $! unless copy("$patchDir/$srcFile",$destLoc);
		}
	    }
	    #Removes a file from the build, should check to make sure destination is still within build directory 
	    if ($action eq "rm") {
		print "rm action\n";
		my ($srcFile) = $target =~ m/(.*)/;
		$log.= "rm action $args{'builddir'}/$srcFile\n";

		my ($rmFile) = "$args{'builddir'}/$srcFile"; 
		my ($rmFileDir) = abs_path($rmFile);
		if ($rmFileDir =~ m/\Q$args{'builddir'}\E/) {
			#Don't fail if it doesn't exist for now
			if (-f $rmFile) {
			    $rc = $! unless unlink("$rmFile");
		    	}
			else {
			    print "File $rmFile not found to remove\n";
			    $log.="File $rmFile not found to remove\n";
			}
		}
		else {
			$log.="$rmFileDir is outside of build directory";
			$rc = 3;
		}
	    }
	    elsif ($action eq "svnm")  {
		print "svn action\n";
		my ($svnSrc,$srcRev,$svnDest,$destRev,$wCopy);
		#First form
		($svnSrc,$srcRev,$svnDest,$destRev,$wCopy) = $target =~ m/(.*?)\@(.*?)\s+(.*?)\@(.*?)\s+(.*)$/;
		#Second Form
		if (!$wCopy) {
		    ($svnSrc,$srcRev,$wCopy) = $target =~ m/(.*?)\@(.*?)\s+(.*)$/;
		}

		my $cmd="";
		my $svnDebugCmds = "";
		if ($wCopy && $svnSrc && $srcRev) {
		    #See if we need to add paths to the source or destination
		    if ($svnSrc =~ m/http.*:\/\// || $svnSrc =~ m/^\//) {}
		    else {$svnSrc=$patchDir."/".$svnSrc;}

		    if ($wCopy =~ m/http:\/\// || $wCopy =~ m/^\//) {}
		    else {$wCopy=$args{'builddir'}."/".$wCopy;}

		    #Get information about the destination of the merge 
		    #Get the revision and URL that this was checked out from so we can compare
		    #Since I can't figure out the syntax to make it compare otherwise.
		    if (!$destRev) {
			my %destInfo = svnInfo(repo=>$wCopy);
			$destRev = $destInfo{'Revision'};
			$svnDest = $destInfo{'URL'};
		    }

		    if ($dryrun == 1) {
			 $svnDebugCmds = " --dry-run ";
		    }
		    if ($destRev && $svnDest) {
			$cmd = "svn merge $svnDebugCmds $svnDest\@$destRev $svnSrc\@$srcRev $wCopy";
			print $cmd;
			my $result = runShellCmdGetResult($cmd);
			$rc = $?;
			$log.=$result;
		    }
		    else {
			$log.="info for working copy $wCopy not found!";
			$rc=4;
		    }
		}
		else {
		    print "svn action called with incorrect parameters\n";
		    $rc = 2;
		}
	    }
	}   
	if ($rc != 0) {
	    appendTextToFile(filename=>$args{'logfile'},text=>$log);
	    $fh->close;	    
	    return $rc;
	}
    }

    appendTextToFile(filename=>$args{'logfile'},text=>$log);
    $fh->close;
    return $rc;
}

# Apply a single patch file and return the return code.
# The log output will be ignored.
# %args = $'patchfile', $'builddir', $'logfile'
sub applyPatchFile(%) {
  my %args = @_;
  my $cmd = makePatchCmd(patchfile=>$args{'patchfile'},builddir=>$args{'builddir'});
  return runShellCmdGetResult($cmd);
}


# Apply a single patch file, log the output and 
# return the return code.
# %args = $'patchfile', $'builddir', $'logfile'

sub applyOnePatchFile(%) {
  my %args = @_;
  print "$0: patchFileName: [$args{'patchfile'}] logfile: [$args{'logfile'}]\n" if ($applyPatchesTrace);
  
  my($rc,$log) = applyPatchFile(%args);
  if ($rc !=0 ) {
	print "Patching $args{'patchfile'} failed with code: $rc\n";
  }

  appendTextToFile(filename=>$args{'logfile'},text=>$log);
  print "aOPF: rc: [$rc]\n" if ($applyPatchesTrace);
  return($rc);
}


# Run a shell command capturing the return code and the stdout and stderr.
# Stderr and stdout will be combined in the same output stream.
# Will return a $rc in scalar context and the $rc and output in list context.
sub runShellCmdGetResult($) {
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
sub makePatchCmd(%) {
  my %args=@_;
  
  my $patchDebugCmds = "";
  # To get more debug information include this string in the command string below.

  if ($dryrun == 1) {
     $patchDebugCmds = " --debug=1 --dry-run ";
  }
  my $patchCmd = "patch -p0 --verbose -d $args{'builddir'} --ignore-whitespace --remove-empty-files --input=$args{'patchfile'} $patchDebugCmds";
}

# Append text to a file.
# %args = $'filename', $'text'
sub appendTextToFile(%){
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
