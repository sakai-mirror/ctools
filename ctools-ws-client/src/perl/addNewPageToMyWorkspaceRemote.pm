#!/usr/bin/perl
# $HeadURL$
# $Id$

## Add specific page and tool to a user's my workspace.
## Users are specified in a list.
## This is quick and dirty.  See TTD (Things To Do).

### TTD
# - factor out account information
# - factor out tool information
# - get rid of those globals (if will use again).
# - rethink WSURI approach
# - what about deleteing the added pages later on?

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
my ($success,$nologin,$noaccount,$eids);

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

# Specify the page title, the tool title and the tool id.
my($pageName,$toolName,$toolId) = ("Added Config Viewer","Added Config Viewer Tool","sakai.configviewer");


# Add a page and tool to the my workspace sites of these users.
sub addNewToolPageFromEidsRemote {
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


  my($noWorkspace,$nopage,$notool,$added) = (0,0,0,0);
  # for every user add the page and tool				
  print ("Adding new page and tool to users. page: [$pageName] tool: [$toolName] toolId: [$toolId]\n");
  print ("user\tworkspaceid\tresult\n");
#  foreach my $uEid (@userEids) {
    $eids++;
    my $result = addPageAndToolToUserMyWorkspaceRemote($pageName,$toolName,$toolId,$sakaiScriptConnection,$sakaiSession,@userEids);
    print "result: [$result]\n";
    $noWorkspace++ if ($result =~ /-userworkspace/);
    $nopage++ if ($result =~ /-page/);
    $notool++ if ($result =~ /-tool/);
    $added++ if ($result =~ /\+tool/);
    print "\n";
#  }

  print "eids: $eids noWorkspace: $noWorkspace nopage: $nopage notool: $notool added: $added\n";

  ############################
  ## terminate the session.
  endSakaiSession(WSURI("SakaiLogin"),$sakaiSession);
  $endTime = time();
  print("terminate session for $loginUser\n");
  ##############################

  print "users: $eids success: $success noaccount: $noaccount nologin: $nologin";
  print " elapsed time (secs) : ",$endTime-$startTime;
  printf " seconds per user: %3.1f\n",($endTime-$startTime)/$eids;

}

sub addPageAndToolToUserMyWorkspaceRemote {
  my ($pageName,$toolName,$toolId,$sakaiScriptConnection,$sakaiSession,@uEids) = @_;
  my $result;
  #  my ($pageName,$toolName,$toolId,$sakaiScriptConnection,$sakaiSession,$uEid) = @_;
  print "aPATTUMWR: args: |",join("|",@_),"|\n";
  #  my $result = $sakaiScriptConnection->addPageAndToolToUserMyWorkspace($pageName,$toolName,$toolId,$sakaiSession,@uEids)->result;
  #    my $remote = $sakaiScriptConnection->addPageAndToolToUserMyWorkspace($pageName,$toolName,$toolId,$sakaiSession,\@uEids);

  my $use;
  foreach $use (@uEids) {
#    my $use = shift(@uEids);
    print " eid: [$use]\n";
    my $remote = $sakaiScriptConnection->addPageAndToolToUserMyWorkspace($pageName,$toolName,$toolId,$sakaiSession,[$use]);
#    my $remote = "";

    ### need to use reference to list or just uses all in list as args, and will usually fail to find that remote java method.
    my $fault = $remote->fault;
    if (defined($fault)) {
      print "fault: ",join(",",$remote->faultcode,$remote->faultstring);"\n";
    } else {
      $result = $remote->result;
    }
    print "aPATTUMWR: result: [$result]\n";
    pop(@uEids);
  }
  return $result;
}

sub addPageAndToolToUserMyWorkspace {
  my($uEid,$pageTitle,$toolTitle,$toolId,$sakaiScriptConnection,$sakaiSession) = @_;
  print "aPATTUMW: args: |",join("|",@_),"|\n" if ($trace);
  my $userWorkspaceId = $sakaiScriptConnection->getUserMyWorkspaceSiteId($sakaiSession,$uEid)->result;
  print "[$uEid]\t[$userWorkspaceId]" if ($verbose);

  $eids++;

  ## no workspace id means they are unknown to Sakai.
  unless($userWorkspaceId) {
    print("\t-user_workspace");
    $noaccount++;
    return;
  }

  ## add a page.
  print "using userWorkspaceId: [$userWorkspaceId]\n" if ($trace);
  my $pageAdded = $sakaiScriptConnection->addNewPageToSite($sakaiSession,$userWorkspaceId,$pageTitle,0)->result;
  print "result from adding page: [$pageAdded]\n" if ($trace);

  if ($pageAdded =~ "success") {
    print "\t+page";
  } else {
    # If are known, but don't have a work space then they haven't logged in yet.
    print ("\t-page. Response: [$pageAdded]");
    if ($pageAdded =~ /IdUnusedException : null/) {
      print ("\tnever logged in?");
      $nologin++;
    } else {
      print "*** unexpected response to adding page ***";
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
  } else {
    print("\t-tool not added. Response: [$toolAdded]");
    return;
  }
}

#end
