package org.sakaiproject.util.api.umiac;

import java.util.Map;
import java.util.Vector;

import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.service.legacy.user.UserEdit;

public interface UmiacClient {

	/**
	 * Sets the port for the target UMIAC server.
	 * @param port The UMIAC port.
	 */
	public abstract void setPort(int port); // setPort

	/**
	 * Gets the port for the target UMIAC server.
	 * @return The UMIAC port
	 */
	public abstract int getPort(); // getPort

	/**
	 * Sets the host name for the target UMIAC server.
	 * @param host The UMIAC host name.
	 */
	public abstract void setHost(String host); // setHost

	/**
	 * Gets the host name for the target UMIAC server.
	 * @return The host name for UMIAC.
	 */
	public abstract String getHost(); // getHost

	/**
	 * Get a name for a user by id, setting a first name and last name into the UserEdit.
	 * @param edit The UserEdit with the id to check, and to be filled in with the information found.
	 * @exception IdUnusedException If there is no user by this id.
	 */
	public abstract void setUserNames(UserEdit edit) throws IdUnusedException; // setUserNames

	/**
	 * See if a user by this id exists.
	 * @param id The user uniqname.
	 * @return true if a user by this id exists, false if not.
	 */
	public abstract boolean userExists(String id);

	/**
	 * Get the names for this user.
	 * @param id The user uniqname.
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
	public abstract Map getGroupRoles(String id) throws IdUnusedException; // getGroupRoles

	/**
	 * Get all the external realm ids the user has a role in, and the role
	 * @param id The user id.
	 * @return A map of he realm id to the role for this user.
	 */
	public abstract Map getUserSections(String id); // getUserSections

	/**
	 * Get all the members of a group, by their group role.
	 * A group is defined by multiple external ids.
	 * @param id The group id.
	 * @return The group's full display name.
	 * @exception IdUnusedException If there is no group by this id.
	 */
	public abstract Map getGroupRoles(String[] id) throws IdUnusedException; // getGroupRoles

	/**
	 * Send a getClasslist command to UMIAC and return the resulting
	 * output as a Vector of String[] objects (one String[] per output line:
	 * sort_name|uniqname|umid|level (always "-")|credits|role|enrl_status
	 *
	 */
	public abstract Vector getClassList(String year, String term,
			String campus, String subject, String course, String section); // getClassList

	/**
	 * Send a command to the UMIAC using the getUserInfo batch API and return
	 * the output as a Vector of String[] objects (one String[] per output line):
	 * // 0: |Fred Farley Fish|70728384|FFISH|08-25-2000 01:46:30 PM
	 *
	 */
	public abstract Vector getUserInformation(String ids) throws Exception; // getUserInformation

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
	public abstract Vector getInstructorSections(String id, String term_year,
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
	public abstract Vector getInstructorClasses(String id, String term_year,
			String term) throws IdUnusedException; // getInstructorClasses
	
	/**
	 * Get sections based on given url
	 */
	public Vector getUrlSections(String url);	// getUrlSections
	
	/**
	 * Set group url to specified section record
	 */
	public void setGroupUrl(String year, String term, String campus, String subject, String course, String section, String url)	;	//setGroupUrl
	
	/**
	 * Unpack a multiple id that may contain many full ids connected with "+", each
	 * of which may have multiple sections enclosed in []
	 * @param id The multiple group id.
	 * @return An array of strings of real umiac group ids, one for each in the multiple.
	 */
	public String[] unpackId(String id);	// unpackId
	
}