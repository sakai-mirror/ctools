#!/bin/bash
# Model script to install special web services.
# $HeadURL:$
# $Id:$
#
# This script is assumed to run in a particular directory 
# structure.  If you got this in a tar file and extracted the
# whole tar you should be set.

# This script just copies files around and sets permissions.
# It contains model statements for both the JWS and the 
# driver perl scripts.  You probably only want to uncomment
# one of those.
# 
# It could be a lot neater and more functional.  If we 
# keep needing to do this kind of thing it will evolve.

set -x

###########
## This code will copy the JWS to the required location.
#DEST_JWS=/usr/local/sakai/webapps/sakai-axis
DEST_JWS=/Users/dlhaines/ws/tomcats/ctools.r39607/installed/webapps/sakai-axis
cp ../jws/ForumDeleterWS.java $DEST_JWS/ForumDeleterWS.jws

########
## Copy over the required perl scripts
#DEST_SCRIPTS=./bin
#mkdir $DEST_SCRIPTS
#cp ./perl/addNewPageToMyWorkspace.pm $DEST_SCRIPTS
#cp ./perl/runAddNewPageToMyWorkspace.pl $DEST_SCRIPTS
#cp ./perl/sakaiSoapUtil.pm $DEST_SCRIPTS
#chmod +x $DEST_SCRIPTS/*.pl

#end
