package org.sakaiproject.component.legacy.realm;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.authz.api.GroupProvider;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.util.api.umiac.EvalUmiacClient;

/**
 * This provider implementation calls Umiac api's set up specifically for U-M Course Evaluations.
 * It should not be used outside the Evaluation System implementation by the University of Michigan.
 * 
 * @author rwellis
 *
 */
public class EvalUmiacProvider implements
		GroupProvider {
	
	/*******************************************************************************
	* Dependencies and their setter methods
	*******************************************************************************/

	private static Log log = LogFactory.getLog(EvalUmiacProvider.class);
	
	private static String INSTRUCTOR_ROLE_STRING = "Instructor";
	
	private static String STUDENT_ROLE_STRING = "Student";

	/** My UMIAC client interface. */
	//private IUmiacClient m_umiac = UmiacClient.getInstance();
	private EvalUmiacClient m_umiac;

	public void setUmiac(EvalUmiacClient m_umiac) {
		this.m_umiac = m_umiac;
	}

	public EvalUmiacClient getUmiac() {
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
	}

	/**
	 * Final cleanup.
	 */
	public void destroy()
	{
		log.info(this +".destroy()");
	}

	/*******************************************************************************
	* GroupProvider implementation
	*******************************************************************************/
	//TODO this keeps Evaluation methods isolated from GroupProvider methods but duplicated code

	/**
	* Construct.
	*/
	public EvalUmiacProvider()
	{
	}


	public Map getGroupRolesForUser(String eid) {

		if (eid == null) return new HashMap();

		// get the user's external list of sites : Map of provider id -> role for this user
		// calls Umiac's getUserEvalGroups api
		Map map = getUmiac().getEvalUserSections(eid);

		// transfer to our special map
		HashMap rv = new HashMap();
		rv.putAll(map);

		return rv;
	}

	public String getRole(String eid, String user) {
		
		//return null;
		if (eid == null) return null;

		String rv = null;

		// compute the set of individual umiac ids that are packed into id
		String eids[] = unpackId(eid);

		// use the user's external list of sites : Map of provider id -> role for this user
		//calls Umiac's getUserEvalGroups api
		Map map = getUmiac().getEvalUserSections(user);
		if (!map.isEmpty())
		{
			for (int i = 0; i < eids.length; i++)
			{
				// does this one of my ids exist in the map?
				String roleId = (String) map.get(eids[i]);
				if (roleId != null)
				{
					// prefer "Instructor" to "Student" in roles
					if (!INSTRUCTOR_ROLE_STRING.equals(rv))
					{
						rv = roleId;
					}
				}
			}
		}

		return rv;
	}

	public Map getUserRolesForGroup(String eid) {

		//return null;
		if (eid == null) return new HashMap();

		// compute the set of individual umiac ids that are packed into id
		String eids[] = unpackId(eid);

		// get a Map of userId - role string (Student, Instructor) for these umiac ids
		try
		{
			// this calls Umiac's getEvalGroupMemberships api
			Map map = getUmiac().getEvalGroupRoles(eids);
			if (map != null)
			{
				Set keys = map.keySet();
				String role = null;
				for (Iterator s = keys.iterator(); s.hasNext();)
				{
					String userId = (String) s.next();
					
					// only the getUserSections returns secondary roles. Use it to watch out possible secondary roles and update the userid-role map
					// this calls Umiac's getUserEvalGroups api
					Map map1 = getUmiac().getEvalUserSections(userId);
					if (map1 != null)
					{
						for (int j = 0; j< eids.length; j++)
						{
							if (map1.containsKey(eids[j]))
							{
								role = (String) map1.get(eids[j]);
							}
						}
					}
					map.put(userId, role);
				}
			}

			return map;
		}
		catch (IdUnusedException e)
		{
			return new HashMap();
		}
	}

	public String packId(String[] ids) {

		return m_umiac.packId(ids);
	}

	public String preferredRole(String one, String other) {

		// Instructor is better than Student
		if ((one != null && INSTRUCTOR_ROLE_STRING.equals(one)) || (other != null && (INSTRUCTOR_ROLE_STRING.equals(other)))) return INSTRUCTOR_ROLE_STRING;
		
		// Student is better than nothing
		if ((one != null && STUDENT_ROLE_STRING.equals(one)) || (other!= null &&STUDENT_ROLE_STRING.equals(other))) return STUDENT_ROLE_STRING;
		
		// something we don't know, so we just return the latest role found
		return one;
	}

	public String[] unpackId(String eid) {

		return m_umiac.unpackId(eid);
	}

}
