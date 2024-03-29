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

package org.sakaiproject.metaobj.utils.mvc.impl;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public class HttpServletHelper {
   private static HttpServletHelper ourInstance = null;

   public static HttpServletHelper getInstance() {
      if (ourInstance == null) {
         ourInstance = new HttpServletHelper();
      }

      return ourInstance;
   }

   private HttpServletHelper() {
   }


   public void reloadApplicationMap(HttpServletRequest request, Map map) {

      /*
      for (Iterator keys = map.keySet().iterator(); keys.hasNext();) {
         String key = (String) keys.next();
         if (map.get(key) == null) {
            request.getSession().getServletContext().removeAttribute(key);
         }
         else if (!map.get(key).equals(request.getSession().getServletContext().getAttribute(key))) {
            request.getSession().getServletContext().setAttribute(key,
               map.get(key));
         }
      }

      Enumeration enumer = request.getSession().getServletContext().getAttributeNames();

      while (enumer.hasMoreElements()) {
         String key = (String)enumer.nextElement();

         if (map.get(key) == null) {
            request.getSession().getServletContext().removeAttribute(key);
         }
      }
      */
   }

   public Map createApplicationMap(HttpServletRequest request) {
      Map parameters = new HashMap();
      //Enumeration enumer = request.getSession().getServletContext().getAttributeNames();

      //while (enumer.hasMoreElements()) {
      //   String key = (String) enumer.nextElement();
      //   parameters.put(key, request.getSession().getServletContext().getAttribute(key));
      //}

      return parameters;
   }

   public void reloadSessionMap(HttpServletRequest request, Map map) {

      for (Iterator keys = map.keySet().iterator(); keys.hasNext();) {
         String key = (String) keys.next();

         if (map.get(key) == null) {
            request.getSession().removeAttribute(key);
         }
         else if (!map.get(key).equals(request.getSession().getAttribute(key))) {
            request.getSession().setAttribute(key, map.get(key));
         }
      }

      Enumeration enumer = request.getSession().getAttributeNames();

      while (enumer.hasMoreElements()) {
         String key = (String) enumer.nextElement();

         if (map.get(key) == null) {
            request.getSession().removeAttribute(key);
         }
      }
   }

   public Map createSessionMap(HttpServletRequest request) {
      Map parameters = new HashMap();
      Enumeration enumer = request.getSession().getAttributeNames();

      while (enumer.hasMoreElements()) {
         String key = (String) enumer.nextElement();
         parameters.put(key, request.getSession().getAttribute(key));
      }

      return parameters;
   }

   public void reloadRequestMap(HttpServletRequest request, Map map) {

      for (Iterator keys = map.keySet().iterator(); keys.hasNext();) {
         String key = (String) keys.next();
         if (map.get(key) == null) {
            request.removeAttribute(key);
         }
         else if (!map.get(key).equals(request.getAttribute(key))) {
            request.setAttribute(key, map.get(key));
         }
      }

      Enumeration enumer = request.getAttributeNames();

      while (enumer.hasMoreElements()) {
         String key = (String) enumer.nextElement();

         if (map.get(key) == null) {
            request.removeAttribute(key);
         }
      }
   }

   public Map createRequestMap(HttpServletRequest request) {
      Map parameters = new HashMap();
      Enumeration enumer = request.getAttributeNames();

      while (enumer.hasMoreElements()) {
         String key = (String) enumer.nextElement();
         parameters.put(key, request.getAttribute(key));
      }

      enumer = request.getParameterNames();

      while (enumer.hasMoreElements()) {
         String key = (String) enumer.nextElement();
         if (request.getParameterValues(key).length > 1) {
            parameters.put(key, request.getParameterValues(key));
         }
         else {
            parameters.put(key, request.getParameter(key));
         }
      }

      return parameters;
   }


}
