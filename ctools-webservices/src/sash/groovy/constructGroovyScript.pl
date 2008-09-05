#!/usr/bin/env perl 
# $HeadURL$
# $Id$

#$verbose = 1;

print "// groovy script from template on ".`date`;
while(<>) {
  $includeFile = undef();
  print "line: [$_]" if ($verbose);
  chomp;
  $line = $_;
  if ($line =~ m/^\s*include:\s*([^;]+);?/) {
    $includeFile = $1;
  }
  includeFile($includeFile) if ($includeFile);
  print "$_\n"  unless ($includeFile);
}

sub includeFile{
  my($fileName) = shift;
  # print "** include file: [$fileName]\n";
  print "// ******** include file: [$fileName]\n";
  open(FH, "< $fileName") or die("$fileName: $!");
  while(<FH>) {
    print;
  }
  print "// ******** end of included file: [$fileName]\n";
}
# end
