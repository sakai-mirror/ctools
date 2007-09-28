#!/usr/bin/perl
# $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/ctools-ws-client/src/perl/testSakaiSoapUtil.pl $
# $Id: testSakaiSoapUtil.pl 35696 2007-09-23 18:56:05Z dlhaines@umich.edu $

## Add specific page and tool to a user's my workspace.
## Users are specified in a list.

use sakaiSoapUtil;
use strict;

## be able to set trace level.
my $trace = 1;

sub setTrace {
  my ($newTrace) = @_;
  my $oldTrace = $trace;
  $trace = $newTrace;
  return($oldTrace);
}

## 

# Keep a current session so can reuse it.
my $currentSakaiSession = "";

my $testHost;

# my $sakaiSession;
#my $myWorkspaceId;

## Utility to generate proper URI for a Sakai web service.
# Return the appropriate URI for the desired service.
# The argument is the name of Sakai web services jws file.
# It uses the global value of the variable testHost to 
# figure out which host to address.
sub WSURI{
  my($service) = @_;
  my($prefix) = "http://$testHost/sakai-axis/";
  my($suffix) = ".jws?wsdl";
  return join("",$prefix,$service,$suffix);
}


# sub listUserSiteIdFromEids {
# This establishes a session (logging in if necessary)
# then talks to SakaiScript to add the value of evaluation tool page / tool.
sub addEvalToolFromEids {
  my ($useHost,$loginUser,$pw,@userEids) = @_;
  $testHost = $useHost;
  ###############################
  # login and start sakai session
  my $sakaiSession = establishSakaiSession( WSURI("SakaiLogin"), $currentSakaiSession, $loginUser, $pw );
  die("failed to create sakai session") unless ($sakaiSession);
  print "established session: [$sakaiSession]\n";
  ##############################

  # connect to the sakai script WS
  my $sakaiScriptConnection = connectToSakaiWebService(WSURI("SakaiScript"));
  die("no sakai web service sakaiScriptConnection $!") unless ($sakaiScriptConnection);

  # for every user add the page and tool						       
  foreach my $uEid (@userEids) {
#    addPageAndToolToUserMyWorkspace($uEid,"Added Evaluation Page","Added Evaluation Tool","sakai.rsf.evaluation",$sakaiScriptConnection,$sakaiSession);
    addPageAndToolToUserMyWorkspace($uEid,"Added Config Viewer","Added Config Viewer Tool","sakai.configviewer",$sakaiScriptConnection,$sakaiSession);
    #     my $userWorkspaceId = $sakaiScriptConnection->getUserMyWorkspaceSiteId($uEid)->result;
    #     print "user: [$uEid] workspacedId: [$userWorkspaceId]\n" if ($trace);

    #     if ($userWorkspaceId) {

    #       ## add a page.
    #       print "using userWorkspaceId: [$userWorkspaceId]\n";
    #       my $pageAdded = $sakaiScriptConnection->addNewPageToSite($sakaiSession,$userWorkspaceId,"Added Evaluation Page",0)->result;
    # #      my $pageAdded = $sakaiScriptConnection->addNewPageToSite($sakaiSession,$uEid,"Added Chat room Page",0)->result;
    #       die("page not added for: [$uEid] response: [$pageAdded] ") unless ($pageAdded =~ "success");
      
    #       ## add a tool to page
    #       my $toolAdded = $sakaiScriptConnection->addNewToolToPage($sakaiSession,$userWorkspaceId,"Added Evaluation Page",
    # 							       "Added Evaluation tool","sakai.rsf.evaluation","")->result;
    #       die("tool not added for: [$uEid] response: [$toolAdded] ") unless ($toolAdded =~ "success");
    #     }
  }
  ############################
  ## terminate the session.
  endSakaiSession(WSURI("SakaiLogin"),$sakaiSession);
  ##############################
}

sub addPageAndToolToUserMyWorkspace {
  my($uEid,$pageTitle,$toolTitle,$toolId,$sakaiScriptConnection,$sakaiSession) = @_;
  print "aPATTUMW: args: |",join("|",@_),"|\n";
  my $userWorkspaceId = $sakaiScriptConnection->getUserMyWorkspaceSiteId($sakaiSession,$uEid)->result;
  print "user: [$uEid] workspacedId: [$userWorkspaceId]\n" if ($trace);

  if ($userWorkspaceId) {

    ## add a page.
    print "using userWorkspaceId: [$userWorkspaceId]\n";
    my $pageAdded = $sakaiScriptConnection->addNewPageToSite($sakaiSession,$userWorkspaceId,$pageTitle,0)->result;
    print "result from adding page: [$pageAdded]\n";
    die("page not added for: [$uEid] response: [$pageAdded] ") unless ($pageAdded =~ "success");
      
    ## add a tool to page
    my $toolAdded = $sakaiScriptConnection->addNewToolToPage($sakaiSession,$userWorkspaceId,$pageTitle,
							     $toolTitle,$toolId,"")->result;
    print "result from adding tool: [$toolAdded]\n";
    die("tool not added for: [$uEid] response: [$toolAdded] ") unless ($toolAdded =~ "success");
  }
}


## tests
# listUserSiteIdFromEids("localhost:8080","admin","admin","newuser01","admin","abba","NONSENSE");
#addEvalToolFromEids("localhost:8080","admin","admin","newuser01","abba");
#addEvalToolFromEids("localhost:8080","admin","admin","karma");
#addEvalToolFromEids("localhost:8080","admin","admin","karma","barma","bordom","NOUSER");

#sakaiSoapUtil::setTrace(1);

#addEvalToolFromEids("localhost:8080","admin","admin","karma");
#addEvalToolFromEids("localhost:8080","admin","admin","newuser01");
addEvalToolFromEids("localhost:8080","admin","admin","newuser02","newuser01","karma");
#end
