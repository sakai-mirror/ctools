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

package org.sakaiproject.metaobj.shared.model.impl;

import org.sakaiproject.metaobj.shared.mgt.ReadableObjectHome;
import org.sakaiproject.metaobj.shared.model.Agent;
import org.sakaiproject.metaobj.shared.model.Artifact;
import org.sakaiproject.metaobj.shared.model.Id;

public class ArtifactImpl implements Artifact {
   private Agent owner;
   private Id id;
   private ReadableObjectHome home;
   private String displayName;

   public Agent getOwner() {
      return owner;
   }

   public void setOwner(Agent owner) {
      this.owner = owner;
   }

   public Id getId() {
      return id;
   }

   public void setId(Id id) {
      this.id = id;
   }

   public ReadableObjectHome getHome() {
      return home;
   }

   public void setHome(ReadableObjectHome home) {
      this.home = home;
   }

   public String getDisplayName() {
      return displayName;
   }

   public void setDisplayName(String displayName) {
      this.displayName = displayName;
   }
}
