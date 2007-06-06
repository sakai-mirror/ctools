// $HeadURL$
// $Id$

package org.sakaiproject.coursemanagement.impl;

// This contains tests for the UMich CTools course management provider.
// It does not test everything currently, but the tests that are here are working.
// Feel free to add more tests as new capabilities are needed.

// To overcome the issue of needing a live database the database access methods have been 
// factored out into an inner class, and a mock can be used to substitute for the 
// database.
// 
// See testGetSectionCreatesSection for an example of using jmock.

// These tests will change as we expand capability of the provider.  E.g.
// getSection tests for a fixed provider name, but when working on
// making that more general, first change the test so it fails,
// because the code doesn't do the right thing and then change the code
// so it works.

//

import org.jmock.*;

import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.sakaiproject.util.api.umiac.UmiacClient;

import org.sakaiproject.coursemanagement.api.AcademicSession;
import org.sakaiproject.coursemanagement.api.CourseOffering;
import org.sakaiproject.coursemanagement.api.EnrollmentSet;
import org.sakaiproject.coursemanagement.api.Section;
import org.sakaiproject.coursemanagement.api.exception.IdNotFoundException;
import org.sakaiproject.coursemanagement.impl.ExternalAcademicSessionInformation;
import org.sakaiproject.exception.IdUnusedException;
import org.apache.commons.logging.Log;

// import junit.framework.TestCase;

public class CourseManagementServiceUnivOfMichImplTest extends MockObjectTestCase {

	CourseManagementServiceUnivOfMichImpl cmsuofi = null;
	
