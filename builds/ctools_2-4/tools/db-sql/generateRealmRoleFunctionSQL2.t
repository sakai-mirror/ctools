#!/usr/bin/perl

# Tests for generateRealmRoldFunctionSQL2.pl

# $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/builds/ctools_2-4/tools/db-sql/generateRealmRoleFunctionSQL.pl $
# $Id: generateRealmRoleFunctionSQL.pl 29082 2007-04-18 20:16:32Z dlhaines@umich.edu $

use env;
#use lib "$ENV{HOME}/mytools/bin";
use lib ".";

use Test::More tests=>24;

require ("generateRealmRoleFunctionSQL2.pl");

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

is_deeply(processFunction("function:FNAME"),
   ["function","FNAME"],
   "check find function line with seperator [:]");

is_deeply(processFunction("function:FNAME1:FNAME2"),
   ["function","FNAME1","FNAME2"],
   "check find multiple value function line with seperator [:]");

is_deeply(processFunction("function FNAME"),
   ["function","FNAME"],
   "check find function line with seperator ' '");

is_deeply(processFunction("function|FNAME"),
   ["function","FNAME"],
   "check find function line with seperator '|'");

is_deeply(processFunction("function|FNAME1|FNAME2"),
   ["function","FNAME1","FNAME2"],
   "check find multiple value function line");

is_deeply(processFunction("role|ROLE1|ROLE2"),
   ["role","ROLE1","ROLE2"],
   "check find multiple value role line");

##############  check line to sql output

#### functions





#end
