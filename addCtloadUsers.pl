#!/usr/bin/perl -w
#
# $HeadURL$
# $Id$
#
#
# This code was adapted from a script provided by Seth Theriault form Columbia.
#
# Copyright (c) 2005 The Trustees of Columbia University in the City of New York
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
#
#   SakaiScript.jws example code
#
#   Seth Theriault <slt@columbia.edu>
#   Academic Information Systems, Columbia University
#
#use SOAP::Lite +trace => all;
use SOAP::Lite;

use Config::Properties;

#   # reading...

#   open PROPS, "< my_config.props"
#     or die "unable to open configuration file";

#   my $properties = new Config::Properties();
#   $properties->load(*PROPS);

#   $value = $properties->getProperty( $key );


#   # saving...

#   open PROPS, "> my_config.props"
#     or die "unable to open configuration file for writing";

#   $properties->setProperty( $key, $value );

#   $properties->format( '%s => %s' );
#   $properties->store(*PROPS, $header );

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

my $lineCnt;

our ($form1_lower,$form1_upper,$form2_lower,$form2_upper);

# our @test = (
# 	     "AAbobZB acorn",	
#      "AAblueZB justcorn",
# 	     "AAblueZAB justcorn"
# 	    );

sub generateCtloadUsersForm1 {
  my($start,$end) = @_;
  my($user,$pw);

  $start = 1 unless defined($start);
  $end = 1000 unless defined($end);

  startSakaiSession();
  getSoapConnection();

  for ($start .. $end) {
    ($user,$pw)  = (sprintf("user%04i",$_),sprintf("user%04i",$_));
    print "u: $user pw: $pw - ";
    createUser($user,$pw);
  }
}

sub generateCtloadUsersForm2 {
  my($start,$end) = @_;
  my($user,$pw);

  $start = 1 unless defined($start);
  $end = 1000 unless defined($end);

  startSakaiSession();
  getSoapConnection();

  for ($start .. $end) {
    ($user,$pw)  = (sprintf("u%05i",$_),sprintf("U%05i",$_));
    print "u: $user pw: $pw - ";
    createUser($user,$pw);
  }
}

sub readProperties {
 #   open PROPS, "< my_config.props"
 #     or die "unable to open configuration file";


 #   my $properties = new Config::Properties();
 #   $properties->load(*PROPS);
 #   $value = $properties->getProperty( $key );

 
  open PROPS, "<$configFileName"
    or die("can't open configuration file: $configFileName $!");

  $properties = new Config::Properties();
  $properties->load(*PROPS);
  my $value = $properties->getProperty("user");
   print "value: $value\n";

}

sub setupCtload {

  readProperties();

   setUser($properties->getProperty("user"));
   setPassword($properties->getProperty("password"));

   setLoginURI($properties->getProperty("loginURI"));
   setProxyURI($properties->getProperty("proxyURI"));
   setScriptURI($properties->getProperty("scriptURI"));
#   setProxyURI( "https://ctoolsload.ds.itd.umich.edu/sakai-axis/SakaiLogin.jws?wsdl");
#   setScriptURI("https://ctoolsload.ds.itd.umich.edu/sakai-axis/SakaiScript.jws?wsdl");

#   setUser("admin");
#   setPassword("r0ck3tman");

#   setLoginURI( "https://ctoolsload.ds.itd.umich.edu/sakai-axis/SakaiLogin.jws?wsdl");
#   setProxyURI( "https://ctoolsload.ds.itd.umich.edu/sakai-axis/SakaiLogin.jws?wsdl");
#   setScriptURI("https://ctoolsload.ds.itd.umich.edu/sakai-axis/SakaiScript.jws?wsdl");

}


sub main {
  setupCtload();
#  generateCtloadUsersForm1(1,1000);
#  generateCtloadUsersForm2(1,60000);

#  generateCtloadUsersForm1(11,1000);
#  generateCtloadUsersForm2(6,10);


#  exit;
  my($lower,$upper) = ($properties->getProperty("form1_lower"),$properties->getProperty("form1_upper"));
  print "form1_lower: ",$lower, "form1_upper: ",$upper,"\n"
    unless ($lower > $upper);

  generateCtloadUsersForm1($lower,$upper)
    unless ($lower > $upper);
  ($lower,$upper) = ($properties->getProperty("form2_lower"),$properties->getProperty("form2_upper"));
#  generateCtloadUsersForm2($properties->getProperty("form2_lower"),$properties->getProperty("form2_upper"))
  generateCtloadUsersForm2($lower,$upper)
    unless ($lower > $upper);


#  generateCtloadUsersForm2(11,19);
#  generateCtloadUsersForm2(99,9999);
#  generateCtloadUsersForm2(2900,9999);
#  generateCtloadUsersForm2(8600,9000);
#  generateCtloadUsersForm2(20000,25000);

#  generateCtloadUsersForm2(30000,30001);
#  generateCtloadUsersForm2(10000,60000);

  printSummary();
}

#######

main();
print "\n";
