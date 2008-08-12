package org.sakaiproject.site.tool.helper.order.impl;

import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.Vector;

import org.sakaiproject.component.api.ServerConfigurationService;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.exception.PermissionException;
import org.sakaiproject.site.api.Site;
import org.sakaiproject.site.api.SitePage;
import org.sakaiproject.site.api.ToolConfiguration;
import org.sakaiproject.site.api.SiteService;
import org.sakaiproject.tool.api.Tool;
import org.sakaiproject.tool.api.ToolManager;
import org.sakaiproject.tool.api.ToolSession;
import org.sakaiproject.tool.api.SessionManager;
import org.sakaiproject.util.SortedIterator;
import org.sakaiproject.util.Web;

/**
 * 
 * @author Joshua Ryan joshua.ryan@asu.edu
 *
 */
public class SitePageEditHandler {
    public Site site = null;
    public SiteService siteService = null;
    public ToolManager toolManager = null;
    public SessionManager sessionManager = null;
    public ServerConfigurationService serverConfigurationService;
    private Map pages = null;
    public String[] selectedTools = new String[] {};
    private Set unhideables = null;
    public String state = null;
    public String title = "";
    public String test = null;
    public boolean update = false;
    public boolean done = false;
    
    //Just something dumb to bind to in order to supress warning messages
    public String nil = null;
    
    private final String TOOL_CFG_FUNCTIONS = "functions.require";
    private final String SITE_UPD = "site.upd";
    private final String HELPER_ID = "sakai.tool.helper.id";
    private final String UNHIDEABLES_CFG = "poh.unhideables";

    //System config for which tools can be added to a site more then once
    private final String MULTI_TOOLS = "sakai.site.multiPlacementTools";

    // Tool session attribute name used to schedule a whole page refresh.
    public static final String ATTR_TOP_REFRESH = "sakai.vppa.top.refresh"; 

    private String[] defaultMultiTools = {"sakai.news", "sakai.iframe"};

    /**
     * Gets the current tool
     * @return Tool
     */
    public Tool getCurrentTool() {
        return toolManager.getCurrentTool();
    }

    /**
     * Generates the currentPlacementId as used by the portal to name the iframe the tool lives in
     * @return String currentPlacementId
     */
    public String getCurrentPlacementId() {
        return Web.escapeJavascript("Main" + toolManager.getCurrentPlacement().getId());
    }
    
    /**
     * Gets the pages for the current site
     * @return Map of pages (id, page)
     */
    public Map getPages() {
        if (site == null) {
            init();
        }
        if (update) {
            pages = new LinkedHashMap();
            if (site != null)
            {    
                List pageList = site.getOrderedPages();
                for (int i = 0; i < pageList.size(); i++) {
                    
                    SitePage page = (SitePage) pageList.get(i);
                    pages.put(page.getId(), page);
                }
            }
        }
        return pages;
    }
    
    /**
     * Initialization method, just gets the current site in preperation for other calls
     *
     */
    public void init() {
        if (site == null) {
            String siteId = null;
            try {
                siteId = sessionManager.getCurrentToolSession()
                        .getAttribute(HELPER_ID + ".siteId").toString();
            }
            catch (java.lang.NullPointerException npe) {
                // Site ID wasn't set in the helper call!!
            }
            
            if (siteId == null) {
                siteId = toolManager.getCurrentPlacement().getContext();
            }
            
            try {    
                site = siteService.getSite(siteId);
            
            } catch (IdUnusedException e) {
                // The siteId we were given was bogus
                e.printStackTrace();
            }
        }
        update = siteService.allowUpdateSite(site.getId());
        title = site.getTitle();
        
        String conf = serverConfigurationService.getString(UNHIDEABLES_CFG);
        if (conf != null) {
            unhideables = new HashSet();
            String[] toolIds = conf.split(",");
            for (int i = 0; i < toolIds.length; i++) {
                unhideables.add(toolIds[i].trim());
            }
        }
    }
    
    /**
     * Wrapper around siteService to save a site
     * @param site
     * @throws IdUnusedException
     * @throws PermissionException
     */
    public void saveSite(Site site) throws IdUnusedException, PermissionException {
        siteService.save(site);
    }
    
