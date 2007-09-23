#!/usr/bin/perl -w
# Utilites to do common web services tasks.
#
### TTD:
# - logout doesn't work except for admin?
#
# $HeadURL:https://source.sakaiproject.org/svn/ctools/trunk/ctools-ws-client/src/perl/sakaiSoapUtil.pm $
# $Id:sakaiSoapUtil.pm 35684 2007-09-22 19:40:53Z dlhaines@umich.edu $
# Based on version provided by Seth Theriault at Columbia University.
#######
# Utility module for Sakai web services.
# Based on:
# 
#   bulk-user.pl -- add/delete users to Sakai from a .csv file
#
#   Seth Theriault <slt@columbia.edu>
#   Information Technology, Columbia University
#
# Copyright (c) 2005 The Trustees of Columbia University in the City of New York
# 
# Licensed under the Educational Community License Version 1.0.
#
# By obtaining, using and/or copying this Original Work, you agree that
# you have read, understand, and will comply with the terms and
# conditions of the Educational Community License (the "License").
#
# You may obtain a copy of the License at:
# 
#      http://www.opensource.org/licenses/ecl1.php
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

use SOAP::Lite;

use strict;

# set up some variables

my ($trace,$oldTrace) = (0,0);

my $true = SOAP::Data->value('true')->type('boolean');
my $false = SOAP::Data->value('')->type('boolean');

# Variables to configure
my $loginURI = "http://SAKAISERVER/sakai-axis/SakaiLogin.jws?wsdl";
my $scriptURI = "http://SAKAISERVER/sakai-axis/SakaiScript.jws?wsdl";

sub setTrace {
  $oldTrace = $trace;
  $trace = shift;
  return $oldTrace;
}

sub establishSakaiSession {
	# start a session, reuse established one if it exists.
	my($loginURI,$session,$user,$pw) = @_;

	return $session if ($session);

	### Start a Sakai session
	
	if ($trace) {
	  print "No Sakai session found. Starting one...\n";
	  print "Sakai session id (after login) -> ";
	}

	my $soap = connectToSakaiWebService($loginURI);
	$session = $soap->login($user,$pw)->result;
	
	print "$session\n" if ($trace);

	return $session;
}

sub endSakaiSession {
  # logout of an existing sakai session.

  my($logInOutWSURI,$session) = @_;
  print "logging out of session [$session]\n" if ($trace);

  my $soap = connectToSakaiWebService($logInOutWSURI);
  my $result = $soap->logout($session)->result;
  print "logout result is: [$result]\n" if ($trace);

}

sub connectToSakaiWebService {
  my($sakaiWSURI) = @_;
  ### Connect and futz
  
  print "sSU: trying web service: [$sakaiWSURI]\n" if ($trace);
  my $soap2 = SOAP::Lite
    -> proxy($sakaiWSURI)
      -> uri($sakaiWSURI)
	;
  print "sSU: return value from SOAP::Lite: [$soap2] result: [",$soap2->result,"]\n" if ($trace);
  return $soap2;
}

 ## example of creating a user.
 #		print $soap2->addNewUser($session, $usertoadd,$first,$last,$mail,"registered",$newpass)->result . "\n" ;
	

