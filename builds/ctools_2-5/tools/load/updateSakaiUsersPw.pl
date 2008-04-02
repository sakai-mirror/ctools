#!/usr/bin/perl -w
#
# $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/builds/ctools_2-3/tools/load/addSakaiUsers.pl $
# $Id: addSakaiUsers.pl 14101 2006-08-29 19:26:20Z dlhaines@umich.edu $
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

my $trace = 1;

# Sakai admin user's credentials
my $user = "admin";
my $password = "admin";

my $soap;

my $lineCnt;

our @test = (
	     "AAbobZB newACORN",
	     "AAblueZAB obscure",
	    );

sub testChangePw {
  my($u);
  my($user,$pw);
  startSakaiSession();
  getSoapConnection();

  foreach $u (@test) {
    ($user,$pw) = $u =~ m/(.*)\s+(.*)/;
    print "u: [$user] p: [$pw]\n" if ($trace);
    changeUserPassword($user,$pw);
  }
}

sub main {
  testChangePw();
  printSummary();
}

sub printSummary() {

}

#######

main();
print "\n";
