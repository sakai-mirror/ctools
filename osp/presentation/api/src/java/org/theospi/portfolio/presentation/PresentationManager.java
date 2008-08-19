/**********************************************************************************
* $URL$
* $Id$
***********************************************************************************
*
* Copyright (c) 2005, 2006, 2007 The Sakai Foundation.
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
package org.theospi.portfolio.presentation;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Collection;
import java.util.List;

import org.jdom.Document;
import org.sakaiproject.entity.api.Reference;
import org.sakaiproject.metaobj.shared.model.Agent;
import org.sakaiproject.metaobj.shared.model.Id;
import org.theospi.portfolio.presentation.model.Presentation;
import org.theospi.portfolio.presentation.model.PresentationComment;
import org.theospi.portfolio.presentation.model.PresentationItem;
import org.theospi.portfolio.presentation.model.PresentationItemDefinition;
import org.theospi.portfolio.presentation.model.PresentationLayout;
import org.theospi.portfolio.presentation.model.PresentationLog;
import org.theospi.portfolio.presentation.model.PresentationPage;
import org.theospi.portfolio.presentation.model.PresentationTemplate;
import org.theospi.portfolio.presentation.model.TemplateFileRef;
import org.theospi.portfolio.security.model.CleanupableService;
import org.theospi.portfolio.shared.model.Node;

/**
 * This class provides a management layer into the presentations included in the system.
 * @author John Bush (jbush@rsmart.com)
 * $Header: /opt/CVS/osp2.x/presentation/api/src/java/org/theospi/portfolio/presentation/PresentationManager.java,v 1.5 2005/10/26 23:53:01 jellis Exp $
 * $Revision: 8645 $
 * $Date$
 */

public interface PresentationManager extends CleanupableService {

   public static final String PRESENTATION_PROPERTIES_FOLDER = "portfolioPropertyForms";
   public static final String PRESENTATION_PROPERTIES_FOLDER_DISPNAME = "portfolioPropertyForms.displayName";
   public static final String PRESENTATION_PROPERTIES_FOLDER_DESC = "portfolioPropertyForms.description";
   public static final String PORTFOLIO_INTERACTION_FOLDER_DISPNAME = "portfolioInteraction.displayName";
   public static final String PORTFOLIO_INTERACTION_FOLDER_DESC = "portfolioInteraction.description";
   public static final String PRESENTATION_PROPERTIES_FOLDER_PATH = "/" + PRESENTATION_PROPERTIES_FOLDER + "/";
   public static final String PRESENTATION_MESSAGE_BUNDLE = "org.theospi.portfolio.presentation.bundle.Messages";

   
   public PresentationTemplate storeTemplate(PresentationTemplate template);
   public PresentationTemplate storeTemplate(PresentationTemplate template, boolean checkAuthz, boolean updateDates);
   
   public boolean deletePresentationTemplate(Id id);
   public void deletePresentationLayout(Id id);

   public PresentationTemplate getPresentationTemplate(Id id);

   public PresentationItemDefinition getPresentationItemDefinition(Id item);

   public void deletePresentationItem(Id item);

   public Presentation getPresentation(Id id);
   public Presentation getLightweightPresentation(Id id);

   public Presentation storePresentation(Presentation presentation);
   public Presentation storePresentation(Presentation presentation, boolean checkAuthz, boolean updateDates);
   
   public void deletePresentation(Id presentation);

   public PresentationItem getPresentationItem(Id itemDef);

   public void updateItemDefintion(PresentationItemDefinition itemDef);

   public void deletePresentationItemDefinition(Id itemDef);

   public TemplateFileRef getTemplateFileRef(Id refId);
   public void updateTemplateFileRef(TemplateFileRef ref);
   public void deleteTemplateFileRef(Id refId);

   /**
    * returns a list of all presentation owned by agent.
    *
    * @param owner
    * @return
    */
   public Collection findPresentationsByOwner(Agent owner);

   /**
    * returns a list of all presentation owned by agent within the given toolId.
    *
    * @param owner
    * @return
    */
   public Collection findPresentationsByOwner(Agent owner, String toolId);


   /**
    * returns a list of all presentation templates owned by agent.
    *
    * @param owner
    * @return
    */
   public Collection findTemplatesByOwner(Agent owner);

   /**
    * returns a list of all presentation templates owned by agent within the given siteId.
    *
    * @param owner
    * @return
    */
   public Collection findTemplatesByOwner(Agent owner, String siteId);

   public Collection findPublishedTemplates(String siteId);

   public Collection findGlobalTemplates();

   public Collection findPublishedTemplates();

