/**********************************************************************************
*
* $HeadURL$
*
***********************************************************************************
*
* Copyright (c) 2003, 2004 The Regents of the University of Michigan, Trustees of Indiana University,
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
package org.sakaiproject.util.impl.umiac;

// imports
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.InterruptedIOException;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Vector;
//import java.util.HashMap;
//import java.util.Hashtable;
//import java.util.List;
//import java.util.Iterator;
//import java.util.Map;
//
//import java.util.Set;
//import java.util.HashSet;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
//import org.sakaiproject.exception.IdUnusedException;
//import org.sakaiproject.component.cover.ServerConfigurationService;
//import org.sakaiproject.event.api.Event;
////import org.sakaiproject.service.framework.log.cover.Log;
////import org.sakaiproject.service.framework.log.cover.Logger;
//import org.sakaiproject.memory.api.Cache;
//import org.sakaiproject.memory.api.CacheRefresher;
//import org.sakaiproject.memory.cover.MemoryServiceLocator;
//import org.sakaiproject.user.api.UserEdit;
//import org.sakaiproject.util.api.umiac.UmiacClient;
//import org.sakaiproject.component.api.ServerConfigurationService;
import org.sakaiproject.component.api.ServerConfigurationService;
import org.sakaiproject.util.api.umiac.UmiacConnector;

/**
 * <p>UmiacClient is the Interface to the UMIAC service (classlist directory services).
 * This class translates calls from UmiacResponse to the UMIAC protocol and sends the protocol
 * via a TCP m_socket to a UMIAC server.</p>
 *
 * @author University of Michigan, CHEF Software Development Team
 * @version $Revision$
 */
public class UmiacConnectorImpl
	implements  UmiacConnector
{
	/** Umiac's network port address. */
	protected int m_port = -1;

	/** Umiac's network host address. */
	protected String m_host = null;
	
//	/** A cache of calls to umiac and the results. */
//	protected Cache m_callCache = null;

	/** The one and only Umiac client. */
	//protected static UmiacClient M_instance = null;
	
	// server configuration
	protected ServerConfigurationService serverConfigurationService = null;
	
	/** Socket timeout for Umiac response. This is the time 
	 * to wait before a failure for Umiac to respond is considered an error.
	 * This can be large since it won't have any effect during normal usage. */
	
	protected int m_umiacSocketTimeout = 3000;
	
	private static Log log = LogFactory.getLog(UmiacConnectorImpl.class);

	// server configuration
	
	public ServerConfigurationService getServerConfigurationService() {
		return serverConfigurationService;
	}

	public void setServerConfigurationService(
			ServerConfigurationService serverConfigurationService) {
		this.serverConfigurationService = serverConfigurationService;
	}

	/**
	* Construct, using the default production UMIAC instance.
	*/
	protected UmiacConnectorImpl()
	{
		// get the umiac address and port from the configuration service
	//	m_host = ServerConfigurationService.getString("umiac.address", null);
		m_host = serverConfigurationService.getString("umiac.address", null);
		try
		{
//			m_port = Integer.parseInt(ServerConfigurationService.getString("umiac.port", "-1"));
			m_port = Integer.parseInt(serverConfigurationService.getString("umiac.port", "-1"));
		}
		catch (Exception ignore) {}

		if (m_host == null)
		{
			log.warn(this + " - no 'umiac.address' in configuration");
		}
		if (m_port == -1)
		{
			log.warn(this + " - no 'umiac.port' in configuration (or invalid integer)");
		}

	}	// UmiacClient

	/**
	 * Final initialization, once all dependencies are set.
	 */
	public void init()
	{
		try
		{
			if (log.isDebugEnabled())
			{
				log.debug(this +".init()");
			}
		}
		catch (Throwable t)
		{
			if (log.isDebugEnabled())
			{
				log.debug(this +".init(): ", t);
			}
		}
	}

	/**
	 * Final cleanup.
	 */
	public void destroy()
	{
		if (log.isDebugEnabled())
		{
			log.debug(this +".destroy()");
		}
	}

	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#setPort(int)
	 */
	public void setPort(int port)
	{
		m_port = port;

	}	// setPort
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getPort()
	 */
	public int getPort()
	{
		return m_port;

	}	// getPort
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#setHost(java.lang.String)
	 */
	public void setHost(String host)
	{
		m_host = host;

	}	// setHost
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.util.IUmiacClient#getHost()
	 */
	public String getHost()
	{
		return m_host;

	}	// getHost

	public void setUmiacSocketTimeout(int umiacSocketTimeout) {
		m_umiacSocketTimeout = umiacSocketTimeout;
	}

/**
	* Send a command to UMIAC and returns the resulting
	* output as a vector of strings (one per response line).
	* No caching is attempted.
	* @param umiacCommand The UMIAC command string.
	* @return A Vector of Strings, one per response line.
	*/
	public Vector<String> makeRawCall(String umiacCommand)
	{
		if (log.isDebugEnabled())
		{
			log.debug( this + ".makeCall: " + umiacCommand);
		}
		PrintWriter out = null;
		BufferedReader in = null;
		Socket socket = null;
		
		Vector<String> v = new Vector<String>();
	
		// Open up a m_socket and write out the command to UMIAC.
		try
		{
			socket = new Socket(m_host,m_port);
			socket.setSoTimeout(m_umiacSocketTimeout);
			out = new PrintWriter(socket.getOutputStream(), true);
			in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			out.println(umiacCommand);
			String inString;
	
			// Now that we have a m_socket open and have thrown our command to UMIAC,
			// we listen for data returning on the m_socket.  UMIAC returns pipe-
			// delimited lines of data. When finished, UMIAC sends a single line
			// of "EOT".
			inString = in.readLine();
			while ((inString != null) && !inString.equalsIgnoreCase("EOT"))
			{
				// Fill up the vector with the strings being returned
				v.add(inString);
				
				// get the next line
				inString = in.readLine();
			}
		}
		catch (InterruptedIOException e)
		{
			// Catch problem if Umiac doesn't respond.  This approach will at least 
			// not leave us stuck waiting forever.
			log.warn("UMIAC: timeout on socket read: " + e.toString());
		}
		catch (Throwable e)
		{
			log.warn("UMIAC: " + e.toString());
		}
		finally
		{
			// Close all the m_sockets, regardless of what happened
			try
			{
				if (in != null) in.close();
				if (out != null) out.close();
				if (socket != null) socket.close();
			}
			catch (Exception ignore){log.warn("UMIAC: " + ignore);}
		}
		
		if (log.isDebugEnabled())
		{
			log.debug( this + ".results: " + v);
		}
		
		return v;
	
	}	// makeRawCall
	
}	// class UmiacClient

/**********************************************************************************/
