/**********************************************************************************
* $URL$
* $Id$
***********************************************************************************
*
* Copyright (c) 2005, 2006 The Sakai Foundation.
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
package org.theospi.portfolio.wizard;

import java.util.Iterator;
import java.util.List;

import org.sakaiproject.metaobj.shared.mgt.IdManager;
import org.sakaiproject.metaobj.shared.model.Agent;
import org.sakaiproject.metaobj.shared.model.Id;
import org.theospi.portfolio.security.AuthorizationFacade;
import org.theospi.portfolio.security.app.ApplicationAuthorizer;
import org.theospi.portfolio.wizard.mgt.WizardManager;
import org.theospi.portfolio.wizard.model.CompletedWizardPage;
import org.theospi.portfolio.wizard.model.Wizard;
import org.theospi.portfolio.wizard.model.WizardPageSequence;
/**
 * These are the permissions and their definitions:
 * 
 * View:       Can a user complete a wizard (is the wizard owner or 
 *                can complete the wizard or the tool permits the user to complete)
 * Review:     can the user review the wizard definition (check the tool for review)
 * Evaluate:   can the user exaluate the wizard definition (check the tool for evaluate)
 * Operate:    does the user have view or review or evaluate
 * Create:     Can a user create a wizard (permitted by the tool)
 * Edit:       can the user change the wizard definition (check the tool for edit)
 * Publish:    can the user publish the wizard definition (check the tool for publish)
 * Delete:     can the user delete the wizard definition (check the tool for delete)
 *                The delete only works on unpublished wizards
 * Copy:       can the user copy the wizard definition (check the tool for copy)
 * Delete:     can the user delete the wizard definition (check the tool for delete)
 * Edit Wizard Page Guidance:  the owner of the wizard can edit guidance of a wizard page
 * View Wizard Page Guidance:  loop through each completed wizard page and:
 *                   does the completed page have evaluate or review or is the owner
 *                   or the page def has view permission
 *                or is the page sequence owned by the current user
 */
public class WizardAuthorizerImpl implements ApplicationAuthorizer{
   private WizardManager wizardManager;
   private IdManager idManager;
   private List functions;
                    
