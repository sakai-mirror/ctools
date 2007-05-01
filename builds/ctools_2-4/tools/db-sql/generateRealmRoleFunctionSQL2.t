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
$trace=0;

$printSql = 0;

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

###
#$trace=1;
resetData();
test_add_to_realm("add_to_realm:!REALM:ROLE:FUNCTION",1,1,1,1);
test_add_to_realm("add_to_realm:!REALM:ROLE:FUNCTION",1,1,1,2);

resetData();
test_add_to_realm("add_to_realm:!REALM:ROLE:FUNCTION",1,1,1,1);
test_add_to_realm("add_to_realm:!REALM:ROLE:FUNCTION2",1,1,2,2);
test_add_to_realm("add_to_realm:!REALM2:ROLE2:FUNCTION3",2,2,3,3);


###### backfill tests
resetData();
test_backfill("backfill:role1:function1",1,1);
test_backfill("backfill:role2:function2",2,2);
test_backfill("backfill:role1:function3:function4",2,4);

######## util ##########

sub testAddNewTuple {

  my($realm,$role,$function,$realmCnt,$roleCnt,$functionCnt) = @_;
  my %cnt;

  $cnt{realm} = scalar(keys(%realms));
  $cnt{role} = scalar(keys(%roles));  
  $cnt{function} = scalar(keys(%functions));

  saveRealmRoleFunction($realm,$role,$function);

  my $args = join(",",@_);

  is(keys(%realms)+0,$realmCnt,"check realm count: $args");
  is(keys(%roles)+0,$roleCnt,"check role count: $args");
  is(keys(%functions)+0,$functionCnt,"check function count: $args");

}

sub test_add_to_realm {

  my($line,$realmCnt,$roleCnt,$functionCnt,$tupleCnt) = @_;
  my %cnt;

  $cnt{realm} = scalar(keys(%realms));
  $cnt{role} = scalar(keys(%roles));  
  $cnt{function} = scalar(keys(%functions));

  add_to_realm($line);

  my $args = join(",",@_);

  is(keys(%realms)+0,$realmCnt,"add_to_realm: check realm count: [$args]");
  is(keys(%roles)+0,$roleCnt,"add_to_realm: check role count: [$args]");
  is(keys(%functions)+0,$functionCnt,"add_to_realm: check function count: [$args]");
  is(scalar(@rrf),$tupleCnt,"add_to_realm: check tuple cnt [$args]");

}

sub test_backfill{

  my($line,$roleCnt,$functionCnt) = @_;
  my %cnt;

  $cnt{role} = scalar(keys(%roles));  
  $cnt{function} = scalar(keys(%functions));

  backfillRoleFunction($line);

  my $args = join(",",@_);

  print "%roles:keys:[",join("*",keys(%roles)),"]\n";
  is(keys(%roles)+0,$roleCnt,"backfill: check role count: [$args]");
  is(keys(%functions)+0,$functionCnt,"backfill: check function count: [$args]");
  
}



    #end
