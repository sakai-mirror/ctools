package org.sakaiproject.provider.user;


// imports
import java.io.IOException;
import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;

import javax.security.auth.callback.Callback;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.callback.ConfirmationCallback;
import javax.security.auth.callback.NameCallback;
import javax.security.auth.callback.PasswordCallback;
import javax.security.auth.callback.TextOutputCallback;
import javax.security.auth.callback.UnsupportedCallbackException;
import javax.security.auth.login.LoginContext;
import javax.security.auth.login.LoginException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.component.api.ServerConfigurationService;

import org.sakaiproject.exception.IdUnusedException;
// import org.sakaiproject.framework.current.CurrentService;
import org.sakaiproject.provider.user.SSLSocketClientWithClientAuth;
import org.sakaiproject.thread_local.cover.ThreadLocalManager;
import org.sakaiproject.user.api.DisplayAdvisorUDP;
import org.sakaiproject.user.api.User;
import org.sakaiproject.user.api.UserDirectoryProvider;
import org.sakaiproject.user.api.UserEdit;
import org.sakaiproject.user.api.UserFactory;
import org.sakaiproject.user.api.UsersShareEmailUDP;
import org.sakaiproject.util.RequestFilter;
import org.sakaiproject.util.StringUtil;
import org.sakaiproject.util.api.umiac.UmiacClient;
// import org.sakaiproject.util.java.StringUtil;

