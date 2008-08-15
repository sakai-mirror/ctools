// List all sites
// $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/ctools-webservices/src/sash/groovy/listSitesWithTool.groovy $
// $Id: listSitesWithTool.groovy 50721 2008-08-14 16:54:56Z dlhaines@umich.edu $

// fundamental imports for Sakai

// Get the component manager to allow looking up the required services;
import org.sakaiproject.component.cover.ComponentManager
// Allow creating logs
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

private static Log metric = LogFactory.getLog("metrics." + "edu.umich.ctools.listSitesWithTool.groovy");
private static Log log = LogFactory.getLog("edu.umich.ctools.listSites.groovy");

// log.debug("listSites.groovy debug level log message");
// log.info("listSites.groovy info level log message");
// log.warn("listSites.groovy warn level log message");
// log.error("listSites.groovy error level log message");

// metric.debug("listSites.groovy debug level metric message");
// metric.info("listSites.groovy info level metric message");
// metric.warn("listSites.groovy warn level metric message");
// metric.error("listSites.groovy error level metric message");

def sleepTime=0;

// Will need to use the site service.
import org.sakaiproject.site.api.SiteService
def siteService = ComponentManager.get("org.sakaiproject.site.api.SiteService");

println "sleep time: "+sleepTime;

// keep some statistics
def start = System.currentTimeMillis();
def  siteCnt = 0;
println "start time: "+start;
out.flush();

// for each site print some information
siteService.getSites(SiteService.SelectionType.NON_USER, ["course","project"], null, null, null,null).each 
{ site ->
  Thread.sleep(sleepTime);
  siteCnt++;
  println  "title: [${site.title}], id: [${site.id}]";
  log.warn("title: [${site.title}], id: [${site.id}]");
  metric.warn("title: [${site.title}], id: [${site.id}]");
  out.flush();
  //  println  "title: [${it.title}], id: [${it.id}]";
}
//     {site ->
// 	    println "site: ".site;
//     }

def stop = System.currentTimeMillis();
println "end time: " + stop;
def elapsed = stop -start;
println "for "+siteCnt+" sites the elapsed time is: "+elapsed;
println "time per site: "+elapsed / siteCnt + " ms";

/* sql example

public SakaiIMSUser retrieveUser(final String userId, boolean isEmail)
	{
		String statement;

		if (userId == null) return null;

		if (isEmail)
		{
			// 1 2 3 4 5 6 7
			statement = "select USERID,FN,SORT,PASSWORD,FAMILY,GIVEN,EMAIL from IMSENT_PERSON where EMAIL = ?";
		}
		else
		{
			statement = "select USERID,FN,SORT,PASSWORD,FAMILY,GIVEN,EMAIL from IMSENT_PERSON where USERID = ?";
		}

		Object fields[] = new Object[1];
		fields[0] = userId;

		System.out.println("SQL:" + statement);
		List rv = m_sqlService.dbRead(statement, fields, new SqlReader()
		{
			public Object readSqlResultRecord(ResultSet result)
			{
				try
				{
					SakaiIMSUser rv = new SakaiIMSUser();
					rv.id = result.getString(1);
					rv.displayName = result.getString(2);
					rv.sortName = result.getString(3);
					if (rv.sortName == null) rv.sortName = rv.displayName;
					rv.password = result.getString(4);
					rv.lastName = result.getString(5);
					rv.firstName = result.getString(6);
					rv.eMail = result.getString(7);
					System.out.println("Inside reader " + rv);
					return rv;
				}
				catch (SQLException e)
				{
					M_log.warn(this + ".authenticateUser: " + userId + " : " + e);
					return null;
				}
			}
		});

		if ((rv != null) && (rv.size() > 0))
		{
			System.out.println("Returning ");
			System.out.println(" " + (SakaiIMSUser) rv.get(0));
			return (SakaiIMSUser) rv.get(0);
		}
		return null;
	}
*/

/* Drew suggests this variant of my query.
-- select distinct * from (select * from (
-- select SITE_ID from SAKAI_SITE_TOOL
-- where SITE_ID like '~%'
-- and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'sakai.rsf.evaluation')
-- order by SITE_ID
-- ) where rownum < 1000);
*/

// end
