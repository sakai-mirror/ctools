/**********************************************************************************
 *
 * $HeadURL$
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

package org.sakaiproject.util.impl.umiac;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Iterator;
import java.util.Map;
import java.util.Vector;
import java.util.Set;
import java.util.HashSet;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.event.api.Event;
import org.sakaiproject.memory.api.Cache;
import org.sakaiproject.memory.api.CacheRefresher;
import org.sakaiproject.memory.api.MemoryService;
import org.sakaiproject.user.api.UserEdit;
import org.sakaiproject.util.api.umiac.UmiacClient;
import org.sakaiproject.util.StringUtil;
import org.sakaiproject.util.impl.umiac.UmiacConnectorImpl;

/**
 * <p>
 * UmiacClient is the Interface to the UMIAC service (classlist directory
 * services).
 * 
 * This class translates method calls into specific Umiac requests and
 * translates the return values from Umiac into Java objects. The actual Umiac
 * connection is handled by the UmiacConnectorImpl.
 * 
 * When adding new method reflecting new functional in Umiac that specific to a
 * new tool try to create an additional API with just the new methods that the
 * tool requires and then implement those methods in this class in addition to
 * the existing UmiacClient API. No point in making the UmiacClient API any
 * bigger than it already is, and no point in spreading the implementation over additional files.
 * 
 * @author University of Michigan, CHEF Software Development Team
 * @version $Revision$
 */

/*
 * TTD: (Things to do)
 * - Figure out the best way to cache.
 * - Add unit tests for the parsing methods as they require changes.
 */

public class UmiacClientImpl implements CacheRefresher, UmiacClient {

	/** A cache of calls to umiac and the results. */
	protected Cache m_callCache = null;

	/** The one and only Umiac client. */
	protected static UmiacClient m_instance = null;

	private static Log log = LogFactory.getLog(UmiacClientImpl.class);

	/* default cache duration to 1 hour */
	private int cacheDurationSeconds = 60 * 60;

	public int getCacheDurationSeconds() {
		return cacheDurationSeconds;
	}

	public void setCacheDurationSeconds(int cacheDurationSeconds) {
		this.cacheDurationSeconds = cacheDurationSeconds;
	}

	private UmiacConnectorImpl m_uci = null;

	/*
	 * This used to have a constructor that called the MemoryService cover in
	 * the constructor. Per suggestions from Ray Davis and Josh Holtsman, the
	 * initialization has been moved to an init method and plain setter
	 * injection will now work under Spring.
	 */

	private MemoryService m_memory = null;

	public MemoryService getMemoryService() {
		return m_memory;
	}

	public void setMemoryService(MemoryService ms) {
		this.m_memory = ms;
	}

	/**
	 * Final initialization, once all dependencies are set.
	 */
	public void init() {
		// build a synchronized map for the call cache, automatically checking
		// for expiration every 15 mins.
		// m_callCache = MemoryServiceLocator.getInstance().newHardCache(this,
		// 15 * 60);

		try {
			m_callCache = m_memory.newHardCache(this, 15 * 60);

			if (m_instance == null) {
				m_instance = this;
			}

			if (log.isDebugEnabled()) {
				log.debug(this + ".init()");
			}
		} catch (Throwable t) {
			log.warn("init(): ", t);
		}
	}

	/**
	 * Final cleanup.
	 */
	public void destroy() {
		if (log.isDebugEnabled()) {
			log.debug(this + ".destroy()");
		}
	}

	/*
	 * NOTE: The 2.5.x deprecated methods are all unsafe! - botimer@umich.edu -
	 * 6/18/08 EHcache invalidates upon get() and returns null for non-existent,
	 * expired, or null-valued keys The MemCache implementation also invalidates
	 * upon containsKey() because it calls get() Using containsKeyExpiredOrNot()
	 * is purely misleading since it is impossible to retrieve expired objects
	 * We must cache sentinels or NullObjects for misses, since nulls, expired,
	 * and missing keys are indistinguishable The fixes have been implemented as
	 * gets followed by null-checks instead of containsKey() calls since they
	 * call get() anyway and throw away the result. This also makes room for an
	 * easy patch for miss checks via instanceof.
	 */

	// NOTE: This is a preliminary idea for implementing the missed searches. It
	// is not used yet.
	// They could be checked with a conditional like this, though the type
	// identification may be a cost penalty:
	// Object cached = getCachedValue(command);
	// if (cached instanceof MissedSearch)
	// ...handle...
	// else if (cached != null)
	// return (CAST) cached;
	/*
	 * protected class MissedSearch { private String command;
	 * 
	 * public MissedSearch() { this.command = null; }
	 * 
	 * public MissedSearch(String command) { this.command = command; } }
	 */

