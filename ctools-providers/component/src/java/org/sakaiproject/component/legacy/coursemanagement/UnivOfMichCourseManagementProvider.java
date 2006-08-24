/**********************************************************************************
*
* $Header: /cvs/ctools/ctools-providers/component/src/java/org/sakaiproject/component/legacy/coursemanagement/UnivOfMichCourseManagementProvider.java,v 1.1 2005/05/25 02:36:51 ggolden.umich.edu Exp $
*
***********************************************************************************
*
* Copyright (c) 2003, 2004 The Regents of the University of Michigan, Trustees of Indiana University,
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
package org.sakaiproject.component.legacy.coursemanagement;

// imports
import java.util.Collections;
import java.util.Hashtable;
import java.util.List;
import java.util.ListIterator;
import java.util.Vector;

//import org.sakaiproject.exception.IdUnusedException;
//import org.sakaiproject.service.framework.config.ServerConfigurationService;
//import org.sakaiproject.service.framework.current.CurrentService;
//import org.sakaiproject.service.framework.log.Logger;
//import org.sakaiproject.service.legacy.coursemanagement.Course;
//import org.sakaiproject.service.legacy.coursemanagement.CourseManagementProvider;
//import org.sakaiproject.service.legacy.coursemanagement.CourseMember;
//import org.sakaiproject.service.legacy.coursemanagement.Term;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.component.api.ServerConfigurationService;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.util.api.umiac.UmiacClient;
import org.sakaiproject.site.api.Course;
import org.sakaiproject.site.api.CourseManagementProvider;
import org.sakaiproject.site.api.CourseMember;
import org.sakaiproject.site.api.Term;
import org.sakaiproject.user.api.UserDirectoryService;
import org.sakaiproject.user.api.UserNotDefinedException;

/**
* <p>UnivOfMichCourseManagementProvider is CourseManagementProvider that provides a course for any
* course known to the U of M UMIAC system.</p>
* <p>Note: The server running this code must be known the the UMIAC system to be able to make requests.</p>
* <p>Todo: %%% cache users?</p>
*
* @author University of Michigan, CHEF Software Development Team
* @version $Revision$
* 
* For conversion CurrentService is replaced by ThreadLocalManager cover, but it seems to be unnecessary.
*/
public class UnivOfMichCourseManagementProvider
	implements CourseManagementProvider
{
	private Hashtable termIndex = new Hashtable();
	
	/*******************************************************************************
	* Dependencies and their setter methods
	*******************************************************************************/

	private static Log log = LogFactory.getLog(UnivOfMichCourseManagementProvider.class);
	
	/** Dependency: CurrentService */
	// protected CurrentService m_currentService = null;

	/**
	 * Dependency: CurrentService.
	 * @param service The CurrentService.
	 */
//	public void setCurrentService(CurrentService service)
//	{
//		m_currentService = service;
//	}

	/** Dependency: ServerConfigurationService*/
	protected ServerConfigurationService m_configService = null;

	/**
	 * Dependency: ServerConfigurationService.
	 * @param service The ServerConfigurationService.
	 */
	public void setServerConfigurationService(ServerConfigurationService service)
	{
		m_configService = service;
	}

	/**
	 * Dependency: UserDirectoryService.
	 * *param service the UserDirectoryService.
	 */
	private UserDirectoryService m_userDirectoryService;
	
	public UserDirectoryService getUserDirectoryService() {
		return m_userDirectoryService;
	}

	public void setUserDirectoryService(UserDirectoryService directoryService) {
		m_userDirectoryService = directoryService;
	}

	
	/** Configuration: kerberos or cosign. */
	protected boolean m_useKerberos = true;

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
	
	/*******************************************************************************
	* Init and Destroy
	*******************************************************************************/

	/**
	 * Final initialization, once all dependencies are set.
	 */
	public void init()
	{
		try
		{
			log.info(this +".init()");
		}
		catch (Throwable t)
		{
			log.warn(this +".init(): ", t);
		}
		
		termIndex.put("SUMMER", "1");
		termIndex.put("FALL","2");
		termIndex.put("WINTER", "3");
		termIndex.put("SPRING", "4");
		termIndex.put("SPRING_SUMMER","5");

	} // init

	/**
	* Returns to uninitialized state.
	*
	* You can use this method to release resources thet your Service
	* allocated when Turbine shuts down.
	*/
	public void destroy()
	{
		log.info(this +".destroy()");

	} // destroy

	/*******************************************************************************
	* CourseManagementProvider implementation
	*******************************************************************************/
	/**
	 * @inheritDoc
	 */
     public List getCourseIdRequiredFields()
     {
    	 	List rv = new Vector();
    	 	rv.add("Subject");
    	 	rv.add("Course:");
    	 	rv.add("Section:");
    	 	return rv;
    	 	
     }	// getRequiredFieldsForCourseId
     
     /**
  	 * Return a list of maximum field size for course id required fields
  	 */
     public List getCourseIdRequiredFieldsSizes()
     {
    	 	List rv = new Vector();
 	 	rv.add(new Integer(8));
 	 	rv.add(new Integer(3));
 	 	rv.add(new Integer(3));
 	 	return rv;
     }
       
     /**
      * @inheritDoc
      */
     public String getCourseId(Term term, List requiredFields)
     {
    	 	String rv = new String("");
    	 	if (term != null)
    	 	{
    	 		rv = rv.concat(term.getYear() + "," + term.getTerm());
    	 	}
    	 	else
    	 	{
    	 		rv = rv.concat(",,");
    	 	}
    	 	// campus
    	 	rv.concat("A,");
    	 	for (int i=0; i<requiredFields.size(); i++)
    	 	{
    	 		rv = rv.concat(",").concat((String) requiredFields.get(i));
    	 	}
    	 	return rv;
    	 	
     }	// getCourseId
     
	/**
	* @inheritDoc
	*/
	public String getCourseName(String courseId)
	{	
		// the format of courseId is of "YEAR,TERM,SUBJECT,COURSE,SECTION", e.g. "2006,WINTER,ENGIN,101,101"
		// the format of returned value is expected to be "SUBJECT COURSE SECTION", e.g. "ENGIN 101 101"
		
		String rv = "";
		// get the course name
		try
		{
			rv = getUmiac().getGroupName(courseId);
			if (rv!=null)
			{
				return rv;
			}
		}
		catch (IdUnusedException e)
		{
			
		}
		
		// If there is no umiac information use the information provided
		String[] fields = courseId.split(",");
		rv = fields[2] + " " + fields[3] + " " + fields[4];
		
		return rv;
	}
	
	/**
	* @inheritDoc
	*/
	public Course getCourse(String courseId)
	{
		String[] fields = courseId.split(",");
		
		Course course = new Course();
		course.setId(courseId);
		course.setTitle(getCourseName(courseId));
		course.setSubject(fields[2] + "_" + fields[3]);
		
		//get course participant list
		//output as a Vector of String[] objects (one String[] per output line:
		//sort_name|uniqname|umid|level (always "-")|credits|role|enrl_status
		Vector plist = getUmiac().getClassList (fields[0], fields[1], fields[2], fields[3], fields[4], fields[5]);
		Vector members = new Vector();
		for (int j= 0; j<plist.size(); j++)
		{
			String[] res = (String[]) plist.get(j);
			CourseMember m = new CourseMember();
			m.setName(res[0]);
			m.setUniqname((res[1]).toLowerCase());
			m.setId(res[2]);
			m.setLevel(res[3]);
			m.setCredits(res[4]);
			m.setRole(res[5]);
			members.add(m);
		}
		course.setMembers(members);
		
		return course;

	}	// getCourse
	
	/**
	* @inheritDoc
	*/
	public List getCourseMembers(String courseId)
	{	
		String[] fields = courseId.split(",");
		
		//get course participant list
		//output as a Vector of String[] objects (one String[] per output line:
		//sort_name|uniqname|umid|level (always "-")|credits|role|enrl_status
		Vector plist = getUmiac().getClassList (fields[0], fields[1], fields[2], fields[3], fields[4], fields[5]);
		Vector members = new Vector();
		for (int j= 0; j<plist.size(); j++)
		{
			String[] res = (String[]) plist.get(j);
			CourseMember m = new CourseMember();
			m.setName(res[0]);
			m.setUniqname(res[1].toLowerCase());
			m.setId(res[2]);
			m.setLevel(res[3]);
			m.setCredits(res[4]);
			m.setRole(res[5]);
			m.setProviderRole(res[5]);
			m.setCourse(fields[3] + " " + fields[4]);
			m.setSection(fields[5]);
			members.add(m);
		}
		
		return members;

	}	// getCourseMembers
	
	/**
	* Get all the course objects in specific term and with the user as the instructor
	* @param instructorEid The id for the instructor
	* @param termYear The term year
	* @param termTerm The term term
	* @return The list of courses
	*/
	public List getInstructorCourses(String instructorId, String termYear, String termTerm)
	{
		Vector rv = new Vector();
		int i = 0;
		String instructorEid = null;
		try {
			instructorEid = m_userDirectoryService.getUserEid(instructorId);
		} catch (UserNotDefinedException e1) {
			log.warn("No eid for instructorId: "+instructorId,e1);
			instructorEid = instructorId;
		}
		try
		{
			//getInstructorSections returns 12 strings: year, term_id, campus_code, 
			//subject, catalog_nbr, class_section, title, url, component, role, 
			//subrole, "CL" if cross-listed, blank if not
			Vector courses = getUmiac().getInstructorSections (instructorEid, termYear, (String) termIndex.get(termTerm));
			
			int count = courses.size();
			for (i=0; i<courses.size(); i++)
			{
				String[] res = (String[]) courses.get(i);
				Course c = new Course();
				c.setId(res[0] + "," + res[1] + "," + res[2] + "," + res[3] + "," + res[4] + "," + res[5]);
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
				}
				
				//output as a Vector of String[] objects (one String[] per output line:
				//sort_name|uniqname|umid|level (always "-")|credits|role|enrl_status
				Vector plist = getUmiac().getClassList (res[0], res[1], res[2], res[3], res[4], res[5]);
				Vector members = new Vector();
				for (int j= 0; j<plist.size(); j++)
				{
					String[] res1 = (String[]) plist.get(j);
					
					CourseMember m = new CourseMember();
					m.setName(res1[0]);
					m.setUniqname(res1[1]);
					m.setId(res1[2]);
					m.setLevel(res1[3]);
					m.setCredits(res1[4]);
					m.setRole(res1[5]);
					members.add(m);
				}
				c.setMembers(members);
				rv.add(c);
			}
		}
		catch (Exception e)
		{
			//log.info(this + " Cannot find any course in record for the instructor with id " + instructorId + ". ");
		}
		return rv;
		
	}	// getInstructorCourses
	
	/**
	 * @inheritDoc
	 */
	public String getProviderId(List providerIdList)
	{
		boolean same_course = true;
		// No sections in list
		if (providerIdList.size() == 0) 
		{
			return null;
		}
		// One section in list
		else if (providerIdList.size() == 1) 
		{
			// 2002,2,A,EDUC,406,001
			return (String) providerIdList.get(0);
		}
		// More than one section in list
		else
		{
			String full_key = (String) providerIdList.get(0);
			
			String course = full_key.substring(0, full_key.lastIndexOf(","));
			same_course = true;
			for (ListIterator i = providerIdList.listIterator(); i.hasNext(); )
			{
				String item = (String) i.next();
				if (item.indexOf(course) == -1) same_course = false; // If there is a difference in course part, multiple courses
			}
			// Same course but with multiple sections
			if (same_course)
			{
				StringBuffer sections = new StringBuffer();
				sections.append(course);
				sections.append(",[");
				boolean first_section = true;
				for (ListIterator i = providerIdList.listIterator(); i.hasNext(); )
				{
					String item = (String) i.next();
					// remove the "," from the first section string
					String section = new String();
					if (first_section)
					{
						section = item.substring(item.lastIndexOf(",")+1,item.length());
					}
					else
					{
						section = item.substring(item.lastIndexOf(","),item.length());
					}
					first_section = false;
					sections.append(section);
				}
				sections.append("]");
				// 2002,2,A,EDUC,406,[001,002,003]
				return sections.toString();
			}
			// Multiple courses 
			else
			{
				// First, put course section keys next to each other to establish the course demarcation points
				Vector keys = new Vector();
				for (int i = 0; i < providerIdList.size(); i++ )
				{
					String item = (String) providerIdList.get(i);
					keys.add(item);
				}
				Collections.sort(keys);
				StringBuffer buf = new StringBuffer();
				StringBuffer section_buf = new StringBuffer();
				String last_course = null;
				String last_section = null;
				String to_buf = null;
				// Compare previous and next keys. When the course changes, build a component part of the id.
				for (int i = 0; i < keys.size(); i++)
				{
					// Go through the list of keys, comparing this key with the previous key
					String this_key= (String) keys.get(i);
					String this_course = this_key.substring(0, this_key.lastIndexOf(","));
					String this_section = this_key.substring(this_key.lastIndexOf(","), this_key.length());
					last_course = this_course;
					if(i != 0)
					{
						// This is not the first key in the list, so it has a previous key
						String previous_key = (String) keys.get(i-1);
						String previous_course = previous_key.substring(0, previous_key.lastIndexOf(","));
						String previous_section = previous_key.substring(previous_key.lastIndexOf(","), previous_key.length());
						if (previous_course.equals(this_course))
						{
							same_course = true;
							section_buf.append(previous_section);
						}
						else
						{
							same_course = false; // Different course, so wrap up the realm component for the previous course
							buf.append(previous_course);
							section_buf.append(previous_section);
							if (section_buf.lastIndexOf(",") == 0) // ,001
							{
								to_buf = section_buf.toString();
								buf.append(to_buf);
							}
							else
							{
								buf.append(",[");
								to_buf = section_buf.toString();
								buf.append(to_buf.substring(1)); // 001,002
								buf.append("]");	
							}
							section_buf.setLength(0);
							buf.append("+");
						}
						last_section = this_section;
					} // one comparison
				}
				// Hit the end of the list, so wrap up the realm component for the last course in the list
				if (same_course)
				{
					buf.append(last_course);
					buf.append(",[");
					buf.append((section_buf.toString()).substring(1));
					buf.append(last_section);
					// There must be more than one section, because there the last course was the same as this course
					buf.append ("]");
				}
				else
				{
					// There can't be more than one section, because the last course was different from this course
					buf.append(last_course);
					buf.append(last_section);
				}
				// 2003,3,A,AOSS,172,001+2003,3,A,NRE,111,001+2003,3,A,ENVIRON,111,001+2003,3,A,SOC,111,001
				return buf.toString();
			}
		}
	}
	
}	// UnivOfMichCourseManagementProvider

/**********************************************************************************
*
* $Header: /cvs/ctools/ctools-providers/component/src/java/org/sakaiproject/component/legacy/coursemanagement/UnivOfMichCourseManagementProvider.java,v 1.1 2005/05/25 02:36:51 ggolden.umich.edu Exp $
*
**********************************************************************************/
