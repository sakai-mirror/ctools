/**********************************************************************************
 * $URL: https://source.sakaiproject.org/svn/course-management/trunk/cm-impl/hibernate-impl/impl/src/java/org/sakaiproject/coursemanagement/impl/SampleDataLoader.java $
 * $Id: SampleDataLoader.java 23011 2007-03-19 20:22:39Z jholtzman@berkeley.edu $
 ***********************************************************************************
 *
 * Copyright (c) 2007 The Sakai Foundation.
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
package org.sakaiproject.coursemanagement.impl;

import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.authz.cover.AuthzGroupService;
import org.sakaiproject.component.api.ServerConfigurationService;
import org.sakaiproject.coursemanagement.api.AcademicSession;
import org.sakaiproject.coursemanagement.api.CanonicalCourse;
import org.sakaiproject.coursemanagement.api.CourseManagementAdministration;
import org.sakaiproject.coursemanagement.api.CourseManagementService;
import org.sakaiproject.coursemanagement.api.CourseOffering;
import org.sakaiproject.coursemanagement.api.EnrollmentSet;
import org.sakaiproject.coursemanagement.api.Meeting;
import org.sakaiproject.coursemanagement.api.Section;
import org.sakaiproject.coursemanagement.api.SectionCategory;
import org.sakaiproject.coursemanagement.api.exception.IdExistsException;
import org.sakaiproject.coursemanagement.api.exception.IdNotFoundException;
import org.sakaiproject.event.cover.EventTrackingService;
import org.sakaiproject.event.cover.UsageSessionService;
import org.sakaiproject.tool.api.Session;
import org.sakaiproject.tool.cover.SessionManager;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.BeanFactoryAware;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class UnivOfMichDataLoader extends HibernateDaoSupport implements BeanFactoryAware {
	private static final Log log = LogFactory.getLog(UnivOfMichDataLoader.class);

	protected static final String[] ACADEMIC_SESSION_EIDS = new String[4];
	protected static final Date[] ACADEMIC_SESSION_START_DATES = new Date[4];
	protected static final Date[] ACADEMIC_SESSION_END_DATES = new Date[4];

	protected static final String CS = "SMPL";

	protected static final String CC1 = "SMPL101";
	protected static final String CC2 = "SMPL202";

	protected static final String CO1_PREFIX = CC1 + " ";
	protected static final String CO2_PREFIX = CC2 + " ";

	protected static final String ENROLLMENT_SET_SUFFIX = "es";
	
	protected static final SimpleDateFormat sdf;
	static {
		
		GregorianCalendar startCal = new GregorianCalendar();
		GregorianCalendar endCal = new GregorianCalendar();

		// Fall 2003
		ACADEMIC_SESSION_EIDS[0]="Fall 2003";
		startCal.set(2003, 9, 1);
		endCal.set(2003, 12, 30);
		ACADEMIC_SESSION_START_DATES[0] = startCal.getTime();
		ACADEMIC_SESSION_END_DATES[0] = endCal.getTime();
		
		int count = 1;
		for (int year = 2004; year < 2008; year++)
		{
			// Winter
			ACADEMIC_SESSION_EIDS[count] = "Winter " + year;
			startCal.set(year, 1, 1);
			endCal.set(year, 5, 1);
			ACADEMIC_SESSION_START_DATES[count] = startCal.getTime();
			ACADEMIC_SESSION_END_DATES[count] = endCal.getTime();
			count++;
			
			// Spring
			ACADEMIC_SESSION_EIDS[count] = "Spring " + year;
			startCal.set(year, 5, 1);
			endCal.set(year, 8, 1);
			ACADEMIC_SESSION_START_DATES[count] = startCal.getTime();
			ACADEMIC_SESSION_END_DATES[count] = endCal.getTime();
			count++;
			
			// Spring-Summer
			ACADEMIC_SESSION_EIDS[count] = "Spring_Summer " + year;
			startCal.set(year, 5, 15);
			endCal.set(year, 9, 1);
			ACADEMIC_SESSION_START_DATES[count] = startCal.getTime();
			ACADEMIC_SESSION_END_DATES[count] = endCal.getTime();	
			count++;
			
			// Summer
			ACADEMIC_SESSION_EIDS[count] = "Summer " + year;
			startCal.set(year, 5, 15);
			endCal.set(year, 9, 1);
			ACADEMIC_SESSION_START_DATES[count] = startCal.getTime();
			ACADEMIC_SESSION_END_DATES[count] = endCal.getTime();	
			count++;
			
			// Fall
			ACADEMIC_SESSION_EIDS[count] = "Fall " + year;
			startCal.set(year, 5, 15);
			endCal.set(year, 9, 1);
			ACADEMIC_SESSION_START_DATES[count] = startCal.getTime();
			ACADEMIC_SESSION_END_DATES[count] = endCal.getTime();
			count++;
		}
		
		sdf = new SimpleDateFormat("HH:mma");
	}
	
	protected int studentCount;

	// Begin Dependency Injection //
	protected CourseManagementAdministration cmAdmin;
	public void setCmAdmin(CourseManagementAdministration cmAdmin) {
		this.cmAdmin = cmAdmin;
	}

	protected ServerConfigurationService scs;
	public void setScs(ServerConfigurationService scs) {
		this.scs = scs;
	}
	
	protected CourseManagementService cmService;
	public void setCmService(CourseManagementService cmService) {
		this.cmService = cmService;
	}

	protected BeanFactory beanFactory;
	public void setBeanFactory(BeanFactory beanFactory) throws BeansException {
		this.beanFactory = beanFactory;
	}
	
	/** A flag for disabling the sample data load */
	protected boolean loadData;
	public void setLoadData(boolean loadData) {
		this.loadData = loadData;
	}
	// End Dependency Injection //

	public void init() {
		log.info("Initializing " + getClass().getName());
		if(cmAdmin == null) {
			return;
		}
		if(loadData && scs.getBoolean("auto.ddl", true)) {
			loginToSakai();
			PlatformTransactionManager tm = (PlatformTransactionManager)beanFactory.getBean("org.sakaiproject.springframework.orm.hibernate.GlobalTransactionManager");
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			TransactionStatus status = tm.getTransaction(def);
			try {
				load();
			} catch (Exception e) {
				log.error("Unable to load CM data: " + e);
				tm.rollback(status);
			} finally {
				if(!status.isCompleted()) {
					tm.commit(status);
				}
			}
			logoutFromSakai();
		} else {
			if(log.isInfoEnabled()) log.info("Skipped CM data load");
		}
	}
	
	public void destroy() {
		log.info("Destroying " + getClass().getName());
	}
	
	private void loginToSakai() {
	    Session sakaiSession = SessionManager.getCurrentSession();
		sakaiSession.setUserId("admin");
		sakaiSession.setUserEid("admin");

		// establish the user's session
		UsageSessionService.startSession("admin", "127.0.0.1", "CMSync");
		
		// update the user's externally provided realm definitions
		AuthzGroupService.refreshUser("admin");

		// post the login event
		EventTrackingService.post(EventTrackingService.newEvent(UsageSessionService.EVENT_LOGIN, null, true));
	}

	private void logoutFromSakai() {
	    Session sakaiSession = SessionManager.getCurrentSession();
		sakaiSession.invalidate();
		
		// post the logout event
		EventTrackingService.post(EventTrackingService.newEvent(UsageSessionService.EVENT_LOGOUT, null, true));
	}

	public void load() throws Exception {
		// Don't do anything if we've got data already.  The existence of an
		// AcademicSession for the first legacy term will be our indicator for existing
		// data.
		try {
			cmService.getAcademicSession(ACADEMIC_SESSION_EIDS[0]);
			if(log.isInfoEnabled()) log.info("CM data exists, skipping data load.");
			return;
		} catch (IdNotFoundException ide) {
			if(log.isInfoEnabled()) log.info("Starting sample CM data load");
		}

		// Academic Sessions
		List<AcademicSession> academicSessions = new ArrayList<AcademicSession>();
		for(int i = 0; i < ACADEMIC_SESSION_EIDS.length; i++) {
			String academicSessionEid = ACADEMIC_SESSION_EIDS[i];
			academicSessions.add(createAcademicSession(academicSessionEid,academicSessionEid,
					academicSessionEid, ACADEMIC_SESSION_START_DATES[i], ACADEMIC_SESSION_END_DATES[i]));
		}

	}
	
	private AcademicSession createAcademicSession(String eid, String title,
			String description, Date startDate, Date endDate) throws IdExistsException {
		AcademicSessionCmImpl academicSession = new AcademicSessionCmImpl(eid, title, description, startDate, endDate);
		academicSession.setCreatedBy("admin");
		academicSession.setCreatedDate(new Date());
		try {
			getHibernateTemplate().save(academicSession);
			return academicSession;
		} catch (DataIntegrityViolationException dive) {
			throw new IdExistsException(eid, AcademicSession.class.getName());
		}
	}
}
