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
package org.theospi.portfolio.list.tool;

import org.theospi.portfolio.shared.model.SortableListObjectComparator;

/**
 * @author chrismaurer
 *
 */
public class DecoratedEntryComparator extends SortableListObjectComparator {

   /**
    * @param criteria
    * @param asc
    */
   public DecoratedEntryComparator(String criteria, int asc) {
      super(criteria, asc);
   }

   /* (non-Javadoc)
    * @see org.theospi.portfolio.shared.model.SortableListObjectComparator#compare(java.lang.Object, java.lang.Object)
    */
   public int compare(Object o1, Object o2) {
      return super.compare(((DecoratedEntry)o1).getEntry(), ((DecoratedEntry)o2).getEntry());
   }
   
   

}
