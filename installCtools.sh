#!/bin/bash
#set -x

# Install an image into a local tomcat directory for testing.

echo ctools tomcat install started at `date`

TOMCAT_BASE=$HOME/tomcats
PLAIN_TOMCAT=$HOME/tomcats/base-tomcat-compat-5.5.9
TOMCAT_DIR=ctools-2.1

IMAGE_DIR=./image
SAKAI_DIR=$HOME/dev/ctools-modules/ctools/ctools-reference/config

cd $(dirname $0)

mkdir $TOMCAT_BASE/$TOMCAT_DIR
rm -rf $TOMCAT_BASE/$TOMCAT_DIR/*
mkdir $TOMCAT_BASE/$TOMCAT_DIR/sakai
cp -rp $PLAIN_TOMCAT/* $TOMCAT_BASE/$TOMCAT_DIR
cp -rp $IMAGE_DIR/* $TOMCAT_BASE/$TOMCAT_DIR
cp -rp $SAKAI_DIR/* $TOMCAT_BASE/$TOMCAT_DIR/sakai

echo ctools tomcat install done at `date`

#end
