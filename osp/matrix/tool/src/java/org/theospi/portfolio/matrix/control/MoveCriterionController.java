
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
package org.theospi.portfolio.matrix.control;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.metaobj.utils.mvc.intf.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.servlet.ModelAndView;
import org.theospi.portfolio.matrix.model.Criterion;
import org.theospi.portfolio.matrix.model.Scaffolding;
/**
 * @author chmaurer
 */
public class MoveCriterionController implements Controller {

   protected final Log logger = LogFactory.getLog(getClass());
   
   /* (non-Javadoc)
    * @see org.theospi.utils.mvc.intf.Controller#handleRequest(java.lang.Object, java.util.Map, java.util.Map, java.util.Map, org.springframework.validation.Errors)
    */
   public ModelAndView handleRequest(Object requestModel, Map request, Map session, Map application, Errors errors) {
      EditedScaffoldingStorage sessionBean = (EditedScaffoldingStorage)session.get(
            EditedScaffoldingStorage.EDITED_SCAFFOLDING_STORAGE_SESSION_KEY);
      Scaffolding scaffolding = sessionBean.getScaffolding();
      Map model = new HashMap();
      
      String currentIndex = (String)request.get("current_index");
      String destIndex = (String)request.get("dest_index");
      if (currentIndex != null && destIndex != null) {
         int current = Integer.parseInt(currentIndex);
         int dest = Integer.parseInt(destIndex);
         int max = scaffolding.getCriteria().size()-1;
         if (dest == -1) dest = max;
         if (dest == max+1) dest = 0;
         //remove then insert
         Criterion obj = (Criterion)scaffolding.getCriteria().remove(current);
         scaffolding.getCriteria().add(dest, obj);
      }
      
      sessionBean.setScaffolding(scaffolding);
      session.put(EditedScaffoldingStorage.EDITED_SCAFFOLDING_STORAGE_SESSION_KEY,
            sessionBean);
      
      model.put(EditedScaffoldingStorage.STORED_SCAFFOLDING_FLAG, "true");
      return new ModelAndView("success", model);
   }
}
