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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.tbook.logic.ExternalLogic;
import org.sakaiproject.tbook.logic.TextbookLogic;
import org.sakaiproject.tbook.model.Book;
import org.sakaiproject.tbook.model.Course;
import org.sakaiproject.tbook.model.CourseBook;
import org.sakaiproject.tbook.model.CourseBookStatus;
import org.sakaiproject.tbook.model.CourseItem;
import org.sakaiproject.tbook.model.CourseMaterials;
import org.sakaiproject.tbook.provider.TextbookProvider;
import org.sakaiproject.util.api.umiac.UmiacClient;

/**
 * UnivOfMichTextbookProvider 
 *
 */
public class UnivOfMichTextbookProvider implements TextbookProvider 
{
	private static Log logger = LogFactory.getLog(UnivOfMichTextbookProvider.class);

	protected TextbookLogic logic;
	public void setLogic(TextbookLogic logic) 
	{
		this.logic = logic;
	}
	
	protected ExternalLogic externalLogic;
	public void setExternalLogic(ExternalLogic externalLogic)
	{
		this.externalLogic = externalLogic;
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
		Course course = null;
		
		JSONObject jsonObject = getJsonObject(courseId);
		if(jsonObject == null || jsonObject.isNullObject() || jsonObject.isEmpty())
		{
			// skip this one
		}
		else
		{
			course = getCourseFromJsonObject(jsonObject);
		}

		return course;
	}

	/* (non-Javadoc)
	 * @see org.sakaiproject.tbook.provider.TextbookProvider#getCourseFromProviderFirst(java.lang.String)
	 */
	public boolean getCourseFromProviderFirst(String courseId) 
	{
		return true;
	}
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.tbook.provider.TextbookProvider#getCourses(java.lang.String, java.lang.String)
	 */
	public List<Course> getCourses(String userEid, String term) 
	{
		logger.debug("term == " + term);
		List<Course> courses = null;
		try 
		{
			Map termIndex = this.umiacClient.getTermIndexTable();
			String year = null;
			String term_code = null;
			String parts[] = term.split("\\s+");
			if(parts != null && parts.length > 1)
			{
				year = parts[1];
				term_code = (String) termIndex.get(parts[0].toUpperCase());
				List<String> jsonStrings = this.umiacClient.getUserTextbookInfo(userEid, year, term_code);
				if(jsonStrings != null)
				{
					for(String jsonString : jsonStrings)
					{
						JSONObject jsonObject = JSONObject.fromObject(jsonString);
						if(jsonObject == null || jsonObject.isNullObject() || jsonObject.isEmpty())
						{
							// skip this one
						}
						else
						{
							Course course = this.getCourseFromJsonObject(jsonObject);
							if(course != null)
							{
								if(courses == null)
								{
									courses = new ArrayList<Course>();
								}
								courses.add(course);
							}
						}
					}
				}
			} 
		}	
		catch (IdUnusedException e) 
		{
			logger.warn("UnivOfMichTextbookProvider.getCourses --> IdUnusedException ", e);
		}
		return courses;
	}

	/* (non-Javadoc)
	 * @see org.sakaiproject.tbook.provider.TextbookProvider#getCoursesFromProviderFirst(java.lang.String, java.lang.String)
	 */
	public boolean getCoursesFromProviderFirst(String userEid, String term) 
	{
		// TODO method stub for getCoursesFromProviderFirst
		return true;
	}


	/**
	 * @param courseId
	 * @return
	 */
	protected JSONObject getJsonObject(String courseId) 
	{
		JSONObject jsonObject = null;
		if(courseId != null && ! courseId.trim().equals(""))
		{
			String parts[] = courseId.split(",");
			if(parts.length < 5)
			{
				return jsonObject;
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
				
				jsonObject = JSONObject.fromObject(jsonString);
				if(jsonObject == null)
				{
					logger.warn("UnivOfMichTextbookProvider.loadCourseFromFile --> Error reading json object from string:\n" + jsonString);
				}
				else
				{
					logger.debug("UnivOfMichTextbookProvider.loadCourseFromFile --> successfully read a jsonObject:\n" + jsonObject.toString());
				}
			} 
			catch(Exception e)
			{
				logger.warn("UnivOfMichTextbookProvider.loadCourseFromFile --> Exception file: " + "", e);
				
			}
		}
		return jsonObject;
	}
	
