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
import org.sakaiproject.coursemanagement.api.CanonicalCourse;
import org.sakaiproject.coursemanagement.api.CourseManagementAdministration;
import org.sakaiproject.coursemanagement.api.CourseManagementService;
import org.sakaiproject.coursemanagement.api.CourseOffering;
import org.sakaiproject.coursemanagement.api.CourseSet;
import org.sakaiproject.coursemanagement.api.Enrollment;
import org.sakaiproject.coursemanagement.api.EnrollmentSet;
import org.sakaiproject.coursemanagement.api.Membership;
import org.sakaiproject.coursemanagement.api.Section;
import org.sakaiproject.coursemanagement.api.SectionCategory;
import org.sakaiproject.coursemanagement.api.exception.IdNotFoundException;
import org.sakaiproject.user.cover.UserDirectoryService;
import org.sakaiproject.user.api.UserNotDefinedException;


import org.sakaiproject.util.api.umiac.UmiacClient;

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
	
	/**
	 * Dependency: UserDirectoryService.
	 * *param service the UmiacClient.
	 */
	
	/** Dependency: UserDirectoryService */
	private UserDirectoryService m_userDirectoryService; 
	
	public void setUserDirectoryService(UserDirectoryService m_userDirectoryService) {
		this.m_userDirectoryService = m_userDirectoryService;
	}

	public UserDirectoryService getUserDirectoryService() {
		return m_userDirectoryService;
	}
	
	/**
	 * Dependency: cmAdmin
	 */
	protected CourseManagementAdministration cmAdmin;
	public void setCmAdmin(CourseManagementAdministration cmAdmin) {
		this.cmAdmin = cmAdmin;
	}
	
	private Object getObjectByEid(final String eid, final String className) throws IdNotFoundException {
		return null;
	}
	
	public CourseSet getCourseSet(String eid) throws IdNotFoundException {
		return (CourseSet)getObjectByEid(eid, CourseSet.class.getName());
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

	public List getAcademicSessions() {
		return new Vector();
	}

	public List getCurrentAcademicSessions() {
		return new Vector();
	}

	public AcademicSession getAcademicSession(final String eid) throws IdNotFoundException {
		return (AcademicSession)getObjectByEid(eid, AcademicSession.class.getName());
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
		return null;
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

	public Set findInstructingSections(final String userId) 
	{
		Vector rv = new Vector();
		int i = 0;
		String instructorEid = null;
		try {
			instructorEid = m_userDirectoryService.getUserEid(userId);
		} catch (UserNotDefinedException e1) {
			log.warn("No eid for instructorId: "+userId,e1);
			instructorEid = userId;
		}
		
		// Enrollment sets and sections
		Set<String> instructors = new HashSet<String>();
		instructors.add(instructorEid);
		
		List academicSessions = getAcademicSessions();
		for (int t = 0; t<academicSessions.size(); t++)
		{
			AcademicSession as = (AcademicSession) academicSessions.get(t);
			try
			{
				//getInstructorSections returns 12 strings: year, term_id, campus_code, 
				//subject, catalog_nbr, class_section, title, url, component, role, 
				//subrole, "CL" if cross-listed, blank if not
				String[] termParts = as.getTitle().split(" ");
				Vector courses = getUmiac().getInstructorSections (instructorEid, termParts[1], (String) termIndex.get(termParts[0]));
				
				int count = courses.size();
				for (i=0; i<courses.size(); i++)
				{
					String[] res = (String[]) courses.get(i);
					
					Set<CanonicalCourse> cc = new HashSet<CanonicalCourse>();
					cc.add(cmAdmin.createCanonicalCourse(res[2] + "_" + res[3], res[2] + "_" + res[3], ""));
					
					String courseId = res[0] + "," + res[1] + "," + res[2] + "," + res[3] + "," + res[4] + "," + res[5];
					CourseOffering c = cmAdmin.createCourseOffering( courseId + as.getEid(),
							res[2] + "_" + res[3], "Sample course offering #1, " + as.getEid(), "open", as.getEid(),
							res[2] + "_" + res[3], as.getStartDate(), as.getEndDate());
					/*c.setId(res[0] + "," + res[1] + "," + res[2] + "," + res[3] + "," + res[4] + "," + res[5]);
					c.setSubject(res[2] + "_" + res[3]);
					c.setTitle(res[6]);
					c.setTermId(termTerm+"_"+termYear);
					//if course is crosslisted, a "CL" is added at the end
					if (res.length == 12)
					{
						c.setCrossListed("CL");
					}
					else
					{
						c.setCrossListed("");
					}*/
					
					//output as a Vector of String[] objects (one String[] per output line:
					//sort_name|uniqname|umid|level (always "-")|credits|role|enrl_status
					Vector plist = getUmiac().getClassList (res[0], res[1], res[2], res[3], res[4], res[5]);
					Vector members = new Vector();
					EnrollmentSet es = cmAdmin.createEnrollmentSet(c.getEid() + ENROLLMENT_SET_SUFFIX,
							c.getTitle() + " Enrollment Set", c.getDescription() + " Enrollment Set",
							"lecture", "3", c.getEid(), instructors);
					
					Map<String, String> gradingSchemes = getGradingSchemeDescriptions(Locale.US);
					
					for (int j= 0; j<plist.size(); j++)
					{
						String[] res1 = (String[]) plist.get(j);
						
						/*CourseMember m = new CourseMember();
						m.setName(res1[0]);
						m.setUniqname(res1[1]);
						m.setId(res1[2]);
						m.setLevel(res1[3]);
						m.setCredits(res1[4]);
						m.setRole(res1[5]);
						*/
						cmAdmin.addOrUpdateEnrollment(res1[1], es.getEid(), res1[3], "", "");
					}
					rv.add(c);
				}
			}
			catch (Exception e)
			{
				//log.info(this + " Cannot find any course in record for the instructor with id " + instructorId + ". ");
			}
		}
		return null;
	}

	public Set<Section> findEnrolledSections(final String userId) {
		return new HashSet();
	}
	
	public Set<Section> findInstructingSections(final String userId, final String academicSessionEid) {
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
		return null;
	}

	public Map<String, String> findCourseSetRoles(final String userEid) {
		return null;
	}


	public Map<String, String> findSectionRoles(final String userEid) {
		return null;
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
