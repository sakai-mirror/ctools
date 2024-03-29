/**********************************************************************************
 * $URL:https://source.sakaiproject.org/svn/ctools/trunk/ctools-webservices/src/jws/CToolsScript.jws $
 * $Id:CToolsScript.jws 40579 2008-01-28 15:04:14Z dlhaines@umich.edu $
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

/*
 *   CToolsScript.jws - customized to add tool to my workspace with 1 call.
 * $HeadURL:https://source.sakaiproject.org/svn/ctools/trunk/ctools-webservices/src/jws/CToolsScript.jws $
 * $Id:CToolsScript.jws 40579 2008-01-28 15:04:14Z dlhaines@umich.edu $
 */

import java.util.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Iterator;
import java.util.Set;
import java.util.Collection;
import java.util.regex.*;

import org.sakaiproject.tool.api.Session;
import org.sakaiproject.tool.cover.SessionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.sakaiproject.authz.api.AuthzGroup;
import org.sakaiproject.authz.api.Role;
import org.sakaiproject.user.cover.UserDirectoryService;
import org.sakaiproject.tool.api.Tool;
import org.sakaiproject.site.api.ToolConfiguration;
import org.sakaiproject.site.api.Site;
import org.sakaiproject.site.api.SitePage;
import org.sakaiproject.user.api.UserEdit;
import org.sakaiproject.authz.cover.AuthzGroupService;
import org.sakaiproject.user.api.User;
import org.sakaiproject.tool.cover.ToolManager;
import org.sakaiproject.site.cover.SiteService;
import org.sakaiproject.authz.cover.SecurityService;
import org.sakaiproject.site.api.SiteService.SelectionType;
import org.sakaiproject.site.api.SiteService.SortType;

import java.util.Properties;
import org.apache.axis.AxisFault;

import org.sakaiproject.util.Xml;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

public class CToolsScript {

	private static final Log LOG = LogFactory.getLog(CToolsScript.class);

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

	public String checkSession(String id) {
		Session s = SessionManager.getSession(id);
		if (s == null)
		{
			return "null";
		}
		else
		{
			return id;
		}
	}

