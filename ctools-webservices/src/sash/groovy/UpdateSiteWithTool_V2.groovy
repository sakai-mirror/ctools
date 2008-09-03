// $HeadURL$
// $Id$

// v2 requires setting the startCnt, the number of times that the time will be checked.

// Groovy script, run through sash, to add tools to "My Worksite" sites which do not 
// already include the tool.  It can also count the number of sites that need to have
// the tool added.

// The query is "incremental".  It will return a limited number of sites that 
// should have the tool added.  It can run in a loop until it returns no 
// more eligible sites.  That means we don't have to manage a list of what sites to 
// add the tool to, and we don't have to worry about data getting out of date.  It is 
// harmless to run the script even when no sites are eligible.
// (Assuming that the query doesn't seriously impact the db.)

// Much of this code is based on code from dmccallum.
// I've added code to get the sites via sql, do batches, and provide summary statistics.

/* TTD
   - tighten query to exclude users with EID that contain a '@' (no friend accounts)
   - add testing via mocks 
   - figure out how to really read in command line arguments.
*/

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import groovy.sql.Sql;


import org.sakaiproject.component.cover.ComponentManager
import org.sakaiproject.site.api.SiteService;
import org.sakaiproject.tool.api.SessionManager;

// Class to be called to start processing.  It is tiny and separate from
// the main processing classes to make testing easier.

class Driver {

  def main(String[] args) {

    //    log.warn("******** start driver **********");
    println "******** start driver **********";
    // would be good to read the desired action from
    // the command line.

    //def cmd = "count";
    def cmd = "process";

    def USWT = new UpdateSiteWithTool();
    USWT.perform(cmd);
  }
}

/* *************** Stopwatch ************* */

// Stopwatch is a class that will compute elapsed time (and count events if desired).

// It is explicitly 
// included here since the current sash implementation doesn't pick up other files.

/*
  benchmark / stats
  - take a comment
  - record start and end.
  - record the successful events (and unsuccessful?)
  - print a summary 

  ?? Should there be a "lap" or "sofar" method that gives result without
  having to call stop?  It uses the current time as the temporary stop value.

  TTD 
  - Constructor should have a 1 MS sleep to avoid problems with very fast 
  elapsed times.
  - Should have explicit constructor that takes a string since it is too easy 
  to forget to pass in the comment as named argument.

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
    // if the watch hasn't been started / stopped use an interim value based on 
    // the current time.  This allow computing the results so far.
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
    // return a list of the important numbers.
    [elapsed,eventCnt,rate];
  }

  // return a printable summary
  def summary() {
    def summary = summaryNums();
    // format the rate
    Float tmp = summary[2];
    def formatted = sprintf("%4.3f",tmp);
    "elapsed: ${summary[0]} events: ${summary[1]} events_per_MS: ${formatted}";
  }
  
  // provide a useful default summary string.
  def String toString() {
    "${comment} "+summary();
  }
}

/*
  This class will use a query that returns a list of sites that need to have a tool added to them.
  Currently the query and tool are hard coded but this could easily be generalized with a bit more time.
*/

class UpdateSiteWithTool {

  // Create 2 loggers.  The first is the normal Sakai log.  The second
  // is used just for recording performance metrics.  The loggers could be configured
  // to send these to a separate log file.  Since we are repurposing the log file
  // the logging methods are the normal error, warn, info, debug levels.   This 
  // uses warn as the level to use to print summary information.

  private static Log log = LogFactory.getLog("edu.umich.ctools.UpdateSitesWithTool");
  private static Log metric = LogFactory.getLog("metrics." + "edu.umich.ctools.UpdateSitesWithTool");

  // control tracing
  def verbose = 1;

  // sql db connection
  //  def db;

  /****************** Important variables, likely to be adjusted *************/

  // maximum number of sites to retrieve in a single query.
  // It should be fairly large for production.
  // def maxBatchSize = 2000;
  // def maxBatchSize = 100;
  // def maxBatchSize = 1000;
  def maxBatchSize = 20;


  // Limit on the number of batches of sites to process.  This is useful
  // mostly for dry run testing, where the query will return the same sites over
  // and over again as they are not updated.
  // def maxBatches = 10;
  // def maxBatches = 10;
  def maxBatches = 2;

  // starting hour and minute
  def startHour = 10;
  def startMin = 55;
  def startDay = Calendar.WEDNESDAY;
  // def startDay = Calendar.THURSDAY;


  // limit the number of times will check in the wait routine. 
  // This prevents waiting forever, but means the job will start regardless when the 
  // startCnt expires.
  // This will cover more than 3 days with a 10 minute wait between checks.
  def startCnt = 500;  

  // how long to sleep between time checks;
  def sleepSeconds = 10 * 60;

  /**************************************************************************/

  //  Do / don't actually do the update.
  Boolean dryRun = false;

