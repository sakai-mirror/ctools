#!/usr/bin/perl -w
# Remove parts of a build that shouldn't be in the final image.
# $HeadURL$
# $Id$

# To be consistant with applyPatches.pl this returns shell style return codes.
# I.e. 0 means success, non-zero means failure.

# Currently just works on full paths.  Doesn't know about builds per sec.

use strict;
use File::Path;

## TTD:
# - use to remove the entire work directory rather than having ant do it (slowly).

## Setup variables and methods to set them for debugging.
our ($dryRun)  = 0;
our ($verbose) = 0;

sub verbose {
	my ($newVerbose) = @_;
	my ($oldVerbose) = $verbose;
	$verbose = $newVerbose;
	return $oldVerbose;
}

sub dryRun {
	my ($newdryRun) = @_;
	my ($olddryRun) = $dryRun;
	$dryRun = $newdryRun;
	return $olddryRun;
}

# Is this useful?
sub removeBuildParts {
	print "removeBuildParts called with arguments: |", join( "|", @ARGV ),
	  "|\n";
}

# Remove a list of files
sub removeBuildPartsListFromArgs {
  removeBuildPartsList(@_);
}

sub removeBuildPartsList {
  my($buildDir,$removeFileNames) = @_;
  my($dirsRemoved,$filesRemoved,$otherElement) = (0,0,0);
  foreach (split(",",$removeFileNames)) {
    print "removeFilesNames: [$_]\n" if ($verbose);
    my($rc);
    if (-d $_) {
      $rc = removeDir($_);
      return $rc if ($rc) ;
	$dirsRemoved++;
    }
    if (-f $_) {
      $rc = removeFile($_);
      return $rc if ($rc);
	$filesRemoved++;
    } 
  }
  return 0;
}

# Remove a file if it can.  It needs a full path.
sub removeFile {
	my ($fileName) = @_;
	print "-- remove file: [$fileName}\n" if ($verbose);

	my $cmd = "unlink(\"$fileName\")";
	if ( $dryRun || $verbose ) {
		print "rF: cmd: [$cmd]\n";
	}
	return 0 if ($dryRun);

	# fails if evaluate the command inside curly brackets.
	eval "$cmd";
	if ($@) {
		print "couldn't remove file: [$fileName] $@";
		return 1;
	}

	return 0;
}

# Remove a directory if it can.  Requires a full path.
sub removeDir {
	my ($entry) = @_;
	print "-- remove dir from build: [$entry]\n" if ($verbose);
	eval { rmtree($entry) };
	if ($@) {
		print "Couldn't remove dir: [$entry] $@";
		return 1;
	}
	return 0;
}

# These perl methods should replace these ant tasks. 
#sub removeWarFromImage {
#	my ($warpath) = @_;
#	print "remove war from image: [$warpath]\n" if ($verbose);
#	removeFileFromBuild($warpath);
#}

#     <removeFromBuild deleteDir="portal/mercury" />
#   <!-- remove files from build directory -->
#   <macrodef name="removeFromBuild">
#     <attribute name="dir" default="${build.dir}" />
#     <attribute name="deleteDir" />
#     <sequential>
#       <echo> remove ${build.dir}/@{deleteDir} from build </echo>
#       <delete dir="${build.dir}/@{deleteDir}"  verbose="false" quiet="true" />
#     </sequential>
#   </macrodef>

#     <removeWarFromImage deleteWar="sakai-comp-test-app1.war" />
#   <!-- remove war files from image directory -->
#   <macrodef name="removeWarFromImage">
#     <attribute name="dir" default="${image.dir}/webapps" />
#     <attribute name="deleteWar" />
#     <sequential>
#     <echo> removeWarFromImage: delete war: @{dir}/@{deleteWar} </echo>
#       <delete file="@{dir}/@{deleteWar}"  />
#       <!--      <delete dir="${dir}/@{deleteWar}"  verbose="false" quiet="true" /> -->
#     </sequential>
#   </macrodef>

#removeBuildParts(@ARGV) if (@ARGV);
removeBuildPartsListFromArgs(@ARGV) if (@ARGV);

1;

#end