	/**
	 * @param jsonObject
	 * @return
	 */
	protected Course getCourseFromJsonObject(JSONObject jsonObject) 
	{
		Course course = new Course();
		
		try
		{
			String year = jsonObject.getString("year");
			String campus = jsonObject.getString("campus");
			String subject = jsonObject.getString("subject");
			String catalog_nbr = jsonObject.getString("catalog_nbr");
			String term = jsonObject.getString("term");
			String class_section = jsonObject.getString("class_section");
			
			String courseId = year + "," + term + "," + campus + "," + subject + "," + catalog_nbr + "," + class_section;
			course.setCourseId(courseId );
			
			//int textbook_item_number = jsonObject.getInt("textbook_item_number");
			try
			{
				String same_as = jsonObject.getString("same_as");
			}
			catch(Exception e)
			{
				// ignore
			}
			String title = subject + "-" + catalog_nbr + " " + class_section;
			try
			{
				String class_title = jsonObject.getString("class_title");
				if(class_title != null && ! class_title.trim().equals(""))
				{
					title += " - " + class_title;
				}
			}
			catch(Exception e)
			{
				// ignore
			}
			course.setTitle(title );
			try
			{
				String has_books = jsonObject.getString("has_books");
			}
			catch(Exception e)
			{
				// ignore
			}
			
			
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
				SortedMap<String,CourseItem> itemMap = new TreeMap<String, CourseItem>();
				for(int i = 0; i < required_items.size(); i++)
				{
					CourseItem newItem = null;
					String sortStr = "";
					JSONObject item = required_items.getJSONObject(i);
					
					String item_type = item.getString("item_type");
					if(item_type != null && item_type.trim().toLowerCase().equals("book"))
					{
						sortStr += "0";
					}
					else
					{
						sortStr += "1";
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
					CourseBookStatus status = CourseBookStatus.REQUIRED;
					if(item.has("required"))
					{
						try
						{
							String statusStr = item.getString("required");
							if(statusStr == null)
							{
								// ignore -- assume it's required
								sortStr += "0";
							}
							else if(statusStr.trim().toLowerCase().equals("rec"))
							{
								status = CourseBookStatus.RECOMMENDED;
								sortStr += "1";
							}
							else if(statusStr.trim().toLowerCase().equals("opt"))
							{
								status = CourseBookStatus.OPTIONAL;
								sortStr += "2";
							}
							else if(statusStr.trim().toLowerCase().equals("avd"))
							{
								status = CourseBookStatus.AVOID;
								sortStr += "3";
							}
							else
							{
								// ignore -- assume it's required
								sortStr += "0";
							}
						}
						catch (Exception e)
						{
							// ignore -- assume it's required
							sortStr += "0";
						}
					}
					else
					{
						// ignore -- assume it's required
						sortStr += "0";
						
					}
					
					boolean late_use = false;
					try
					{
						late_use = item.getBoolean("late_use");
					}
					catch(Exception e)
					{
						// ignore -- let "late_use" remain false 
					}
					if(late_use)
					{
						sortStr += "1";
					}
					else
					{
						sortStr += "0";
					}
	
					if(item_type != null && item_type.trim().toLowerCase().equals("book"))
					{
						String isbn = item.getString("isbn");
						List<Book> bookmatches = logic.getBooks(isbn);
						if(bookmatches == null || bookmatches.isEmpty())
						{
							// need to log this as an invalid book?
							logger.warn("Could not find book (ISBN: " + isbn + ") for course: ");
							continue;
						}
						else
						{
							newItem = new CourseBook();
							CourseBook newBook = (CourseBook) newItem;
							
							Book book = bookmatches.get(0);
							newBook.setIsbn(book.getIsbn());
							
							boolean reserve_requested = false;
							try
							{
								reserve_requested = item.getBoolean("on_reserve");
							}
							catch(Exception e)
							{
								// ignore -- let reserve_requested remain false
							}
							newBook.setLibraryReserveRequested(reserve_requested);
							
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
							newBook.setPreferredBookseller(preferredBookseller);
							
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
								logger.debug("Problem reading price: " + val + " --> " + e);
							}
							newBook.setRetailPrice(retailPrice);
							//course.addBook(book, item_comment, status, late_use, reserve_requested, preferredBookseller, retailPrice);
						}
					}
					else
					{
						newItem = new CourseMaterials();
						CourseMaterials newMaterials = (CourseMaterials) newItem;
						
						String description = item.getString("description");
						newMaterials.setDescription(description);
						
						//course.addMaterials(description, item_comment, status, late_use);
					}
					if(newItem == null)
					{
						continue;
					}
					newItem.setLateUse(late_use);
					newItem.setNotes(item_comment);
					newItem.setStatus(status);
					newItem.setCourse(course);
					
					if(item.has("seqnum"))
					{
						String seqnum = item.getString("seqnum");
						if(seqnum != null)
						{
							sortStr += seqnum.trim();
						}
					}
					itemMap.put(sortStr, newItem);
				}
				for(String key : itemMap.keySet())
				{
					CourseItem newItem = itemMap.get(key);
					if(newItem instanceof CourseBook)
					{
						course.addBook((CourseBook) newItem);
					}
					else // if(newItem instanceof CourseMaterials)
					{
						course.addMaterials((CourseMaterials) newItem);
					}
				}
			}
			course.setComment(course_comment);
		}
		catch(JSONException e)
		{
			logger.warn("Exception parsing JSON Object:\n" + jsonObject, e);
		}
		return course;
	}

	public void init()
	{
		logger.info("init()");
		this.logic.registerProvider(this);
	}

}
