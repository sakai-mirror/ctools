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
package org.theospi.portfolio.presentation.model.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.entity.api.Entity;
import org.sakaiproject.metaobj.shared.mgt.EntityProducerBase;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Jan 8, 2006
 * Time: 4:53:43 PM
 * To change this template use File | Settings | File Templates.
 */
public class LayoutEntityProducer extends EntityProducerBase {
   
   protected final Log logger = LogFactory.getLog(getClass());
   protected static final String PRODUCER_NAME = "ospPresentationLayout";

   public String getLabel() {
      return PRODUCER_NAME;
   }

   public void init() {
      logger.info("init()");
      try {
         getEntityManager().registerEntityProducer(this, Entity.SEPARATOR + PRODUCER_NAME);
      }
      catch (Exception e) {
         logger.warn("Error registering Layout Entity Producer", e);
      }
   }
}
