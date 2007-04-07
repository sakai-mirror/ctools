/**********************************************************************************
 * $URL:  $
 * $Id:  $
 ***********************************************************************************
 *
 * Copyright (c) 2006 The Sakai Foundation.
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

import java.sql.ResultSet;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.coursemanagement.api.AcademicSession;
import org.sakaiproject.coursemanagement.impl.AcademicSessionCmImpl;
import org.sakaiproject.coursemanagement.impl.SectionCmImpl;
import org.sakaiproject.coursemanagement.api.CanonicalCourse;
import org.sakaiproject.coursemanagement.impl.CanonicalCourseCmImpl;
import org.sakaiproject.coursemanagement.api.CourseManagementAdministration;
import org.sakaiproject.coursemanagement.api.CourseManagementService;
import org.sakaiproject.coursemanagement.api.CourseOffering;
import org.sakaiproject.coursemanagement.impl.CourseOfferingCmImpl;
import org.sakaiproject.coursemanagement.api.CourseSet;
import org.sakaiproject.coursemanagement.api.Enrollment;
import org.sakaiproject.coursemanagement.api.EnrollmentSet;
import org.sakaiproject.coursemanagement.api.Membership;
import org.sakaiproject.coursemanagement.api.Section;
import org.sakaiproject.coursemanagement.api.SectionCategory;
import org.sakaiproject.coursemanagement.api.exception.IdExistsException;
import org.sakaiproject.coursemanagement.api.exception.IdNotFoundException;
import org.sakaiproject.coursemanagement.impl.facade.Authentication;
import org.sakaiproject.db.api.SqlReader;
import org.sakaiproject.db.api.SqlService;
import org.sakaiproject.user.cover.UserDirectoryService;
import org.sakaiproject.user.api.UserNotDefinedException;

import org.sakaiproject.util.api.umiac.UmiacClient;
import org.sakaiproject.db.api.SqlReader;
import org.sakaiproject.db.api.SqlService;

/**
 * Provides access to course and enrollment data stored in UMIAC's 
 * 
 * @author <a href="mailto:jholtzman@berkeley.edu">Josh Holtzman</a>
 *
 */
public class CourseManagementServiceUnivOfMichImpl implements CourseManagementService {
	private static final Log log = LogFactory.getLog(CourseManagementServiceUnivOfMichImpl.class);
	
	protected static final String ENROLLMENT_SET_SUFFIX = "es";
	
	private Hashtable termIndex = new Hashtable();
	
	
	public void init() {
		log.info("Initializing " + getClass().getName());
		
		termIndex.put("SUMMER", "1");
		termIndex.put("FALL","2");
		termIndex.put("WINTER", "3");
		termIndex.put("SPRING", "4");
		termIndex.put("SPRING_SUMMER","5");
	}

	public void destroy() {
		log.info("Destroying " + getClass().getName());
	}
	
	/**
	 * Dependency: UmiacClient.
	 * *param service the UmiacClient.
	 */
	
	/** Dependency: UmiacClient */
	private UmiacClient m_umiac; 
	
	public void setUmiac(UmiacClient m_umiac) {
		this.m_umiac = m_umiac;
	}

	public UmiacClient getUmiac() {
		return m_umiac;
	}
	
	/** Dependency: SqlService */
	protected SqlService m_sqlService = null;

	public void setSqlService(SqlService service)
	{
		m_sqlService = service;
	}
	
	/** Dependency: */
	protected CourseManagementAdministration cmAdmin;
	public void setCmAdmin(CourseManagementAdministration cmAdmin) {
		this.cmAdmin = cmAdmin;
	}
	
	private Object getObjectByEid(final String eid, final String className) throws IdNotFoundException {
		return null;
	}
	
	/**
	 * get the course set by eid. 
	 */
	public CourseSet getCourseSet(String eid) throws IdNotFoundException {
		return null;
	}

	public Set getChildCourseSets(final String parentCourseSetEid) throws IdNotFoundException {
		// Ensure that the parent exists
		if(!isCourseSetDefined(parentCourseSetEid)) {
			throw new IdNotFoundException(parentCourseSetEid, CourseSet.class.getName());
		}
		return new HashSet();
	}

