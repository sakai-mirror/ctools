#!/usr/bin/perl
# $HeadURL$
# $Id$

## Add specific page and tool to a user's my workspace.
## Users are specified in a list.
## This is quick and dirty.  See TTD (Things To Do).

### TTD
# - get rid of those globals (if will use again).
# - rethink WSURI approach
# - what about deleteing the added pages later on?
# - what about checking that not adding a page twice?
# - send tool info over as an object?
# - enhance sakaiScript to prevent having to make multiple WS calls 
#   to process a single user.

######## 
# These structs are for information passed between the caller and this module.
# By putting them before the package statement they will appear directly in 
# the namespace of each module with no extra effort.

# hold the host and account information
struct( HostAccount => [ hostProtocol=> '$', hostUrl => '$', user => '$', pw => '$']);

# bind new page name, tool name and the Sakai tool id together.
struct( PageToolIdNames => [ pageName=> '$', toolName => '$', toolId => '$']);

#################

package addNewPageToMyWorkspace;

# Need all 3 of these to export values.  NOTE: put no commas in the qw list.

require Exporter;
@ISA = ('Exporter');
# export common routines.
# Don't export setVerbose and setTrace as requiring prefix makes it easier to tell what
# you are setting verbose and trace for.
@EXPORT = qw(setPageAndToolNames setWSURI,WSURI addNewToolPageFromEids addPageAndToolToUserMyWorkspace setWSURI WSURI);

use sakaiSoapUtil;
use strict;

## be able to set verbose level.
my $verbose = 0;

sub setVerbose {
  # would this work?
  # my ($oldVerbose,$verbose) = ($verbose,@_);
  # return $oldVerbose;
  my ($newVerbose) = @_;
  my $oldVerbose = $verbose;
  $verbose = $newVerbose;
  return($oldVerbose);
}

## be able to set trace level.
my $trace = 0;

sub setTrace {
  # see setVerbose to see if the alternate method would work.
  my ($newTrace) = @_;
  my $oldTrace = $trace;
  $trace = $newTrace;
  return($oldTrace);
}

###################

## For accounting
#my ($startTime,$endTime);
my ($success,$nologin,$noaccount,$eids);

# Keep a current session so can reuse it.
my $sakaiSession;

#################
### setup URIs for web services
## Utility to generate proper URI for a Sakai web service.
# Return the appropriate URI for the desired service.
# The argument is the name of Sakai web services jws file.

my ($protocol) = "https";
my ($prefix);
my ($suffix) = ".jws?wsdl";

# set the values that are likely to change.
sub setWSURI {
  my $host;
  ($protocol,$host) = @_;
  $prefix = "$protocol://$host/sakai-axis/";
}

sub WSURI{
  my($service) = @_;
  my $uri = join("",$prefix,$service,$suffix);
  print "WSURI: uri: [$uri]\n" if ($trace);
  return($uri);
}

################
## setup to hold the page / tool information

my($toolInfo);
sub setPageAndToolNames {
  $toolInfo = shift;
}

##############

# Add a page and tool to the my workspace sites of these users.
sub addNewToolPageFromEids {
  my ($account,@userEids) = @_;

  my $startTime = time();

  ###############################
  # login and start sakai session if there isn't one already
  $sakaiSession = establishSakaiSession( WSURI("SakaiLogin"), $sakaiSession, $account->user, $account->pw );

  die("failed to create sakai session") unless ($sakaiSession);
  print "established [",$account->user,"] session: [$sakaiSession]\n" if ($verbose);
  ##############################

  # connect to the sakai script WS
  my $sakaiScriptConnection = connectToSakaiWebService(WSURI("SakaiScript"));
  die("no sakai web service sakaiScriptConnection $!") unless ($sakaiScriptConnection);

  print ("Adding new page and tool to users. page: [",$toolInfo->pageName,
	 "] tool: [",$toolInfo->toolName,
	 "] toolId: [",$toolInfo->toolId,
	 "]\n");

  print "@userEids: [",join("][",@userEids),"]\n" if ($verbose);
  print ("user\tworkspaceid\tresult\n");

  foreach my $uEid (@userEids) {
      print "uEid: [$uEid]\n" if ($verbose);
      # for every user add the page and tool		
      # If pass toolInfo as an object put the struct into sakaiSoapUtils.pm
      addPageAndToolToUserMyWorkspace($uEid,$toolInfo->pageName,$toolInfo->toolName,$toolInfo->toolId,$sakaiScriptConnection,$sakaiSession);
    print "\n";
  }

  # This batch is over.
  my $endTime = time();

  ############################
  ## terminate the session.
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
  my $userWorkspaceId = checkWSResponseAndReturnResult($response);

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

  my $response = $sakaiScriptConnection->addNewPageToSite($sakaiSession,$userWorkspaceId,$pageTitle,0);
  my $pageAdded = checkWSResponseAndReturnResult($response);

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
  my $response = $sakaiScriptConnection->addNewToolToPage($sakaiSession,$userWorkspaceId,$pageTitle,
							   $toolTitle,$toolId,"");
  my $toolAdded = checkWSResponseAndReturnResult($response);

  print "result from adding tool: [$toolAdded]\n" if ($trace);
  if ($toolAdded =~ "success") {
    print "\t+tool";
    $success++;
  } else {
    print("\t-tool not added. Response: [$toolAdded]");
    return;
  }
}

# check the response, print fault if it exists and return undefined result,
# otherwise return the result.
sub checkWSResponseAndReturnResult {
  my $response = shift;
  my $fault = $response->fault;
  if (defined($fault)) {
      print " fault: ",join(",",$response->faultcode,$response->faultstring),"\n";
      return undef;
  }
  return $response->result;
}

1;
# end
