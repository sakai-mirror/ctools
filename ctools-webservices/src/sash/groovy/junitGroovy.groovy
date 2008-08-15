// $HeadURL:$
// $Id:$

// Demonstrate simple junit testing with groovy.

// import the class to test
import testSubClasses

// create the test class
  class SimpleUnitTest extends GroovyTestCase {

  def testSql1 = "select distinct * from (select * from ( select SITE_ID from SAKAI_SITE_TOOL  where SITE_ID like '~%'  and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'sakai.rsf.evaluation')  order by SITE_ID) where rownum < 10)";
  def testSql2 = "select distinct * from (select * from ( select SITE_ID from SAKAI_SITE_TOOL  where SITE_ID like '~%'  and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'XABC')  order by SITE_ID) where rownum < 17)";
    void testSimpleA() {
      def tsc2 = new testSubClasses();
      assertEquals(testSql2,tsc2.getCandidateSitesSql("XABC",17));
    }

    void testSimpleB() {
      def tsc2 = new testSubClasses();
      assertEquals(testSql1,tsc2.getCandidateSitesSql("sakai.rsf.evaluation",10));
    }
  }
