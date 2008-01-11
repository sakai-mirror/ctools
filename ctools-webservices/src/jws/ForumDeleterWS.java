//import java.util.HashMap;
//import java.util.List;
//import java.util.Iterator;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

//import org.sakaiproject.tool.api.Tool;
import org.sakaiproject.tool.api.Session;
import org.sakaiproject.site.api.Site;
import org.sakaiproject.site.api.SitePage;
import org.sakaiproject.site.api.ToolConfiguration;
import org.sakaiproject.tool.cover.SessionManager;
import org.sakaiproject.site.cover.SiteService;
import org.sakaiproject.component.cover.ComponentManager;

//import java.util.Properties;
import org.apache.axis.AxisFault;

import org.sakaiproject.api.app.messageforums.MessageForumsForumManager;
//import org.sakaiproject.api.app.messageforums.BaseForum;
import org.sakaiproject.api.app.messageforums.DiscussionForum;

import org.sakaiproject.thread_local.cover.ThreadLocalManager;

public class ForumDeleterWS {

//	private static final Log log = LogFactory.getLog(ForumDeleterWS.class);
//	private   String siteId = "xxxx-234";
//	private   String pageId = "yyyy-123";
//	private   String toolId = "zzzz-123";
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

			//First, get the tool placement to fake the context
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
//
//			//Set the "current placement" to the tool from the right page, so getContextId() pulls the right info
//			ThreadLocalManager.set(CURRENT_PLACEMENT, tool);
//
//			String retval = "";
//			String[] deleteIds = forumIds.split("\n");
//			for (int i = 0; i < deleteIds.length; i++) {
//				String forumId = deleteIds[i];
//
//				//The cast is here because the UI typically uses the DiscussionForumManager, which does this exact call
//				//We're just skipping the middle man to get the DiscussionForum object required for the delete method
//				DiscussionForum forum = (DiscussionForum) forumManager.getForumByUuid(forumId);
//
//				//Delete the forum, letting the call stack hit the faked placement context
//				retval += "Deleting: " + forum.getTitle() + " (" + forum.getUuid() + ")\n";
//				//forumManager.deleteDiscussionForum(forum);
//			}
//			return retval;
//		} catch (Exception e) {
//			java.io.StringWriter sw = new java.io.StringWriter();
//			e.printStackTrace(new java.io.PrintWriter(sw));
//			throw new AxisFault(sw.toString());		
//		}
//	}

	public String deleteForumsOld(String sessionId, String siteId, String pageId, String toolId, 
			String forumIds) throws AxisFault {
		try {
			Session s = establishSession(sessionId);

			//First, get the tool placement to fake the context
			Site site = SiteService.getSite(siteId);
			SitePage page = site.getPage(pageId);
			ToolConfiguration tool = page.getTool(toolId);

			//Set the "current placement" to the tool from the right page, so getContextId() pulls the right info
			ThreadLocalManager.set(CURRENT_PLACEMENT, tool);

			String retval = "";
			String[] deleteIds = forumIds.split("\n");
			for (int i = 0; i < deleteIds.length; i++) {
				String forumId = deleteIds[i];

				//The cast is here because the UI typically uses the DiscussionForumManager, which does this exact call
				//We're just skipping the middle man to get the DiscussionForum object required for the delete method
				DiscussionForum forum = (DiscussionForum) forumManager.getForumByUuid(forumId);

				//Delete the forum, letting the call stack hit the faked placement context
				retval += "Deleting: " + forum.getTitle() + " (" + forum.getUuid() + ")\n";
				//forumManager.deleteDiscussionForum(forum);
			}
			return retval;
		} catch (Exception e) {
			java.io.StringWriter sw = new java.io.StringWriter();
			e.printStackTrace(new java.io.PrintWriter(sw));
			throw new AxisFault(sw.toString());		
		}
	}

}
