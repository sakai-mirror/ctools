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

package org.sakaiproject.metaobj.shared.mgt.factories;

import java.util.Iterator;
import java.util.Map;

import org.sakaiproject.metaobj.shared.mgt.HomeFactory;
import org.sakaiproject.metaobj.shared.mgt.ReadableObjectHome;
import org.sakaiproject.metaobj.shared.mgt.StructuredArtifactDefinitionManager;
import org.sakaiproject.metaobj.shared.mgt.home.StructuredArtifactDefinition;
import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.metaobj.shared.model.StructuredArtifactDefinitionBean;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Apr 9, 2004
 * Time: 12:51:01 PM
 * To change this template use File | Settings | File Templates.
 */
public class DbXmlHomeFactoryImpl extends HomeFactoryBase implements HomeFactory {

   private StructuredArtifactDefinitionManager structuredArtifactDefinitionManager;

   public boolean handlesType(String objectType) {
      return (getHome(objectType) != null);
   }

   public Map getHomes(Class requiredHomeType) {
      return super.getHomes(requiredHomeType);
   }

   public ReadableObjectHome findHomeByExternalId(String externalId, Id worksiteId) {
      return createHome(getStructuredArtifactDefinitionManager().loadHomeByExternalType(externalId, worksiteId));
   }

   public ReadableObjectHome getHome(String objectType) {
      return createHome(getStructuredArtifactDefinitionManager().loadHome(objectType));
   }

   public Map getWorksiteHomes(Id worksiteId) {
      return createHomes(getStructuredArtifactDefinitionManager().getWorksiteHomes(worksiteId));
   }

   public Map getWorksiteHomes(Id worksiteId, boolean includeHidden) {
      return createHomes(getStructuredArtifactDefinitionManager().getWorksiteHomes(worksiteId, true));
   }

   public Map getHomes() {
      return createHomes(getStructuredArtifactDefinitionManager().getHomes());
   }

   protected Map createHomes(Map homeBeans) {
      for (Iterator i = homeBeans.entrySet().iterator(); i.hasNext();) {
         Map.Entry entry = (Map.Entry) i.next();
         entry.setValue(createHome((StructuredArtifactDefinitionBean) entry.getValue()));
      }
      return homeBeans;
   }

   protected ReadableObjectHome createHome(StructuredArtifactDefinitionBean sadBean) {
      return new StructuredArtifactDefinition(sadBean);
   }

   public StructuredArtifactDefinitionManager getStructuredArtifactDefinitionManager() {
      return structuredArtifactDefinitionManager;
   }

   public void setStructuredArtifactDefinitionManager(StructuredArtifactDefinitionManager structuredArtifactDefinitionManager) {
      this.structuredArtifactDefinitionManager = structuredArtifactDefinitionManager;
   }

}
