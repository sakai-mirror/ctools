#!/usr/bin/env bash
# Package up a tar file suitable to install this into an existing Sakai deployment.
# $HeadURL:$
# $Id:$

# steps
# - extract and compile sash
# - deploy to a new, empty, deploy directory
# - package that up.
# - state how to deploy.

DEPLOYED=$HOME/deploy
TAR_NAME=sash-0.1.1
tar -z -f $TAR_NAME.tgz -C $DEPLOYED -c .

# To extract sash use:
# tar -z -f <tar+name>.*z -C <directory containing the webapps directory> -x

#end
