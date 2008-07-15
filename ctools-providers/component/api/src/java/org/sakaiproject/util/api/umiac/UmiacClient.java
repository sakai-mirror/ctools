package org.sakaiproject.util.api.umiac;


import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.user.api.UserEdit;

public interface UmiacClient {


	/**
	 * Get a name for a user by id, setting a first name and last name into the UserEdit.
	 * @param edit The UserEdit with the id to check, and to be filled in with the information found.
	 * @exception IdUnusedException If there is no user by this id.
	 */
	public abstract void setUserNames(UserEdit edit) throws IdUnusedException; // setUserNames


	/**
	 * See if a user by this id exists.
	 * @param id The user unique name.
	 * @return true if a user by this id exists, false if not.
	 */
	public abstract boolean userExists(String id);

	/**
	 * Get the names for this user.
	 * @param id The user unique name.
	 * @return String[]: [0] sort name, [1] display name, [2] last name, and [3] first name,
	 * or null if the user does not exist.
	 */
	public abstract String[] getUserName(String id); // getUserName

	/**
	 * Get a name for a group (class) by id.
	 * @param id The group id.
	 * @return The group's full display name.
	 * @exception IdUnusedException If there is no group by this id.
	 */
	public abstract String getGroupName(String id) throws IdUnusedException; // getGroupName

	/**
	 * Get all the members of a group, by their group role
	 * @param id The group id.
	 * @return The group's full display name.
	 * @exception IdUnusedException If there is no group by this id.
	 */
	public abstract Map<String, String> getGroupRoles(String id) throws IdUnusedException; // getGroupRoles

	/**
	 * Get all the external realm ids the user has a role in, and the role.  
	 * For teachers this will contain the TEACH site so that they have "magic" access to 
	 * teaching support.  That doesn't appear in the getInstructorSections command.
	 * @param id The user id.
	 * @return A map of he realm id to the role for this user.
	 */
	public abstract Map<String, String> getUserSections(String id); // getUserSections

	/**
	 * Get all the members of a group, by their group role.
	 * A group is defined by multiple external ids.
	 * @param id The group id.
	 * @return The group's full display name.
	 * @exception IdUnusedException If there is no group by this id.
	 */
	public abstract Map<String, String> getGroupRoles(String[] id) throws IdUnusedException; // getGroupRoles

	/**
	 * Send a getClasslist command to UMIAC and return the resulting
	 * output as a Vector of String[] objects (one String[] per output line:
	 * sort_name|uniqname|umid|level (always "-")|credits|role|enrl_status
	 *
	 */
	public abstract Vector<String[]> getClassList(String year, String term,
			String campus, String subject, String course, String section); // getClassList
	
	/**
	 * get class category
	 *
	 */
	public abstract String getClassCategory(String year, String term,
			String campus, String subject, String course, String section); // getClassCategory

	/**
	 * Send a command to the UMIAC using the getUserInfo batch API and return
	 * the output as a Vector of String[] objects (one String[] per output line):
	 * // 0: |Fred Farley Fish|70728384|FFISH|08-25-2000 01:46:30 PM
	 *
	 */
	public abstract Vector<String[]> getUserInformation(String ids) throws Exception; // getUserInformation

	/**
	 * getInstructorSections
	 *
	 * Sends a getInstructorSections command to UMIAC and returns the resulting
	 * output as a Vector of String[] objects (one String[] per output line of
	 * year|term_id|campus_code|subject|catalog_nbr|class_section|title|url|
	 * component (e.g., LAB, DISC)|role|subrole|crosslist ("CL" if cross-listed,
	 * blank if not)  Note: String[] will have 12 elements if CL is appended and
	 * 11 elements if it is not.
	 * Output is terminated by EOT
	 * As opposed to getInstructorClasses, the output is in data format rather
	 * that text (e.g., A rather than Ann Arbor, D rather than Dearborn).
	 * The results include cross-listed sections.
	 * @param id is the Instructor's uniqname
	 * @param term_year is expressed in four-digit numbers: 2003
	 * @param term is expressed as a single-digit number:
	 * 1 - SUMMER
	 * 2 - FALL
	 * 3 - WINTER
	 * 4 - SPRING
	 * 5 - SPRING/SUMMER
	 */
	public abstract Vector<String[]> getInstructorSections(String id, String term_year,
			String term) throws IdUnusedException; // getInstructorSections

	/**
	 * getInstructorClasses
	 *
	 * Sends a getInstructorClasses command to UMIAC and returns the resulting
	 * output as a Vector of String[] objects (one String[] per output line of 
	 * 14 fields: year|term (text)|campus (text)|subject|catalog_nbr|title|(legacy, always blank)|
	 * class_section|url|units taken (blank for instructors)|component (LEC, DIS, LAB, etc)|
	 * role|subrole|enrl_status)
	 * Output is terminated by EOT
	 * As opposed to getInstructorSections, the output is in a human-readable format
	 * rather than data (e.g., Ann Arbor rather than A, Dearborn rather than D).
	 * The results do not include cross-listed sections.
	 * @param id is the Instructor's uniqname
	 * @param term_year is expressed in four-digit numbers: 2003
	 * @param term is expressed as a single-digit number:
	 * 1 - SUMMER
	 * 2 - FALL
	 * 3 - WINTER
	 * 4 - SPRING
	 * 5 - SPRING/SUMMER
	 */
	public abstract Vector<String[]> getInstructorClasses(String id, String term_year,
			String term) throws IdUnusedException; // getInstructorClasses
	
	/**
	 * Get sections based on given url
	 */
	public Vector<String> getUrlSections(String url);	// getUrlSections
	
	/**
	 * Set group url to specified section record
	 */
	public void setGroupUrl(String year, String term, String campus, String subject, String course, String section, String url)	;	//setGroupUrl
	
	/**
	 * Get set of course offering eids which are cross-listed with the provided course offering
	 * If there is no cross-listings, empty list will be returned
	 * @param year
	 * @param term
	 * @param campus
	 * @param subject
	 * @param course
	 * @return
	 */
	public Set<String> getCrossListingsByCourseOffering(String year, String term, String campus, String subject, String course);
	
	/**
	 * get the term index table
	 */
	public Hashtable<String, String> getTermIndexTable();
	
	/**
	 * 
	 * @param ids
	 * @return
	 */
	public String packId(String[] ids);
	
	/**
	 * Unpack a multiple id that may contain many full ids connected with "+", each
	 * of which may have multiple sections enclosed in []
	 * @param id The multiple group id.
	 * @return An array of strings of real umiac group ids, one for each in the multiple.
	 */
	public String[] unpackId(String id);	// unpackId
	

	
}