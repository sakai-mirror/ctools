/**********************************************************************************
* $URL$
* $Id$
***********************************************************************************
*
* Copyright (c) 2006 The Sakai Foundation.
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

package org.theospi.portfolio.admin.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.api.app.scheduler.SchedulerManager;
import org.sakaiproject.component.cover.ComponentManager;
import org.sakaiproject.content.api.ContentCollectionEdit;
import org.sakaiproject.content.api.ContentHostingService;
import org.sakaiproject.entity.api.ResourceProperties;
import org.sakaiproject.exception.IdUsedException;
import org.sakaiproject.tool.api.Session;
import org.sakaiproject.tool.cover.SessionManager;
import org.springframework.beans.factory.InitializingBean;
import org.theospi.portfolio.admin.intf.SakaiIntegrationPlugin;
import org.theospi.portfolio.admin.intf.SakaiIntegrationService;
import org.theospi.portfolio.admin.model.IntegrationOption;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class SakaiIntegrationServiceImpl implements SakaiIntegrationService, InitializingBean {
   protected final transient Log logger = LogFactory.getLog(getClass());

   private List integrationPlugins;
   private List dependantBeans;
   private long pollingInterval;
   private SchedulerManager schedulerManager;
   private ContentHostingService contentHostingService;
   private List initUsers = new ArrayList();

   protected void executePlugin(SakaiIntegrationPlugin plugin) {
      for (Iterator i=plugin.getPotentialIntegrations().iterator();i.hasNext();) {
         if (!plugin.executeOption((IntegrationOption) i.next())) {
            break;
         }
      }
   }

   public void afterPropertiesSet() throws Exception {
      logger.info("afterPropertiesSet()");
      // go through each integration plugin and execute it...
      Session sakaiSession = SessionManager.getCurrentSession();
      String userId = sakaiSession.getUserId();

      try {
         sakaiSession.setUserId("admin");
         sakaiSession.setUserEid("admin");
         createUserResourceDir();
         for (Iterator i=getIntegrationPlugins().iterator();i.hasNext();) {
            String pluginId = (String) i.next();
            SakaiIntegrationPlugin plugin = (SakaiIntegrationPlugin) ComponentManager.get(pluginId);
            executePlugin(plugin);
         }
      } catch (Exception e) {
         logger.warn("Temporarily catching all exceptions in osp.SakaiIntegrationServiceImpl.afterPropertiesSet()", e);
      } finally {
         sakaiSession.setUserEid(userId);
         sakaiSession.setUserId(userId);
      }
   }

   protected void createUserResourceDir() {
      for (Iterator iter = getInitUsers().iterator(); iter.hasNext();) {
         String userId = (String)iter.next();
         try {
            ContentCollectionEdit userCollection = getContentHostingService().addCollection("/user/" + userId + "/");
            userCollection.getPropertiesEdit().addProperty(ResourceProperties.PROP_DISPLAY_NAME, userId);
            getContentHostingService().commitCollection(userCollection);
         }
         catch (IdUsedException e) {
            // ignore... it is already there.
         }
         catch (Exception e) {
            throw new RuntimeException(e);
         }
      }
   }

   public List getIntegrationPlugins() {
      return integrationPlugins;
   }

   public void setIntegrationPlugins(List integrationPlugins) {
      this.integrationPlugins = integrationPlugins;
   }

   public List getDependantBeans() {
      return dependantBeans;
   }

   public void setDependantBeans(List dependantBeans) {
      this.dependantBeans = dependantBeans;
   }

   public long getPollingInterval() {
      return pollingInterval;
   }

   public void setPollingInterval(long pollingInterval) {
      this.pollingInterval = pollingInterval;
   }

   public SchedulerManager getSchedulerManager() {
      return schedulerManager;
   }

   public void setSchedulerManager(SchedulerManager schedulerManager) {
      this.schedulerManager = schedulerManager;
   }

   public ContentHostingService getContentHostingService() {
      return contentHostingService;
   }

   public void setContentHostingService(ContentHostingService contentHostingService) {
      this.contentHostingService = contentHostingService;
   }

   public List getInitUsers() {
      return initUsers;
   }

   public void setInitUsers(List initUsers) {
      this.initUsers = initUsers;
   }

}
