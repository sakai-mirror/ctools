#!/usr/bin/perl -w
#
# $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/builds/ctools_2-3/tools/load/addCtloadUsers.pl $
# $Id: addCtloadUsers.pl 14101 2006-08-29 19:26:20Z dlhaines@umich.edu $
#
##############################
# This code was adapted and generalized from a script provided by Seth Theriault from Columbia.
# Changes by David Haines (University of Michigan).
#######
#
#   SakaiScript.jws example code
#
#   Seth Theriault <slt@columbia.edu>
#   Academic Information Systems, Columbia University
#

##############################
#
# Copyright (c) 2005 The Trustees of Columbia University in the City of New York.
# Copyright (c) 2005 The Trustees of the University of Michigan, Ann Arbor.
# 
# Licensed under the Educational Community License Version 1.0.
#
# By obtaining, using and/or copying this Original Work, you agree that
# you have read, understand, and will comply with the terms and conditions 
# of the Educational Community License (the "License").
#
# You may obtain a copy of the License at:
# 
#      http://www.opensource.org/licenses/ecl1.php
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
# DEALINGS IN THE SOFTWARE.
#

#######
## TTD ##
# Could make anonymous function and pass that in to do the actual formating.  Then
# there could be less duplication.


# You can learn a lot if it doesn't work and you turn on tracing.
#use SOAP::Lite +trace => all;
use SOAP::Lite;
use Config::Properties;
use strict;
use addSakaiUsers;

my $trace = 0;

# hold object for reading properties from file.
our $configFileName = "addUsers.properties";
our $properties;

# Default Sakai admin user's credentials
my $user = "admin";
my $password = "admin";

my $soap;

## for the two ways to create user names for UofM load testings.
#our ($form1_lower,$form1_upper,$form2_lower,$form2_upper);

# our @test = (
# 	     "AAbobZB acorn",	
#      "AAblueZB justcorn",
# 	     "AAblueZAB justcorn"
# 	    );


sub readProperties {

  # Use the Config::Properties module so that can store the values
  # that are likely to vary from run to run in a separate file.
  open PROPS, "<$configFileName"
    or die("can't open configuration file: $configFileName $!");

  $properties = new Config::Properties();
  $properties->load(*PROPS);
 
  # to read a named value use this:
  #  my $value = $properties->getProperty("user");

}

sub setupCtload {

  readProperties();

  setUser($properties->getProperty("user"));
  setPassword($properties->getProperty("password"));

  setLoginURI($properties->getProperty("loginURI"));
  setProxyURI($properties->getProperty("proxyURI"));
  setScriptURI($properties->getProperty("scriptURI"));

}


sub readUserPw () {
  
}

# run the two forms of user name generation and provide limits for the generation 
# based on properties.
sub main {

  my($user,$pw);
  my($u);
  setupCtload();

  startSakaiSession();
  getSoapConnection();


#  my($lower,$upper) = ($properties->getProperty("form1_lower"),$properties->getProperty("form1_upper"));
#  print "form1_lower: ",$lower, "form1_upper: ",$upper,"\n"
#    unless ($lower > $upper);

  while(<>) { 	
    $u = $_;
    ($user,$pw) = $u =~ m/(.+)\s+(.+)/;
    print "user: [$user] pw: [$pw]\n";
    changeUserPassword($user,$pw);
  }


  printSummary();
}

#######

main();
print "\n";
