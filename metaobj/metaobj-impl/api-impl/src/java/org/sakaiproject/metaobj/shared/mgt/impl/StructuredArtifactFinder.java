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

package org.sakaiproject.metaobj.shared.mgt.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

import org.sakaiproject.authz.cover.SecurityService;
import org.sakaiproject.content.api.ContentResource;
import org.sakaiproject.content.api.ResourceType;
import org.sakaiproject.entity.api.ResourceProperties;
import org.sakaiproject.metaobj.shared.mgt.HomeFactory;
import org.sakaiproject.metaobj.shared.mgt.home.StructuredArtifactHomeInterface;
import org.sakaiproject.metaobj.shared.model.*;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Aug 17, 2005
 * Time: 2:33:51 PM
 * To change this template use File | Settings | File Templates.
 */
public class StructuredArtifactFinder extends WrappedStructuredArtifactFinder {

   private HomeFactory homeFactory;

   protected Artifact createArtifact(ContentResource resource) {
      String formType = (String) resource.getProperties().get(
         resource.getProperties().getNamePropStructObjType());

      StructuredArtifactHomeInterface home =
         (StructuredArtifactHomeInterface) getHomeFactory().getHome(formType);

      return home.load(resource);
   }

   public HomeFactory getHomeFactory() {
      return homeFactory;
   }

   public void setHomeFactory(HomeFactory homeFactory) {
      this.homeFactory = homeFactory;
   }

   public Collection findByType(String type) {
      Collection<ContentResource> filteredArtifacts = new ArrayList<ContentResource>();
      int page = 0;
      Collection<ContentResource> rawResources = getContentHostingService().getResourcesOfType(
            ResourceType.TYPE_METAOBJ, getFinderPageSize(), page);
      while (rawResources != null && rawResources.size() > 0) {
         
         filteredArtifacts.addAll(filterArtifacts(rawResources, type, true));
         page++;
         rawResources = getContentHostingService().getResourcesOfType(
               ResourceType.TYPE_METAOBJ, getFinderPageSize(), page);
      }
      
      //List artifacts = getContentHostingService().findResources(type,
      //      null, null, false);

      Collection<Artifact> returned = new ArrayList<Artifact>();

      for (Iterator<ContentResource> i = filteredArtifacts.iterator(); i.hasNext();) {
         ContentResource resource = (ContentResource) i.next();
         returned.add(createArtifact(resource));
      }

      return returned;
   }
   
   protected Collection filterArtifacts(Collection artifacts, String type, boolean checkPerms)
   {
      for (Iterator i = artifacts.iterator(); i.hasNext();)
      {
         ContentResource resource = (ContentResource) i.next();
         //check for read permissions...
         if (!checkPerms || SecurityService.unlock("content.read", resource.getId())) 
         {
            String currentType = resource.getProperties().getProperty(ResourceProperties.PROP_STRUCTOBJ_TYPE);
            //String mimeType = resource.getProperties().getProperty(ResourceProperties.PROP_CONTENT_TYPE);
   
            if (type != null && !type.equals(ResourceProperties.FILE_TYPE))
            {
               // process StructuredObject type
               if (currentType == null)
               {
                  i.remove();
               }
               else if (!currentType.equals(type))
               {
                  i.remove();
               }
            }
            else 
            {
               // this one is a structured object, get rid of it
               i.remove();
            }
         }
         else {
            i.remove();
         }
      }
      return artifacts;
   }

}
