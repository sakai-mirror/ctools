/**********************************************************************************
* $URL$
* $Id$
***********************************************************************************
*
* Copyright (c) 2003, 2004, 2005 The Regents of the University of Michigan, Trustees of Indiana University,
*                  Board of Trustees of the Leland Stanford, Jr., University, and The MIT Corporation
* 
* Licensed under the Educational Community License Version 1.0 (the "License");
* By obtaining, using and/or copying this Original Work, you agree that you have read,
* understand, and will comply with the terms and conditions of the Educational Community License.
* You may obtain a copy of the License at:
* 
*      http://cvs.sakaiproject.org/licenses/license_1_0.html
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
* AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
* DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
**********************************************************************************/

// package
package org.sakaiproject.eventwatcher;

// imports
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Observable;
import java.util.Observer;
import java.util.Set;
import java.util.Vector;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.authz.api.AuthzGroup;
import org.sakaiproject.authz.api.Role;
import org.sakaiproject.authz.cover.AuthzGroupService;
import org.sakaiproject.component.cover.ServerConfigurationService;
import org.sakaiproject.entity.api.Reference;
import org.sakaiproject.entity.cover.EntityManager;
import org.sakaiproject.event.api.Event;
import org.sakaiproject.event.api.EventTrackingService;
import org.sakaiproject.event.cover.UsageSessionService;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.util.SubjectAffiliates;
import org.sakaiproject.thread_local.cover.ThreadLocalManager;
import org.sakaiproject.tool.api.Session;
import org.sakaiproject.tool.cover.SessionManager;
import org.sakaiproject.user.api.User;
import org.sakaiproject.user.cover.UserDirectoryService;
import org.sakaiproject.util.StringUtil;
import org.sakaiproject.util.api.umiac.UmiacClient;
import org.sakaiproject.site.api.SiteService;
//import org.sakaiproject.util.java.StringUtil;

/**
* <p>%%%</p>
* 
* @author University of Michigan, Sakai Software Development Team
* @version $Revision$
*/
public class EventWatcher implements Observer
{
	
	private static Log log = LogFactory.getLog(EventWatcher.class);
	
	private static String FLAG_FROM_MEMBERSHIP_UPDATE = "flag_from_membership_update";
	
	private static String AFFILIATE_ROLE = "Affiliate";
	
	/*******************************************************************************
	* Dependencies and their setter methods
	*******************************************************************************/

	/** Dependency: event tracking service */
	protected EventTrackingService m_eventTrackingService = null;

	/**
	 * Dependency: event tracking service.
	 * @param service The event tracking service.
	 */
	public void setEventTrackingService(EventTrackingService service)
	{
		m_eventTrackingService = service;
	}

	/*******************************************************************************
	* Init and Destroy
	*******************************************************************************/
	/** affiliates */
	protected Vector<SubjectAffiliates> m_affiliates = null;
	
	/** able to update url in umiac? */
	protected boolean m_umiacUpdateUrl = false;
	
	/**
	 * Final initialization, once all dependencies are set.
	 */
	public void init()
	{
		try
		{
			log.warn(this);
			log.warn(m_eventTrackingService);
			// start watching the events - only those generated on this server, not those from elsewhere
			m_eventTrackingService.addLocalObserver(this);

			// read affiliates info
			setupSubjectAffiliates();
			
			// check the setting of umiac.updateUrl, default to be false unless set otherwise
			m_umiacUpdateUrl = ServerConfigurationService.getBoolean("umiac.updateUrl", false);
			
			log.info(this +".init()");
		}
		catch (Throwable t)
		{
			log.warn(this +".init(): ", t);
		}
	}

	/**
	* Returns to uninitialized state.
	*/
	public void destroy()
	{
		// done with event watching
		m_eventTrackingService.deleteObserver(this);

		log.info(this +".destroy()");
	}

	/*******************************************************************************
	* Observer implementation
	*******************************************************************************/
	/** My UMIAC client interface. */
	
	private UmiacClient m_umiac;