/**
* <p>UnivOfMichUserDirectoryProvider is UserDirectoryProvider that provides a user for any
* person known to kerberos and the U of M UMIAC system.</p>
* <p>Note: Java Runtime must be setup properly:<ul>
* <li>{java_home}/jre/lib/security/java.security must have this line:<br/>
*   login.config.url.1=file:${java.home}/lib/security/JaasAuthentication.conf</li>
* <li>the file "JaasAuthentication.conf" must be placed into that same directory.</li>
* <li>the file "krb5.conf" must be placed into that same directory.</li></ul></p>
* <p>These two files can be found in CVS under src/conf/jaas_k5, and are configured
* for U of M Kerberos.</p>
* <p>Note: The server running this code must be known the the UMIAC system to be able to mity of Michigan, CHEF Software Development Team
* @version $Revision$
* $HeadURL$
* $Id$
*/
public class UnivOfMichUserDirectoryProvider
	implements UserDirectoryProvider, UsersShareEmailUDP, DisplayAdvisorUDP
{

	// keep false, else someone might configure the server (CTOOLS_UDP_NOAUTH=true in sakai.properties) to allow authentication w/o password
	protected static boolean TEST_MODE = false;
	
	protected void initTestMode() {
		TEST_MODE=false;
	}

		private static Log log = LogFactory.getLog(UnivOfMichUserDirectoryProvider.class);
//	/** Dependency: CurrentService */
//	protected CurrentService m_currentService = null;
//
//	/**
//	 * Dependency: CurrentService.
//	 * @param service The CurrentService.
//	 */
//	public void setCurrentService(CurrentService service)
//	{
//		m_currentService = service;
//	}

		
	/** Dependency: ServerConfigurationService*/
	protected org.sakaiproject.component.api.ServerConfigurationService m_configService = null;

	/**
	 * Dependency: ServerConfigurationService.
	 * @param service The ServerConfigurationService.
	 */
	public void setServerConfigurationService(org.sakaiproject.component.api.ServerConfigurationService service)
	{
		m_configService = service;
	}

	/** Configuration: kerberos or cosign. */
	protected boolean m_useKerberos = true;

	/**
	 * Dependency: ServerConfigurationService.
	 * @param setting The "kerberos" or "cosign" method setting.
	 */
	public void setMethod(String setting)
	{
		if ("cosign".equalsIgnoreCase(setting))
		{
			m_useKerberos = false;
		}
	}

	/** My UMIAC client interface. */
	private UmiacClient m_umiac;
	
	public void setUmiac(UmiacClient m_umiac) {
		this.m_umiac = m_umiac;
	}

	public UmiacClient getUmiac() {
		return m_umiac;
	}



	
	/*******************************************************************************
	* Init and Destroy
	*******************************************************************************/

	/**
	 * Final initialization, once all dependencies are set.
	 */
	public void init()
	{
		// call so that will set the value of test_mode for later calls.
		// Use a method so that can override it in class used only for 
		// safe testing environments.
		initTestMode();
		try
		{
			log.info(this +".init()");
			log.info(this +" user directory provider TEST_MODE="+TEST_MODE);
		}
		catch (Throwable t)
		{
			log.warn(this +".init(): ", t);
		}

	} // init

	/**
	* Returns to uninitialized state.
	*
	* You can use this method to release resources thet your Service
	* allocated when Turbine shuts down.
	*/
	public void destroy()
	{
		log.info(this +".destroy()");

	} // destroy

	/*******************************************************************************
	* UserDirectoryProvider implementation
	*******************************************************************************/


	/**
	* See if a user by this id exists.
	* @param userId The user id string.
	* @return true if a user by this id exists, false if not.
	*/
	public boolean userExists(String userId)
	{
		// our policy is:
		//		- if a uniqname user, which is know to umiac, is not internally defined, but umiac finds it,
		//		  then the user "exists".
		//		- if not, we won't check with kerberos/cosign, because we insist that the user have an internal
		//		  defined record to be valid in CTools.

		// first check with Umiac
//long umiacTime = System.currentTimeMillis();
		boolean knownUmiac = getUmiac().userExists(userId);
//umiacTime = System.currentTimeMillis() - umiacTime;
//log.info(this + ".userExists: " + userId + "  umiac: " + knownUmiac + " (" + umiacTime + ")");
		if (knownUmiac)
		{
			return true;
		}

/* The following code COULD be used to check for user existance with kerb / cosign, but
   our policy requires us to fail to find the use if umiac can't find it (if it's internally defined, it's already found
   before we are asked).

		// check kerberos / cosign
		if (m_useKerberos)
		{
//long kerbTime = System.currentTimeMillis();
			boolean knownKerb = userKnownToKerberos(userId);
//kerbTime = System.currentTimeMillis() - kerbTime;
//log.info(this + ".userExists: " + userId + " kerberos: " + knownKerb + " (" + kerbTime + ")");
			if (knownKerb)
			{
				return true;
			}
		}
		
		else
		{
//long cosignTime = System.currentTimeMillis();
			boolean knownCosign = userKnownToCosign(userId);
//cosignTime = System.currentTimeMillis() - cosignTime;
//log.info(this + ".userExists: " + userId + " cosign: " + knownCosign + " (" + cosignTime + ")");
			if (knownCosign)
			{
				return true;
			}
		}
*/
		return false;

	}	// userExists

	/**
	* Access a user object.  Update the object with the information found.
	* @param edit The user object (id is set) to fill in.
	* @return true if the user object was found and information updated, false if not.
	*/
	public boolean getUser(UserEdit edit)
	{
		if (!userExists(edit.getEid())) return false;

		// lookup the user in UMIAC
		try
		{
			getUmiac().setUserNames(edit);
		}
		catch (IdUnusedException e)
		{
			// if not known to UMIAC, leave firstName blank, last name set to id
			edit.setLastName(edit.getEid());
		}

		edit.setEmail(edit.getEid() + "@umich.edu");
		edit.setType("uniqname");

		return true;

	}	// getUser

	/**
	 * Access a collection of UserEdit objects; if the user is found, update the information, otherwise remove the UserEdit object from the collection.
	 * @param users The UserEdit objects (with id set) to fill in or remove.
	 */
	public void getUsers(Collection users)
	{
		// Note: we just iterate with getUser(); perhaps a single UMIAC call could be used to get them all at once... -ggolden
		for (Iterator i = users.iterator(); i.hasNext();)
		{
			UserEdit user = (UserEdit) i.next();
			if (!getUser(user))
			{
				i.remove();
			}
		}
	}

	/**
	 * Find all user objects which have this email address.
	 * 
	 * @param email
	 *        The email address string.
	 * @param factory
	 *        Use this factory's newUser() method to create all the UserEdit objects you populate and return in the return collection.
	 * @return Collection (UserEdit) of user objects that have this email address, or an empty Collection if there are none.
	 */
	public Collection findUsersByEmail(String email, UserFactory factory)
	{
		Collection rv = new Vector();

		// get a UserEdit to populate
		UserEdit edit = factory.newUser();
		String emailLC = email.toLowerCase();

		// assume a "@...umich.edu"

	//	int posUmich = email.indexOf("umich.edu");
		int posUmich = emailLC.indexOf("umich.edu");
		int posAt = email.indexOf("@");
		if (posUmich != -1 && posAt != -1)
		{
			String id = email.substring(0, posAt);
			edit.setEid(id);
			if (getUser(edit)) rv.add(edit);
		}

		return rv;
	}

	public Collection findUsersByEmailOld(String email, UserFactory factory)
	{
		Collection rv = new Vector();

		// get a UserEdit to populate
		UserEdit edit = factory.newUser();

		// assume a "@local.host"
		int pos = email.indexOf("@umich.edu");
		if (pos != -1)
		{
			String id = email.substring(0, pos);
			edit.setEid(id);
			if (getUser(edit)) rv.add(edit);
		}

		return rv;
	}
	
	
	/**
	* Find a user object who has this email address. Update the object with the information found.
	* @param email The email address string.
	* @return true if the user object was found and information updated, false if not.
	*/
	public boolean findUserByEmail(UserEdit edit, String email)
	{
		// lets not get messed up with spaces or cases
		String test = email.toLowerCase().trim();

		// if the email ends with "umich.edu" (even if it's from somebody@krusty.si.umich.edu) use the local part as a user id.
		if (!test.endsWith("umich.edu")) return false;

		// split the string once at the first "@"
		String parts[] = StringUtil.splitFirst(test, "@");
	//	edit.setId(parts[0]);
		edit.setEid(parts[0]);
		return getUser(edit);

	}	// findUserByEmail
	
	/**
	 * {@inheritDoc}
	 */
	public String getDisplayName(User user)
	{
	    String [] userName = getUmiac().getUserName(user.getEid());
	    if (userName == null) {
	    	return null;
	    }
    	return userName[1];
	}
	
	/**
	 * {@inheritDoc}
	 */
	public String getDisplayId(User user)
	{
		return user.getEid();
	}

	/**
	 * Authenticate a user / password.
	 * If the user edit exists it may be modified, and will be stored if...
	 * @param id The user id.
	 * @param edit The UserEdit matching the id to be authenticated (and updated) if we have one.
	 * @param password The password.
	 * @return true if authenticated, false if not.
	 */
	public boolean authenticateUser(String userId, UserEdit edit, String password)
	{
		// if we are compiled in test mode
		if (TEST_MODE)
		{
			// if we are configured to allow authentication w/o password
			if (m_configService.getBoolean("CTOOLS_UDP_NOAUTH", false))
			{
				// make sure the user has an entry
				boolean knownUmiac = getUmiac().userExists(userId);
				return knownUmiac;
			}
		}

		// check with kerberos / cosign
		if (m_useKerberos)
		{
//long kerbTime = System.currentTimeMillis();
			boolean authKerb = authenticateKerberos(userId, password);
//kerbTime = System.currentTimeMillis() - kerbTime;
//log.info(this + ".authenticateUser: " + userId + " kerberos: " + authKerb + " (" + kerbTime + ")");
			if (authKerb)
			{
				return true;
			}
		}
		
		else
		{
//long cosignTime = System.currentTimeMillis();
			boolean authCosign = authenticateCosign(userId, password);
//cosignTime = System.currentTimeMillis() - cosignTime;
//log.info(this + ".authenticateUser: " + userId + " cosign: " + authCosign + " (" + cosignTime+ ")");
			if (authCosign)
			{
				return true;
			}
		}

		return false;

	}	// authenticateUser

	/**
	 * {@inheritDoc}
	 */
	public void destroyAuthentication()
	{
		// get the current response
		HttpServletResponse resp = (HttpServletResponse) ThreadLocalManager.get(RequestFilter.CURRENT_HTTP_RESPONSE);
		if (resp != null)
		{
			// prep the response to clear the COSIGN cookie
			Cookie service = new Cookie("cosign-ctng","null");
			service.setMaxAge(0);
			service.setComment("");
			service.setDomain(m_configService.getServerName());
			service.setPath("/");
			resp.addCookie(service);
		}
	}

	/**
	 * Will this provider update user records on successfull authentication?
	 * If so, the UserDirectoryService will cause these updates to be stored.
	 * @return true if the user record may be updated after successfull authentication, false if not.
	 */
	public boolean updateUserAfterAuthentication()
	{
		return false;
	}
	
	/**
	 * {@inheritDoc}
	 */
	public boolean authenticateWithProviderFirst(String id)
	{
		return false;
	}
	
	/**
	 * {@inheritDoc}
	 */
	public boolean createUserRecord(String id)
	{
		return false;
	}

	/*******************************************************************************
	* Kerberos stuff
	*******************************************************************************/

	/**
	* Authenticate the user id and pw with kerberos.
	* @param user The user id.
	* @param password the user supplied password.
	* @return true if successful, false if not.
	*/
	protected boolean authenticateKerberos(String user, String pw)
	{
		// assure some length to the password
		if ((pw == null) || (pw.length () == 0)) return false;

		// Obtain a LoginContext, needed for authentication. Tell it
		// to use the LoginModule implementation specified by the
		// entry named "JaasAuthentication" in the JAAS login configuration
		// file and to also use the specified CallbackHandler.
		LoginContext lc = null;
		try
		{
			ChefCallbackHandler t = new ChefCallbackHandler();
			t.setId(user);
			t.setPw(pw);
			lc = new LoginContext("JaasAuthentication", t);
		}
		catch (LoginException le)
		{
			if (log.isDebugEnabled())
				log.debug(this + ".authenticateKerberos(): " + le.toString());
			return false;
		}
		catch (SecurityException se)
		{
			if (log.isDebugEnabled())
				log.debug(this + ".authenticateKerberos(): " + se.toString());
			return false;
		}

		try
		{
			// attempt authentication
			lc.login();

			if (log.isDebugEnabled())
				log.debug(this + ".authenticateKerberos(" + user + ", pw): kerberos success!");

			return true;
		}
		catch (LoginException le)
		{
			if (log.isDebugEnabled())
				log.debug(this + ".authenticateKerberos(" + user + ", pw): kerberos failed: " + le.toString());

			return false;
		}

	}   // authenticateKerberos

	/**
	* Check if the user id is known to kerberos.
	* @param user The user id.
	* @return true if successful, false if not.
	*/
	private boolean userKnownToKerberos(String user)
	{
		// use a dummy password
		String pw = "dummy";

		// Obtain a LoginContext, needed for authentication. Tell it
		// to use the LoginModule implementation specified by the
		// entry named "JaasAuthentication" in the JAAS login configuration
		// file and to also use the specified CallbackHandler.
		LoginContext lc = null;
		try
		{
			ChefCallbackHandler t = new ChefCallbackHandler();
			t.setId(user);
			t.setPw(pw);
			lc = new LoginContext("JaasAuthentication", t);
		}
		catch (LoginException le)
		{
			if (log.isDebugEnabled())
				log.debug(this + ".useKnownToKerberos(): " + le.toString());
			return false;
		}
		catch (SecurityException se)
		{
			if (log.isDebugEnabled())
				log.debug(this + ".useKnownToKerberos(): " + se.toString());
			return false;
		}

		try
		{
			// attempt authentication
			lc.login();

			if (log.isDebugEnabled())
				log.debug(this + ".useKnownToKerberos(" + user + "): kerberos success!");

			return true;
		}
		catch (LoginException le)
		{
			String msg = le.getMessage();
			
			// if this is the message, the user was good, the password was bad
			if (msg.equals("Pre-authentication information was invalid (24) - Preauthentication failed"))
			{
				if (log.isDebugEnabled())
					log.debug(this + ".useKnownToKerberos(" + user + "): kerberos user exists!");

				return true;
			}

			// the other message is when the user is bad:
			// Client not found in Kerberos database (6) - Client not found in Kerberos database
			if (log.isDebugEnabled())
				log.debug(this + ".userKnownToKerberos(" + user + "): kerberos user does not exist!");

			return false;
		}

	}   // userKnownToKerberos

	/**
	* Inner Class ChefCallbackHandler
	*
	* Get the user id and password information for authentication purpose.
	* This can be used by a JAAS application to instantiate a CallbackHandler.
	* @see javax.security.auth.callback
	*/
	protected class ChefCallbackHandler
		implements CallbackHandler
	{
		private String m_id;
		private String m_pw;
		
		/** constructor */
		public ChefCallbackHandler ()
		{
			m_id = new String ("");
			m_pw = new String ("");
			
		}   // ChefCallbackHandler
		
		/**
		 * Handles the specified set of callbacks.
		 *
		 * @param callbacks the callbacks to handle
		 * @throws IOException if an input or output error occurs.
		 * @throws UnsupportedCallbackException if the callback is not an
		 * instance of NameCallback or PasswordCallback
		 */
		public void handle (Callback[] callbacks) throws java.io.IOException, UnsupportedCallbackException
		{
			ConfirmationCallback confirmation = null;

			for (int i = 0; i < callbacks.length; i++)
			{
				if (callbacks[i] instanceof TextOutputCallback)
				{
					if (log.isDebugEnabled())
						log.debug("ChefCallbackHandler: TextOutputCallback");
				}

				else if (callbacks[i] instanceof NameCallback)
				{
					NameCallback nc = (NameCallback) callbacks[i];
					
					String result = getId();
					if (result.equals(""))
					{
						result = nc.getDefaultName();
					}
					
					nc.setName(result);
				}

				else if (callbacks[i] instanceof PasswordCallback)
				{
					PasswordCallback pc = (PasswordCallback) callbacks[i];
					pc.setPassword(getPw());
				}

				else if (callbacks[i] instanceof ConfirmationCallback)
				{
					if (log.isDebugEnabled())
						log.debug("ChefCallbackHandler: ConfirmationCallback");
				}

				else
				{
					throw new UnsupportedCallbackException (callbacks[i], "ChefCallbackHandler: Unrecognized Callback");
				}
			}

		}   // handle

		void setId(String id)
		{
			m_id = id;
			
		}   // setId
		
		private String getId()
		{
			return m_id;
			
		}   // getid
		
		void setPw(String pw)
		{
			m_pw = pw;
			
		}   // setPw
		
		private char[] getPw()
		{
			return m_pw.toCharArray();
			
		}   // getPw

	}   // ChefCallbackHandler

	/*******************************************************************************
	* Cosign stuff
	*******************************************************************************/

	/**
	* Authenticate the user id and pw with cosign.
	* @param user The user id.
	* @param password the user supplied password.
	* @return true if successful, false if not.
	*/
	protected boolean authenticateCosign(String user, String pw)
	{
		boolean passed = false;
		// assure some length to the password
		if ((pw == null) || (pw.length() == 0))
			return false;

		SSLSocketClientWithClientAuth cosign = new SSLSocketClientWithClientAuth();
		try
		{
			passed = cosign.authenticateCosign(user, pw);
		}
		catch (Exception e)
		{
			if (log.isDebugEnabled())
				log.debug(this +".authenticateCosign(): " + e.toString());
			return false;
		}

		return passed;
	}

	/**
	* Check if the user id is known to cosign.
	* @param user The user id.
	* @return true if successful, false if not.
	*/
	private boolean userKnownToCosign(String user)
	{
		boolean passed = false;

		SSLSocketClientWithClientAuth cosign = new SSLSocketClientWithClientAuth();
		try
		{
			passed = cosign.userKnownToCosign(user);
		}
		catch (Exception e)
		{
			if (log.isDebugEnabled())
				log.debug(this +".authenticateCosign(): " + e.toString());
			return false;
		}

		return passed;
	}

}	// UnivOfMichUserDirectoryProvider

/**********************************************************************************
*
* $Header: /cvs/ctools/ctools-providers/component/src/java/org/sakaiproject/component/legacy/user/UnivOfMichUserDirectoryProvider.java,v 1.3 2005/06/04 00:47:38 ggolden.umich.edu Exp $
*
**********************************************************************************/
