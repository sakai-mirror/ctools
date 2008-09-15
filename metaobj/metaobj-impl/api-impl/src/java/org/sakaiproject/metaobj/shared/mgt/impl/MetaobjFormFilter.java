package org.sakaiproject.metaobj.shared.mgt.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.content.api.ContentResource;
import org.sakaiproject.content.api.ContentResourceFilter;
import org.sakaiproject.content.api.ResourceToolAction;
import org.sakaiproject.entity.api.ResourceProperties;

public class MetaobjFormFilter implements ContentResourceFilter {
	private String targetType = null;
	private Set<String> collectionIds = null;
	
	private static Log log = LogFactory.getLog(MetaobjFormFilter.class);

	public MetaobjFormFilter() {
		// Nothing
	}

	public MetaobjFormFilter(String targetType) {
		this.targetType = targetType;
	}

	public MetaobjFormFilter(Set<String> collectionIds) {
		this.collectionIds = collectionIds;
	}

	public MetaobjFormFilter(String targetType, Set<String> collectionIds) {
		this.targetType = targetType;
		this.collectionIds = collectionIds;
	}

	public String getTargetType() {
		return this.targetType;
	}

	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}

	public Set<String> getCollectionIds() {
		return collectionIds;
	}

	public void setCollectionIds(Set<String> collectionIds) {
		this.collectionIds = collectionIds;
	}

	public boolean allowSelect(ContentResource contentResource) {
		return false;
	}

	public boolean allowView(ContentResource contentResource) {
		if (contentResource == null)
			return false;

		String actualType = contentResource.getProperties().getProperty(ResourceProperties.PROP_STRUCTOBJ_TYPE);
		if (actualType == null)
			log.warn("Unexpected null form type on resource: " + contentResource.getReference());

		boolean passesType = (targetType == null || targetType.equals(actualType));
		boolean passesCollection = (collectionIds == null);

		if (passesType && !passesCollection) {
			for (String collId : collectionIds) {
				if (contentResource.getId().startsWith(collId)) {
					passesCollection = true;
					break;
				}
			}
		}

		return (passesType && passesCollection);
	}

	public List<ResourceToolAction> filterAllowedActions(List<ResourceToolAction> actions) {
		return new ArrayList<ResourceToolAction>();
	}
}
