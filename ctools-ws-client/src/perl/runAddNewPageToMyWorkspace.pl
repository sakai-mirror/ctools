#!/usr/bin/perl
use strict;
use addNewPageToMyWorkspace;

# test script
my $i=0;
my $reps = 1;
while ($i++ < $reps) {
   addNewToolPageFromEids("localhost:8080","admin","admin","newuser01","newuser02","newuser01","newuser02","newuser01","newuser02");
}


#end
