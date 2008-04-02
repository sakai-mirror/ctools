#!/usr/bin/perl
# Duplicate externals functionality, but read from a file so that can 
# get all the functionality in the same place.
# Read a file in the svn externals format and check out those files into the current directory.

# Will get just the control files, not externals from the sakai release directory
#svn co --ignore-externals https://source.sakaiproject.org/svn/sakai/branches/sakai_2-4-x .

## TTD
# - documentation
use strict;

my ($trace) = 0;
my (%lines);
my ($module,$revision,$path,$svnOptions);
my ($log) = `date`;
my ($startTime,$endTime);
my ($svncmd) = "checkout";
my ($destinationDir);

my ($logFileName) = "./svnCheckout.log";

$startTime = time();

  print "$0: args: ",join("|",@ARGV),"\n" if ($trace);

# arguments must occur in this order.

if (@ARGV > 0) {
  $destinationDir = shift;
}

if (@ARGV > 0) {
  $logFileName = shift;
}

if (@ARGV > 0) {
  $svncmd = shift;
}

print "logFileName: [$logFileName]  svncmd: [$svncmd]\n" if ($trace);

# Have a place to assign the unneeded contents of the RE group
# required for grouping the optional svnOptions.

my $dummy;
sub getSrcViaExternalsFile {

  while (<>) {
    chomp;
    $svnOptions = "";
    $lines{TOTAL_LINES}++;

    # print "line: [$_]\n";
    #   next if ($lines{TOTAL} > 2 && $lines{TOTAL} <70); # use for testing to cut down on processing.
    # sample externals file format
    # access -r35024 https://source.sakaiproject.org/svn/access/branches/sakai_2-4-x
    ## skip lines that don't count
    next if (/^\s*#/);
    next if (/^\s*$/);

    ($module,$revision,$path,$dummy,$svnOptions) = m/\s*(\S+)\s+-r(\d+)\s+([^|]*)\s*(\|\s*(.+))*$/;
    next unless ($module);
  
    # Count the types of modules being checked out.
    $lines{USED}++;
    $lines{TRUNK}++ if (m|/trunk/|);
    $lines{CONTRIB}++ if (m|/contrib/|);
    $lines{BRANCH}++ if (m|/branches/|);

    print "module: [$module] revision: [$revision] path: [$path] svnOptions: [$svnOptions]\n" if ($trace);

    my $cmd = makeSvnCmd($module,$revision,$path,$svnOptions);

    print "$cmd\n";

    # Execute the svn command.
    # Capture the error output along with the standard output
    # This may only work with a *ix type OS.
    my $result = `$cmd 2>&1`;
    my $rc = $?;

    chomp $result;
    print "rc: [$rc] result: [$result]\n" if ($trace);
    $log .= "$cmd result: \n[$result]\n";
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
  print "USING LOGFILE: [$fileName]\n";
  open(LOGFILE,">>$fileName") or die("Can't open log file: [$fileName] $!");
  print LOGFILE $text;
  close(LOGFILE) or die("can't close log file $!");
}

sub diffCmd {
  my($key,$rev1,$rev2) = @_;
  print "svn diff -r$rev1:$rev2 $key\n";
}

sub makeSvnCmd {
  my($module,$revision,$path,$svnOptions) = @_;
#  return "svn checkout -r$revision $path $module";
  return "svn $svncmd $svnOptions -r$revision $path $module";
}

# can checkout or update.
# Note that update won't catch top level modules that have been deleted.
#$svncmd="update";
#$svncmd="checkout";
chdir $destinationDir;

getSrcViaExternalsFile() if (@ARGV);

1;
#end
