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

package org.sakaiproject.metaobj.shared.model;

import org.sakaiproject.metaobj.shared.mgt.ReadableObjectHome;

/**
 * This interface represents anything in OSP that can be put
 * into the matrix or into a presentation.  The Object's home
 * represents the object "type" or the object's definition.
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Apr 8, 2004
 * Time: 4:55:28 PM
 * To change this template use File | Settings | File Templates.
 */
public interface Artifact {

   public Agent getOwner();

   public Id getId();

   public ReadableObjectHome getHome();

   public void setHome(ReadableObjectHome home);

   public String getDisplayName();
}
