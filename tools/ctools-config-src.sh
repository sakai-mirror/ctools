#!/bin/bash

#set -x

# Get the right source and take out some things we don't need for ctools.

. $HOME/.bash_profile

# Check out specific modules for the ctools winter 06 build.

echo ctools source extraction started at `date`

# Include the utility functions.  Use this fancy dirname processing
# so that it still finds the utilities even if it is not invoked 
# the same directory where the script lives.
source $(dirname $0)/configUtils.sh

# include the configuration specification
source $(dirname $0)/config.properties

###################

if [ -e $destdir ]; then
	rm -rf $destdir
fi

mkdir $destdir;

echo $PATH 

cd $destdir;

# override the svn command so don't use that default version.
(
#    svnCmd="svn export";
    melete_tar=melete_ha_2.1.0.tgz
    exportSvnSingleFile $ctoolsSvnUrl melete/$melete_tar ./$melete_tar
)


# Get the appropriate sakai modules.
evalSvnCmdOnList $sakaiSvnUrl $sakaiCtoolsSrcList;

# Get the required ctools specific modules.
evalSvnCmdOnList $ctoolsSvnUrl $ctoolsSrcList;

cleanSource portal/mercury
cleanSource common/common-composite-component/src/test
cleanSource edu/coursemanagement-tool/src/test
cleanSource gradebook/testservice
cleanSource metaobj/api-impl/src/test
cleanSource osid/osid-unit-test
cleanSource rwiki/jrcs/src/completetest
cleanSource rwiki/jrcs/src/test
cleanSource rwiki/radeox/src/test
cleanSource rwiki/rwiki/src/test
cleanSource rwiki/rwiki/src/testBundle
cleanSource sam/testdata
cleanSource sam/tests
cleanSource sam/tool/src/java/test

echo Ctools source extraction done at $(date)

#end


#end