  // Define the tool to be added along with the desired page name and tool name.
  def evalNames = ['toolRegistration':'sakai.rsf.evaluation', 'newPageName':"Teaching Questionnaires", 'toolName': "Teaching Questionnaires"];
  def wikiNames = ['toolRegistration':'sakai.rwiki', 'newPageName':'Wiki Tool page', 'toolName': 'Wiki Tool'];
  def dropboxNames = ['toolRegistration':'sakai.dropbox', 'newPageName':'dropbox', 'toolName': 'dropbox'];
  def pollNames = ['toolRegistration':'sakai.poll', 'newPageName':'Poll Page(added by script)', 'toolName': 'Poll tool (added by script)'];
  def discussionNames = ['toolRegistration':'sakai.discussion', 'newPageName':'Discussion Page(added by script)', 'toolName': 'Discussion tool (added by script)'];


  // Specify which tool configuration infomation to use.
  def toolDef = evalNames;

  // List of sites to ignore, e.g. ~admin

  // Per John Leasia, ignore these sites.
  def ignoreSites = [  '~admin','!user','!user.friend','!user.guest','!user.uniqname','!user.liteguest','~'];

  // Sql to return a list of candidate sites to be updated. (These sites are candidates since some might be returned
  // that will be excluded based on list of exception sites.)

  def candidateSitesSql = "select SITE_ID from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = ${toolDef.toolRegistration}) order by SITE_ID) where rownum <= ${maxBatchSize}";

  // Sql to count the total number of candidate sites.
  def countCandidateSitesSql = "select count(distinct SITE_ID) from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = ${toolDef.toolRegistration})";

  // Get the required Sakai services.  Avoid using covers if at all possible.
  def siteService = ComponentManager.get("org.sakaiproject.site.api.SiteService");
  def toolManager = ComponentManager.get("org.sakaiproject.tool.api.ToolManager");
  def sqlService = ComponentManager.get("org.sakaiproject.db.api.SqlService");
  def sessionManager = ComponentManager.get("org.sakaiproject.tool.api.SessionManager");

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

  /* *** internal variables *** */
  
  // The db connection obtained from Sakai.  This is kept explictly visible so that it can be returned to Sakai 
  // in a finally block
  //  def dbSql;
  def dbConnection; // The sakai connection
  def dbSql; // the Groovy sql object
  Boolean originalAutoCommit;

  /****************************
   Dispatch method.  
   Get the db connection and invoke the desired processing.
  ****************************/

  def  perform(String cmd) {

    def foundCmd = 0;
    log.info("********** UpdateSiteWithTool *************");
    log.info("cmd: ${cmd}");

    if (verbose) {
      settings(cmd);
    }

    try {

      dbSql = getDbConnection();
      //      dbConnection = sqlService.borrowConnection();
      // assert dbConnection != null;
      //      db = getDbViaConnection(dbConnection);

      if (cmd == 'count') {
	foundCmd = 1;
	countSites(dbSql);
      };

      if (cmd == 'process') {
	foundCmd = 1;
	// waitUntil(2,10); 	// wait until 2 am
	log.info("processing will wait until ${startDay} ${startHour} ${startMin}");
	waitUntil(startDay,startHour,startMin,startCnt);
	log.info("processing started");
	processSites(dbSql);
      }
      // This should be added back in when the command line processing is figured out.
      //     if (cmd == 'help' || (!foundCmd)) {
      //       //println ": arg is count (the number of remaining sites to process) or process (start processing the sites).";
      //     }
      summary();
    }
    finally {
      releaseDbConnection();
    }
    
  }

  def getDbConnection() {
    dbConnection = sqlService.borrowConnection();
    assert dbConnection != null;
    originalAutoCommit = dbConnection.getAutoCommit();
    log.debug("original auto commit: " + originalAutoCommit);
    dbConnection.setAutoCommit(false);
    //    def db = new Sql(dbConnection);
    dbSql = new Sql(dbConnection);
    assert dbSql != null; 
    return dbSql;
  }

  def releaseDbConnection() {
    //    dbSql.getConnection().autoCommit = originalAutoCommit;
    dbConnection.autoCommit = originalAutoCommit;
    sqlService.returnConnection(dbConnection);
  }

  // Method to open connection to db given that a connection
  // has been obtained (probably from Sakai).
  // A direct connection could be opened explicitly using
  // Sql.newInstance(<lots of connection information>), but that should NOT
  // be used in a real Sakai instance.

  Sql getDbViaConnection(connection) {
    def db = new Sql(connection);
    assert db != null; 

    log.debug("sites in batch (via connection):");
    //  db.eachRow(countCandidateSitesSql) { log.debug("* ${it.SITE_ID}") };
    return db;
  };

  
  /* ******** utility ********* */
  // Closure that will dump the settings for the run.
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

  // Log a summary of processing.
    def summary = {
      metric.info("number of batches: ${batchCnt}");
      metric.info("number of candidate sites: ${rowsProcessedInBatch}");
      metric.info("sites skipped: ${sitesSkipped}");
    };


