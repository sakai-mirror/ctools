/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2007 The Sakai Foundation.
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

package org.theospi.portfolio.matrix.taggable.tool;

import java.util.ArrayList;
import java.util.List;

import org.sakaiproject.assignment.taggable.api.Tag;
import org.sakaiproject.assignment.taggable.api.TagColumn;
import org.sakaiproject.assignment.taggable.api.TagList;
import org.sakaiproject.assignment.taggable.api.TaggableActivity;
import org.sakaiproject.assignment.taggable.api.TaggingProvider;

/**
 * Wrapper around {@link TaggingProvider} for displaying a pageable/sortable
 * list of tags for an activity or item. Since there may be multiple providers
 * each with a list of tags displayed on a single page, this class enables each
 * provider to maintain the page/sort state of its list separate from others.
 * 
 * @author The Sakai Foundation.
 */
public class DecoratedTaggingProvider {

	private Sort sort;

	private Pager pager;

	private TaggableActivity activity;

	private TaggingProvider provider;

	private TagList tagList;

	protected final static int[] PAGESIZES = { 5, 10, 20, 50, 100, 200 };

	public DecoratedTaggingProvider(TaggableActivity activity,
			TaggingProvider provider) {
		this.activity = activity;
		this.provider = provider;
		sort = new Sort("", true);
		tagList = provider.getTags(activity);
		pager = new Pager(tagList.size(), 0, 20);
	}

	public Sort getSort() {
		return sort;
	}

	public Pager getPager() {
		return pager;
	}

	public boolean getAllowViewTags() {
		return provider.allowViewTags(activity.getContext());
	}

	public TaggingProvider getProvider() {
		return provider;
	}

	public List<Tag> getTags() {
		List<Tag> tags = new ArrayList<Tag>();
		if (tagList != null) {
			tagList.sort(tagList.getColumn(sort.getSort()), sort.isAscending());
			tags = tagList.subList(pager.getFirstItem(), pager
					.getLastItemNumber());
		}
		return tags;
	}

	public List<TagColumn> getColumns() {
		return provider.getTags(activity).getColumns();
	}

	public class Sort {

		protected String sortString = "";

		protected boolean ascending = true;

		public Sort(String sort, boolean ascending) {
			sortString = sort;
			this.ascending = ascending;
		}

		public boolean isAscending() {
			return ascending;
		}

		public void setAscending(boolean ascending) {
			this.ascending = ascending;
		}

		public String getSort() {
			return sortString;
		}

		public void setSort(String sort) {
			sortString = sort;
		}
	}

	public class Pager {

		protected int totalItems;

		protected int firstItem;

		protected int pageSize;

		public static final String FIRST = "|<", PREVIOUS = "<", NEXT = ">",
				LAST = ">|";

		public Pager(int totalItems, int firstItem, int pageSize) {
			this.totalItems = totalItems;
			this.firstItem = firstItem;
			this.pageSize = pageSize;
		}

		public int getFirstItemNumber() {
			return firstItem + 1;
		}

		public int getLastItemNumber() {
			int n = firstItem + pageSize;
			return (totalItems < n ? totalItems : n);
		}

		public boolean getCanFirst() {
			return firstItem > 0;
		}

		public boolean getCanPrevious() {
			return getCanFirst();
		}

		public boolean getCanNext() {
			return getLastItemNumber() < totalItems;
		}

		public boolean getCanLast() {
			return getCanNext();
		}

		public int[] getPageSizes() {
			return PAGESIZES;
		}

		public int getFirstItem() {
			return firstItem;
		}

		public void setFirstItem(int firstItem) {
			this.firstItem = firstItem;
		}

		public int getPageSize() {
			return pageSize;
		}

		public void setPageSize(int pageSize) {
			this.pageSize = pageSize;
		}

		public int getTotalItems() {
			return totalItems;
		}

		public void setTotalItems(int totalItems) {
			this.totalItems = totalItems;
		}
	}
}
