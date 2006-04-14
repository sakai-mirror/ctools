/**********************************************************************************
*
* $Header: /cvs/ctools/ctools-providers/component/src/java/org/sakaiproject/util/UmiacClient.java,v 1.3 2005/05/26 00:55:34 ggolden.umich.edu Exp $
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
package org.sakaiproject.util.impl.umiac;

// imports
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.service.framework.config.cover.ServerConfigurationService;
import org.sakaiproject.service.framework.log.Logger;
//import org.sakaiproject.service.framework.log.cover.Log;
//import org.sakaiproject.service.framework.log.cover.Logger;
import org.sakaiproject.service.framework.memory.Cache;
import org.sakaiproject.service.framework.memory.CacheRefresher;
import org.sakaiproject.service.framework.memory.cover.MemoryService;
import org.sakaiproject.service.legacy.event.Event;
import org.sakaiproject.service.legacy.user.UserEdit;
import org.sakaiproject.util.api.umiac.UmiacClient;
import org.sakaiproject.util.java.StringUtil;

/**
 * <p>UmiacClient is the Interface to the UMIAC service (classlist directory services).
 * This class translates calls from UmiacResponse to the UMIAC protocol and sends the protocol
 * via a TCP m_socket to a UMIAC server.</p>
 *
 * @author University of Michigan, CHEF Software Development Team
 * @version $Revision$
 */
