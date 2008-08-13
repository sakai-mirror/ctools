// List all sites
// $HeadURL$
// $Id$

// fundamental imports for Sakai

// Get the component manager to allow looking up the required services;
import org.sakaiproject.component.cover.ComponentManager
// Allow creating logs
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

private static Log metric = LogFactory.getLog("metrics." + "edu.umich.ctools.listSites.groovy");
private static Log log = LogFactory.getLog("edu.umich.ctools.listSites.groovy");

log.debug("listSites.groovy debug level log message");
log.info("listSites.groovy info level log message");
log.warn("listSites.groovy warn level log message");
log.error("listSites.groovy error level log message");

metric.debug("listSites.groovy debug level metric message");
metric.info("listSites.groovy info level metric message");
metric.warn("listSites.groovy warn level metric message");
metric.error("listSites.groovy error level metric message");

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

  // end
