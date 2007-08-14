#!/bin/bash
# $HeadURL:$
# $Id:$

if [ 'x' = 'x'$1 ]; then
    echo "Must supply a svn url to examine.  E.g. https://source.sakaiproject.org/svn/ctools/trunk."
    exit 1;
fi

SVNURL=$1;

svn log --quiet --limit 1 $SVNURL | perl -n -e 'm|r(\d+)\s| && print "$1\n"'

#svn log --quiet --limit 1 $C/umctx | perl -n -e 'm|r(\d+)\s| && print "$1\n"'
#end
