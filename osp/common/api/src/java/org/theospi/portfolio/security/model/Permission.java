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
package org.theospi.portfolio.security.model;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.metaobj.shared.model.Agent;

public class Permission {
   protected final transient Log logger = LogFactory.getLog(getClass());

   private Agent agent;
   private String function;
   private boolean readOnly = false;


   public Permission() {
   }

   public Permission(Agent agent, String function) {
      this.agent = agent;
      this.function = function;
   }

   public Permission(Agent agent, String function, boolean readOnly) {
      this.agent = agent;
      this.function = function;
      this.readOnly = readOnly;
   }

   public String getFunction() {
      return function;
   }

   public void setFunction(String function) {
      this.function = function;
   }

   public Agent getAgent() {
      return agent;
   }

   public void setAgent(Agent agent) {
      this.agent = agent;
   }

   public boolean isReadOnly() {
      return readOnly;
   }

   public void setReadOnly(boolean readOnly) {
      this.readOnly = readOnly;
   }

   public String toString() {
      return getAgent().getDisplayName() + "~" + getFunction();
   }

   public boolean equals(Object o) {
      if (this == o) return true;
      if (!(o instanceof Permission)) return false;

      final Permission permission = (Permission) o;

      if (agent != null ? !agent.equals(permission.agent) : permission.agent != null) return false;
      if (function != null ? !function.equals(permission.function) : permission.function != null) return false;

      return true;
   }

   public int hashCode() {
      int result;
      result = (agent != null ? agent.hashCode() : 0);
      result = 29 * result + (function != null ? function.hashCode() : 0);
      return result;
   }
}
