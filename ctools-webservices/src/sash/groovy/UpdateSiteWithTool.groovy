// $HeadURL$
// $Id$

// Much of this code is based on code from dmccallum.
// I've added code to do batches and provide summary statistics.

// checkin comment:

// code to add tool to sites returned from an sql query.

import groovy.sql.Sql;
import org.sakaiproject.component.cover.ComponentManager
import org.sakaiproject.site.api.SiteService;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/*
 */

class UpdateSiteWithTool {

  private static Log metric = LogFactory.getLog("metrics." + "edu.umich.ctools.UpdateSitesWithTool");
  private static Log log = LogFactory.getLog("edu.umich.ctools.UpdateSitesWithTool");

  // control tracing
  def verbose = 1;

  // sql db connection
  def db;

  // maximum number of sites to retrieve in a single query.
  def maxBatchSize = 10;

  // max batches (Useful if testing and want to break the eternal update loop).
  def maxBatches = 2;

  //Boolean dryRun = true;
  Boolean dryRun = false;

  def evalNames = ['toolRegistration':'sakai.rsf.evaluation', 'newPageName':'EvalTool page', 'toolName': 'EvalTool Name'];
  def wikiNames = ['toolRegistration':'sakai.rwiki', 'newPageName':'Wiki Tool page', 'toolName': 'Wiki Tool'];

  // which tool are we adding to the site?

  def toolDef  = wikiNames;

  def properties = [myURL:"jdbc:oracle:thin:@localhost:12439:SAKAIDEV", user:"dlhaines", password:"dlhaines", dbdriver:"oracle.jdbc.driver.OracleDriver"];

  def candidateSitesSql = "select SITE_ID from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = ${toolDef.toolRegistration}) order by SITE_ID) where rownum <= ${maxBatchSize}";

  // List of sites to ignore, e.g. ~admin

  def ignoreSites = [ '~admin'];

  // get the required Sakai services
  def siteService = ComponentManager.get("org.sakaiproject.site.api.SiteService");
  def toolManager = ComponentManager.get("org.sakaiproject.tool.api.ToolManager");
  def sqlService = ComponentManager.get("org.sakaiproject.db.api.SqlService");

  /* ****************************** */

  /* data summary variables */
  // How many sites already have the tool placed in it?
  def sitesWithExistingTool = 0;

  // How many batches have been processed in this run?
  def batchCnt = 0;

  // how much was processed in this batch?
  def rowsProcessedInBatch = 0;

  // How many were actually added?
  def sitesAddedInBatch = 0;

  // final number of updated sites.
  def totalSitesUpdated = 0;

  // How many sites were ignored?
  def sitesSkipped = 0;

  // How many sites already have the tool?
  def sitesWithOutTool = 0;

  
  /****************************
   Main method of script
  ****************************/

  def  main(String[] args) {

    log.info("********** UpdateSiteWithTool *************");

    if (verbose) {
      settings(args);
      args.each{println it};
    }
    db = getDb();
    //countSites(db);
    processSites(db);
    summary();
  }


  // summarize the settings for the run.
  def settings = {args	->
		  log.info("* settings:");
		  args.each{log.info("* arg: ${it}")};
		  log.info("* tool registration: [${toolDef.toolRegistration}]");		  
		  log.info("* maxBatchSize: ${maxBatchSize}");
		  log.info("* dryRun: ${dryRun}");
		  log.info("* candidateSitesSql: ${candidateSitesSql}");
		  log.info("* ignoreSites: ${ignoreSites}");
		  log.info("* sitesSkipped: ${sitesSkipped}");
  }

  // print a summary of processing
    def summary = {
      metric.info("number of batches: ${batchCnt}");
      metric.info("number of candidate sites: ${rowsProcessedInBatch}");
      metric.info("sites skipped: ${sitesSkipped}");
    };

  // Method to open connection to db.
  Sql getDb() {
    def db = Sql.newInstance(properties.myURL, properties.user, 
			     properties.password,properties.dbdriver);

    log.debug("sites in batch:");
    db.eachRow(candidateSitesSql) { log.debug("* ${it.SITE_ID}") };
    return db;
  };

