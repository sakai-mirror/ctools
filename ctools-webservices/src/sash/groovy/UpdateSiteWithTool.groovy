// $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/ctools-webservices/src/sash/groovy/testDbSql.groovy $
// $Id: testDbSql.groovy 50826 2008-08-17 19:17:33Z dlhaines@umich.edu $

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


  //  def toolRegistration = "sakai.rsf.evaluation";
  //  // for testing use wiki
  //  def toolRegistration = "sakai.rwiki";
  // Specify the name of the page given to the page the tool will be on.
  //  def newPageName = "EvalTool Page";
  // Specify the name of the tool
  //def toolName = "EvalTool Name";



  def properties = [myURL:"jdbc:oracle:thin:@localhost:12439:SAKAIDEV", user:"dlhaines", password:"dlhaines", dbdriver:"oracle.jdbc.driver.OracleDriver"];

  //  def candidateSitesSql = "select SITE_ID from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = ${toolRegistration}) order by SITE_ID) where rownum <= ${maxBatchSize}";

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


log.debug("UpdateSitesWIthTool.groovy debug level log message");
log.info("UpdateSitesWIthTool.groovy info level log message");
log.warn("UpdateSitesWIthTool.groovy warn level log message");
log.error("UpdateSitesWIthTool.groovy error level log message");

metric.debug("UpdateSitesWIthTool.groovy debug level metric message");
metric.info("UpdateSitesWIthTool.groovy info level metric message");
metric.warn("UpdateSitesWIthTool.groovy warn level metric message");
metric.error("UpdateSitesWIthTool.groovy error level metric message");


//    log.WARN("********** UpdateSiteWithTool *************");
    log.warn("********** UpdateSiteWithTool *************");
    //    log.ERROR("********** UpdateSiteWithTool *************");
    log.error("********** UpdateSiteWithTool *************");

    if (verbose) {
      println "********** UpdateSiteWithTool *************";
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
		  println "* settings:\n* date: ${ new Date() }";
		  args.each{println "* arg: ${it}"};
		  println "* tool registration: [${toolDef.toolRegistration}]";		  
		  println "* maxBatchSize: ${maxBatchSize}";
		  println "* dryRun: ${dryRun}";
		  println "* candidateSitesSql: ${candidateSitesSql}";
		  println "* ignoreSites: ${ignoreSites}";
		  println "* sitesSkipped: ${sitesSkipped}";
  }

  // print a summary of processing
    def summary = {
      println "number of batches: ${batchCnt}";
      println "number of candidate sites: ${rowsProcessedInBatch}";
      println "sites skipped: ${sitesSkipped}";

      /*
      metric.WARN("number of batches: ${batchCnt}");
      metric.WARN("number of candidate sites: ${rowsProcessedInBatch}");
      metric.WARN("sites skipped: ${sitesSkipped}");
      */
      // println "total sites updated: ${totalSitesUpdated}";
    };

    // Method to open connection to db.
      Sql getDb() {
	def db = Sql.newInstance(properties.myURL, properties.user, 
				 properties.password,properties.dbdriver);

	if (verbose) {
	  println "sites in batch:";
	  db.eachRow(candidateSitesSql) { println "* ${it.SITE_ID}" }
	}
	return db;
      };

  // closure to check if the site already contains the tool
  def toolAlreadyPlaced = { siteId, toolId ->
			    def siteEdit = siteService.getSite(siteId)
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
      if (verbose) {println "ignoring site: ${siteId}"};
    }

    return shouldUpdate;
  };

  // add the tool to the site.
  def placeTool = {siteId, toolId, pageName ->
		   if (verbose) {println "* about to add ${toolId} to page: ${pageName} on site {$siteId}"};
		   def siteEdit = siteService.getSite(siteId)
		   def sitePageEdit = siteEdit.addPage()
		   sitePageEdit.setTitle(pageName)
		   sitePageEdit.setLayout(0)
		   def toolConfig = sitePageEdit.addTool()
		   toolConfig.setTool(toolId, toolManager.getTool(toolId))
		   toolConfig.setTitle(toolDef.newPageName)
		   siteService.save(siteEdit)
  };

  /****************** Control methods *************/

  // allow mocking of sites to test with.
  def testSites = [["SITE_ID":"~c8a87abf-15fe-4d9f-a6af-5c28abd42c8b"]];

  void countSites(Sql db) {
    def sitesWithTool = 0;
    db.eachRow(candidateSitesSql) { queryRow ->
      sitesWithOutTool++;
    }
    println "sitesWithOutTool: ${sitesWithOutTool}";
  }

  void processSites(Sql db) {

    //  loop over lists of some candidate sites to ensure all sites are processed
    // then loop over each list to process each site.

    // bootstrap / halt flag
    def moreSitesToProcess = 1;
    //    log.debug("in processSites");

    while(moreSitesToProcess && (batchCnt < maxBatches))  {
      batchCnt++;
      if (verbose) {println "batchCnt: ${batchCnt}"};
      rowsProcessedInBatch = 0;
      db.eachRow(candidateSitesSql) { queryRow ->
	//	log.debug("processing site: ${queryRow.SITE_ID}");
      // testSites.each {queryRow -> // for mocking
	if (verbose) {println "queryRow candidate: [${queryRow.SITE_ID}]"};
	rowsProcessedInBatch++;
	if (siteEligibleForUpdate((String)queryRow.SITE_ID)) {
	  if (verbose) {println "processing site: ${queryRow.SITE_ID}"};
	  if (!isDryRun()) {
	    placeTool(queryRow.SITE_ID,toolDef.toolRegistration,toolDef.newPageName);
	    totalSitesUpdated++;
	  }
	}
	if (!siteEligibleForUpdate(queryRow.SITE_ID)) {
	  sitesSkipped++;
	}
	if (verbose) {println "* totalSitesUpdated: ${totalSitesUpdated}"};
	/*
	  metric.debug("* totalSitesUpdated: ${totalSitesUpdated}");
	*/
      }
      if (verbose) {println "rowsProcessedInBatch: ${rowsProcessedInBatch}"};
      // metric.debug("rowsProcessedInBatch: ${rowsProcessedInBatch}");
      if (batchCnt > maxBatches) {
	rowsProcessedInBatch = 0;
      }

      moreSitesToProcess = (rowsProcessedInBatch > 0);
    }
  };
}
// end

