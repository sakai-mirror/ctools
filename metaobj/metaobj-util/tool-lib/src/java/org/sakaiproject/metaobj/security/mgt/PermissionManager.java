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

package org.sakaiproject.metaobj.security.mgt;

import java.util.List;

import org.sakaiproject.metaobj.security.model.PermissionsEdit;
import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.site.api.Site;

public interface PermissionManager {

   public List getWorksiteRoles(PermissionsEdit edit);

   public List getAppFunctions(PermissionsEdit edit);

   public PermissionsEdit fillPermissions(PermissionsEdit edit);

   public void updatePermissions(PermissionsEdit edit);

   public void duplicatePermissions(Id srcQualifier, Id targetQualifier, Site newSite);

}
