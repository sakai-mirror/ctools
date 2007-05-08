/**********************************************************************************
 * $URL: $
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

import java.sql.Time;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.Vector;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.coursemanagement.api.AcademicSession;
import org.sakaiproject.coursemanagement.api.CanonicalCourse;
import org.sakaiproject.coursemanagement.api.CourseManagementAdministration;
import org.sakaiproject.coursemanagement.api.CourseOffering;
import org.sakaiproject.coursemanagement.api.CourseSet;
import org.sakaiproject.coursemanagement.api.Enrollment;
import org.sakaiproject.coursemanagement.api.EnrollmentSet;
import org.sakaiproject.coursemanagement.api.Meeting;
import org.sakaiproject.coursemanagement.api.Membership;
import org.sakaiproject.coursemanagement.api.Section;
import org.sakaiproject.coursemanagement.api.SectionCategory;
import org.sakaiproject.coursemanagement.api.exception.IdExistsException;
import org.sakaiproject.coursemanagement.api.exception.IdNotFoundException;
import org.sakaiproject.coursemanagement.impl.facade.Authentication;

/**
 * Manipulates course and enrollment data retrieved from UMIAC
 * 
 * @author <a href="mailto:jholtzman@berkeley.edu">Josh Holtzman</a>
 *
 */
public class CourseManagementAdministrationUnivOfMichImpl implements CourseManagementAdministration {

	private static final Log log = LogFactory.getLog(CourseManagementAdministrationUnivOfMichImpl.class);

	protected Authentication authn;
	public void setAuthn(Authentication authn) {
		this.authn = authn;
	}
	
	public void init() {
		log.info("Initializing " + getClass().getName());
	}

	public void destroy() {
		log.info("Destroying " + getClass().getName());
	}
	
	public AcademicSession createAcademicSession(String eid, String title,
			String description, Date startDate, Date endDate) throws IdExistsException {
		AcademicSessionCmImpl academicSession = new AcademicSessionCmImpl(eid, title, description, startDate, endDate);
		academicSession.setCreatedBy(authn.getUserEid());
		academicSession.setCreatedDate(new Date());
		return academicSession;
	}

	public void updateAcademicSession(AcademicSession academicSession) {
		// no impl to update methods
	}

	public CourseSet createCourseSet(String eid, String title, String description, String category,
			String parentCourseSetEid) throws IdExistsException {
		CourseSet parent = null;
		if(parentCourseSetEid != null) {
			parent = (CourseSet)getObjectByEid(parentCourseSetEid, CourseSetCmImpl.class.getName());
		}
		CourseSetCmImpl courseSet = new CourseSetCmImpl(eid, title, description, category, parent);
		courseSet.setCreatedBy(authn.getUserEid());
		courseSet.setCreatedDate(new Date());
		return courseSet;
	}

	public void updateCourseSet(CourseSet courseSet) {
		// no impl to update methods
	}

	public CanonicalCourse createCanonicalCourse(String eid, String title, String description) throws IdExistsException {
		CanonicalCourseCmImpl canonCourse = new CanonicalCourseCmImpl(eid, title, description);
		canonCourse.setCreatedBy(authn.getUserEid());
		canonCourse.setCreatedDate(new Date());
		return canonCourse;
	}

	public void updateCanonicalCourse(CanonicalCourse canonicalCourse) {
		// no impl to update methods
	}

	public void addCanonicalCourseToCourseSet(String courseSetEid, String canonicalCourseEid) throws IdNotFoundException {
		CourseSetCmImpl courseSet = (CourseSetCmImpl)getObjectByEid(courseSetEid, CourseSetCmImpl.class.getName());
		CanonicalCourseCmImpl canonCourse = (CanonicalCourseCmImpl)getObjectByEid(canonicalCourseEid, CanonicalCourseCmImpl.class.getName());
		
		Set<CanonicalCourse> canonCourses = courseSet.getCanonicalCourses();
		if(canonCourses == null) {
			canonCourses = new HashSet<CanonicalCourse>();
			courseSet.setCanonicalCourses(canonCourses);
		}
		canonCourses.add(canonCourse);
		
		courseSet.setLastModifiedBy(authn.getUserEid());
		courseSet.setLastModifiedDate(new Date());
	}

