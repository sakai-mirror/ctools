#!/bin/bash

#set -x

# Compile CTools.  Make necessary changes for melete.

source $HOME/.bash_profile
source ./configUtils.sh

# Update melete here so that the wars are built correctly.

function updateMeleteDocs {
set -x
    # update the directory reference in meleteDocs.xml
    #cat $1| sed -e 's/\"/\"/'g|sed -e 's/=(.*)/=\"\\1\"/g'>$TEMPFILE    
    local meleteFile=$1
    local meleteWebXml=$2
    local meleteWebPath=$(dirname $meleteWebXml)
    local meleteWebFile=$(basename $meleteWebXml)
    echo meleteWebPath: $meleteWebPath
    echo meleteWebFile: $meleteWebFile


    if [ ! -e $meleteFile.bkp ]; then
	cp $meleteFile $meleteFile.bkp
    fi

    # update the melete context file
    sed -e 's/\/var/\/meletehome/' < $meleteFile.bkp >| $meleteFile

    # update the web.xml
    mv $meleteWebPath/$meleteWebFile $meleteWebPath/$meleteWebFile.bkp 
    sed -e 's/\/var/\/meletehome/g' < $meleteWebXml.bkp >| $meleteWebXml

}


# Compile ctools

# include the configuration specification
source $(dirname $0)/config.properties

readPropertiesFile $(dirname $0)/image.properties

cd $destdir;

tar --gunzip -xf *.tgz

updateMeleteDocs  $MELETE_CONF_FILE $MELETE_WEB_XML


maven sakai:clean sakai:build sakai:deploy-zip

echo "remember to update GradToolsStudent in sakai.sitesetup.xml and add withDissertation=true to sakai.properties."
echo " add GradToolsStudent to siteTypes and to privateSiteTypes"

#end
