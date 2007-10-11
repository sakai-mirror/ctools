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
my ($log) = `date`;
my ($startTime,$endTime);
my ($svncmd) = "checkout";

my ($logFileName) = "./svnCheckout.log";

$startTime = time();

sub getSrcViaExternalsFile {

  while (<>) {
    $lines{TOTAL_LINES}++;

    #   next if ($lines{TOTAL} > 2 && $lines{TOTAL} <70); # use for testing to cut down on processing.
    # sample externals file format
    # access -r35024 https://source.sakaiproject.org/svn/access/branches/sakai_2-4-x
    ## skip lines that don't count
    next if (/^\s*#/);
    next if (/^\s*$/);
    ($module,$revision,$path) = m/\s*(\S+)\s+-r(\d+)\s+(.*)\s+/;
    next unless ($module);
  
    # Count the types of modules being checked out.
    $lines{USED}++;
    $lines{TRUNK}++ if (m|/trunk/|);
    $lines{CONTRIB}++ if (m|/contrib/|);
    $lines{BRANCH}++ if (m|/branches/|);

    print "module: [$module] revision: [$revision] path: [$path]\n" if ($trace);

    my $cmd = makeSvnCmd($module,$revision,$path);
    print "cmd: [$cmd]\n" if ($trace);
    print "$cmd\n";

    # Execute the svn command.
    # Capture the error output along with the standard output
    # This may only work with a *ix type OS.
    my $result = `$cmd 2>&1`;
    my $rc = $?;

    chomp $result;
    print "rc: [$rc] result: [$result]\n" if ($trace);
    $log .= "$cmd result: [$result]\n";
    if ($rc) {
      print "svn cmd [$cmd] failed with rc: [$rc] result: [$result]\n";
      return $rc;
    }
  }
}

END {
  $endTime = time();
  my($k,$v);

  foreach $k (sort {$lines{$a} <=> $lines{$b}} keys(%lines)) {
    printf "%10s %5d\n",$k,$lines{$k};
  }

  
  printLogFile($logFileName,$log);

  my($elapsedSecs) = $endTime - $startTime;
  print "processed ",$lines{USED}," modules in ",sprintf("%.2f",$elapsedSecs/60)," (mins) ",$elapsedSecs," (secs)";
  print "\n";
}

sub printLogFile{
  my($fileName,$text) = @_;
  $text .= `date`;
  open(LOGFILE,">>$fileName") or die("Can't open log file: [$fileName] $!");
  print LOGFILE $text;
  close(LOGFILE) or die("can't close log file $!");
}

sub diffCmd {
  my($key,$rev1,$rev2) = @_;
  print "svn diff -r$rev1:$rev2 $key\n";
}

sub makeSvnCmd {
  my($module,$revision,$path) = @_;
#  return "svn checkout -r$revision $path $module";
  return "svn $svncmd -r$revision $path $module";
}

# can checkout or update.
$svncmd="update";
getSrcViaExternalsFile();

#end
