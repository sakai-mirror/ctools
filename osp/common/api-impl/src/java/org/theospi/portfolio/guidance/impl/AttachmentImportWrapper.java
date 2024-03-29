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
package org.theospi.portfolio.guidance.impl;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Feb 2, 2006
 * Time: 4:45:09 PM
 * To change this template use File | Settings | File Templates.
 */
public class AttachmentImportWrapper {

   private String oldRef;
   private String oldUrl;

   public AttachmentImportWrapper(String oldRef, String oldUrl) {
      this.oldRef = oldRef;
      this.oldUrl = oldUrl;
   }

   public String getOldRef() {
      return oldRef;
   }

   public void setOldRef(String oldRef) {
      this.oldRef = oldRef;
   }

   public String getOldUrl() {
      return oldUrl;
   }

   public void setOldUrl(String oldUrl) {
      this.oldUrl = oldUrl;
   }
}
