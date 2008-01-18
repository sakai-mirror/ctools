#!/usr/bin/perl
# $HeadURL$
# $Id$

## Add specific page and tool to a user's my workspace.
## Users are specified in a list.
## This is quick and dirty.  See TTD (Things To Do).

### TTD

######## 
# These structs are for information passed between the caller and this module.
# By putting them before the package statement they will appear directly in 
# the namespace of each module with no extra effort.

# hold the host and account information
struct( HostAccount => [ hostProtocol=> '$', hostUrl => '$', user => '$', pw => '$']);

# bind new page name, tool name and the Sakai tool id together.
struct( SitePageToolIds => [ siteId=> '$', pageId => '$', toolId => '$', forumIds=> '$']);

#################

package forumDelete;

# Need all 3 of these to export values.  NOTE: put no commas in the qw list.

require Exporter;
@ISA = ('Exporter');
# export common routines.
# Don't export setVerbose and setTrace as requiring prefix makes it easier to tell what
# you are setting verbose and trace for.
#@EXPORT = qw(setPageAndToolNames setWSURI,WSURI addNewToolPageFromEids addPageAndToolToUserMyWorkspace setWSURI WSURI);
#@EXPORT = qw(setSitePageToolIds setWSURI setVerbose testCall);
@EXPORT = qw(setSitePageToolIds setWSURI setVerbose deleteListOfForums);

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

# return the actual ws services URI.
sub WSURI{
    my($service) = @_;
    my $uri = join("",$prefix,$service,$suffix);
    print "WSURI: uri: [$uri]\n" if ($trace);
    return($uri);
}

################
## setup to hold site / page / tool id info

my($sitePageToolIds);
sub setSitePageToolIds {
    $sitePageToolIds = shift;
}

sub deleteListOfForumsDummy {
    print "remember to reset the dLOF call in forumDelete.pm.\n";
}

sub deleteListOfForums {


    my $account = shift;
    print("setup site / page / tool id ",
	  $sitePageToolIds->siteId,
	  "/",
	  $sitePageToolIds->pageId,
	  "/",
	  $sitePageToolIds->toolId,
	  "\n");

    # login and start sakai session if there isn't one already
    $sakaiSession = establishSakaiSession( 
					   WSURI("SakaiLogin"), 
					   $sakaiSession, 
					   $account->user, $account->pw );

    die("failed to create sakai session") unless ($sakaiSession);
    print "established [",$account->user,"] session: [$sakaiSession]\n" if ($verbose);
    ##############################

    # connect to the sakai script WS
    my $forumDeleterConnection = connectToSakaiWebService(WSURI("ForumDeleterWS"));
    die("no sakai web service forumDeleter $!") unless ($forumDeleterConnection);

    print ("deleting forum from: site/page/tool: ",join("/",$sitePageToolIds->siteId,
							$sitePageToolIds->pageId,
							$sitePageToolIds->toolId),
	   "\n");

    my $response = $forumDeleterConnection->deleteForums($sakaiSession,
							 $sitePageToolIds->siteId,
							 $sitePageToolIds->pageId,
							 $sitePageToolIds->toolId,
							 $sitePageToolIds->forumIds
							 );

    my $forumDeleted = checkWSResponseAndReturnResult($response);
    print "connection test response: [",$forumDeleted,"]\n";

    ############################
    ## terminate the session.
    endSakaiSession(WSURI("SakaiLogin"),$sakaiSession);
    $sakaiSession = undef;
    ##############################

}


1;

__END__

=head1 NAME

forumDelete.pm

=head1 SYNOPSIS

Method to delete a forum from message center. See
forumDeleteGeneric.pl for more details on this specific use.

These subroutines can be used directly by any code that includes this module.

=head2 GENERIC WEB SERVICE METHODS

=over

=item setWSURI - set the host and protocol to use for the web services
connections.  

=item WSURI - return a specific web services URI for a particular JWS file.

=item setVerbose - set module to be verbose.

=item setTrace - set module to trace behavior.

=item checkWSResponseAndReturnResult - Examine the result of a SOAP call.
If there is a fault it will print the fault and return undef.  If
there is no fault it will return the result of the invocation.

=back

=head2 Forums specific method

=over

=item deleteListOfForums.  See forumDeleteGeneric.pl.

=back

=head1 DESCRIPTION

See SYNOPSIS and BUGS AND LIMITATIONS

=head1 BUGS AND LIMITATIONS

TBD

=head1 COPYRIGHT

You can use it.

=head1 AUTHORS

David Haines (University of Michigan).  Originally based on code
supplied by Seth Theriault.  Don't blame him for my mistakes.

=cut

#end
