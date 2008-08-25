// $HeadURL$
// $Id$

// Groovy script, run through sash,

// Much of this code is based on code from dmccallum.
// I've added code to get the sites via sql, do batches, and provide summary statistics.

/* TTD
   - add summary stats.
   - read from properties file? (need to modify sash to do that)
   - get db connection from Sakai? (good idea)
   - add testing via mocks 
*/

// run a couple of upfront queries to see how many sites will be updated.

/*
  See Stopwatch.groovy for description of timing.
*/

// code to add tool to sites returned from an sql query.

import groovy.sql.Sql;
import org.sakaiproject.component.cover.ComponentManager
import org.sakaiproject.site.api.SiteService;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

//println  "howdy from USWT";

class Driver {

  def main(String[] args) {

    // def cmd = "count";
    def cmd = "process";

    //    log.info("********** UpdateSiteWithTool *************");
    //    log.info("cmd: ${cmd}");

    def USWT = new UpdateSiteWithTool();
    USWT.perform(cmd);
  }
}

// Stopwatch is copied from the Stopwatch.groovy file and current sash
// doesn't pick up other files.

/*
  benchmark / stats
  - take a comment
  - record start and end.
  - record the successful events (and unsuccessful?)
  - print a summary 

  ?? Should there be a "lap" or "sofar" method that gives result without
  having to call stop?  It uses the current time as the temporary stop value.

  Constructor should have a 1 MS sleep to avoid problems with very fast 
  elapsed times.

  s1 = new Stopwatch("comment")
  s1.start(); // start recording stats
  s1.stop();  // stop recording stats.
  s1.startTime();  // return the start time
  s1.stopTime();   // return the stop time
  s1.markEvent(); note that event occurred
  s1.eventCnt();  // how many events have there been?
  s1.summaryNums(); returns list of elapsed MS, num events, and events / MS.
  s1.summary() // returns a summary string elapsed, num events, avg
  s1.toString() // provide a default summary naming the stopwatch and giving elapsed time, num events and event rate.
*/

class Stopwatch {
  
  // default comment
  String comment = "default comment";

  // start and stop time stamps.
  def startMS = 0;
  def stopMS = 0;
  def eventCnt = 0;
  
  // initialize the stopwatch and return the start time in MS
  def start() {
    startMS = System.currentTimeMillis();
  }

  def startTime() {
    return startMS;
  }

  // stop the timing and return the stop time in MS.
  def stop() {
    stopMS = System.currentTimeMillis();
  }

  def stopTime() {
    return stopMS;
  }

  // handle events
  def markEvent() {
    eventCnt++;
  }

  def eventCnt() {
    return eventCnt;
  }

  // compute the summary values
  def summaryNums() {
    // if the watch hasn't been stopped give an interim value based on 
    // the current time.
    def useStartMS = (startMS ? startMS : System.currentTimeMillis());
    def useStopMS = (stopMS ? stopMS : System.currentTimeMillis());
    def elapsed = useStopMS-useStartMS;
    Float rate = 0;
    if (elapsed) {
      rate = eventCnt / elapsed;
    }
    else {
      rate = -1;
    }
    [elapsed,eventCnt,rate];
  }

  // give a summary 
  def summary() {
    def summary = summaryNums();
    // format the rate
    Float tmp = summary[2];
    def formatted = sprintf("%4.3f",tmp);
    "elapsed: ${summary[0]} events: ${summary[1]} events_per_MS: ${formatted}";
  }
  
