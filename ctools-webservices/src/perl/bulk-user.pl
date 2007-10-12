#!/usr/bin/perl -w
#
# Archived from copy provided by Seth Theriault at Columbia University.

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
#######
#
#   bulk-user.pl -- add/delete users to Sakai from a .csv file
#
#   Seth Theriault <slt@columbia.edu>
#   Information Technology, Columbia University
#
use SOAP::Lite;

use strict;

# set up some variables
my $session = "";
my $usertoadd ="";		# name of user to be created
my $usertodelete = "";		# name of user to be deleted	

my $true = SOAP::Data->value('true')->type('boolean');
my $false = SOAP::Data->value('')->type('boolean');

# Variables to configure
my $loginURI = "http://SAKAISERVER/sakai-axis/SakaiLogin.jws?wsdl";
my $scriptURI = "http://SAKAISERVER/sakai-axis/SakaiScript.jws?wsdl";

my $adminuser = "ADMINUSER";
my $adminpw = "ADMINPW";

my $csvfile="FILE";

# generate radmon password -- see below
sub generate_random_string
{
  my $stringsize = shift;
  my @alphanumeric = ('a'..'z', 'A'..'Z', 0..9);
  my $randstring = join '', (map { $alphanumeric[rand @alphanumeric] } @alphanumeric)[0 .. $stringsize];
  return $randstring;
}

open(CSVFILE, $csvfile) || die("bulk-user-public failed: $!");
while( <CSVFILE> ) {
        
   if ( /^[a-z0-9]+/ ) {
	chomp;
	my ($username,$first,$last,$mail) = (split(/,/, $_))[0,1,2,3];

	# Choose to add or delete
	$usertoadd = $username;
	#$usertodelete = $username;

	### Start a Sakai session

	if (!$session) {

		print "No Sakai session found. Starting one...\n";

		print "Sakai session id (after login) -> ";
		my $soap = SOAP::Lite
		    -> proxy($loginURI)
		    -> uri($loginURI)
		;

		$session = $soap->login($adminuser,$adminpw)->result;

	} else {
		print "Sakai session id (after login) -> ";
	}
	print "$session\n";


	### Connect and futz

	my $soap2 = SOAP::Lite
	    -> proxy($scriptURI)
	    -> uri($scriptURI)
	;


	### Create a user (no session required)
	###
	### addNewUser( String sessionid, String userid, String firstname, String lastname, String email, String type, String password)

	if ($usertoadd) {
		# Pick on the following to generate a password
		#my $newpass = "password";
		my $newpass = generate_random_string(8);
		print "UNI --> $username\nFirst --> $first\nLast --> $last\nE-mail --> $mail\n";
		print "Password: $newpass\n";
		print "Trying to create user \"$usertoadd\" --> ";
		#print $soap2->addNewUser($session, $usertoadd,"Test","User","$usertoadd\@somewhere.edu","registered","password")->result . "\n" ;
		print $soap2->addNewUser($session, $usertoadd,$first,$last,$mail,"registered",$newpass)->result . "\n" ;
	} else { print "\nNo user to create.\n"; }

	### Delete a user (session required)
	###
	### removeUser( String sessionid, String userid)

	if ($usertodelete) {
		print "\nDeleting user \"$usertodelete\" --> ";
		print $soap2->removeUser($session, $usertodelete)->result . "\n" ;
	} else { print "\nNo user to delete.\n"; }

	print "--------------\n";

   }
}
close(CSVFILE);
exit 0;
