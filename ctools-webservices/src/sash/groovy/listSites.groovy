// List all sites
// $HeadURL$
// $Id$

def sleepTime=5000;
def version = "$Id:$";
// Get the component manager to allow looking up the required services;
import org.sakaiproject.component.cover.ComponentManager

// Will need to use the site service.
import org.sakaiproject.site.api.SiteService
def siteService = ComponentManager.get("org.sakaiproject.site.api.SiteService");

println version;
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
