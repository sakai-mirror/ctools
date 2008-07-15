package org.sakaiproject.util.api.umiac;


import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.user.api.UserEdit;

public interface UmiacConnector {

	/**
	 * Sets the port for the target UMIAC server.
	 * @param port The UMIAC port.
	 */
	public abstract void setPort(int port); // setPort

	/**
	 * Gets the port for the target UMIAC server.
	 * @return The UMIAC port
	 */
	public abstract int getPort(); // getPort

	/**
	 * Sets the host name for the target UMIAC server.
	 * @param host The UMIAC host name.
	 */
	public abstract void setHost(String host); // setHost

	/**
	 * Gets the host name for the target UMIAC server.
	 * @return The host name for UMIAC.
	 */
	public abstract String getHost(); // getHost
	
	/*
	 * Set a time out so don't wait forever if Umiac
	 * isn't working.
	 */
	public void setUmiacSocketTimeout(int umiacSocketTimeout);

	
//	/**
//	 * get the term index table
//	 */
//	public Hashtable<String, String> getTermIndexTable();
//	
}