/**********************************************************************************
*
* $Header: /cvs/ctools/ctools-providers/component/src/java/org/sakaiproject/component/legacy/realm/UnivOfMichRealmProvider.java,v 1.1 2005/05/25 02:36:52 ggolden.umich.edu Exp $
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

package org.sakaiproject.component.legacy.realm;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.authz.api.GroupProvider;
import org.sakaiproject.util.api.umiac.UmiacClient;

/**
* <p>UnivOfMichRealmProvider with information from U of M's UMIAC system.</p>
* <p>ExternalRealmId is converted into a UMIAC class/section identifier</p>
*
* @author University of Michigan, CTools / Sakai Software Development Team
* @version $Revision$
*/
public class UnivOfMichRealmProvider implements GroupProvider
{
	/*******************************************************************************
	* Dependencies and their setter methods
	*******************************************************************************/

	private static Log log = LogFactory.getLog(UnivOfMichRealmProvider.class);

	/** My UMIAC client interface. */
	//private IUmiacClient m_umiac = UmiacClient.getInstance();
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


	/**
	* Construct.
	*/
	public UnivOfMichRealmProvider()
	{
	} // UnivOfMichRealmProvider

	/**
	 * {@inheritDoc}
	 */
	public String getRole(String eid, String user)
	{
		if (eid == null) return null;

		String rv = null;

		// compute the set of individual umiac ids that are packed into id
		String eids[] = unpackId(eid);

		// use the user's external list of sites : Map of provider id -> role for this user
		Map map = getUmiac().getUserSections(user);
		if (!map.isEmpty())
		{
			for (int i = 0; i < eids.length; i++)
			{
				// does this one of my ids exist in the map?
				String roleId = (String) map.get(eids[i]);
				if (roleId != null)
				{
					// prefer "Instructor" to "Student" in roles
					if (!"Instructor".equals(rv))
					{
						rv = roleId;
					}
				}
			}
		}

		return rv;
	}

	/**
	 * {@inheritDoc}
	 */
	public Map getUserRolesForGroup(String eid)
	{
		if (eid == null) return new HashMap();

		// compute the set of individual umiac ids that are packed into id
		String eids[] = unpackId(eid);

		// get a Map of userId - role string (Student, Instructor) for these umiac ids
		try
		{
			Map map = getUmiac().getGroupRoles(eids);

			return map;
		}
		catch (IdUnusedException e)
		{
			return new HashMap();
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public Map getGroupRolesForUser(String eid)
	{
		if (eid == null) return new HashMap();

		// get the user's external list of sites : Map of provider id -> role for this user
		Map map = getUmiac().getUserSections(eid);

		// transfer to our special map
		MyMap rv = new MyMap();
		rv.putAll(map);

		return rv;
	}

	/**
	 * Unpack a multiple id that may contain many full ids connected with "+", each
	 * of which may have multiple sections enclosed in []
	 * @param eid The multiple group id.
	 * @return An array of strings of real umiac group ids, one for each in the multiple.
	 */
	public String[] unpackId(String eid)
	{
		return m_umiac.unpackId(eid);
	}

	/**
	 * <p>MyMap is a Map that in get() recognizes compound keys.</p>
	 */
	public class MyMap extends HashMap
	{
		/**
		 * {@inheritDoc}
		 */
		public Object get(Object key)
		{
			// if we have this key exactly, use it
			Object value = super.get(key);
			if (value != null)
				return value;

			// otherwise break up key as a compound id and find what values we have for these
			// the values are roles, and we prefer "Instructor" to "Student"
			String rv = null;
			String[] eids = unpackId((String) key);
			for (int i = 0; i < eids.length; i++)
			{
				value = super.get(eids[i]);
				if ((value != null) && !("Instructor".equals(rv)))
				{
					rv = (String) value;
				}
			}

			return rv;
		}
	}
}

/**********************************************************************************
*
* $Header: /cvs/ctools/ctools-providers/component/src/java/org/sakaiproject/component/legacy/realm/UnivOfMichRealmProvider.java,v 1.1 2005/05/25 02:36:52 ggolden.umich.edu Exp $
*
**********************************************************************************/
