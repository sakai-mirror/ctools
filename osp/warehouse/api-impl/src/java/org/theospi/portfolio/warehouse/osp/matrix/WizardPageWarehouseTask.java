/**********************************************************************************
* $URL$
* $Id$
***********************************************************************************
*
* Copyright (c) 2006 The Sakai Foundation.
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

/**
 * 
 */
package org.theospi.portfolio.warehouse.osp.matrix;

import java.util.Collection;

import org.theospi.portfolio.matrix.MatrixManager;
import org.sakaiproject.warehouse.impl.BaseWarehouseTask;

/**
 * @author chrismaurer
 *
 */
public class WizardPageWarehouseTask extends BaseWarehouseTask {

   private MatrixManager matrixManager;
   
   protected Collection getItems() {
      Collection wizardPages = matrixManager.getWizardPagesForWarehousing();
      return wizardPages;
         
   }

   public MatrixManager getMatrixManager() {
      return matrixManager;
   }

   public void setMatrixManager(MatrixManager matrixManager) {
      this.matrixManager = matrixManager;
   }

}
