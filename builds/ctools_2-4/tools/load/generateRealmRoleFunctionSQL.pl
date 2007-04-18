#!/usr/bin/perl

# Generate sql to insert roles, functions, and role function pairs
# into a database for a 2.0.1 to 2.1.2 upgrade.
# This does nothing to check that the functions / roles need to added, so 
# be aware of that when updating the db.

# This only generates Oracle compatible sql, but it should be easy to 
# modify the tmpl variables to generate other variants.

# $HeadURL$
# $Id$

# The input format is a text file with lines like:
# <function> <roleA> <roleb> ......
# Blank lines and comment lines (starting with a #) are ignored.

use strict;

# keep track of some things for reporting
our $lineCnt;
our $pairCnt;
our $roleCnt;
our $functionCnt;


# Hold the final set of functions / roles / pairs found.
our %functions;
our %roles;
our @pairs;

# SQL templates for generating the sql statements.
# insert new function
our $sqlFunctionTmpl = "insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, '%s');";
# insert new role
our $sqlRoleTmpl = "insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, '%s');";
# map the new functions and roles together
our $sqlPairTmpl = "insert into PERMISSIONS_SRC_TEMP values ('%s','%s');";

# variables to hold information from the input file.
our ($function,@roles);
# hold the current role under consideration.
our $r;


##### Do it

print "Note that this only generates the specific sql and doesn't generate\n";
print "the sql to actually perform the update.  The output then in just a model\n";
print "for the right sql."

printHeader();

# read each line
while (<>) {

  # prep line and skip non-relevant lines.
  chomp;
  next if (/^\s*$/);
  next if (/^\s*#/);
  $lineCnt++;

  # get the data from the line and form the pairings.
  ($function,@roles) = split;
  $functions{$function}++;
  foreach $r (@roles) {
    push(@pairs,formatInsertRoleFunction($r,$function));
  }
}

END {
  # Print the various inserts and a summary

  foreach (sort(keys(%functions))) {
    printInsertFunction($_);
  }
  print "\n";

  foreach (sort(keys(%roles))) {
    printInsertRole($_);
  }
  print "\n";

  foreach (sort(@pairs)) {
    print "$_\n";
  }

  printSummary();

}

##### Generate the sql stmts.

sub formatInsertRoleFunction {
  # write sql for a pair
  my($role,$function) = @_;
  $pairCnt++;
  $roles{$role}++;
  return sprintf($sqlPairTmpl,$role,$function);

}

sub printInsertRole {
  # write sql to insert a role
  my($role) = @_;
  print sprintf($sqlRoleTmpl,$role),"\n";
  $roleCnt++;
}

sub printInsertFunction {
  # write sql to insert a function
  my($function) = @_;
  print sprintf($sqlFunctionTmpl,$function),"\n";
  $functionCnt++;
}


# print a header

sub printHeader {
  print "-- This file was auto generated at ",`date`,"\n";
}

# Print the summary

sub printSummary {
  # print a summary that sql will ignore
  print "-- lineCnt: $lineCnt pairCnt: $pairCnt\n";
  print "-- roleCnt: $roleCnt functions: $functionCnt\n";
  print "\n";
}

#end