public class UmiacClientImpl
	implements CacheRefresher, UmiacClient
{
	/** Umiac's network port address. */
	protected int m_port = -1;

	/** Umiac's network host address. */
	protected String m_host = null;
	
	/** A cache of calls to umiac and the results. */
	protected Cache m_callCache = null;

	/** The one and only Umiac client. */
	protected static UmiacClient M_instance = null;

	/** Dependency: logging service */
	protected Logger m_logger = null;

	/**
	 * Dependency: logging service.
	 * @param service The logging service.
	 */
	public void setLogger(Logger service)
	{
		m_logger = service;
	}

	public Logger getLogger()
	{
		return this.m_logger;
	}
	
	/** Get the umiac client. */
//	private static IUmiacClient getInstance()
//	{
//		if (M_instance == null) new UmiacClient();
//		return M_instance;
//
//	}	// getInstance

	/**
	* Construct, using the default production UMIAC instance.
	*/
	protected UmiacClientImpl()
	{
		// get the umiac address and port from the configuration service
		m_host = ServerConfigurationService.getString("umiac.address", null);
		try
		{
			m_port = Integer.parseInt(ServerConfigurationService.getString("umiac.port", "-1"));
		}
		catch (Exception ignore) {}

		if (m_host == null)
		{
			getLogger().warn(this + " - no 'umiac.address' in configuration");
//			Log.warn("chef", this + " - no 'umiac.address' in configuration");
		}
		if (m_port == -1)
		{
			getLogger().warn(this + " - no 'umiac.port' in configuration (or invalid integer)");
		}

		// build a synchronized map for the call cache, automatiaclly checking for expiration every 15 mins.
		m_callCache = MemoryService.newHardCache(this, 15 * 60);

		if (M_instance == null)
		{
			M_instance = this;
		}

	}	// UmiacClient

	/**
	 * Final initialization, once all dependencies are set.
	 */
	public void init()
	{
		try
		{
	//		if (Log.getLogger("chef").isDebugEnabled())
			if (getLogger().isDebugEnabled())
			{
				getLogger().debug(this +".init()");
			}
		//	m_logger.info(this +".init()");
		}
		catch (Throwable t)
		{
			if (getLogger().isDebugEnabled())
			{
				getLogger().debug(this +".init(): ", t);
			}
		//	m_logger.warn(this +".init(): ", t);
		}
	}

	/**
	 * Final cleanup.
	 */
	public void destroy()
	{
		if (getLogger().isDebugEnabled())
		{
			getLogger().debug(this +".destroy()");
		}
	//	m_logger.info(this +".destroy()");
	}

	
	/**
	* finalize
	*/
	protected void finalize()
	{
		if (this == M_instance)
		{
			M_instance = null;
		}

	}	// finalize

	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#setPort(int)
	 */
	public void setPort(int port)
	{
		m_port = port;

	}	// setPort
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getPort()
	 */
	public int getPort()
	{
		return m_port;

	}	// getPort
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#setHost(java.lang.String)
	 */
	public void setHost(String host)
	{
		m_host = host;

	}	// setHost
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getHost()
	 */
	public String getHost()
	{
		return m_host;

	}	// getHost

	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#userExists(java.lang.String)
	 */
	public boolean userExists(String id)
	{
		return (getUserName(id) != null);
	}

	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getUserName(java.lang.String)
	 */
	public String[] getUserName(String id)
	{
		String command = "getSortName," + id;

		// check the cache - still use expired entries
		if ((m_callCache != null) && (m_callCache.containsKeyExpiredOrNot(command)))
		{
			return (String[]) m_callCache.getExpiredOrNot(command);
		}

		Vector result = makeRawCall(command);

		// if there are no results, then we don't know the user
		if (	(result == null)
			||	(result.size() != 1)
			||	(((String) result.elementAt(0)).trim().length() == 0)
			||	(((String) result.elementAt(0)).trim().equals(",")))
		{
			// cache the miss for 60 minutes
			if (m_callCache != null) m_callCache.put(command, null, 60 * 60);

			return null;
		}

		String[] rv = new String[4];

		// get the result string for the sort name [0]
		//Fred, Farley Fish
		rv[0] = ((String) result.elementAt(0)).trim();

		// parse the result string for the display name [1]
		// Farley Fish Fred
		String[] res = StringUtil.split(rv[0], ",");
		String displayName = "";
		if (res.length > 1)
		{
			displayName = res[1] + " ";
		}
		rv[1] = displayName.concat(res[0]);

		// set the last name [2]
		rv[2] = res[0];
	
		// set the first name [3]
		if (res.length > 1)
		{
			rv[3] = res[1];
		}
		else
		{
			rv[3] = "";
		}

		// cache the results for 60 minutes
		if (m_callCache != null) m_callCache.put(command, rv, 60 * 60);

		return rv;

	}	// getUserName

	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getGroupName(java.lang.String)
	 */
	public String getGroupName(String id)
		throws IdUnusedException
	{
		String command = "getClassInfo," + id;

		// check the cache - still use expired entries
		if ((m_callCache != null) && (m_callCache.containsKeyExpiredOrNot(command)))
		{
			String rv = (String) m_callCache.getExpiredOrNot(command);
			if (rv == null)
			{
				throw new IdUnusedException(id);
			}
			return rv;
		}

		Vector result = makeRawCall(command);
		
		// if there are no results, or the one has no "|", then we don't know the user
		if (	(result == null)
			||	(result.size() < 1)
			||	(((String)result.elementAt(0)).indexOf("|") == -1))
		{
			// cache the miss for 60 minutes
			if (m_callCache != null) m_callCache.put(command, null, 60 * 60);

			throw new IdUnusedException(id);
		}
		
		// parse the result string for the name
		// 0: 1410|32220|Teach with Tech|https://chefproject.org/chef/portal/group/ED504|SEM|2002-09-03|2002-12-11|405000|School Of Education|EDU|Education
//		String[] res = StringUtil.split((String)result.elementAt(0),"|");
//		String name = res[2];

		// CT-512 - move the UMICH course name generation from SiteAction to Umiac
		
		// The result is generated from the id
		
		String [] fields;
		fields = id.split(",");
		StringBuffer tab = new StringBuffer();
		tab.append(fields[3]);
		tab.append(" ");
		tab.append(fields[4]);
		tab.append( " ");
		tab.append(fields[5]);
		
		String name = tab.toString();
		
		// cache the result for 60 minutes
		if (m_callCache != null) m_callCache.put(command, name, 60 * 60);

		return name;

	}	// getGroupName

	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getGroupRoles(java.lang.String)
	 */
	public Map getGroupRoles(String id)
		throws IdUnusedException
	{
		String command = "getClasslist," + id;

		// check the cache - still use expired entries
		if ((m_callCache != null) && (m_callCache.containsKeyExpiredOrNot(command)))
		{
			Map rv = (Map) m_callCache.getExpiredOrNot(command);
			if (rv == null)
			{
				throw new IdUnusedException(id);
			}
			return rv;
		}

		Vector result = makeRawCall(command);
		
		// if there are no results, or the one has no "|", then we don't know the user
		if (	(result == null)
			||	(result.size() < 1)
			||	(((String)result.elementAt(0)).indexOf("|") == -1))
		{
			// cache the miss for 60 minutes
			if (m_callCache != null) m_callCache.put(command, null, 60 * 60);

			throw new IdUnusedException(id);
		}

		// store user id key to role value in return table
		HashMap map = new HashMap();

		// parse each line of the result
		// 1: Burger,Ham F|HBURGER|11234541|-||Instructor|E
		for (int i = 0; i < result.size(); i++)
		{
			String[] res = StringUtil.split((String)result.elementAt(i),"|");
			String uid = res[1].toLowerCase();
			String role = res[5];
			map.put(uid, role);
		}
		
		// cache the result for 60 minutes
		if (m_callCache != null) m_callCache.put(command, null, 60 * 60);

		return map;

	}	// getGroupRoles

	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getUserSections(java.lang.String)
	 */
	public Map getUserSections(String id)
	{
		String command = "getUserSections," + id;

		// check the cache - still use expired entries
		if ((m_callCache != null) && (m_callCache.containsKeyExpiredOrNot(command)))
		{
			return (Map) m_callCache.getExpiredOrNot(command);
		}

		// make the call		
		Vector result = makeRawCall(command);

		// parse the results
		Map map = new HashMap();
	
		// if there are no results, or the one has no "|", then we have no class roles for the user
		if (	!(	(result == null)
				||	(result.size() < 1)
				||	(((String)result.elementAt(0)).indexOf("|") == -1)))
		{
			// parse each line of the result
			// ex: 2004,2,A,SI,653,001|Instructor|Primary
			for (int i = 0; i < result.size(); i++)
			{
				String[] res = StringUtil.split((String)result.elementAt(i),"|");
				String exId = res[0];
				String role = res[1];
				map.put(exId, role);
			}
		}

		// cache the results for 60 minutes
		if (m_callCache != null) m_callCache.put(command, map, 60 * 60);

		return map;

	}	// getUserSections

	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#setUserNames(org.sakaiproject.service.legacy.user.UserEdit)
	 */
	public void setUserNames(UserEdit edit)
		throws IdUnusedException
	{
		String[] name = getUserName(edit.getId());
		if (name == null)
		{
			throw new IdUnusedException(edit.getId());
		}
	
		edit.setLastName(name[2]);
		edit.setFirstName(name[3]);
	
	}	// setUserNames


	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getGroupRoles(java.lang.String[])
	 */
	public Map getGroupRoles(String[] id)
		throws IdUnusedException
	{
		StringBuffer commandBuf = new StringBuffer();
		commandBuf.append("getGroupMemberships");
		for (int i = 0; i < id.length; i++)
		{
			commandBuf.append(",");
			
			// convert the comma separated id string to a "|" separated one
			String[] parts = StringUtil.split(id[i], ",");
			commandBuf.append(parts[0]);
			for (int p = 1; p < parts.length; p++)
			{
				commandBuf.append("|");
				commandBuf.append(parts[p]);
			}
		}
		String command = commandBuf.toString();

		// check the cache - still use expired entries
		if ((m_callCache != null) && (m_callCache.containsKeyExpiredOrNot(command)))
		{
			Map rv = (Map) m_callCache.getExpiredOrNot(command);
			if (rv == null)
			{
				throw new IdUnusedException(id[0]);
			}
			return rv;
		}

		Vector result = makeRawCall(command);

		// if there are no results, or the one has no "|", then we don't know the user
		if (	(result == null)
			||	(result.size() < 1)
			||	(((String)result.elementAt(0)).indexOf("|") == -1))
		{
			// cache this miss for 60 minutes
			if (m_callCache != null) m_callCache.put(command, null, 60 * 60);

			throw new IdUnusedException(id[0]);
		}

		// store user id key to role value in return table
		HashMap map = new HashMap();

		// parse each line of the result
		// 2002,2,A,EDUC,547,003|Arrdvark Axis Betterman|Betterman,Arrdvark Axis|BOBOBOBOB|12345678|3|Student|E
		for (int i = 0; i < result.size(); i++)
		{
			String[] res = StringUtil.split((String)result.elementAt(i),"|");

			String uid = res[3].toLowerCase();
			String role = res[6];

			// the user res[3] has id res[3], display name res[1], sort name res[2]
			// TODO: do we really need to store the user names? -ggolden
			//m_userNames.put(uid, res[1]);
			//m_userSortNames.put(uid, res[2]);

			// if there's a role for this user already, and it's instructor, just leave it
			String roleAlready = (String) map.get(uid);
			if (	(roleAlready == null)
				||	(roleAlready.equals("Student") && role.equals("Instructor")))
			{
				map.put(uid, role);
			}
		}

		// cache the results for 60 minutes
		if (m_callCache != null) m_callCache.put(command, map, 60 * 60);

		return map;

	}	// getGroupRoles
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getClassList(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	public Vector getClassList (String year, String term, String campus, String subject, String course, String section)
	{
		String command = "getClasslist," + year + "," + term + "," + campus + "," + subject + "," + course + "," + section + "\n\n";

		// check the cache - still use expired entries
		if ((m_callCache != null) && (m_callCache.containsKeyExpiredOrNot(command)))
		{
			return (Vector) m_callCache.getExpiredOrNot(command);
		}

		Vector result = makeRawCall(command);
		
		// if there are no results
		if (	(result == null)
			||	(result.size() < 1))
		{
			// Log.warn("chef", "Cannot get the class record for " + year + "," + term + "," + campus + "," + subject + "," + course + "," + section);

			// TODO: NOTE: no cache miss, cause this might be a transitory error? -ggolden
			return null;
		}

		Vector rv = new Vector();
		for (int i = 0; i < result.size(); i++)
		{
			String[] res = StringUtil.split((String)result.elementAt(i),"|");
			rv.add(res);
		}

		// cache the results for 60 minutes
		if (m_callCache != null) m_callCache.put(command, rv, 60 * 60);

		return rv;
		
	} // getClassList
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getUserInformation(java.lang.String)
	 */
	public Vector getUserInformation (String ids)
		throws Exception
	{
		String command = "getUserInfo," + ids + "\n\n";

		// check the cache - still use expired entries
		if ((m_callCache != null) && (m_callCache.containsKeyExpiredOrNot(command)))
		{
			return (Vector) m_callCache.getExpiredOrNot(command);
		}

		Vector result = makeRawCall(command);
		
		// if there are no results
		if (	(result == null)
			||	(result.size() < 1))
		{
			// TODO: NOTE: no cache miss, cause this might be a transitory error? -ggolden
			throw new Exception("UMIAC: no results: " + command);
		}

		Vector rv = new Vector();
		for (int i = 0; i < result.size(); i++)
		{
			// 0: |Fred Farley Fish|70728384|FFISH|08-25-2000 01:46:30 PM
			String[] res = StringUtil.split((String)result.elementAt(i),"|");
			rv.add(res);
		}

		// cache the results for 60 minutes
		if (m_callCache != null) m_callCache.put(command, rv, 60 * 60);

		return rv;
		
	} // getUserInformation
	
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getInstructorSections(java.lang.String, java.lang.String, java.lang.String)
	 */
	public Vector getInstructorSections (String id, String term_year, String term)
		throws IdUnusedException
	{
		String command = "getInstructorSections," + id + "," + term_year + "," + term + "\n\n";

		if ((m_callCache != null) && (m_callCache.containsKeyExpiredOrNot(command)))
		{
			Vector rv = (Vector) m_callCache.getExpiredOrNot(command);
			if (rv == null)
			{
				throw new IdUnusedException(id);
			}

			return (Vector) m_callCache.getExpiredOrNot(command);
		}

		Vector result = makeRawCall(command);
		
		// if there are no results
		if (	(result == null)
			||	(result.size() < 1))
		{
			// cache the miss for 60 minutes
			if (m_callCache != null) m_callCache.put(command, null, 60 * 60);

			throw new IdUnusedException(id);
		}

		Vector rv = new Vector();
		for (int i = 0; i < result.size(); i++)
		{
			String[] res = StringUtil.split((String)result.elementAt(i),"|");
			rv.add(res);
		}

		// cache the results for 60 minutes
		if (m_callCache != null) m_callCache.put(command, rv, 60 * 60);

		return rv;
		
	} // getInstructorSections
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getInstructorClasses(java.lang.String, java.lang.String, java.lang.String)
	 */
	public Vector getInstructorClasses (String id, String term_year, String term)
		throws IdUnusedException
	{
		String command = "getInstructorClasses," + id + "," + term_year + "," + term + "\n\n";

		if ((m_callCache != null) && (m_callCache.containsKeyExpiredOrNot(command)))
		{
			Vector rv = (Vector) m_callCache.getExpiredOrNot(command);
			if (rv == null)
			{
				throw new IdUnusedException(id);
			}

			return (Vector) m_callCache.getExpiredOrNot(command);
		}

		Vector result = makeRawCall(command);
		
		// if there are no results
		if (	(result == null)
			||	(result.size() < 1))
		{
			// cache the miss for 60 minutes
			if (m_callCache != null) m_callCache.put(command, null, 60 * 60);

			throw new IdUnusedException(id);
		}

		Vector rv = new Vector();
		for (int i = 0; i < result.size(); i++)
		{
			String[] res = StringUtil.split((String)result.elementAt(i),"|");
			rv.add(res);
		}

		// cache the results for 60 minutes
		if (m_callCache != null) m_callCache.put(command, rv, 60 * 60);

		return rv;
		
	} // getInstructorClasses
	
	/**
	* Set group url to specified section record
	*/
	public void setGroupUrl(String year, String term, String campus, String subject, String course, String section, String url)
	{
		String command = "setGroupUrl," + year + "," + term + "," + campus + "," + subject + "," + course + "," + section + "," + url + "\n\n";

		makeRawCall(command);

	}	// setGroupUrl
	
	/**
	* Get sections based on given url
	*/
	public Vector getUrlSections(String url)
	{
		String command = "getUrlSections," + url + "\n\n";

		Vector result = makeRawCall(command);
		
		// if there are no results
		if (	(result == null)
			||	(result.size() < 1))
		{
			return null;
		}

		Vector rv = new Vector();
		for (int i = 0; i < result.size(); i++)
		{
			String[] res = StringUtil.split((String)result.elementAt(i),"|");
			String resString = "";
			for(int j = 0; j < res.length; j++)
			{
				// concat section info separated with ","
				resString = resString.concat(res[j]).concat(",");
			}
			// remove the last ","
			resString = resString.substring(0, resString.length()-1);
			rv.add(resString);
		}

		return rv;

	}	// getUrlSections

	/**
	* Send a command to UMIAC and returns the resulting
	* output as a vector of strings (one per response line).
	* No caching is attempted.
	* @param umiacCommand The UMIAC command string.
	* @return A Vector of Strings, one per response line.
	*/
	public Vector makeRawCall(String umiacCommand)
	{
		if (getLogger().isDebugEnabled())
		{
			getLogger().debug( this + ".makeCall: " + umiacCommand);
		}
		PrintWriter out = null;
		BufferedReader in = null;
		Socket socket = null;
		
		Vector v = new Vector();

		// Open up a m_socket and write out the command to UMIAC.
		try
		{
			socket = new Socket(m_host,m_port);
			out = new PrintWriter(socket.getOutputStream(), true);
			in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			out.println(umiacCommand);
			String inString;

			// Now that we have a m_socket open and have thrown our command to UMIAC,
			// we listen for data returning on the m_socket.  UMIAC returns pipe-
			// delimited lines of data. When finished, UMIAC sends a single line
			// of "EOT".
			inString = in.readLine();
			while ((inString != null) && !inString.equalsIgnoreCase("EOT"))
			{
				// Fill up the vector with the strings being returned
				v.add(inString);
				
				// get the next line
				inString = in.readLine();
			}
		}
		catch (Throwable e)
		{
			getLogger().warn("UMIAC: " + e.toString());
	//		Logger.warn("UMIAC: " + e.toString());
		}
		finally
		{
			// Close all the m_sockets, regardless of what happened
			try
			{
				if (in != null) in.close();
				if (out != null) out.close();
				if (socket != null) socket.close();
			}
			catch (Exception ignore){getLogger().warn("UMIAC: " + ignore);}
//			catch (Exception ignore){Logger.warn("UMIAC: " + ignore);}
		}
		
		return v;

	}	// makeRawCall
	
	/**
	 * Unpack a multiple id that may contain many full ids connected with "+", each
	 * of which may have multiple sections enclosed in []
	 * @param id The multiple group id.
	 * @return An array of strings of real umiac group ids, one for each in the multiple.
	 */
	public String[] unpackId(String id)
	{
		if (id == null) return null;

		Vector returnVector = new Vector();

		// first unpack the full ids
		String[] first = unpackIdFull(id);

		// then, for each, unpack the sections
		for (int i = 0; i < first.length; i++)
		{
			String[] second = unpackIdSections(first[i]);
			for (int s = 0; s < second.length; s++)
			{
				returnVector.add(second[s]);
			}
		}

		String[] rv = (String[]) returnVector.toArray(new String[returnVector.size()]);

		return rv;
	}

	/**
	 * Unpack a crosslisted multiple groupId into a set of individual group ids.
	 * 2002,2,A,EDUC,504,[001,002,003,004,006]+2002,2,A,LSA,101,[002,003]+etc
	 * @param id The crosslisted multiple group id.
	 * @return An array of strings of real umiac group ids, one for each in the multiple.
	 */
	protected String[] unpackIdFull(String id)
	{
		String[] rv = null;

		// if there is not a '+' return just the id
		int pos = id.indexOf('+');
		if (pos == -1)
		{
			rv = new String[1];
			rv[0] = id;
		}
		else
		{
			// split by the "+" separators
			rv = StringUtil.split(id, "+");
		}

		return rv;
	}

	/**
	 * Unpack a multiple section groupId into a set of individual group ids.
	 * 2002,2,A,EDUC,504,[001,002,003,004,006]
	 * @param id The multiple section group id.
	 * @return An array of strings of real umiac group ids, one for each section in the multiple.
	 */
	protected String[] unpackIdSections(String id)
	{
		String[] rv = null;

		// if there is not a '[' and a ']', or they are inverted or enclose an empty string,
		// return just the id
		int leftPos = id.indexOf('[');
		int rightPos = id.indexOf(']');
		if (!((leftPos != -1) && (rightPos != -1)) || (rightPos - leftPos <= 1))
		{
			rv = new String[1];
			rv[0] = id;
		}
		else
		{
			// isolate the root
			String root = id.substring(0, leftPos);

			// isolate the sections
			String sectionString = id.substring(leftPos + 1, rightPos);

			// separate these
			String sections[] = StringUtil.split(sectionString, ",");

			// handle misformed strings
			if ((sections == null) || (sections.length == 0))
			{
				rv = new String[1];
				rv[0] = id;
			}

			else
			{
				// build a return for each section
				rv = new String[sections.length];
				for (int i = 0; i < sections.length; i++)
				{
					rv[i] = root + sections[i];
				}
			}
		}

		return rv;
	}

	/*******************************************************************************
	* CacheRefresher implementation
	*******************************************************************************/

	/**
	* Get a new value for this key whose value has already expired in the cache.
	* @param key The key whose value has expired and needs to be refreshed.
	* @param oldValue The old exipred value of the key.
	* @param event The event which triggered this refresh.
	* @return a new value for use in the cache for this key; if null, the entry will be removed.
	*/
	public Object refresh(Object key, Object oldValue, Event event)
	{
		// instead of refreshing when an entry expires, let it go and we'll get it again if needed -ggolden
		// return makeRawCall((String)key);

		return null;

	}	// refresh

}	// class UmiacClient

/**********************************************************************************
*
* $Header: /cvs/ctools/ctools-providers/component/src/java/org/sakaiproject/util/UmiacClient.java,v 1.3 2005/05/26 00:55:34 ggolden.umich.edu Exp $
*
**********************************************************************************/
