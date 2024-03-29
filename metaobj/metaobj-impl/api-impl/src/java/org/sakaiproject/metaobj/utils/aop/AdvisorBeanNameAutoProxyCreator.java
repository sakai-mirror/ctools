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

package org.sakaiproject.metaobj.utils.aop;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.aop.Advisor;
import org.springframework.aop.framework.ProxyFactory;
import org.springframework.aop.framework.autoproxy.BeanNameAutoProxyCreator;

public class AdvisorBeanNameAutoProxyCreator extends BeanNameAutoProxyCreator {
   protected final transient Log logger = LogFactory.getLog(getClass());

   private Advisor[] advisors;


   protected void customizeProxyFactory(ProxyFactory proxyFactory) {
      setAdvisors(proxyFactory.getAdvisors());
   }

   /**
    * Subclasses may choose to implement this: for example,
    * to change the interfaces exposed
    *
    * @param bean bean about to be autoproxied
    * @param pf   ProxyFactory that will be used to create the proxy
    *             immediably after this method returns
    *             protected void customizeProxyFactory(Object bean, ProxyFactory pf) {
    *             super.customizeProxyFactory(bean, pf);
    *             setAdvisors(pf.getAdvisors());
    *             }
    */

   public Advisor[] getAdvisors() {
      return advisors;
   }

   public void setAdvisors(Advisor[] advisors) {
      this.advisors = advisors;
   }
}
