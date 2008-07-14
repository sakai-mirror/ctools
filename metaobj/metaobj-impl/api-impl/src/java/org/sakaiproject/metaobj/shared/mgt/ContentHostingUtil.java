package org.sakaiproject.metaobj.shared.mgt;

import org.jdom.Element;
import org.sakaiproject.content.api.ContentResource;
import org.sakaiproject.time.api.Time;
import org.sakaiproject.entity.api.EntityPropertyNotDefinedException;
import org.sakaiproject.entity.api.EntityPropertyTypeException;

import java.util.Date;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Feb 10, 2007
 * Time: 11:36:29 AM
 * To change this template use File | Settings | File Templates.
 */
public class ContentHostingUtil {

   public static Element createRepoNode(ContentResource contentResource) {
      Element repositoryNode;
      repositoryNode = new Element("repositoryNode");

      Date created = getDate(contentResource,
            contentResource.getProperties().getNamePropCreationDate());
      if (created != null) {
         repositoryNode.addContent(createNode("created",
               created.toString()));
      }

      Date modified = getDate(contentResource,
            contentResource.getProperties().getNamePropModifiedDate());
      if (modified != null) {
         repositoryNode.addContent(createNode("modified",
               modified.toString()));
      }
      return repositoryNode;
   }

   public static Element createNode(String name, String value) {
      Element newNode = new Element(name);
      newNode.addContent(value);
      return newNode;
   }

   public static Date getDate(ContentResource resource, String propName) {
      try {
         Time time = resource.getProperties().getTimeProperty(propName);
         return new Date(time.getTime());
      }
      catch (EntityPropertyNotDefinedException e) {
         return null;
      }
      catch (EntityPropertyTypeException e) {
         throw new RuntimeException(e);
      }
   }


}
