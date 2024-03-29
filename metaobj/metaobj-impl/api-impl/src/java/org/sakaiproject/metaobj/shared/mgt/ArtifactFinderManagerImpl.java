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

import java.util.Map;

import org.sakaiproject.metaobj.shared.ArtifactFinder;
import org.sakaiproject.metaobj.shared.ArtifactFinderManager;

public class ArtifactFinderManagerImpl implements ArtifactFinderManager {
   private Map finders = null;
   private ArtifactFinder artifactFinder;

   public ArtifactFinder getArtifactFinderByType(String key) {
      if (finders.get(key) != null) {
         return (ArtifactFinder) finders.get(key);
      }
      return getArtifactFinder();
   }

   public Map getFinders() {
      return finders;
   }

   public void setFinders(Map finders) {
      this.finders = finders;
   }

   public ArtifactFinder getArtifactFinder() {
      return artifactFinder;
   }

   public void setArtifactFinder(ArtifactFinder artifactFinder) {
      this.artifactFinder = artifactFinder;
   }
}
