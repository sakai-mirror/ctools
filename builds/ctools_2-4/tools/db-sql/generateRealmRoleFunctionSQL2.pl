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
# separated by a ':'.

# backfill <role_name> <function_name>
# Add this function to every realm that has this role.

# If not using spaces as the seperator, then spaces are included in names!!!

use strict;

# keep track of some things for reporting
our $lineCnt;
our $pairCnt;
our $roleCnt;
our $functionCnt;

our $trace = 0;
our $printSql = 1;

# Hold the final set of functions / roles / pairs found.
our %realms;
our %functions;
our %roles;
our @pairs;
our @rrf;

# SQL templates for generating the sql statements.
# insert new function
our $sqlFunctionTmpl = "insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, '%s');";
# insert new role
our $sqlRoleTmpl = "insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, '%s');";
# insert new realm
our $sqlRealmTmpl = "insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '%s');";


# map the new functions and roles together
our $sqlPairTmpl = "insert into PERMISSIONS_SRC_TEMP values ('%s','%s');";

# variables to hold information from the input file.
our ($function,@roles);
# hold the current role under consideration.
our $r;


##### Do it


#print "Note that this only generates the specific sql and doesn't generate\n";
#print "the sql to actually perform the update.  The output then in just a model\n";
#print "for the right sql.\n";

## See if this is a test run.

#our $type = @ARGV[0];
#print "type: [$type]\n";
#if ($type =~ /test/i) {
#  1;
#}


# If invoked with no arguments, then just return having defined the functions, otherwise run it on the arguments.

#print "\$\#ARGV: ",$#ARGV,"\n"; 

if ($#ARGV == -1) {
  1;
} else {
  main();
}

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
      print "line: $_\n" if ($trace);
      processAddToRealm($_);
    }

    #     # get the data from the line and form the pairings.
    #     #  ($function,@roles) = split;
    #     ($function,@roles) = split(/\|/);
    #     $functions{$function}++;
    #     foreach $r (@roles) {
    #       push(@pairs,formatInsertRoleFunction($r,$function));
    #     }
  }
}


sub resetData {
  $lineCnt = 0;
  $pairCnt = 0;
  $roleCnt = 0;
  $functionCnt = 0;

  %realms = ();
  %functions = ();
  %roles = ();
  @pairs = ();
  @rrf = ();

}

END {
  
  print "In END\n" if ($trace);

  if ($printSql) {
  printRoleSql();
  printFunctionSql();
  printRealmSql();
  printSummary();
}

}

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

# sub processFunction{
#   return parseLine(@_);
# }

sub add_to_realm{
  my($function,@values) = @{parseLine(@_)};
  print "input: [",@_,"]\n" if ($trace);
  print "parsed: [",$function,"]:[",join("*",@values),"]\n" if ($trace);
  die("Not an addition $!") unless ($function =~ /add_to_realm/i);
  die("Badly formed realm tuple $!") unless (@values == 3);
  return insertRealmRoleFunction(@values);
}

sub insertRealmRoleFunction{
  my($realm,$role,$function) = @_;
  push(@rrf ,\@_);
#  print "realm: $realm\n";
  $realms{$realm}++;
  $functions{$function}++;
  $roles{$role}++;
}

sub processFunction{
  my($function,@values) = @{parseLine(@_)};
  print "input: [",@_,"]\n" if ($trace);
  print "parsed: [",$function,"]:[",@values,"]\n" if ($trace);
  die("Not a function $!") unless ($function =~ /function/i);
  return returnInsertFunction(@values);
}

sub parseLine {
  my($line) = shift;
  my($verb,$seperator,$tail) = $line =~ m|(\w+)(\W)(.*)|;
  ## add the backslash to allow | as a seperator.
  my(@values) = split("\\".$seperator,$tail);
  unshift @values, $verb;
  print "verb: [$verb] seperator: [$seperator] values: [",@values,"] \n" if ($trace);
  return(\@values);
}

##### Generate the sql stmts.

sub formatInsertRoleFunction {
  # write sql for a pair
  my($role,$function) = @_;
  $pairCnt++;
  $roles{$role}++;
  return returnInsertRoleFunction($role,$function);
}

sub returnInsertRoleFunction {
  # write sql for a pair
  my($role,$function) = @_;
  return sprintf($sqlPairTmpl,$role,$function);
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
  print "rIF:",@_,"\n" if ($trace);
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
  $functionCnt++;
}

sub returnInsertRealm {
  # write sql to insert a realm
  my($realm) = @_;
  return sprintf($sqlRealmTmpl,$realm);
}


# sub returnInsertFunction {
#   # write sql to insert a function
#   my(@functions) = @_;
#   my(@sql);
#   foreach(@functions) {
#     push @sql,sprintf($sqlFunctionTmpl,$function);
#   }
#   return @sql;
# }

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

1;
#end
