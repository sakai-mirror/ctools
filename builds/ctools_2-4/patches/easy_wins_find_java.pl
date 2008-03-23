#!/usr/bin/perl
use File::Find;
#use strict; # OK when I have time

# Makes a list of java files
# Then does the easy quick win static bugs
# Tested only on Linux
# Feb 4 2008
# Last modified: March 6th 2008
#
# Contact Alan Berg: a.m.berg@uva.nl

# Can Change
my $src="/home/aberg/apps/sakai_fluth_remover/trunk/src/"; # Source directory
my $DEBUG=0; # If 0 or less then modify source code. If greater than zero then just output to stdout what will be done 

# Internal use only
my @file_list=();
my $global_change=0;

# MAIN
#
unless (-d $src){
    print "Please change \$src variable to point to source directory";
}

find(\&list_java, $src);

my $file;
foreach $file (@file_list){
    my $content="";
    my $flag=0;
    my $line;
    my $line_no=0;
    
    open(TMP,$file)|| die "Unable to open $file";
    
    while($line=<TMP>){
        $line_no++;
        my $temp_line=$line;
        $line=parsed($line);
        $content.=$line;

        unless(length($line)==length($temp_line)){
            print "$file [$line_no]\n";
            print $line;
            print "$temp_line\n";
            $global_change++;
            $flag=1;
        }
    }
    close(TMP);
    
    if (($flag)&&(!($DEBUG))){
        open(TMP,">$file") || return 0;
        print TMP $content;
        close(TMP);
    }
}
print "TOTAL CHANGES: $global_change\n";


# Parse line for specific bug patterns
sub parsed{
my ($line)=@_;
    # Trivial at present or is it?
    $line=~s/new Boolean\(/Boolean.valueOf\(/g;
    $line=~s/new Integer\(/Integer.valueOf\(/g;
    $line=~s/new Byte\(/Byte.valueOf\(/g;
    $line=~s/new Short\(/Short.valueOf\(/g;
    $line=~s/new Long\(/Long.valueOf\(/g;
    $line=~s/new String\(\)/\"\"/g; 
    return $line;
}

# List all Java files
sub list_java{
if ($File::Find::name=~/\.java$/){
  @file_list=(@file_list,$File::Find::name);
}
}
