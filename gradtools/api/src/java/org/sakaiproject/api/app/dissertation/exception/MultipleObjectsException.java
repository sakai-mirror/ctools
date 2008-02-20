package org.sakaiproject.api.app.dissertation.exception;

/**
 * An exception thrown when there is more than 1 object
 * for a user id.
 * 
 * @author rwellis@umich.edu
 */
public class MultipleObjectsException extends RuntimeException {
	
	private static final long serialVersionUID = -8588237050380289434L;
	
	public MultipleObjectsException(String id, String className) {
		super("Multiple objects of type " + className + " for user " + id + " exist");
	}
}
