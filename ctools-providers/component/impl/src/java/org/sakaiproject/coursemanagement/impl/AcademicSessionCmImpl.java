/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2006 The Sakai Foundation.
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

import java.io.Serializable;
import java.util.Date;

import org.sakaiproject.coursemanagement.api.AcademicSession;
import org.sakaiproject.coursemanagement.impl.AbstractNamedCourseManagementObjectCmImpl;

public class AcademicSessionCmImpl extends AbstractNamedCourseManagementObjectCmImpl implements AcademicSession, Serializable {
	
	private static final long serialVersionUID = 1L;

	private Date startDate;
	private Date endDate;
	
	public AcademicSessionCmImpl() {}
	
	public AcademicSessionCmImpl(String eid, String title, String description, Date startDate, Date endDate) {
		this.eid = eid;
		this.title = title;
		this.description = description;
		this.startDate = startDate;
		this.endDate = endDate;
	}
	
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
}
