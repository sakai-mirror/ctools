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

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.component.cover.ComponentManager;
import org.sakaiproject.metaobj.shared.mgt.PortalParamManager;

public class RedirectView extends org.springframework.web.servlet.view.RedirectView {
   protected final transient Log logger = LogFactory.getLog(getClass());

   /**
    * Prepares the view given the specified model, merging it with static
    * attributes and a RequestContext attribute, if necessary.
    * Delegates to renderMergedOutputModel for the actual rendering.
    *
    * @see #renderMergedOutputModel
    */
   public void render(Map model, HttpServletRequest request, HttpServletResponse response) throws Exception {
      if (model == null) {
         model = new HashMap();
      }
      model.putAll(getPortalParamManager().getParams(request));
      super.render(model, request, response);
   }

   protected PortalParamManager getPortalParamManager() {
      return (PortalParamManager)
            ComponentManager.getInstance().get(PortalParamManager.class.getName());
   }

}
