#!/usr/bin/perl
# $HeadURL:$
# $Id:$

use sakaiSoapUtil;
use strict;

# Variables to configure

my $sakaiSession = "";

# start a sakai session
# connect to the web service
# do something.
# logout;

my $trace = 1;

sub runTest { 

	my($testHost,$user,$pw) = @_;

	my($sakaiSession,$connection,$foundUser);

	if ($trace) {
	  print "testHost: [$testHost] user: [$user] pw: [SUPPRESSED]\n";
	}

	my $logInOutWSURI     = "http://$testHost/sakai-axis/SakaiLogin.jws?wsdl";
	my $sakaiScriptWSURI  = "http://$testHost/sakai-axis/SakaiScript.jws?wsdl";
	my $sakaiSessionWSURI = "http://$testHost/sakai-axis/SakaiSession.jws?wsdl";

 	# login and start sakai session
	$sakaiSession = establishSakaiSession( $logInOutWSURI, $sakaiSession, $user, $pw );
	die("no sakai session $!") unless ($sakaiSession);
	print "established session: [$sakaiSession]\n";

	# connect to the web service
	$connection = connectToSakaiWebService($sakaiSessionWSURI);
	die("no sakai web service connection $!") unless ($connection);
	print "established sakai session ws connection\n";

	# check that the user is who we expect it to be.
	$foundUser = $connection->getSessionUser($sakaiSession)->result;
	die("expected user: [$user] but found user: [$foundUser] $!")
	  unless ( $foundUser =~ $user );
	print "get session user: [$foundUser]\n";

	# logout
	# Need to change establishSakaiSession to return connection to logout.
	print "web service connection test successful.\n";
}

#runTest("localhost:8080","USER","PW");
runTest("localhost:8080","admin","admin");

#end
