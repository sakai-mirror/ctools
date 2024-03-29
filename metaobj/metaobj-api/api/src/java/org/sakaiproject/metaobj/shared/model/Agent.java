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

package org.sakaiproject.metaobj.shared.model;

import java.io.Serializable;
import java.security.Principal;
import java.util.List;


/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Apr 8, 2004
 * Time: 5:21:55 PM
 * To change this template use File | Settings | File Templates.
 */
public interface Agent extends Serializable, Principal {
   public static final String AGENT_SESSION_KEY = "osp_agent";

   public static final String ROLE_MEMEBER = "ROLE_MEMBER";
   public static final String ROLE_ADMIN = "ROLE_ADMIN";
   public static final String ROLE_REVIEWER = "ROLE_REVIEWER";
   public static final String ROLE_GUEST = "ROLE_GUEST";
   public static final String ROLE_ANONYMOUS = "ROLE_ANONYMOUS";

   public Id getId();
   
   public Id getEid();

   public Artifact getProfile();

   public Object getProperty(String key);

   public String getDisplayName();

   public boolean isInRole(String role);

   public boolean isInitialized();

   public String getRole();

   public List getWorksiteRoles(String worksiteId);

   public List getWorksiteRoles();

   public boolean isRole();

}
