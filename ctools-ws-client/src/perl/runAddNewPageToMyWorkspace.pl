#!/usr/bin/perl
use strict;
use addNewPageToMyWorkspace;

# test script
my $i=0;
my $reps = 1;
#while ($i++ < $reps) {
#   addNewToolPageFromEids("localhost:8080","admin","admin","newuser01","newuser02","newuser01","newuser02","newuser01","newuser02");
#}

my ($startTime,$endTime);

my ($count);
my $printRate = 2;
$startTime = time();
while(<>) {
  chomp;
  next if (/^\s*$/);
  next if (/^\s*#/);
  $count++;
  addNewToolPageFromEids("localhost:8080","admin","admin",$_);
}


#end
