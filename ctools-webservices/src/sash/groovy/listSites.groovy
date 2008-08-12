// List all sites
// $HeadURL:$
// $Id:$

import org.sakaiproject.component.cover.ComponentManager
import org.sakaiproject.site.api.SiteService

    siteService = ComponentManager.get("org.sakaiproject.site.api.SiteService");
    siteService.getSites(SiteService.SelectionType.NON_USER, ["course","project"], null, null, null,null).each 
    { println  "title: [${it.title}], id: [${it.id}]"
	    }
//     {site ->
// 	    println "site: ".site;
//     }

// end