	public Set getCourseSets() {
		return new HashSet();
	}

	public Set getCourseSetMemberships(String courseSetEid) throws IdNotFoundException 
	{
		String[] fields = courseSetEid.split(",");
		
		//get course participant list
		//output as a Vector of String[] objects (one String[] per output line:
		//sort_name|uniqname|umid|level (always "-")|credits|role|enrl_status
		Vector plist = getUmiac().getClassList (fields[0], fields[1], fields[2], fields[3], fields[4], fields[5]);
		Vector members = new Vector();
		for (int j= 0; j<plist.size(); j++)
		{
			String[] res = (String[]) plist.get(j);
			/*Membership m = new Membership();
			m.setName(res[0]);
			m.setUniqname(res[1].toLowerCase());
			m.setId(res[2]);
			m.setLevel(res[3]);
			m.setCredits(res[4]);
			m.setRole(res[5]);
			m.setProviderRole(res[5]);
			m.setCourse(fields[3] + " " + fields[4]);
			m.setSection(fields[5]);
			members.add(m);*/
		}
		
		return new HashSet();
	}

	public CanonicalCourse getCanonicalCourse(String eid) throws IdNotFoundException {
		return (CanonicalCourse)getObjectByEid(eid, CanonicalCourse.class.getName());
	}

	public Set getEquivalentCanonicalCourses(String canonicalCourseEid) {
		return new HashSet();
	}

	public Set getCanonicalCourses(final String courseSetEid) throws IdNotFoundException {
		return new HashSet();
	}

	public List<AcademicSession> getAcademicSessions() {
		// send to database
		String statement = null;
		Object[] fields = null;
		
		// if a record with courseId exists
		statement = "SELECT ACADEMIC_SESSION_ID, VERSION, LAST_MODIFIED_BY, LAST_MODIFIED_DATE, CREATED_BY, CREATED_DATE, ENTERPRISE_ID, TITLE, DESCRIPTION, START_DATE	, END_DATE FROM CM_ACADEMIC_SESSION_T";
		
		List results = m_sqlService.dbRead(statement, null, new SqlReader()
			{
				public Object readSqlResultRecord(ResultSet result)
				{
					try
					{
						// create the Resource from the db xml
						String academic_session_id = result.getString(1);
						String version = result.getString(2);
						String lastModifiedBy = result.getString(3);
						String lastModifiedDate = result.getString(4);
						String createdBy= result.getString(5);
						String createdDate= result.getString(6);
						String eid= result.getString(7);
						String title = result.getString(8);
						String description = result.getString(9);
						Date startDate = result.getDate(10);
						Date endDate = result.getDate(11);
						AcademicSessionCmImpl ac = new AcademicSessionCmImpl(eid, title, description, startDate, endDate);
						
						return ac;
					}
					catch (Throwable ignore) { return null;}
				}
			} );
		
		if (results != null && results.size()>0)
		{
			return results;
		}
		else
		{
			return null;
		}
	}

	public List<AcademicSession> getCurrentAcademicSessions() {
		return getAcademicSessions();
	}

	public AcademicSession getAcademicSession(final String eid) throws IdNotFoundException {
		
		// send to database
		String statement = null;
		Object[] fields = new Object[1];
		fields[0] = eid;
		
		// if a record with courseId exists
		statement = "SELECT ACADEMIC_SESSION_ID, VERSION, LAST_MODIFIED_BY, LAST_MODIFIED_DATE, CREATED_BY, CREATED_DATE, ENTERPRISE_ID, TITLE, DESCRIPTION, START_DATE	, END_DATE FROM CM_ACADEMIC_SESSION_T WHERE ENTERPRISE_ID=?";
		
		List results = m_sqlService.dbRead(statement, fields, new SqlReader()
			{
				public Object readSqlResultRecord(ResultSet result)
				{
					try
					{
						// create the Resource from the db xml
						String academic_session_id = result.getString(1);
						String version = result.getString(2);
						String lastModifiedBy = result.getString(3);
						String lastModifiedDate = result.getString(4);
						String createdBy= result.getString(5);
						String createdDate= result.getString(6);
						String eid= result.getString(7);
						String title = result.getString(8);
						String description = result.getString(9);
						Date startDate = result.getDate(10);
						Date endDate = result.getDate(11);
						AcademicSessionCmImpl ac = new AcademicSessionCmImpl(eid, title, description, startDate, endDate);
						
						return ac;
					}
					catch (Throwable ignore) { return null;}
				}
			} );
		
		if (results != null && results.size()>0)
		{
			return (AcademicSession) results.get(0);
		}
		else
		{
			return null;
		}
	}
	
