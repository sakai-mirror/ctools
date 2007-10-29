#!/usr/bin/perl -w
# Remove parts of a build that shouldn't be in the final image.
# $HeadURL$
# $Id$

use strict;
use File::Path;

## TTD:
# - use to remove the entire work directory rather than having ant do it (slowly).


sub removeBuildParts{
  print "removeBuildParts called with arguments: |",join("|",@ARGV),"|\n";
}

sub removeFileFromBuild {
  my($entry) = @_;
  # print "-- remove file from build: [$entry}\n";
  unlink($entry) || return 0;
  return 1;
}

sub removeDirFromBuild {
  my($entry) = @_;
  print "-- remove dir from build: [$entry]\n";
  eval { rmtree($entry) };
  if ($@) {
    print "Couldn't remove dir: [$entry] $@";
    return 0;
  }
  return 1;
}

sub removeWarFromImage {
  my($warpath) = @_;
  print "remove war from image: [$warpath]\n";
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
