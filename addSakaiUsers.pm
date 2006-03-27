#!/usr/bin/perl -w
#
# $HeadURL$
# $Id$
#
#
# This code was adapted from a script provided by Seth Theriault form Columbia.
#
#  Module to supply ability to add users to Sakai via webservices.
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

use SOAP::Lite;

#use Crypt::SSLeay;
#use SOAP::Lite +trace => qw(debug);

use strict;

# Variables to configure
my $session = "";
my $newuser ="testu7";		# name of user to be created
my $usertodelete = "";		# name of user to be deleted	
my $newsiteid ="genchem1";   # unique string to identify site (siteid)
my $newpagename = "testpage";	# title of new page
my $deletesiteid = "";		# siteid of site to be deleted

my $soap2;			# hold soap connection to sakai

my $true;
my $false;

#my $true = SOAP::Data->value('true')->type('boolean');
#my $false = SOAP::Data->value('')->type('boolean');

# Default values.
my $loginURI = "http://localhost:8080/sakai-axis/SakaiLogin.jws?wsdl";
my $scriptURI = "http://localhost:8080/sakai-axis/SakaiScript.jws?wsdl";
my $proxyURI;

# Sakai admin user's credentials
my $user = "admin";
my $password = "admin";

my $soap;
my $trace;

### If there is nothing to do, exit.


sub setUser {
  $user = shift;
}

sub setPassword {
  $password=shift;
}

sub setLoginURI {
  $loginURI = shift;
}

sub setProxyURI {
  $proxyURI = shift;
}

sub setScriptURI {
  $scriptURI = shift;
}

sub setTrace {
  $trace = shift;
}

#######################################################

sub setupSOAP {

 $true = SOAP::Data->value('true')->type('boolean');
 $false = SOAP::Data->value('')->type('boolean');

}

### Start a Sakai session

sub startSakaiSession {

  $proxyURI = $loginURI unless(defined($proxyURI));

  print "loginURI: $loginURI\n" if ($trace);
  print "proxyURI: $proxyURI\n" if ($trace);

#  $soap = SOAP::Lite
##    -> proxy($loginURI)
#    -> proxy($proxyURI)
#      -> uri($loginURI)
#	;

# should it be uri->proxy?
  $soap = SOAP::Lite
    -> uri($loginURI)
      -> proxy($proxyURI)
	;

  unless ($soap) {
    die "can't open loginURI: $loginURI proxyURI: $proxyURI\n";
  }

  print "Starting a Sakai session...\n";
  print "Sakai session id (after login) -> ";
  print "soap: $soap\n";

#  print "soap fault\n" if ($soap->fault);

  $session = $soap->login($user,$password)->result;
  unless ($session){
    die("no session");
  }

  print "$session\n";

}

sub getSoapConnection {

  print "scriptURI: $scriptURI\n";
  $soap2 = SOAP::Lite
    -> proxy($scriptURI)
      -> uri($scriptURI)
	;

  unless ($soap2) {
    die "can't open scriptURI: $scriptURI\n";
  }

}
### Create a user (no session required)
###
### addNewUser( String sessionid, String userid, String firstname, String lastname, String email, String type, String password)

#my ($userCnt,$sakaiErrorCnt,$soapErrorCnt,$lineCnt,$tries) = (0,0,0,0,0);
my ($userCnt,$sakaiErrorCnt,$soapErrorCnt,$tries) = (0,0,0,0);

our $userType = "uniqname";
#our $userType = "";

sub createUser {
  # create a new user.
  my($newuser,$p) = @_;
  my $result;
  if ($newuser) {
    print "adding: $newuser " if ($trace);
    $tries++;
    $result = $soap2->addNewUser(
				 $session,
				 $newuser,
				 "",
				 "",
#				 "Test",
#				 "User",
				 "$newuser\@somewhere.edu",
				 $userType,
#				 "registered",
				 $p);
    print $result->result,"\n";
    if ($result->fault) {
      print join(", ",$result->faultcode,$result->faultstring);
      print "\n";
      $soapErrorCnt++;
    } elsif ($result->result =~ /exception/i) {
      $sakaiErrorCnt++;
    } else {
      $userCnt++;
    }
  }
}


sub printSummary {
  print "\n";
#  print "lines: $lineCnt add attempts: $tries added: $userCnt soap errors: $soapErrorCnt sakai errors: $sakaiErrorCnt\n";
  print "add attempts: $tries added: $userCnt soap errors: $soapErrorCnt sakai errors: $sakaiErrorCnt\n";
}

1;
