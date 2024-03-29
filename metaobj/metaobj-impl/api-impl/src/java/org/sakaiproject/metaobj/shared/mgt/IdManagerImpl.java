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

package org.sakaiproject.metaobj.shared.mgt;

import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.metaobj.shared.model.IdImpl;
import org.sakaiproject.metaobj.utils.id.guid.Guid;

/**
 * @author rpembry
 */
public class IdManagerImpl implements IdManager {
   /* (non-Javadoc)
    * @see org.sakaiproject.metaobj.shared.IdManager#getInstance()
    */
   public IdManager getInstance() {
//TODO: retrieve Singleton from Spring?
      return new IdManagerImpl();
   }

   /* (non-Javadoc)
    * @see org.sakaiproject.metaobj.shared.IdManager#getId(java.lang.String)
    */
   public Id getId(String id) {
      //return new org.sakaiproject.metaobj.shared.model.IdImpl(id);
      return new IdImpl(id, null);
   }

   /* (non-Javadoc)
    * @see org.sakaiproject.metaobj.shared.IdManager#createId()
    */
   public Id createId() {
//TODO: delegate to OKI impl here
      return getId(new Guid().getString());
   }


}
