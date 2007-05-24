package org.sakaiproject.coursemanagement.impl;

import java.util.Set;

import org.sakaiproject.coursemanagement.api.CourseOffering;
import org.sakaiproject.coursemanagement.api.exception.IdNotFoundException;

import junit.framework.TestCase;

public class CourseManagementServiceUnivOfMichImplTest extends TestCase {

	CourseManagementServiceUnivOfMichImpl cmsuofi = null;
	
	protected void setUp() throws Exception {
		super.setUp();
		cmsuofi = new CourseManagementServiceUnivOfMichImpl();
		cmsuofi.init();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}

	
	
//	public void testInit() {
//		fail("Not yet implemented");
//	}

//	public void testDestroy() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetCourseSet() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetChildCourseSets() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetCourseSets() {
//		fail("Not yet implemented");
//	}
//
	public void testGetCourseSetMemberships() {
		Set courseSetMemberships = cmsuofi.getCourseSetMemberships(null);
		assertNull("dummy getCourseSetMemberships",courseSetMemberships);
	}
//
//	public void testGetCanonicalCourse() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetEquivalentCanonicalCourses() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetCanonicalCourses() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetAcademicSessions() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetCurrentAcademicSessions() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetAcademicSession() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetCourseOffering() {
//		fail("Not yet implemented");
//	}
	
//	termIndex.put("SUMMER", "1");
//	termIndex.put("FALL","2");
//	termIndex.put("WINTER", "3");
//	termIndex.put("SPRING", "4");
//	termIndex.put("SPRING_SUMMER","5");
	
	public void testFindTermStringFromTermIndex() {
		assertEquals("Summer term is 1","SUMMER",cmsuofi.findTermStringFromTermIndex("1"));
		assertEquals("Fall term is 2","FALL",cmsuofi.findTermStringFromTermIndex("2"));
		assertEquals("Winter term is 3","WINTER",cmsuofi.findTermStringFromTermIndex("3"));
		assertEquals("Spring term is 4","SPRING",cmsuofi.findTermStringFromTermIndex("4"));
		assertEquals("Spring Summer term is 5","SPRING_SUMMER",cmsuofi.findTermStringFromTermIndex("5"));
	}
	
	public void testGetCourseOfferingCreatesCourseOffering() {
		CourseOffering co = cmsuofi.getCourseOffering("2007,3,A,SUBJECT,SECTION,COURSE");
		assertEquals("CourseOffering returned from GCO",co instanceof CourseOffering);
		
	}
	
//
//	public void testGetCourseOfferingsInCourseSet() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetEquivalentCourseOfferings() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetCourseOfferingMemberships() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetSection() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetSections() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetChildSections() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetSectionMemberships() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetEnrollmentSet() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetEnrollmentSets() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetEnrollments() {
//		fail("Not yet implemented");
//	}
//
//	public void testIsEnrolledStringSetOfString() {
//		fail("Not yet implemented");
//	}
//
//	public void testIsEnrolledStringString() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindEnrollment() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetInstructorsOfRecordIds() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindCurrentlyEnrolledEnrollmentSets() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindCurrentlyInstructingEnrollmentSets() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindInstructingSectionsString() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindEnrolledSections() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindInstructingSectionsStringString() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindCourseOfferings() {
//		fail("Not yet implemented");
//	}
//
//	public void testIsEmpty() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindCourseSets() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindCourseOfferingRoles() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindCourseSetRoles() {
//		fail("Not yet implemented");
//	}
//
//	public void testFindSectionRoles() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetCourseOfferingsInCanonicalCourse() {
//		fail("Not yet implemented");
//	}
//
//	public void testIsAcademicSessionDefined() {
//		fail("Not yet implemented");
//	}
//
//	public void testIsCanonicalCourseDefined() {
//		fail("Not yet implemented");
//	}
//
//	public void testIsCourseOfferingDefined() {
//		fail("Not yet implemented");
//	}
//
//	public void testIsCourseSetDefined() {
//		fail("Not yet implemented");
//	}
//
//	public void testIsEnrollmentSetDefined() {
//		fail("Not yet implemented");
//	}
//
//	public void testIsSectionDefined() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetSectionCategories() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetSectionCategoryDescription() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetEnrollmentStatusDescriptions() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetGradingSchemeDescriptions() {
//		fail("Not yet implemented");
//	}
//
//	public void testGetMembershipStatusDescriptions() {
//		fail("Not yet implemented");
//	}
//
//	public void testUnpackId() {
//		fail("Not yet implemented");
//	}

}
