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

package org.sakaiproject.metaobj.shared.mgt;

import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.metaobj.utils.xml.SchemaFactory;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Apr 9, 2004
 * Time: 12:46:02 PM
 * To change this template use File | Settings | File Templates.
 */
public class HomeFactoryImpl implements HomeFactory {
   protected final Log logger = LogFactory.getLog(getClass());
   private List homeFactories = null;

   public boolean handlesType(String objectType) {

      for (Iterator i = homeFactories.iterator(); i.hasNext();) {
         if (((HomeFactory) i.next()).handlesType(objectType)) {
            return true;
         }
      }

      return false;
   }

   public ReadableObjectHome getHome(String objectType) {

      for (Iterator i = homeFactories.iterator(); i.hasNext();) {
         HomeFactory testFactory = (HomeFactory) i.next();
         if (testFactory.handlesType(objectType)) {
            return testFactory.getHome(objectType);
         }
      }

      return null;
   }

   public ReadableObjectHome findHomeByExternalId(String externalId, Id worksiteId) {

      for (Iterator i = getHomeFactories().iterator(); i.hasNext();) {
         ReadableObjectHome home = ((HomeFactory) i.next()).findHomeByExternalId(externalId, worksiteId);
         if (home != null) {
            return home;
         }
      }

      return null;
   }

   public Map getHomes() {
      Map homes = new Hashtable();

      for (Iterator i = getHomeFactories().iterator(); i.hasNext();) {
         homes.putAll(((HomeFactory) i.next()).getHomes());
      }

      return homes;
   }

   public Map getWorksiteHomes(Id worksiteId) {
      return getWorksiteHomes(worksiteId, false);
   }

   public Map getWorksiteHomes(Id worksiteId, boolean includeHidden) {
      Map homes = new Hashtable();

      for (Iterator i = getHomeFactories().iterator(); i.hasNext();) {
         homes.putAll(((HomeFactory) i.next()).getWorksiteHomes(worksiteId, includeHidden));
      }

      return homes;
   }

   public Map getHomes(Class requiredHomeType) {
      Map homes = new Hashtable();

      for (Iterator i = getHomeFactories().iterator(); i.hasNext();) {
         homes.putAll(((HomeFactory) i.next()).getHomes(requiredHomeType));
      }

      return homes;
   }

   public void reload() {
      SchemaFactory.getInstance().reload();
      for (Iterator j = getHomes().values().iterator(); j.hasNext();) {
         ReadableObjectHome home = (ReadableObjectHome) j.next();
         home.refresh();
      }
   }

   public List getHomeFactories() {
      return homeFactories;
   }

   public void setHomeFactories(List homeFactories) {
      this.homeFactories = homeFactories;
   }
}
