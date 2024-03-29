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


package org.sakaiproject.metaobj.shared.control;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * @author chmaurer
 */
public class SessionListener implements HttpSessionListener {

   protected final transient Log logger = LogFactory.getLog(getClass());

   public void sessionCreated(HttpSessionEvent event) {
      // TODO Auto-generated method stub
      //Enumeration foo = event.getSession();
      logger.warn("SessionListener create - " + event.getSource());
      try {
         throw new Exception();
      }
      catch (Exception e) {
         e.printStackTrace();
      }
   }

   public void sessionDestroyed(HttpSessionEvent event) {
      // TODO Auto-generated method stub
      logger.warn("SessionListener destroy - " + event.getSource());
      try {
         throw new Exception();
      }
      catch (Exception e) {
         e.printStackTrace();
      }
   }

}
