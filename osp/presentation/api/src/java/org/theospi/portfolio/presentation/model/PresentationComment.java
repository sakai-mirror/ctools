/**********************************************************************************
* $URL:https://source.sakaiproject.org/svn/osp/trunk/presentation/api/src/java/org/theospi/portfolio/presentation/model/PresentationComment.java $
* $Id:PresentationComment.java 9134 2006-05-08 20:28:42Z chmaurer@iupui.edu $
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

import java.util.Date;

import org.sakaiproject.metaobj.shared.model.Agent;
import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.metaobj.shared.model.IdentifiableObject;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Jun 1, 2004
 * Time: 6:21:55 AM
 * To change this template use File | Settings | File Templates.
 */
public class PresentationComment extends IdentifiableObject {

   public static final byte VISABILITY_UNKNOWN = 0;
   public static final byte VISABILITY_PRIVATE = 1;
   public static final byte VISABILITY_SHARED = 2;
   public static final byte VISABILITY_PUBLIC = 3;

   private Presentation presentation = new Presentation();
   private Agent creator = null;
   private Id id = null;
   private String title = null;
   private String comment = null;
   private Date created = null;
   private byte visibility = 0;

   public PresentationComment() {
   }


   public Presentation getPresentation() {
      return presentation;
   }

   public void setPresentation(Presentation presentation) {
      this.presentation = presentation;
   }

   public Agent getCreator() {
      return creator;
   }

   public void setCreator(Agent creator) {
      this.creator = creator;
   }

   public Id getId() {
      return id;
   }

   public void setId(Id id) {
      this.id = id;
   }

   public String getTitle() {
      return title;
   }

   public void setTitle(String title) {
      this.title = title;
   }

   public String getComment() {
      return comment;
   }

   public void setComment(String comment) {
      this.comment = comment;
   }

   public Date getCreated() {
      return created;
   }

   public void setCreated(Date created) {
      this.created = created;
   }

   public byte getVisibility() {
      return visibility;
   }

   public void setVisibility(byte visibility) {
      this.visibility = visibility;
   }

   public Id getPresentationId() {
      return presentation.getId();
   }

   public void setPresentationId(Id presentationId) {
      this.presentation.setId(presentationId);
   }

}
