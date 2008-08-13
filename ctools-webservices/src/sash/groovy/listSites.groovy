// List all sites
// $HeadURL$
// $Id$

import org.sakaiproject.component.cover.ComponentManager
import org.sakaiproject.site.api.SiteService


start = System.currentTimeMillis()
  println "start time: "+start

  siteCnt = 0;

siteService = ComponentManager.get("org.sakaiproject.site.api.SiteService");
siteService.getSites(SiteService.SelectionType.NON_USER, ["course","project"], null, null, null,null).each 
{ 
  siteCnt++
    println  "title: [${it.title}], id: [${it.id}]"
}
//     {site ->
// 	    println "site: ".site;
//     }

  def stop = System.currentTimeMillis()
  println "end time: " + stop
  def elapsed = stop -start
  println "for "+siteCnt+" sites the elapsed time is: "+elapsed
  println "time per site: "+elapsed / siteCnt

  // end
