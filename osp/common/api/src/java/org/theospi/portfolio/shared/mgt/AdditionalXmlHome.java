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
package org.theospi.portfolio.shared.mgt;

import java.util.Map;

import org.sakaiproject.metaobj.shared.mgt.HomeFactory;

public class AdditionalXmlHome {


   private Map additionalHomes;
   private HomeFactory xmlHomeFactory;

   public Map getAdditionalHomes() {
      return additionalHomes;
   }

   public void setAdditionalHomes(Map additionalHomes) {
      this.additionalHomes = additionalHomes;
   }

   public HomeFactory getXmlHomeFactory() {
      return xmlHomeFactory;
   }

   public void setXmlHomeFactory(HomeFactory xmlHomeFactory) {
      this.xmlHomeFactory = xmlHomeFactory;
   }

   public void init() {
      getXmlHomeFactory().getHomes().putAll(getAdditionalHomes());
   }

}

