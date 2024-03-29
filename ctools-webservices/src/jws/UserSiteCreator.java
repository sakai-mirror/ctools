/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2008 The Regents of the University of Michigan.
 * 
 * Licensed under the Educational Community License, Version 1.0 (the "License"); 
 * you may not use this file except in compliance with the License. 
 * You may obtain a copy of the License at
 * 
 *      http://www.opensource.org/licenses/ecl1.php
 * 
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS, 
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
 * See the License for the specific language governing permissions and 
 * limitations under the License.
 *
 **********************************************************************************/

/**
  * UserSiteCreator.jws
  * @author botimer@umich.edu
  * @since 01/18/2008
  *
  * This simple web service allows us to give a list of provided usernames that
  * must each have internal user IDs either created or located and My Workspace
  * sites.  This allows injection of a tool into the My Workspace sites for all
  * users in the list, whether or not they have yet logged in.
  */

 /*
  Note: This version is, as yet, untested.
 */


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.sakaiproject.site.api.Site;
import org.sakaiproject.tool.api.Session;
import org.sakaiproject.user.api.User;

//Using covers for simplicity
import org.sakaiproject.tool.cover.SessionManager;
import org.sakaiproject.site.cover.SiteService;
import org.sakaiproject.user.cover.UserDirectoryService;

import java.util.Properties;
import org.apache.axis.AxisFault;

public class UserSiteCreator {

	private static final Log log = LogFactory.getLog(UserSiteCreator.class);

	private Session establishSession(String id) throws AxisFault 
	{
		Session s = SessionManager.getSession(id);

		if (s == null)
			throw new AxisFault("Session "+id+" is not active");
		s.setActive();
		SessionManager.setCurrentSession(s);
		return s;
	}

	private String createUsersAndSites(Session s, String usernames) throws AxisFault {
		Session s = establishSession(sessionId);			
		String callingUserId = s.getUserId();
		String callingUserEid = s.getUserEid();

		String status = "";
		try {
			for (String uniqname : usernames.split("\n")) {
				User u = UserDirectoryService.getUserByEid(uniqname);
				if (u == null) {
					status + = "Could not locate user: " + uniqname + "\n";
				}
				else {
					//We're electing to change ownership of the current session, rather than making new ones.
					//This is required because the BaseSiteService calls getCurrentSessionUserId().
					//Note the finally block restores the calling user to avoid impersonation.
					s.setUserId(u.getId());
					s.setUserEid(u.getEid());
					String siteId = "~" + u.getId();
					Site site = SiteService.getSite(siteId);
					String located = (site == null) ? "Could not locate" : "Located";
					status += located + " site (" + siteId + ") for user: " + u.getEid() + " (" + u.getId() + ")\n";					
				}
			}
		} catch (Exception e) {
			java.io.StringWriter sw = new java.io.StringWriter();
			sw.write("Processing log so far:\n");
			sw.write("======================\n");
			sw.write(status);
			sw.write("======================\n");			
			e.printStackTrace(new java.io.PrintWriter(sw));
			throw new AxisFault(sw.toString());		
		} finally {
			s.setUserId(callingUserId);
			s.setUserEid(callingUserEid);
		}
		return status;
	}
}
