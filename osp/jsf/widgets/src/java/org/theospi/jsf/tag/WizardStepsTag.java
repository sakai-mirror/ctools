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
package org.theospi.jsf.tag;

import javax.faces.component.UIComponent;
import javax.faces.webapp.UIComponentTag;

import org.sakaiproject.jsf.util.TagUtil;


public class WizardStepsTag extends UIComponentTag
{
   private String currentStep = null;

	public String getComponentType()
	{
		return "org.theospi.WizardSteps";
	}

	public String getRendererType()
	{
		return "org.theospi.WizardSteps";
	}
   
   protected void setProperties(UIComponent component)
   {
      super.setProperties(component);
      TagUtil.setString(component, "currentStep", currentStep);
   }

   public String getCurrentStep() {
      return currentStep;
   }

   public void setCurrentStep(String currentStep) {
      this.currentStep = currentStep;
   }
   
   
}