	public void setUmiac(UmiacClient m_umiac) {
		this.m_umiac = m_umiac;
	}

	public UmiacClient getUmiac() {
		return m_umiac;
	}
	
	/**
	* This method is called whenever the observed object is changed. An
	* application calls an <tt>Observable</tt> object's
	* <code>notifyObservers</code> method to have all the object's
	* observers notified of the change.
	*
	* default implementation is to cause the courier service to deliver to the
	* interface controlled by my controller.  Extensions can override.
	*
	* @param   o     the observable object.
	* @param   arg   an argument passed to the <code>notifyObservers</code>
	*                 method.
	*/
	public void update(Observable o, Object arg)
	{
		// arg is Event
		if (!(arg instanceof Event))
			return;
		Event event = (Event) arg;
		Session session = SessionManager.getCurrentSession();
		
		// check the event function against the functions we have notifications watching for
		String function = event.getEvent();

		if (function.equals(SiteService.SECURE_UPDATE_SITE_MEMBERSHIP))
		{
			session.setAttribute(FLAG_FROM_MEMBERSHIP_UPDATE, Boolean.TRUE);
		}
		else if (function.equals(AuthzGroupService.SECURE_UPDATE_AUTHZ_GROUP) || function.equals(AuthzGroupService.SECURE_REMOVE_AUTHZ_GROUP))
		{
			Reference ref = EntityManager.newReference(event.getResource());
			String url = ServerConfigurationService.getPortalUrl() + ref.getId();
			
			// if there any section assoicated with the site?
			Vector<String> sectionsWithUrl = m_umiac.getUrlSections(url);
			
			if (function.equals(AuthzGroupService.SECURE_REMOVE_AUTHZ_GROUP))
			{
				// remove site url from any section in sectionWithUrl
				for (int i=0; sectionsWithUrl != null && i<sectionsWithUrl.size(); i++)
				{
					updateGroupUrl("-", (String) sectionsWithUrl.get(i));
				}
			}
			else
			{
				// this is the current realm reference
				if (ThreadLocalManager.get("current.event.resource.ref") == null)
				{
					ThreadLocalManager.set("current.event.resource.ref", ref);
					try
					{
						String realmId = ref.getId();
						AuthzGroup r = AuthzGroupService.getAuthzGroup(realmId);
						
						String[] providerIds = m_umiac.unpackId(r.getProviderGroupId());
						List<String> providerIdsList = new Vector<String>();
						if (providerIds != null)
						{
							providerIdsList = new ArrayList<String>(Arrays.asList(providerIds));
						}
						
						// get the provider subject list
						List<String> providerIdSubjectList = getProviderSubjectList(providerIdsList);
						
						// update affiliates
						// if the realm.upd was generated during the site participant change, no need to update affiliates.
						if (session.getAttribute(FLAG_FROM_MEMBERSHIP_UPDATE) == null)
						{
							// update affiliates 1:  remove affiliates for dropped provider
							removeSubjectAffiliates(realmId, r, providerIdSubjectList);
							
							// update affiliates 2: add affiliates for added provider
							addSubjectAffliates(providerIdsList, realmId);
						}
						else
						{
							// reset flag
							session.removeAttribute(FLAG_FROM_MEMBERSHIP_UPDATE);
						}
						
						// update the url 1: remove site url for any dropped provider
						for (int i=0; sectionsWithUrl != null && i<sectionsWithUrl.size(); i++)
						{
							String section = (String) sectionsWithUrl.get(i);
							if (!providerIdsList.contains(section))
							{
								// remove site url from any section in sectionWithUrl but not inside providerIds
								updateGroupUrl("-", section);
							}
						}
						// update the url 2: add site url for all added provider
						for (int i=0; i<providerIdsList.size(); i++)
						{
							String providerId = (String) providerIdsList.get(i);
							
							if (sectionsWithUrl == null || !sectionsWithUrl.contains(providerId))
							{
								// for those sections inside provider id list but not marked with site url, update them with site url
								updateGroupUrl(url, providerId);
							}
						}
					}
					catch (Exception e)
					{
						log.warn(this + ".update:" + e.getMessage() + ": " + event.getResource());
					}
					
					// reset
					ThreadLocalManager.set("current.event.resource.ref", null);
				}
			}
		}
	} // update

