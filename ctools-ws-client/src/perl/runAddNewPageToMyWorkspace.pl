#!/usr/bin/perl
use strict;
use addNewPageToMyWorkspace;

# test script
my $i=0;
my $reps = 1;
#while ($i++ < $reps) {
#   addNewToolPageFromEids("localhost:8080","XXXX","XXXX","newuser01","newuser02","newuser01","newuser02","newuser01","newuser02");
#}

my ($startTime,$endTime,$currentTime);

my ($count);
my $lastCntReported;
# how often to print the processing summary
my $batchSize = 12;
my @batch;

# specify the tool id and the name to be shown for the page and tool.
setPageAndToolNames("Added Eval","Added Evaluation tool","sakai.rsf.evaluation");

$startTime = time();

# expect a file with 1 eid per line.  Comments and commented lines are ignored.
while(<>) {
  chomp;
  next if (/^\s*$/);
  next if (/^\s*#/);
  $count++;
  push(@batch,$_);
  unless($count % $batchSize) {
    processBatch(@batch);
  }
}

# Get the last batch which may not be full
END {
  processBatch(@batch) if (@batch);
}

sub processBatch {
  addNewToolPageFromEids("localhost:8080","XXXX","XXXX",@_);
#  addNewToolPageFromEids("localhost:8080","admin","admin",@_);
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
