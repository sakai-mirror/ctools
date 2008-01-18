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

/* Written by David Haines and Noah Botimer at the University of Michigan.
   This implements a web service that allows a single forum to be deleted via 
   a web service.  This is particularly useful if there are thousands of forums
   in a site and the number of forums prevents viewing the page (and ties up 
   the app server and database).

   To install it copy it to the ...../webapps/sakai-axis directory with the extension
   jws.  Developing with the java extension allows using the java tools in Eclipse.

   Note:
   This worked sucessfully for us at Michigan, but there are some considerations:
   - I added the comments after running the code, so if it doesn't compile that may
   be the problem.
   - The error handling is basically untested, so you should audit the results, or better yet
   fix the error handling.  Also test ahead of time on development data.

*/

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.sakaiproject.tool.api.Session;
import org.sakaiproject.site.api.Site;
import org.sakaiproject.site.api.SitePage;
import org.sakaiproject.site.api.ToolConfiguration;
import org.sakaiproject.tool.cover.SessionManager;
import org.sakaiproject.site.cover.SiteService;
import org.sakaiproject.component.cover.ComponentManager;

import org.apache.axis.AxisFault;

import org.sakaiproject.api.app.messageforums.MessageForumsForumManager;

import org.sakaiproject.api.app.messageforums.DiscussionForum;

import org.sakaiproject.thread_local.cover.ThreadLocalManager;

public class ForumDeleterWS {

//	private static final Log log = LogFactory.getLog(ForumDeleterWS.class);

	private final static  String CURRENT_PLACEMENT = "sakai:ToolComponent:current.placement";

	private static final  MessageForumsForumManager forumManager =
		(MessageForumsForumManager) ComponentManager.get(MessageForumsForumManager.class);

	private Session establishSession(String id) throws AxisFault 
	{
		Session s = SessionManager.getSession(id);

		if (s == null)
		{
			throw new AxisFault("Session "+id+" is not active");
		}
		s.setActive();
		SessionManager.setCurrentSession(s);
		return s;
	}
	
	public String deleteForumsTestConnection(String sessionId, String siteId, String pageId, String toolId, 
			String forumIds) throws AxisFault {
		try {
			Session s = establishSession(sessionId);

			//First, get the tool placement to fake the context
			//Site site = SiteService.getSite(siteId);
			//SitePage page = site.getPage(pageId);
			//ToolConfiguration tool = page.getTool(toolId);
			
			String status = "site: ["+siteId+"] session: "+s;
			return status;
		}
		catch (Exception e) {
			java.io.StringWriter sw = new java.io.StringWriter();
			e.printStackTrace(new java.io.PrintWriter(sw));
			throw new AxisFault(sw.toString());		
		}
	}
	
	public String deleteForumsTestArgs(String sessionId, String siteId, String pageId, String toolId, 
			String forumIds) throws AxisFault {
		try {
			Session s = establishSession(sessionId);

			//First, get the tool placement to fake the context
			Site site = SiteService.getSite(siteId);
			SitePage page = site.getPage(pageId);
			ToolConfiguration tool = page.getTool(toolId);
			
			String status = 
			"site: ["+siteId+site+"] "
			+"page: [" +pageId+page+"] " 
			+"tool: [" +toolId+tool+"] " 
			+"	 session: ["+s+"] ";
			
			String[] deleteIds = forumIds.split("\n");
			for (int i = 0; i < deleteIds.length; i++) {
				String forumId = deleteIds[i];
				status += "\nfid: ["+forumId+"]";
			}
			
			return status;
		}
		catch (Exception e) {
			java.io.StringWriter sw = new java.io.StringWriter();
			e.printStackTrace(new java.io.PrintWriter(sw));
			throw new AxisFault(sw.toString());		
		}
	}
	
	public String deleteForums(String sessionId, String siteId, String pageId, String toolId, 
			String forumIds) throws AxisFault {
		try {
			Session s = establishSession(sessionId);

			// This is necessary since the data access implementation looks up the context.
			// That is not a good idea since it may be called as a web service which has
			// no context.

			// Get the tool placement to fake the context.
			Site site = SiteService.getSite(siteId);
			SitePage page = site.getPage(pageId);
			ToolConfiguration tool = page.getTool(toolId);
			
			String status = 
			"site: ["+siteId+site+"] "
			+"page: [" +pageId+page+"] " 
			+"tool: [" +toolId+tool+"] " 
			+"	 session: ["+s+"] ";
			
			//Set the "current placement" to the tool from the right page, so getContextId() pulls the right info
			ThreadLocalManager.set(CURRENT_PLACEMENT, tool);
			
			String[] deleteIds = forumIds.split("\n");
			for (int i = 0; i < deleteIds.length; i++) {
				String forumId = deleteIds[i];
				status += "\nfid: ["+forumId+"]";
				DiscussionForum forum = (DiscussionForum) forumManager.getForumByUuid(forumId);
				status += "forum: "+forum;
				forumManager.deleteDiscussionForum(forum);
			}
			
			return status+"\n";
		}
		catch (Exception e) {
			java.io.StringWriter sw = new java.io.StringWriter();
			e.printStackTrace(new java.io.PrintWriter(sw));
			throw new AxisFault(sw.toString());		
		}
	}
}
