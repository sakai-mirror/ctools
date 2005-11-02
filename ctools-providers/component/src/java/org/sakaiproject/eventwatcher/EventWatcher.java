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
import java.util.ListIterator;
import java.util.Observable;
import java.util.Observer;
import java.util.Vector;

import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.service.framework.config.cover.ServerConfigurationService;
import org.sakaiproject.service.framework.log.Logger;
import org.sakaiproject.service.framework.session.SessionState;
import org.sakaiproject.service.legacy.coursemanagement.Course;
import org.sakaiproject.service.legacy.coursemanagement.cover.CourseManagementService;
import org.sakaiproject.service.legacy.event.Event;
import org.sakaiproject.service.legacy.event.EventTrackingService;
import org.sakaiproject.service.legacy.realm.cover.RealmService;
import org.sakaiproject.service.legacy.realm.Realm;
import org.sakaiproject.service.legacy.realm.RealmEdit;
import org.sakaiproject.service.legacy.realm.Role;
import org.sakaiproject.service.legacy.realm.cover.RealmService;
import org.sakaiproject.service.legacy.resource.Reference;
import org.sakaiproject.service.legacy.site.SiteEdit;
import org.sakaiproject.service.legacy.user.User;
import org.sakaiproject.service.legacy.user.cover.UserDirectoryService;
import org.sakaiproject.util.api.umiac.UmiacClient;
import org.sakaiproject.util.java.StringUtil;
import org.sakaiproject.util.SubjectAffiliates;

/**
* <p>%%%</p>
* 
* @author University of Michigan, Sakai Software Development Team
* @version $Revision$
*/
public class EventWatcher implements Observer
{
	/*******************************************************************************
	* Dependencies and their setter methods
	*******************************************************************************/

	/** Dependency: logging service */
	protected Logger m_logger = null;

	/**
	 * Dependency: logging service.
	 * @param service The logging service.
	 */
	public void setLogger(Logger service)
	{
		m_logger = service;
	}

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
	protected Vector m_affiliates = null;
	
	/**
	 * Final initialization, once all dependencies are set.
	 */
	public void init()
	{
		try
		{
			m_logger.warn(this);
			m_logger.warn(m_eventTrackingService);
			// start watching the events - only those generated on this server, not those from elsewhere
			m_eventTrackingService.addLocalObserver(this);

			// read affiliates info
			setupSubjectAffiliates();
			
			m_logger.info(this +".init()");
		}
		catch (Throwable t)
		{
			m_logger.warn(this +".init(): ", t);
		}
	}

	/**
	* Returns to uninitialized state.
	*/
	public void destroy()
	{
		// done with event watching
		m_eventTrackingService.deleteObserver(this);

		m_logger.info(this +".destroy()");
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
		
		// check the event function against the functions we have notifications watching for
		String function = event.getEvent();

		if (function.equals(RealmService.SECURE_UPDATE_REALM) || function.equals(RealmService.SECURE_REMOVE_REALM))
		{
			Reference ref = new Reference(event.getResource());
			String url = ServerConfigurationService.getPortalUrl() + ref.getId();
			
			// if there any section assoicated with the site?
			Vector sectionsWithUrl = m_umiac.getUrlSections(url);
			
			if (function.equals(RealmService.SECURE_REMOVE_REALM))
			{
				// remove site url from any section in sectionWithUrl
				for (int i=0; sectionsWithUrl != null && i<sectionsWithUrl.size(); i++)
				{
					String section = (String) sectionsWithUrl.get(i);
					
					List sList = new ArrayList(Arrays.asList(section.split(",")));
					if (sList.size() == 6)
					{
						m_umiac.setGroupUrl((String) sList.get(0), (String) sList.get(1), (String) sList.get(2), (String) sList.get(3), (String) sList.get(4), (String) sList.get(5), "-");
					}
				}
			}
			else
			{
				try
				{
					Realm r = RealmService.getRealm(ref.getId());
					
					String[] providerIds = m_umiac.unpackId(r.getProviderRealmId());
					List providerIdsList = new Vector();
					if (providerIds != null)
					{
						providerIdsList = new ArrayList(Arrays.asList(providerIds));
					}
					
					for (int i=0; sectionsWithUrl != null && i<sectionsWithUrl.size(); i++)
					{
						String section = (String) sectionsWithUrl.get(i);
						if (!providerIdsList.contains(section))
						{
							// remove site url from any section in sectionWithUrl but not inside providerIds
							List sList = new ArrayList(Arrays.asList(section.split(",")));
							if (sList.size() == 6)
							{
								m_umiac.setGroupUrl((String) sList.get(0), (String) sList.get(1), (String) sList.get(2), (String) sList.get(3), (String) sList.get(4), (String) sList.get(5), "-");
								
								// remove subject affiliates from the realm
								modifySubjectAffliates((String) sList.get(3), ref.getId(), false);
							}
						}
					}
					
					for (int i=0; i<providerIdsList.size(); i++)
					{
						String providerId = (String) providerIdsList.get(i);
						
						if (sectionsWithUrl == null || !sectionsWithUrl.contains(providerId))
						{
							// for those sections inside provider id list but not marked with site url, update them with site url
							List pIdList = new ArrayList(Arrays.asList(providerId.split(",")));
							if (pIdList.size() == 6)
							{
								// year,term,campus,subject,course,section
								m_umiac.setGroupUrl((String) pIdList.get(0), (String) pIdList.get(1), (String) pIdList.get(2), (String) pIdList.get(3), (String) pIdList.get(4), (String) pIdList.get(5), url);
								
								// add subject affiliates to the realm
								modifySubjectAffliates((String) pIdList.get(3), ref.getId(), true);
							}
						}
					}
				}
				catch (IdUnusedException e)
				{
					m_logger.warn(this + ".update:" + e.getMessage() + ": " + event.getResource());
				}
				catch (Exception e)
				{
					m_logger.warn(this + ".update:" + e.getMessage() + ": " + event.getResource());
				}
			}
		}
	} // update