  def String toString() {
    "${comment} "+summary();
  }
}

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
  def maxBatchSize = 2;

  // max batches (Useful if testing and want to break the eternal update loop).
  def maxBatches = 10;

  //Boolean dryRun = true;
  Boolean dryRun = false;

  def evalNames = ['toolRegistration':'sakai.rsf.evaluation', 'newPageName':"Teaching Questionnaires", 'toolName': "Teaching Questionnaires"];
  def wikiNames = ['toolRegistration':'sakai.rwiki', 'newPageName':'Wiki Tool page', 'toolName': 'Wiki Tool'];
  def dropboxNames = ['toolRegistration':'sakai.dropbox', 'newPageName':'dropbox', 'toolName': 'dropbox'];
  def pollNames = ['toolRegistration':'sakai.poll', 'newPageName':'Poll Page(added by script)', 'toolName': 'Poll tool (added by script)'];
  def discussionNames = ['toolRegistration':'sakai.discussion', 'newPageName':'Discussion Page(added by script)', 'toolName': 'Discussion tool (added by script)'];


  // which tool are we adding to the site?

  //  def toolDef  = wikiNames;
  //  def toolDef  = dropboxNames;
  // def toolDef  = pollNames;
  // def toolDef  = discussionNames;

  //  def properties = [myURL:"jdbc:oracle:thin:@localhost:12439:SAKAIDEV", user:"dlhaines", password:"dlhaines", dbdriver:"oracle.jdbc.driver.OracleDriver"];

  def candidateSitesSql = "select SITE_ID from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = ${toolDef.toolRegistration}) order by SITE_ID) where rownum <= ${maxBatchSize}";

  def countCandidateSitesSql = "select count(distinct SITE_ID) from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = ${toolDef.toolRegistration})";

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

  
  // db connection.  It is visible so that it can be referenced in a finally block
  def dbConnection;

  /****************************
   Dispatch method.
  ****************************/

  def  perform(String cmd) {


    def foundCmd = 0;
    log.info("********** UpdateSiteWithTool *************");
    log.info("cmd: ${cmd}");

    if (verbose) {
      settings(cmd);
    }

    try {
      //    db = getDb();
      dbConnection = sqlService.borrowConnection();
      assert dbConnection != null;
      db = getDbViaConnection(dbConnection);

      if (cmd == 'count') {
	foundCmd = 1;
	countSites(db);
      };

      if (cmd == 'process') {
	foundCmd = 1;
	processSites(db);
      }
      //     if (cmd == 'help' || (!foundCmd)) {
      //       //println ": arg is count (the number of remaining sites to process) or process (start processing the sites).";
      //     }
      summary();
    }
    finally {
      sqlService.returnConnection(dbConnection);
    }
    
  }

  

  // Method to open connection to db.
  Sql getDbViaConnection(connection) {
    //    def db = Sql.newInstance(properties.myURL, properties.user, 
    //			     properties.password,properties.dbdriver);
    //    dbConnection = sqlService.borrowConnection();
    def db = new Sql(connection);
    assert db != null;

    log.debug("sites in batch (via connection):");
    db.eachRow(candidateSitesSql) { log.debug("* ${it.SITE_ID}") };
    return db;
  };

  //   Sql getDbDirect() {
  //     def db = Sql.newInstance(properties.myURL, properties.user, 
  // 			     properties.password,properties.dbdriver);

  //     log.debug("sites in batch:");
  //     db.eachRow(candidateSitesSql) { log.debug("* ${it.SITE_ID}") };
  //     return db;
  //   };

  /* ************* context unaware ************** */

  // summarize the settings for the run.
  def settings = {args	->
		  log.info("* settings:");
		  //		  args.each{log.info("* arg: ${it}")};
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

  // For testing can create a list to use instead of the db result to
  // allow mocking of sites.  This can be used instead of the db variable.
  //def testSites = [["SITE_ID":"~c8a87abf-15fe-4d9f-a6af-5c28abd42c8b"]];

  void countSites(Sql db) {

    log.warn("countSites start");
    def siteCount = 0;
    def sw = new Stopwatch(comment:"count query:");
    sw.start();
    //* only getting 1 row back, the count.
    db.eachRow(countCandidateSitesSql) { queryRow ->
      sw.markEvent();
      //      println "count: ${queryRow[0]}";
      //      log.warn("siteCount: ${siteCount}");
      log.warn("siteCount: ${queryRow[0]} (including special sites ignored later)");
    }
    sw.stop();
    log.warn(sw.toString());
  }

  void processSites(Sql db) {

    // Gets a limited size list of sites to process from sql and 
    // processes those in a batch.  It loops running that query until 
    // there is a batch that contains no eligable sites.

    // bootstrap / halt flag
    def moreSitesToProcess = 1;
    log.debug("in processSites");

    def updatedSite = false;

    def swAll = new Stopwatch(comment:"AddTool ${toolDef.toolRegistration} summary");
    swAll.start();
    
    while(moreSitesToProcess && (batchCnt < maxBatches))  {
      batchCnt++;
      log.debug("batchCnt: ${batchCnt}");
      rowsProcessedInBatch = 0;
      sitesAddedInBatch = 0;
      def swBatch = new Stopwatch(comment:"AddTool ${toolDef.toolRegistration} batch summary");
      swBatch.start();
      db.eachRow(candidateSitesSql) { queryRow ->
	updatedSite = false;
	log.debug("processing site: ${queryRow.SITE_ID}");
	// testSites.each {queryRow -> // this line could be used for mocking
	log.debug("queryRow candidate: [${queryRow.SITE_ID}]");
	swBatch.markEvent();
	swAll.markEvent();
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
      swBatch.stop();
      metric.warn(swBatch.toString());
      moreSitesToProcess = (sitesAddedInBatch > 0);
    }
    swAll.stop();
    metric.warn(swAll.toString());
  };
}
// end
