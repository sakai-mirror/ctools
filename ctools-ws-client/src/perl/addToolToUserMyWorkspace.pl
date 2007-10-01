#!/usr/bin/perl
# $HeadURL$
# $Id$

## Demonstrate how to get the my workspace for a particular user.
## There may (must) be better ways.

use sakaiSoapUtil;
use strict;

# start a sakai session by logging in.
# connect to the Sakai Site webservice.
# get the Dom list of the worksites and pull out the one for
# My Workspace
# logout;

# Variables to configure

my $sakaiSession = "";
my $trace = 1;


sub getUserWorkspaceDom {
  my ($testHost,$user,$pw) = @_;
  my $sakaiScriptWSURI  = "http://$testHost/sakai-axis/SakaiScript.jws?wsdl";
  my $logInOutWSURI     = "http://$testHost/sakai-axis/SakaiLogin.jws?wsdl";
  my $sakaiSiteWSURI    = "http://$testHost/sakai-axis/SakaiSite.jws?wsdl";

  # login and start sakai session
  my $sakaiSession = establishSakaiSession( $logInOutWSURI, $sakaiSession, $user, $pw );
  die("failed to create sakai session") unless ($sakaiSession);
  print "established session: [$sakaiSession]\n";

  # get the list of sites.
  
 # connect to the web service
  my $connection = connectToSakaiWebService($sakaiSiteWSURI);
  die("no sakai web service connection $!") unless ($connection);
  print "established sakai session ws connection\n";

  # check that the user is who we expect it to be.
  my $listOfSitesDom = $connection->getSitesDom($sakaiSession,"",0,100)->result;

  $listOfSitesDom =~ m|My Workspace.*<id>(~[^<]+)</id>|;
  my $myWorkspaceId = $1;
  print "myWorkspaceId: [$myWorkspaceId]\n";

  endSakaiSession($logInOutWSURI,$sakaiSession);
 #    my $formatted = $listOfSitesDom;
 #    $formatted =~ s/></>\n</g;
 #    print "listOfSitesDom: [$listOfSitesDom]\n";
 #    print "f: $formatted\n";
  
}


# test
## works
getUserWorkspaceDom("localhost:8080","newuser01","newuser01");

#end
