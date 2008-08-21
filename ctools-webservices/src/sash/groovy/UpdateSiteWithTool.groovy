// $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/ctools-webservices/src/sash/groovy/testDbSql.groovy $
// $Id: testDbSql.groovy 50826 2008-08-17 19:17:33Z dlhaines@umich.edu $

// Much of this code is based on code from dmccallum.

// checkin comment:

// code to add tool to sites returned from an sql query.

import groovy.sql.Sql;
import org.sakaiproject.component.cover.ComponentManager
import org.sakaiproject.site.api.SiteService;

class UpdateSiteWithTool {

  // sql db connection
  def db;

  // maximum number of batchs to do.
  def maxBatchSize = 5;

  // which tool to look for?
  def toolRegistration = "sakai.rsf.evaluation";

  def properties = [myURL:"jdbc:oracle:thin:@localhost:12439:SAKAIDEV", user:"dlhaines", password:"dlhaines", dbdriver:"oracle.jdbc.driver.OracleDriver"];

  Boolean dryRun = true;

  def candidateSitesSql = "select SITE_ID from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = '${toolRegistration}') order by SITE_ID) where rownum <= ${maxBatchSize}"
  //  def candidateSitesSql = "select * from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = '${toolRegistration}') order by SITE_ID) where rownum <= ${maxBatchSize}"
    //  def candidateSitesSql = "select * from (select distinct SITE_ID from SAKAI_SITE_TOOL where SITE_ID like '~%'and SITE_ID not in (select SITE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'sakai.rsf.evaluation') order by SITE_ID) where rownum <= ${maxBatchSize}"

    // List of sites to ignore, e.g. ~admin

    def ignoreSites = [ 'a', 'b', '~admin'];

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
  def sitesWithTool = 0;

  // max batches (Useful if testing and want to break the eternal update loop).
  def maxBatches = 10;

  // get the required Sakai services
  def siteService = ComponentManager.get("org.sakaiproject.site.api.SiteService");
  def toolManager = ComponentManager.get("org.sakaiproject.tool.api.ToolManager");
  def sqlService = ComponentManager.get("org.sakaiproject.db.api.SqlService");
  
  /****************************
   Main method of script
  ****************************/

  def  main(String[] args) {
    println "HOWDY";
    settings(args);
    // args.each{println it};
    db = getDb();
    println "db ${db}";
    processSites(db);
    summary();
  }


  def settings = {args	->

		  println "settings:\ndate: ${ new Date() }";

		  args.each{println "arg: ${it}"};
    

		  println "* tool registration: [${toolRegistration}]";		  
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
      // println "total sites updated: ${totalSitesUpdated}";
    }

    // Method to open connection to db.
      Sql getDb() {
	println "about to setup db";
	println "site query: [$candidateSitesSql}";
	def db = Sql.newInstance(properties.myURL, properties.user, 
				 properties.password,properties.dbdriver);

	db.eachRow(candidateSitesSql) { println it.SITE_ID }
	return db;
      };

  // closure to check if the site already contains the tool
  def toolAlreadyPlaced = { siteId, toolId ->
			    def siteEdit = siteService.getSite(siteId) // siteId?
			    //			    if (siteId.getToolForCommonId(toolId) != null) {
			    if (siteEdit.getToolForCommonId(toolId) != null) {
			      sitesWithExistingTool++;
			      return true;
			    }
			    return false;
			    
  };

  // closure to see if the site should be ignored

  Boolean excludeSite(String siteId)  {
    println "eS: siteId: {$siteId}"; 
    return (ignoreSites.find {println "ignore: [${it}] [${siteId}]";it == siteId} ? true : false);
  };

  // Will we allow any updates?
  Boolean isDryRun() { 
    return dryRun;
  };

  // closure to take a site and decide if if it should be updated.
  //  def shouldUpdateSite = { site ->
  Boolean shouldUpdateSite(String siteId) { 
    
    //    println "sUS: siteId: ${siteId}";
    Boolean shouldUpdate = true;
    shouldUpdate = !excludeSite(siteId);
    //    println "sUS: after excludeSite: ${shouldUpdate}";
    if (shouldUpdate) {
      shouldUpdate =  !toolAlreadyPlaced(siteId,toolRegistration);
    }
    println "sUS: before return: ${shouldUpdate} for site: ${siteId}";
    
    return shouldUpdate;
    //    return (! (   
    //	       excludeSite(site)
    //	       || toolAlreadyPlaced(site,toolId)
    //		  ));
  };

  // add the tool to the site.
  //  def placeTool = {site, toolId, pageName ->
  def placeTool = {siteId, toolId, pageName ->
		   siteEdit = siteService.getSite(site.id) // siteId?
		   sitePageEdit = siteEdit.addPage()
		   sitePageEdit.setTitle(pageName)
		   sitePageEdit.setLayout(0)
		   toolConfig = sitePageEdit.addTool()
		   toolConfig.setTool(toolId, toolManager.getTool(toolId))
		   toolConfig.setTitle(toolName)
		   siteService.save(siteEdit)
  };

  void processSites(Sql db) {

    //  loop over lists of some candidate sites to ensure all sites are processed
    // then loop over each list to process each site.

    // bootstrap / halt flag
    def moreSitesToProcess = 1;
    //    def totalSitesUpdated = 0;


    while(moreSitesToProcess && (batchCnt < maxBatches))  {
      batchCnt++;
      println "batchCnt: ${batchCnt}";
      rowsProcessedInBatch = 0;
      db.eachRow(candidateSitesSql) { queryRow ->
	println "queryRow site id: [${queryRow.SITE_ID}]";
	rowsProcessedInBatch++;
	if (shouldUpdateSite((String)queryRow.SITE_ID)) {
	  println "processing site: ${queryRow}";
	  if (!isDryRun()) {
	    placeTool(queryRow.SITE_ID,toolId,pageName);
	    totalSitesUpdated++;
	  }
	}
	if (!shouldUpdateSite(queryRow.SITE_ID)) {
	  sitesSkipped++;
	}
	println "totalSitesUpdated: ${totalSitesUpdated}";
	println "${rowsProcessedInBatch}";
	/*
	  if (shouldUpdateSite(siteId)) {

	  totalSitesUpdated++;
	  }
	  else {
	  sitesSkipped++;
	  }
	*/
      }
      if (batchCnt > maxBatches) {
	rowsProcessedInBatch = 0;
      }
      println "rowsProcessedInBatch: ${rowsProcessedInBatch}";
      moreSitesToProcess = (rowsProcessedInBatch > 0);
    }
    //    println "totalSitesUpdated: ${totalSitesUpdated}";
  };
}
// end

