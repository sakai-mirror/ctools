/**********************************************************************************
 * $URL: https://source.sakaiproject.org/svn/web/tags/sakai_2-5-0_RC_04a/news-api/api/src/java/org/sakaiproject/news/api/NewsConnectionException.java $
 * $Id: NewsConnectionException.java 8312 2006-04-26 02:55:39Z ggolden@umich.edu $
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

package org.sakaiproject.news.api;

/**
 * <p>
 * NewsConnectionException is thrown whenever the NewsService is unable to make a connection or obtain a file specified by a source URL.
 * </p>
 */
public class NewsConnectionException extends Exception
{
	public NewsConnectionException(String message)
	{
		super(message);
	}
}
