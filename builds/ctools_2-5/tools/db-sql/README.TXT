Customizing permissions for database conversions.

Note that the term "function" and "permission" are interchangable in
this file.

The standard database conversion scripts provided with a sakai release
must be generic and will need customization to deal with an individual
installation's needs.

Two scripts in this directory help with this task.

parseRealmUpdate2.pl - examine a generic sql file and build a table of
which roles needs which permissions. 

generateRealmRoleFunctionSQL.pl - Take a table and generate (some) sql
to update permissions. 

The utility of the scripts is that it is much easier to modify the
table for local needs than to write the required sql by hand. 

The table format is:
function|role|role|.....

A function name can be followed by any number of role names to which
it should be added.

If you run parseRealmUpdate2.pl on a conversion script
(e.g. sakai_2_3_1-2_4_0_oracle_conversion.sql) you get a summary of
the conversion including:

- the names of the functions that will be added,
- the role and function that will be added to templates,
- the role and function that will be added to existing realms,
- a function|role table summarizing which roles a function will be added
to.

If you run that table through generateRealmRoleFunctionSQL.pl 
"generateRealmRoleFunctionSQL.pl <table file" you get the sql required
to actually add those permissions.







--------------------------------------
$HeadURL$
$Id$
