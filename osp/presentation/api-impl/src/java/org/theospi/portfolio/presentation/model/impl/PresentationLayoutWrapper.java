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
package org.theospi.portfolio.presentation.model.impl;

import org.theospi.portfolio.presentation.model.PresentationLayout;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Jan 30, 2006
 * Time: 10:25:40 AM
 * To change this template use File | Settings | File Templates.
 */
public class PresentationLayoutWrapper extends PresentationLayout {

   private String idValue;
   private String layoutFileLocation;
   private String previewFileLocation;
   private String previewFileType;
   private String previewFileName;

   public String getLayoutFileLocation() {
      return layoutFileLocation;
   }

   public void setLayoutFileLocation(String layoutFileLocation) {
      this.layoutFileLocation = layoutFileLocation;
   }

   public String getPreviewFileLocation() {
      return previewFileLocation;
   }

   public void setPreviewFileLocation(String previewFileLocation) {
      this.previewFileLocation = previewFileLocation;
   }

   public String getIdValue() {
      return idValue;
   }

   public void setIdValue(String idValue) {
      this.idValue = idValue;
   }

   public String getPreviewFileType() {
      return previewFileType;
   }

   public void setPreviewFileType(String previewFileType) {
      this.previewFileType = previewFileType;
   }

   public String getPreviewFileName() {
      return previewFileName;
   }

   public void setPreviewFileName(String previewFileName) {
      this.previewFileName = previewFileName;
   }
}
