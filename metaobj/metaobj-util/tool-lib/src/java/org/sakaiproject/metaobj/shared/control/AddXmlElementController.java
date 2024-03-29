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
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.validation.Errors;
import org.springframework.web.servlet.ModelAndView;
import org.sakaiproject.metaobj.utils.mvc.intf.Controller;
import org.sakaiproject.metaobj.utils.mvc.intf.CancelableController;
import org.sakaiproject.metaobj.utils.mvc.intf.CustomCommandController;
import org.sakaiproject.metaobj.utils.mvc.intf.FormController;
import org.sakaiproject.metaobj.shared.model.StructuredArtifact;
import org.sakaiproject.metaobj.shared.model.ElementBean;
import org.sakaiproject.metaobj.shared.model.Artifact;
import org.sakaiproject.metaobj.shared.model.PersistenceException;
import org.sakaiproject.metaobj.shared.mgt.home.StructuredArtifactHomeInterface;
import org.sakaiproject.metaobj.shared.mgt.WritableObjectHome;
import org.sakaiproject.metaobj.shared.FormHelper;
import org.sakaiproject.tool.api.ToolSession;
import org.sakaiproject.content.api.FilePickerHelper;

import java.util.Map;
import java.util.Hashtable;

/**
 * Created by IntelliJ IDEA.
 * <p/>
 * User: John Ellis
 * <p/>
 * Date: Apr 20, 2004
 * <p/>
 * Time: 3:31:02 PM
 * <p/>
 * To change this template use File | Settings | File Templates.
 */
public class AddXmlElementController extends XmlControllerBase
   implements Controller, CustomCommandController, CancelableController {
   protected final Log logger = LogFactory.getLog(getClass());

   public Object formBackingObject(Map request, Map session, Map application) {
      ElementBean returnedBean;
      if (session.get(EditedArtifactStorage.STORED_ARTIFACT_FLAG) == null) {
         StructuredArtifactHomeInterface home = getSchema(session);
         StructuredArtifact bean = (StructuredArtifact)home.createInstance();

         if (session.get(FormHelper.NEW_FORM_DISPLAY_NAME_TAG) != null) {
            bean.setDisplayName((String) session.get(FormHelper.NEW_FORM_DISPLAY_NAME_TAG));
         }

         bean.setParentFolder((String)session.get(FormHelper.PARENT_ID_TAG));
         EditedArtifactStorage sessionBean = new EditedArtifactStorage(bean.getCurrentSchema(),
            bean);
         session.put(EditedArtifactStorage.EDITED_ARTIFACT_STORAGE_SESSION_KEY,
            sessionBean);
         returnedBean = bean;
      }
      else {
         EditedArtifactStorage sessionBean = (EditedArtifactStorage)session.get(
            EditedArtifactStorage.EDITED_ARTIFACT_STORAGE_SESSION_KEY);
         returnedBean = sessionBean.getCurrentElement();
      }

      if (session.get(FilePickerHelper.FILE_PICKER_CANCEL) != null ||
            session.get(FilePickerHelper.FILE_PICKER_ATTACHMENTS) != null) {
         retrieveFileAttachments(request, session, returnedBean);
      }

      return returnedBean;
   }

   public ModelAndView handleRequest(Object requestModel, Map request, Map session,
                                     Map application, Errors errors) {
      ElementBean bean = (ElementBean)requestModel;
      if (request.get("cancel") != null) {
         session.put(FormHelper.RETURN_ACTION_TAG, FormHelper.RETURN_ACTION_CANCEL);
         session.remove(FormHelper.PREVIEW_HOME_TAG);
         session.remove(EditedArtifactStorage.STORED_ARTIFACT_FLAG);
         return new ModelAndView("success");
      }
      if (request.get("submitButton") == null) {
         return handleNonSubmit(bean, request, session, application, errors);
      }
      getValidator().validate(bean, errors, true);
      if (errors.hasErrors()) {
         return null;
      }
      StructuredArtifact artifact = (StructuredArtifact)bean;
      Artifact newArtifact;

      if (session.get(FormHelper.PREVIEW_HOME_TAG) != null) {
         request.remove("fileHelper");
         Map model = new Hashtable();
         model.put("success", "validationSuccessful");
         return handleNonSubmit(bean, request, session, application, errors, model);
      }

      try {
         WritableObjectHome home = getSchema(session);
         newArtifact = home.store(artifact);
         if (newArtifact.getId() != null) {
            session.put(FormHelper.RETURN_REFERENCE_TAG, newArtifact.getId().getValue());
            session.put(FormHelper.RETURN_ACTION_TAG, FormHelper.RETURN_ACTION_SAVE);
         }
      } catch (PersistenceException e) {
         errors.rejectValue(e.getField(), e.getErrorCode(), e.getErrorInfo(),
            e.getDefaultMessage());
      }
      session.remove(EditedArtifactStorage.STORED_ARTIFACT_FLAG);
      return new ModelAndView("success");
   }

}