    /**
     * Gets the list of tools that can be added to the current site
     * @return List of Tools
     */
    public List getAvailableTools() {

        List tools = new Vector();

        if (site == null) {
            init();
        }
        
        Set categories = new HashSet();

        if (site.getType() == null || siteService.isUserSite(site.getId())) {
            categories.add("myworkspace");
        }
        else {
            categories.add(site.getType());
        }
        
        Set toolRegistrations = toolManager.findTools(categories, null);
        
        Vector multiPlacementToolIds = new Vector();

        String items[];
        if (serverConfigurationService.getString(MULTI_TOOLS) != null && 
                !"".equals(serverConfigurationService.getString(MULTI_TOOLS)))
            items = serverConfigurationService.getString(MULTI_TOOLS).split(",");
        else
            items = defaultMultiTools;

        for (int i = 0; i < items.length; i++) {
            multiPlacementToolIds.add(items[i]);
        }
     
        List currentTools = new Vector();
        
        SortedIterator i = new SortedIterator(toolRegistrations.iterator(), new ToolComparator());
        for (; i.hasNext();)
        {
            Tool tr = (Tool) i.next();
            if (tr != null) {
                if (multiPlacementToolIds.contains(tr.getId())) {
                    tools.add(tr);
                }
                else if (site.getToolForCommonId(tr.getId()) == null) {
                    tools.add(tr);
                }
            }
        }
        
        return tools;
    }
    
    /**
     * Process tool adds
     * @return
     */
    public String addTools () {    
        for (int i = 0; i < selectedTools.length; i++) {
            SitePage page = null;
            try {
                page = site.addPage();
                Tool tool = toolManager.getTool(selectedTools[i]);
                page.setTitle(tool.getTitle());
                page.addTool(tool.getId());
                siteService.save(site);
            } 
            catch (IdUnusedException e) {
                e.printStackTrace();
                return null;
            } 
            catch (PermissionException e) {
                e.printStackTrace();
                return null;
            }
        }
      
        return "success";
    }
    
