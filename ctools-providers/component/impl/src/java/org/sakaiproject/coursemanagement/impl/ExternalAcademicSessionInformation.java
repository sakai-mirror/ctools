/**********************************************************************************
 * $HeadURL$
 * $Id:  $
 ***********************************************************************************
 *
 * Copyright (c) 2007 The Sakai Foundation.
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

package org.sakaiproject.coursemanagement.impl;

import java.util.List;

import org.sakaiproject.coursemanagement.api.AcademicSession;
import org.sakaiproject.coursemanagement.api.exception.IdNotFoundException;

/* This interface will help support testing of the UMich CMS implementation.
 * It allows overriding the default process for getting academic term
 * information directly from the database.
 */

interface ExternalAcademicSessionInformation {

	/**
	 * Get session information for a single session.
	 * @param eid
	 * @return
	 * @throws IdNotFoundException
	 */
	public abstract AcademicSession getAcademicSession(final String eid)
			throws IdNotFoundException;
	/**
	 * Get session information for multiple sessions.
	 * @param impl
	 * @return
	 */
	public abstract List<AcademicSession> getAcademicSessions();

}