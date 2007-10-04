#!/usr/bin/perl

# Script to add a page and a tool to a user's my workspace.

use strict;
use addNewPageToMyWorkspace;


# Keep track of some values
my ($startTime,$endTime,$currentTime);

my ($count);
my $lastCntReported;
# how often to print the processing summary
my $batchSize = 12;
my @batch;

# specify the tool id and the name to be shown for the page and tool.
setPageAndToolNames("Added Eval","Added Evaluation tool","sakai.rsf.evaluation");
# set the batch size.  Will process the eids in batches of this size and will 
# generate summary statistics after every batch.

$startTime = time();

# expect a file with 1 eid per line.  Empty and commented lines are ignored.
while(<>) {
  chomp;
  next if (/^\s*$/);
  next if (/^\s*#/);
  $count++;
  # accumulate a batch of the eids to process.
  push(@batch,$_);
  unless($count % $batchSize) {
    processBatch(@batch);
  }
}

# Get the last batch (which may not be full).
END {
  processBatch(@batch) if (@batch);
}

##################################

sub processBatch {
  addNewToolPageFromEids("localhost:8080","XXXX","XXXX",@_);
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
