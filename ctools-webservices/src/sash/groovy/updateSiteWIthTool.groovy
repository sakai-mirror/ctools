// $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/ctools-webservices/src/sash/groovy/testDbSql.groovy $
// $Id: testDbSql.groovy 50826 2008-08-17 19:17:33Z dlhaines@umich.edu $

// Much of this code is based on code from dmccallum.

// checkin comment:

// code to add tool to sites returned from an sql query.

Properties properties  = new Properties();
FileInputStream props = new FileInputStream("test.properties");
properties.load(props);
props.close();

/* print all the properties read in.
   properties.each {
   println it;
   }
*/

/*
  properties should be:
  db url, user, pw, driver
  tool to add (and to filter out from candidates)
  page name
  tool name
  dryRun (if true then no updates)
  number of rows per batch
  someday maybe ignore sites also.
*/

def candidateSitesSql = "select * from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'sakai.rsf.evaluation') order by SITE_ID) where rownum < 3"

  // Get list of sites to ignore
  // may want to read from properties file.  Will probably need to split a blank separated line 
  // to get a list of properties

  def ignoreSites = [ 'a', 'b'];

// println ignoreSites['z'];  fails
// println ignoreSites.any('z');fails

// example of finding particular values in a list.
// Not efficient for long lists.
//println ignoreSites.find { it == 'a' }
//println ignoreSites.find {it == 'z'}

// ignoreSites.each { println it};

import groovy.sql.Sql;

def sql = Sql.newInstance(properties.myURL, properties.user, 
			  properties.password,properties.dbdriver);

sql.eachRow(candidateSitesSql) { println it.SITE_ID }

// closure to check if the site already contains the tool
def toolAlreadyPlaced = { site, toolId ->
			  site.getToolForCommonId(toolId) != null
};

// closure to see if the site should be ignored
def excludeSite = { site ->
		    ignoreSites.find {it == site}
}

  def dryRun = { site ->
		 if (dryRun) {
		   println "dry run check on site: "+site;
		   return false;
		 }
		 return true;
  }

  // closure to take a site and decide if if it should be updated.
    def shouldUpdateSite = { site ->
			     ! (   dryRun(site) 
				   || excludeSite(site)
				   || toolAlreadyPlaced(site,toolId)
				   )
    }

    // add the tool to the site.
      def placeTool = {site, toolId, pageName ->
		       siteEdit = siteService.getSite(site.id)
		       sitePageEdit = siteEdit.addPage()
		       sitePageEdit.setTitle(pageName)
		       sitePageEdit.setLayout(0)
		       toolConfig = sitePageEdit.addTool()
		       toolConfig.setTool(toolId, toolManager.getTool(toolId))
		       toolConfig.setTitle(toolName)
		       siteService.save(siteEdit)
      }

      //  loop over lists of some candidate sites to ensure all sites are processed
      // then loop over each list to process each site.
	moreSitesToProcess = 1;
totalSitesUpdated = 0;
sitesSkipped = 0;
while(moreRowsToProcess)  {
  rowsProcessedInBatch = 0;
  sql.eachRow(candiateSitesSql) { siteId ->
    if (shouldUpdateSite(siteId)) {
      placeTool(siteId,toolId,pageName);
      totalSitesUpdated++;
    }
    {
      elseSitesSkipped++;
    }
  }
  moreRowsToProcess = (rowsProcessedInBatch > 0);
 }

// end
