/*
 * *********************************************************************************
 *  $URL$
 *  $Id$
 * **********************************************************************************
 *
 *  Copyright (c) 2003, 2004, 2005, 2006 The Sakai Foundation.
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
 * *********************************************************************************
 *
 */

package org.sakaiproject.metaobj.shared.control;

import org.sakaiproject.metaobj.shared.SharedFunctionConstants;
import org.sakaiproject.metaobj.shared.model.PersistenceException;
import org.sakaiproject.metaobj.shared.model.StructuredArtifactDefinitionBean;
import org.sakaiproject.metaobj.utils.mvc.intf.LoadObjectController;
import org.springframework.validation.Errors;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Jun 6, 2006
 * Time: 6:57:42 AM
 * To change this template use File | Settings | File Templates.
 */
public class DeleteStructuredArtifactDefinitionController extends PublishStructuredArtifactDefinitionController
   implements LoadObjectController {

   public ModelAndView handleRequest(Object requestModel, Map request, Map session, Map application, Errors errors) {
      StructuredArtifactDefinitionBean sad = (StructuredArtifactDefinitionBean) requestModel;
      checkPermission(SharedFunctionConstants.DELETE_ARTIFACT_DEF);
      try {
         getStructuredArtifactDefinitionManager().delete(sad);
      }
      catch (PersistenceException e) {
         errors.rejectValue(e.getField(), e.getErrorCode(), e.getErrorInfo(),
               e.getDefaultMessage());
      }
      return prepareListView(request, sad.getId().getValue());
   }


}
