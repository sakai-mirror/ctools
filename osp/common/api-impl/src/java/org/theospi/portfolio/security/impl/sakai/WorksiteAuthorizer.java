/**********************************************************************************
* $URL:https://source.sakaiproject.org/svn/osp/trunk/common/api-impl/src/java/org/theospi/portfolio/security/impl/sakai/WorksiteAuthorizer.java $
* $Id:WorksiteAuthorizer.java 9134 2006-05-08 20:28:42Z chmaurer@iupui.edu $
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
package org.theospi.portfolio.security.impl.sakai;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.authz.api.AuthzGroup;
import org.sakaiproject.authz.api.GroupNotDefinedException;
import org.sakaiproject.authz.cover.AuthzGroupService;
import org.sakaiproject.metaobj.shared.model.Agent;
import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.metaobj.worksite.mgt.WorksiteManager;
import org.theospi.portfolio.security.AuthorizationFacade;
import org.theospi.portfolio.security.app.ApplicationAuthorizer;


public class WorksiteAuthorizer implements ApplicationAuthorizer {
   protected final transient Log logger = LogFactory.getLog(getClass());

   protected List functions;

   /**
    * This method will ask the application specific functional authorizer to determine authorization.
    *
    * @param facade   this can be used to do explicit auths if necessary
    * @param agent
    * @param function
    * @param id
    * @return null if the authorizer has no opinion, true if authorized, false if explicitly not authorized.
    */
   public Boolean isAuthorized(AuthorizationFacade facade, Agent agent, String function, Id id) {

      try {
         if (function.equals(WorksiteManager.WORKSITE_MAINTAIN)) {
            return checkRoleAccess(agent, function, id);
         }
         else {
            return null;
         }
      } catch (GroupNotDefinedException e) {
         logger.info("current worksite not known", e);
         return null;
      }
   }

   protected Boolean checkRoleAccess(Agent agent, String function, Id worksiteId) throws GroupNotDefinedException {
      AuthzGroup authzgroup = AuthzGroupService.getInstance()
								.getAuthzGroup("/site/" + worksiteId.getValue());
      
      String maintain = authzgroup.getMaintainRole();
      
      return new Boolean(authzgroup.hasRole(agent.getId().getValue(), maintain));
   }

   public List getFunctions() {
      return functions;
   }

   public void setFunctions(List functions) {
      this.functions = functions;
   }

}
