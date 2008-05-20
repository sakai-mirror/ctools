#!/usr/bin/perl 

# Switch a conversion script between the readable shortcut permissions statements
# and the longer SQL version of the statements.

# This will take any uncommented line in a format it recognizes and translates to the other.


# $HeadURL: https://wush.net/svn/ctools/sandbox/dlh/trunk/mytools/misc/readablePermissions.pl $
# $Id: readablePermissions.pl 53 2008-05-19 16:02:20Z dlhaines $

my $lines=0;

#my @newFunctions;
#my @templateAdditions;
#my @backfill;

my $discountHandled = 1;
my $printShortedCommented = 0;

while(<>) {
    $printed = 0;

 #  next if (/^\s*$/);
 #  next if (/^\s*--/);
    $lines++;

 #DELETE From SAKAI_REALM_RL_FN WHERE REALM_KEY = (select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.portfolio') AND ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Participant') and FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'reports.view');

 #    $permission.DELETE.tmpl = 'DELETE From SAKAI_REALM_RL_FN WHERE REALM_KEY = (select REALM_KEY from SAKAI_REALM where REALM_ID = '$realm') AND ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = '$role') and FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = '$function');';

    if (/DELETE From SAKAI_REALM_RL_FN WHERE REALM_KEY = \(select REALM_KEY from SAKAI_REALM where REALM_ID = '(.*)'\) AND ROLE_KEY = \(select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = '(.*)'\) and FUNCTION_KEY = \(select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = '(.*)'\)/i) {
	my($realm,$role,$function) = ($1,$2,$3);
	print "permission.DELETE: [$realm][$role][$function]\n";
	$printed = 1;
    }

    if (/^\s*permission\.DELETE: \[(.*)\]\[(.*)\]\[(.*)\]/) {
	print "--  $_" if ($printShortCommented);
	my($realm,$role,$function) = ($1,$2,$3);
	print "DELETE From SAKAI_REALM_RL_FN WHERE REALM_KEY = (select REALM_KEY from SAKAI_REALM where REALM_ID = '$realm') AND ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = '$role') and FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = '$function');\n";
	$printed = 1;
    }

#delete from SAKAI_REALM_RL_FN where function_key in (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME like 'roster.%');
    if (/delete from SAKAI_REALM_RL_FN where function_key in \(select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME like '(.*)'\);/i) {
	print "permission.FUNCTION.DELETE: [$1]\n";
	$printed = 1;
    }

    if (/^\s*permission\.FUNCTION\.DELETE: \[(.*)\]/) {
	print "--  $_" if ($printShortCommented);
	my($function) = ($1);
	
	print "delete from SAKAI_REALM_RL_FN where function_key in \(select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME like '$function'\);\n";
	$printed = 1;
    }

    ##########
    # add a new role
    #insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Evaluator');

    if (/insert into SAKAI_REALM_ROLE VALUES \(SAKAI_REALM_ROLE_SEQ.NEXTVAL, '(.*)'\);/i) {
	my($role) = ($1);
	print "permission.ROLE.ADD: [$role]\n";
	$printed=1;
	$lines-- if ($discountHandled);
    }

    if (/^\s*permission\.ROLE\.ADD: \[(.*)\]/i) {
	print "--  $_" if ($printShortCommented);
	my($role) = ($1);
	print "insert into SAKAI_REALM_ROLE VALUES \(SAKAI_REALM_ROLE_SEQ.NEXTVAL, '$role'\);'\ny";
	$printed=1;
	$lines-- if ($discountHandled);
    }

    # add a new function
    if (/insert into SAKAI_REALM_FUNCTION.*'(.*)'/i) {
	my($function) = ($1);
	print "permission.FUNCTION.ADD: [$function]\n";
	$printed=1;
	$lines-- if ($discountHandled);
    }

    if (/^\s*permission\.FUNCTION\.ADD: \[(.*)\]/i) {
	my($function) = ($1);
	print "--  $_" if ($printShortCommented);
	print "insert into SAKAI_REALM_FUNCTION VALUES(SAKAI_REALM_FUNCTION_SEQ.NEXTVAL,'$function');\n";
	$printed=1;
	$lines-- if ($discountHandled);
    }

    # add a new permission tuple. Match an appreviated version.
    if (/insert into SAKAI_REALM_RL_FN .*REALM_ID\s*=\s*'([^']+).*ROLE_NAME\s*=\s*'([^']+).*FUNCTION_NAME\s*=\s*'([^']+)/i) {
	print "permission.ADD: [$1][$2][$3]\n";
	$printed=1;
	$lines-- if ($discountHandled);
    }

# INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewallmembers'));
    if (/^\s*permission.ADD:\s+\[(.*)\]\[(.*)\]\[(.*)\]/i) {
	print "--  $_" if ($printShortCommented);
	($realm,$role,$function) = ($1,$2,$3);
	print "INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '$realm'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = '$role'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = '$function'));\n";
#	print "insert into SAKAI_REALM_RL_FN REALM_ID = '$realm' ROLE_NAME = '$role' FUNCTION_NAME = '$function';\n";

	$printed=1;
	$lines-- if ($discountHandled);
    }

    # backfill example
    # INSERT INTO PERMISSIONS_SRC_TEMP values ('Instructor','roster.viewallmembers');

    if (/insert into PERMISSIONS_SRC_TEMP.*'([^']+)'.*'([^']+)'/i) {
	print "permission.BACKFILL: [$1][$2]\n";
	$printed=1;
	$lines-- if ($discountHandled);
    }

    if (/^\s*permission.BACKFILL: \[(.*)\]\[(.*)\]/)  {
	my($role,$function) = ($1,$2);
	print "--  $_" if ($printShortCommented);
	print "insert into PERMISSIONS_SRC_TEMP values ('$role','$function');\n";
	$printed=1;
	$lines-- if ($discountHandled);
    }

    print "$_" unless ($printed);

}

END {
    print "-- lines: $lines\n";

}

#end
