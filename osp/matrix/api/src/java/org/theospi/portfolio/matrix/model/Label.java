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
package org.theospi.portfolio.matrix.model;

import org.sakaiproject.metaobj.shared.model.Id;

/**
 * @author apple
 */
public interface Label {
   /**
    * @return Returns the id.
    */
   public Id getId();

   /**
    * @param id The id to set.
    */
   public void setId(Id id);

   /**
    * @return Returns the description.
    */
   public String getDescription();

   /**
    * @param description The description to set.
    */
   public void setDescription(String description);
   
   public String getTextColor();
   
   public String getColor();
   
   public void setTextColor(String textColor);
   
   public void setColor(String color);
}