   /**
    * This method will ask the application specific functional authorizer to determine authorization.
    *
    * @param facade   this can be used to do explicit auths if necessary
    * @param agent
    * @param function
    * @param id
    * @return null if the authorizer has no opinion, true if authorized, false if explicitly not authorized.
    */
   public Boolean isAuthorized(AuthorizationFacade facade, Agent agent,
                               String function, Id id) {

      // return null if we don't know what is up...
      if (function.equals(WizardFunctionConstants.OPERATE_WIZARD)) {
         Boolean access = isWizardViewAuth(facade, agent, id, true);
         if(access == null || access.booleanValue() == false) {
            access = isWizardAuthForReview(facade, agent, id);
            if(access == null || access.booleanValue() == false) {
               access = isWizardAuthForEval(facade, agent, id);
            }
         }
         return access;
      } else if (function.equals(WizardFunctionConstants.VIEW_WIZARD)) {
            return isWizardViewAuth(facade, agent, id, true);
            
      } else if (function.equals(WizardFunctionConstants.CREATE_WIZARD)) {
         return new Boolean(facade.isAuthorized(agent,function,id));
         
      } else if (function.equals(WizardFunctionConstants.EDIT_WIZARD)) {
         return isWizardAuth(facade, id, agent, WizardFunctionConstants.EDIT_WIZARD);
         
      } else if (function.equals(WizardFunctionConstants.PUBLISH_WIZARD)) {
         String siteStr = getWizardManager().getWizardIdSiteId(id);
         Id siteId = getIdManager().getId(siteStr);
         return new Boolean(facade.isAuthorized(agent,function,siteId));
         
      } else if (function.equals(WizardFunctionConstants.DELETE_WIZARD)) {
         return isWizardAuth(facade, id, agent, WizardFunctionConstants.DELETE_WIZARD);
         
      } else if (function.equals(WizardFunctionConstants.COPY_WIZARD)) {
         return isWizardAuth(facade, id, agent, WizardFunctionConstants.COPY_WIZARD);
         
      } else if (function.equals(WizardFunctionConstants.EXPORT_WIZARD)) {
         return isWizardAuth(facade, id, agent, WizardFunctionConstants.EXPORT_WIZARD);
         
      } else if (WizardFunctionConstants.REVIEW_WIZARD.equals(function)) {
         return isWizardAuthForReview(facade, agent, id);
         
      } else if (WizardFunctionConstants.EVALUATE_WIZARD.equals(function)) {
         return isWizardAuthForEval(facade, agent, id);
      } 
      else if (function.equals(WizardFunctionConstants.EDIT_WIZARDPAGE_GUIDANCE)) {
         //ScaffoldingCell sCell = getMatrixManager().getScaffoldingCellByWizardPageDef(id);
         WizardPageSequence wps = wizardManager.getWizardPageSeqByDef(id);
         Wizard wizard = wps.getCategory().getWizard();
         Agent owner = wizard.getOwner();
         
         
         Boolean returned = new Boolean(agent.equals(owner));
         
         if (returned == null || !returned.booleanValue()) {
            returned = Boolean.valueOf(facade.isAuthorized(agent, 
                  WizardFunctionConstants.EDIT_WIZARD, 
                  getIdManager().getId(wizard.getSiteId())));
         }
         
         return returned;
         
      } else if (function.equals(WizardFunctionConstants.VIEW_WIZARDPAGE_GUIDANCE)) {
         //If I can eval, review, or own it
         List pages = wizardManager.getCompletedWizardPagesByPageDef(id);
         Boolean returned = null;

         for (Iterator iter=pages.iterator(); iter.hasNext();) {
            CompletedWizardPage cwp = (CompletedWizardPage)iter.next();
            // why are we trying to get a wizard permission on a completed wizard page id?
            // returned = Boolean.valueOf(facade.isAuthorized(agent, WizardFunctionConstants.EVALUATE_WIZARD, cwp.getId()));
            returned = isWizardAuthForEval(facade, agent, cwp.getCategory().getWizard().getWizard().getId());
            
            if (returned == null || !returned.booleanValue()) {
               // again, why review wizard permission on the completed wizard page id
               //returned = Boolean.valueOf(facade.isAuthorized(agent, WizardFunctionConstants.REVIEW_WIZARD, cwp.getId()));
               returned = isWizardAuthForReview(facade, agent, cwp.getCategory().getWizard().getWizard().getId());
            }
            if (returned == null || !returned.booleanValue()) {
               // if the user is the owner of the completed wizard
               returned = Boolean.valueOf(cwp.getCategory().getWizard().getOwner().equals(agent));
            }
            if (returned == null || !returned.booleanValue()) {
               // Again, with the cwp instead of the wizard
               //returned = Boolean.valueOf(facade.isAuthorized(agent, WizardFunctionConstants.VIEW_WIZARD,id));
               returned = isWizardViewAuth(facade, agent, cwp.getCategory().getWizard().getWizard().getId(), true);
            }
            if (returned == null || !returned.booleanValue()) {
               // if the user is the owner of the actual wizard
               returned = Boolean.valueOf(cwp.getCategory().getWizard().getWizard().getOwner().equals(agent));
            }
            if (returned.booleanValue())
               return returned;
         }
        
         WizardPageSequence wps = getWizardManager().getWizardPageSeqByDef(id);
         
         returned = Boolean.valueOf(wps.getCategory().getWizard().getOwner().equals(agent));
         if (returned.booleanValue())
            return returned;
         
         return null;
      } 
      else if (function.equals(WizardFunctionConstants.EVALUATE_SPECIFIC_WIZARD)) {
         Wizard wizard = wizardManager.getWizard(id);
         Id siteId = idManager.getId(wizard.getSiteId());
         facade.pushAuthzGroups(siteId.getValue());
         return isWizardAuthForEval(facade, agent, siteId);
      }
      else if (function.equals(WizardFunctionConstants.EVALUATE_SPECIFIC_WIZARDPAGE)) {
         Wizard wizard = wizardManager.getCompletedWizardByPage(id).getWizard();
         Id siteId = idManager.getId(wizard.getSiteId());
         facade.pushAuthzGroups(siteId.getValue());
         return isWizardAuthForEval(facade, agent, siteId);
      }
      
      else {
         return null;
      }
   }
   
