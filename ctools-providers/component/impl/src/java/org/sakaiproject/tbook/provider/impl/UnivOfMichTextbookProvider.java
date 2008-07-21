/**
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2008 The Sakai Foundation.
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

package org.sakaiproject.tbook.provider.impl;

import java.math.BigDecimal;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.tbook.logic.TextbookLogic;
import org.sakaiproject.tbook.model.Book;
import org.sakaiproject.tbook.model.Course;
import org.sakaiproject.tbook.model.CourseBookStatus;
import org.sakaiproject.tbook.provider.TextbookProvider;
import org.sakaiproject.util.api.umiac.UmiacClient;

/**
 * UnivOfMichTextbookProvider 
 *
 */
public class UnivOfMichTextbookProvider implements TextbookProvider 
{
	private static Log logger = LogFactory.getLog(UnivOfMichTextbookProvider.class);

	private TextbookLogic logic;
	public void setLogic(TextbookLogic logic) 
	{
		this.logic = logic;
	}
	
	protected UmiacClient umiacClient;
	public void setUmiacClient(UmiacClient umiacClient) 
	{
		this.umiacClient = umiacClient;
	}

	/* (non-Javadoc)
	 * @see org.sakaiproject.tbook.provider.TextbookProvider#getCourse(java.lang.String)
	 */
	public Course getCourse(String courseId) 
	{
		Course course = loadCourseFromFile(courseId);
		return course;
	}

	/* (non-Javadoc)
	 * @see org.sakaiproject.tbook.provider.TextbookProvider#getCourseFromProviderFirst(java.lang.String)
	 */
	public boolean getCourseFromProviderFirst(String courseId) 
	{
		return true;
	}

	/**
	 * @param courseId
	 * @return
	 */
	protected Course loadCourseFromFile(String courseId) 
	{
		Course course = null;
		if(courseId != null && ! courseId.trim().equals(""))
		{
			String parts[] = courseId.split(",");
			if(parts.length < 5)
			{
				return course;
			}
			String year = parts[0];
			String term = parts[1];
			String campus = parts[2]; 
			String subject = parts[3];
			String catalog_nbr = parts[4];
			String class_section = parts[5];
			try 
			{
				String jsonString = this.umiacClient.getClassTextbookInfo(year,term,campus,subject,catalog_nbr,class_section);
				
				JSONObject jsonObject = JSONObject.fromObject(jsonString);
				if(jsonObject == null)
				{
					logger.warn("UnivOfMichTextbookProvider.loadCourseFromFile --> Error reading json object from string:\n" + jsonString);
				}
				else
				{
					logger.info("UnivOfMichTextbookProvider.loadCourseFromFile --> successfully read a jsonObject:\n" + jsonObject.toString());
					
					course = getCourseFromJSON(jsonObject);
				}
			} 
			catch(Exception e)
			{
				logger.warn("UnivOfMichTextbookProvider.loadCourseFromFile --> Exception file: " + "", e);
				
			}
		}
		return course;
	}
	
	/**
	 * @param jsonObject
	 * @return
	 */
	protected Course getCourseFromJSON(JSONObject jsonObject) 
	{
		Course course = new Course();
		
		String year = jsonObject.getString("year");
		int textbook_item_number = jsonObject.getInt("textbook_item_number");
		String campus = jsonObject.getString("campus");
		String subject = jsonObject.getString("subject");
		String catalog_nbr = jsonObject.getString("catalog_nbr");
		String term = jsonObject.getString("term");
		String class_section = jsonObject.getString("class_section");
		
		String courseId = year + "," + term + "," + campus + "," + subject + "," + catalog_nbr + "," + class_section;
		course.setCourseId(courseId );
		
		String title = subject + "-" + catalog_nbr + " " + class_section;
		course.setTitle(title );
		
		try
		{
			String coursepack_location = jsonObject.getString("coursepack_location");
			course.setCoursepackLocation(coursepack_location);
		}
		catch(Exception e)
		{
			// ignore -- no coursepack location
		}
		
		String course_comment = null;
		
		try
		{
			course_comment = jsonObject.getString("textbook_note");
		}
		catch (Exception e)
		{
			// ignore -- let comment remain null
		}
		
		if(course_comment == null)
		{
			course_comment = "";
		}
		course_comment = course_comment.trim();
		
		JSONArray required_items = jsonObject.getJSONArray("required_items");
		if(required_items == null)
		{
			course_comment += "\n" + "No textbooks required for this course";
		}
		else
		{
			for(int i = 0; i < required_items.size(); i++)
			{
				JSONObject item = required_items.getJSONObject(i);
				
				boolean late_use = false;
				try
				{
					late_use = item.getBoolean("late_use");
				}
				catch(Exception e)
				{
					// ignore -- let "late_use" remain false 
				}
				
				String item_comment = null;
				try
				{
					item_comment = item.getString("comments");
				}
				catch(Exception e)
				{
					// ignore -- let comments remain null
				}

				String item_type = item.getString("item_type");
				if(item_type != null && item_type.trim().toLowerCase().equals("book"))
				{
					String isbn = item.getString("isbn");
					List<Book> bookmatches = logic.getBooks(isbn);
					if(bookmatches == null || bookmatches.isEmpty())
					{
						// need to log this as an invalid book?
						logger.warn("Could not find book (ISBN: " + isbn + ") for course: ");
					}
					else
					{
						Book book = bookmatches.get(0);
						
						boolean reserve_requested = false;
						try
						{
							reserve_requested = item.getBoolean("on_reserve");
						}
						catch(Exception e)
						{
							// ignore -- let reserve_requested remain false
						}
						
						String preferredBookseller = null;
						try
						{
							preferredBookseller = item.getString("preferred_vendor");
							if(preferredBookseller == null || preferredBookseller.trim().equals("") || preferredBookseller.trim().toLowerCase().equals("null"))
							{
								preferredBookseller = null;
							}
						}
						catch(Exception e)
						{
							// ignore -- let preferredBookseller remain null
						}
						
						BigDecimal retailPrice = null;
						String val = null;
						try
						{
							val = item.getString("msrp");
							retailPrice = new BigDecimal(val);
						}
						catch(Exception e)
						{
							// ignore -- let price remain null
							logger.warn("Problem reading price: " + val + " --> " + e);
						}
						
						course.addBook(book, item_comment, CourseBookStatus.REQUIRED, late_use, reserve_requested, preferredBookseller, retailPrice);
					}
				}
				else
				{
					String description = item.getString("description");
					
					course.addMaterials(description, item_comment, CourseBookStatus.REQUIRED, late_use);
				}
			}
		}
		course.setComment(course_comment);
		return course;
	}

	public void init()
	{
		logger.info("init()");
	}

}