   public Collection findPublishedLayouts(String siteId);
   public Collection findLayoutsByOwner(Agent owner, String siteId);
   public Collection findMyGlobalLayouts();
   public Collection findAllGlobalLayouts();

   public PresentationLayout storeLayout(PresentationLayout layout);
   public PresentationLayout storeLayout(PresentationLayout layout, boolean checkAuthz);
   
   public PresentationLayout getPresentationLayout(Id layoutId);
   
   public List getPresentationPagesByPresentation(Id presentationId);
   public PresentationPage getPresentationPage(Id id);
   public Document getPresentationLayoutAsXml(Presentation presentation, String pageId);
   
   /**
    * Creates an xml document represenation of the requested page from the 
    * presentation passed in.
    * 
    * @param presentation
    * @param pageId
    * @return xml representation of the requested page or null
    */
   public Document getPresentationPreviewLayoutAsXml(Presentation presentation, String pageId);

   /**
    * returns a list of all presentations owned by agent </br>
    *
    * @param viewer
    * @return
    */
   public Collection findPresentationsByViewer(Agent viewer);

   /**
    * returns a list of all presentations agent can view within the given tool</br>
    *
    * @param viewer
    * @param toolId
    * @return
    */
   public Collection findPresentationsByViewer(Agent viewer, String toolId);
   
   /**
    * 
    * returns a list of all presentations agent can view within the given tool, optionally showing hidden presentations</br>
    * 
    * @param viewer
    * @param toolId
    * @param showHidden
    * @return
    */
   public Collection findPresentationsByViewer(Agent viewer, String toolId, boolean showHidden);

   /**
    * returns a list of all presentations agent can view, optionally showing hidden presentations</br>
    * 
    * @param viewer
    * @param showHidden
    * @return
    */
   public Collection findPresentationsByViewer(Agent viewer, boolean showHidden);

   public void createComment(PresentationComment comment);
   public void createComment(PresentationComment comment, boolean checkAuthz, boolean updateDates);

   public List getPresentationComments(Id presentationId, Agent viewer);

   public PresentationComment getPresentationComment(Id id);

   public void deletePresentationComment(PresentationComment comment);

   public void updatePresentationComment(PresentationComment oldComment);

   /**
     * returns list of comments owned by agent in given tool.  Includes comments created by the owner.
     * @param owner
     * @param sortBy
     * @return
     */
   public List getOwnerComments(Agent owner, CommentSortBy sortBy);

   /**
    * returns list of comments owned by agent in given tool.  Includes comments created by the owner.
    * @param owner
    * @param toolId
    * @param sortBy
    * @param excludeOwner - set to true to exclude comments created by the owner
    * @return
    */
   public List getOwnerComments(Agent owner, String toolId, CommentSortBy sortBy, boolean excludeOwner);

   /**
    * returns list of comments owned by agent in given tool.  Includes comments created by the owner.
    * @param owner
    * @param toolId
    * @param sortBy
    * @return
    */
   public List getOwnerComments(Agent owner, String toolId, CommentSortBy sortBy);

   public List getCreatorComments(Agent creator, CommentSortBy sortBy);

   /**
    * returns list of comments created by creator in given tool.
    * @param creator
    * @param toolId
    * @param sortBy
    * @return
    */
   public List getCreatorComments(Agent creator, String toolId, CommentSortBy sortBy);

   public PresentationTemplate copyTemplate(Id templateId);

   public String packageTemplateForExport(Id templateId, OutputStream os) throws IOException;

   public PresentationTemplate uploadTemplate(String templateFileName, String toContext, InputStream zipFileStream) throws IOException;

   public void storePresentationLog(PresentationLog log);

   public Collection findLogsByPresID(Id presID);
	
   public Presentation findPresentationByLogID(Id presID);

   public Collection getPresentationItems(Id artifactId);

   public Collection getPresentationsBasedOnTemplateFileRef(Id artifactId);

   public Collection findPresentationsByTool(Id id);
   
   public Node getNode(Id artifactId);

   public Node getNode(Reference ref);

   /**
    * Get node within the context of this presentation
    * @param ref
    * @param presentation
    * @return
    */
   public Node getNode(Reference ref, Presentation presentation);
   public Node getNode(Id artifactId, Presentation presentation);

   public Node getNode(Id artifactId, PresentationLayout layout);

   public Collection loadArtifactsForItemDef(PresentationItemDefinition itemDef, Agent agent);
   
   public Document createDocument(Presentation presentation);

   public Collection getAllPresentationsForWarehouse();

   public Collection getAllPresentationLayouts();

   public Collection getAllPresentationTemplates();

   public Presentation getPresentation(Id id, String secretExportKey);
   
   public boolean isGlobal();
   
}
