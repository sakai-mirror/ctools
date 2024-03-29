/**********************************************************************************
* $URL:https://source.sakaiproject.org/svn/osp/trunk/jsf/widgets/src/java/org/theospi/jsf/renderer/TestComponentRenderer.java $
* $Id:TestComponentRenderer.java 9134 2006-05-08 20:28:42Z chmaurer@iupui.edu $
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
package org.theospi.jsf.renderer;

import java.io.IOException;

import javax.faces.component.UIColumn;
import javax.faces.component.UIComponent;
import javax.faces.component.UIData;
import javax.faces.component.UIViewRoot;
import javax.faces.component.html.HtmlCommandButton;
import javax.faces.component.html.HtmlInputText;
import javax.faces.component.html.HtmlOutputLink;
import javax.faces.component.html.HtmlOutputText;
import javax.faces.context.FacesContext;
import javax.faces.context.ResponseWriter;
import javax.faces.el.ValueBinding;
import javax.faces.event.ActionEvent;
import javax.faces.render.Renderer;

import org.theospi.jsf.component.TestComponent;
import org.theospi.jsf.util.TagUtil;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Dec 28, 2005
 * Time: 11:51:38 AM
 * To change this template use File | Settings | File Templates.
 */
public class TestComponentRenderer extends Renderer {

   public void decode(FacesContext context, UIComponent component) {
      super.decode(context, component);
   }

   public void encodeBegin(FacesContext context, UIComponent component) throws IOException {
      super.encodeBegin(context, component);
      ResponseWriter writer = context.getResponseWriter();
      writer.write("<b>JDE Test</b>");
   }

   public boolean getRendersChildren() {
      return true;
   }

   public void encodeChildren(FacesContext context, UIComponent component) throws IOException {
      super.encodeChildren(context, component);
      TestComponent testComponent = (TestComponent) component;
      UIComponent layoutRoot = testComponent.getLayoutRoot();
      if (layoutRoot == null) {
         UIViewRoot root = context.getViewRoot();
         UIData container = new UIData();
         ValueBinding vb = context.getApplication().createValueBinding("#{testBean.subBeans}");
         container.setValueBinding("value", vb);
         container.setVar("testSubBean");
         container.setId(root.createUniqueId());
         UIColumn column = new UIColumn();
         column.setId(root.createUniqueId());
         container.getChildren().add(column);
         root.getChildren().add(container);
         HtmlOutputLink testLink = new HtmlOutputLink();
         testLink.setValue("http://www.javasoft.com");
         HtmlOutputText text = new HtmlOutputText();
         text.setValue("test");
         testLink.getChildren().add(text);
         HtmlCommandButton button = new HtmlCommandButton();
         button.setId(root.createUniqueId());
         button.setActionListener(
               context.getApplication().createMethodBinding("#{testSubBean.processTestButton}",
                     new Class[]{ActionEvent.class}));
         button.setValue("test me");
         HtmlInputText input = new HtmlInputText();
         input.setValueBinding("value", context.getApplication().createValueBinding("#{testSubBean.index}"));
         input.setId(root.createUniqueId());
         column.getChildren().add(input);
         column.getChildren().add(button);
         HtmlOutputText testVerbatim = new HtmlOutputText();
         testVerbatim.setEscape(false);
         testVerbatim.setValue("<some>");
         column.getChildren().add(testVerbatim);
         column.getChildren().add(testLink);
         HtmlOutputText testVerbatim2 = new HtmlOutputText();
         testVerbatim2.setEscape(false);
         testVerbatim2.setValue("</some>");
         column.getChildren().add(testVerbatim2);
         TagUtil.renderChild(context, container);
         testComponent.setLayoutRoot(container);
      }
      else {
         TagUtil.renderChild(context, layoutRoot);
      }
   }

   public void encodeEnd(FacesContext context, UIComponent component) throws IOException {
      ResponseWriter writer = context.getResponseWriter();

      writer.write("<b>End JDE Test</b>");
      super.encodeEnd(context, component);
   }

}
