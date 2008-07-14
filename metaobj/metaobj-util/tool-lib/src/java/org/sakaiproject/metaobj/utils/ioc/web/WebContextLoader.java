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

package org.sakaiproject.metaobj.utils.ioc.web;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.component.cover.ComponentManager;
import org.sakaiproject.component.impl.SpringCompMgr;
import org.sakaiproject.metaobj.utils.ioc.ApplicationContextFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextException;
import org.springframework.web.context.ConfigurableWebApplicationContext;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.XmlWebApplicationContext;

public class WebContextLoader extends ContextLoader {
   private final Log logger = LogFactory.getLog(ContextLoader.class);
   private static final String WEB_INF_PREFIX = "/WEB-INF";

   /**
    * Default context class for ContextLoader.
    *
    * @see org.springframework.web.context.support.XmlWebApplicationContext
    */
   private static final Class DEFAULT_CONTEXT_CLASS_1_1_5 = XmlWebApplicationContext.class;

   /**
    * Instantiate the root WebApplicationContext for this loader, either a default
    * XmlWebApplicationContext or a custom context class if specified.
    * This implementation expects custom contexts to implement ConfigurableWebApplicationContext.
    * Can be overridden in subclasses.
    *
    * @throws BeansException if the context couldn't be initialized
    * @see #CONTEXT_CLASS_PARAM
    * @see org.springframework.web.context.ConfigurableWebApplicationContext
    * @see org.springframework.web.context.support.XmlWebApplicationContext
    */
   protected WebApplicationContext createWebApplicationContext(ServletContext servletContext, ApplicationContext parent)
         throws BeansException {
      String contextClassName = servletContext.getInitParameter(CONTEXT_CLASS_PARAM);
      Class contextClass = DEFAULT_CONTEXT_CLASS_1_1_5;
      if (contextClassName != null) {
         try {
            contextClass = Class.forName(contextClassName, true, Thread.currentThread().getContextClassLoader());
         }
         catch (ClassNotFoundException ex) {
            throw new ApplicationContextException("Failed to load context class [" + contextClassName + "]", ex);
         }
         if (!ConfigurableWebApplicationContext.class.isAssignableFrom(contextClass)) {
            throw new ApplicationContextException("Custom context class [" + contextClassName + "] is not of type ConfigurableWebApplicationContext");
         }
      }
      ConfigurableWebApplicationContext wac =
            (ConfigurableWebApplicationContext) BeanUtils.instantiateClass(contextClass);
      //wac.setParent(parent);
      wac.setParent(((SpringCompMgr) ComponentManager
            .getInstance()).getApplicationContext());
      wac.setServletContext(servletContext);
      String contextFileName = servletContext.getInitParameter(CONFIG_LOCATION_PARAM);

      try {
         wac.setConfigLocations(getConfigLocations(contextFileName));
      }
      catch (IOException e) {
         throw new ApplicationContextException("I/O error loading '" + contextFileName +
               "' from classpath while creating application context: " + e.getMessage(), e);
      }
      wac.refresh();
      return wac;
   }

   protected String[] getConfigLocations(String contextFileName) throws IOException {
      Properties props = new Properties();
      props.load(this.getClass().getResourceAsStream(contextFileName));
      String[] configLocations = ApplicationContextFactory.getInstance().getConfigLocations(props);
      for (int i = 0; i < configLocations.length; i++) {
         configLocations[i] = WEB_INF_PREFIX + configLocations[i];
      }
      return configLocations;
   }

}
