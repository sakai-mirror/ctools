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
import org.theospi.portfolio.admin.model.IntegrationOption;

import java.util.List;

public class RoleIntegrationOption extends IntegrationOption {
   protected final transient Log logger = LogFactory.getLog(getClass());

   private String copyOf;
   private List permissionsOn;
   private List permissionsOff;
   private String realm;
   private String roleId;

   public String getCopyOf() {
      return copyOf;
   }

   public void setCopyOf(String copyOf) {
      this.copyOf = copyOf;
   }

   public List getPermissionsOff() {
      return permissionsOff;
   }

   public void setPermissionsOff(List permissionsOff) {
      this.permissionsOff = permissionsOff;
   }

   public List getPermissionsOn() {
      return permissionsOn;
   }

   public void setPermissionsOn(List permissionsOn) {
      this.permissionsOn = permissionsOn;
   }

   public String getRealm() {
      return realm;
   }

   public void setRealm(String realm) {
      this.realm = realm;
   }

   public String getRoleId() {
      return roleId;
   }

   public void setRoleId(String roleId) {
      this.roleId = roleId;
   }
}
