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
package example.xml;

import org.theospi.jsf.impl.DefaultXmlTagFactory;
import org.theospi.jsf.intf.XmlTagHandler;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Dec 30, 2005
 * Time: 1:15:39 PM
 * To change this template use File | Settings | File Templates.
 */
public class TestXmlTagFactory extends DefaultXmlTagFactory {

   private final static String OSP_NS_URI = "http://www.osportfolio.org/OspML";
   private XmlTagHandler regionTagHandler = new RegionTagHandler(this);
   private XmlTagHandler sequenceTagHandler = new SequenceTagHandler(this);

   public XmlTagHandler getHandler(String uri, String localName, String qName) {
      if (OSP_NS_URI.equals(uri)) {
         if ("region".equals(localName)) {
            return regionTagHandler;
         }
         else if ("sequence".equals(localName)) {
            return sequenceTagHandler;
         }
      }
      return super.getHandler(uri, localName, qName);
   }
}