  // closure to check if a site already contains the tool. 

  def toolAlreadyPlaced = { siteId, toolId ->
			    def siteEdit = siteService.getSite(siteId);
			    if (siteEdit.getToolForCommonId(toolId) != null) {
			      sitesWithExistingTool++;
			      return true;
			    }
			    return false;
			    
  };

  // Method to see if the specific site should be excluded based on
  // exception list.

  Boolean excludeSite(String siteId)  {
    return (ignoreSites.find {it == siteId} ? true : false);
  };

  // Provide a method to prevent any updates.
  Boolean isDryRun() { 
    return dryRun;
  };

  // Method to take a site and decide if it is eligible to be updated.
  Boolean siteEligibleForUpdate(String siteId) { 
    
    Boolean shouldUpdate = true;
    // on exception list?
    shouldUpdate = !excludeSite(siteId);
    // already contains the tool?
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

  // Testing note:  
  // Groovy is flexible enough that for testing you can just create an 
  // explicit list of sites to consider instead of using a db call to allow
  // mocking of the db results. The list can be used instead of the 
  // db variable.
  //def testSites = [["SITE_ID":"~c8a87abf-15fe-4d9f-a6af-5c28abd42c8b"]];

  // Method to count all eligible sites.
  // Time this query so that have some idea if it 
  // is really slow.
  void countSites(Sql db) {

    log.warn("countSites start");
    def siteCount = 0;
    def sw = new Stopwatch(comment:"count query:");
    sw.start();
    //* only getting 1 row back, the count.
    db.eachRow(countCandidateSitesSql) { queryRow ->
      sw.markEvent();
      log.warn("siteCount: ${queryRow[0]} (including special sites ignored later)");
    }
    sw.stop();
    log.warn(sw.toString());
  }

  // method to allow gross scheduling of additions.
  def waitUntil(waitDay,waitHour,waitMin,waitCnt) {
    log.warn("wait for: day: ${waitDay} waitHour: ${waitHour} waitMin: ${waitMin}");
    log.warn("sleep interval: ${sleepSeconds}");
    // def cnt = 50;
    while (waitCnt-- > 0) {
      // while(true) {
      def now = Calendar.getInstance();
      now.setTime(new Date());
      def day = now.get(Calendar.DAY_OF_WEEK);
      def hour = now.get(Calendar.HOUR_OF_DAY);
      def minute = now.get(Calendar.MINUTE);

      log.warn("current: day: ${day} hour: ${hour} min: ${minute}");

      if (waitDay == day && waitHour <= hour && waitMin <= minute) {
	//if (waitHour <= hour && waitMin <= minute) {
	log.warn("found start time");
	return;
      }
      //print ".";
      //log.warn("not sleeping!");
      // sleep is MS
      sleep sleepSeconds * 1000;
    }
  }

  // Process the list of eligable sites.

  void processSites(Sql db) {

    // bootstrap / halt flag
    def moreSitesToProcess = 1;
    log.debug("in processSites");

    def currentSession = sessionManager.getCurrentSession();
    log.warn("currentSession: "+currentSession);

    def updatedSite = false;

    def swAll = new Stopwatch(comment:"AddTool ${toolDef.toolRegistration} summary");
    swAll.start();

    // while there are more sites to process and haven't 
    // exceeded the processing limit.
    while(moreSitesToProcess && (batchCnt < maxBatches))  {
      currentSession.setActive();
      batchCnt++;
      log.debug("batchCnt: ${batchCnt}");
      rowsProcessedInBatch = 0;
      sitesAddedInBatch = 0;
      def swBatch = new Stopwatch(comment:"AddTool ${toolDef.toolRegistration} batch summary");
      swBatch.start();
      // run the candidate sql query and process each resulting site.
      db.eachRow(candidateSitesSql) { queryRow ->
	updatedSite = false;
	log.debug("processing site: ${queryRow.SITE_ID}");
	// testSites.each {queryRow -> // this line could be used for mocking.  See testing note above.
	log.debug("queryRow candidate: [${queryRow.SITE_ID}]");
	// mark that have found a candidate site both for the batch and for the whole run.
	swBatch.markEvent();
	swAll.markEvent();
	rowsProcessedInBatch++;

	if (siteEligibleForUpdate((String)queryRow.SITE_ID)) {
	  log.warn("processing site: ${queryRow.SITE_ID}");
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
      metric.info("rowsProcessedInBatch: ${rowsProcessedInBatch}");
      metric.info("sitesAddedInBatch: ${sitesAddedInBatch}");
      if (batchCnt > maxBatches) {
	sitesAddedInBatch = 0;
      }
      db.commit();
      swBatch.stop();
      // Record the performance of this batch.
      metric.warn(swBatch.toString());
      moreSitesToProcess = (sitesAddedInBatch > 0);
    }
    swAll.stop();
    // Record the performance of the whole run.
    metric.warn(swAll.toString());
  };
}
// end
