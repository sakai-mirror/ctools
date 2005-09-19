/**********************************************************************************
*
* $Header: /cvs/sakai/chef-tool/src/java/org/sakaiproject/tool/news/ReservesAction.java,v 1.4 2005/03/14 18:16:22 bkirschn.umich.edu Exp $
*
***********************************************************************************
*
* Copyright (c) 2003, 2004, 2005 The Regents of the University of Michigan, Trustees of Indiana University,
*                  Board of Trustees of the Leland Stanford, Jr., University, and The MIT Corporation
* 
* Licensed under the Educational Community License Version 1.0 (the "License");
* By obtaining, using and/or copying this Original Work, you agree that you have read,
* understand, and will comply with the terms and conditions of the Educational Community License.
* You may obtain a copy of the License at:
* 
*      http://cvs.sakaiproject.org/licenses/license_1_0.html
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
* AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
* DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
**********************************************************************************/

// package
package org.sakaiproject.tool.news;

// imports
import java.net.URL;
import java.util.List;
import java.util.ListIterator;
import java.util.ResourceBundle;
import java.util.Vector;
import java.util.regex.Pattern;

import org.sakaiproject.api.kernel.tool.Placement;
import org.sakaiproject.api.kernel.tool.cover.ToolManager;
import org.sakaiproject.cheftool.Context;
import org.sakaiproject.cheftool.JetspeedRunData;
import org.sakaiproject.cheftool.PortletConfig;
import org.sakaiproject.cheftool.RunData;
import org.sakaiproject.cheftool.VelocityPortlet;
import org.sakaiproject.service.framework.session.SessionState;
import org.sakaiproject.service.legacy.news.cover.NewsService;
import org.sakaiproject.service.legacy.news.NewsConnectionException;
import org.sakaiproject.service.legacy.news.NewsFormatException;
import org.sakaiproject.service.legacy.news.NewsItem;
import org.sakaiproject.service.legacy.realm.Realm;
import org.sakaiproject.service.legacy.realm.cover.RealmService;
import org.sakaiproject.service.legacy.site.cover.SiteService;
import org.sakaiproject.util.FormattedText;
import org.sakaiproject.util.java.StringUtil;

