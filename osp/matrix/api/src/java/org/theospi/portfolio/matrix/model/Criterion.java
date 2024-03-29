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

/**
 * @author rpembry
 */
public class Criterion extends AbstractLabel implements Label {
   
   public Criterion() {}
   
   public Criterion(CriterionTransport criterion) {
      this.id = criterion.getId();
      this.description = criterion.getDescription();
      this.color = criterion.getColor();
      this.textColor = criterion.getTextColor();
   }
   
   public Criterion copy(CriterionTransport criterion) {
      this.id = criterion.getId();
      this.description = criterion.getDescription();
      this.color = criterion.getColor();
      this.textColor = criterion.getTextColor();
      return this;
   }

   /* (non-Javadoc)
    * @see java.lang.Object#equals(java.lang.Object)
    */
   public boolean equals(Object other) {
      if (other == this) return true;
      if (other == null || !(other instanceof Criterion)) return false;
      Criterion otherCriterion = (Criterion) other;
      return otherCriterion.getDescription().equals(this.getDescription());
   }

   /* (non-Javadoc)
    * @see java.lang.Object#hashCode()
    */
   public int hashCode() {
      String hashString = this.getDescription();
      return hashString.hashCode();
   }
}
