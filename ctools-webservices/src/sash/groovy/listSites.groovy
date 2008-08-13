// List all sites
// $HeadURL$
// $Id$

// Get the component manager to allow looking up the required services;
import org.sakaiproject.component.cover.ComponentManager

// Will need to use the site service.
import org.sakaiproject.site.api.SiteService
def siteService = ComponentManager.get("org.sakaiproject.site.api.SiteService");

// keep some statistics
def start = System.currentTimeMillis();
def  siteCnt = 0;
println "start time: "+start

// for each site print some information
siteService.getSites(SiteService.SelectionType.NON_USER, ["course","project"], null, null, null,null).each 
{ 
  siteCnt++;
  println  "title: [${it.title}], id: [${it.id}]";
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
