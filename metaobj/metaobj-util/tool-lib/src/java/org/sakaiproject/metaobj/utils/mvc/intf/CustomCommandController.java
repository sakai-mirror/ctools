/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
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

package org.sakaiproject.metaobj.utils.mvc.intf;

import java.util.Map;

/*
 * $URL$
 * $Revision$
 * $Date$
 */

/**
 * Use this controller when you need to override the way the backing object is created.
 * If all you are doing is return new MyBackingObject() you won't need to implement this,
 * Spring will handle that for you.  Do not use this method to populate helping data
 * into the model.  This method does not get called if there is an error in validation.
 * If you rely on this information for putting stuff in the request, you will not have
 * it there in the case of validation error.  If you need to put helping data in the model,
 * implement FormController's referenceData method.
 *
 * @author John Ellis (john.ellis@rsmart.com)
 * @author John Bush (john.bush@rsmart.com)
 * @see Controller
 */
public interface CustomCommandController extends Controller {
   public Object formBackingObject(Map request,
                                   Map session,
                                   Map application);
}
