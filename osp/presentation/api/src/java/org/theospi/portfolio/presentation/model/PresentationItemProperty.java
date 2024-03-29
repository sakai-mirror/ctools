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
package org.theospi.portfolio.presentation.model;

import org.sakaiproject.metaobj.shared.model.Id;

public class PresentationItemProperty {
   
   public final static String RENDER_STYLE = "renderStyle";
   public final static String ITEM_HEIGHT = "itemHeight";
   public final static String ITEM_WIDTH = "itemWidth";
   public final static String LINK_TARGET = "linkTarget";
   public final static String CONTENT_TYPE = "contentType";
   
   private Id id;
   private PresentationPageItem item;
   private String key;
   private String value;
   
   public String getKey() {
      return key;
   }
   public void setKey(String key) {
      this.key = key;
   }
   public String getValue() {
      return value;
   }
   public void setValue(String value) {
      this.value = value;
   }
   public PresentationPageItem getItem() {
      return item;
   }
   public void setItem(PresentationPageItem item) {
      this.item = item;
   }
   public Id getId() {
      return id;
   }
   public void setId(Id id) {
      this.id = id;
   }
   
   

}
