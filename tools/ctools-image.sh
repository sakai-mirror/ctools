#!/bin/bash
#set -x

source ./configUtils.sh


function dropUnused {
    # drop the modules that are not needed in ctools
    rm $IMAGE_DIR/webapps/sakai-axis.war
    rm $IMAGE_DIR/webapps/sakai-scheduler-tool.war
    rm $IMAGE_DIR/components/sakai-legacy-providers/WEB-INF/lib/sakai-legacy-provider-sakai*.jar
    # get rid of some things we don't want
    # mercury? More?
	rm -rf $IMAGE_DIR/*license*
	rm -rf sample-tools
	rm -rf test
}


###############################
###############################
###############################

# the dirname stuff will pick up the properties file from
# the directory with the script.

readPropertiesFile $(dirname $0)/image.properties

echo "Build image in $IMAGE_DIR";

#set -x

if [ -e $IMAGE_DIR ]; then
    echo "rm -rf $IMAGE_DIR";
    rm -rf $IMAGE_DIR;
fi

mkdir $IMAGE_DIR

# get the normal Sakai installation.  Sakai must have been checked out and 
# compiled separately.

if [ ! -e $TAR_PATH/sakai.tar.gz ]; then
    echo "$TAR_PATH/sakai.tar.gz is missing";
    return 1;
fi

(cd $IMAGE_DIR; tar --gunzip -xf $TAR_PATH/sakai.tar.gz)
echo "A 'lone zero block' error message can be ignored."

dropUnused

# install the db driver
echo "** installing driver $DB_DRIVER"
cp -f $DB_DRIVER $IMAGE_DIR/common/lib


#### pilot
if testStringsIgnoreCase "$BUILD_PILOT" "true"; then
    echo "configure for pilot"
    # get rid of the remote tools
    # rm $IMAGE_DIR/webapps/ctools*remote.war
fi

#### melete
if testStringsIgnoreCase "$USE_MELETE" "true"; then
    # add the meleteDocs.xml file to the tomcat conf directory
    echo "** copying $MELETE_CONF_FILE to conf/Catalina/localhost"
    mkdir -p $IMAGE_DIR/conf/Catalina/localhost
    cp -f $MELETE_CONF_FILE $IMAGE_DIR/conf/Catalina/localhost
    echo "update placeholder.properties with melete db poperties."
    echo "update components.xml"
    echo "fix meleteDocs.xml"
    echo "update the web.xml"
fi

if testStringsIgnoreCase "$USE_SAMIGO" "true"; then
    echo "";
else
    # Samigo is not required 
    echo "!!! delete samigo for now"
    rm $IMAGE_DIR/webapps/*samigo*war
fi

# remember these!
echo "update version in sakai.properties"

#end
