#!/usr/bin/perl

# Script to test manual builds of ctools
# $HeadURL:
# $Id: 
#http://www.perl.com/doc/FAQs/FAQ/oldfaq-html/Q5.15.html
#http://www.unix.org.ua/orelly/perl/prog3/ch09_04.htm

use File::Basename;
use FindBin qw($Bin);
use Term::ANSIColor qw(:constants);
use POSIX qw(strftime);
#use Properties;

use strict;

#Define which type to build, this might be prompted later
my $typevar = "prod";

$ENV{'JAVA_OPTS'} = "-server -Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=196m -XX:NewSize=192m -XX:MaxNewSize=384m";
$ENV{'MAVEN_OPTS'} = "-Xms256m -Xmx512m";

#This is for Sakai 2.5
#Find the minimum and maximum versions that this will work on
#To add a new required software to this list follow the format, the cmd must return at least
#A major.minor version somewhere in the text as the first number with a decimal.
my %requiredSoftware = (

#This might work with ant 1.5, but that'd be the earliest, give it a try? 
    ant => {
	cmd => "ant -version",
	min =>"1.7",
	max =>"1.7",
    },
    javac => {
	cmd => "javac -J-version",
	min => "1.5",
	max => "1.5",
    },
    mvn => {
	cmd => "mvn -version",
	min => "2.0",
	max => "2.0",
    },
    svn => {
	cmd => "svn --version --quiet",
	min=>"1.4",
	max=>"1.4",
    },
    perl => {
	cmd => "perl --version",
	min=>"5.8",
	max=>"5.8",
    },
    
    patch => {
	cmd => "patch -v",
	min=>"2.5",
	max=>"2.5",
    },

); 

#Check Versions
my ($majorerror,$minorerror) = 0;
my ($required,$result);
my ($minmajor,$minminor,$maxmajor,$maxminor,$resultmajor,$resultminor);
my ($minstatus,$maxstatus);

#Check for required software
for $required ( keys %requiredSoftware) {
    print "Checking program $required: ";
    $result=`$requiredSoftware{$required}{cmd} 2>&1`;
    chop $result;
    ($minmajor,$minminor) = split(/\./,$requiredSoftware{$required}{min});
    ($maxmajor,$maxminor) = split(/\./,$requiredSoftware{$required}{max});
    if ($result) {
        ($resultmajor,$resultminor) = $result =~ m/(\d+)\.(\d+)\.\d+/;
	$minstatus = ($resultmajor >= $minmajor && $resultminor >= $minminor) ? "Ok" : "version installed lower than tested";
	$maxstatus = ($resultmajor <= $maxmajor && $resultminor <= $maxminor) ? "Ok" : "version installed higher than tested";

	if ($minstatus != "Ok" || $maxstatus ne "Ok") {
	    $minorerror = 1;
	}
	
         print "\n  Version detected as: $resultmajor.$resultminor\n";
	 print "  Minimum Version tested: $minmajor.$minminor $minstatus\n";
	 print "  Maximum Version tested: $maxmajor.$maxminor $maxstatus\n";
	
	}
    else {
	print "Not found, please install version $minmajor.$minminor - $maxmajor.$maxminor\n";
	$majorerror=1;
    } 
}

if ($majorerror) {
    print "Please install the necessary programs before continuing!\n";
    exit();
}

if ($minorerror) {
    print "The software was not tested with this version, you can continue but may have errors.\n";
}

my ($svninfo,$svnversion,$svnvar);
$svninfo = `svn info`;
if ($svninfo) {
    ($svnversion) = $svninfo =~ m/Revision: (\d*)/;
}

if ($svnversion) {
    print "Building revision: $svnversion\n";
    $svnvar = "-DCANDIDATE.revision=$svnversion";
}

print "Searching for valid build files!\n";
#Look for a list of builds in the config directory
my @builds = `find configs -name "defaultbuild.properties" | sort`;
if (!@builds) {
     #Look for a list of builds in the current directory
     @builds = `find . -name "defaultbuild.properties" | sort`;
}

print "Detected ".@builds." candidate(s) (You can create a new candidate by cp -r one of the configs in the configs directory and editing the sakai.tag property to match this new name.):\n";
my ($buildcount,$build)=0;
foreach $build (@builds) {
    my ($configs,$dirname,$file) = split(/\//,$build);
    print WHITE,"$buildcount ", RESET, "$dirname\n";
    $buildcount++;
}

#Get the build directory input from the user
my ($buildin,$cleanin, $builddir);
do
{
    print "Enter a number to build (Ctrl-C to abort):";	# Ask for input
    $buildin = <STDIN>;	# Get input
    chop $buildin;	    # Chop off newline
}
until ($builddir = dirname($builds[$buildin]));	    # Redo while wrong input

#Find out other options like if they want to clean out the build, or just update whats there
#ETC!

print "NOTE: The resulting packages will be placed in $Bin/artifacts/$builddir\n";

#Prompt if they want a clean install, parts of this are still being worked on in the scripts.
do
{
    print "Do you want to do a clean install? (First time will always be clean) [y/n]";	# Ask for input
    $cleanin = <STDIN>;	# Get input
    chop $cleanin;	    # Chop off newline
}
until ($cleanin eq "n" || $cleanin eq "y");	    # Redo while wrong input

#Get a log file started for further analysis
my $nowstring = strftime "%m-%d-%y_%H-%M-%S", localtime;
mkdir("./logs");
open(STDOUT, "| tee ./logs/outputlog.$nowstring.log");

my $cleanvar;
#Command to start it up!
if ($cleanin eq "n") {
    $cleanvar = "-Dnoclean=noclean";
}
else {
    $cleanvar = "-Dclean=clean";
}

#Change directory to the builds directory
chdir($builddir);
my $cmd = "ant -s build.xml -Dtype=$typevar $cleanvar $svnvar 2>&1";
system $cmd; 
close(STDOUT);

0;

END { print RESET; }
