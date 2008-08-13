package org.sakaiproject.util.api.umiac;

import java.util.Map;

import org.sakaiproject.exception.IdUnusedException;

public interface EvalUmiacClient {

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
	 * Get all the members of a group, by their group role for Course Evaluations
	 * 
	 * A behind-the-scenes modification of getGroupRoles(String id) tailored to
	 * the Evaluation tool.
	 *  
	 * Instructors are pulled from a table that may be modified in M-Pathways by E&E
	 * or departmental staff to determine who has "be.evaluated" permission in the
	 * Evaluation tool rather than getting that information from the course roster.
	 * The students should be the same as for getGroupRoles(String id).
	 * 
	 * @see org.sakaiproject.component.legacy.realm.EvalGroupsProviderUnivOfMichImpl
	 * 
	 * @param id The group id followed by "|" and the evaluation eid
	 * @return The group's full membership information
	 * @exception IdUnusedException If there is no group by this id.
	 */
	public abstract Map<String, String> getEvalGroupRoles(String[] id) throws IdUnusedException;  // variant of getGroupRoles for Course Evaluations

	/**
	 * Get all the external group ids the user has a role in, and the role, for Course Evaluations.
	 * 
	 * A behind-the-scenes modification of getUserSections(String id) tailored to
	 * the Evaluation tool.
	 * 
	 * 	 * Instructors are pulled from a table that may be modified in M-Pathways by E&E
	 * or departmental staff to determine who has "be.evaluated" permission in the
	 * Evaluation tool rather than getting that information from the course roster.
	 * The students should be the same as for getGroupRoles(String id).
	 * 
	 * @see org.sakaiproject.component.legacy.realm.EvalGroupsProviderUnivOfMichImpl
	 * 
	 * @param id The user id.
	 * @return A map of the group id to the role for this user.
	 */
	public abstract Map<String, String> getEvalUserSections(String id); // variant of getUserSections for Course Evaluations
	
	/**
	 * Unpack a multiple id that may contain many full ids connected with "+", each
	 * of which may have multiple sections enclosed in []
	 * @param id The multiple group id.
	 * @return An array of strings of real umiac group ids, one for each in the multiple.
	 */
	public String[] unpackId(String id);	// unpackId

	/**
	 * 
	 * @param ids
	 * @return
	 */
	public String packId(String[] ids);


}