    /**
     * Process the 'Save' post on page ordering.
     *
     */
    public String savePages () {
        if (state != null) {
            String[] pages = state.split(" ");
            for (int i = 0; i < pages.length; i++) {
                if (pages[i] != null) {
                    SitePage realPage = site.getPage(pages[i]);
                    realPage.setPosition(i);
                }
            }
            site.setCustomPageOrdered(true);
            try {
                siteService.save(site);
            } 
            catch (IdUnusedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } 
            catch (PermissionException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }

        ToolSession session = sessionManager.getCurrentToolSession();
        session.setAttribute(ATTR_TOP_REFRESH, Boolean.TRUE);

        return "done";
    }
    
    /**
     * Allows the Cancel button to return control to the tool calling this helper
     *
     */
    public String cancel() {
        ToolSession session = sessionManager.getCurrentToolSession();
        session.setAttribute(ATTR_TOP_REFRESH, Boolean.TRUE);

        return "done";
    }
    
    /**
     * Cancel out of the current action and go back to main view
     * 
     */
    public String back() {
      return "back";
    }
    
    public String reset() {
        site.setCustomPageOrdered(false);
        try {
            siteService.save(site);
        } 
        catch (IdUnusedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } 
        catch (PermissionException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return "";
    }

    /**
     * Checks if a given toolId is required or not for the current site being edited
     *
     * @param toolId
     * @return true if the tool is required
     */
    public boolean isRequired(String toolId) {
        if (site == null) {
            init();
        }

        List requiredTools = null;
        if (site.getType() == null || siteService.isUserSite(site.getId())) {
            requiredTools = serverConfigurationService.getToolsRequired("myworkspace");
        }
        else {
            requiredTools = serverConfigurationService.getToolsRequired(site.getType());
        }

        if (requiredTools != null && requiredTools.contains(toolId)) {
            return true;
        }
        return false;
    }   


    /**
     * Checks if users without site.upd can see a page or not
     * 
     * @param page The SitePage whose visibility is in question
     * @return true if users with out site.upd can see the page
     */
    public boolean isVisible(SitePage page) {
        List tools = page.getTools();
        Iterator iPt = tools.iterator();

        boolean visible = false;
        while( !visible && iPt.hasNext() ) 
        {
            ToolConfiguration placement = (ToolConfiguration) iPt.next();
            Properties roleConfig = placement.getConfig();
            String roleList = roleConfig.getProperty(TOOL_CFG_FUNCTIONS);

            if (roleList == null || !(roleList.indexOf(SITE_UPD) > -1)) {
                visible = true;
            }
            
        }
        
        return visible;
    }
    
    /**
     * Checks if the site has been ordered yet
     * 
     * @return true if the site has custom ordering
     */
    public boolean isSiteOrdered() {
        return site.isCustomPageOrdered();
    }

    /**
     * Checks to see if a given tool is allowed to be hidden.
     *
     * Useful for tools that have other requried permissions where setting the page
     * as visible may not make it visible to all users and thus causes some confusion.
     *
     * @return true if this tool is allowed to be hidden
     */
    public boolean allowsHide(String toolId) {
        if (unhideables == null || !unhideables.contains(toolId))
            return true;
        return false;
    }

    /**
     * Checks to see if a given SitePage is allowed to be hidden.
     *
     * Useful for pages with tools that have other requried permissions where setting 
     * the page as visible may not make it visible to all users and thus causes some
     * confusion.
     *
     * @return true if this tool is allowed to be hidden
     */
    public boolean allowsHide(SitePage page) {
        List tools = page.getTools();
        Iterator iPt = tools.iterator();

        boolean hideable = true;
        while( hideable && iPt.hasNext() )
        {
            ToolConfiguration placement = (ToolConfiguration) iPt.next();

            if (!allowsHide(placement.getToolId())) {
                hideable = false;
            }
        }
        return hideable;
    }
 
    /**
     * Hides a page from any user who doesn't have site.upd
     * Or atleast removes it from the portal navigation list
     * 
     * @param pageId The Id of the Page
     * @return true for sucess, false for failuer
     * @throws IdUnusedException, PermissionException
     */
    public boolean hidePage(String pageId) throws IdUnusedException, PermissionException {
        return  pageVisibilityHelper(pageId, false);
    }
    
    /**
     * Unhides a page from any user who doesn't have site.upd
     * Or atleast removes it from the portal navigation list
     * 
     * @param pageId The Id of the Page
     * @return true for sucess, false for failuer
     * @throws IdUnusedException, PermissionException
     */
    public boolean showPage(String pageId) throws IdUnusedException, PermissionException {        
        return pageVisibilityHelper(pageId, true);
    }
    
    /**
     * Adds or removes the requirement to have site.upd in order to see
     * a page
     * @param pageId The Id of the Page
     * @param visible
     * @return true for sucess, false for failuer
     * @throws IdUnusedException, PermissionException
     */
    private boolean pageVisibilityHelper(String pageId, boolean visible) 
                                throws IdUnusedException, PermissionException{

        if (site == null) {
            init();
        }
        SitePage page = site.getPage(pageId);
        List tools = page.getTools();
        Iterator iterator = tools.iterator();

        //If all the tools on a page require site.upd then only users with site.upd will see
        //the page in the site nav of Charon... not sure about the other Sakai portals floating about
        while( iterator.hasNext() ) {
            ToolConfiguration placement = (ToolConfiguration) iterator.next();
            Properties roleConfig = placement.getPlacementConfig();
            String roleList = roleConfig.getProperty(TOOL_CFG_FUNCTIONS);
            boolean saveChanges = false;
            
            if (roleList == null) {
                roleList = "";
            }
            if (!(roleList.indexOf(SITE_UPD) > -1) && !visible) {
                if (roleList.length() > 0) {
                    roleList += ",";
                }
                roleList += SITE_UPD;
                saveChanges = true;
            }
            else if (visible) {
                roleList = roleList.replaceAll("," + SITE_UPD, "");
                roleList = roleList.replaceAll(SITE_UPD, "");
                saveChanges = true;
            }
            
            if (saveChanges) {
                roleConfig.setProperty(TOOL_CFG_FUNCTIONS, roleList);

                placement.save();
                
                siteService.save(site);
            }
            
        }
        
        return true;
    }
    
    /**
     * Adds a new single tool page to the current site
     * @param toolId
     * @param title
     * @return the newly added SitePage
     */
    public SitePage addPage (String toolId, String title) {
        SitePage page = null;
        try {
            page = site.addPage();
            page.setTitle(title);
            page.addTool(toolId);        
            siteService.save(site);
        } 
        catch (IdUnusedException e) {
            e.printStackTrace();
            return null;
        } 
        catch (PermissionException e) {
            e.printStackTrace();
            return null;
        }
        init();
        
        return page;
    }
    
    /**
     * ** Copied from SiteAction.java.. should be in a common place such as util?
     * 
     * @author joshuaryan
     *
     */
    private class ToolComparator
    implements Comparator
    {    
        /**
        * implementing the Comparator compare function
        * @param o1 The first object
        * @param o2 The second object
        * @return The compare result. 1 is o1 < o2; 0 is o1.equals(o2); -1 otherwise
        */
        public int compare ( Object o1, Object o2)
        {
            try
            {
                return ((Tool) o1).getTitle().compareTo(((Tool) o2).getTitle());
            }
            catch (Exception e)
            {
            }
            return -1;
            
        }    // compare
        
    } //ToolComparator
    
}
