// $HeadURL:$
// $Id:$

// checking comment: works!

println "HOWDY"

def myURL = "jdbc:oracle:thin:@localhost:12439:SAKAIDEV";
def user = "dlhaines";
def password = "dlhaines";

def candidateSitesSql = "select * from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'sakai.rsf.evaluation') order by SITE_ID) where rownum < 3"


// ds = new oracle.jdbc.pool.OracleDataSource();
// ds.setURL(myURL);
// conn = ds.getConnection(user, password);
// conn.execute(candidateSitesSql);

  import groovy.sql.Sql;
import java.sql.Connection;
import java.sql.DriverManager;
import javax.sql.DataSource;

def sql = Sql.newInstance(myURL, user, password,"oracle.jdbc.driver.OracleDriver");
sql.eachRow(candidateSitesSql) { println it.SITE_ID }

// end
