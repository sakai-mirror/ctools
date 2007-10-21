#!/usr/bin/perl
# Remove parts of a build that shouldn't be in the final image.
# $HeadURL:$
# $Id:$


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

#end