	public CourseOffering getCourseOffering(String eid) throws IdNotFoundException {
		return (CourseOffering)getObjectByEid(eid, CourseOffering.class.getName());
	}

	public Set getCourseOfferingsInCourseSet(final String courseSetEid) throws IdNotFoundException {
		return new HashSet();
	}

	public Set getEquivalentCourseOfferings(String courseOfferingEid) throws IdNotFoundException {
		return new HashSet();
	}

	public Set getCourseOfferingMemberships(String courseOfferingEid) throws IdNotFoundException {
		return new HashSet();
	}

	public Section getSection(String eid) throws IdNotFoundException {
		return (Section)getObjectByEid(eid, Section.class.getName());
	}

	public Set getSections(String courseOfferingEid) throws IdNotFoundException {
		return new HashSet();
	}

	public Set getChildSections(final String parentSectionEid) throws IdNotFoundException {
		return new HashSet();
	}

	public Set getSectionMemberships(String sectionEid) throws IdNotFoundException {
		return new HashSet();
	}

	public EnrollmentSet getEnrollmentSet(String eid) throws IdNotFoundException {
		return (EnrollmentSet)getObjectByEid(eid, EnrollmentSet.class.getName());
	}

	public Set getEnrollmentSets(final String courseOfferingEid) throws IdNotFoundException {
		return new HashSet();
	}

	public Set getEnrollments(final String enrollmentSetEid) throws IdNotFoundException {
		return new HashSet();
	}

	public boolean isEnrolled(final String userId, final Set<String> enrollmentSetEids) {
		return false;
	}

	public boolean isEnrolled(String userId, String enrollmentSetEid) {
		
		return false;
	}
	
	public Enrollment findEnrollment(final String userId, final String enrollmentSetEid) {
		if( ! isEnrollmentSetDefined(enrollmentSetEid)) {
			log.warn("Could not find an enrollment set with eid=" + enrollmentSetEid);
			return null;
		}
		
		return null;
	}
	
	public Set getInstructorsOfRecordIds(String enrollmentSetEid) throws IdNotFoundException {
		EnrollmentSet es = getEnrollmentSet(enrollmentSetEid);
		return es.getOfficialInstructors();
	}


	public Set findCurrentlyEnrolledEnrollmentSets(final String userId) {
		return new HashSet();
	}


	public Set  findCurrentlyInstructingEnrollmentSets(final String userId) {
		return new HashSet();
	}

	/**
	 * @inherit
	 */
	public Set<Section> findInstructingSections(final String userId) 
	{
		HashSet set = new HashSet<Section>();
		
		// iterating through all sessions
		List sessions = getAcademicSessions();
		for (int i = 0; i<sessions.size(); i++)
		{
			AcademicSession session = (AcademicSession) sessions.get(i);
			Set set1 = findInstructingSections(userId, session.getEid());
			for(Iterator iter = set1.iterator(); iter.hasNext();) {
				Section section = (Section)iter.next();
				set.add(section);
			}
		}
		
		return set;
		
	}

	/**
	 * @inherit
	 */
	public Set<Section> findEnrolledSections(final String userId) 
	{
		HashSet set = new HashSet();
		
		if (userId == null) return set;

		// get the user's external list of sites : Map of provider id -> role for this user
		Map map = getUmiac().getUserSections(userId);
		set.addAll(map.keySet());
		
		return set;
	}
	
