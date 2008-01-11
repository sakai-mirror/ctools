#!/usr/bin/perl

# Script to delete forums from a site via uuid.

# $HeadURL$
# $Id$


use strict;
use Class::Struct;
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
# Testctools JL test site.
# site id 4965db20-7e16-47a4-00b9-4ace7d339b6b
# page id d5f2c7f0-fbd7-434e-80a7-fdcb13741f62
# tool id 547b6cd9-ba93-4ecb-00ca-68135249327d


my $sitePageToolInfo = new SitePageToolIds(
					   siteId => "4965db20-7e16-47a4-00b9-4ace7d339b6b",
					   pageId => "d5f2c7f0-fbd7-434e-80a7-fdcb13741f62",
					   toolId => "547b6cd9-ba93-4ecb-00ca-68135249327d",
					   forumIds => join("\n",
							    "09514626-678e-4206-0083-af627c5dc615",
							   )
					  );
# 							    "13bacb46-1008-46c3-806e-f937653548c0",
# 							    "15bf3b6f-a0d8-4733-802c-826f336fc463",
# 							    "2306aa8e-01cf-4937-008c-0edab5c298fc",
# 							    "264e068d-3063-4fc8-804b-ac8ff669d7a9",
# 							    "29b94bf2-a998-475c-8000-b0cd5824e6ed",
# 							    "2a9ab6a5-ed81-456a-808b-0de35086cb86",
# 							    "2a9ea109-0010-4ad3-00ca-5d2cda2ffb04",
# 							    "2c6dc2d4-6417-47a6-0030-25f0af89f539",
# 							    "2e7f909b-b1bd-48fe-802d-01e660ac6859",
# 							    "30a338f7-9816-42df-8046-09566fc93dd2",
# 							    "3f4785f0-3dee-4b4c-80a3-9e752a04106c",
# 							    "41aad0d6-7f40-4fab-8064-43496e7fcf27",
# 							    "4ee2cc6b-031f-41a6-004a-f1e575b5a942",
# 							    "50eb4529-b881-4660-80d8-fb357e6a11c6",
# 							    "52daf185-6593-4428-00f8-458fc3f4ed5d",
# 							    "57ac2af6-4299-4f1b-80ef-d44c608dc45d",
# 							    "5e3fc310-425e-4b3c-005b-64ca824ac59f",
# 							    "680bf089-4a1b-468a-00dd-efff96859f75",
# 							    "6ab8967b-24d5-40ea-009c-9039e568f0fc",
# 							    "90d90c76-4beb-4b5f-00df-b8c18d17d07f",
# 							    "914d5d98-29fa-4bca-0094-3e3c49061b2b",
# 							    "9b026a76-61b5-4495-80aa-bed10f76a4e0",
# 							    "a001e40f-731c-4ac4-80e8-4e0c0fe80ebe",
# 							    "a363a529-a68c-4354-80e5-7cad06a91fec",
# 							    "a9ac3846-e817-48d5-809c-7aa105a3e292",
# 							    "bd2de066-29f4-4ad4-00af-03582bbb4a18",
# 							    "be87c71a-ca7f-4ca0-8087-51481ef7d471",
# 							    "c1bf0024-f184-4e9b-00d3-1229df7f3ccd",
# 							    "c1d596b6-343b-42ad-8028-ab70f82e4f85",
# 							    "d58265f7-1c63-46f5-0035-aa754e75ff39",
# 							    "d922f063-1aef-4269-8013-07c89b547a3a",
# 							    "dbf97408-ae31-4974-0053-b8ad968ebb8e",
# 							    "e348e77e-b6ad-459f-80e9-9264e6332528",
# 							    "eaf6262f-cb4c-42fe-80d2-28071fcce6fd",
# 							    "f12156c3-287b-48fb-0022-e4772bac9fd9",
# 							    "f1ebbcaa-7fe5-4265-800b-e6d5840efb92",
# 							    "f7aadcc4-87b2-4c9a-0050-e37523c8d386"

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