  // closure to check if the site already contains the tool
  def toolAlreadyPlaced = { siteId, toolId ->
			    def siteEdit = siteService.getSite(siteId);
			    if (siteEdit.getToolForCommonId(toolId) != null) {
			      sitesWithExistingTool++;
			      return true;
			    }
			    return false;
			    
  };

  // Method to see if the specific site should be excluded.

  Boolean excludeSite(String siteId)  {
    return (ignoreSites.find {it == siteId} ? true : false);
  };

  // Will we allow any updates?
  Boolean isDryRun() { 
    return dryRun;
  };

  // Method to take a site and decide if it is eligible to be updated.
  Boolean siteEligibleForUpdate(String siteId) { 
    
    Boolean shouldUpdate = true;
    shouldUpdate = !excludeSite(siteId);
    //    println "sUS: after excludeSite: ${shouldUpdate}";
    if (shouldUpdate) {
      shouldUpdate =  !toolAlreadyPlaced(siteId,toolDef.toolRegistration);
    }
    else {
      log.debug("ignoring site: ${siteId}")
    };
    return shouldUpdate;
  };

  // add the tool to the site.
  def placeTool = {siteId, toolId, pageName ->
		   log.debug("* about to add ${toolId} to page: ${pageName} on site {$siteId}");
		   def siteEdit = siteService.getSite(siteId);
		   def sitePageEdit = siteEdit.addPage();
		   sitePageEdit.setTitle(pageName);
		   sitePageEdit.setLayout(0);
		   def toolConfig = sitePageEdit.addTool();
		   toolConfig.setTool(toolId, toolManager.getTool(toolId));
		   toolConfig.setTitle(toolDef.newPageName);
		   siteService.save(siteEdit);
  };

  /****************** Control methods *************/

  // allow mocking of sites to test with.  This can be used instead of the db variable.
  //def testSites = [["SITE_ID":"~c8a87abf-15fe-4d9f-a6af-5c28abd42c8b"]];

  void countSites(Sql db) {
    def sitesWithTool = 0;
    db.eachRow(candidateSitesSql) { queryRow ->
      sitesWithOutTool++;
    }
    log.debug("sitesWithOutTool: ${sitesWithOutTool}");
  }

  void processSites(Sql db) {

    //  loop over lists of some candidate sites to ensure all sites are processed
    // then loop over each list to process each site.

    // bootstrap / halt flag
    def moreSitesToProcess = 1;
    log.debug("in processSites");

    def updatedSite = false;

    while(moreSitesToProcess && (batchCnt < maxBatches))  {
      batchCnt++;
      log.debug("batchCnt: ${batchCnt}");
      rowsProcessedInBatch = 0;
      sitesAddedInBatch = 0;
      db.eachRow(candidateSitesSql) { queryRow ->
	updatedSite = false;
	log.debug("processing site: ${queryRow.SITE_ID}");
	// testSites.each {queryRow -> // for mocking
	log.debug("queryRow candidate: [${queryRow.SITE_ID}]");
	rowsProcessedInBatch++;

	if (siteEligibleForUpdate((String)queryRow.SITE_ID)) {
	  log.debug("processing site: ${queryRow.SITE_ID}");
	  if (!isDryRun()) {
	    placeTool(queryRow.SITE_ID,toolDef.toolRegistration,toolDef.newPageName);
	    updatedSite = true;
	    sitesAddedInBatch++;
	    totalSitesUpdated++;
	  }
	}
	if (!updatedSite) {
	  sitesSkipped++;
	}
	metric.debug("* totalSitesUpdated: ${totalSitesUpdated}");
      }
      metric.debug("rowsProcessedInBatch: ${rowsProcessedInBatch}");
      metric.debug("sitesAddedInBatch: ${sitesAddedInBatch}");
      if (batchCnt > maxBatches) {
	sitesAddedInBatch = 0;
      }

      moreSitesToProcess = (sitesAddedInBatch > 0);
    }
  };
}
// end