	/**
	* Get affiliates information
	*
	*/
	private void setupSubjectAffiliates()
	{
		Vector affiliates = new Vector();
		
		List subjectList = new Vector();
		List campusList = new Vector();
		List uniqnameList = new Vector();
		
		//get term information
		if (ServerConfigurationService.getStrings("affiliatesubjects") != null)
		{
			subjectList = new ArrayList(Arrays.asList(ServerConfigurationService.getStrings("affiliatesubjects")));
		}
		if (ServerConfigurationService.getStrings("affiliatecampus") != null)
		{
			campusList = new ArrayList(Arrays.asList(ServerConfigurationService.getStrings("affiliatecampus")));
		}
		if (ServerConfigurationService.getStrings("affiliateuniqnames") != null)
		{
			uniqnameList = new ArrayList(Arrays.asList(ServerConfigurationService.getStrings("affiliateuniqnames")));
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
					
					for (int k=0; k < uniqnameFields.length;k++)
					{
						affiliate.getUniqnames().add(StringUtil.trimToZero(uniqnameFields[k]));
					}
					affiliates.add(affiliate);
				}
			}
		}
		
		m_affiliates = affiliates;
		
	}	// setupSubjectAffiliates
	
	// modify affiliate information
	private void modifySubjectAffliates(String subject, String realmId, boolean add)
	{
		Collection affiliates = new Vector();
		String affiliate = "";
		
		// get affliates for subjects
		affiliates = new HashSet(getSubjectAffiliates(subject));
		
		// try to add uniqnames with appropriate role
		for (Iterator i = affiliates.iterator(); i.hasNext(); )
		{
			affiliate = (String)i.next();
			
			try
			{
				User user = UserDirectoryService.getUser(affiliate);
				if (RealmService.allowUpdateRealm(realmId))
				{
					try
					{
						RealmEdit realmEdit = RealmService.editRealm(realmId);
						Role role = realmEdit.getRole("Affiliate");
						if (add)
						{
							realmEdit.addUserRole(user.getId(), role.getId(), true, false);
						}
						else
						{
							realmEdit.removeUser(user.getId());
						}
						RealmService.commitEdit(realmEdit);
					}
					catch(Exception ignore) {}
				}
			}
			catch(Exception ignore)
			{
				m_logger.warn(this + " cannot find affiliate " + affiliate);
			}
			
		}	// for	
		
		
	} // modifySubjectAffliates
	
	/**
	* @params - String subject is the University's Subject code
	* @return - Collection of uniqnames of affiliates for this subject
	*/
	private Collection getSubjectAffiliates(String subject)
	{
		Collection rv = null;
		
		//iterate through the subjects looking for this subject
		for (Iterator i = m_affiliates.iterator(); i.hasNext(); )
		{
			SubjectAffiliates sa = (SubjectAffiliates)i.next();
			if(sa.getSubject().equals(subject)) return sa.getUniqnames();
		}
		return rv;
		
	} //getSubjectAffiliates
	
} // EventWatcher



