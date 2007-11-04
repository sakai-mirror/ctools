#!/usr/bin/perl -w
# Remove parts of a build that shouldn't be in the final image.
# $HeadURL$
# $Id$

# To be consistant with applyPatches.pl this returns shell style return codes.
# I.e. 0 means success, non-zero means failure.

use strict;
use File::Path;

## TTD:
# - use to remove the entire work directory rather than having ant do it (slowly).

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

sub removeBuildParts {
	print "removeBuildParts called with arguments: |", join( "|", @ARGV ),
	  "|\n";
}

sub removeFile {
	my ($fileName) = @_;
	print "-- remove file: [$fileName}\n" if ($verbose);

	#  my $cmd = "$unlink($fileName) || return 0";
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

	#  unless ($unlink($fileName) || return 0;
	return 0;
}


#sub removeDirFromBuild {
	#my ( $buildDir, $entry ) = @_;
	#print "-- remove dir: [$entry] from build: [$buildDir]\n" if ($verbose);
	#eval { rmtree("$buildDir/$entry") };
	#if ($@) {
		#print "Couldn't remove directory: [$buildDir/$entry] $@";
		#return 0;
	#}
	#return 1;
#}

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

sub removeWarFromImage {
	my ($warpath) = @_;
	print "remove war from image: [$warpath]\n" if ($verbose);
	removeFileFromBuild($warpath);
}

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

removeBuildParts(@ARGV) if (@ARGV);

1;

#end

