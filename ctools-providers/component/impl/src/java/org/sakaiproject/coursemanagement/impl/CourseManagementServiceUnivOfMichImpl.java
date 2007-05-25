/**********************************************************************************
 * $HeadURL:  $
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
import java.sql.SQLException;
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
import org.sakaiproject.coursemanagement.api.AcademicSession;
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
import org.sakaiproject.util.StringUtil;
import org.sakaiproject.exception.IdUnusedException;

/**
 * Provides access to course and enrollment data stored in UMIAC.
 * 
 * In process.
 * 
 */
public class CourseManagementServiceUnivOfMichImpl implements CourseManagementService {
	private static final Log log = LogFactory.getLog(CourseManagementServiceUnivOfMichImpl.class);
	
	protected static final String ENROLLMENT_SET_SUFFIX = "es";
	
	private static Hashtable<String, String> termIndex = new Hashtable<String, String>();
	
	private ExternalAcademicSessionInformation esi = new UseDb();
	
	private boolean useSql = true;
	
	/**
	 * term names are stored as digits in UMIAC
	 */
	static {
		termIndex.put("SUMMER", "1");
		termIndex.put("FALL","2");
		termIndex.put("WINTER", "3");
		termIndex.put("SPRING", "4");
		termIndex.put("SPRING_SUMMER","5");
	}
	
	public void init() {
		log.info("Initializing " + getClass().getName());
	}

	public void destroy() {
		log.info("Destroying " + getClass().getName());
	}
	
	/**
	 * Dependency: UmiacClient.
	 * @param service the UmiacClient.
	 */
	
	/** Dependency: UmiacClient */
	private UmiacClient m_umiac; 
	
	public void setUmiac(UmiacClient m_umiac) {
		this.m_umiac = m_umiac;
	}

	public void setEsi(ExternalAcademicSessionInformation esi) {
		this.esi = esi;
	}

