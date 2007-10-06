#!/usr/bin/perl

# Script to add a page and a tool to a user's my workspace.

use Class::Struct;
use strict;
use addNewPageToMyWorkspace qw( setPageAndToolNames );

# hold the host and account information
struct( HostAccount => [ hostProtocol=> '$', hostUrl => '$', user => '$', pw => '$']);
my $accnt;


my $trace = 0;

# Keep track of some values
my ($startTime,$endTime,$currentTime);

my ($count);
my $lastCntReported;
# size of batch to be processed.
my $batchSize = 1;
my @batch;

# specify the tool id and the name to be shown for the page and tool.
addNewPageToMyWorkspace::setPageAndToolNames("Teaching Questionnaires","Teaching Questionnaires","sakai.rsf.evaluation");

# generate summary statistics after every batch.

$startTime = time();

sub processFile {
  # expect a file with 1 eid per line.  Empty and commented lines are ignored.
  while (<>) {
    chomp;
    next if (/^\s*$/);
    next if (/^\s*#/); 
    $count++;
    print "eid: [$_]\n" if ($trace);
    # accumulate a batch of the eids to process.
    push(@batch,$_);
    unless($count % $batchSize) {
      @batch = processBatch(@batch);
    }
  }

  # Get the last batch (which may not be full).
  @batch = processBatch(@batch) if (@batch);
}
##################################

sub processBatch {
  my(@batch) = @_;
  addNewPageToMyWorkspace::addNewToolPageFromEids($accnt->user,$accnt->pw,@batch);
  printSummary($count,$startTime,time());
  return ();
}

sub printSummary {
  my($cnt,$startTime,$endTime) = @_;
  print "cumulative ";
  print "users: $cnt ";
  my $elapsedSecs = $endTime - $startTime;
  print " elapsed time (secs) : ",$elapsedSecs;
  printf " seconds per user: %3.1f\n",$elapsedSecs/$cnt;
}

addNewPageToMyWorkspace::setVerbose(0);
addNewPageToMyWorkspace::setTrace(0);
$accnt = new HostAccount( user => 'admin', pw => 'admin');
addNewPageToMyWorkspace::setWSURI('http','localhost:8080');

processFile();

#end
