#!/usr/bin/perl

#http://www.perl.com/doc/FAQs/FAQ/oldfaq-html/Q5.15.html
#http://www.unix.org.ua/orelly/perl/prog3/ch09_04.htm

use File::Basename;
use Term::ANSIColor qw(:constants);

$ENV{'JAVA_OPTS'} = "-server -Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=196m -XX:NewSize=192m -XX:MaxNewSize=384m";
$ENV{'MAVEN_OPTS'} = "-Xms256m -Xmx512m";

#This is for Sakai 2.5
#Find the minimum and maximum versions that this will work on
#To add a new required software to this list follow the format, the cmd must return at least
#An major.minor version somewhere in the text as the first number with a decimal.
%requiredSoftware = (

#This might work with ant 1.5, but that'd be the earliest, give it a try? 
    ant => {
	cmd => "ant -version",
	min =>"1.5",
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
$majorerror=0;
$minorerror=0;
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

@builds = `find configs -name "defaultbuild.properties" | sort`;

print "Detected ".@builds." candidates:\n";
$i=0;
foreach $build (@builds) {
    ($configs,$dirname,$file) = split(/\//,$build);
    print WHITE,"$i ", RESET, "$dirname\n";
    $i++;
}

do
{
    print "Enter a number to build (Ctrl-C to abort):";	# Ask for input
    $buildno = <STDIN>;	# Get input
    chop $buildno;	    # Chop off newline
}
while ($buildno > @builds-1);	    # Redo while wrong input

#Find out other options like if they want to clean out the build, or just update whats there
#ETC!

do
{
    print "Do you want to do a clean install? (First time will always be clean) [y/n]";	# Ask for input
    $clean = <STDIN>;	# Get input
    chop $clean;	    # Chop off newline
}
until ($clean eq "n" || $clean eq "y");	    # Redo while wrong input


#Change directory to this one
chdir(dirname($builds[$buildno]));
#Command to start it up!
if ($clean eq "n") {
    $cleanvar = "-Dnoclean=active";
}

$typevar = "prod";

$cmd = "ant -f ../../build.xml -Dtype=$typevar $cleanvar";
system $cmd; 

END { print RESET; }

#IT PUTS THE GZIP in the artifacts directory.
