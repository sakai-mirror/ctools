#!/usr/bin/perl

# Generate sql to insert roles, functions, and role function pairs
# into a database for a 2.0.1 to 2.1.2 upgrade.
# This does nothing to check that the functions / roles need to added, so 
# be aware of that when updating the db.

# This only generates Oracle compatible sql, but it should be easy to 
# modify the tmpl variables to generate other variants.

# $HeadURL$
# $Id$

########
# The input format is a text file with lines like:
# <function> <roleA> <roleb> ......
# Blank lines and comment lines (starting with a #) are ignored.
#######
# The new input format is: 

# add_to_realm <realm_name> <role_name> <function_name> add this tuple to
# a realm.  The first non word character is the separator character.
# E.g.  "add_tuple !sillysite actor ego" has the values separated by a
# space.  E.g. "add_tuple:!sillysite:actor:ego" has the value
# separated by a ':'.  Multiple function names can be specfied for a particular
# realm and role.

# backfill <role_name> <function_name>.  Arrange for the any realm with this role to have this function added to it.

# Add this function to every realm that has this role.

# If not using spaces as the seperator, then spaces are included in names!!!

use strict;

# keep track of some things for reporting
our $lineCnt;
our $tupleCnt;
our $backfillCnt;
our $roleCnt;
our $functionCnt;
our $realmCnt;

our $trace = 0;
#our $trace = 1;
our $printBareTuple = 0;
our $printSql = 1;

# Hold the final set of functions / roles / pairs found.
our %realms;
our %functions;
our %roles;
our @pairs;
our @rrf;
our @backfill;

# SQL templates for generating the sql statements.
# insert new function
our $sqlFunctionTmpl = "insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, '%s');";
# insert new role
our $sqlRoleTmpl = "insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, '%s');";
# insert new realm
our $sqlRealmTmpl = "insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '%s');";

# map the realm / role / function together.
our $sqlTupleTmpl = "INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '%s'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = '%s'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = '%s'));";


# map the backfill functions and roles together
our $sqlBackfillTmpl = "insert into PERMISSIONS_SRC_TEMP values ('%s','%s');";

# variables to hold information from the input file.
our ($function,@roles);

# If invoked with no arguments, then just return having defined the functions, otherwise run it on the arguments.

if ($#ARGV == -1) {
  1;
} else {
  main();
}


