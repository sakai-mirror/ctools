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

/**
 * This control is useful for loading data into a backing object from a backing store.
 * This is typically necessary in a controller that is editing backend data.
 * To use simply implement fillBackingObject to oad data into the incomingModel.
 * By the time fillBackingObject is called the system
 * has already created the backing object and bound the request params into it.
 * This means any id's or other information you need to lookup the data will be available in
 * the incomingModel.
 *
 * @author John Ellis (john.ellis@rsmart.com)
 * @author John Bush (john.bush@rsmart.com)
 */
public interface LoadObjectController extends Controller {

   public Object fillBackingObject(Object incomingModel, Map request,
                                   Map session, Map application) throws Exception;

}