	protected void setUp() throws Exception {
		super.setUp();
		cmsuofi = new CourseManagementServiceUnivOfMichImpl();
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
	
	//Section eid: 2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION -> CouseOffering eid:2007,3,A,SUBJECT,CATALOG_NBR
	public void testGetCourseOfferingEidFromProviderId() {
		assertEquals("extract course offering from provider id","2007,3,A,SUBJECT,CATALOG_NBR",
				cmsuofi.getCourseOfferingEidFromProviderId("2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION"));
		
	}
	
	// 2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION -> WINTER 2007
	public void testGetAcademicSessionIdFromProviderIdWinter() {
		String academicSessionId = cmsuofi.getAcademicSessionIdFromProviderId("2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION");	
		assertEquals("generate WINTER 2007","WINTER 2007",academicSessionId);
		
	}
	
	public void testGetAcademicSessionIdFromProviderIdSummer() {
		String academicSessionId = cmsuofi.getAcademicSessionIdFromProviderId("2000,1,A,SUBJECT,CATALOG_NBR,CLASS_SECTION");	
		assertEquals("generate SUMMER 2000","SUMMER 2000",academicSessionId);
		
	}
	
	public void testGetAcademicSessionIdFromProviderIdSpring() {
		String academicSessionId = cmsuofi.getAcademicSessionIdFromProviderId("2006,4,A,SUBJECT,CATALOG_NBR,CLASS_SECTION");	
		assertEquals("generate SPRING 2006","SPRING 2006",academicSessionId);
		
	}
	
	public void testGetAcademicSessionIdFromProviderIdSpringSummer() {
		String academicSessionId = cmsuofi.getAcademicSessionIdFromProviderId("2010,5,A,SUBJECT,CATALOG_NBR,CLASS_SECTION");	
		assertEquals("generate SPRING_SUMMER","SPRING_SUMMER 2010",academicSessionId);
		
	}
	
	
	public void testGetCourseSetMemberships() {
		Set courseSetMemberships = cmsuofi.getCourseSetMemberships(null);
		assertNull("dummy getCourseSetMemberships",courseSetMemberships);
	}
	
//	public void testGetCourseSetMembershipsYetToDo() {
//		// need to implement these tests too.
//		// 
//		// 
//		fail("not yet finished");
//	}
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
	
	/**
	 * test the mapping the English-version of term names into one-digit format which is used inside UMIAC
	 */
	public void testFindTermStringFromTermIndex() {
		assertEquals("Summer term is 1","SUMMER",cmsuofi.findTermStringFromTermIndex("1"));
		assertEquals("Fall term is 2","FALL",cmsuofi.findTermStringFromTermIndex("2"));
		assertEquals("Winter term is 3","WINTER",cmsuofi.findTermStringFromTermIndex("3"));
		assertEquals("Spring term is 4","SPRING",cmsuofi.findTermStringFromTermIndex("4"));
		assertEquals("Spring Summer term is 5","SPRING_SUMMER",cmsuofi.findTermStringFromTermIndex("5"));
	}
	
	
//	import org.jmock.*;
//
//	class PublisherTest extends MockObjectTestCase {
//	    public void testOneSubscriberReceivesAMessage() {
//	        // set up
//	        Mock mockSubscriber = mock(Subscriber.class);
//	        Publisher publisher = new Publisher();
//	        publisher.add((Subscriber) mockSubscriber.proxy());
//	        
//	        final String message = "message";
//	        
//	        // expectations
//	        mockSubscriber.expects(once()).method("receive").with( eq(message) );
//	        
//	        // execute
//	        publisher.publish(message);
//	    }
//	}
	
	/**
	 * test the Section object creation based on the section id in UMIAC format
	 * test expected contents of enrollmentset and course offering.
	 * Not finished.
	 */
	public void testGetSection() {
		
		// getSection will look up section from external source,
		// so mock one up.
		Mock mockUseDb = mock(ExternalAcademicSessionInformation.class);
		ExternalAcademicSessionInformation easi = (ExternalAcademicSessionInformation) mockUseDb.proxy();
		
		// The external source will return an Academic session object.  Mock that up and
		// set appropriate values for that object.
		Mock mockAcademicSession = mock(AcademicSession.class);
		mockUseDb.expects(once()).method("getAcademicSession").with(eq("WINTER 2007")).will(returnValue(mockAcademicSession.proxy()));
		mockAcademicSession.expects(once()).method("getDescription").will(returnValue("W07"));
		mockAcademicSession.expects(once()).method("getStartDate").will(returnValue(new Date()));
		mockAcademicSession.expects(once()).method("getEndDate").will(returnValue(new Date()));
		
		// setup to use the mock
		cmsuofi.setExternalAcademicSessionInformationSource(easi);
		
		String id = "2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION";
		Section s = cmsuofi.getSection(id);
		// make sure that got back a section and a course offering
		assertTrue("section returned from GS",s instanceof Section);
		
		// course offering id should not contain the section information from the full id.
		String coEid = "2007,3,A,SUBJECT,CATALOG_NBR";
		assertEquals("section contains course offering",coEid,s.getCourseOfferingEid());
		assertEquals("title contains description","SUBJECT CATALOG_NBR CLASS_SECTION W07",s.getTitle());
		
		// check contents of enrollment set.
		EnrollmentSet es = s.getEnrollmentSet();
		assertTrue("section contains enrollment set",es instanceof EnrollmentSet);
		Set<String> instructors = es.getOfficialInstructors();
		Set<String> instructorSet = new HashSet<String>();
		instructorSet.add("instructorOne");
		assertTrue("expected instructors are in enrollment set",instructorSet.containsAll(instructors));
		assertTrue("instructors in enrollment set are all expected",instructors.containsAll(instructorSet));
		
		//assertEquals("instructor is instructorOne","instructorOne";
	}
	
//	public void testGetSectionYetToDo() {
//		fail("more getSection tests yet to do");
//	}
//	
	
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
	
	// eid: providerId 2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION
	// result: 1: Burger,Ham F|HBURGER|11234541|-||Instructor|E
	public void testGetSectionInstructors() {

		// will need to mock umiac
		Mock mockUmiac = mock(UmiacClient.class);
		UmiacClient uc = (UmiacClient) mockUmiac.proxy();
		
		String providerId = "2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION";
		
		HashMap<String, String> eidRoleMap = new HashMap<String, String>();
	
		eidRoleMap.put("HBURGER", "Instructor");
		eidRoleMap.put("FFERTER", "Instructor");
		eidRoleMap.put("MUSTARD","Student");
		eidRoleMap.put("VINEGAR","Student");
		mockUmiac.expects(once()).method("getGroupRoles").with(eq(providerId)).will(returnValue(eidRoleMap));

		cmsuofi.setUmiac(uc);
		
		Set s = cmsuofi.getSectionInstructors(providerId);
		String elements[] = {"HBURGER","FFERTER"};
		Set right = new HashSet<String>(Arrays.asList(elements));
		assertEquals("found both instructors",right,s);
	}
	
	public void testGetSectionInstructorsEmpty() {

		// will need to mock umiac
		Mock mockUmiac = mock(UmiacClient.class);
		UmiacClient uc = (UmiacClient) mockUmiac.proxy();
		
		String providerId = "2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION";
		
		HashMap eidRoleMap = new HashMap();
	
		mockUmiac.expects(once()).method("getGroupRoles").with(eq(providerId)).will(returnValue(eidRoleMap));

		cmsuofi.setUmiac(uc);
		
		Set s = cmsuofi.getSectionInstructors(providerId);
		String elements[] = new String[] {};
		Set right = new HashSet<String>(Arrays.asList(elements));
		assertEquals("no instructors returns empty set",right,s);

	}
	
	public void testGetSectionInstructorsnoInstructor() {

		// will need to mock umiac
		Mock mockUmiac = mock(UmiacClient.class);
		UmiacClient uc = (UmiacClient) mockUmiac.proxy();
		
		String providerId = "2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION";
		
		HashMap eidRoleMap = new HashMap();
	
		eidRoleMap.put("HBURGER", "TA");
		eidRoleMap.put("FFERTER", "TA");
		eidRoleMap.put("MUSTARD","Student");
		eidRoleMap.put("VINEGAR","Student");
		mockUmiac.expects(once()).method("getGroupRoles").with(eq(providerId)).will(returnValue(eidRoleMap));

		cmsuofi.setUmiac(uc);
		
		Set s = cmsuofi.getSectionInstructors(providerId);
		String elements[] = {};
		Set right = new HashSet<String>(Arrays.asList(elements));
		assertEquals("found no instructors",right,s);

	}
	
	
	public void testGetSectionInstructorsUnusedId() {

		// will need to mock umiac
		Mock mockUmiac = mock(UmiacClient.class);
		UmiacClient uc = (UmiacClient) mockUmiac.proxy();
		
		Mock mockLog = mock(Log.class);
		Log log = (Log) mockLog.proxy();
		
		mockLog.expects(once()).method("warn").with(ANYTHING);
				
		String providerId = "2007,3,A,SUBJECT,CATALOG_NBR,CLASS_SECTION";
		
//		HashMap eidRoleMap = new HashMap();
	
		mockUmiac.expects(once()).method("getGroupRoles").with(eq(providerId)).will(throwException(new org.sakaiproject.exception.IdUnusedException(providerId)));

		cmsuofi.setUmiac(uc);
		cmsuofi.setLog(log);
		
		Set s = cmsuofi.getSectionInstructors(providerId);
		
		// There are no specfic asserts since the verify step in the mocks will ensure that the log method has been called.
	}
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