	public String addNewUser( String sessionid, String eid, String firstname, String lastname, String email, String type, String password) throws AxisFault
	{
		Session session = establishSession(sessionid);

		if (!SecurityService.isSuperUser())
		{
			LOG.warn("NonSuperUser trying to add accounts: " + session.getUserId());
			throw new AxisFault("NonSuperUser trying to add accounts: " + session.getUserId());
		}
		try {

			User addeduser = null;
			addeduser = UserDirectoryService.addUser(null, eid, firstname, lastname, email, password, type, null);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String addNewUser( String sessionid, String id ,String eid, String firstname, String lastname, String email, String type, String password) throws AxisFault
	{
		Session session = establishSession(sessionid);

		if (!SecurityService.isSuperUser())
		{
			LOG.warn("NonSuperUser trying to add accounts: " + session.getUserId());
			throw new AxisFault("NonSuperUser trying to add accounts: " + session.getUserId());
		}
		try {

			User addeduser = null;
			addeduser = UserDirectoryService.addUser(id, eid, firstname, lastname, email, password, type, null);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String removeUser( String sessionid, String eid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			UserEdit userEdit = null;
			String userid = UserDirectoryService.getUserByEid(eid).getId();
			userEdit = UserDirectoryService.editUser(userid);
			UserDirectoryService.removeUser(userEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String changeUserInfo( String sessionid, String eid, String firstname, String lastname, String email, String type, String password) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			UserEdit userEdit = null;
			String userid = UserDirectoryService.getUserByEid(eid).getId();
			userEdit = UserDirectoryService.editUser(userid);
			userEdit.setFirstName(firstname);
			userEdit.setLastName(lastname);
			userEdit.setEmail(email);
			userEdit.setType(type);
			userEdit.setPassword(password);
			UserDirectoryService.commitEdit(userEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String changeUserName( String sessionid, String eid, String firstname, String lastname) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			UserEdit userEdit = null;
			String userid = UserDirectoryService.getUserByEid(eid).getId();
			userEdit = UserDirectoryService.editUser(userid);
			userEdit.setFirstName(firstname);
			userEdit.setLastName(lastname);
			UserDirectoryService.commitEdit(userEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String changeUserEmail( String sessionid, String eid, String email) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			UserEdit userEdit = null;
			String userid = UserDirectoryService.getUserByEid(eid).getId();
			userEdit = UserDirectoryService.editUser(userid);
			userEdit.setEmail(email);
			UserDirectoryService.commitEdit(userEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String changeUserType( String sessionid, String eid, String type) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {
			UserEdit userEdit = null;
			String userid = UserDirectoryService.getUserByEid(eid).getId();
			userEdit = UserDirectoryService.editUser(userid);
			userEdit.setType(type);
			UserDirectoryService.commitEdit(userEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String changeUserPassword( String sessionid, String eid, String password) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			UserEdit userEdit = null;
			String userid = UserDirectoryService.getUserByEid(eid).getId();
			userEdit = UserDirectoryService.editUser(userid);
			userEdit.setPassword(password);
			UserDirectoryService.commitEdit(userEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String getUserEmail( String sessionid ) throws AxisFault
	{
		Session session = establishSession(sessionid);
		User user = UserDirectoryService.getCurrentUser();
		return user.getEmail();
	}


	public String getUserDisplayName( String sessionid ) throws AxisFault
	{
		Session session = establishSession(sessionid);
		User user = UserDirectoryService.getCurrentUser();
		return user.getDisplayName();
	}

	//	addNewRealm
	public String addNewAuthzGroup(String sessionid, String groupid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = null;
			authzgroup = AuthzGroupService.addAuthzGroup(groupid);
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	removeRealm
	public String removeAuthzGroup( String sessionid, String authzgroupid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			AuthzGroupService.removeAuthzGroup(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	addNewRoleToRealm
	public String addNewRoleToAuthzGroup( String sessionid, String authzgroupid, String roleid, String description) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			Role role = authzgroup.addRole(roleid);
			role.setDescription(description);
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	removeAllRolesFromRealm
	public String removeAllRolesFromAuthzGroup( String sessionid, String authzgroupid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			authzgroup.removeRoles();
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	removeRolefromRealm
	public String removeRoleFromAuthzGroup( String sessionid, String authzgroupid, String roleid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			authzgroup.removeRole(roleid);
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	addLockToRole
	public String allowFunctionForRole( String sessionid, String authzgroupid, String roleid, String function) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			Role role = authzgroup.getRole(roleid);
			role.allowFunction(function);
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	removeAllLocksFromRole
	public String disallowAllFunctionsForRole( String sessionid, String authzgroupid, String roleid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			Role role = authzgroup.getRole(roleid);
			role.disallowAll();
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	removeLockFromRole
	public String disallowFunctionForRole( String sessionid, String authzgroupid, String roleid, String function) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			Role role = authzgroup.getRole(roleid);
			role.disallowFunction(function);
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String setRoleDescription( String sessionid, String authzgroupid, String roleid, String description) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			Role role = authzgroup.getRole(roleid);
			role.setDescription(description);
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	addUserToRealmWithRole
	public String addMemberToAuthzGroupWithRole( String sessionid, String eid, String authzgroupid, String roleid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			String userid = UserDirectoryService.getUserByEid(eid).getId();
			authzgroup.addMember(userid,roleid,true,false);
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	removeUserFromRealm
	public String removeMemberFromAuthzGroup( String sessionid, String eid, String authzgroupid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			String userid = UserDirectoryService.getUserByEid(eid).getId();
			authzgroup.removeMember(userid);
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	removeAllUsersFromRealm
	public String removeAllMembersFromAuthzGroup( String sessionid, String authzgroupid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup realmEdit = AuthzGroupService.getAuthzGroup(authzgroupid);
			realmEdit.removeMembers();
			AuthzGroupService.save(realmEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	//	setRoleForRealmMaintenance
	public String setRoleForAuthzGroupMaintenance( String sessionid, String authzgroupid, String roleid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			AuthzGroup authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
			authzgroup.setMaintainRole(roleid);
			AuthzGroupService.save(authzgroup);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String addMemberToSiteWithRole(String sessionid, String siteid, String eid, String roleid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {
			Site site = SiteService.getSite(siteid);
			String userid = UserDirectoryService.getUserByEid(eid).getId();
			site.addMember(userid,roleid,true,false);
			SiteService.save(site);
		}
		catch (Exception e) {
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String addNewSite( String sessionid, String siteid, String title, String description, String shortdesc, String iconurl, String infourl, boolean joinable, String joinerrole, boolean published, boolean publicview, String skin, String type) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			Site siteEdit = null;
			siteEdit = SiteService.addSite(siteid, type);
			siteEdit.setTitle(title);
			siteEdit.setDescription(description);
			siteEdit.setShortDescription(shortdesc);
			siteEdit.setIconUrl(iconurl);
			siteEdit.setInfoUrl(infourl);
			siteEdit.setJoinable(joinable);
			siteEdit.setJoinerRole(joinerrole);
			siteEdit.setPublished(published);
			siteEdit.setPubView(publicview);
			siteEdit.setSkin(skin);
			siteEdit.setType(type);
			SiteService.save(siteEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}


	public String removeSite( String sessionid, String siteid) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			Site siteEdit = null;
			siteEdit = SiteService.getSite(siteid);
			SiteService.removeSite(siteEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String copySite( String sessionid, String siteidtocopy, String newsiteid, String title, String description, String shortdesc, String iconurl, String infourl, boolean joinable, String joinerrole, boolean published, boolean publicview, String skin, String type) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			Site site = SiteService.getSite(siteidtocopy);
			Site siteEdit = SiteService.addSite(newsiteid, site);
			siteEdit.setTitle(title);
			siteEdit.setDescription(description);
			siteEdit.setShortDescription(shortdesc);
			siteEdit.setIconUrl(iconurl);
			siteEdit.setInfoUrl(infourl);
			siteEdit.setJoinable(joinable);
			siteEdit.setJoinerRole(joinerrole);
			siteEdit.setPublished(published);
			siteEdit.setPubView(publicview);
			siteEdit.setSkin(skin);
			siteEdit.setType(type);
			SiteService.save(siteEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	public String addNewPageToSite( String sessionid, String siteid, String pagetitle, int pagelayout) throws AxisFault
	{
		Session session = establishSession(sessionid);

		try {

			Site siteEdit = null;
			SitePage sitePageEdit = null;
			siteEdit = SiteService.getSite(siteid);
			sitePageEdit = siteEdit.addPage();
			sitePageEdit.setTitle(pagetitle);
			sitePageEdit.setLayout(pagelayout);
			SiteService.save(siteEdit);

		}
		catch (Exception e) {  
			return e.getClass().getName() + " : " + e.getMessage();
		}
		return "success";
	}

	/*
	 *  Add a page and tool to a user myworkspace.  The complication is that don't have the site id, only the user id.
	 *  This can be done with muliple WS calls per user but that gets slow.  This bundles all the calls for one user
	 *  into one method.
	 * - It doesn't check to see if the tool already exists.  If it does it adds it again.
	 * - It doesn't work if the user hasn't logged in and doesn't have a user myworkspace.
	 *  This returns a string with information about the addition.  It exits with an appropriate 
	 * string when ever it has an error.
	 *
	 */

	public String addToolToUserMyWorkspace( String sessionid, String eid, String pagetitle, int pagelayout,
			String toolTitle, String toolId, String layoutHints, Boolean deleteOldTool) throws AxisFault
			{
			

		// Need to work some of the error handling to here from the perl calling scripts.
		// Can the compiled patterns be static final, so don't recompile every time?
		Pattern exceptionPattern = Pattern.compile("exception",Pattern.CASE_INSENSITIVE);
		Pattern successPattern = Pattern.compile("success",Pattern.CASE_INSENSITIVE);
		Pattern idUnusedException = Pattern.compile("IdUnusedException",Pattern.CASE_INSENSITIVE);
		String errorResult = "eid: "+eid+" ";
			
		// get the user myworkspace
		String siteId = resolveUserMyWorkspaceSiteId(eid);
		Matcher exceptionMatcher = exceptionPattern.matcher(siteId);
		if (exceptionMatcher.find()) {
			LOG.warn(errorResult+ " siteId failure: ["+siteId+"]");
			return errorResult + " siteError: "+siteId; 
		}

		String resultPageDelete = "";
		if (deleteOldTool) {
			resultPageDelete = removePageFromSite(sessionid,siteId,pagetitle);
			// if can't delete then still add.  Most likely that there was no
			// old version of the tool.
			// LOG.warn(error_result + " try to delete old version of tool: "+resultPageDelete);
		}

		// add the page
		String resultPageAdd = addNewPageToSite(sessionid,siteId,pagetitle,pagelayout);
		Matcher pageSuccessMatcher = successPattern.matcher(resultPageAdd);
		Matcher pageIdUnknownMatcher = idUnusedException.matcher(resultPageAdd);
		if (!pageSuccessMatcher.find()) {
			LOG.warn(errorResult+" page add failure: ["+resultPageAdd+"]");
			errorResult += "-page. ";
			if (pageIdUnknownMatcher.find()) {
				errorResult += " never logged in?";
			}
			return errorResult;
		}
			
		String resultToolAdd = addNewToolToPage(sessionid,siteId,pagetitle,toolTitle,toolId,layoutHints);
		Matcher toolAddSuccess = successPattern.matcher(resultToolAdd);

		LOG.warn("resultToolAdd: "+resultToolAdd);
		if (!toolAddSuccess.find()) {
			LOG.warn(errorResult+" did not find: [success] in string: ["+resultToolAdd+"]");
			return errorResult += "-tool not added.";
		}

			

		String returnString = "args: "+sessionid
		+"|" +eid
		+ " [site:"+ siteId +"]"
		+"|" +pagetitle
		+"|" +pagelayout
		+ "[page: "+resultPageAdd +"]"
		+"|" +toolTitle
		+"|" +toolId
		+"|" +layoutHints
		+"[tool: "+resultToolAdd+"]"
		;

		LOG.warn("returnString: "+returnString);
		return returnString;
			//}



//public String deletePageFromUserMyWorkspace( String sessionid, String eid, String pagetitle) throws AxisFault
//{

//// Need to work some of the error handling to here from the perl calling scripts.
//// Can the compiled patterns be static final, so don't recompile every time?
//Pattern exceptionPattern = Pattern.compile("exception",Pattern.CASE_INSENSITIVE);
//Pattern successPattern = Pattern.compile("success",Pattern.CASE_INSENSITIVE);
////	 Pattern idUnusedException = Pattern.compile("IdUnusedException",Pattern.CASE_INSENSITIVE);
//String errorResult = "eid: "+eid+" ";

//// get the user myworkspace
//String siteId = resolveUserMyWorkspaceSiteId(eid);
//Matcher exceptionMatcher = exceptionPattern.matcher(siteId);
//if (exceptionMatcher.find()) {
//LOG.warn(errorResult+ " siteId failure: ["+siteId+"]");
//return errorResult + " siteError: "+siteId; 
//}

//// delete the page
////String resultPageAdd = addNewPageToSite(sessionid,siteId,pagetitle,pagelayout);

//Matcher pageSuccessMatcher = successPattern.matcher(resultPageDelete);

//if (!pageSuccessMatcher.find()) {
//LOG.warn(errorResult+" page delete failure: ["+resultPageAdd+"]");
//errorResult += "-page. ";
//return errorResult;
//}

//String resultToolAdd = addNewToolToPage(sessionid,siteId,pagetitle,toolTitle,toolId,layoutHints);
//Matcher toolAddSuccess = successPattern.matcher(resultToolAdd);

//LOG.warn("resultToolAdd: "+resultToolAdd);
//if (!toolAddSuccess.find()) {
//LOG.warn(errorResult+" did not find: [success] in string: ["+resultToolAdd+"]");
//return errorResult += "-tool not added.";
//}



//String returnString = "args: "+sessionid
//+"|" +eid
//+ " [site:"+ siteId +"]"
//+"|" +pagetitle
//+"|" +pagelayout
//+ "[page: "+resultPageAdd +"]"
//+"|" +toolTitle
//+"|" +toolId
//+"|" +layoutHints
//+"[tool: "+resultToolAdd+"]"
//;

//LOG.warn("returnString: "+returnString);
//return returnString;
//}

/* Wrap calls for addToolToUserMyWorkspace to allow operating on lists.
 * of users.
 */

//public List<String> addToolToUserMyWorkspaceList( String sessionid, List<String> eids, String pagetitle, int pagelayout,
//String toolTitle, String toolId, String layoutHints) throws AxisFault
//{
//String result = "";

//for (String eid : eids) {
//LOG.warn("add tool for "+eid;
//result += addToolToUserMyWorkspace(sessionid, eid, pagetitle,pagelayout,toolTitle,toolId,layoutHints)+"\n";
//}
//LOG.warn("add list result: "+result;)
//return result;
//}


public String getUserMyWorkspaceSiteId(String sessionid, String eid) throws AxisFault
{
	Session s = establishSession(sessionid);

	String result = resolveUserMyWorkspaceSiteId(eid);

	return result;
}

public String getUserMyWorkspaceSiteIdList(String sessionid, List<String> eids) throws AxisFault
{
	Session s = establishSession(sessionid);
	String result = "";

	for (String eid : eids) {
		result += resolveUserMyWorkspaceSiteId(eid);
	}

	return result;
}


private String resolveUserMyWorkspaceSiteId(String eid) throws AxisFault
{

	String result = "";

	try {
		String userid = UserDirectoryService.getUserByEid(eid).getId();
		if (userid != null)
			result = "~"+userid;
	}
	catch (Exception e)
	{
		result = "Exception:" +e;
	}

	return result;
}

///////////

public String removePageFromSite( String sessionid, String siteid, String pagetitle) throws AxisFault
{
	Session session = establishSession(sessionid);

	try {

		Site siteEdit = null;
		siteEdit = SiteService.getSite(siteid);
		List pageEdits = siteEdit.getPages();
		for (Iterator i = pageEdits.iterator(); i.hasNext();)
		{
			SitePage pageEdit = (SitePage) i.next();
			if (pageEdit.getTitle().equals(pagetitle))
				siteEdit.removePage(pageEdit);
		}
		SiteService.save(siteEdit);

	}
	catch (Exception e) {  
		return e.getClass().getName() + " : " + e.getMessage();
	}
	return "success";
}



public String addNewToolToPage( String sessionid, String siteid, String pagetitle, String tooltitle, String toolid, String layouthints) throws AxisFault
{
	Session session = establishSession(sessionid);

	try {

		Site siteEdit = SiteService.getSite(siteid);
		List pageEdits = siteEdit.getPages();
		for (Iterator i = pageEdits.iterator(); i.hasNext();)
		{
			SitePage pageEdit = (SitePage) i.next();
			if (pageEdit.getTitle().equals(pagetitle))
			{
				ToolConfiguration tool = pageEdit.addTool();
				Tool t = tool.getTool();

				tool.setTool(toolid, ToolManager.getTool(toolid));
				tool.setTitle(tooltitle);
				//toolEdit.setTitle(tooltitle);
				//toolEdit.setToolId(toolid);
				//toolEdit.setLayoutHints(layouthints);
			}
		}
		SiteService.save(siteEdit);

	}
	catch (Exception e) {  
		return e.getClass().getName() + " : " + e.getMessage();
	}
	return "success";
}



public String addConfigPropertyToTool( String sessionid, String siteid, String pagetitle, String tooltitle, String propname, String propvalue) throws AxisFault
{
	Session session = establishSession(sessionid);

	try {

		Site siteEdit = SiteService.getSite(siteid);
		List pageEdits = siteEdit.getPages();
		for (Iterator i = pageEdits.iterator(); i.hasNext();)
		{
			SitePage pageEdit = (SitePage) i.next();
			if (pageEdit.getTitle().equals(pagetitle))
			{
				List toolEdits = pageEdit.getTools();
				for (Iterator j = toolEdits.iterator(); j.hasNext();)
				{
					ToolConfiguration tool = (ToolConfiguration) j.next();
					Tool t = tool.getTool();
					if (tool.getTitle().equals(tooltitle))
					{
						Properties propsedit = tool.getPlacementConfig();
						propsedit.setProperty(propname, propvalue);
					}
				}
			}
		}
		SiteService.save(siteEdit);

	}
	catch (Exception e) {  
		return e.getClass().getName() + " : " + e.getMessage();
	}
	return "success";
}

//checkForUser(): a call to check for an existing user
public boolean checkForUser(String sessionid, String eid) throws AxisFault
{
	Session s = establishSession(sessionid);

	try {
		User u = null;
		String userid = UserDirectoryService.getUserByEid(eid).getId();
		u = UserDirectoryService.getUser(userid);
		if (u != null)
			return true;
		else
			return false;
	}
	catch (Exception e)
	{
		return false;
	}
}

//checkForSite(): a call to check for an existing site
public boolean checkForSite(String sessionid, String siteid) throws AxisFault
{
	Session s = establishSession(sessionid);

	try {
		Site site = null;
		site = SiteService.getSite(siteid);
		if (site != null)
			return true;
		else
			return false;
	}
	catch (Exception e)
	{
		return false;
	}
}

//checkForUserInRealmWithRole
public boolean checkForMemberInAuthzGroupWithRole(String sessionid, String eid, String authzgroupid, String role) throws AxisFault
{
	Session s = establishSession(sessionid);

	try {
		AuthzGroup authzgroup = null; 
		authzgroup = AuthzGroupService.getAuthzGroup(authzgroupid);
		if (authzgroup == null)
			return false;
		else {
			String userid = UserDirectoryService.getUserByEid(eid).getId();
			return authzgroup.hasRole(userid, role);
		}
	}
	catch (Exception e) {
		return false;
	}
}

//Return XML document listing all sites user has read or write access
public String getSitesUserCanAccess(String sessionid)
throws AxisFault
{
	Session s = establishSession(sessionid);

	try 
	{
		List allSites = SiteService.getSites(SelectionType.ACCESS, null, null,
				null, SortType.TITLE_ASC, null);
		List moreSites = SiteService.getSites(SelectionType.UPDATE, null, null,
				null, SortType.TITLE_ASC, null);

		if ( (allSites == null || moreSites == null) ||
				(allSites.size() == 0 && moreSites.size() == 0) )
			return "<list/>";

		// combine two lists
		allSites.addAll( moreSites );

		Document dom = Xml.createDocument();
		Node list = dom.createElement("list");
		dom.appendChild(list);

		for (Iterator i = allSites.iterator(); i.hasNext();)
		{
			Site site = (Site)i.next();
			Node item = dom.createElement("item");
			Node siteId = dom.createElement("siteId");
			siteId.appendChild( dom.createTextNode(site.getId()) );
			Node siteTitle = dom.createElement("siteTitle");
			siteTitle.appendChild( dom.createTextNode(site.getTitle()) );

			item.appendChild(siteId);
			item.appendChild(siteTitle);
			list.appendChild(item);
		}

		return Xml.writeDocumentToString(dom);
	}
	catch (Exception e) 
	{
		return "<exception/>";
	}
}

}
