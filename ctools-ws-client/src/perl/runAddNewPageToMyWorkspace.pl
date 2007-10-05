#!/usr/local/bin/perl

# Script to add a page and a tool to a user's my workspace.

use strict;
use addNewPageToMyWorkspace;

my $trace = 0;

# Keep track of some values
my ($startTime,$endTime,$currentTime);

my ($count);
my $lastCntReported;
# how often to print the processing summary
my $batchSize = 20;
my @batch;

# specify the tool id and the name to be shown for the page and tool.
setPageAndToolNames("Teaching Questionnaires","Teaching Questionnaires","sakai.rsf.evaluation");

# set the batch size.  Will process the eids in batches of this size and will 
# generate summary statistics after every batch.

$startTime = time();

# expect a file with 1 eid per line.  Empty and commented lines are ignored.
while(<>) {
  chomp;
  next if (/^\s*$/);
  next if (/^\s*#/); 
	   $count++;
	   print "eid: [$_]\n" if ($trace);
  # accumulate a batch of the eids to process.
  push(@batch,$_);
  unless($count % $batchSize) {
    processBatch(@batch);
    @batch = ();
  }
}

# Get the last batch (which may not be full).
END {
    processBatch(@batch) if (@batch);
    @batch = ();
}

##################################

sub processBatch {
    my(@batch) = @_;
#  addNewToolPageFromEids("localhost:8080","XXXX","XXXX",@_);
#  addNewToolPageFromEids("chitlin.ds.itd.umich.edu",'dlhaines@gmail.com',"XXXXX",@_);
#  addNewToolPageFromEids("bologna.ds.itd.umich.edu",'dlhaines@gmail.com',"XXXXX",@_);
#    addNewToolPageFromEids("bologna.ds.itd.umich.edu",'admin','admin');
    addNewToolPageFromEids("bologna.ds.itd.umich.edu",'dlhaines','XXXX',@batch);
  printSummary($count,$startTime,time());
  @batch = ();
}

sub printSummary {
  my($cnt,$startTime,$endTime) = @_;
  print "cumulative ";
  print "users: $cnt ";
  my $elapsedSecs = $endTime - $startTime;
  print " elapsed time (secs) : ",$elapsedSecs;
  printf " seconds per user: %3.1f\n",$elapsedSecs/$cnt;
}

#end
