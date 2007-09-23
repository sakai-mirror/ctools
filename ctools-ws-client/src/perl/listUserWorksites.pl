#!/usr/bin/perl
# $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/ctools-ws-client/src/perl/testSakaiSoapUtil.pl $
# $Id: testSakaiSoapUtil.pl 35696 2007-09-23 18:56:05Z dlhaines@umich.edu $

## List the sites that the user can see.

use sakaiSoapUtil;
use strict;

# Variables to configure

my $sakaiSession = "";

# start a sakai session
# connect to the web service
# do something.
# logout;

my $trace = 1;

# sub listUserSites {
#   my ($testHost,$user,$pw) = @_;
#   my $sakaiScriptWSURI  = "http://$testHost/sakai-axis/SakaiScript.jws?wsdl";
#   my $logInOutWSURI     = "http://$testHost/sakai-axis/SakaiLogin.jws?wsdl";

#   # login and start sakai session
#   my $sakaiSession = establishSakaiSession( $logInOutWSURI, $sakaiSession, $user, $pw );
#   die("failed to create sakai session") unless ($sakaiSession);
#   print "established session: [$sakaiSession]\n";

#   # get the list of sites.
  
#  # connect to the web service
#   my $connection = connectToSakaiWebService($sakaiScriptWSURI);
#   die("no sakai web service connection $!") unless ($connection);
#   print "established sakai session ws connection\n";

#   # check that the user is who we expect it to be.
#   my $listOfSites = $connection->getSitesUserCanAccess($sakaiSession)->result;
#   print "listOfSites: [$listOfSites]\n";
  
# }

sub listUserSitesDom {
  my ($testHost,$user,$pw) = @_;
  my $sakaiScriptWSURI  = "http://$testHost/sakai-axis/SakaiScript.jws?wsdl";
  my $logInOutWSURI     = "http://$testHost/sakai-axis/SakaiLogin.jws?wsdl";
  my $sakaiSiteWSURI    = "http://$testHost/sakai-axis/SakaiSite.jws?wsdl";

  # login and start sakai session
  my $sakaiSession = establishSakaiSession( $logInOutWSURI, $sakaiSession, $user, $pw );
  die("failed to create sakai session") unless ($sakaiSession);
  print "established session: [$sakaiSession]\n";

  # get the list of sites.
  
 # connect to the web service
  my $connection = connectToSakaiWebService($sakaiSiteWSURI);
  die("no sakai web service connection $!") unless ($connection);
  print "established sakai session ws connection\n";

  # check that the user is who we expect it to be.
  my $listOfSitesDom = $connection->getSitesDom($sakaiSession,"",0,100)->result;

  $listOfSitesDom =~ m|My Workspace.*<id>(~[^<]+)</id>|;
  my $myWorkspaceId = $1;
  print "myWorkspaceId: [$myWorkspaceId]\n";

#    my $formatted = $listOfSitesDom;
#    $formatted =~ s/></>\n</g;
#    print "listOfSitesDom: [$listOfSitesDom]\n";
#    print "f: $formatted\n";
  
}

# sub checkUserForSite {
#   my ($testHost,$user,$pw,$siteId) = @_;
#   my $sakaiScriptWSURI  = "http://$testHost/sakai-axis/SakaiScript.jws?wsdl";
#   my $logInOutWSURI     = "http://$testHost/sakai-axis/SakaiLogin.jws?wsdl";


#   print "\nchecking site for user: [$user] on host: [$testHost]";
#   print " checking for site: [$siteId]";
#   print "\n";
#   # login and start sakai session
#   my $sakaiSession = establishSakaiSession( $logInOutWSURI, $sakaiSession, $user, $pw );
#   die("failed to create sakai session") unless ($sakaiSession);
#   print "established session: [$sakaiSession]\n";

#   # check to see if they have a worksite
  
#  # connect to the web service
#   my $connection = connectToSakaiWebService($sakaiScriptWSURI);
#   die("no sakai web service connection $!") unless ($connection);
#   print "established sakai session ws connection\n";

#   # check that the user is who we expect it to be.
#   my $haveSite = $connection->checkForSite($sakaiSession,$siteId)->result;
#   print "haveSite [$siteId] : [$haveSite]\n";
  
# }

# sub checkUserForSiteDom {
#   my ($testHost,$user,$pw,$siteId) = @_;
#   my $sakaiScriptWSURI  = "http://$testHost/sakai-axis/SakaiScript.jws?wsdl";
#   my $logInOutWSURI     = "http://$testHost/sakai-axis/SakaiLogin.jws?wsdl";