	public boolean removeCanonicalCourseFromCourseSet(String courseSetEid, String canonicalCourseEid) {
		CourseSetCmImpl courseSet = (CourseSetCmImpl)getObjectByEid(courseSetEid, CourseSetCmImpl.class.getName());
		CanonicalCourseCmImpl canonCourse = (CanonicalCourseCmImpl)getObjectByEid(canonicalCourseEid, CanonicalCourseCmImpl.class.getName());
		
		Set courses = courseSet.getCanonicalCourses();
		if(courses == null || ! courses.contains(canonCourse)) {
			return false;
		}
		courses.remove(canonCourse);

		courseSet.setLastModifiedBy(authn.getUserEid());
		courseSet.setLastModifiedDate(new Date());
		return true;
	}

	private void setEquivalents(Set crossListables) {
		
		// TODO Clean up orphaned cross listings
	}
	
	public void setEquivalentCanonicalCourses(Set canonicalCourses) {
		setEquivalents(canonicalCourses);
	}

	private boolean removeEquiv(CrossListableCmImpl impl) {
		boolean hadCrossListing = impl.getCrossListing() != null;
		impl.setCrossListing(null);
		impl.setLastModifiedBy(authn.getUserEid());
		impl.setLastModifiedDate(new Date());
		return hadCrossListing;
	}
	
	public boolean removeEquivalency(CanonicalCourse canonicalCourse) {
		return removeEquiv((CanonicalCourseCmImpl)canonicalCourse);
	}

	public CourseOffering createCourseOffering(String eid, String title, String description,
			String status, String academicSessionEid, String canonicalCourseEid, Date startDate, Date endDate) throws IdExistsException {
		AcademicSession as = (AcademicSession)getObjectByEid(academicSessionEid, AcademicSessionCmImpl.class.getName());
		CanonicalCourse cc = (CanonicalCourse)getObjectByEid(canonicalCourseEid, CanonicalCourseCmImpl.class.getName());
		CourseOfferingCmImpl co = new CourseOfferingCmImpl(eid, title, description, status, as, cc, startDate, endDate);
		co.setCreatedBy(authn.getUserEid());
		co.setCreatedDate(new Date());
		return co;
	}

	public void updateCourseOffering(CourseOffering courseOffering) {
		// no impl to update methods
	}

	public void setEquivalentCourseOfferings(Set courseOfferings) {
		setEquivalents(courseOfferings);
	}

	public boolean removeEquivalency(CourseOffering courseOffering) {
		return removeEquiv((CrossListableCmImpl)courseOffering);
	}

	public void addCourseOfferingToCourseSet(String courseSetEid, String courseOfferingEid) {
		// CourseSet's set of courses are controlled on the CourseSet side of the bi-directional relationship
		CourseSetCmImpl courseSet = (CourseSetCmImpl)getObjectByEid(courseSetEid, CourseSetCmImpl.class.getName());
		CourseOfferingCmImpl courseOffering = (CourseOfferingCmImpl)getObjectByEid(courseOfferingEid, CourseOfferingCmImpl.class.getName());
		Set<CourseOffering> offerings = courseSet.getCourseOfferings();
		if(offerings == null) {
			offerings = new HashSet<CourseOffering>();
		}
		offerings.add(courseOffering);
		courseSet.setCourseOfferings(offerings);
		
		courseSet.setLastModifiedBy(authn.getUserEid());
		courseSet.setLastModifiedDate(new Date());
	}

	public boolean removeCourseOfferingFromCourseSet(String courseSetEid, String courseOfferingEid) {
		
		return true;
	}