/**
* <p>ReservesAction is the rss news tool used for UM library reserves.</p>
* 
* @author University of Michigan, CTools Software Development Team
* @version $Revision$
*/
public class ReservesAction
	extends NewsAction
{
	
	private static ResourceBundle rb = ResourceBundle.getBundle("news");
	private static final String CHANNEL_URL_CHECKED = "channel_url_checked";
	
	/** These evil HTML tags are disallowed in RSS Item Description to protect
	 *  the system from broken pages as well as Cross-Site Scripting (XSS) attacks.
	 *  Probably not required for a trusted feed but might be useful later.
	 */								
	private final String[] M_evilTags = 
	{ 
		"applet", "base", "body", "bgsound", "button", "col", "colgroup", "comment", "embed", 
		"dfn", "embed", "fieldset", "form", "frame", "frameset", "head", "html",
		"iframe", "ilayer", "img", "inlineinput", "isindex", "input", "keygen", "label", "layer", "legend",
		"link", "listing", "map", "meta", "multicol", "nextid", "noembed", "noframes", "nolayer", "noscript",
		"object", "optgroup", "option", "param", "plaintext", "script", "select", "sound", "spacer",
		"spell", "submit", "textarea", "title", "wbr",
		"/applet", "/base", "/body", "/bgsound", "/button", "/col", "/colgroup", "/comment", "/embed", 
		"/dfn", "/embed", "/fieldset", "/form", "/frame", "/frameset", "/head", "/html",
		"/iframe", "/ilayer", "/img", "/inlineinput", "/isindex", "/input", "/keygen", "/label", "/layer", "/legend",
		"/link", "/listing", "/map", "/meta", "/multicol", "/nextid", "/noembed", "/noframes", "/nolayer", "/noscript",
		"/object", "/optgroup", "/option", "/param", "/plaintext", "/script", "/select", "/sound", "/spacer",
		"/spell", "/submit", "/textarea", "/title", "/wbr"
	};
	
	private final String[] M_goodTags = 
	{
		"abbr", "acronym", "address", "b", "br", "big", "blockquote", "br", "center", "cite", "code", 
		"dd", "del", "dir", "div", "dl", "dt", "em", "font", "hr", "h1", "h2", "h3", "h4", "h5", "h6", "i", "ins",
		"kbd", "li", "marquee", "menu", "nobr", "ol", "p", "pre", "q", "rt", "ruby", "rbc", "rb", "rtc", "rp",
		"s", "samp", "small", "span", "strike", "strong", "sub", "sup", "tt", "u", "ul", "var", "xmp",
		"/abbr", "/acronym", "/address", "/b", "/br", "/big", "/blockquote", "/br", "/center", "/cite", "/code", 
		"/dd", "/del", "/dir", "/div", "/dl", "/dt", "/em", "/font", "/hr", "/h1", "/h2", "/h3", "/h4", "/h5", "/h6", "/i", "/ins",
		"/kbd", "/li", "/marquee", "/menu", "/nobr", "/ol", "/p", "/pre", "/q", "/rt", "/ruby", "/rbc", "/rb", "/rtc", "/rp",
		"/s", "/samp", "/small", "/span", "/strike", "/strong", "/sub", "/sup", "/tt", "/u", "/ul", "/var", "/xmp" 
	};
										
	/** TODO: Decide which of these HTML tags to allow, and which to disallow in Item Description */
	private final String[] M_maybeTags = 
	{
		"img", "style", "span", "table", "tbody", "td", "tfoot", "th", "thead", "tr", "xml",
		"/img", "/style", "/span", "/table", "/tbody", "/td", "/tfoot", "/th", "/thead", "/tr", "/xml"
	};
	
	/** Matches anchor tags so that a target can be added to them.
	 * This ensures that links in formatted text are forced to open up in a new window.
	 * 
	 * This pattern matches as follows:
	 * "<a " followed by (string not containing characters "<>") 
	 * possibly followed by "target=something" (which is ignored),
	 * followed by "href" followed by (string not containing characters "<>")
	 * possibly followed by "target=something" (which is ignored), 
	 * followed by ">".
	 * 
	 * This should match all anchor tags that have an href attribute. 
	 */
	
	/** Matches anchor tags */
	private Pattern M_patternAnchorTag = Pattern.compile("(<a\\s[^<>]*?)(\\s+href[^<>\\s]*=[^<>\\s]*?)?+([^<>]*?)>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
	
	/** Matches close anchor tags */
	private Pattern M_patternCloseAnchorTag = Pattern.compile("</a\\s*>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
	
	/** Matches anchor tags anywhere */
	private Pattern M_containsAnchorTag = Pattern.compile(".*(<a\\s[^<>]*?)(\\s+href[^<>\\s]*=[^<>\\s]*?)?+([^<>]*?)>.*", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
	
	/** An array of regular expression pattern-matchers, that will match the tags given in M_evilTags */
	private Pattern[] M_evilTagsPatterns;
	
	/** An array of regular expression pattern-matchers, that will match the tags given in M_goodTags */
	private Pattern[] M_goodTagsPatterns;
	
	/**
	* Populate the state object, if needed.
	*/
	protected void initState(SessionState state, VelocityPortlet portlet, JetspeedRunData data)
	{
		super.initState(state, portlet, data);
		
		PortletConfig config = portlet.getPortletConfig();
		
		try
		{
			if(state.getAttribute("STATE_COMPILE_PATTERNS") == null)
			{
				compilePatterns();
				state.setAttribute("STATE_COMPILE_PATTERNS", "compiled");
			}
			
			Placement tool = ToolManager.getCurrentPlacement();
			
			if (StringUtil.trimToNull(tool.getPlacementConfig().getProperty(CHANNEL_URL_CHECKED)) == null)
			{
				//set the Library Reserves tool url when first launched
				String siteId = ToolManager.getCurrentPlacement().getContext();
				
				try
				{
					try
					{
						Realm r = RealmService.getRealm(SiteService.siteReference(siteId));
						String providerId = r.getProviderRealmId();
						
						String courseReserveUrl = StringUtil.trimToNull(config.getInitParameter(PARAM_CHANNEL_URL));
						
						String urlString = getCourseReserveUrl(courseReserveUrl, providerId);
						if (urlString != null)
						{
							try 
							{
								URL url = new URL(urlString);
								Object content = url.getContent();
								NewsService.getChannel(url.toExternalForm());
								
								state.setAttribute(STATE_CHANNEL_URL, url.toExternalForm());
								
								// update the tool config
								tool.getPlacementConfig().setProperty("channel-url", url.toExternalForm());
							}
							catch(Exception e)
							{
								// display message
								addAlert(state, rb.getString("cannot") +" " + urlString + ". ");
							}
						}
					}
					catch (Exception e)
					{
						Log.warn("chef", this + " Cannot get site realm " + siteId);
					}
					
					tool.getPlacementConfig().setProperty(CHANNEL_URL_CHECKED, Boolean.TRUE.toString());
					tool.save();
				}
				catch (Exception ee)
				{
					Log.warn("chef", this + " Cannot get site edit for " + siteId);
				}
			}	// if
		}
		catch (Exception any)
		{
			
		}
		
	}	// initState
	
	/** 
	* build the context for the Library Reserves List panel.
	* @return (optional) template name for this panel
	*/
	public String buildListPanelContext(VelocityPortlet portlet, 
										Context context,
										RunData rundata,
										SessionState state)
	{
		context.put("tlang",rb);
		// put this pannel's name for the return url
		context.put("panel-control", CONTROL_PANEL);
		context.put("panel-monitor", MONITOR_PANEL);

		context.put(GRAPHIC_VERSION_TEXT, state.getAttribute(GRAPHIC_VERSION_TEXT));
		context.put(FULL_STORY_TEXT, state.getAttribute(FULL_STORY_TEXT));

		String channel = (String) state.getAttribute(STATE_CHANNEL_URL);
		
		List items = new Vector();
		try {
			items = NewsService.getNewsitems(channel);
		}
		catch(NewsConnectionException e)
		{
			// display message
			addAlert(state, e.getMessage());
		}
		catch(NewsFormatException e)
		{
			// display message
			addAlert(state, e.getMessage());
		}
		catch(Exception e)
		{
			// display message
			addAlert(state, e.getMessage());
		}
		
		/** TODO Make BasicNewsService.BasicNewsChannel.initChannel() 
		 *  aware of item description child nodes of text type, and if
		 *  they exist process embedded HTML there (ref. SAK-1256)
		 *  (and then remove this code).
		 */
		
		if((items!=null) && (items.size() > 0))
		{
			for(ListIterator i = items.listIterator(); i.hasNext(); )
			{
				NewsItem item = (NewsItem) i.next();
				item.setDescription(processItemDescriptionHtml(item.getDescription()));
			}
		}
		
		context.put("news_items", items.iterator());
		
		return (String)getContext(rundata).get("template") + "-List";
	
	}   // buildListPanelContext

	
	/**
	* getCourseReserve gets a Course Reserve URL based on section
	*
	*/
	private String getCourseReserveUrl(String courseReserveUrl, String id)
	{
		String url = null;
		
		String[] courses;
		String[] fields;
		//String course = NULL_STRING;
		String sections = null;
		//String[] sect;
		String firstCourse = "";
		String firstCatalogNbr = null;
		String firstSection = null;
		String firstSubject = null;
		String firstSemester = null;
		String firstYear = null;
		try
		{
			if (id.indexOf("+") != -1) 
			{
				// This is a crosslisted course; tab is first course and its section(s)
				courses = id.split("\\+");
				firstCourse = courses[0]; // Get the first course
				if (firstCourse.indexOf("[") != -1) 
				{
					// Case 1: A cross-listed course with multiple sections; tab is first course and its sections
					sections = firstCourse.substring(firstCourse.indexOf("[")+1, firstCourse.indexOf("]"));
					fields = firstCourse.split(",");
					firstYear = fields[0];
					firstSemester = fields[1];
					firstSubject = fields[3]; //Subject
					firstCatalogNbr = fields[4]; //Catalog number
					firstSection = (sections.indexOf(",")!=-1)?sections.substring(0, sections.indexOf(",")):sections; //Sections
				}
				else
				{
					// Case 2: A cross-listed course with one section; tab is first course and its section
					fields = firstCourse.split(",");
					firstYear = fields[0];
					firstSemester = fields[1];
					firstSubject = fields[3]; //Subject
					firstCatalogNbr = fields[4]; //Catalog number
					firstSection = fields[5]; //Section
				}
			}
			else if (id.indexOf("[") != -1) 
			{
				// Case 3: A single course with multiple sections; tab is course and sections
				firstCourse = id.substring(0,id.indexOf("[")-1);
				fields = firstCourse.split(",");
				firstYear = fields[0];
				firstSemester = fields[1];
				firstSubject = fields[3]; //Subject
				firstCatalogNbr = fields[4]; //Catalog number
				sections = id.substring(id.indexOf("[")+1, id.indexOf("]"));
				firstSection = (sections.indexOf(",")!=-1)?sections.substring(0, sections.indexOf(",")):sections; //Section
			}
			else 
			{
				// Case 4: A single course with a single section; tab is course and section
				fields = id.split(",");
				firstYear = fields[0];
				firstSemester = fields[1];
				firstSubject = fields[3]; //Subject
				firstCatalogNbr = fields[4]; //Catalog number
				firstSection = fields[5]; //Section
			}
		}
		catch (Exception e)
		{
			// if there is a problem, create a generic tab
			Log.warn("chef", "SiteAction.getCourseTab Exception " + e.getMessage() + " " + id);
		}
		
		if (courseReserveUrl != null)
		{
			if(	firstCatalogNbr != null 
				&& firstSection != null
				&& firstSubject != null
				&& firstSemester != null
				&& firstYear != null)
			{
				//e.g., http://www.lib.umich.edu/r/rss-reserves/rss.php?catalog_nbr=468&section=001&semester=2&subject=JUDAIC&year=2004
				url = courseReserveUrl + "catalog_nbr=" + firstCatalogNbr + 
					"&section=" + firstSection + "&semester=" + firstSemester + 
					"&subject=" + firstSubject + "&year=" + firstYear;
			}
			else
			{
				// splash page for Course Reserve
				url = courseReserveUrl + "catalog_nbr=&section=&semester=&subject=&year=";
			}
		}
		
		return url;
	}//getCourseReserveUrl
	
	/*
	 * Compile tag matching patterns.
	*/
	private void compilePatterns()
	{
		//compile evil tag patterns
		M_evilTagsPatterns = new Pattern[M_evilTags.length];
		for (int i=0; i<M_evilTags.length; i++)
		{
			// matches the start of the particular evil tag "<" followed by whitespace, 
			// followed by the tag name, followed by anything, followed by ">", case insensitive, 
			// allowed to match over multiple lines.
			M_evilTagsPatterns[i] = Pattern.compile(".*<\\s*" + M_evilTags[i] + ".*>.*", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE | Pattern.DOTALL);
		}
		
		//compile good tag patterns
		M_goodTagsPatterns = new Pattern[M_goodTags.length];
		for (int i=0; i<M_goodTags.length; i++)
		{
			// matches the start of the particular evil tag "<" followed by whitespace, 
			// followed by the tag name, followed by anything, followed by ">", case insensitive, 
			// allowed to match over multiple lines.
			M_goodTagsPatterns[i] = Pattern.compile(".*<\\s*" + M_goodTags[i] + ".*>.*", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE | Pattern.DOTALL);
		}
		
	}
	
	/** Various RSS versions allow HTML in item description.
	 *  Process item description characters, escaping evil HTML tags
	 *  and sanitizing HTML anchors, allowing clean anchor tags and
	 *  good tags to go unescaped.
	 */
	public String processItemDescriptionHtml(String in)
	{
		/** This list of good and evil tags comes from FormattedText.java,
		 *  but end tags have been added, and a, /a omitted from the
		 *  good tags, because anchors are treated separately.
		 *
		 */
		if(in == null || in.equals(""))
			return "";
		StringBuffer retVal = new StringBuffer();
		try
		{
			boolean evilTag = false;
			boolean goodTag = false;
			boolean anchorTag = false;
			boolean closeAnchorTag = false;
			
			//is there an anchor tag?
			if(M_containsAnchorTag.matcher(in).matches())
				anchorTag = true;
			
			//is there an evil tag?
			for (int i=0; i<M_evilTags.length; i++)
			{
				if (M_evilTagsPatterns[i].matcher(in).matches())
				{
					evilTag = true;
					continue;
				}
			}
			
			/** if there are no evil tags or anchor tags, there is nothing to worry 
			 *  about.  Let other HTML tags through unescaped.
			 */
			
			/** TODO need to make some decisions about maybe HTML tags */
			if(!evilTag && !anchorTag)
				return in;
			
			int beginIndex = -1;
			int endIndex = -1;
			int begin = -1;
			int end = -1;
			String cData = null;
			String tag = null;
			String href = null;
			String target = null;
			
			/** TODO if count of < doesn't match count of >, 
			 * then this breaks. Treat as structured content instead.
			 */
			
			beginIndex = in.indexOf("<");
			if(beginIndex == -1)
			{
				//escape all to be safe
				return new String(FormattedText.escapeHtml(in, false));
			}
			else
			{
				/** parse */
				beginIndex = 0;
				while(in.length() > beginIndex )
				{
					anchorTag = false;
					closeAnchorTag = false;
					evilTag = false;
					goodTag = false;
					
					//is there text before the tag?
					endIndex = in.indexOf("<", beginIndex);
					try
					{
						if(endIndex == -1)
							cData = in.substring(beginIndex);
						else
							cData = in.substring(beginIndex, endIndex);
					}
					catch(Exception e)
					{
						if (Log.getLogger("chef").isWarnEnabled())
						Log.warn("chef", this + ".processItemDescriptionHtml() cData = in.substring " + e 
								+ " in.length " + in.length() + " " + in 
								+ " retVal.length " + ((String)retVal.toString()).length() 
								+ " " + retVal.toString());
						return new String(retVal.toString() + " " + e);
					}
					
					//escapeHtml() CDATA though we only worry about unescaped HTML
					if(cData != null)
					{	
						retVal.append(FormattedText.escapeHtml(cData, false));
					}
					
					//look for < thru trailing >
					beginIndex = endIndex;
					
					//if no more tags, we're done
					if(endIndex == -1)
						return new String(retVal.toString());
					
					try
					{
						endIndex = in.indexOf(">", beginIndex) + 1;
					}
					catch(Exception e)
					{
						if (Log.getLogger("chef").isWarnEnabled())
						Log.warn("chef", this + ".processItemDescriptionHtml() in.indexOf " + e 
								+ " in.length " + in.length() + " " + in 
								+ " retVal.length " + ((String)retVal.toString()).length() 
								+ " " + retVal.toString());
						return new String(retVal.toString() + " " + e);
					}

					//include the >
					try
					{
						tag = in.substring(beginIndex, endIndex);
					}
					catch(Exception e)
					{
						if (Log.getLogger("chef").isWarnEnabled())
						Log.warn("chef", this + ".processItemDescriptionHtml() in.substring  " + e 
								+ " in.length " + in.length() + " " + in 
								+ " retVal.length " + ((String)retVal.toString()).length() 
								+ " " + retVal.toString());
						return new String(retVal.toString() + " " + e);
					}
					
					/** now we have a tag to classify */
					
					//is it an anchor tag?
					if(M_patternAnchorTag.matcher(tag).matches())
						anchorTag = true;
					
					//is it a close anchor tag?
					if(M_patternCloseAnchorTag.matcher(tag).matches())
						closeAnchorTag = true;
					
					//is it an evil tag?
					for (int i=0; i<M_evilTags.length; i++)
					{
						if (M_evilTagsPatterns[i].matcher(tag).matches())
						{
							evilTag = true;
						}
					}
					
					//is it a good tag?
					for (int i=0; i<M_goodTags.length; i++)
					{
						if (M_goodTagsPatterns[i].matcher(tag).matches())
						{
							goodTag = true;
						}
					}
					
					//escape the evil tag
					if(evilTag)
					{
						tag = "(Escaped tag) " + FormattedText.escapeHtml(tag, false);
					}
					if(goodTag)
					{
						//leave good tag unescaped, e.g. </br>
					}
					else if(anchorTag)
					{
						//rewrite anchor without javascript: etc. but don't escape it
						
						/** TODO could do a better job parsing the href */
						
						try
						{
							//get href="..."
							begin = tag.indexOf("href");
							begin = tag.indexOf("=", begin);
							try
							{
								href = tag.substring(begin + 1);
							}
							catch(Exception e)
							{
								if (Log.getLogger("chef").isWarnEnabled())
								Log.warn("chef", this + ".processItemDescriptionHtml() tag.substring " + e 
										+ " in.length " + in.length() + " " + in 
										+ " retVal.length " + ((String)retVal.toString()).length() 
										+ " " + retVal.toString());
								return new String(retVal.toString() + " " + e);
							}
							end = href.indexOf("\"");
							begin = end;
							try
							{
								end = href.indexOf("\"", begin + 2) + 1;
							}
							catch(Exception e)
							{
								if (Log.getLogger("chef").isWarnEnabled())
								Log.warn("chef", this + ".processItemDescriptionHtml() href.indexOf " + e 
										+ " in.length " + in.length() + " " + in 
										+ " retVal.length " + ((String)retVal.toString()).length() 
										+ " " + retVal.toString());
								return new String(retVal.toString() + " " + e);
							}
							try
							{
								href = href.substring(begin, end);
							}
							catch(Exception e)
							{
								if (Log.getLogger("chef").isWarnEnabled())
								Log.warn("chef", this + ".processItemDescriptionHtml() href.substring  " + e 
										+ " in.length " + in.length() + " " + in 
										+ " retVal.length " + ((String)retVal.toString()).length() 
										+ " " + retVal.toString());
								return new String(retVal.toString() + " " + e);
							}
						}
						catch(Exception e)
						{
							if (Log.getLogger("chef").isWarnEnabled())
							Log.warn("chef", this + ".processItemDescriptionHtml() get href " + e 
									+ " in.length " + in.length() + " " + in 
									+ " retVal.length " + ((String)retVal.toString()).length() 
									+ " " + retVal.toString());
							return new String(retVal.toString() + " " + e);
						}
						
						//open in its own window
						target = " target=\"_blank\"";
						tag = "<a href=" + href + target + ">";
						
						//if href contains javascript, escape it
						if(href.indexOf("javascript") != -1)
							tag = "(Escaped tag) " + FormattedText.escapeHtml(tag, false);
					}
					else if(closeAnchorTag)
					{
						//normalize close anchor and don't escape it
						tag = "</a>";
					}
					else
					{
						//to be safe, escape anything else
						tag = FormattedText.escapeHtml(tag, false);
						
					}
					retVal = retVal.append(tag + "\n");
					
					//start over at end of this tag
					beginIndex = endIndex;
				}
				
			}//else
		}
		catch(Exception e)
		{
			if (Log.getLogger("chef").isWarnEnabled())
				Log.warn("chef", this + ".processItemDescriptionHtml() " + e 
					+ " in.length " + in.length() + " " + in 
					+ " retVal.length " + ((String)retVal.toString()).length() 
					+ " " + retVal.toString());
			return new String(retVal.toString() + " " + e);
		}
		
		return new String(retVal.toString());
		
	}//processItemDescriptionHtml
	
}	// class ReservesAction

/**********************************************************************************
*
* $Header: /cvs/sakai/chef-tool/src/java/org/sakaiproject/tool/news/ReservesAction.java,v 1.4 2005/03/14 18:16:22 bkirschn.umich.edu Exp $
*
**********************************************************************************/
