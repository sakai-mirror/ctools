// $HeadURL:$
// $Id:$

class testSubClasses {

def getCandidateSitesSql(String toolId, Integer rowLimit) {
  def query = """select distinct * from (select * from ( select SITE_ID from SAKAI_SITE_TOOL  where SITE_ID like '~%'  and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = '${toolId}')  order by SITE_ID) where rownum < ${rowLimit})"""

  return query;
    }
}

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
