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
package org.theospi.portfolio.guidance.tool;

import org.theospi.portfolio.guidance.model.Guidance;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Nov 14, 2005
 * Time: 4:52:55 PM
 * To change this template use File | Settings | File Templates.
 */
public class DecoratedGuidance {
   private Guidance base;
   private GuidanceTool tool;

   public DecoratedGuidance(GuidanceTool tool, Guidance base) {
      this.base = base;
      this.tool = tool;
   }

   public Guidance getBase() {
      return base;
   }

   public void setBase(Guidance base) {
      this.base = base;
   }

   protected DecoratedGuidanceItem getItem(String type) {
      return new DecoratedGuidanceItem(tool, base.getItem(type));
   }

   public DecoratedGuidanceItem getInstruction() {
      return getItem(Guidance.INSTRUCTION_TYPE);
   }

   public DecoratedGuidanceItem getExample() {
      return getItem(Guidance.EXAMPLE_TYPE);
   }

   public DecoratedGuidanceItem getRationale() {
      return getItem(Guidance.RATIONALE_TYPE);
   }

   public String processActionEdit() {
      return tool.processActionEdit(base);
   }

   public String processActionEditInstruction() {
      return tool.processActionEditInstruction(base);
   }
   
   public String processActionEditExample() {
      return tool.processActionEditExample(base);
   }
   
   public String processActionEditRationale() {
      return tool.processActionEditRationale(base);
   }
   
   public String processActionView() {
      return tool.processActionView(base);
   }

   public String processActionDelete() {
      return tool.processActionDelete(base);
   }
}
