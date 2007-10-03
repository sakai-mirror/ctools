#!/usr/bin/perl
use strict;
use addNewPageToMyWorkspaceRemote;

# test script
my $i=0;
my $reps = 1;
while ($i++ < $reps) {
   addNewToolPageFromEidsRemote("localhost:8081","admin","admin","newuser01","newuser02","newuser01","newuser02","newuser01","newuser02");
}


#end
