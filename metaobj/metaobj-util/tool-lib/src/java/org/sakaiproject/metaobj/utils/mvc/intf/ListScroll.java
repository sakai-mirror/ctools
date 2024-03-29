/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
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

package org.sakaiproject.metaobj.utils.mvc.intf;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class ListScroll {
   protected final transient Log logger = LogFactory.getLog(getClass());

   public static final String STARTING_INDEX_TAG = "listScroll_startingIndex";
   public static final String ENSURE_VISIBLE_TAG = "listScroll_ensureVisibleIndex";

   private int total;
   private int perPage;
   private int startingIndex;

   public ListScroll(int perPage, int total, int startingIndex) {
      this.perPage = perPage;
      this.total = total;
      this.startingIndex = startingIndex;
   }

   public int getNextIndex() {
      int nextIndex = startingIndex + perPage;

      if (nextIndex >= total) {
         return -1;
      }

      return nextIndex;
   }

   public int getPerPage() {
      return perPage;
   }

   public void setPerPage(int perPage) {
      this.perPage = perPage;
   }

   public int getPrevIndex() {
      int prevIndex = startingIndex - perPage;

      if (prevIndex < 0) {
         return -1;
      }

      return prevIndex;
   }

   public int getStartingIndex() {
      return startingIndex;
   }

   public void setStartingIndex(int startingIndex) {
      this.startingIndex = startingIndex;
   }

   public int getTotal() {
      return total;
   }

   public void setTotal(int total) {
      this.total = total;
   }

   public int getFirstItem() {
      if (total == 0) {
         return 0;
      }
      return startingIndex + 1;
   }

   public int getLastItem() {
      int lastItem = startingIndex + perPage;

      if (lastItem > total) {
         return total;
      }
      return lastItem;
   }
}
