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
package org.theospi.portfolio.help.model;



public class GlossaryEntry extends GlossaryBase {
   private String term;
   private String description;
   private String worksiteId;

   private GlossaryDescription longDescriptionObject = new GlossaryDescription();

   public GlossaryEntry(){}

   public GlossaryEntry(String term, String description){
      this.term = term;
      this.description = description;
   }

   public String getTerm() {
      return term;
   }

   public void setTerm(String term) {
      this.term = term.trim();
   }

   public String getDescription() {
      return description;
   }

   public void setDescription(String description) {
      this.description = description;
   }

   public String getWorksiteId() {
      return worksiteId;
   }

   public void setWorksiteId(String worksiteId) {
      this.worksiteId = worksiteId;
   }

   public String getLongDescription() {
      return longDescriptionObject.getLongDescription();
   }

   public void setLongDescriptionObject(GlossaryDescription longDescriptionObject) {
      this.longDescriptionObject = longDescriptionObject;
   }

   public GlossaryDescription getLongDescriptionObject() {
      return longDescriptionObject;
   }

   public void setLongDescription(String longDescription) {
      this.longDescriptionObject.setLongDescription(longDescription);
   }

   /**
    * Returns a string representation of the object. In general, the
    * <code>toString</code> method returns a string that
    * "textually represents" this object. The result should
    * be a concise but informative representation that is easy for a
    * person to read.
    * It is recommended that all subclasses override this method.
    * <p/>
    * The <code>toString</code> method for class <code>Object</code>
    * returns a string consisting of the name of the class of which the
    * object is an instance, the at-sign character `<code>@</code>', and
    * the unsigned hexadecimal representation of the hash code of the
    * object. In other words, this method returns a string equal to the
    * value of:
    * <blockquote>
    * <pre>
    * getClass().getName() + '@' + Integer.toHexString(hashCode())
    * </pre></blockquote>
    *
    * @return a string representation of the object.
    */
   public String toString() {
      return getTerm();
   }
   
}
