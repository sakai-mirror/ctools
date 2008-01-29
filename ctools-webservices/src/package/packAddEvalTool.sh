#!/bin/bash
# Packup the files needed for adding evaluation tools via web services into a tar file.
# $HeadURL:$
# $Id:$

set -x

# Find the source directory so know where to get the files.
WS_SRC=$(pwd | perl -ne 'm|(.*)/|; print $1')
START_DIR=$(pwd);

JWS_DIR=$WS_SRC/jws
PERL_DIR=$WS_SRC/perl

PACK=addEvalTool

# add the perl files
cd $WS_SRC
tar --exclude '.*' -cvf $START_DIR/$PACK.tar jws/CToolsScript.jws perl/util/*.p? perl/addEvalTool/*.p?
#tar --exclude '.*' -cvf $PACK.tar $JWS_DIR/SakaiScript.jws $PERL_DIR/util $PERL_DIR/addEvalTool/[!.]*.p?


#end