	public EnrollmentSet createEnrollmentSet(String eid, String title, String description, String category,
			String defaultEnrollmentCredits, String courseOfferingEid, Set officialGraders)
			throws IdExistsException {
		if(courseOfferingEid == null) {
			throw new IllegalArgumentException("You can not create an EnrollmentSet without specifying a courseOffering");
		}
		CourseOffering co = (CourseOffering)getObjectByEid(courseOfferingEid, CourseOfferingCmImpl.class.getName());
		EnrollmentSetCmImpl enrollmentSet = new EnrollmentSetCmImpl(eid, title, description, category, defaultEnrollmentCredits, co, officialGraders);
		enrollmentSet.setCreatedBy(authn.getUserEid());
		enrollmentSet.setCreatedDate(new Date());
		return enrollmentSet;
	}

	public void updateEnrollmentSet(EnrollmentSet enrollmentSet) {
		// no impl to update methods
	}

	public Enrollment addOrUpdateEnrollment(String userId, String enrollmentSetEid, String enrollmentStatus, String credits, String gradingScheme) {
		EnrollmentCmImpl enrollment = null;
		
		List enrollments = new Vector();
		if(enrollments.isEmpty()) {
			EnrollmentSet enrollmentSet = (EnrollmentSet)getObjectByEid(enrollmentSetEid, EnrollmentSetCmImpl.class.getName());
			enrollment = new EnrollmentCmImpl(userId, enrollmentSet, enrollmentStatus, credits, gradingScheme);
			enrollment.setCreatedBy(authn.getUserEid());
			enrollment.setCreatedDate(new Date());
		} else {
			enrollment = (EnrollmentCmImpl)enrollments.get(0);
			enrollment.setEnrollmentStatus(enrollmentStatus);
			enrollment.setCredits(credits);
			enrollment.setGradingScheme(gradingScheme);
			enrollment.setDropped(false);
			
			enrollment.setLastModifiedBy(authn.getUserEid());
			enrollment.setLastModifiedDate(new Date());
		}
		return enrollment;
	}

	public boolean removeEnrollment(String userId, String enrollmentSetEid) {
		return true;
	}

	public Section createSection(String eid, String title, String description, String category,
		String parentSectionEid, String courseOfferingEid, String enrollmentSetEid) throws IdExistsException {
		
		// The objects related to this section
		Section parent = null;
		CourseOffering co = null;
		EnrollmentSet es = null;
                Integer maxSize = null;

		// Get the enrollment set, if needed
		if(courseOfferingEid != null) {
			co = (CourseOffering)getObjectByEid(courseOfferingEid, CourseOfferingCmImpl.class.getName());
		}

		// Get the parent section, if needed
		if(parentSectionEid != null) {
			parent = (Section)getObjectByEid(parentSectionEid, SectionCmImpl.class.getName());
		}
		
		// Get the enrollment set, if needed
		if(enrollmentSetEid != null) {
			es = (EnrollmentSet)getObjectByEid(enrollmentSetEid, EnrollmentSetCmImpl.class.getName());
		}

		SectionCmImpl section = new SectionCmImpl(eid, title, description, category, parent, co, es, maxSize);
		section.setCreatedBy(authn.getUserEid());
		return section;
	}

	public void updateSection(Section section) {
		// no impl to updates
	}
	
    public Membership addOrUpdateCourseSetMembership(final String userId, String role, final String courseSetEid, final String status) throws IdNotFoundException {
		CourseSetCmImpl cs = (CourseSetCmImpl)getObjectByEid(courseSetEid, CourseSetCmImpl.class.getName());
		MembershipCmImpl member =getMembership(userId, cs);
		if(member == null) {
			// Add the new member
		    member = new MembershipCmImpl(userId, role, cs, status);
		    member.setCreatedBy(authn.getUserEid());
		    member.setCreatedDate(new Date());
		} else {
			// Update the existing member
			member.setRole(role);
			member.setStatus(status);
			member.setLastModifiedBy(authn.getUserEid());
			member.setLastModifiedDate(new Date());
		}
		return member;
	}

	public boolean removeCourseSetMembership(String userId, String courseSetEid) {
		return true;
	}

