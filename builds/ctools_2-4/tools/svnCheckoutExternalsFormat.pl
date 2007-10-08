#!/usr/bin/perl
# Duplicate externals functionality, but read from a file so that can 
# get all the functionality in the same place.
# Read a file in the svn externals format and check out those files into the current directory.

## TTD
# - make src command settable (checkout or update)

use strict;

my ($trace) = 0;
my (%lines);
my ($module,$revision,$path);
my ($log);
my ($startTime,$endTime);

my ($logFileName) = "./svnCheckout.log";

$startTime = time();

sub getSrcViaExternalsFile {

  while (<>) {
    $lines{TOTAL}++;

    #   next if ($lines{TOTAL} > 2 && $lines{TOTAL} <70); # use for testing to cut down on processing.
    # sample externals file format
    # access -r35024 https://source.sakaiproject.org/svn/access/branches/sakai_2-4-x
    next if (/^\s*#/);
    next if (/^\s*$/);
    ($module,$revision,$path) = m/\s*(\S+)\s+-r(\d+)\s+(.*)\s+/;
    next unless ($module);
  
    # Count the types of modules.
    $lines{USED}++;
    $lines{TRUNK}++ if (m|/trunk/|);
    $lines{CONTRIB}++ if (m|/contrib/|);
    $lines{BRANCH}++ if (m|/branches/|);

    #  $linesUsed++;
    #  $linesTrunk++ if (m|/trunk/|);
    #  $lineContrib++ if (
    print "module: [$module] revision: [$revision] path: [$path]\n" if ($trace);

    my $cmd = checkoutCmd($module,$revision,$path);
    print "cmd: [$cmd]\n";
    my $result = `$cmd`;
    print "result: [$result]\n" if ($trace);
    $log += $result;
  }
}

END {
  $endTime = time();
  my($k,$v);
 #  while(($k,$v) = each(%lines)) {
#  foreach $k (sort(keys(%lines))) {
  foreach $k (sort {$lines{$a} <=> $lines{$b}} keys(%lines)) {
#    print "$k count: ",$lines{$k},"\n";
    printf "%10s %5d\n",$k,$lines{$k};
  }
  printLogFile($logFileName,$log);
  my($elapsedSecs) = $endTime - $startTime;
  print "processed ",$lines{USED}," modules in ",sprintf("%.2f",$elapsedSecs/60)," (mins) ",$elapsedSecs," (secs)";
  print "\n";
}

sub printLogFile{
  my($fileName,$text) = @_;
  open(LOGFILE,">>$fileName") or die("Can't open log file: [$fileName] $!");
  print LOGFILE $text;
  close(LOGFILE) or die("can't close log file $!");
}

sub diffCmd {
  my($key,$rev1,$rev2) = @_;
  print "svn diff -r$rev1:$rev2 $key\n";
}

sub checkoutCmd {
  my($module,$revision,$path) = @_;
  return "svn checkout -r$revision $path $module";
}


getSrcViaExternalsFile();
#end
