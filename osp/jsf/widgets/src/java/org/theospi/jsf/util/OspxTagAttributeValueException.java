/**********************************************************************************
* $URL$
* $Id$
***********************************************************************************
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
package org.theospi.jsf.util;

import java.io.IOException;

public class OspxTagAttributeValueException extends IOException {

	   /**
	 * Create a OspxTagAttributeValueException and list a reason why thrown.
	 *
	 * @param reason String describing the reason for the exception.
	 */
	public OspxTagAttributeValueException(String reason) {
		super(reason);
	}

	/**
	 * Create a OspxTagAttributeValueException and list no reason why thrown.
	 */
	public OspxTagAttributeValueException() {
		super();
	}
}