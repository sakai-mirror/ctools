#!/usr/bin/env groovy
// $HeadURL$
// $Id$

// Demonstrate simple junit testing with groovy.

// import the class to test

import UpdateSiteWithTool

// create the test class
class SimpleUnitTest extends GroovyTestCase {

  def uSWT;

  // create new instance of class with each test.

  void setUp () { 
    uSWT = new UpdateSiteWithTool();
  };
  
  void testExcludeSiteCheck() {
    assertTrue("should find default excluded site",uSWT.excludeSite('a'));
    assertTrue("should find default excluded site",uSWT.excludeSite('b'));
    assertFalse("should NOT find in default excluded site",uSWT.excludeSite('c'));
    // assertFalse("should NOT find in default excluded site",uSWT.excludeSiteC('a'));
  };

  void testDryRunCheck () {
    // set property as variable.
    assertTrue("verify default value",uSWT.isDryRun());
    uSWT.dryRun = true;
    assertTrue("should verify dryRunStatus is true",uSWT.isDryRun());
    uSWT.dryRun = false;
    assertFalse("should verify dryRunStatus is false",uSWT.isDryRun());
  };
}
