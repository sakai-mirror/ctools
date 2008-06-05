#!/usr/bin/perl

# Run this with file in svn externals format 
# <PATH> <REVISION> <SVN LOCATION> <JUNK> 
# And it will update everything to the last committed revision

# use module
use XML::Simple;
use Data::Dumper;
use IO::File;

if (@ARGV == 0) {
    print "Usage: $0 <externals file>>\n";
    print "Example: $0 somefile.externals\n";
    exit;
}
# create object
$xml = new XML::Simple;

$fh = new IO::File();
if (-f $ARGV[0]) {
    $fh->open($ARGV[0],"r") or die "unable to find file: $!\n";
    eval {
	@externalsfile = <$fh>;
    };  
    if ($@) {
	    die $@; 
    }   
}
$fh->close();

#print Dumper(@externalsfile);

# read XML file
foreach $line (@externalsfile) {

    ($start,$name,$revision,$svnpath,$end) = $line =~ m/(\W*?)([\w-]*)\s+-r(\w+)\s+(.*?\s+)(.*)$/;
     if ($svnpath && $start !~ m/#/) {
        $info = `svn info --xml $svnpath`;
        $data = $xml->XMLin($info);
#	print Dumper($data);
	$output = sprintf '%s%-20.20s-r%-10s%s%s',$start,$name,$data->{entry}->{commit}->{revision},$svnpath,$end;
	print $output;
	if ($output !~ m/\n/) {
	    print "\n";
	}
     }
}
