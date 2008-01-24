#!/bin/bash
# Model script to install special web services.
# $HeadURL:$
# $Id:$
#
set -x
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

#set -x

###########
## This code will copy the JWS to the required location.
#DEST_JWS=/usr/local/sakai/webapps/sakai-axis
#cp ./jws/SakaiScript.jws $DEST_JWS

REVISION=r40471
SRC_JWS=./jws/SakaiScript.jws
DEST_JWS=$HOME/ws/tomcats/ctools.${REVISION}/installed/webapps/sakai-axis
cp $SRC_JWS $DEST_JWS

########
## Copy over the required perl scripts
#DEST_SCRIPTS=./bin
#mkdir $DEST_SCRIPTS
#cp ./perl/addNewPageToMyWorkspace.pm $DEST_SCRIPTS
#cp ./perl/runAddNewPageToMyWorkspace.pl $DEST_SCRIPTS
#cp ./perl/sakaiSoapUtil.pm $DEST_SCRIPTS
#chmod +x $DEST_SCRIPTS/*.pl

#end
