/**********************************************************************************
 * $HeadURL:  $
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
package org.sakaiproject.sitemanage.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Hashtable;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.coursemanagement.api.AcademicSession;
import org.sakaiproject.coursemanagement.api.CourseManagementService;
import org.sakaiproject.coursemanagement.api.exception.IdNotFoundException;
import org.sakaiproject.sitemanage.api.SectionField;
import org.sakaiproject.sitemanage.api.SectionFieldProvider;
import org.sakaiproject.util.ResourceLoader;
import org.sakaiproject.util.api.umiac.UmiacClient;

public class SectionFieldProviderUMichImpl implements SectionFieldProvider {
	private static final Log log = LogFactory.getLog(SectionFieldProviderUMichImpl.class);

	/**
	 * Dependency: UmiacClient.
	 * @param service the UmiacClient.
	 */
	
	/** Dependency: UmiacClient */
	private UmiacClient m_umiac; 
	
	public void setUmiac(UmiacClient m_umiac) {
		this.m_umiac = m_umiac;
	}

	public UmiacClient getUmiac() {
		return m_umiac;
	}
	
	/** Dependency: CourseManagementService */
	private CourseManagementService cms;
	public void setCourseManagementService (CourseManagementService cms)
	{
		this.cms = cms;
	}
	public CourseManagementService getCourseManagementService()
	{
		return cms;
	}
	
	public List<SectionField> getRequiredFields() {
		ResourceLoader resourceLoader = new ResourceLoader("SectionFields");
		List<SectionField> fieldList = new ArrayList<SectionField>();

		fieldList.add(new SectionFieldUMichImpl(resourceLoader.getString("required_fields_subject"), null, 8));
		fieldList.add(new SectionFieldUMichImpl(resourceLoader.getString("required_fields_course"), null, 3));
		fieldList.add(new SectionFieldUMichImpl(resourceLoader.getString("required_fields_section"), null, 3));		
		
		return fieldList;
	}

	public String getSectionEid(String academicSessionEid, List<SectionField> fields) {
		if(fields == null || fields.isEmpty()) {
			if(log.isDebugEnabled()) log.debug(this + ":getSectionEid Returning an empty sectionEID for an empty (or null) list of fields");
			return "";
		}
		
		String sEid = "";
		
		// academicSessionEid is of format "FALL 2007"
		String[] asParts = academicSessionEid.split(" ");
		Hashtable termIndex = m_umiac.getTermIndexTable();
		if (termIndex != null && termIndex.containsKey(asParts[0]))
		{
			sEid = asParts[1] + "," + (String) termIndex.get(asParts[0]) + "," + "A";/*make it for only Ann Arbor campus for now*/
		}
		
		for(int i = 0; i < fields.size(); i++) {
			SectionField sf = fields.get(i);
			sEid = sEid + "," + sf.getValue();
		}
		
		if(log.isDebugEnabled()) log.debug("Generated section eid = " + sEid);
		return sEid;
	}

	public String getSectionTitle(String academicSessionEid, List<SectionField> fields) {
		if(fields == null || fields.isEmpty()) {
			if(log.isDebugEnabled()) log.debug(this + ":getSectionTitle Returning an empty sectionTitle for an empty (or null) list of fields");
			return "";
		}
		
		String title = "";
		
		for(int i = 0; i < fields.size(); i++) {
			SectionField sf = fields.get(i);
			title += sf.getValue() + " ";
		}
		
		// academicSessionEid is of format "FALL 2007"
		try
		{
			AcademicSession as = cms.getAcademicSession(academicSessionEid);
			// if found
			title += as.getDescription();
		}
		catch (IdNotFoundException e)
		{
			// cannot find academic session
			log.warn(this + "getSectionTitle Cannot find acadmic session with eid = " + academicSessionEid);
			// use academic session title 
			title += academicSessionEid;
		}
		
		return title;
	}
	
	public void init() {
		log.info("Initializing CTools:" + getClass().getName());
	}

	public void destroy() {
	}

}
