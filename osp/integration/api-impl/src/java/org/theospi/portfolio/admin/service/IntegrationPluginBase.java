/**********************************************************************************
* $URL$
* $Id$
***********************************************************************************
*
* Copyright (c) 2006 The Sakai Foundation.
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

package org.theospi.portfolio.admin.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.theospi.portfolio.admin.intf.SakaiIntegrationPlugin;

import java.util.List;

abstract public class IntegrationPluginBase implements SakaiIntegrationPlugin {
   protected final transient Log logger = LogFactory.getLog(getClass());

   private String title;
   private String description;
   private List potentialIntegrations;

   public String getDescription() {
      return description;
   }

   public void setDescription(String description) {
      this.description = description;
   }

   public List getPotentialIntegrations() {
      return potentialIntegrations;
   }

   public void setPotentialIntegrations(List potentialIntegrations) {
      this.potentialIntegrations = potentialIntegrations;
   }

   public String getTitle() {
      return title;
   }

   public void setTitle(String title) {
      this.title = title;
   }

}
