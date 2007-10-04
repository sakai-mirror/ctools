#!/bin/bash
# package up the right things into the tar file for delivery.
# $HeadURL:$
# $Id:$
#

set -x
tar -cf ./evalWS.tar installJWS-model.sh jws/SakaiScript.jws perl/runAddNewPageToMyWorkspace.pl perl/addNewPageToMyWorkspace.pm perl/sakaiSoapUtil.pm

#end
