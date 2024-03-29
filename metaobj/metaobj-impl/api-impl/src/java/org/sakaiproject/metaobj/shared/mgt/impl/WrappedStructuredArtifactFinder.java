/*******************************************************************************
 * $URL$
 * $Id$
 * **********************************************************************************
 *
 *  Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
 *
 *  Licensed under the Educational Community License, Version 1.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.opensource.org/licenses/ecl1.php
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 ******************************************************************************/

package org.sakaiproject.metaobj.shared.mgt.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.content.api.ContentHostingService;
import org.sakaiproject.content.api.ContentResource;
import org.sakaiproject.content.api.ResourceType;
import org.sakaiproject.entity.api.ResourceProperties;
import org.sakaiproject.metaobj.shared.mgt.AgentManager;
import org.sakaiproject.metaobj.shared.mgt.IdManager;
import org.sakaiproject.metaobj.shared.model.Agent;
import org.sakaiproject.metaobj.shared.model.ContentResourceArtifact;
import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.metaobj.shared.model.MimeType;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Dec 11, 2006
 * Time: 8:48:47 AM
 * To change this template use File | Settings | File Templates.
 */
public class WrappedStructuredArtifactFinder  extends FileArtifactFinder {

   private ContentHostingService contentHostingService;
   private AgentManager agentManager;
   private IdManager idManager;
   private int finderPageSize = 1000;
   
   private static Log log = LogFactory.getLog(WrappedStructuredArtifactFinder.class);

   public Collection findByOwnerAndType(Id owner, String type) {
      Set<String> userCollectionIds = (Set<String>) getContentHostingService().getCollectionMap().keySet();
      Collection<ContentResource> artifacts = findArtifacts(type, userCollectionIds);
      ArrayList<ContentResourceArtifact> returned = new ArrayList<ContentResourceArtifact>();

      if (owner == null)
    	  log.info("Null owner passed to findByOwnerAndType -- returning all users' forms");
      
      for (Iterator<ContentResource> i = artifacts.iterator(); i.hasNext();) {
         ContentResource resource = i.next();
         Agent resourceOwner = getAgentManager().getAgent(resource.getProperties().getProperty(ResourceProperties.PROP_CREATOR));
         if (owner == null || owner.equals(resourceOwner.getId())) {         
        	 Id resourceId = getIdManager().getId(getContentHostingService().getUuid(resource.getId()));
        	 returned.add(new ContentResourceArtifact(resource, resourceId, resourceOwner));
         }
      }
      return returned;
   }

   public Collection findByOwnerAndType(Id owner, String type, MimeType mimeType) {
      return null;
   }

   public Collection findByOwner(Id owner) {
      return null;
   }

   public Collection findByWorksiteAndType(Id worksiteId, String type) {
      return null;
   }

   public Collection findByWorksite(Id worksiteId) {
      return null;
   }

   public Collection findByType(String type) {
      return null;
   }

   public boolean getLoadArtifacts() {
      return false;
   }

   public void setLoadArtifacts(boolean loadArtifacts) {

   }

   public ContentHostingService getContentHostingService() {
      return contentHostingService;
   }

   public void setContentHostingService(ContentHostingService contentHostingService) {
      this.contentHostingService = contentHostingService;
   }

   public AgentManager getAgentManager() {
      return agentManager;
   }

   public void setAgentManager(AgentManager agentManager) {
      this.agentManager = agentManager;
   }

   public IdManager getIdManager() {
      return idManager;
   }

   public void setIdManager(IdManager idManager) {
      this.idManager = idManager;
   }

   /**
    * @return the finderPageSize
    */
   public int getFinderPageSize() {
      return finderPageSize;
   }

   /**
    * @param finderPageSize the finderPageSize to set
    */
   public void setFinderPageSize(int finderPageSize) {
      this.finderPageSize = finderPageSize;
   }
  
	/**
	 * Find artifacts of a specific type; may be null to find all.
	 * 
	 * @deprecated This is a temporary method to avoid code duplication - it is
	 *             called by findByOwnerAndType here and findByType in
	 *             StructuredArtifactFinder
	 * @param type
	 *            The Form type to retrieve; may be null to get all types
	 * @param collectionIds
	 *            A set of collection IDs; if a resource does not belong to one of these, it will be
	 *            filtered before checking access; may be null to skip pre-filtering based on collection
	 * @return A filtered collection of ContentResource objects for readable Forms of the specific type
	 */
	@Deprecated
	protected Collection<ContentResource> findArtifacts(String type, Set<String> collectionIds) {
		//FIXME: Document exactly why WrappedStructuredArtifactFinder.findByType() returns null
		//TODO: Refactor Wrapped vs. Structured
		MetaobjFormFilter filter = new MetaobjFormFilter(type, collectionIds);
		ArrayList<ContentResource> artifacts = new ArrayList<ContentResource>();
		
		int page = 0;
		Collection<ContentResource> rawResources = getContentHostingService().getResourcesOfType(
				ResourceType.TYPE_METAOBJ, filter, getFinderPageSize(), page);
		
		while (rawResources != null) {
			artifacts.addAll(rawResources);
			page++;
			rawResources = getContentHostingService().getResourcesOfType(
					ResourceType.TYPE_METAOBJ, filter, getFinderPageSize(), page);
		}
		
		return artifacts;
	}
   
}
