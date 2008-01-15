#!/usr/local/bin/perl

# Seperate the configuration from the deletion code for forum deleting.
# See the forumDeleteDriver.pl file for details.

# $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/ctools-webservices/src/perl/forumDeleteCTTEST.pl $
# $Id: forumDeleteCTTEST.pl 40065 2008-01-11 18:37:33Z dlhaines@umich.edu $

# Note: This puts the data into perl data structures that are evaluated within
# the forumDeleteGeneric code.  If the code were to be used frequently a 
# different format might be easier to use.

# Technical note: Perl can't reference lexical variable from the
# caller in a file brought in via 'require'.  Therefore this file will
# set global variables and the caller will reassign them to lexical
# variables in the getConfig subroutine.  The protocol and domain name
# are set directly by call to a routine supplied by the caller.  This
# might be a better approach for setting all the values.

eval <<'EOF'
    $setup_description = "Test prod setup config file.";
$setup_sitePageToolInfo = 
    new SitePageToolIds(

			siteId => "SITE_ID",
			pageId => "PAGE_ID",
			toolId => "TOOL_ID",
			forumIds => join("\n",
					 "forumUUIDA",
					 "forumUUIDB",
					 )
			);

$setup_accnt = new HostAccount( user => 'UUUUUUU', pw => 'XXXXXXX');

# not used.
$setup_batchSize = 111;

setWSURI('https','TEST.ds.itd.umich.edu');

EOF

#end
