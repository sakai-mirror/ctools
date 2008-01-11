#!/usr/bin/perl

# Script to delete forums from a site via uuid.

# $HeadURL$
# $Id$

# Take a list of eids from stdin and add the defined page / tool to the user's My Workspace.  
# The processing can be batched.  After each batch a summary is printed.  Also will login / out 
# for each batch which will keep the session active.

#### TTD
# - why is account in a global and toolInfo passed as an argument?
# - startTime as global?
# - Why have processfile code and setup in the same file?
# - Recognize that page already exists?

use strict;
use Class::Struct;
#use addNewPageToMyWorkspace;
use forumDelete;

# hold the host and account information
my $accnt;
my $trace = 0;

# Keep track of some values
my ($startTime);

my $count;

# Can set to process in batches.  The advantages are that can
# get summary after each batch, so can keep track of progress and
# will login / logout for each batch so have shorter sessions.

# default size of batch to be processed.
my $batchSize = 10;
my @batch;

sub processFile {
  # expect a file with siteid / pageid / toolid / forum uuid
  # will generate summary statistics after every batch and at the end of the run.
  $startTime = time();
  while (<>) {
    chomp;
    next if (/^\s*$/);
    next if (/^\s*#/); 
    $count++;
    #    print "eid: [$_]\n" if ($trace);
    #($siteId,$pageId,$toolId,$forumUuid) = @_;
    # accumulate a batch of the eids to process.
    push(@batch,$_);
    unless($count % $batchSize) {
      print "process batch: ",join("|",@batch),"\n";
      processBatch(@batch);
      # empty batch so don't process again.
      @batch = ();
    }
  }

  # Get the last batch (which may not be full).
  @batch = processBatch(@batch) if (@batch);
  @batch = ();
}
##################################

sub processBatch {
  my(@batch) = @_;
  addNewToolPageFromEids($accnt,@batch);
  printSummary($count,$startTime,time());
}

sub printSummary {
  my($cnt,$startTime,$endTime) = @_;
  print "cumulative ";
  print "users: $cnt ";
  my $elapsedSecs = $endTime - $startTime;
  print " elapsed time (secs) : ",$elapsedSecs;
  printf " seconds per user: %3.1f\n",$elapsedSecs/$cnt;
}

############ setup and run #################

$trace=1;
forumDelete::setVerbose(1);
forumDelete::setTrace(1);

# specify the tool id and the name to be shown for the page and tool.
#my $sitePageToolInfo = new SitePageToolIds(siteId => "SITEID", pageId => "PAGEID", toolId =>"TOOLID");
# forums src A in dlhaines db.
# bbf8f50d-0bb4-4c94-00ca-3bec8a7b6c4a/page/a35af6d1-50ee-46eb-8003-6a239adbe85d
my $sitePageToolInfo = new SitePageToolIds(
					   siteId => "bbf8f50d-0bb4-4c94-00ca-3bec8a7b6c4a",
					   pageId => "a35af6d1-50ee-46eb-8003-6a239adbe85d",
					   toolId => "3ec9110c-b69b-47ca-00e5-2f2411dc2c8c",
					   forumIds => join("\n",
							    "26fca2d8-df5c-43a2-0012-a316b55e2ace",
							    "d9f6ff8a-2156-4d83-003a-f6f45ca491b0",
							    "7f30b9fc-6b99-4260-0049-582cc1dc35bd",
							    "5e54f8f8-3572-4295-80e1-57a0e41a99b6")
#					   forumIds => "26fca2d8-df5c-43a2-0012-a316b55e2ace\nd9f6ff8a-2156-4d83-003a-f6f45ca491b0\n7f30b9fc-6b99-4260-0049-582cc1dc35bd\n5e54f8f8-3572-4295-80e1-57a0e41a99b6"
);
#my $toolInfo = new PageToolIdNames(pageName => ".", toolName => "Teaching Questionnaires", toolId =>"sakai.rsf.evaluation");
setSitePageToolIds($sitePageToolInfo);

$accnt = new HostAccount( user => 'admin', pw => 'admin');
setWSURI('http','localhost:8080');

$batchSize = 20;
testCall($accnt);
#processFile();

__END__

=head1 NAME
runAddNewPageToMyWorkspace

This consists of some utility methods and configuration to add specific page and tool a users My Workspace.
It could be improved a lot.

=head1 SYNOPSIS

Customize the page / tool / toolId, the account information, and the
server to be addressed.  Input is a file of Sakai Eids, one per line,
to which the page will be added.  Blank lines and lines starting with
a '#' will be ignored.

=head1 DESCRIPTION

See SYNOPSIS and BUGS AND LIMITATIONS

=head1 BUGS AND LIMITATIONS

It does not check if the page already exists, a new page will be
added.  As of 2.4.x not only will there be multiple pages, the tool
will be added to EVERY page with a matching name, so you end with way
to many instances.

If the user has never logged in their My Workspace doesn't exist and
pages can't be added to it.  A message will be printed in this case.

It could be refactored and improved greatly.

=head1 COPYRIGHT

You can use it.

=head1 AUTHORS

  David Haines (University of Michigan) extended and distorted code
  from Seth Theriault.  Don't blame Seth for my mistakes.

=cut

#end