	public Set<Section> findInstructingSections(final String userId, final String academicSessionEid) 
	{
		HashSet s = new HashSet();
		
		try
		{
			// get the academic session first
			AcademicSession as = getAcademicSession(academicSessionEid);
			String[] acTitleParts = as.getTitle().split(" ");
			
			// get the instructor courses 
			Vector rv = new Vector();
			int i = 0;
			String instructorEid = null;
			try 
			{
				instructorEid = UserDirectoryService.getUserEid(userId);
			} 
			catch (UserNotDefinedException e1) 
			{
				log.warn("No eid for instructorId: "+userId,e1);
				instructorEid = userId;
			}
			try
			{
				//getInstructorSections returns 12 strings: year, term_id, campus_code, 
				//subject, catalog_nbr, class_section, title, url, component, role, 
				//subrole, "CL" if cross-listed, blank if not
				Vector courses = getUmiac().getInstructorSections (instructorEid, acTitleParts[1], (String) termIndex.get(acTitleParts[0]));
				
				int count = courses.size();
				for (i=0; i<courses.size(); i++)
				{
					String[] res = (String[]) courses.get(i);
					String cEid = res[0] + "," + res[1] + "," + res[2] + "," + res[3] + "," + res[4] + "," + res[5];
					
					CourseOfferingCmImpl co = new CourseOfferingCmImpl(cEid + academicSessionEid, res[6], res[2] + "_" + res[3],"open", as, new CanonicalCourseCmImpl(cEid, cEid, res[2] + "_" + res[3]), as.getStartDate(),as.getEndDate());
					
					SectionCmImpl section = new SectionCmImpl();
					section.setCategory("lct");
					section.setCourseOffering(co);
					section.setDescription(co.getDescription());
					section.setEid(co.getEid());
					section.setTitle(co.getTitle());
			        section.setMaxSize(new Integer(100));
		        	
					s.add(section);
				}
			}
			catch (Exception ee)
			{
				log.warn(this + " Cannot find any course in record for the instructor with id " + instructorEid + ". ");
			}
		}
		catch (IdNotFoundException e)
		{
		}
		return s;
	}

	public Set<CourseOffering> findCourseOfferings(final String courseSetEid, final String academicSessionEid) throws IdNotFoundException {
		return new HashSet();
	}

	public boolean isEmpty(final String courseSetEid) {
		return false;
	}


	public List<CourseSet> findCourseSets(final String category) {
		return new Vector();
	}


	public Map<String, String> findCourseOfferingRoles(final String userEid) {
		Map map = new HashMap();
		
		if (userEid == null) return map;

		// get the user's external list of sites : Map of provider id -> role for this user
		return getUmiac().getUserSections(userEid);
	}

	public Map<String, String> findCourseSetRoles(final String userEid) {
		Map map = new HashMap();
		
		if (userEid == null) return map;

		// get the user's external list of sites : Map of provider id -> role for this user
		return getUmiac().getUserSections(userEid);
	}


	public Map<String, String> findSectionRoles(final String userEid) {
		if (userEid == null) return new HashMap();

		// get the user's external list of sites : Map of provider id -> role for this user
		Map map = m_umiac.getUserSections(userEid);

		// transfer to our special map
		HashMap rv = new HashMap();
		rv.putAll(map);

		return rv;
	}


	public Set<CourseOffering> getCourseOfferingsInCanonicalCourse(final String canonicalCourseEid) throws IdNotFoundException {
		return new HashSet();
	}

	public boolean isAcademicSessionDefined(String eid) {
		return false;
	}
	
	public boolean isCanonicalCourseDefined(String eid) {
		return false;
	}

	public boolean isCourseOfferingDefined(String eid) {
		return false;
	}

	public boolean isCourseSetDefined(String eid) {
		return false;
	}

	public boolean isEnrollmentSetDefined(String eid) {
		return false;
	}

	public boolean isSectionDefined(String eid) {
		return false;
	}

	public List<String> getSectionCategories() {
		return new Vector();
	}

	public String getSectionCategoryDescription(String categoryCode) {
		return "";
	}

	public Map<String, String> getEnrollmentStatusDescriptions(Locale locale) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("enrolled", "Enrolled");
		map.put("wait", "Waitlisted");
		return map;
	}

	public Map<String, String> getGradingSchemeDescriptions(Locale locale) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("standard", "Letter Grades");
		map.put("pnp", "Pass / Not Pass");
		return map;
	}

	public Map getMembershipStatusDescriptions(Locale locale) {
		Map map = new HashMap();
		map.put("member", "Member");
		map.put("guest", "Guest");
		return map;
	}
}
