/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2003, 2004, 2005, 2006 The Sakai Foundation.
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

package org.sakaiproject.site.tool;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Vector;

import org.sakaiproject.cheftool.Context;
import org.sakaiproject.cheftool.JetspeedRunData;
import org.sakaiproject.cheftool.PagedResourceActionII;
import org.sakaiproject.cheftool.RunData;
import org.sakaiproject.cheftool.VelocityPortlet;
import org.sakaiproject.component.cover.ServerConfigurationService;
import org.sakaiproject.event.api.SessionState;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.exception.InUseException;
import org.sakaiproject.exception.PermissionException;
import org.sakaiproject.javax.PagingPosition;
import org.sakaiproject.site.cover.SiteService;
import org.sakaiproject.util.ResourceLoader;

/**
 * <p>
 * MembershipAction is a tool which displays Sites and lets the user join and un-join joinable Sites.
 * </p>
 */
public class MembershipAction extends PagedResourceActionII
{
	private static String STATE_VIEW_MODE = "state_view";

	private static ResourceLoader rb = new ResourceLoader("membership");

	private static String SORT_ASC = "sort_asc";

	private static String JOINABLE_SORT_ASC = "sort_asc";

	private static String STATE_CONFIRM_VIEW_MODE = "state_confirm_view";

	private static String UNJOIN_SITE = "unjoin_site";

