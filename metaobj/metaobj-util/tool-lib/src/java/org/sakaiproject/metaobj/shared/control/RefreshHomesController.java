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

package org.sakaiproject.metaobj.shared.control;

import java.util.Map;

import org.sakaiproject.metaobj.shared.mgt.HomeFactory;
import org.sakaiproject.metaobj.utils.mvc.intf.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.servlet.ModelAndView;

public class RefreshHomesController implements Controller {
   private HomeFactory homeFactory;

   public ModelAndView handleRequest(Object requestModel, Map request, Map session, Map application, Errors errors) {
      getHomeFactory().reload();
      request.put("message", "Reload complete");
      return new ModelAndView("success", request);
   }

   public HomeFactory getHomeFactory() {
      return homeFactory;
   }

   public void setHomeFactory(HomeFactory homeFactory) {
      this.homeFactory = homeFactory;
   }
}
