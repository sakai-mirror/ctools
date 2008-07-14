/*******************************************************************************
 * $URL$
 * $Id$
 * **********************************************************************************
 *
 *  Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
 *
 *  Licensed under the Educational Community License, Version 1.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.opensource.org/licenses/ecl1.php
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 ******************************************************************************/

package org.sakaiproject.metaobj.shared.control;

import org.sakaiproject.metaobj.utils.mvc.intf.Controller;
import org.sakaiproject.metaobj.shared.Helper;
import org.sakaiproject.content.api.ResourceEditingHelper;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.validation.Errors;

import java.util.Map;
import java.util.Hashtable;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Feb 7, 2006
 * Time: 11:34:11 AM
 * To change this template use File | Settings | File Templates.
 */
public class FormHelperController implements Controller {

   public ModelAndView handleRequest(Object requestModel, Map request, Map session,
                                     Map application, Errors errors) {
      Map model = new Hashtable();
      
      if (request.get(Helper.HELPER_SESSION_ID) != null) {
         model.put(Helper.HELPER_SESSION_ID, request.get(Helper.HELPER_SESSION_ID));
      }
      
      if (session.get(ResourceEditingHelper.ATTACHMENT_ID) != null) {
         return new ModelAndView("edit", model);
      }
      else {
         return new ModelAndView("create", model);
      }
   }

}
