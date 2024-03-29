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
import java.io.InterruptedIOException;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.component.cover.ServerConfigurationService;
import org.sakaiproject.event.api.Event;
import org.sakaiproject.memory.api.Cache;
import org.sakaiproject.memory.api.CacheRefresher;
import org.sakaiproject.memory.cover.MemoryServiceLocator;
import org.sakaiproject.util.api.umiac.EvalUmiacClient;
import org.sakaiproject.util.StringUtil;


/**
 * EvalUmiacClientImpl implements calls to Umiac for Evaluation data.
 * 
 * @author rwellis
 *
 */
public class EvalUmiacClientImpl
	implements CacheRefresher, EvalUmiacClient
{
	/** Umiac's network port address. */
	protected int m_port = -1;

	/** Umiac's network host address. */
	protected String m_host = null;
	
	/** A cache of calls to umiac and the results. */
	protected Cache m_callCache = null;

	/** The one and only Umiac client. */
	protected static EvalUmiacClient M_instance = null;
	
	/** Socket timeout for Umiac response. This is the time 
	 * to wait before a failure for Umiac to respond is considered an error.
	 * This can be large since it won't have any effect during normal usage. */
	
	protected int m_umiacSocketTimeout = 3000;
	
	private static Log log = LogFactory.getLog(UmiacClientImpl.class);

	/* default cache duration to 1 hour */
	private int cacheDurationSeconds = 60 * 60;

	/**
	* Construct, using the default production UMIAC instance.
	*/
	protected EvalUmiacClientImpl()
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
			log.warn(this + " - no 'umiac.address' in configuration");
		}
		if (m_port == -1)
		{
			log.warn(this + " - no 'umiac.port' in configuration (or invalid integer)");
		}

		// build a synchronized map for the call cache, automatically checking for expiration every 15 mins.
		m_callCache = MemoryServiceLocator.getInstance().newHardCache(this, 15 * 60);

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
			if (log.isDebugEnabled())
			{
				log.debug(this +".init()");
			}
		}
		catch (Throwable t)
		{
			if (log.isDebugEnabled())
			{
				log.debug(this +".init(): ", t);
			}
		}
	}

	/**
	 * Final cleanup.
	 */
	public void destroy()
	{
		if (log.isDebugEnabled())
		{
			log.debug(this +".destroy()");
		}
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

	public void setUmiacSocketTimeout(int umiacSocketTimeout) {
		m_umiacSocketTimeout = umiacSocketTimeout;
	}

	public int getCacheDurationSeconds() {
		return cacheDurationSeconds;
	}

	public void setCacheDurationSeconds(int cacheDurationSeconds) {
		this.cacheDurationSeconds = cacheDurationSeconds;
	}
	
	/* NOTE: The 2.5.x deprecated methods are all unsafe! - botimer@umich.edu - 6/18/08
	 * EHcache invalidates upon get() and returns null for non-existent, expired, or null-valued keys 
	 * The MemCache implementation also invalidates upon containsKey() because it calls get()
	 * Using containsKeyExpiredOrNot() is purely misleading since it is impossible to retrieve expired objects
	 * We must cache sentinels or NullObjects for misses, since nulls, expired, and missing keys are indistinguishable
	 * The fixes have been implemented as gets followed by null-checks instead of containsKey() calls since they call
	 *    get() anyway and throw away the result.  This also makes room for an easy patch for miss checks via instanceof. 
	 */
	
	//NOTE: This is a preliminary idea for implementing the missed searches.  It is not used yet.
	//They could be checked with a conditional like this, though the type identification may be a cost penalty:
	//Object cached = getCachedValue(command);
	//if (cached instanceof MissedSearch)
	//  ...handle...
	//else if (cached != null)
	//  return (CAST) cached;
	
	/*
	protected class MissedSearch {
		private String command;
		
		public MissedSearch() {
			this.command = null;
		}
		
		public MissedSearch(String command) {
			this.command = command;
		}
	}
	*/
	
	/*
	 * Encapsulate the null-check on the cache itself and return the object
	 */
	protected Object getCachedValue(String command) {
		return (m_callCache != null) ? m_callCache.get(command) : null;		
	}

	/*
	 * (non-Javadoc)
	 * @see org.sakaiproject.util.api.umiac.UmiacClient#getEvalUserSections(java.lang.String)
	 */
	public Map<String, String> getEvalUserSections(String eid) {

		//return null;
		Map<String, String> map = new HashMap<String, String>();
		
		//Null searches should fast-fail to an empty map
		if (eid == null)
			return map;
		// Note: this Umiac command should not be used outside of the Evaluation System implementation
		String command = "getUserEvalGroups," + eid;

		Object cached = getCachedValue(command);
		//TODO: Catch sentinels or NullObjects to throw IdUnusedException
		//if (cached instanceof MissedSearch)
		//	throw new IdUnusedException(id);
		//else		
		if (cached != null)
			return (Map<String, String>) cached;

		// make the call		
		Vector<String> result = makeRawCall(command);

		// parse the results	
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
				// watch out for secondary role, 
				// set role to be Instructor if it is Instructor|Primary, otherwise, set the role to be Assistant
				if (res[1].equals("Instructor") && res[2].equals("GSI"))
				{
					role = "Assistant";
				}
				map.put(exId, role);
			}
		}

		// cache the results for a while
		if (m_callCache != null) m_callCache.put(command, map, cacheDurationSeconds);

		return map;
		
	}// getEvalUserSections
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getEvalGroupRoles(java.lang.String[])
	 */
	public Map<String, String> getEvalGroupRoles(String[] id)
		throws IdUnusedException
	{
		/* id is "realm id" +  | + "evaluation eid". This is used as the provider id field 
		 * in evaluations from MAIS and the evalGroupId of EvalGroup with type = "Provided".
		 * 
		 * i.e., getEvalGroupMemberships,year|term_id|campus|subject|catalog_nbr|class_section|eval_nbr
		 * 
		 * @see org.sakaiproject.evaluation.logic.model.EvalGroup.evalGroupId
		 */
		StringBuffer commandBuf = new StringBuffer();
		//Note: this Umiac command should not be used outside of the Evaluation System implementation
		commandBuf.append("getEvalGroupMemberships");
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

		Object cached = getCachedValue(command);
		//TODO: Catch sentinels or NullObjects to throw IdUnusedException
		//if (cached instanceof MissedSearch)
		//	throw new IdUnusedException(id);
		//else
		if (cached != null)
			return (Map<String, String>) cached;

		Vector<String> result = makeRawCall(command);

		// if there are no results, or the one has no "|", then we don't know the user
		if (	(result == null)
			||	(result.size() < 1)
			||	(((String)result.elementAt(0)).indexOf("|") == -1))
		{
			//TODO: Cache sentinels or NullObjects to store misses if they are efficiency concerns
			// cache this miss for awhile.
			//if (m_callCache != null) m_callCache.put(command, null, cacheDurationSeconds);

			throw new IdUnusedException(id[0]);
		}

		// store user id key to role value in return table
		HashMap<String, String> map = new HashMap<String, String>();

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

		// cache the results for awhile.
		if (m_callCache != null) m_callCache.put(command, map, cacheDurationSeconds);

		return map;

	} // getEvalGroupRoles
	
	/**
	 * @inherit
	 */
	public String packId(String[] ids)
	{
		if(ids == null || ids.length == 0)
		{
			return null;
		}
		
		if(ids.length == 1)
		{
			return ids[0];
		}
		
		StringBuffer sb = new StringBuffer();
		for(int i=0; i<ids.length; i++)
		{
			sb.append(ids[i]);
			if(i < ids.length - 1)
			{
				sb.append("+");
			}
		}
		return sb.toString();
	}
	
	/**
	 * Unpack a multiple id that may contain many full ids connected with "+", each
	 * of which may have multiple sections enclosed in []
	 * @param id The multiple group id.
	 * @return An array of strings of real umiac group ids, one for each in the multiple.
	 */
	public String[] unpackId(String id)
	{
		if (id == null) return null;

		Vector<String> returnVector = new Vector<String>();

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

	/**
	* Send a command to UMIAC and returns the resulting
	* output as a vector of strings (one per response line).
	* No caching is attempted.
	* @param umiacCommand The UMIAC command string.
	* @return A Vector of Strings, one per response line.
	*/
	public Vector<String> makeRawCall(String umiacCommand)
	{
		if (log.isDebugEnabled())
		{
			log.debug( this + ".makeCall: " + umiacCommand);
		}
		PrintWriter out = null;
		BufferedReader in = null;
		Socket socket = null;
		
		Vector<String> v = new Vector<String>();

		// Open up a m_socket and write out the command to UMIAC.
		try
		{
			socket = new Socket(m_host,m_port);
			socket.setSoTimeout(m_umiacSocketTimeout);
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
		catch (InterruptedIOException e)
		{
			// Catch problem if Umiac doesn't respond.  This approach will at least 
			// not leave us stuck waiting forever.
			log.warn("UMIAC: timeout on socket read: " + e.toString());
		}
		catch (Throwable e)
		{
			log.warn("UMIAC: " + e.toString());
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
			catch (Exception ignore){log.warn("UMIAC: " + ignore);}
		}
		
		if (log.isDebugEnabled())
		{
			log.debug( this + ".results: " + v);
		}
		
		return v;

	}	// makeRawCall

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