	public ExternalAcademicSessionInformation getEsi() {
		return esi;
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

	private boolean UseSql;
	public void setCmAdmin(CourseManagementAdministration cmAdmin) {
		this.cmAdmin = cmAdmin;
	}
	
	private Object getObjectByEid(final String eid, final String className) throws IdNotFoundException {
		return null;
	}
	
	/**
	 * get the CourseSet by its eid. 
	 */
	public CourseSet getCourseSet(String eid) throws IdNotFoundException {
		return null;
	}

	public Set getChildCourseSets(final String parentCourseSetEid) throws IdNotFoundException {
		return new HashSet();
	}

	/**
	 * get the whole list of available CourseSet objects
	 */
	public Set getCourseSets() {
		return new HashSet();
	}

	public Set getCourseSetMemberships(String courseSetEid) throws IdNotFoundException 
	{
		// not needed
		
//		String[] fields = courseSetEid.split(",");
//		
//		//get course participant list
//		//output as a Vector of String[] objects (one String[] per output line:
//		//sort_name|uniqname|umid|level (always "-")|credits|role|enrl_status
//		Vector plist = getUmiac().getClassList (fields[0], fields[1], fields[2], fields[3], fields[4], fields[5]);
//		Vector members = new Vector();
//		for (int j= 0; j<plist.size(); j++)
//		{
//			String[] res = (String[]) plist.get(j);
//			/*Membership m = new Membership();
//			m.setName(res[0]);
//			m.setUniqname(res[1].toLowerCase());
//			m.setId(res[2]);
//			m.setLevel(res[3]);
//			m.setCredits(res[4]);
//			m.setRole(res[5]);
//			m.setProviderRole(res[5]);
//			m.setCourse(fields[3] + " " + fields[4]);
//			m.setSection(fields[5]);
//			members.add(m);*/
//		}
//		
	//	return new HashSet();
		return null;
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

	// Delegate to a default subclass so that can then override the inner class and use a mock for testing.
	
	public AcademicSession getAcademicSession(String eid) throws IdNotFoundException {
		return esi.getAcademicSession(eid);
	}


	public List<AcademicSession> getAcademicSessions() {
		return esi.getAcademicSessions();
	}
			

	public List<AcademicSession> getCurrentAcademicSessions() {
		return getAcademicSessions();
	}

	
	
	public CourseOffering getCourseOffering(String providerId) throws IdNotFoundException {
		AcademicSession as = getAcademicSessionFromProviderId(providerId);
		
		// construct CourseOffering object
		if (as != null)
		{
			CourseOfferingCmImpl co = new CourseOfferingCmImpl(providerId, providerId, "","open", as, new CanonicalCourseCmImpl(providerId, providerId, providerId), as.getStartDate(),as.getEndDate());
			
			return co;
		}
		else
		{
			CourseOfferingCmImpl co = new CourseOfferingCmImpl();
			co.setEid(providerId);
			if (as != null)
			{
				co.setAcademicSession(as);
			}
			else
			{
				// make up some dummy old term, which is 20 years from the current date
				co.setAcademicSession(new AcademicSessionCmImpl("old_terms", "Old Term", "old term", new Date(System.currentTimeMillis() - 1000*60*60*24*365*20), new Date(System.currentTimeMillis()-1000*60*60*24*365*19)));
			}
			return co;
		}
	}

	private AcademicSession getAcademicSessionFromProviderId(String providerId) {
		// 2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION
		String[] eidParts = providerId.split(",");
		String foundTermString = null;
	//	foundTermString = findTermStringFromTermIndex(eidParts, foundTermString);
		foundTermString = findTermStringFromTermIndex(eidParts[1]);
		String academicSessionId = foundTermString.concat(" ").concat(eidParts[0]);
		AcademicSession as = getAcademicSession(academicSessionId);
		return as;
	}

	/**
	 * Look up the term string from the term index in the provider id.
	 * @param eidParts
	 * @param foundTermString
	 * @return
	 */
	
	 String findTermStringFromTermIndex(String termIndexIntString) {
		String foundTermString = null;
		for (Iterator iTerm = termIndex.keySet().iterator(); foundTermString == null && iTerm.hasNext();)
		{
			String termString = (String) iTerm.next();
			if (termIndex.get(termString).equals(termIndexIntString))
			{
				foundTermString = termString;
			}
		}
		return foundTermString;
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
		AcademicSession as = getAcademicSessionFromProviderId(eid);
		
		CourseOfferingCmImpl co = new CourseOfferingCmImpl(eid, eid, "","open", as, new CanonicalCourseCmImpl(eid, eid, eid), as.getStartDate(),as.getEndDate());
		
		Set instructors = new HashSet();
		instructors.add("instructorOne");
		
		EnrollmentSet eSet = new EnrollmentSetCmImpl(eid,eid,eid, "lct","3", co, instructors);
		
		SectionCmImpl section = new SectionCmImpl();
		section.setCategory("lct");
		section.setCourseOffering(co);
		section.setDescription(co.getDescription());
		section.setEid(co.getEid());
		section.setTitle(co.getTitle());
        section.setMaxSize(new Integer(100));
        section.setEnrollmentSet(eSet);
        
        return section;
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
		
		Set instructors = new HashSet();
		
		try
		{
			Map members = getUmiac().getGroupRoles(eid);
			for (Iterator i=members.keySet().iterator(); i.hasNext();)
			{
				String eId = (String) i.next();
				String roleString = (String) members.get(eid);
				if (roleString != null && roleString.equals("Instructor"))
				{
					instructors.add(eId);
				}
			}
		}
		catch (IdUnusedException e)
		{
			log.warn(this + "could not find an enrollment set for " + eid);
		}
		
		EnrollmentSet eSet = new EnrollmentSetCmImpl(eid, eid, eid, "lct","3", getCourseOffering(eid), instructors);
		
		return eSet;
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
			log.warn(this + "Could not find an enrollment set with eid=" + enrollmentSetEid);
			return null;
		}
		
		// compute the set of individual umiac ids that are packed into id
		String eids[] = unpackId(enrollmentSetEid);
		
		try
		{
			Map members = getUmiac().getGroupRoles(eids);
			String roleString = null;
			for (Iterator i = members.keySet().iterator(); i.hasNext();)
			{
				String memberEid = (String) i.next();
				if (memberEid.equals(userId))
				{
					roleString = (String) members.get(memberEid);
				}
			}
			return new EnrollmentCmImpl(userId, getEnrollmentSet(enrollmentSetEid), "enrolled", "3", "gradeScheme");
		}
		catch (IdUnusedException e)
		{
			log.warn(this + "could not find an enrollment set for " + enrollmentSetEid);
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
		// not needed
		return new HashSet<Section>();
	}

	/**
	 * @inherit
	 */
	public Set<Section> findEnrolledSections(final String userId) 
	{
		// not needed
		return new HashSet();
	}
	
	public Set<Section> findInstructingSections(final String userId, final String academicSessionEid) 
	{
		return new HashSet();
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
		try
		{
			String name = StringUtil.trimToNull(getUmiac().getGroupName(eid));
			if (name != null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		catch (Exception e)
		{
			return false;
		}
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
	
	/**
	 * Unpack a multiple id that may contain many full ids connected with "+", each
	 * of which may have multiple sections enclosed in []
	 * @param eid The multiple group id.
	 * @return An array of strings of real umiac group ids, one for each in the multiple.
	 */
	public String[] unpackId(String eid)
	{
		return getUmiac().unpackId(eid);
	}

	// Inner class so that can mock and not require a database.

	class UseDb implements ExternalAcademicSessionInformation {
		/* (non-Javadoc)
		 * @see org.sakaiproject.coursemanagement.impl.ExternalSessionInformation#getAcademicSession(java.lang.String)
		 */
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
							AcademicSessionCmImpl ac = packageAcademicSessionInformationFromDb(result);
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
	
		/* (non-Javadoc)
		 * @see org.sakaiproject.coursemanagement.impl.ExternalSessionInformation#getAcademicSessions(org.sakaiproject.coursemanagement.impl.CourseManagementServiceUnivOfMichImpl)
		 */
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
							
							AcademicSessionCmImpl ac = packageAcademicSessionInformationFromDb(result);
//							String academic_session_id = result.getString(1);
//							String version = result.getString(2);
//							String lastModifiedBy = result.getString(3);
//							String lastModifiedDate = result.getString(4);
//							String createdBy= result.getString(5);
//							String createdDate= result.getString(6);
//							String eid= result.getString(7);
//							String title = result.getString(8);
//							String description = result.getString(9);
//							Date startDate = result.getDate(10);
//							Date endDate = result.getDate(11);
//							AcademicSessionCmImpl ac = new AcademicSessionCmImpl(eid, title, description, startDate, endDate);
//							
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

		protected AcademicSessionCmImpl packageAcademicSessionInformationFromDb(ResultSet result) throws SQLException {
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
		
	}
}
