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
package org.theospi.portfolio.matrix;

import org.theospi.portfolio.matrix.model.Scaffolding;

public class DefaultScaffoldingBean {
   private String columnLabel;
   private String rowLabel;
   
   public String getColumnLabel() {
      return columnLabel;
   }
   public void setColumnLabel(String columnLabel) {
      this.columnLabel = columnLabel;
   }
   public String getRowLabel() {
      return rowLabel;
   }
   public void setRowLabel(String rowLabel) {
      this.rowLabel = rowLabel;
   }
   
   public Scaffolding createDefaultScaffolding() {
      return new Scaffolding(columnLabel, rowLabel);
   }
}