#   print "\nchecking site for user: [$user] on host: [$testHost]";
#   print " checking for site: [$siteId]";
#   print "\n";
#   # login and start sakai session
#   my $sakaiSession = establishSakaiSession( $logInOutWSURI, $sakaiSession, $user, $pw );
#   die("failed to create sakai session") unless ($sakaiSession);
#   print "established session: [$sakaiSession]\n";

#   # check to see if they have a worksite
  
#  # connect to the web service
#   my $connection = connectToSakaiWebService($sakaiScriptWSURI);
#   die("no sakai web service connection $!") unless ($connection);
#   print "established sakai session ws connection\n";

#   # if the user has this site.
#   my $haveSite = $connection->checkForSite($sakaiSession,$siteId)->result;
#   print "haveSite [$siteId] : [$haveSite]\n";
  
# }

# sub listWorkSitesOld { 

#   my($testHost,$user,$pw) = @_;

#   my($sakaiSession,$connection,$foundUser);

#   if ($trace) {
#     print "testHost: [$testHost] user: [$user] pw: [SUPPRESSED]\n";
#   }

#   my $logInOutWSURI     = "http://$testHost/sakai-axis/SakaiLogin.jws?wsdl";
#   my $sakaiScriptWSURI  = "http://$testHost/sakai-axis/SakaiScript.jws?wsdl";
#   my $sakaiSessionWSURI = "http://$testHost/sakai-axis/SakaiSession.jws?wsdl";
#   my $sakaiSiteWSURI = "http://$testHost/sakai-axis/SakaiSite.jws?wsdl";

#   # login and start sakai session
#   $sakaiSession = establishSakaiSession( $logInOutWSURI, $sakaiSession, $user, $pw );
#   die("failed to create sakai session") unless ($sakaiSession);
#   print "established session: [$sakaiSession]\n";

#   # connect to the web service
#   $connection = connectToSakaiWebService($sakaiSessionWSURI);
#   die("no sakai web service connection $!") unless ($connection);
#   print "established sakai session ws connection\n";

#   # check that the user is who we expect it to be.
#   $foundUser = $connection->getSessionUser($sakaiSession)->result;
#   die("expected user: [$user] but found user: [$foundUser] $!")
#     unless ( $foundUser =~ $user );
#   print "get session user: [$foundUser]\n";

#   # get list of sites for this user.

#   # Need to change establishSakaiSession to return connection to logout.
#   print "web service connection test successful.\n";

#   my $sleep = 120;
#   print "sleeping for $sleep seconds before logging out\n";
#   sleep $sleep;
#   # logout
#   my $result = endSakaiSession($logInOutWSURI,$user,$sakaiSession);
#   print "logout result: [$result]\n";
#   #	print "can't log out of session for: [$user]\n" unless($result);
# }

# #runTest("localhost:8080","USER","PW");
# #runTest("localhost:8080","admin","admin");
# #listUserSites("localhost:8080","admin","admin");
# #checkUserForSite("localhost:8080","admin","admin","~adminXXX");

# sub testUserSites {
#   my($user,$pw,$siteId) = @_;

#   print "testUserSite for user: [$user]\n";

#   # see which sites they can see.
#   listUserSites("localhost:8080",$user,$pw);

#   # see if can see own worksite
#   checkUserForSite("localhost:8080",$user,$pw,"~".$user);
  
#   checkUserForSite("localhost:8080",$user,$pw,$siteId) if ($siteId);
# #  checkUserForSite("localhost:8080",$user,$pw,"~9fb81184-1738-49d7-80ea-683123f00f11");

#   # make sure can't see garbage site
#   checkUserForSite("localhost:8080",$user,$pw,"~GARBAGE".$user);
# }

#testUserSites("admin","admin");
#testUserSites("newuser01","newuser01");
#testUserSites("newuser01","newuser01","d5ba185c-b39e-441f-0057-8fec4a132599");
#testUserSites("newuser01","newuser01","~d5ba185c-b39e-441f-0057-8fec4a132599");

## works
listUserSitesDom("localhost:8080","newuser01","newuser01");
##returns empty as name is different.
#listUserSitesDom("localhost:8080","admin","admin");

# will extract out the myworkspace id
#perl -n -e 'm|My Workspace.*<id>(~[^<]+)</id>| && print "$1\n"' tmp.txt

#end