	/**
	 * update the group url
	 * @param url
	 * @param providerId
	 */
	private void updateGroupUrl(String url, String providerId) {
		List<String> pIdList = new ArrayList<String>(Arrays.asList(providerId.split(",")));
		//year,term,campus,subject,course,section
		if (pIdList.size() == 6)
		{
			if (m_umiacUpdateUrl)
			{
				// only update url when set to
				m_umiac.setGroupUrl(pIdList.get(0), pIdList.get(1), pIdList.get(2), pIdList.get(3), pIdList.get(4), pIdList.get(5), url);
			}
		}
	}

	private List<String> getProviderSubjectList(List<String> providerIdsList) {
		List<String> providerIdSubjectList = new Vector<String>();
		for (int i=0; i<providerIdsList.size(); i++)
		{
			String providerId = (String) providerIdsList.get(i);
			
			List<String> pIdList = new ArrayList<String>(Arrays.asList(providerId.split(",")));
			//year,term,campus,subject,course,section
			if (pIdList.size() == 6)
			{
				providerIdSubjectList.add((String) pIdList.get(2) + "_" + (String) pIdList.get(3));
			}
		}
		return providerIdSubjectList;
	}

	/**
	 * remove subject affiliates after the assoicated provider has been removed
	 * @param realmId
	 * @param r
	 * @param providerIdSubjectList
	 */
	private void removeSubjectAffiliates(String realmId, AuthzGroup r, List<String> providerIdSubjectList) 
	{
		Set<String> affiliates = r.getUsersHasRole(AFFILIATE_ROLE);
		for (Iterator<String> affiliateIds = affiliates.iterator(); affiliateIds.hasNext();)
		{
			String userId = (String) affiliateIds.next();
			try
			{
				User user = UserDirectoryService.getUser(userId);
				// get all related affiliate subjects
				Collection<String> affiliateSubjects = getAffiliateSubjects(user.getEid());
				List<String> providerIdSubjectListClone = providerIdSubjectList;
				// remove all subject that does not have the affiliate eid
				if (affiliateSubjects.size() != 0 && !providerIdSubjectListClone.removeAll(affiliateSubjects))
				{
					// if the list is unchanged, this means none of the associated subject is in the provider, the affiliate needs to be removed
					if (AuthzGroupService.allowUpdate(realmId))
					{
						try
						{
							AuthzGroup realmEdit = AuthzGroupService.getAuthzGroup(realmId);
							realmEdit.removeMember(userId);
							AuthzGroupService.save(realmEdit);
						}
						catch(Exception ignore) {}
					}
				}
			}
			catch(Exception ignore)
			{
				log.warn(this + " cannot find user " + userId);
			}
		}
	}

	/**
	* Get affiliates information
	*
	*/
	private void setupSubjectAffiliates()
	{
		Vector<SubjectAffiliates> affiliates = new Vector<SubjectAffiliates>();
		
		List<String> subjectList = new Vector<String>();
		List<String> campusList = new Vector<String>();
		List<String> uniqnameList = new Vector<String>();
		
		//get term information
		if (ServerConfigurationService.getStrings("affiliatesubjects") != null)
		{
			subjectList = new ArrayList<String>(Arrays.asList(ServerConfigurationService.getStrings("affiliatesubjects")));
		}
		if (ServerConfigurationService.getStrings("affiliatecampus") != null)
		{
			campusList = new ArrayList<String>(Arrays.asList(ServerConfigurationService.getStrings("affiliatecampus")));
		}
		if (ServerConfigurationService.getStrings("affiliateuniqnames") != null)
		{
			uniqnameList = new ArrayList<String>(Arrays.asList(ServerConfigurationService.getStrings("affiliateuniqnames")));
		}
		
		if (subjectList.size() > 0 && subjectList.size() == campusList.size() && subjectList.size() == uniqnameList.size())
		{
			for (int i=0; i < subjectList.size();i++)
			{
				String[] subjectFields = ((String) subjectList.get(i)).split(",");
				String[] uniqnameFields = ((String) uniqnameList.get(i)).split(",");
				String campus = (String) campusList.get(i);
				
				for (int j=0; j < subjectFields.length; j++)
				{
					String subject = StringUtil.trimToZero(subjectFields[j]);
					
					SubjectAffiliates affiliate = new SubjectAffiliates();
					affiliate.setSubject(subject);
					affiliate.setCampus(campus);
					Collection<String> uniqnames = affiliate.getUniqnames();
					
					for (int k=0; k < uniqnameFields.length;k++)
					{
						uniqnames.add(StringUtil.trimToZero(uniqnameFields[k]));
					}
					affiliates.add(affiliate);
				}
			}
		}
		
		m_affiliates = affiliates;
		
	}	// setupSubjectAffiliates
	
