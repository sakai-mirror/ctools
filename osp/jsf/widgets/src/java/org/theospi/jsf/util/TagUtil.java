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
package org.theospi.jsf.util;

import java.io.IOException;
import java.io.Writer;
import java.util.Iterator;

import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.context.ResponseWriter;
import javax.servlet.http.HttpServletRequest;

public class TagUtil {
	

   public static void renderChildren(FacesContext facesContext, UIComponent component)
           throws IOException
   {
       if (component.getChildCount() > 0)
       {
           for (Iterator it = component.getChildren().iterator(); it.hasNext(); )
           {
               UIComponent child = (UIComponent)it.next();
               renderChild(facesContext, child);
           }
       }
   }

   public static void renderChild(FacesContext facesContext, UIComponent child)
           throws IOException
   {
       if (!child.isRendered())
       {
           return;
       }

       child.encodeBegin(facesContext);
       if (child.getRendersChildren())
       {
           child.encodeChildren(facesContext);
       }
       else
       {
           renderChildren(facesContext, child);
       }
       child.encodeEnd(facesContext);
   }

}