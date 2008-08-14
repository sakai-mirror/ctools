/**********************************************************************************
*
* Copyright (c) 2005, 2006 The Sakai Foundation.
* 
* Licensed under the Educational Community License, Version 1.0 (the "License"); 
* you may not use this file except in compliance with the License. 
* You may obtain a copy of the License at
* 
*      http://www.opensource.org/licenses/ecl1.php
* 
* Unless required by applicable law or agreed to in writing, software 
* distributed under the License is distributed on an "AS IS" BASIS, 
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
* See the License for the specific language governing permissions and 
* limitations under the License.
*
**********************************************************************************/
package org.sakaiproject.component.legacy.realm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.sakaiproject.authz.api.GroupProvider;
import org.sakaiproject.evaluation.logic.externals.EvalExternalLogic;
import org.sakaiproject.evaluation.logic.model.EvalGroup;
import org.sakaiproject.evaluation.logic.model.EvalUser;
import org.sakaiproject.evaluation.providers.EvalGroupsProvider;
import org.sakaiproject.evaluation.constant.EvalConstants;

/**
* The University of Michigan's implementation of EvalGroups provider.<br />
* The group id is composed of a realm id and evaluation eid, which is used
* to look up instructors in a special table in M-Pathways set up for use
* in Course Evaluations.
* 
* Note: This is currently relying on caching by other services, but a cache for
* courses and enrollments could be implemented if performance needs to be
* improved per UMD's EvalCourseProvider.
* 
* Note: A very helpful "test EvalGroupProvider" page is available from the
* tool's Administrate page.
* 
* @author rwellis
* 
*/
public class EvalGroupsProviderUnivOfMichImpl implements EvalGroupsProvider {

	private static final Log log = LogFactory
			.getLog(EvalGroupsProviderUnivOfMichImpl.class);
	private static final Log metric = LogFactory.getLog("metrics."
			+ EvalGroupsProviderUnivOfMichImpl.class.getName());

	// UMIAC roles
	public static final String STUDENT_ROLE_STRING = "Student";
	public static final String INSTRUCTOR_ROLE_STRING = "Instructor";

	/*
	 * STUDENT/TEACH sections are bogus, rigged up in 2005 so that they only
	 * show up in getUserSections so users can be permitted to a site but are
	 * otherwise invisible to CTools.
	 */
	private final String[] skipSection = new String[] { ",TEACH,000,000",
			",STUDENT,000,000" };

	private EvalExternalLogic externalLogic;
	public void setExternalLogic(EvalExternalLogic externalLogic) {
		this.externalLogic = externalLogic;
	}

