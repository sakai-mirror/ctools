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
import java.util.Hashtable;
import java.util.List;
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

	/** Configuration: kerberos or cosign. */
	protected boolean m_useKerberos = true;

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
	* @param instructorId The id for the instructor
	* @param termYear The term year
	* @param termTerm The term term
	* @return The list of courses
	*/
	public List getInstructorCourses(String instructorId, String termYear, String termTerm)
	{
		Vector rv = new Vector();
		int i = 0;
		
		try
		{
			//getInstructorSections returns 12 strings: year, term_id, campus_code, 
			//subject, catalog_nbr, class_section, title, url, component, role, 
			//subrole, "CL" if cross-listed, blank if not
			Vector courses = getUmiac().getInstructorSections (instructorId, termYear, (String) termIndex.get(termTerm));
			
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

}	// UnivOfMichCourseManagementProvider

/**********************************************************************************
*
* $Header: /cvs/ctools/ctools-providers/component/src/java/org/sakaiproject/component/legacy/coursemanagement/UnivOfMichCourseManagementProvider.java,v 1.1 2005/05/25 02:36:51 ggolden.umich.edu Exp $
*
**********************************************************************************/
