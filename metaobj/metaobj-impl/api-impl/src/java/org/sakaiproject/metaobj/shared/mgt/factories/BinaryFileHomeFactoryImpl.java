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

import java.util.Hashtable;
import java.util.Map;

import org.sakaiproject.metaobj.shared.mgt.HomeFactory;
import org.sakaiproject.metaobj.shared.mgt.ReadableObjectHome;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Apr 13, 2004
 * Time: 11:40:51 AM
 * To change this template use File | Settings | File Templates.
 */
public class BinaryFileHomeFactoryImpl extends HomeFactoryBase implements HomeFactory {
   private Map homes = new Hashtable();

   public boolean handlesType(String objectType) {
      return false;  //To change body of implemented methods use File | Settings | File Templates.
   }

   public ReadableObjectHome getHome(String objectType) {
      return null;  //To change body of implemented methods use File | Settings | File Templates.
   }

   /**
    * let injection set this for now...
    * will eventually load from the db
    */
   public Map getHomes() {
      return homes;
   }

   public void setHomes(Map homes) {
      this.homes = homes;
   }
}