	/**
	 * add subject affiliate
	 * @param subject
	 * @param realmId
	 */
	private void addSubjectAffliates(List<String> providerIdsList, String realmId)
	{
		if (providerIdsList != null)
		{
			for (Iterator<String> providerIdsListIterator = providerIdsList.iterator(); providerIdsListIterator.hasNext();)
			{
				String providerId = providerIdsListIterator.next();
				List<String> pIdList = new ArrayList<String>(Arrays.asList(providerId.split(",")));
				//year,term,campus,subject,course,section
				if (pIdList.size() == 6)
				{
					String subject = (String) pIdList.get(2) + "_" + (String) pIdList.get(3);
					
					// get affiliates for subjects
					Collection<String> affiliates = new HashSet<String>(getSubjectAffiliates(subject));
					String affiliate = "";
					
					// try to add unique names with appropriate role
					for (Iterator<String> i = affiliates.iterator(); i.hasNext(); )
					{
						affiliate = (String)i.next();
						
						try
						{
							User user = UserDirectoryService.getUserByEid(affiliate);
							if (AuthzGroupService.allowUpdate(realmId))
							{
								try
								{
									AuthzGroup realmEdit = AuthzGroupService.getAuthzGroup(realmId);
									if (realmEdit.getUserRole(user.getId()) == null)
									{
										realmEdit.addMember(user.getId(), realmEdit.getRole(AFFILIATE_ROLE).getId(), true, false);
									}
									AuthzGroupService.save(realmEdit);
								}
								catch(Exception ignore) {}
							}
						}
						catch(Exception ignore)
						{
							log.warn(this + " cannot find affiliate " + affiliate);
						}
						
					}	// for	
				}
			}
		}
		
		
		
	} // modifySubjectAffliates
	
	/**
	 * 
	 * @param subject
	 * @return
	 */
	private Collection<String> getSubjectAffiliates(String subject)
	{
		Collection<String> rv = null;
		
		//iterate through the subjects looking for this subject
		for (Iterator<SubjectAffiliates> i = m_affiliates.iterator(); i.hasNext(); )
		{
			SubjectAffiliates sa = (SubjectAffiliates)i.next();
			String s = sa.getCampus().concat("_").concat(sa.getSubject());
			if(subject.equals(s))
			{
				return sa.getUniqnames();
			}
		}
		return rv;
		
	} //getSubjectAffiliates
	
	/**
	 * Based on the affiliate unique name, get the associated subject collection
	 * @param affiliateUniqueName
	 * @return
	 */
	private Collection<String> getAffiliateSubjects(String affiliateUniqueName)
	{
		Collection<String> rv = new Vector<String>();
		
		//iterate through the subjects looking for this subject
		for (Iterator<SubjectAffiliates> i = m_affiliates.iterator(); i.hasNext(); )
		{
			SubjectAffiliates sa = (SubjectAffiliates)i.next();
			if (sa.getUniqnames().contains(affiliateUniqueName))
			{
				rv.add(sa.getSubject());
			}
		}
		return rv;
		
	} //getSubjectAffiliates
	
} // EventWatcher



