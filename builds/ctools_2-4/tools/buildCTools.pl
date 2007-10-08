#!/usr/bin/perl
# $HeadURL:$
# $Id:$


use strict;

my $trace;

## command
# has targets and will run those.
# targets can expand to multiple individual targets.

my %Targets = (
	    all => ["readConfiguration", "getSource", "adjustSource", "compile", "adjustBin", "buildImage", "buildInstances", "package"],
#	    all => ["readConfiguration","getSource"],
);

# use this to turn target name into a call 
#$bar = \&{'foo'};
#    &$bar;

my @buildOrder = ();

print $Targets{all};
@buildOrder =@{$Targets{'all'}};

print "[",join("|",@buildOrder),"]\n";

foreach(@buildOrder) {
  my $T = \&{"$_"};
  print "arg: [$_] target: [$T]\n" if ($trace);
  # Call the target;
  $T->();
}

######## Target routines ########
sub readConfiguration {
  print "readConfiguration called\n";
}

sub getSource {
  print "getSource called\n";
}

# stages 
# create configuration
# get source
# adjust source
#  compile
# adjust bin
# build image
# build instances
# package up artifacts.
#end
