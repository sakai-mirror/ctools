#!/usr/bin/perl 

# look at update script and generate list of permission: roles

# $HeadURL$
# $Id$



my $lines=0;

my @newFunctions;
my @templateAdditions;
my @backfill;
my %permissionRoles;
my %permissionRoleList;

my $discountHandled = 0;
while(<>) {

  next if (/^\s*$/);
  next if (/^\s*--/);
  $lines++;

  if (/insert into SAKAI_REALM_FUNCTION.*'(.*)'/i) {
    push @newFunctions, $1;
#    print "new function: $1\n";
    $lines-- if ($discountHandled);
  }

  if (/insert into SAKAI_REALM_RL_FN .*REALM_ID\s*=\s*'([^']+).*ROLE_NAME\s*=\s*'([^']+).*FUNCTION_NAME\s*=\s*'([^']+)/i) {
    push @templateAdditions, "$1\t$2\t$3";
#    print "realm_id: $1 role_name: $2 function_name: $3\n";
    $permissionRoles{$2} += $3;
    $lines-- if ($discountHandled);
  }

  if (/insert into PERMISSIONS_SRC_TEMP.*'([^']+)'.*'([^']+)'/i) {
    print "backfill: $1, $2\n";
    push @backfill, "$1\t$2";
    $permissionRoleList{$2} .= "|$1";
    print "pR: $2 $permissionRoleList{$2}\n";
    $lines-- if ($discountHandled);
  }

}


END {
  print "lines: $lines\n";


  print "**************\n";
  print "adding functions\n";
  print "**************\n";
  foreach(sort(@newFunctions)) {
    print "$_\n";
  }

  print "**************\n";
  print "adding to templates\n";
  print "**************\n";
  foreach(sort(@templateAdditions)) {
    print "$_\n";
v  }

  print "**************\n";
  print "backfill\n";
  print "**************\n";
  foreach(sort(@backfill)) {
    print "$_\n";
  }

  print "#############\n";
  print "## permission: roles";
  print "#############\n";
  while(($k,$v) = each(%permissionRoleList)) {
#      print "k: [$k] v: [$v]\n";
      print "${k}${v}\n";
  }
}

#end
