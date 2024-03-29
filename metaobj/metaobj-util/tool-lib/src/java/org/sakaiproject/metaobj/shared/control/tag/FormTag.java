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

package org.sakaiproject.metaobj.shared.control.tag;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.component.cover.ComponentManager;
import org.sakaiproject.metaobj.shared.mgt.PortalParamManager;

public class FormTag extends BodyTagSupport {
   protected final transient Log logger = LogFactory.getLog(getClass());

   private final static String paramFormat =
         "<input type=\"hidden\" name=\"{0}\" value=\"{1}\" />";

   public int doStartTag() throws JspException {
      // add hidden inputs here
      Map newParams = getPortalParamManager().getParams(this.pageContext.getRequest());

      for (Iterator i = newParams.entrySet().iterator(); i.hasNext();) {
         Map.Entry entry = (Map.Entry) i.next();
         try {
            pageContext.getOut().write(MessageFormat.format(paramFormat,
                  new Object[]{entry.getKey(), entry.getValue()}));
         }
         catch (IOException e) {
            logger.error("", e);
            throw new JspException(e);
         }
      }

      return EVAL_BODY_INCLUDE;
   }

   protected PortalParamManager getPortalParamManager() {
      return (PortalParamManager)
            ComponentManager.getInstance().get(PortalParamManager.class.getName());
   }
}