	public void setUmiacConnector(UmiacConnectorImpl uci) {
		this.m_uci = uci;
	}

	public UmiacConnectorImpl getUmiacConnector() {
		return m_uci;
	}

	/*
	 * Encapsulate the null-check on the cache itself and return the object
	 */
	protected Object getCachedValue(String command) {
		return (m_callCache != null) ? m_callCache.get(command) : null;
	}

	/**
	 * @inherit
	 */
	public String packId(String[] ids) {
		if (ids == null || ids.length == 0) {
			return null;
		}

		if (ids.length == 1) {
			return ids[0];
		}

		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < ids.length; i++) {
			sb.append(ids[i]);
			if (i < ids.length - 1) {
				sb.append("+");
			}
		}
		return sb.toString();
	}

	/**
	 * Unpack a multiple id that may contain many full ids connected with "+",
	 * each of which may have multiple sections enclosed in []
	 * 
	 * @param id
	 *            The multiple group id.
	 * @return An array of strings of real umiac group ids, one for each in the
	 *         multiple.
	 */
	public String[] unpackId(String id) {
		if (id == null)
			return null;

		Vector<String> returnVector = new Vector<String>();

		// first unpack the full ids
		String[] first = unpackIdFull(id);

		// then, for each, unpack the sections
		for (int i = 0; i < first.length; i++) {
			String[] second = unpackIdSections(first[i]);
			for (int s = 0; s < second.length; s++) {
				returnVector.add(second[s]);
			}
		}

		String[] rv = (String[]) returnVector.toArray(new String[returnVector
				.size()]);

		return rv;
	}

	/**
	 * Unpack a crosslisted multiple groupId into a set of individual group ids.
	 * 2002,2,A,EDUC,504,[001,002,003,004,006]+2002,2,A,LSA,101,[002,003]+etc
	 * 
	 * @param id
	 *            The crosslisted multiple group id.
	 * @return An array of strings of real umiac group ids, one for each in the
	 *         multiple.
	 */
	protected String[] unpackIdFull(String id) {
		String[] rv = null;

		// if there is not a '+' return just the id
		int pos = id.indexOf('+');
		if (pos == -1) {
			rv = new String[1];
			rv[0] = id;
		} else {
			// split by the "+" separators
			rv = StringUtil.split(id, "+");
		}

		return rv;
	}

	/**
	 * Unpack a multiple section groupId into a set of individual group ids.
	 * 2002,2,A,EDUC,504,[001,002,003,004,006]
	 * 
	 * @param id
	 *            The multiple section group id.
	 * @return An array of strings of real umiac group ids, one for each section
	 *         in the multiple.
	 */
	protected String[] unpackIdSections(String id) {
		String[] rv = null;

		// if there is not a '[' and a ']', or they are inverted or enclose an
		// empty string,
		// return just the id
		int leftPos = id.indexOf('[');
		int rightPos = id.indexOf(']');
		if (!((leftPos != -1) && (rightPos != -1)) || (rightPos - leftPos <= 1)) {
			rv = new String[1];
			rv[0] = id;
		} else {
			// isolate the root
			String root = id.substring(0, leftPos);

			// isolate the sections
			String sectionString = id.substring(leftPos + 1, rightPos);

			// separate these
			String sections[] = StringUtil.split(sectionString, ",");

			// handle misformed strings
			if ((sections == null) || (sections.length == 0)) {
				rv = new String[1];
				rv[0] = id;
			}

			else {
				// build a return for each section
				rv = new String[sections.length];
				for (int i = 0; i < sections.length; i++) {
					rv[i] = root + sections[i];
				}
			}
		}

		return rv;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#userExists(java.lang.String)
	 */
	public boolean userExists(String eid) {
		return (getUserName(eid) != null);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#getUserName(java.lang.String)
	 */
	public String[] getUserName(String eid) {
		// Null indicates a missed search for this method
		if (eid == null)
			return null;

		String command = "getSortName," + eid;

		Object cached = getCachedValue(command);
		if (cached != null)
			return (String[]) cached;

		Vector<String> result = m_uci.makeRawCall(command);

		// if there are no results, then we don't know the user
		// If the entries are all null that is the same as a null result.
		Boolean foundContent = false;
		for (Object r : result) {
			// System.out.println(name.charAt(0));
			if (r != null) {
				foundContent = true;
			}
		}

		if (!foundContent) {
			result = null;
		}

		if ((result == null) || (result.size() != 1)
				|| (((String) result.elementAt(0)).trim().length() == 0)
				|| (((String) result.elementAt(0)).trim().equals(","))) {
			// cache the miss for 60 minutes
			// if (m_callCache != null) m_callCache.put(command, null, 60 * 60);
			// TODO: Cache sentinels or NullObjects to store misses if they are
			// efficiency concerns
			// if (m_callCache != null) m_callCache.put(command, null,
			// cacheDurationSeconds);

			return null;
		}

		String[] rv = parseGetUserNameFromUmiacResult(result);

		// cache the results for cache duration seconds.
		if (m_callCache != null)
			m_callCache.put(command, rv, cacheDurationSeconds);

		return rv;

	} // getUserName

	/**
	 * @param result
	 * @return
	 */
	protected String[] parseGetUserNameFromUmiacResult(Vector<String> result) {
		String[] rv = new String[4];

		// get the result string for the sort name [0]
		// Fred, Farley Fish
		rv[0] = ((String) result.elementAt(0)).trim();

		// parse the result string for the display name [1]
		// Farley Fish Fred
		String[] res = StringUtil.split(rv[0], ",");
		String displayName = "";
		if (res.length > 1) {
			displayName = res[1] + " ";
		}
		rv[1] = displayName.concat(res[0]);

		// set the last name [2]
		rv[2] = res[0];

		// set the first name [3]
		if (res.length > 1) {
			rv[3] = res[1];
		} else {
			rv[3] = "";
		}
		return rv;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#getGroupName(java.lang.String)
	 */
	public String getGroupName(String id) throws IdUnusedException {
		String command = "getClassInfo," + id;

		Object cached = getCachedValue(command);
		if (cached != null)
			return (String) cached;

		Vector<String> result = m_uci.makeRawCall(command);

		// if there are no results, or the one has no "|", then we don't know
		// the user
		if ((result == null) || (result.size() < 1)
				|| (((String) result.elementAt(0)).indexOf("|") == -1)) {
			// TODO: Cache sentinels or NullObjects to store misses if they are
			// efficiency concerns
			// cache the miss for a while.
			// if (m_callCache != null) m_callCache.put(command, null,
			// cacheDurationSeconds);

			throw new IdUnusedException(id);
		}

		String name = parseGetGroupNameFromUmiacResult(id);

		// cache the result for a while.
		if (m_callCache != null)
			m_callCache.put(command, name, cacheDurationSeconds);

		return name;

	} // getGroupName

	/**
	 * @param id
	 * @return
	 */
	protected String parseGetGroupNameFromUmiacResult(String id) {
		// parse the result string for the name
		// 0: 1410|32220|Teach with
		// Tech|https://chefproject.org/chef/portal/group/ED504|SEM|2002-09-03|2002-12-11|405000|School
		// Of Education|EDU|Education
		// String[] res = StringUtil.split((String)result.elementAt(0),"|");
		// String name = res[2];

		// CT-512 - move the UMICH course name generation from SiteAction to
		// Umiac

		// The result is generated from the id

		String[] fields;
		fields = id.split(",");
		StringBuffer tab = new StringBuffer();
		tab.append(fields[3]);
		tab.append(" ");
		tab.append(fields[4]);
		tab.append(" ");
		tab.append(fields[5]);

		String name = tab.toString();
		return name;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#getGroupRoles(java.lang.String)
	 */
	public Map<String, String> getGroupRoles(String id)
			throws IdUnusedException {
		String command = "getClasslist," + id;

		Object cached = getCachedValue(command);
		// TODO: Catch sentinels or NullObjects to throw IdUnusedException
		// if (cached instanceof MissedSearch)
		// throw new IdUnusedException(id);
		// else
		if (cached != null)
			return (Map<String, String>) cached;

		Vector<String> result = m_uci.makeRawCall(command);

		// if there are no results, or the one has no "|", then we don't know
		// the user
		if ((result == null) || (result.size() < 1)
				|| (((String) result.elementAt(0)).indexOf("|") == -1)) {
			// TODO: Cache sentinels or NullObjects to store misses if they are
			// efficiency concerns
			// cache the miss for awhile.
			// if (m_callCache != null) m_callCache.put(command, null,
			// cacheDurationSeconds);

			throw new IdUnusedException(id);
		}

		HashMap<String, String> map = parseGetGroupRolesFromUmiacResult(result);

		// cache the result for a while.
		if (m_callCache != null)
			m_callCache.put(command, map, cacheDurationSeconds);

		return map;

	} // getGroupRoles

	/**
	 * @param result
	 * @return
	 */
	protected HashMap<String, String> parseGetGroupRolesFromUmiacResult(
			Vector<String> result) {
		// store user id key to role value in return table
		HashMap<String, String> map = new HashMap<String, String>();

		// parse each line of the result
		// 1: Burger,Ham F|HBURGER|11234541|-||Instructor|E
		for (int i = 0; i < result.size(); i++) {
			String[] res = StringUtil.split((String) result.elementAt(i), "|");
			String uid = res[1].toLowerCase();
			String role = res[5];
			map.put(uid, role);
		}
		return map;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#getUserSections(java.lang.String)
	 */
	public Map<String, String> getUserSections(String eid) {
		Map<String, String> map = new HashMap<String, String>();

		// Null searches should fast-fail to an empty map
		if (eid == null)
			return map;

		String command = "getUserSections," + eid;

		Object cached = getCachedValue(command);
		// TODO: Catch sentinels or NullObjects to throw IdUnusedException
		// if (cached instanceof MissedSearch)
		// throw new IdUnusedException(id);
		// else
		if (cached != null)
			return (Map<String, String>) cached;

		// make the call
		Vector<String> result = m_uci.makeRawCall(command);

		// parse the results
		// if there are no results, or the one has no "|", then we have no class
		// roles for the user
		if (!((result == null) || (result.size() < 1) || (((String) result
				.elementAt(0)).indexOf("|") == -1))) {
			parseGetUserSectionFromUmiacResult(map, result);
		}

		// cache the results for a while
		if (m_callCache != null)
			m_callCache.put(command, map, cacheDurationSeconds);

		return map;

	} // getUserSections

	/**
	 * @param map
	 * @param result
	 */
	protected void parseGetUserSectionFromUmiacResult(Map<String, String> map,
			Vector<String> result) {
		// parse each line of the result
		// ex: 2004,2,A,SI,653,001|Instructor|Primary
		for (int i = 0; i < result.size(); i++) {
			String[] res = StringUtil.split((String) result.elementAt(i), "|");
			String exId = res[0];
			String role = res[1];
			// watch out for secondary role,
			// set role to be Instructor if it is Instructor|Primary, otherwise,
			// set the role to be Assistant
			if (res[1].equals("Instructor") && res[2].equals("GSI")) {
				role = "Assistant";
			}
			map.put(exId, role);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#setUserNames(org.sakaiproject.service.legacy.user.UserEdit)
	 */
	public void setUserNames(UserEdit edit) throws IdUnusedException {
		String[] name = getUserName(edit.getEid());
		if (name == null) {
			throw new IdUnusedException(edit.getEid());
		}

		edit.setLastName(name[2]);
		edit.setFirstName(name[3]);

	} // setUserNames

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#getGroupRoles(java.lang.String[])
	 */
	public Map<String, String> getGroupRoles(String[] id)
			throws IdUnusedException {
		String command = generateGetGroupRolesCommand(id);

		Object cached = getCachedValue(command);
		// TODO: Catch sentinels or NullObjects to throw IdUnusedException
		// if (cached instanceof MissedSearch)
		// throw new IdUnusedException(id);
		// else
		if (cached != null)
			return (Map<String, String>) cached;

		Vector<String> result = m_uci.makeRawCall(command);

		// if there are no results, or the one has no "|", then we don't know
		// the user
		if ((result == null) || (result.size() < 1)
				|| (((String) result.elementAt(0)).indexOf("|") == -1)) {
			// TODO: Cache sentinels or NullObjects to store misses if they are
			// efficiency concerns
			// cache this miss for awhile.
			// if (m_callCache != null) m_callCache.put(command, null,
			// cacheDurationSeconds);

			throw new IdUnusedException(id[0]);
		}

		HashMap<String, String> map = parseGetGroupRolesArrayFromUmiacResult(result);

		// cache the results for awhile.
		if (m_callCache != null)
			m_callCache.put(command, map, cacheDurationSeconds);

		return map;

	} // getGroupRoles

	/**
	 * @param result
	 * @return
	 */
	protected HashMap<String, String> parseGetGroupRolesArrayFromUmiacResult(
			Vector<String> result) {
		// store user id key to role value in return table
		HashMap<String, String> map = new HashMap<String, String>();

		// parse each line of the result
		// 2002,2,A,EDUC,547,003|Arrdvark Axis Betterman|Betterman,Arrdvark
		// Axis|BOBOBOBOB|12345678|3|Student|E
		for (int i = 0; i < result.size(); i++) {
			String[] res = StringUtil.split((String) result.elementAt(i), "|");

			String uid = res[3].toLowerCase();
			String role = res[6];

			// the user res[3] has id res[3], display name res[1], sort name
			// res[2]
			// TODO: do we really need to store the user names? -ggolden
			// m_userNames.put(uid, res[1]);
			// m_userSortNames.put(uid, res[2]);

			// if there's a role for this user already, and it's instructor,
			// just leave it
			String roleAlready = (String) map.get(uid);
			if ((roleAlready == null)
					|| (roleAlready.equals("Student") && role
							.equals("Instructor"))) {
				map.put(uid, role);
			}
		}
		return map;
	}

	/**
	 * @param id
	 * @return
	 */
	protected String generateGetGroupRolesCommand(String[] id) {
		StringBuffer commandBuf = new StringBuffer();
		commandBuf.append("getGroupMemberships");
		for (int i = 0; i < id.length; i++) {
			commandBuf.append(",");

			// convert the comma separated id string to a "|" separated one
			String[] parts = StringUtil.split(id[i], ",");
			commandBuf.append(parts[0]);
			for (int p = 1; p < parts.length; p++) {
				commandBuf.append("|");
				commandBuf.append(parts[p]);
			}
		}
		String command = commandBuf.toString();
		return command;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#getClassList(java.lang.String,
	 *      java.lang.String, java.lang.String, java.lang.String,
	 *      java.lang.String, java.lang.String)
	 */
	public Vector<String[]> getClassList(String year, String term,
			String campus, String subject, String course, String section) {
		String command = "getClasslist," + year + "," + term + "," + campus
				+ "," + subject + "," + course + "," + section + "\n\n";

		Object cached = getCachedValue(command);
		if (cached != null)
			return (Vector<String[]>) cached;

		Vector<String> result = m_uci.makeRawCall(command);

		// if there are no results
		if ((result == null) || (result.size() < 1)) {
			// Log.warn("chef", "Cannot get the class record for " + year + ","
			// + term + "," + campus + "," + subject + "," + course + "," +
			// section);

			// TODO: NOTE: no cache miss, cause this might be a transitory
			// error? -ggolden
			return null;
		}

		Vector<String[]> rv = splitUmiacResultString(result);

		// cache the results for awhile
		if (m_callCache != null)
			m_callCache.put(command, rv, cacheDurationSeconds);

		return rv;

	} // getClassList

	/**
	 * @param result
	 * @return
	 */
	protected Vector<String[]> splitUmiacResultString(Vector<String> result) {
		Vector<String[]> rv = new Vector<String[]>();
		for (int i = 0; i < result.size(); i++) {
			String[] res = StringUtil.split((String) result.elementAt(i), "|");
			rv.add(res);
		}
		return rv;
	}

	/**
	 * @inheritDoc
	 */
	public String getClassCategory(String year, String term, String campus,
			String subject, String course, String section) {
		String command = "getClassInfo," + year + "," + term + "," + campus
				+ "," + subject + "," + course + "," + section + "\n\n";

		Vector<String> results;

		Object cached = getCachedValue(command);
		if (cached != null) {
			results = (Vector<String>) cached;
		} else {
			results = m_uci.makeRawCall(command);
		}

		// if there are no results
		if ((results == null) || (results.size() < 1)) {
			return null;
		} else {
			String rv = parseGetClassCategoryFromUmiacResult(results);
			return rv;
		}
	}

	/**
	 * @param results
	 * @return
	 */
	protected String parseGetClassCategoryFromUmiacResult(Vector<String> results) {
		String[] classInfos = StringUtil.split((String) results.get(0), "|");
		// look up the category definition
		Hashtable<String, String> categoryTable = getClassCategoryTable();
		String rv = (classInfos.length >= 5 && categoryTable.get(classInfos[4]) != null) ? (String) categoryTable
				.get(classInfos[4])
				: null;
		return rv;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#getUserInformation(java.lang.String)
	 */
	public Vector<String[]> getUserInformation(String eids) throws Exception {
		if (eids == null)
			throw new Exception(
					"UMIAC: getUserInformation called with null list of EIDs");

		String command = "getUserInfo," + eids + "\n\n";

		Object cached = getCachedValue(command);
		if (cached != null)
			return (Vector<String[]>) cached;

		Vector<String> result = m_uci.makeRawCall(command);

		// if there are no results
		if ((result == null) || (result.size() < 1)) {
			// TODO: NOTE: no cache miss, cause this might be a transitory
			// error? -ggolden
			throw new Exception("UMIAC: no results: " + command);
		}

		Vector<String[]> rv = splitUmiacResultString(result);

		// cache the results for awhile.
		if (m_callCache != null)
			m_callCache.put(command, rv, cacheDurationSeconds);

		return rv;

	} // getUserInformation

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#getInstructorSections(java.lang.String,
	 *      java.lang.String, java.lang.String)
	 */
	public Vector<String[]> getInstructorSections(String eid, String term_year,
			String term) throws IdUnusedException {
		if (eid == null)
			throw new IdUnusedException("<null>");

		String command = "getInstructorSections," + eid + "," + term_year + ","
				+ term + "\n\n";

		// TODO: Figure out if this should be cached

		/*
		 * if ((m_callCache != null) &&
		 * (m_callCache.containsKeyExpiredOrNot(command))) { Vector rv =
		 * (Vector) m_callCache.getExpiredOrNot(command); if (rv == null) {
		 * throw new IdUnusedException(eid); }
		 * 
		 * return (Vector) m_callCache.getExpiredOrNot(command); }
		 */

		Vector<String> result = m_uci.makeRawCall(command);

		// if there are no results
		if ((result == null) || (result.size() < 1)) {
			// TODO: Cache sentinels or NullObjects to store misses if they are
			// efficiency concerns
			// cache the miss for awhile.
			// if (m_callCache != null) m_callCache.put(command, null,
			// cacheDurationSeconds);

			throw new IdUnusedException(eid);
		}

		Vector<String[]> rv = splitUmiacResultString(result);

		// cache the results for awhile.
		if (m_callCache != null)
			m_callCache.put(command, rv, cacheDurationSeconds);

		return rv;

	} // getInstructorSections

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.util.IUmiacClient#getInstructorClasses(java.lang.String,
	 *      java.lang.String, java.lang.String)
	 */
	public Vector<String[]> getInstructorClasses(String eid, String term_year,
			String term) throws IdUnusedException {
		if (eid == null)
			throw new IdUnusedException("<null>");

		String command = "getInstructorClasses," + eid + "," + term_year + ","
				+ term + "\n\n";

		Object cached = getCachedValue(command);
		// TODO: Catch sentinels or NullObjects to throw IdUnusedException
		// if (cached instanceof MissedSearch)
		// throw new IdUnusedException(eid);
		// else
		if (cached != null)
			return (Vector<String[]>) cached;

		Vector<String> result = m_uci.makeRawCall(command);

		// if there are no results
		if ((result == null) || (result.size() < 1)) {
			// TODO: Cache sentinels or NullObjects to store misses if they are
			// efficiency concerns
			// cache the miss for awhile.
			// if (m_callCache != null) m_callCache.put(command, null,
			// cacheDurationSeconds);

			throw new IdUnusedException(eid);
		}

		Vector<String[]> rv = splitUmiacResultString(result);

		// cache the results for awhile.
		if (m_callCache != null)
			m_callCache.put(command, rv, cacheDurationSeconds);

		return rv;

	} // getInstructorClasses

	/**
	 * Set group url to specified section record
	 */
	public void setGroupUrl(String year, String term, String campus,
			String subject, String course, String section, String url) {
		String command = "setGroupUrl," + year + "," + term + "," + campus
				+ "," + subject + "," + course + "," + section + "," + url
				+ "\n\n";

		m_uci.makeRawCall(command);

	} // setGroupUrl

	/**
	 * Get sections based on given url
	 */
	public Vector<String> getUrlSections(String url) {
		String command = "getUrlSections," + url + "\n\n";

		Vector<String> result = m_uci.makeRawCall(command);

		// if there are no results
		if ((result == null) || (result.size() < 1)) {
			return null;
		}

		Vector<String> rv = parseGetUrlSectionsFromUmiac(result);

		return rv;

	} // getUrlSections

	/**
	 * @param result
	 * @return
	 */
	protected Vector<String> parseGetUrlSectionsFromUmiac(Vector<String> result) {
		Vector<String> rv = new Vector<String>();
		for (int i = 0; i < result.size(); i++) {
			String[] res = StringUtil.split((String) result.elementAt(i), "|");
			String resString = "";
			for (int j = 0; j < res.length; j++) {
				// combine section info separated with ","
				resString = resString.concat(res[j]).concat(",");
			}
			// remove the last ","
			resString = resString.substring(0, resString.length() - 1);
			rv.add(resString);
		}
		return rv;
	}

	/**
	 * Get set of course offering eids which are cross-listed with the provided
	 * course offering If there is no cross-listings, empty list will be
	 * returned
	 * 
	 * @param year
	 * @param term
	 * @param campus
	 * @param subject
	 * @param course
	 * @return
	 */
	public Set<String> getCrossListingsByCourseOffering(String year,
			String term, String campus, String subject, String course) {
		String command = "getCourses,term_year=" + year + ",term_id=" + term
				+ ",source=" + campus + ",subject=" + subject + ",catalog_nbr="
				+ course + "\n\n";
		Set<String> rv = new HashSet<String>();
		List<String> rv1 = new Vector<String>();

		Object cached = getCachedValue(command);
		if (cached != null) {
			rv1 = (Vector<String>) cached;
		} else {
			rv1 = m_uci.makeRawCall(command);
		}

		// if there are no results
		if ((rv1 == null) || (rv1.size() < 1)) {
			return new HashSet<String>();
		} else {
			parseGetCrossListingsByCourseOfferings(year, term, campus, subject,
					course, rv, rv1);

		}
		return rv;
	}

	/**
	 * @param year
	 * @param term
	 * @param campus
	 * @param subject
	 * @param course
	 * @param rv
	 * @param rv1
	 */
	protected void parseGetCrossListingsByCourseOfferings(String year,
			String term, String campus, String subject, String course,
			Set<String> rv, List<String> rv1) {
		for (Iterator<String> i = rv1.iterator(); i.hasNext();) {
			// AMCULT|398|001|11168|Hon Writ
			// Wkshp|SEM|https://ctools.umich.edu/portal/site/04002365-5e48-4516-007f-b6ada00d5488|CL
			String[] classInfos = StringUtil.split((String) i.next(), "|");
			if (classInfos.length == 8 && classInfos[7].equalsIgnoreCase("CL")) {
				List<String> crossListingSections = getCrossListings(year,
						term, campus, subject, course, classInfos[2]);
				String originalId = year + "," + term + "," + campus + ","
						+ subject + "," + course + "," + classInfos[2];
				for (Iterator<String> j = crossListingSections.iterator(); j
						.hasNext();) {
					// 2008|3|A|AMCULT|398|001|MT
					// 2008|3|A|WOMENSTD|389|001|MT
					String sectionId = ((String) j.next()).replace('|', ',');
					// get the eid for course offering object
					sectionId = sectionId.substring(0, sectionId
							.lastIndexOf(","));
					if (!sectionId.equals(originalId)) {
						// filter out the original id from the returned list
						sectionId = sectionId.substring(0, sectionId
								.lastIndexOf(","));
						rv.add(sectionId);
					}
				}
			}
		}
	}

	/**
	 * set up the class category look up table
	 */
	protected Hashtable<String, String> getClassCategoryTable() {
		Hashtable<String, String> rv = new Hashtable<String, String>();
		rv.put("ACL", "Ambulatory Clinical");
		rv.put("CAS", "Case Studies/Presentations");
		rv.put("CLL", "Clinical Lab");
		rv.put("CLN", "Clinical");
		rv.put("CNF", "Conference");
		rv.put("DIS", "Discussion");
		rv.put("ERC", "Emergency Room Clinical");
		rv.put("FLD", "Field Studies");
		rv.put("FLD", "Field Experience");
		rv.put("HP", "History and Physical");
		rv.put("IND", "Independent Study");
		rv.put("LAB", "Laboratory");
		rv.put("LEC", "Lecture");
		rv.put("MDC", "Multi Disciplinary Conf");
		rv.put("PSI", "Personalized System of Instr");
		rv.put("PTP", "Patient Presentations");
		rv.put("REC", "Recitation");
		rv.put("RES", "Research");
		rv.put("SEM", "Seminar");
		rv.put("SMA", "Small Group");
		rv.put("SPI", "Simulated Patient Interviews");
		return rv;
	}

	/**
	 * @inheritDoc
	 */
	public Hashtable<String, String> getTermIndexTable() {
		// term names are stored as digits in UMIAC
		Hashtable<String, String> termIndex = new Hashtable<String, String>();
		termIndex.put("SUMMER", "1");
		termIndex.put("FALL", "2");
		termIndex.put("WINTER", "3");
		termIndex.put("SPRING", "4");
		termIndex.put("SPRING_SUMMER", "5");
		return termIndex;
	}

	/**
	 * Get list of course data which are cross-listed with the provided course
	 * Each of format: term_year|term|campus|subject|catalog_nbr|class_section
	 * If there is no cross-listings, empty list will be returned
	 * 
	 * @param year
	 * @param term
	 * @param campus
	 * @param subject
	 * @param course
	 * @param section
	 * @return
	 */
	protected List<String> getCrossListings(String year, String term,
			String campus, String subject, String course, String section) {
		String command = "getCrossListings," + year + "," + term + "," + campus
				+ "," + subject + "," + course + "," + section + "\n\n";

		Vector<String> result = null;
		Object cached = getCachedValue(command);
		if (cached != null) {
			result = (Vector<String>) cached;
		} else {
			result = m_uci.makeRawCall(command);
		}

		Vector<String> rv = parseGetCrossListingsFromUmiac(result);

		// cache the results for awhile.
		if (m_callCache != null)
			m_callCache.put(command, rv, cacheDurationSeconds);

		return rv;
	}

	/**
	 * @param result
	 * @return
	 */
	protected Vector<String> parseGetCrossListingsFromUmiac(
			Vector<String> result) {
		Vector<String> rv = new Vector<String>();
		if (result != null && result.size() > 0) {
			for (int i = 0; i < result.size(); i++) {
				rv.add((String) result.elementAt(i));
			}
		}
		return rv;
	}

	/**
	 * Get a new value for this key whose value has already expired in the
	 * cache.
	 * 
	 * @param key
	 *            The key whose value has expired and needs to be refreshed.
	 * @param oldValue
	 *            The old expired value of the key.
	 * @param event
	 *            The event which triggered this refresh.
	 * @return a new value for use in the cache for this key; if null, the entry
	 *         will be removed.
	 */
	public Object refresh(Object key, Object oldValue, Event event) {
		// instead of refreshing when an entry expires, let it go and we'll get
		// it again if needed -ggolden
		// return makeRawCall((String)key);

		return null;

	} // refresh

	/* (non-Javadoc)
	 * @see org.sakaiproject.util.api.umiac.UmiacClient#getClassTextbookInfo(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	public String getClassTextbookInfo(String year, String term_code,
			String campus_code, String subject, String course_nbr,
			String section_nbr) 
	{
		String query = "getClassTextbookInfo," + year + "," + term_code + "," + campus_code + "," + subject + "," + course_nbr + "," + section_nbr + "\n\n";
	
		List<String> rawResults = null;
		Object cached = getCachedValue(query);
		if (cached != null) 
		{
			rawResults = (List<String>) cached;
		} 
		else 
		{
			rawResults = m_uci.makeRawCall(query);
		}
		
		List<String> results = extractJsonStringsFromList(rawResults);
		
		String result = null;
		if(results.size() > 0)
		{
			result = results.get(0);
			if(results.size() > 1)
			{
				log.info("getClassTextbookInfo() returning: " + result); 
				for(int i = 1; i < results.size(); i++)
				{
					log.info("getClassTextbookInfo() discarding: " + results.get(i));
				}
			}
		}
		
		return result;
	}

	/* (non-Javadoc)
	 * @see org.sakaiproject.util.api.umiac.UmiacClient#getUserTextbookInfo(java.lang.String, java.lang.String, java.lang.String)
	 */
	public List<String> getUserTextbookInfo(String user_id, String year,
			String term_code) throws IdUnusedException 
	{
		String query = "getUserTextbookInfo," + user_id + "," + year + "," + term_code + "\n\n";
		
		List<String> rawResults = null;
		Object cached = getCachedValue(query);
		if (cached != null) 
		{
			rawResults = (List<String>) cached;
		} 
		else 
		{
			rawResults = m_uci.makeRawCall(query);
		}
		
		List<String> results = extractJsonStringsFromList(rawResults);
		
		return results;
		
	}

	protected List<String> extractJsonStringsFromList(List<String> rawResults) 
	{
		List<String> results = new ArrayList<String>();
		for(String rawResult : rawResults)
		{
			if(rawResult != null && ! rawResult.trim().equals("") && ! rawResult.trim().toUpperCase().equals("EOT"))
			{
				try
				{
					JSONObject jsonObject = JSONObject.fromObject(rawResult);
					results.add(jsonObject.toString());
				}
				catch(Exception e)
				{
					// ignore -- this indicates invalid JSON
				}
			}
		}
		return results;
	}

} // class UmiacClient

/** ******************************************************************************* */
