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
package org.theospi.portfolio.presentation.control;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.metaobj.shared.model.Id;
import org.springframework.validation.Errors;
import org.springframework.web.servlet.ModelAndView;
import org.theospi.portfolio.presentation.PresentationFunctionConstants;
import org.theospi.portfolio.presentation.model.PresentationLayout;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Apr 22, 2004
 * Time: 9:58:31 AM
 * To change this template use File | Settings | File Templates.
 */
public class DeleteLayoutController extends AbstractPresentationController {
   protected final Log logger = LogFactory.getLog(getClass());

   public ModelAndView handleRequest(Object requestModel, Map request, Map session, Map application, Errors errors) {
      if (request.get("layout_id") != null && !request.get("layout_id").equals("")) {
         Id id = getIdManager().getId((String)request.get("layout_id"));
         PresentationLayout layout = getPresentationManager().getPresentationLayout(id);
      getAuthzManager().checkPermission(PresentationFunctionConstants.DELETE_LAYOUT, layout.getId());
         getPresentationManager().deletePresentationLayout(layout.getId());
      }
      return new ModelAndView("success");
   }

}
