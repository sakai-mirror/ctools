#!/usr/bin/perl -n 
$trace = 0;
print "line: $_" if ($trace);
chomp;

# Merge realm changes.
if (m|^(\S+)\s+(\S+)\s+(\S+)\s*$|) {
  ($realm,$role,$function) = ($1,$2,$3);

  if ($function =~ m|([^.]+)\.|) {
    $function_prefix = ".".$1;
    # print "function_prefix: [$function_prefix]\n";
  }

  print "rrf: $realm:$role:$function\n" if ($trace);
  $key = $realm." ".$role.$function_prefix;
  $RealmRoleFunction{$key} .= " $function";
  print "key: [$key] value: [",$RealmRoleFunction{$key},"]\n" if($trace);
}

# Merge backfill changes
if (m|^(\S+)\s+(\S+)\s*$|) {
  ($role,$function) = ($1,$2);
  print "rf: $role:$function\n" if ($trace);

#  print "function: [$function]\n";
  if ($function =~ m|([^.]+)\.|) {
    $function_prefix = ".".$1;
    print "function_prefix: [$function_prefix]\n" if ($trace);
  }

  $key = $role.$function_prefix;
  $RoleFunction{$key} .= " $function";
  print "key: [$key] value: [",$RoleFunction{$key},"]\n" if ($trace);
}

END {

  printRealmRoleFunctionTuple();
#   foreach(sort(keys(%RealmRoleFunction))) {
#     print "key: [$_] value: [",$RealmRoleFunction{$_},"]\n" if ($trace);
#     ($print_role) = ($_ =~ m|(.*)\.[^.]+$|);
# #    print "add_to_realm ",$_,$RealmRoleFunction{$_},"\n";
#     print "add_to_realm ",$print_role,$RealmRoleFunction{$_},"\n";
#   }

  printBackfill();

#   foreach(sort(keys(%RoleFunction))) {
#     print "key: [$_] value: [",$RoleFunction{$_},"]\n" if ($trace);
#     ($print_role) = ($_ =~ m|(.*)\.[^.]+$|);
# #    print "backfill ",$_,$RoleFunction{$_},"\n";
#     print "backfill ",$print_role,$RoleFunction{$_},"\n";
#   }
}

sub printRealmRoleFunctionTuple {
  foreach(sort(keys(%RealmRoleFunction))) {
    print "key: [$_] value: [",$RealmRoleFunction{$_},"]\n" if ($trace);
    ($print_role) = ($_ =~ m|(.*)\.[^.]+$|);
#    print "add_to_realm ",$_,$RealmRoleFunction{$_},"\n";
    print "add_to_realm ",$print_role,$RealmRoleFunction{$_},"\n";
  }
}

sub printBackfill {
   foreach(sort(keys(%RoleFunction))) {
     print "key: [$_] value: [",$RoleFunction{$_},"]\n" if ($trace);
     ($print_role) = ($_ =~ m|(.*)\.[^.]+$|);
 #    print "backfill ",$_,$RoleFunction{$_},"\n";
     print "backfill ",$print_role,$RoleFunction{$_},"\n";
   }
}

#end
