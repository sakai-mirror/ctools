#!/usr/bin/perl

# Tests for generateRealmRoldFunctionSQL2.pl

# $HeadURL$
# $Id$

use env;
#use lib "$ENV{HOME}/mytools/bin";
use lib ".";

use Test::More tests=>24;

require ("generateRealmRoleFunctionSQL2.pl");

# set this to non-zero to get tracing.
$trace=1;

############ Check the basic sql templates.

is(returnInsertFunction("FUNCTION"),
   "insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'FUNCTION');",
   "check function SQL template");

is(returnInsertRole("ROLE"),
   "insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'ROLE');",
   "check role SQL template");

is(returnInsertRole("ROLE WITH SPACES"),
   "insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'ROLE WITH SPACES');",
   "check role with spaces SQL template");

is(returnInsertRoleFunction("ROLE WITH SPACES","FUNCTION"),
   "insert into PERMISSIONS_SRC_TEMP values ('ROLE WITH SPACES','FUNCTION');",
   "check role function SQL template");

############ Check parsing of specification line

is_deeply(parseLine("function:FNAME"),
   ["function","FNAME"],
   "check find function line with seperator [:]");

is_deeply(parseLine("function: FNAME"),
   ["function"," FNAME"],
   "check find function line with seperator [:].  Spaces count if using non-space seperator.");

is_deeply(parseLine("function:FNAME1:FNAME2"),
   ["function","FNAME1","FNAME2"],
   "check find multiple value function line with seperator [:]");

is_deeply(parseLine("function FNAME"),
   ["function","FNAME"],
   "check find function line with seperator ' '");

is_deeply(parseLine("function|FNAME"),
   ["function","FNAME"],
   "check find function line with seperator '|'");

is_deeply(parseLine("function|FNAME1|FNAME2"),
   ["function","FNAME1","FNAME2"],
   "check find multiple value function line");

is_deeply(parseLine("role|ROLE1|ROLE2"),
   ["role","ROLE1","ROLE2"],
   "check find multiple value role line");

##############  check line to sql output

#### functions

is(processFunction("function:FUNCT01"),
   "insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'FUNCT01');",
   "function values to sql");

is(processFunction("function:FUNCT01:FUNCT02"),
   "insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'FUNCT01');",
   "function values to sql");

resetData();
testAddNewTuple("REALM","ROLE","FUNCTION",1,1,1);

resetData();
testAddNewTuple("REALM1","ROLE1","FUNCTION1",1,1,1);
testAddNewTuple("REALM2","ROLE2","FUNCTION2",2,2,2);
testAddNewTuple("REALM2","ROLE2","FUNCTION2",2,2,2);
testAddNewTuple("REALM2","ROLE3","FUNCTION2",2,3,2);
testAddNewTuple("REALM2","ROLE3","FUNCTION3",2,3,3);


# is(add_to_realm("add_to_realm:REALM_A:ROLE_A:FUNCTION_A"),
#    "",
#    "add realm tuple");

sub testAddNewTuple {

  my($realm,$role,$function,$realmCnt,$roleCnt,$functionCnt) = @_;
  my %cnt;

  $cnt{realm} = scalar(keys(%realms));
  $cnt{role} = scalar(keys(%roles));  
  $cnt{function} = scalar(keys(%functions));

  insertRealmRoleFunction($realm,$role,$function);

  is(keys(%realms)+0,$realmCnt,"check realm count");
  is(keys(%roles)+0,$roleCnt,"check role count");
  is(keys(%functions)+0,$functionCnt,"check function count");

}

sub testAddNewTupleOld {

  my($realm,$role,$function) = @_;
  my %cnt;

#  resetData();

#   while(($k,$v) = each(%cnt)) {
#     print "k: [$k] v: [$v]\n";
#   }

#  print "lk:",scalar(keys(%realms)),"\n";
#  foreach(keys(%realms)) {
#    print "key: $_\n";
#  }
  $cnt{realm} = scalar(keys(%realms));
#  print "X: realmcnt: $cnt{realm}\n";
#  while(($k,$v) = each(%realms)) {
#    print "r: k: [$k] v: [$v]\n";
#  }
#  print "X: realms:",join("*",keys(%realms)),"\n";
  $cnt{role} = scalar(keys(%roles));  
  $cnt{function} = scalar(keys(%functions));

#   print "a realms:",join("*",keys(%realms)),"\n";
#   print "a realmCnt: ",$cnt{realm},"\n";
  insertRealmRoleFunction($realm,$role,$function);
#   print "b realms:",join("*",keys(%realms)),"\n";

#   print "realmCnt: ",$cnt{realm},"\n";

#   print "realms:",join("*",keys(%realms)),"\n";

#   while(($k,$v) = each(%cnt)) {
#     print "k: $k v: $v\n";
#   }

#  print "test: ",(%realms)+0,"\n";

  is(keys(%realms)+0,$cnt{realm}+1,"check realm count");

}

#end
