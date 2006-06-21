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
use SOAP::Lite;

use strict;

use addSakaiUsers;

my $trace = 0;

# Variables to configure
#my $session = "";
#my $newuser ="testu7";		# name of user to be created
#my $usertodelete = "";		# name of user to be deleted	
#my $newsiteid ="genchem1";   # unique string to identify site (siteid)
#my $newpagename = "testpage";	# title of new page
#my $deletesiteid = "";		# siteid of site to be deleted

#my $soap2;			# hold soap connection to sakai

#my $true = SOAP::Data->value('true')->type('boolean');
#my $false = SOAP::Data->value('')->type('boolean');

# Change these variables as appropriate
#my $loginURI = "http://localhost:8080/sakai-axis/SakaiLogin.jws?wsdl";
#my $scriptURI = "http://localhost:8080/sakai-axis/SakaiScript.jws?wsdl";

# Sakai admin user's credentials
my $user = "admin";
my $password = "admin";

my $soap;

my $lineCnt;

### If there is nothing to do, exit.


### Start a Sakai session

# sub startSakaiSession {

#   print "Starting a Sakai session...\n";

#   print "Sakai session id (after login) -> ";
#   $soap = SOAP::Lite
#     -> proxy($loginURI)
#       -> uri($loginURI)
# 	;

#   $session = $soap->login($user,$password)->result;

#   print "$session\n";

# }

### Connect and futz

# sub getSoapConnection {

#   $soap2 = SOAP::Lite
#     -> proxy($scriptURI)
#       -> uri($scriptURI)
# 	;
# }
### Create a user (no session required)
###
### addNewUser( String sessionid, String userid, String firstname, String lastname, String email, String type, String password)

# my ($userCnt,$sakaiErrorCnt,$soapErrorCnt,$lineCnt,$tries) = (0,0,0,0,0);

# sub createUser {
#   my($newuser,$p) = @_;
#   my $result;
#   if ($newuser) {
#     $tries++;
#     print "line: $.: Creating user \"$newuser\" --> ";
#     # print "s: $session\n";
#     $result = $soap2->addNewUser(
# 				 $session,
# 				 $newuser,
# 				 "Test",
# 				 "User",
# 				 "$newuser\@somewhere.edu",
# 				 "registered",
# 				 $p);
#     #    print "r: $result\n";
#     print $result->result,"\n";
# #    print "fault: ",$result->fault,"\n";
#     if ($result->fault) {
# #      print "line: $.: user: [$newuser] ";
#       print join(", ",$result->faultcode,$result->faultstring);
#       print "\n";
#       $soapErrorCnt++;
#     } elsif ($result->result =~ /exception/i) {
#  #     print "line: $.: user: [$newuser] : sakai exception";

#       $sakaiErrorCnt++;
#     } else {
#       $userCnt++;
#     }
#   }
# #  print "\n";
# }

our @test = (
	     "AAbobZB acorn",
	     "AAblueZB justcorn",
	     "AAblueZAB justcorn"
	    );

sub testAdd {
  my($u);
  my($user,$pw);
  startSakaiSession();
  getSoapConnection();

  foreach $u (@test) {
    ($user,$pw) = $u =~ m/(.*)\s+(.*)/;
    print "u: $user p: $pw\n" if ($trace);
    createUser($user,$pw);
  }
}

# read in user / pw from file and then add to the 
sub readFromStdIn {
  my($user,$pw);
#  print "call readFromStdIn\n";
  startSakaiSession();
  getSoapConnection();

  while (<>) {
    next if (/^\s*$./);
    chomp;
    $lineCnt++;
#    print "line: $.: [$_]\n";
    ($user,$pw) = m/(\w*)\s+(\w*)/;
#    print "user: [$user] pw: [$pw]\n";
    createUser($user,$pw);
  }
  
}

# sub printSummary {
#   print "\n";
#   print "lines: $lineCnt add attempts: $tries added: $userCnt soap errors: $soapErrorCnt sakai errors: $sakaiErrorCnt\n";
# }

sub main {
  testAdd();
#  readFromStdIn();
  printSummary();
}

#######

main();
print "\n";
