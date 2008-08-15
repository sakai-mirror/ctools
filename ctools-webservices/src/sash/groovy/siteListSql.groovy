// $HeadURL$
// $Id$

// Class to return sql for various types of queries to get various types of lists of sites.

class siteListSql {

def getWorkSitesWithoutToolSql(String toolId, Integer rowLimit) {
  def query = """select distinct * from (select * from ( select SITE_ID from SAKAI_SITE_TOOL  where SITE_ID like '~%'  and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = '${toolId}')  order by SITE_ID) where rownum < ${rowLimit})"""

  return query;
    }
}


/*
new suggestion from Drew
select * from (
select SITE_ID from SAKAI_SITE_TOOL A
where SITE_ID like '~%'
and not exists (select SITE_ID from SAKAI_SITE_TOOL B where REGISTRATION = 'sakai.rsf.evaluation' and A.SITE_ID=B.SITE_ID) order by SITE_ID
) where rownum < 100
;
*/
// println getCandidateSitesSql("sakai.rsf.evaluation",10);

// def testSql1 = "select distinct * from (select * from ( select SITE_ID from SAKAI_SITE_TOOL  where SITE_ID like '~%'  and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'sakai.rsf.evaluation}')  order by SITE_ID) where rownum < 10)"

// assert "a" == "a"

// assert "a" != "b"

// assert  testSql1 == getCandidateSitesSql('sakai.rsf.evaluation',10);

/*
  select distinct * from (select * from (
  select SITE_ID from SAKAI_SITE_TOOL
  where SITE_ID like '~%'
  and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'sakai.rsf.evaluation')
  order by SITE_ID
) where rownum < 1000);
*/
