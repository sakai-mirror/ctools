#!/usr/bin/env perl -n
print "// groovy script from template on ".`date`;
while(<>) {
  $includeFile = undef();
  chomp;
#  print "l: [$_]\n";
  $line = $_;
#  print "line: [$line]\n";
  if ($line =~ m/^\s*include:\s*(.+)/) {
#    print "found match\n";
    $includeFile = $1;
  }
#  print "1: [$1]\n";
#  print "if: [$includeFile]\n";
  includeFile($includeFile) if ($includeFile);
  print "*** $_\n"  unless ($includeFile);
}

sub includeFile{
  my($fileName) = shift;
  print "** include file: [$fileName]\n";
  open(FH, "< $fileName") or die("$fileName: $!");
  while(<FH>) {
    print;
  }
}
# end