	private GroupProvider groupProvider;
	public void setGroupProvider(GroupProvider groupProvider) {
		this.groupProvider = groupProvider;
	}
	
	
	public void init() {
		// this is where we would build the cache
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.evaluation.logic.providers.EvalGroupsProvider#countEvalGroupsForUser(java.lang.String,
	 *      java.lang.String)
	 */
	public int countEvalGroupsForUser(String userId, String permission) {
		return getEvalGroupsForUser(userId, permission).size();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.evaluation.logic.providers.EvalGroupsProvider#countUserIdsForEvalGroups(java.lang.String[],
	 *      java.lang.String)
	 */
	public int countUserIdsForEvalGroups(String[] groupIds, String permission) {
		return getUserIdsForEvalGroups(groupIds, permission).size();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.evaluation.logic.providers.EvalGroupsProvider#getEvalGroupsForUser(java.lang.String,
	 *      java.lang.String)
	 */
	public List getEvalGroupsForUser(String userId, String permission) {
		if (userId == null || "".equals((userId))) {
			if (log.isWarnEnabled())
				log
						.warn("getEvalGroupsForUser() parameter userId null or empty.");
			return null;
		}
		if (permission == null
				|| !(PERM_TAKE_EVALUATION.equals(permission) || PERM_BE_EVALUATED
						.equals(permission))) {
			if (log.isWarnEnabled())
				log
						.warn("getEvalGroupsForUser() permission was null or not Student/Instructor.");
			return null;
		}
		List<EvalGroup> evalGroups = new ArrayList<EvalGroup>();
		String role = null;
		try {
			// UMIAC role, which is Student or Instructor
			role = translatePermission(permission);
			EvalUser user = externalLogic.getEvalUserById(userId);
			String eid = externalLogic.getUserUsername(userId);
			Map map = groupProvider.getGroupRolesForUser(eid);
			if (!map.isEmpty()) {
				// get external group id -> role name map for this user in all
				// external groups. (may be empty).
				for (Iterator i = map.entrySet().iterator(); i.hasNext();) {
					Map.Entry entry = (Map.Entry) i.next();
					// STUDENT/TEACH? compare to e.g.,
					// <PROVIDER_ID>2008,2,A,AAPTIS,217,001</PROVIDER_ID>
					if (((String) entry.getKey()).endsWith(skipSection[0])
							|| ((String) entry.getKey())
									.endsWith(skipSection[1])) {
						if (log.isDebugEnabled())
							log.debug("skipping section '"
									+ (String) entry.getKey() + "'");
						continue;
					}
					// permission corresponds to role?
					if (((String) entry.getValue()).equalsIgnoreCase(role)) {
						evalGroups.add(getGroupByGroupId((String) entry
								.getKey()));
					}
				}
			}
		} catch (Exception e) {
			if (log.isWarnEnabled())
				log.warn("getEvalGroupsForUser() " + e);
		}
		if(log.isDebugEnabled())
			log.debug("getEvalGroupsForUser(" + userId + "," + permission + ") returns " + evalGroups.size() + " EvalGroups");
		return evalGroups;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.evaluation.logic.providers.EvalGroupsProvider#getGroupByGroupId(java.lang.String)
	 */
	public EvalGroup getGroupByGroupId(String groupId) {
		return new EvalGroup(groupId, getSectionTitle(groupId),
				EvalConstants.GROUP_TYPE_PROVIDED);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.evaluation.logic.providers.EvalGroupsProvider#getUserIdsForEvalGroups(java.lang.String[],
	 *      java.lang.String)
	 */
	public Set getUserIdsForEvalGroups(String[] groupIds, String permission) {

		if (groupIds == null || groupIds.length < 1) {
			if (log.isWarnEnabled())
				log.warn("EvalGroup groupIds null or empty String[].");
			return null;
		}
		if (permission == null
				|| !(PERM_TAKE_EVALUATION.equals(permission) || PERM_BE_EVALUATED
						.equals(permission))) {
			if (log.isWarnEnabled())
				log
						.warn("Permission was null or not PERM_TAKE_EVALUATION/PERM_BE_EVALUATED.");
			return null;
		}
		Set<String> userIds = new HashSet<String>();
		String groupEid = null;
		String userId = null;
		EvalUser user = null;
		String role = translatePermission(permission);
		for (int i = 0; i < groupIds.length; i++) {
			try {
				groupEid = groupIds[i];
				Map map = groupProvider.getUserRolesForGroup(groupEid);
				// outbound to Umiac evaluation group id consists of realm id + evaluation eid
				for (Iterator j = map.entrySet().iterator(); j.hasNext();) {
					Map.Entry<String, String> entry = (Map.Entry<String, String>) j
							.next();
					if (entry.getValue().equals(role)) {
						user = externalLogic.getEvalUserByEid(entry.getKey());
						userId = user.userId; 
						userIds.add(userId);
					}
				}
			} catch (Exception e) {
				if (log.isWarnEnabled())
					log.warn("Group eid '" + groupEid + "' " + e);
			}
			continue;
		}
		if(log.isDebugEnabled())
			log.debug("getUserIdsForEvalGroups(" + groupIds + "," + permission + ") returns " + userIds.size() + " userIds " + userIds);
		
		return userIds;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.evaluation.logic.providers.EvalGroupsProvider#isUserAllowedInGroup(java.lang.String,
	 *      java.lang.String, java.lang.String)
	 */
	public boolean isUserAllowedInGroup(String userId, String permission,
			String groupId) {
		// parameter checks
		if (userId == null || "".equals(userId)) {
			if (log.isWarnEnabled())
				log
						.warn("isUserAllowedInGroup() userId parameter is null or an empty String.");
			return false;
		}
		if (permission == null || "".equals(permission)) {
			if (log.isWarnEnabled())
				log
						.warn("isUserAllowedInGroup() permision parameter is null or an empty String.");
			return false;
		}
		if (groupId == null || "".equals(groupId)) {
			if (log.isWarnEnabled())
				log
						.warn("isUserAllowedInGroup() groupId parameter is null or an empty String.");
			return false;
		}
		if (groupId.endsWith(skipSection[0])
				|| groupId.endsWith(skipSection[1])) {
			if (log.isDebugEnabled())
				log.debug("skipping section '" + groupId + "'");
			return false;
		}

		// test
		boolean answer = false;
		String role = translatePermission(permission);
		if (INSTRUCTOR_ROLE_STRING.equals(role)
				|| STUDENT_ROLE_STRING.equals(role)) {
			try {
				EvalUser user = externalLogic.getEvalUserById(userId);	
				answer = role.equals(groupProvider.getRole(groupId,user.username));
				
			} catch (Exception e) {
				if (log.isWarnEnabled())
					log.warn("isUserAllowedInGroup() userId '" + userId
							+ "' permission '" + permission + "' groupId '"
							+ groupId + "' " + e);
			}
		}
		return answer;
	}
	


	/**
	 * Get the title of a section using the CourseManagementSystem.<br />
	 * The evaluation eid is removed from the group id leaving a section,
	 * e.g., 2008,2,A,AAPTIS,217,001
	 * 
	 * @param groupId
	 *            the group id e.g., 2008,2,A,AAPTIS,217,001 with evaluation eid appended e.g., 2008,2,A,AAPTIS,217,001,196
	 * @return the section title
	 */
	private String getSectionTitle(String groupId) {
		String[] fields = groupId.split(",");
		String providerId = fields[0] + "," + fields[1] + "," + fields[2] + "," + fields[3] + "," + fields[4] + "," + fields[5];
		return externalLogic.getSectionTitle(providerId);
	}

	/**
	 * Simple method to translate from Evaluation System permissions to UMIAC
	 * role Student or Instructor
	 * 
	 * @param permission
	 *            a PERM constant from {@link EvalConstants}
	 * @return the UMIAC role
	 */
	private String translatePermission(String permission) {
		if (PERM_TAKE_EVALUATION.equals(permission)) {
			return STUDENT_ROLE_STRING;
		} else if (PERM_BE_EVALUATED.equals(permission)) {
			return INSTRUCTOR_ROLE_STRING;
		}
		return "UNKNOWN";
	}
}