   /**
    * This method checks for permission "function" of wizard "qualifier" with the given Agent.
    * @param facade AuthorizationFacade
    * @param qualifier Id -- for this function it's the wizard id
    * @param agent Agent
    * @param function String
    * @return Boolean
    */
   protected Boolean isWizardAuth(AuthorizationFacade facade, Id qualifier, Agent agent, String function) {
      
      String siteStr = getWizardManager().getWizardIdSiteId(qualifier);
      
      if (siteStr == null) {
         // must be tool id
         return new Boolean(facade.isAuthorized(function,qualifier));
      }
      
      //owner can do anything
      /*
      if (wizard.getOwner().equals(agent)){
         return new Boolean(true);
      }
      */
      Id siteId = getIdManager().getId(siteStr);
      return new Boolean(facade.isAuthorized(function,siteId));
   }

   /**
    * THis handles the authority for the view permission on a wizard
    * @param facade
    * @param agent
    * @param id -- for this function it's the wizard id
    * @param allowAnonymous
    * @return
    */
   protected Boolean isWizardViewAuth(AuthorizationFacade facade, Agent agent, Id id, boolean allowAnonymous) {
      
      String siteStr = getWizardManager().getWizardIdSiteId(id);
      
      if (siteStr == null) {
         return new Boolean(facade.isAuthorized(agent, 
               WizardFunctionConstants.VIEW_WIZARD, id));
      }

      return isWizardViewAuth(id, facade, agent, id, allowAnonymous);
   }

   /**
    * Checks an agents ability to view the given wizard.  It also check the wizard's
    * tool for permission to access the wizard as view is a tool wide permission.  
    * Anonymous is not recognized in this function yet
    * @param wizardId      Id of the wizard we are checkingWizard
    * @param facade        AuthorizationFacade
    * @param agent         Agent
    * @param id            Id
    * @param allowAnonymous boolean
    * @return Boolean
    */
   protected Boolean isWizardViewAuth(Id wizardId, AuthorizationFacade facade,
                                            Agent agent, Id id, boolean allowAnonymous) {
      boolean isAuthorized = false;
      Agent owner = getWizardManager().getWizardIdOwner(wizardId);
      
      if (owner != null && owner.equals(agent)) {
         isAuthorized = true;
      } else {
         isAuthorized = facade.isAuthorized(agent, WizardFunctionConstants.VIEW_WIZARD, id);
         
         if(!isAuthorized) {
            String siteStr = getWizardManager().getWizardIdSiteId(id);
            Id siteId = getIdManager().getId(siteStr);
            isAuthorized = facade.isAuthorized(WizardFunctionConstants.VIEW_WIZARD, siteId);
            
         }
      }
      return new Boolean(isAuthorized);
   }

   protected Boolean isWizardAuthForReview(AuthorizationFacade facade, Agent agent, Id id) {
      String siteStr = getWizardManager().getWizardIdSiteId(id);
      Id tmpId = id;
      if (siteStr != null) {
         tmpId = getIdManager().getId(siteStr);
      }
      
      return new Boolean(facade.isAuthorized(agent, WizardFunctionConstants.REVIEW_WIZARD, tmpId));
   }
   
   protected Boolean isWizardAuthForEval(AuthorizationFacade facade, Agent agent, Id id) {
      return new Boolean(facade.isAuthorized(agent, WizardFunctionConstants.EVALUATE_WIZARD, id));
   }

   public WizardManager getWizardManager() {
      return wizardManager;
   }

   public void setWizardManager(WizardManager wizardManager) {
      this.wizardManager = wizardManager;
   }

   public IdManager getIdManager() {
      return idManager;
   }

   public void setIdManager(IdManager idManager) {
      this.idManager = idManager;
   }

   public List getFunctions() {
      return functions;
   }

   public void setFunctions(List functions) {
      this.functions = functions;
   }
}
