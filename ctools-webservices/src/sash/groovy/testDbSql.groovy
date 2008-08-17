// $HeadURL$
// $Id$

// checkin comment: reading properties works

Properties properties  = new Properties();
FileInputStream props = new FileInputStream("test.properties");
properties.load(props);
props.close();

/* print all the properties read in.
properties.each {
  println it;
}
*/

def candidateSitesSql = "select * from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'sakai.rsf.evaluation') order by SITE_ID) where rownum < 3"

  import groovy.sql.Sql;

def sql = Sql.newInstance(properties.myURL, properties.user, 
			  properties.password,properties.dbdriver);

sql.eachRow(candidateSitesSql) { println it.SITE_ID }

// end
