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
# - what about checking that not adding a page twice?
# - way testhost is used is silly.

package addNewPageToMyWorkspace;
require Exporter;

# this is not working?
@EXPORT = qw(setPageAndToolNames);

use sakaiSoapUtil;
use strict;

## be able to set verbose level.
my $verbose = 1;

# from web
#my @chars=('A'..'Z','0'..'9');

sub setVerbose {
  my ($newVerbose) = @_;
  my $oldVerbose = $verbose;
  $verbose = $newVerbose;
  return($oldVerbose);
}

## be able to set trace level.
my $trace = 1;

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
my $sakaiSession;

my $testHost;

## Utility to generate proper URI for a Sakai web service.
# Return the appropriate URI for the desired service.
# The argument is the name of Sakai web services jws file.
# It uses the global value of the variable testHost to 
# figure out which host to address.

my($protocol) = "https";
my($prefix) = "$protocol://XXXXX/sakai-axis/";
my($suffix) = ".jws?wsdl";

# set the values that are likely to change.
sub setWSURI {
  my $host;
  ($protocol,$host) = @_;
  $prefix = "$protocol://$host/sakai-axis/";
}

sub WSURI{
  my($service) = @_;
  return join("",$prefix,$service,$suffix);
}

# Hold the page title, the tool title and the tool id.
my($pageName,$toolName,$toolId);

# set a persistant value for the page and tool combination
sub setPageAndToolNames {
  ($pageName,$toolName,$toolId) = @_;
}

# Add a page and tool to the my workspace sites of these users.
sub addNewToolPageFromEids {
  my ($loginUser,$pw,@userEids) = @_;

  $startTime = time();

  ###############################
  # login and start sakai session if there isn't one already
  $sakaiSession = establishSakaiSession( WSURI("SakaiLogin"), $sakaiSession, $loginUser, $pw );

  die("failed to create sakai session") unless ($sakaiSession);
  print "established [$loginUser] session: [$sakaiSession]\n" if ($verbose);
  ##############################

  # connect to the sakai script WS
  my $sakaiScriptConnection = connectToSakaiWebService(WSURI("SakaiScript"));
  die("no sakai web service sakaiScriptConnection $!") unless ($sakaiScriptConnection);

  print ("Adding new page and tool to users. page: [$pageName] tool: [$toolName] toolId: [$toolId]\n");
  print "@userEids: [",join("][",@userEids),"]\n" if ($verbose);
  print ("user\tworkspaceid\tresult\n");
  foreach my $uEid (@userEids) {
      print "uEid: [$uEid]\n" if ($verbose);
    # for every user add the page and tool			
    addPageAndToolToUserMyWorkspace($uEid,$pageName,$toolName,$toolId,$sakaiScriptConnection,$sakaiSession);
    print "\n";
  }

  # This batch is over.
  $endTime = time();

  ############################
  ## terminate the session.
  # Not logging out for now.
  endSakaiSession(WSURI("SakaiLogin"),$sakaiSession);
  $sakaiSession = undef;
  ##############################

  print "users: $eids success: $success noaccount: $noaccount nologin: $nologin";
  print " elapsed time (secs) : ",$endTime-$startTime;
  printf " seconds per user: %3.1f\n",($endTime-$startTime)/$eids;

}

# Should not have to make three calls, should be able to do this
# on the JWS side.

sub addPageAndToolToUserMyWorkspace {
  my($uEid,$pageTitle,$toolTitle,$toolId,$sakaiScriptConnection,$sakaiSession) = @_;
  print "aPATTUMW: args: |",join("|",@_),"|\n" if ($trace);
  my $response = $sakaiScriptConnection->getUserMyWorkspaceSiteId($sakaiSession,$uEid);
  my $fault = $response->fault;
  if (defined($fault)) {
      print "fault: ",join(",",$response->faultcode,$response->faultstring),"\n";
  }
  my $userWorkspaceId = $response->result;

  print "[$uEid]\t[$userWorkspaceId]";

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
1;
#end