	private static String SEARCH_TERM = "search";

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.cheftool.PagedResourceActionII#sizeResources(org.sakaiproject.service.framework.session.SessionState)
	 */
	protected int sizeResources(SessionState state)
	{
		int size = 0;

		String search = (String) state.getAttribute(SEARCH_TERM);
		if ((search != null) && search.trim().equals(""))
		{
			search = null;
		}

		List openSites = SiteService.getSites(org.sakaiproject.site.api.SiteService.SelectionType.JOINABLE,
		// null, null, null, org.sakaiproject.service.legacy.site.SiteService.SortType.TITLE_ASC, null);
				null, search, null, org.sakaiproject.site.api.SiteService.SortType.TITLE_ASC, null);
		size = openSites.size();

		return size;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.sakaiproject.cheftool.PagedResourceActionII#readResourcesPage(org.sakaiproject.service.framework.session.SessionState, int, int)
	 */
	protected List readResourcesPage(SessionState state, int first, int last)
	{
		List rv = new Vector();

		String search = (String) state.getAttribute(SEARCH_TERM);
		if ((search != null) && search.trim().equals(""))
		{
			search = null;
		}

		if (((Boolean) state.getAttribute(SORT_ASC)).booleanValue())
		{
			rv = SiteService.getSites(org.sakaiproject.site.api.SiteService.SelectionType.JOINABLE,
			// null, null, null, org.sakaiproject.service.legacy.site.SiteService.SortType.TITLE_ASC, null);
					null, search, null, org.sakaiproject.site.api.SiteService.SortType.TITLE_ASC, null);
		}
		else
		{
			rv = SiteService.getSites(org.sakaiproject.site.api.SiteService.SelectionType.JOINABLE,
			// null, null, null, org.sakaiproject.service.legacy.site.SiteService.SortType.TITLE_DESC, null);
					null, search, null, org.sakaiproject.site.api.SiteService.SortType.TITLE_DESC, null);
		}

		PagingPosition page = new PagingPosition(first, last);
		page.validate(rv.size());
		rv = rv.subList(page.getFirst() - 1, page.getLast());

		return rv;
	}

	/** the above : paging * */

	/**
	 * build the context
	 */
	public String buildMainPanelContext(VelocityPortlet portlet, Context context, RunData rundata, SessionState state)
	{
		// buildMenu(portlet, context, rundata, state);

		String template = (String) getContext(rundata).get("template");

		// read the group ids to join
		if (state.getAttribute(SORT_ASC) == null)
		{
			state.setAttribute(SORT_ASC, Boolean.TRUE);
		}
		Boolean sortAsc = (Boolean) state.getAttribute(SORT_ASC);
		context.put("currentSortAsc", sortAsc);

		if (state.getAttribute(SEARCH_TERM) == null)
		{
			state.setAttribute(SEARCH_TERM, "");
		}
		context.put(SEARCH_TERM, state.getAttribute(SEARCH_TERM));

		boolean defaultMode = state.getAttribute(STATE_VIEW_MODE) == null;
		if (defaultMode)
		{
			// process all the sites the user has access to so can unjoin
			List unjoinableSites = new Vector();
			if (sortAsc.booleanValue())
			{
				unjoinableSites = SiteService.getSites(org.sakaiproject.site.api.SiteService.SelectionType.ACCESS, null, null,
						null, org.sakaiproject.site.api.SiteService.SortType.TITLE_ASC, null);
			}
			else
			{
				unjoinableSites = SiteService.getSites(org.sakaiproject.site.api.SiteService.SelectionType.ACCESS, null, null,
						null, org.sakaiproject.site.api.SiteService.SortType.TITLE_DESC, null);
			}
			context.put("unjoinableSites", unjoinableSites);

			context.put("SiteService", SiteService.getInstance());

			// if property set in sakai.properties then completely disable 'unjoin' link
			if (ServerConfigurationService.getBoolean("disable.membership.unjoin.selection", false))
			{
				context.put("disableUnjoinSelection", Boolean.TRUE);
			}
			
			if (ServerConfigurationService.getStrings("wsetup.disable.unjoin") != null)
			{
				context.put("disableUnjoinSiteTypes", new ArrayList(Arrays.asList(ServerConfigurationService.getStrings("wsetup.disable.unjoin"))));
			}
		}
		else
		{
			template = buildJoinableContext(portlet, context, rundata, state);
		}
		// build confirmation screen context
		if (state.getAttribute(STATE_CONFIRM_VIEW_MODE) != null)
		{
			if (state.getAttribute(STATE_CONFIRM_VIEW_MODE).equals("unjoinconfirm"))
			{
				template = buildUnjoinconfirmContext(portlet, context, rundata, state);
			}
		}
		context.put("tlang", rb);
		context.put("alertMessage", state.getAttribute(STATE_MESSAGE));

		return template;

	} // buildMainPanelContext

	/**
	 * Navigate to confirmation screen
	 */
	public void doGoto_unjoinconfirm(RunData data)
	{
		SessionState state = ((JetspeedRunData) data).getPortletSessionState(((JetspeedRunData) data).getJs_peid());
		state.setAttribute(STATE_CONFIRM_VIEW_MODE, "unjoinconfirm");
		String id = data.getParameters().getString("itemReference");
		state.setAttribute(UNJOIN_SITE, id);
	}

	/**
	 * Build context for confirmation screen
	 * 
	 * @param portlet
	 * @param context
	 * @param runData
	 * @param state
	 * @return
	 */
	public String buildUnjoinconfirmContext(VelocityPortlet portlet, Context context, RunData runData, SessionState state)
	{

		context.put("tlang", rb);
		if (state.getAttribute(UNJOIN_SITE) != null)
		{
			try
			{
				context.put("unjoinSite", SiteService.getSite(((String) state.getAttribute(UNJOIN_SITE))).getTitle());
			}
			catch (IdUnusedException e)
			{
				Log.warn("chef", this + ".buildUnjoinconfirmContext(): " + e);
			}
		}

		String template = (String) getContext(runData).get("template");
		return template + "_confirm";
	}

	/**
	 * process unjoin
	 * 
	 * @param data
	 */
	public void doGoto_unjoinyes(RunData data)
	{
		SessionState state = ((JetspeedRunData) data).getPortletSessionState(((JetspeedRunData) data).getJs_peid());
		state.removeAttribute(STATE_CONFIRM_VIEW_MODE);
		doUnjoin(data);
	}

	/**
	 * cancel unjoin of site
	 * 
	 * @param data
	 */
	public void doGoto_unjoincancel(RunData data)
	{
		SessionState state = ((JetspeedRunData) data).getPortletSessionState(((JetspeedRunData) data).getJs_peid());
		state.removeAttribute(STATE_CONFIRM_VIEW_MODE);
	}

	/**
	 * Setup for the options panel.
	 */
	public String buildJoinableContext(VelocityPortlet portlet, Context context, RunData runData, SessionState state)
	{
		// the sorting sequence
		if (state.getAttribute(JOINABLE_SORT_ASC) == null)
		{
			state.setAttribute(JOINABLE_SORT_ASC, Boolean.TRUE);
		}
		context.put("currentSortAsc", state.getAttribute(JOINABLE_SORT_ASC));

		if (state.getAttribute(SEARCH_TERM) == null)
		{
			state.setAttribute(SEARCH_TERM, "");
		}
		context.put(SEARCH_TERM, state.getAttribute(SEARCH_TERM));

		List openSites = prepPage(state);
		context.put("openSites", openSites);

		pagingInfoToContext(state, context);

		context.put("tlang", rb);

		String template = (String) getContext(runData).get("template");
		return template + "_joinable";
	}

	/**
	 * Handle the eventSubmit_doGoto_unJoinable command to shwo the list of site which are unjoinable.
	 */
	public void doGoto_unjoinable(RunData data)
	{
		SessionState state = ((JetspeedRunData) data).getPortletSessionState(((JetspeedRunData) data).getJs_peid());
		state.removeAttribute(STATE_VIEW_MODE);
	}

	/**
	 * Handle the eventSubmit_doGoto_unJoinable command to shwo the list of site which are joinable.
	 */
	public void doGoto_joinable(RunData data)
	{
		SessionState state = ((JetspeedRunData) data).getPortletSessionState(((JetspeedRunData) data).getJs_peid());
		state.setAttribute(STATE_VIEW_MODE, "joinable");
	}

	/**
	 * Handle the eventSubmit_doJoin command to have the user join one or more sites.
	 */
	public void doJoin(RunData data)
	{
		SessionState state = ((JetspeedRunData) data).getPortletSessionState(((JetspeedRunData) data).getJs_peid());

		// read the group ids to join
		String id = data.getParameters().getString("itemReference");
		if (id != null)
		{
			try
			{
				// join the site
				SiteService.join(id);
				String msg = rb.getString("mb.youhave2") + " " + SiteService.getSite(id).getTitle();
				addAlert(state, msg);
			}
			catch (IdUnusedException e)
			{
				Log.warn("chef", this + ".doJoin(): " + e);
			}
			catch (PermissionException e)
			{
				Log.warn("chef", this + ".doJoin(): " + e);
			}
			catch (InUseException e)
			{
				addAlert(state, rb.getString("mb.sitebeing"));
			}
		}

		// TODO: hard coding this frame id is fragile, portal dependent, and needs to be fixed -ggolden
		// schedulePeerFrameRefresh("sitenav");
		
		scheduleTopRefresh();

	} // doJoin

	/**
	 * Handle the eventSubmit_doUnjoin command to have the user un-join one or more groups.
	 */
	public void doUnjoin(RunData data)
	{
		SessionState state = ((JetspeedRunData) data).getPortletSessionState(((JetspeedRunData) data).getJs_peid());

		// read the form / state to figure out which attachment(s) to add.
		// String id = data.getParameters().getString("itemReference");
		String id = (String) state.getAttribute(UNJOIN_SITE);
		if (id != null)
		{
			try
			{
				SiteService.unjoin(id);
				String msg = rb.getString("mb.youhave") + " " + SiteService.getSite(id).getTitle();
				addAlert(state, msg);
			}
			catch (IdUnusedException ignore)
			{
			}
			catch (PermissionException e)
			{
				// This could occur if the user's role is the maintain role for the site, and we don't let the user
				// unjoin sites they are maintainers of
				Log.warn("chef", this + ".doUnjoin(): " + e);
			}
			catch (InUseException e)
			{
				Log.warn("chef", this + ".doJoin(): " + e);
				addAlert(state, rb.getString("mb.sitebeing"));
			}
		}

		// TODO: hard coding this frame id is fragile, portal dependent, and needs to be fixed -ggolden
		schedulePeerFrameRefresh("sitenav");

	} // doUnjoin

	/**
	 * toggle the sort ascending vs decending property in main view
	 */
	public void doToggle_sort(RunData data)
	{
		SessionState state = ((JetspeedRunData) data).getPortletSessionState(((JetspeedRunData) data).getJs_peid());

		if (state.getAttribute(SORT_ASC) != null)
		{
			state.setAttribute(SORT_ASC, new Boolean(!((Boolean) state.getAttribute(SORT_ASC)).booleanValue()));
		}
	} // doToggle_sort

	/**
	 * toggle the sort ascending vs decending property in joinable view
	 */
	public void doToggle_joinable_sort(RunData data)
	{
		SessionState state = ((JetspeedRunData) data).getPortletSessionState(((JetspeedRunData) data).getJs_peid());

		if (state.getAttribute(JOINABLE_SORT_ASC) != null)
		{
			state.setAttribute(JOINABLE_SORT_ASC, new Boolean(!((Boolean) state.getAttribute(JOINABLE_SORT_ASC)).booleanValue()));
		}
	}
}
