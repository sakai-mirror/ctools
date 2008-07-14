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

import org.sakaiproject.metaobj.shared.model.StructuredArtifactDefinitionBean;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: May 19, 2004
 * Time: 3:31:16 PM
 * To change this template use File | Settings | File Templates.
 */
public class StructuredArtifactDefinitionValidator implements Validator {

   public static final String PICK_SCHEMA_ACTION = "pickSchema";
   public static final String PICK_TRANSFORM_ACTION = "pickTransform";
   public static final String PICK_ALTCREATEXSLT_ACTION = "pickAltCreate";
   public static final String PICK_ALTVIEWXSLT_ACTION = "pickAltView";

   public boolean supports(Class clazz) {
      return (StructuredArtifactDefinitionBean.class.isAssignableFrom(clazz));
   }

   public void validate(Object obj, Errors errors) {
      if (obj instanceof StructuredArtifactDefinitionBean) {
         StructuredArtifactDefinitionBean artifactHome = (StructuredArtifactDefinitionBean) obj;

         if (PICK_SCHEMA_ACTION.equals(artifactHome.getFilePickerAction()) ||
               PICK_TRANSFORM_ACTION.equals(artifactHome.getFilePickerAction()) ||
               PICK_ALTCREATEXSLT_ACTION.equals(artifactHome.getFilePickerAction()) ||
               PICK_ALTVIEWXSLT_ACTION.equals(artifactHome.getFilePickerAction())) {
            return;
         }

         if ((artifactHome.getSchemaFile() == null ||
               artifactHome.getSchemaFile().getValue() == null ||
               artifactHome.getSchemaFile().getValue().length() == 0)
               && artifactHome.getSchema() == null) {
            errors.rejectValue("schemaFile", "errors.required", "required");
         }
         if (artifactHome.getDocumentRoot() == null ||
               artifactHome.getDocumentRoot().length() == 0) {
            errors.rejectValue("documentRoot", "errors.required", "required");
         }
         if (artifactHome.getType() == null ||
               artifactHome.getType().getDescription() == null ||
               artifactHome.getType().getDescription().length() == 0) {
            errors.rejectValue("description", "errors.required", "required");
         }
      }
   }
}
