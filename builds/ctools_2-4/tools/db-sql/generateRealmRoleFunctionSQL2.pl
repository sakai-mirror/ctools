#!/usr/bin/perl

# Generate sql to insert roles, functions, and role function pairs
# into a database for a 2.0.1 to 2.1.2 upgrade.
# This does nothing to check that the functions / roles need to added, so 
# be aware of that when updating the db.

# This only generates Oracle compatible sql, but it should be easy to 
# modify the tmpl variables to generate other variants.

# $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/builds/ctools_2-4/tools/db-sql/generateRealmRoleFunctionSQL.pl $
# $Id: generateRealmRoleFunctionSQL.pl 29082 2007-04-18 20:16:32Z dlhaines@umich.edu $

########
# The input format is a text file with lines like:
# <function> <roleA> <roleb> ......
# Blank lines and comment lines (starting with a #) are ignored.
#######
# The new input format is: 

# function <list of function names> - make sure these are valid
# functions.  

# role <list of role names> - make sure these are valid
# roles.  

# realm <list of realm names> - make sure these are valid
# realm names.  

# add_tuple <realm_name> <role_name> <function_name> add this tuple to
# a realm.  The first non word character is the separator character.
# E.g.  "add_tuple !sillysite actor ego" has the values separated by a
# space.  E.g. "add_tuple:!sillysite:actor:ego" has the value
# separated by a ':'.

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


#print "Note that this only generates the specific sql and doesn't generate\n";
#print "the sql to actually perform the update.  The output then in just a model\n";
#print "for the right sql.\n";

## See if this is a test run.

#our $type = @ARGV[0];
#print "type: [$type]\n";
#if ($type =~ /test/i) {
#  1;
#}


#If invoked with no arguments, then  just return having defined the functions, otherwise run it on the arguments.

#print "\$\#ARGV: ",$#ARGV,"\n"; 

if ($#ARGV == -1) {
  1;
}
else {
  main();
}

sub main  {
  printHeader();

  # read each line
  while (<>) {

    # prep line and skip non-relevant lines.
    chomp;
    next if (/^\s*$/);
    next if (/^\s*#/);
    $lineCnt++;

    if (/^\s*function:/i) {
      processFunction($_);
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

END {
  
  print "In END\n";

  # Print the various inserts and a summary

  #   foreach (sort(keys(%functions))) {
  #     printInsertFunction($_);
  #   }
  #   print "\n";

  foreach (sort(keys(%roles))) {
    printInsertRole($_);
  }
  print "\n";

  foreach (sort(@pairs)) {
    print "$_\n";
  }

  printSummary();

}

sub processFunction{
  return parseLine(@_);
}

sub parseLine {
  my($line) = shift;
  my($verb,$seperator,$tail) = $line =~ m|(\w+)(\W)(.*)|;
  ## add the backslash to allow | as a seperator.
  my(@values) = split("\\".$seperator,$tail);
  unshift @values, $verb;
#  print "verb: [$verb] seperator: [$seperator] values: [",@values,"] \n";
    return(\@values);
}


sub parseLineOld {
  my($line) = shift;
  my($verb,$seperator,$tail) = $line =~ m|(\w+)(\W)(.*)|;
  ## add the backslash to allow | as a seperator.
  my(@values) = split("\\".$seperator,$tail);
#  print "verb: [$verb] seperator: [$seperator] values: [",@values,"] \n";
  my(@return) = ($verb,@values);
  return(\@return);
}

##### Generate the sql stmts.

# sub formatInsertRoleFunctionOld {
#   # write sql for a pair
#   my($role,$function) = @_;
#   $pairCnt++;
#   $roles{$role}++;
#   return sprintf($sqlPairTmpl,$role,$function);

# }

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

# sub printInsertRoleOld {
#   # write sql to insert a role
#   my($role) = @_;
#   print sprintf($sqlRoleTmpl,$role),"\n";
#   $roleCnt++;
# }

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

# sub printInsertFunction {
#   # write sql to insert a function
#   my($function) = @_;
#   print sprintf($sqlFunctionTmpl,$function),"\n";
#   $functionCnt++;
# }

sub printInsertFunction {
  # write sql to insert a function
  print "rIF:",@_,"\n";
  print returnInsertFunction(@_),"\n";
  $functionCnt++;
}

sub returnInsertFunction {
  # write sql to insert a function
  my($function) = @_;
  return sprintf($sqlFunctionTmpl,$function);
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

1;
#end
