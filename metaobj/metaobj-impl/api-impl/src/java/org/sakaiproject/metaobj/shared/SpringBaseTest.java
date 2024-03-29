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

package org.sakaiproject.metaobj.shared;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import junit.framework.TestCase;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.metaobj.utils.ioc.ApplicationContextFactory;
import org.springframework.beans.factory.BeanFactory;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: May 6, 2004
 * Time: 12:46:55 PM
 * To change this template use File | Settings | File Templates.
 */
public abstract class SpringBaseTest extends TestCase {
   protected final Log logger = LogFactory.getLog(getClass());

   private BeanFactory beanFactory;

   protected SpringBaseTest(String s) {
      super(s);
   }

   protected SpringBaseTest() {
   }

   public BeanFactory getBeanFactory() {
      if (beanFactory == null) {
         Properties props = new Properties();
         InputStream in = this.getClass().getResourceAsStream("/test-context.properties");
         try {
            props.load(in);
         }
         catch (IOException e) {
            throw new RuntimeException("problem loading context.properties from classpath", e);
         }
         beanFactory = ApplicationContextFactory.getInstance().createContext(props);
      }
      return beanFactory;
   }

}
