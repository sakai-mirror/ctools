// $HeadURL$
// $Id$

// checking comment: works!

/*
  Test to see if can read properties.
 */



// def myURL = "jdbc:oracle:thin:@localhost:12439:SAKAIDEV";
// def user = "dlhaines";
// def password = "dlhaines";

Properties properties  = new Properties();
FileInputStream props = new FileInputStream("test.properties");
properties.load(props);
props.close();

properties.each {
  println it;
}

def candidateSitesSql = "select * from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'sakai.rsf.evaluation') order by SITE_ID) where rownum < 3"


// ds = new oracle.jdbc.pool.OracleDataSource();
// ds.setURL(myURL);
// conn = ds.getConnection(user, password);
// conn.execute(candidateSitesSql);

  import groovy.sql.Sql;
//import java.sql.Connection;
//import java.sql.DriverManager;
//import javax.sql.DataSource;

//def sql = Sql.newInstance(myURL, user, password,"oracle.jdbc.driver.OracleDriver");
def sql = Sql.newInstance(properties.myURL, properties.user, properties.password,"oracle.jdbc.driver.OracleDriver");
sql.eachRow(candidateSitesSql) { println it.SITE_ID }

// end
