/**********************************************************************************
 * $HeadURL: https://source.sakaiproject.org/svn/ctools/trunk/ctools-providers/component/impl/src/java/org/sakaiproject/sitemanage/impl/SectionFieldImpl.java $
 * $Id: SectionFieldImpl.java 31262 2007-05-31 19:22:59Z dlhaines@umich.edu $
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

import org.sakaiproject.sitemanage.api.SectionField;

public class SectionFieldUMichImpl implements SectionField {
	protected String labelKey;
	protected String value;
	protected int maxSize;
	
	public SectionFieldUMichImpl() {}
	public SectionFieldUMichImpl(String labelKey, String value, int maxSize) {
		this.labelKey = labelKey;
		this.value = value;
		this.maxSize = maxSize;
	}
	
	public String getLabelKey() {
		return labelKey;
	}
	public void setLabelKey(String labelKey) {
		this.labelKey = labelKey;
	}
	public int getMaxSize() {
		return maxSize;
	}
	public void setMaxSize(int maxSize) {
		this.maxSize = maxSize;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	

}
