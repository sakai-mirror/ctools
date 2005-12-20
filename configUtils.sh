#!/bin/bash

# Utilities useful in multiple scripts.

# Utility to evaluate a svn command on a list of arguments.
# It expects:
#  --  The variable $svnCmd to be set to the command prefix.
#  --  The first argument to be a svn repository prefix string that can be
#      prepended to each entry in
#  --  The following arguments are a list of directories to have the
#      svn command evaluated on.

# eg 
# svnCmd="svn ls ";
#dirList="
#a
#b";
# evalSvnCmdOnList https://source.sakaiproject.org/svn/trunk/sakai $dirList

function evalSvnCmdOnList {
    local count=0
    local svnUrl=$1;
    local logname;
    local logdir="extractionLogs";
    shift;
    
    if [ ! -e $logDir ]; then
	mkdir $logDir;
    fi
    
    # need $* to get all the members of the list
    for i in $*
    do 
	(( count++ ))
#	logname=$(echo $i | sed 's/\//\./g')
	# to get log file name convert any slashs to '.' and
	# take off a leading . if it exists.
	logname=`echo $i| sed s/\\\//\\\./g`
	logname=`echo $logname | sed s/^\\\.//`
	logname=$logDir/$logname;
	echo "$svnCmd $svnUrl/$i $svnDest"
	echo "extracting module: $i"
	eval "$svnCmd $svnUrl/$i $svnDest" >> $logname.log
    done
    echo "modules extracted: $count";
}

function exportSvnSingleFile {
    local svnUrl=$1;
    local file=$2;
    local destFile=$3;
    
    echo "$svnCmd $svnUrl/$file $destFile"
    eval "$svnCmd $svnUrl/$file $destFile" 
}

function cleanSource {
    local file=$1;
    
    echo "rm -rf $file"
    rm -rf $file
}

function readPropertiesFile {
    # get a temp file
    if [ `uname` = 'Darwin' ]; then
	TEMPFILE=$(mktemp -t BUILD_IMAGE)
    fi	
    if [ `uname` = 'Linux' ]; then
        TEMPFILE=$(mktemp BUILD_IMAGE.XXXXXXXX)
    fi
    echo $TEMPFILE
    echo ARG: $1
    cat $1| sed -e 's/\"/\"/'g|sed -e 's/=(.*)/=\"\\1\"/g'>$TEMPFILE
    source $TEMPFILE
    rm $TEMPFILE
}

function readPropertiesFileOld {
    TEMPFILE=$(mktemp -t BUILD_IMAGE)
    echo $TEMPFILE
    echo ARG: $1
    cat $1| sed -e 's/\"/\"/'g|sed -e 's/=(.*)/=\"\\1\"/g'>$TEMPFILE
    source $TEMPFILE
    rm $TEMPFILE
}

function testStringsIgnoreCase {
    # succeed if the strings are the same (ignoring case)
    # fail if they are different
    local STRING1=`echo $1 | tr '[a-z]' '[A-Z]'`;
    local STRING2=`echo $2 | tr '[a-z]' '[A-Z]'`;
    if [ "$STRING1" = "$STRING2" ]; then
	return 0;
    fi
    return 1;
}



#end