## Read from stdin and process each line.
sub main  {

  resetData();
  printHeader();

  # read each line
  while (<>) {

    # prep line and skip non-relevant lines.
    chomp;
    next if (/^\s*$/);
    next if (/^\s*#/);
    $lineCnt++;

    if (/^\s*add_to_realm/i) {
      print "line: [$_]\n" if ($trace);
      add_to_realm($_);
    }

    if (/^\s*backfill/i) {
      print "line: [$_]\n" if ($trace);
      backfillRoleFunction($_);
    }
  }
}


# Reset the state of the script.  Mostly for testing.
sub resetData {
  $lineCnt = 0;
  $tupleCnt = 0;
  $backfillCnt = 0;
  $roleCnt = 0;
  $functionCnt = 0;
  $realmCnt = 0;

  %realms = ();
  %functions = ();
  %roles = ();
  @rrf = ();
  @backfill = ();
}

# When input is done, print the requested sql.
END {
  
  print "In END\n" if ($trace);

  if ($printSql) {
    print "\n";
    printRoleSql();
    printFunctionSql();
    printRealmSql();
    printTupleSql();
    printBackfillSql();
    printSummary();
  }

}

### Take tuple information then pick out and save the tuples.  Along
### the way keep track of the realm / role / function names.

### Take an input line and pull out the pieces.
### This allows for an indefinate number of elements.
sub parseLine {
  my($line) = shift;
  my($verb,$seperator,$tail) = $line =~ m|(\w+)(\W)(.*)|;
  ## add the backslash to allow | as a seperator.
  my(@values) = split("\\".$seperator,$tail);
  unshift @values, $verb;
  print "verb: [$verb] seperator: [$seperator] values: [",@values,"] \n" if ($trace);
  return(\@values);
}

## Parse the line, sanity check, and arrange to save the tuple.
sub add_to_realm{
  my($function,@values) = @{parseLine(@_)};
  print "input: [",@_,"]\n" if ($trace);
  print "parsed: [",$function,"]:[",join("*",@values),"]\n" if ($trace);
  die("Not an addition $!") unless ($function =~ /add_to_realm/i);
  die("Badly formed realm tuple $!") unless (@values >= 3);
  return saveRealmRoleFunction(@values);
}

## Save a set of tuples.  There may be multiple function
## names, so loop over the trailing entries.
sub saveRealmRoleFunction{
  my($realm,$role,@functions) = @_;

  $realms{$realm}++;
  $roles{$role}++;

  foreach (@functions) {
    my($function) = $_;
    push(@rrf ,[$realm,$role,$function]);
    $functions{$function}++;
  }

}

sub processFunction{
  my($function,@values) = @{parseLine(@_)};
  print "input: [",@_,"]\n" if ($trace);
  print "parsed: [",$function,"]:[",@values,"]\n" if ($trace);
  die("Not a function $!") unless ($function =~ /function/i);
  return returnInsertFunction(@values);
}

sub backfillRoleFunction{
  my($command,$role,@functions) = @{parseLine(@_)};
  print "bRF: role: [$role] functions: [",join("*",@functions),"]\n";

  $roles{$role}++;

  foreach (@functions) {
    my($function) = $_;
    push(@backfill,[$role,$function]);
    $functions{$function}++;
  }

}

##### Generate the sql stmts.

### Format and print the sql.

sub printRoleSql {
  foreach (sort(keys(%roles))) {
    printInsertRole($_);
  }
  print "\n";
}

sub printFunctionSql {
  foreach (sort(keys(%functions))) {
    printInsertFunction($_);
  }
  print "\n";
}

sub printRealmSql {
  foreach (sort(keys(%realms))) {
    printInsertRealm($_);
  }
  print "\n";
}

sub printTupleSql {
  foreach (@rrf) {
    printInsertTuple(@{$_});
  }
  print "\n";
}

sub printBackfillSql {
  foreach (@backfill) {
    printBackfill(@{$_});
  }
  print "\n";
}

sub formatInsertRoleFunction {
  # write sql for a pair
  my($role,$function) = @_;
  $tupleCnt++;
  $roles{$role}++;
  return returnInsertRoleFunction($role,$function);
}

sub returnInsertRoleFunction {
  # write sql for a pair
  my($role,$function) = @_;
  return sprintf($sqlBackfillTmpl,$role,$function);
}

sub printInsertRole {
  # write sql to insert a role
  print returnInsertRole(@_),"\n";
  $roleCnt++;
}

sub returnInsertRole {
  # write sql to insert a role
  my($role) = @_;
  return sprintf($sqlRoleTmpl,$role);
}

sub printInsertFunction {
  # write sql to insert a function
  print returnInsertFunction(@_),"\n";
  $functionCnt++;
}

sub returnInsertFunction {
  # write sql to insert a function
  my($function) = @_;
  return sprintf($sqlFunctionTmpl,$function);
}

sub printInsertRealm {
  # write sql to insert a function
  print returnInsertRealm(@_),"\n";
  $realmCnt++;
}

sub returnInsertRealm {
  # write sql to insert a realm
  my($realm) = @_;
  return sprintf($sqlRealmTmpl,$realm);
}

sub printInsertTuple {
  # write sql to insert a tuple
  print returnInsertTuple(@_),"\n";
  $tupleCnt++;
}

sub returnInsertTuple {
  # write sql to insert a tuple
  my(@tuple) = @_;
  if ($printBareTuple) {
    print "tuple: [",join(",",@tuple),"]\n";
  }
  return sprintf($sqlTupleTmpl,@tuple);
}

sub printBackfill {
  # write sql to insert a tuple
  print returnBackfill(@_),"\n";
  $backfillCnt++;
}

sub returnBackfill {
  # write sql to insert a tuple
  my(@args) = @_;
  return sprintf($sqlBackfillTmpl,@args);
}


# Print the header and summary

sub printHeader {
  print "-- This file was auto generated at ",`date`,"\n";
}

sub printSummary {
  # print a summary that sql will ignore
  print "-- lineCnt: $lineCnt tupleCnt: $tupleCnt\n";
  print "-- roleCnt: $roleCnt functions: $functionCnt\n";  
  print "-- realmCnt: $realmCnt backfillCnt: $backfillCnt\n";
  print "\n";
}

1;
#end