    public Membership addOrUpdateCourseOfferingMembership(String userId, String role, String courseOfferingEid, String status) {
		CourseOfferingCmImpl co = (CourseOfferingCmImpl)getObjectByEid(courseOfferingEid, CourseOfferingCmImpl.class.getName());
		MembershipCmImpl member =getMembership(userId, co);
		if(member == null) {
			// Add the new member
		    member = new MembershipCmImpl(userId, role, co, status);
		    member.setCreatedBy(authn.getUserEid());
		    member.setCreatedDate(new Date());
		} else {
			// Update the existing member
			member.setRole(role);
			member.setStatus(status);
			member.setLastModifiedBy(authn.getUserEid());
			member.setLastModifiedDate(new Date());
		}
		return member;
	}

	public boolean removeCourseOfferingMembership(String userId, String courseOfferingEid) {
		return true;
	}
	
    public Membership addOrUpdateSectionMembership(String userId, String role, String sectionEid, String status) {
		SectionCmImpl sec = (SectionCmImpl)getObjectByEid(sectionEid, SectionCmImpl.class.getName());
		MembershipCmImpl member =getMembership(userId, sec);
		if(member == null) {
			// Add the new member
		    member = new MembershipCmImpl(userId, role, sec, status);
		    member.setCreatedBy(authn.getUserEid());
		    member.setCreatedDate(new Date());
		} else {
			// Update the existing member
			member.setRole(role);
			member.setStatus(status);
			member.setLastModifiedBy(authn.getUserEid());
			member.setLastModifiedDate(new Date());
		}
		return member;
	}

	public boolean removeSectionMembership(String userId, String sectionEid) {
		return true;
	}
	
	private MembershipCmImpl getMembership(final String userId, final AbstractMembershipContainerCmImpl container) {
		// This may be a dynamic proxy.  In that case, make sure we're using the class
		// that hibernate understands.
		return null;
	}

	public Meeting newSectionMeeting(String sectionEid, String location, Time startTime, Time finishTime, String notes) {
		Section section = (Section)getObjectByEid(sectionEid, SectionCmImpl.class.getName());
		MeetingCmImpl meeting = new MeetingCmImpl(section, location, startTime, finishTime, notes);
		meeting.setCreatedBy(authn.getUserEid());
		meeting.setCreatedDate(new Date());
		Set<Meeting> meetings = section.getMeetings();
		if(meetings == null) {
			meetings = new HashSet<Meeting>();
			section.setMeetings(meetings);
		}
		return meeting;
	}

	public void removeAcademicSession(String eid) {
		// no impl to updates
	}

	public void removeCanonicalCourse(String eid) {
		// no impl to removes
	}

	public void removeCourseOffering(String eid) {
		// no impl to removes
	}

	public void removeCourseSet(String eid) {
		// no impl to removes
	}

	public void removeEnrollmentSet(String eid) {
		// no impl to removes
	}

	public void removeSection(String eid) {
		// no impl to removes
	}

	public SectionCategory addSectionCategory(String categoryCode, String categoryDescription) {
		SectionCategoryCmImpl cat = new SectionCategoryCmImpl(categoryCode, categoryDescription);
		return cat;
	}
	
	
	// TODO: The following two methods were copied from CM Service.  Consolidate them.
	
	/**
	 * A generic approach to finding objects by their eid.  This is "coding by convention",
	 * since it expects the parameterized query to use "eid" as the single named parameter.
	 * 
	 * @param eid The eid of the object we're trying to load
	 * @param className The name of the class / interface we're looking for
	 * @return The object, if found
	 * @throws IdNotFoundException
	 */
	private Object getObjectByEid(final String eid, final String className) throws IdNotFoundException {
		return null;
	}
	
	/**
	 * Gets the memberships for a membership container.  This query can not be
	 * performed using just the container's eid, since it may conflict with other kinds
	 * of objects with the same eid.
	 * 
	 * @param container
	 * @return
	 */
	private Set<Membership> getMemberships(final AbstractMembershipContainerCmImpl container) {
		// This may be a dynamic proxy.  In that case, make sure we're using the class
		// that hibernate understands.
		
		return new HashSet();
	}


}
