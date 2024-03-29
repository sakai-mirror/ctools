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
package org.theospi.portfolio.workflow.mgt;

import java.util.Set;

import org.sakaiproject.entity.api.Reference;
import org.sakaiproject.metaobj.shared.model.Id;
import org.theospi.portfolio.shared.model.ObjectWithWorkflow;
import org.theospi.portfolio.workflow.model.Workflow;

public interface WorkflowManager {

   public final static String CURRENT_WORKFLOW = "org.theospi.portfolio.workflow.currentWorkflow";
   public final static String CURRENT_WORKFLOW_ID = "org.theospi.portfolio.workflow.currentWorkflowId";

   public Workflow createNew(String description, String siteId, Id securityQualifier,
                             String securityViewFunction, String securityEditFunction);

   public Workflow getWorkflow(Id workflowId);

   public Workflow saveWorkflow(Workflow workflow);

   public void deleteWorkflow(Workflow workflow);

   public Reference decorateReference(Workflow workflow, String reference);

   public Workflow getWorkflow(String id);
   
   public Set createEvalWorkflows(ObjectWithWorkflow obj);
   
}
