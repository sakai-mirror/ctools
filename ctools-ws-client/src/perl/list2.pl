#!/usr/bin/perl
# $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/ctools-ws-client/src/perl/testSakaiSoapUtil.pl $
# $Id: testSakaiSoapUtil.pl 35696 2007-09-23 18:56:05Z dlhaines@umich.edu $

## Add specific page and tool to a user's my workspace.
## Users are specified in a list.

use sakaiSoapUtil;
use strict;

## be able to set verbose level.
my $verbose = 1;

sub setVerbose {
  my ($newVerbose) = @_;
  my $oldVerbose = $verbose;
  $verbose = $newVerbose;
  return($oldVerbose);
}

## be able to set trace level.
my $trace = 0;

sub setTrace {
  my ($newTrace) = @_;
  my $oldTrace = $trace;
  $trace = $newTrace;
  return($oldTrace);
}

## 

my ($startTime,$endTime);
my ($success,$nologin,$noworkspace);

# Keep a current session so can reuse it.
my $currentSakaiSession = "";

my $testHost;

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

my($pageName,$toolName,$toolId) = ("Added Config Viewer","Added Config Viewer Tool","sakai.configviewer");

sub addEvalToolFromEids {
  my ($useHost,$loginUser,$pw,@userEids) = @_;
  $testHost = $useHost;

  $startTime = time();

  ###############################
  # login and start sakai session
  my $sakaiSession = establishSakaiSession( WSURI("SakaiLogin"), $currentSakaiSession, $loginUser, $pw );
  die("failed to create sakai session") unless ($sakaiSession);
  print "established [$loginUser] session: [$sakaiSession]\n" if ($verbose);
  ##############################

  # connect to the sakai script WS
  my $sakaiScriptConnection = connectToSakaiWebService(WSURI("SakaiScript"));
  die("no sakai web service sakaiScriptConnection $!") unless ($sakaiScriptConnection);

  # for every user add the page and tool				
  print ("Adding new page and tool to users. page: [$pageName] tool: [$toolName] toolId: [$toolId]\n");
  print ("user\tworkspaceid\tresult\n");
  foreach my $uEid (@userEids) {
#    addPageAndToolToUserMyWorkspace($uEid,"Added Config Viewer","Added Config Viewer Tool","sakai.configviewer",$sakaiScriptConnection,$sakaiSession);
    addPageAndToolToUserMyWorkspace($uEid,$pageName,$toolName,$toolId,$sakaiScriptConnection,$sakaiSession);
    print "\n";
  }
  ############################
  ## terminate the session.
  endSakaiSession(WSURI("SakaiLogin"),$sakaiSession);
  $endTime = time();
  print("terminate session for $loginUser\n");
  ##############################

  print "success: $success noworkspace: $noworkspace nologin: $nologin";
  print " elapsed time (secs) : ",$endTime-$startTime,"\n";

}

sub addPageAndToolToUserMyWorkspace {
  my($uEid,$pageTitle,$toolTitle,$toolId,$sakaiScriptConnection,$sakaiSession) = @_;
  print "aPATTUMW: args: |",join("|",@_),"|\n" if ($trace);
  my $userWorkspaceId = $sakaiScriptConnection->getUserMyWorkspaceSiteId($sakaiSession,$uEid)->result;
  print "[$uEid]\t[$userWorkspaceId]" if ($verbose);

  unless($userWorkspaceId) {
#    warn("no user workspace for user: [$uEid]");
    print("\t-user_workspace");
    $noworkspace++;
    return;
  }

#  if ($userWorkspaceId) {

    ## add a page.
    print "using userWorkspaceId: [$userWorkspaceId]\n" if ($trace);
    my $pageAdded = $sakaiScriptConnection->addNewPageToSite($sakaiSession,$userWorkspaceId,$pageTitle,0)->result;
    print "result from adding page: [$pageAdded]\n" if ($trace);
    #   die("page not added for: [$uEid] response: [$pageAdded] ") unless ($pageAdded =~ "success");
    if ($pageAdded =~ "success") {
      print "\t+page";
    }
    else {
      print ("\t-page. Response: [$pageAdded]");
      if ($pageAdded =~ /IdUnusedException : null/) {
	print ("\tnever logged in?");
	$nologin++;
      }
      else {
	print "*** unexpected ***";
      }
      return;
    }
      
    ## add a tool to page
    my $toolAdded = $sakaiScriptConnection->addNewToolToPage($sakaiSession,$userWorkspaceId,$pageTitle,
							     $toolTitle,$toolId,"")->result;
    print "result from adding tool: [$toolAdded]\n" if ($trace);
    if ($toolAdded =~ "success") {
      print "\t+tool";
      $success++;
    }
    else {
#      die("tool not added for: [$uEid] response: [$toolAdded] ") unless ($toolAdded =~ "success");
#      die("tool not added for: [$uEid] response: [$toolAdded] ");
      print("\t-tool not added. Response: [$toolAdded]");
#      warn("tool not added for: [$uEid] response: [$toolAdded] ");
      return;
    }
 # }
}

# test script
#addEvalToolFromEids("localhost:8080","admin","admin","newuser02","newuser01","karma");
my $i=0;
my $reps = 1;
while($i++ < $reps) {
addEvalToolFromEids("localhost:8080","admin","admin","newuser01","newuser02","NOACCOUNT","NOACCOUNT2","NEVERLOGIN","NOACCOUNT");
}
#end
