/**********************************************************************************
* $URL:https://source.sakaiproject.org/svn/osp/trunk/presentation/tool/src/java/org/theospi/portfolio/presentation/control/DeleteTemplateController.java $
* $Id:DeleteTemplateController.java 9134 2006-05-08 20:28:42Z chmaurer@iupui.edu $
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

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.validation.Errors;
import org.springframework.web.servlet.ModelAndView;
import org.theospi.portfolio.presentation.PresentationFunctionConstants;
import org.theospi.portfolio.presentation.model.PresentationTemplate;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Apr 22, 2004
 * Time: 9:58:31 AM
 * To change this template use File | Settings | File Templates.
 */
public class DeleteTemplateController extends AbstractPresentationController {
   protected final Log logger = LogFactory.getLog(getClass());

   public ModelAndView handleRequest(Object requestModel, Map request, Map session, Map application, Errors errors) {
      PresentationTemplate template = (PresentationTemplate) requestModel;
      getAuthzManager().checkPermission(PresentationFunctionConstants.DELETE_TEMPLATE, template.getId());
      
      Map model = new HashMap();
      if (!getPresentationManager().deletePresentationTemplate(template.getId())) {
         model.put("presentationTemplateError", "cant_delete_template");
      }
      return new ModelAndView("success", model);
   }

}
