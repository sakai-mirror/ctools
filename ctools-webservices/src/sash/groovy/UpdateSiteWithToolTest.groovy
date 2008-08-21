#!/usr/bin/env groovy
// $HeadURL$
// $Id$

// TTD (Things To Do)
// - test reading the properties file.
// - add mocks to test process sites

import org.jmock.MockObjectTestCase;

import groovy.sql.Sql;

// import the class to test
import UpdateSiteWithTool;

// create the test class
class SimpleUnitTest extends MockObjectTestCase {

  def uSWT;

  // create new instance of class with each test.

  void setUp () { 
    uSWT = new UpdateSiteWithTool();
  };
  
  void testExcludeSiteCheck() {
    assertTrue("should find default excluded site",uSWT.excludeSite('a'));
    assertTrue("should find default excluded site",uSWT.excludeSite('b'));
    assertFalse("should NOT find in default excluded site",uSWT.excludeSite('c'));
  };

  void testDryRunCheck () {
    // set property as variable.
    assertTrue("verify default value",uSWT.isDryRun());
    uSWT.dryRun = true;
    assertTrue("should verify dryRunStatus is true",uSWT.isDryRun());
    uSWT.dryRun = false;
    assertFalse("should verify dryRunStatus is false",uSWT.isDryRun());
  };

  // add mock


  def testEachRow = { db->
    //    def db = Sql.newInstance("A","B","C","D");
    println db.eachRow() == "SITE1";
    println db.eachRow() == "SITE2";
  }

  void testMock() {
    // need to mock a class / interface
    def dbMock = new MockFor(Sql.class);

    //    dbMock.demand.new{};
    // dbMock.demand.newInstance("A","oracle.jdbc.driver.OracleDriver") {};
    //    dbMock.demand.newInstance("jdbc:oracle:thin:@localhost:12439:SAKAIDEV","dlhaines","dlhaines","oracle.jdbc.driver.OracleDriver") {};
    dbMock.demand.eachRow(1..1){"SITE1"};
    dbMock.demand.eachRow(2..2){"SITE2"};

    //    db = dbMock.proxyDelegateInstance("A","B","C","D");
    //    db = dbMock.proxyDelegateInstance();
    // db = dbMock.proxyInstance();

    //        dbMock.use {

    testEachRow(dbMock.proxyInstance("jdbc:oracle:thin:@localhost:12439:SAKAIDEV"));
      
	  //        }
    //    println dummyDb.eachRow();

    // This doesn't work with the message testMock(SimpleUnitTest)groovy.lang.MissingPropertyException: No such property: db for class: SimpleUnitTest
//     dbMock.use {
//     println db.eachRow("X");
//      }

//  dbMock.use {
    //   //  ["A","B"].each {
    //    println db.eachRow("X");
    // //    }
    //     }
  }
}
 