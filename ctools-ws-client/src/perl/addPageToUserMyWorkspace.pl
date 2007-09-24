#!/usr/bin/perl
# $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/ctools-ws-client/src/perl/testSakaiSoapUtil.pl $
# $Id: testSakaiSoapUtil.pl 35696 2007-09-23 18:56:05Z dlhaines@umich.edu $

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

my $currentSakaiSession = "";
my $trace = 1;

sub getUserWorkspaceDom {
  my ($testHost,$user,$pw) = @_;
  my $sakaiScriptWSURI  = "http://$testHost/sakai-axis/SakaiScript.jws?wsdl";
  my $logInOutWSURI     = "http://$testHost/sakai-axis/SakaiLogin.jws?wsdl";
  my $sakaiSiteWSURI    = "http://$testHost/sakai-axis/SakaiSite.jws?wsdl";

  # login and start sakai session
  my $sakaiSession = establishSakaiSession( $logInOutWSURI, $currentSakaiSession, $user, $pw );
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
}

sub addPageToMyWorkspace {
  my ($testHost,$user,$pw,$pageName) = @_;
  my $sakaiScriptWSURI  = "http://$testHost/sakai-axis/SakaiScript.jws?wsdl";
  my $logInOutWSURI     = "http://$testHost/sakai-axis/SakaiLogin.jws?wsdl";
  my $sakaiSiteWSURI    = "http://$testHost/sakai-axis/SakaiSite.jws?wsdl";

  ###############################
  # login and start sakai session
  my $sakaiSession = establishSakaiSession( $logInOutWSURI, $currentSakaiSession, $user, $pw );
  die("failed to create sakai session") unless ($sakaiSession);
  print "established session: [$sakaiSession]\n";
  ##############################

  # connect to the sakai site WS
  my $sakaiSiteConnection = connectToSakaiWebService($sakaiSiteWSURI);
  die("no sakai web service sakaiSiteConnection $!") unless ($sakaiSiteConnection);
  print "established sakai session ws connection\n";

  # get all the sites
  my $listOfSitesDom = $sakaiSiteConnection->getSitesDom($sakaiSession,"",0,100)->result;

  # extract the my workspace site id.
  $listOfSitesDom =~ m|My Workspace.*<id>(~[^<]+)</id>|;
  my $myWorkspaceId = $1;

  # connect to the sakai script WS
  my $sakaiScriptConnection = connectToSakaiWebService($sakaiScriptWSURI);
  die("no sakai web service sakaiScriptConnection $!") unless ($sakaiScriptConnection);
  print "established sakai script ws connection\n";

  ## add a page.
  my $pageAdded = $sakaiScriptConnection->addNewPageToSite($sakaiSession,$myWorkspaceId,"New Scripted Page",0)->result;
  die("page not added [$pageAdded]") unless ($pageAdded =~ "success");
  
  ## add a tool to page
  my $toolAdded = $sakaiScriptConnection->addNewToolToPage($sakaiSession,$myWorkspaceId,"New Scripted Page",
							   "script added tool","sakai.syllabus","")->result;
  die("tool not added [$toolAdded]") unless ($toolAdded =~ "success");
  
  ############################
  ## terminate the session.
  endSakaiSession($logInOutWSURI,$sakaiSession);
  ##############################
}
# test
## works
#getUserWorkspaceDom("localhost:8080","newuser01","newuser01");

# find the my workspace site.

# String addNewPageToSite( String sessionid, String siteid, String pagetitle, int pagelayout) throws AxisFault


addPageToMyWorkspace("localhost:8080","newuser01","newuser01","Tools");

#end
