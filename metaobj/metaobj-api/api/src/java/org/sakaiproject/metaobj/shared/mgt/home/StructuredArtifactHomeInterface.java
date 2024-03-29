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

package org.sakaiproject.metaobj.shared.mgt.home;

import java.util.Date;

import org.sakaiproject.metaobj.shared.mgt.CloneableObjectHome;
import org.sakaiproject.metaobj.shared.mgt.PresentableObjectHome;
import org.sakaiproject.metaobj.shared.mgt.WritableObjectHome;
import org.sakaiproject.metaobj.shared.model.Type;
import org.sakaiproject.metaobj.shared.model.StructuredArtifact;
import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.metaobj.utils.xml.SchemaNode;
import org.sakaiproject.content.api.ContentResource;

/**
 * marker for structured artifact home
 */
public interface StructuredArtifactHomeInterface extends WritableObjectHome, CloneableObjectHome, PresentableObjectHome {

   public String getSiteId();

   public SchemaNode getRootSchema();

   public Type getType();

   public String getInstruction();

   public Date getModified();

   public String getRootNode();

   public SchemaNode getSchema();

   public StructuredArtifact load(ContentResource resource);
   
   public StructuredArtifact load(ContentResource resource, Id artifactId);

   public String getTypeId();

   public byte[] getBytes(StructuredArtifact artifact);
   
}
