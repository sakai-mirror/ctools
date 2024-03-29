/**********************************************************************************
 * $URL$
 * $Id$
 **********************************************************************************
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

package org.sakaiproject.component.app.dissertation;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.quartz.JobDataMap;
import org.quartz.JobDetail;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import org.sakaiproject.api.app.dissertation.CandidateInfoEdit;
import org.sakaiproject.api.app.dissertation.CandidatePath;
import org.sakaiproject.api.app.dissertation.CandidatePathEdit;
import org.sakaiproject.api.app.dissertation.Dissertation;
import org.sakaiproject.api.app.dissertation.StepStatus;
import org.sakaiproject.api.app.dissertation.StepStatusEdit;
import org.sakaiproject.api.app.dissertation.cover.DissertationService;
import org.sakaiproject.api.app.dissertation.exception.MultipleObjectsException;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.exception.InUseException;
import org.sakaiproject.exception.PermissionException;
import org.sakaiproject.time.api.Time;
import org.sakaiproject.time.api.TimeBreakdown;
import org.sakaiproject.time.cover.TimeService;
import org.sakaiproject.tool.api.Session;
import org.sakaiproject.tool.cover.SessionManager;
import org.sakaiproject.user.api.UserNotDefinedException;
import org.sakaiproject.user.cover.UserDirectoryService;
import org.sakaiproject.util.StringUtil;
import org.sakaiproject.util.Web;

/**
 * <p>
 * Uses Rackham Graduate School institutional data to create new CandidatePath
 * objects and set the status of StepStatus objects.
 * </p>
 * 
 * @author University of Michigan, Sakai Software Development Team
 * @version $Revision: $
 */
public class UploadExtractsJobImpl implements UploadExtractsJob
{
	private static final Log m_logger = LogFactory.getLog(UploadExtractsJobImpl.class);
	private static final Log metric = LogFactory.getLog("metrics." + UploadExtractsJobImpl.class.getName());
	private final int METRIC_INTERVAL = 500;
	private String jobName;
	private StringBuffer buf;
	private JobDetail jobDetail;
	private JobDataMap dataMap;
	private JobAnnouncement announcement;
	private Calendar cal;
	private SimpleDateFormat formatter;

	//key = emplid, value = uniqname (campus_id, Sakai eid)
	private Hashtable ids;

	List OARDRecords;
	List MPRecords;
	
	//execution parameters
	private String m_currentUser;
	private String m_oardFileName;
	private String[] m_oardRecords;
	private String m_mpFileName;
	private String[] m_mpRecords;
	
	//TODO get from ServerConfiguration
	private String m_musicPerformanceSite;
	
	/** Holds the School administrative Block Grant Group numbers. */
	protected Hashtable m_schoolGroups;
	
	/** regular expressions used in data validation **/
	Matcher matcher;
	
	static final String NEWLINE = Web.escapeHtmlFormattedText("<br/>");
	static final String START_ITALIC = Web.escapeHtmlFormattedText("<i>");
	static final String END_ITALIC = Web.escapeHtmlFormattedText("</i>");
	
	//general patterns
	private static final Pattern  m_patternDate = Pattern.compile("(^([0-9]|[0-9][0-9])/([0-9]|[0-9][0-9])/[0-9]{4}$|)");
	
	//required (not null) data common to both database extracts
	private static final Pattern m_patternUMId = Pattern.compile("^\"[0-9]{8}\"$");
	private static final Pattern m_patternCampusId = Pattern.compile("(^\"[A-Za-z0-9]{1,8}\"\r?$)|(^\".+@.+\"\r?$)");
	 
	//MPathways fields
	private static final Pattern m_patternAcadProg = Pattern.compile("(^\"[0-9]{5}\"$|^\"\"$)");
	private static final Pattern m_patternAnticipate = Pattern.compile("(^\"[A-Z]{2}[- ][0-9]{4}\"$|^\"[A-Za-z]*( |,)[0-9]{4}\"$|^\"\"$)");
	private static final Pattern m_patternDateCompl = Pattern.compile("(^([0-9]|[0-9][0-9])/([0-9]|[0-9][0-9])/[0-9]{4}$|)");
	private static final Pattern m_patternMilestone = Pattern.compile("(^\"[A-Za-z]*\"$|^\"\"$)");
	private static final Pattern m_patternAcademicPlan = Pattern.compile("(^\"[0-9]{4}[A-Z0-9]*\"|^\"[0-9]{4}[A-Z0-9]*\"\r?$|^\"\"$|^\"\"\r?$)");
	private static final Pattern m_patternRole = Pattern.compile("(^\".*\"$|^\"\"$|^\"#EMPTY\"$)"); //not restrictive
	//private static final Pattern m_patternMember = Pattern.compile("(^\"[A-Z]([- A-Za-z])+,[A-Z]([- A-Za-z])+\"$|^\"\"$|^\"#EMPTY\"$)");
	private static final Pattern m_patternMember = Pattern.compile("(^\".*\"$|^\"\"$|^\"#EMPTY\"$)"); //not restrictive
	private static final Pattern m_patternEvalDate = Pattern.compile("(^\"([0-9]|[0-9][0-9])/([0-9]|[0-9][0-9])/([0-9]{4}).*\"$|^\"([0-9]|[0-9][0-9])/([0-9]|[0-9][0-9])/([0-9]{4}).*\"$|^\"#EMPTY\"$|^\"\"$|)");
	private static final Pattern m_patternCommitteeApprovedDate = Pattern.compile("(^\"([0-9]|[0-9][0-9])/([0-9]|[0-9][0-9])/([0-9]{4}).*\"$|^\"([0-9]|[0-9][0-9])/([0-9]|[0-9][0-9])/([0-9]{4}).*\"\r$|^\"#EMPTY\"\r$|^\"\"\r$|)");
		
	//Office of Academic Records and Dissertations fields
	private static final Pattern m_patternFOS = Pattern.compile("(^\"[0-9]{4}\"$|^\"\"$)");
	private static final Pattern m_patternDegreeTermTrans = Pattern.compile("(^\"[A-Za-z]{2}( |-)[0-9]{4}\"$|^\"\"$)");
	private static final Pattern m_patternOralExamTime = Pattern.compile("(^\".*\"$|^\"\"$)"); //not restrictive
	private static final Pattern m_patternOralExamPlace = Pattern.compile("(^\".*\"$|^\"\"$)"); //not restrictive


	/* (non-Javadoc)
	 * @see org.quartz.Job#execute(org.quartz.JobExecutionContext)
	 */
	public void execute(JobExecutionContext context) throws JobExecutionException 
	{
		//collecting parameter pattern for collecting results
		List collecting = new ArrayList();
		
		//validation error
		boolean vErrors = false;
		//loading error
		boolean lErrors = false;
		
		//execute() is the main method of a Quartz job
		try
		{
			if(m_logger == null)
				System.out.println(this + ".execute() couldn't get a logger");

			init();
			
			Session s = SessionManager.getCurrentSession();
			if (s != null)
				s.setUserId(UserDirectoryService.ADMIN_ID);
			else
				if(m_logger.isWarnEnabled())
					m_logger.warn(this + ".execute() could not setUserId to ADMIN_ID");
		
			//get the job detail
			jobDetail = context.getJobDetail();
			jobName = jobDetail.getName();
			dataMap = jobDetail.getJobDataMap();
			if(jobDetail == null)
				if(m_logger.isWarnEnabled())
					m_logger.warn(this + ".execute() jobDetail is null");
			
			//make sure we can report on the job's execution
			announcement = new JobAnnouncement(jobDetail);
			if(announcement == null)
				if(m_logger.isWarnEnabled())
					m_logger.warn(this + ".execute() could not get instance of JobAnnouncement");
			
			//set job execution parameters
			setJobExecutionParameters(context, collecting);
			
			//TODO make sure we have permission
			
			//TODO methods to
			//validate String[]'s
			//set CandidateInfo's
			//set StepStatus's
			
			//Note: either one or two extract files might have been uploaded
			if(m_oardFileName != null && m_oardFileName.length()>0)
				collecting.add("The OARD Upload File is '" + m_oardFileName + "'."  + NEWLINE);
				
			if(m_mpFileName != null && m_mpFileName.length()>0)
				collecting.add("The MP Upload File is '" + m_mpFileName + "'." + NEWLINE);
		
			collecting.add(getTime() + " JOB NAME: " + jobName + " - START" + NEWLINE);
				
			if(metric.isInfoEnabled())
				metric.info("METRIC "+ jobName + " - START " + getTime());
		
			//validate the String[]'s passed as job detail data
			if(m_oardRecords != null && m_oardRecords.length > 0)
				vErrors = createOARDRecords(m_oardRecords, collecting);
			
			if(m_mpRecords != null && m_mpRecords.length > 0)
				vErrors = createMPRecords(m_mpRecords, collecting);
			
			//if there are no validation errors, convert and use the data
			if(!vErrors)
			{
				collecting.add("There were no validation errors, so the data will be used to update checklist status." + NEWLINE);
				
				if(metric.isInfoEnabled())
					metric.info("METRIC " + jobName + " - There were no validation errors, so the data will be used to update checklist status. " + getTime());
				
				//if we have no ids at this point bail out
				if(!ids.elements().hasMoreElements())
				{
					//note exception in job execution report
					collecting.add(getTime() + " " + jobName + " exception - no employee id-uniquename map" + NEWLINE);
				}
				
				/** for each id in ids, use data to initialize 
				 * and update CandidateInfo, add to Collection
				 * and at end pass Collection to dumpData(data)
				 * returning alerts etc.*/
				
				//load the extract data to update path step status
				lErrors = queryLists(OARDRecords, MPRecords, ids, collecting);
				
			}
			else
			{	
				//there were validation errors, don't process the data until it's been fixed
				collecting.add(getTime() + " JOB NAME: " + jobName + " - data validation errors" + NEWLINE);
				collecting.add("Because there were validation errors, the data have not be used to update checklist status." + NEWLINE);
				collecting.add("Please correct the errors and upload the data again." + NEWLINE);
				
				if(metric.isInfoEnabled())
					metric.info("METRIC " + jobName + " - Because there were validation errors, the data have not be used to update checklist status. " + getTime());
			}
		}
		catch(Exception e)
		{
			//note exception in job execution report
			collecting.add(getTime() + " JOB NAME: " + jobName + " exception - " + e  + NEWLINE);
			
			if(m_logger.isWarnEnabled())
				m_logger.warn(getTime() + " " + jobName + " exception - " + e  + NEWLINE);
		}
		finally
		{
			
			//note that job is done
			collecting.add(getTime() + " JOB NAME: " + jobName + " - DONE" + NEWLINE);
			if(lErrors)
				collecting.add("Note: There were errors loading data which require attention." + NEWLINE);
			
			if(metric.isInfoEnabled())
				metric.info("METRIC " + jobName + " - DONE " + getTime());
			
			//clean up lock at the end
			try
			{
				CandidateInfoEdit lock = DissertationService.editCandidateInfo(DissertationService.IS_LOADING_LOCK_REFERENCE);
				if(lock != null && lock.isActiveEdit())
					DissertationService.removeCandidateInfo(lock);
			}
			catch(Exception e)
			{
				if(m_logger.isWarnEnabled())
					m_logger.warn(this + ".execute() removeCandidateInfo(lock) " + e);
				collecting.add(getTime() + " JOB NAME: " + jobName + " exception removing lock " + e + NEWLINE);
			}
			
			//send report of job execution to Announcements
			String announce = null;
			try
			{
				StringBuffer results = new StringBuffer();
				for (int i = 0; i < collecting.size(); i++) {
					results.append((String)collecting.get(i));
				}
				announce = new String(results.toString());
				if(announce != null && !announce.equals(""))
					announcement.addAnnouncementMessage(announce);
			}
			catch(Exception e)
			{
				if(m_logger.isWarnEnabled())
					m_logger.warn(this + ".execute() addAnnouncementMessage " + e);
			}
			if(metric.isInfoEnabled())
				metric.info("METRIC " + jobName + " - execution complete. " + getTime());
		}
	}
	
	protected boolean setJobExecutionParameters(JobExecutionContext context, List collecting)
	{
		m_musicPerformanceSite = DissertationService.getMusicPerformanceSite();
		
		//get job execution parameters from job data map
		m_currentUser = (String)dataMap.get("CURRENT_USER");
		m_schoolGroups = (Hashtable)dataMap.get("SCHOOL_GROUPS");
		m_oardFileName = (String)dataMap.get("OARD_FILE_NAME");
		m_oardRecords = (String[])dataMap.get("OARD_RECORDS");
		m_mpFileName = (String)dataMap.get("MP_FILE_NAME");
		m_mpRecords = (String[])dataMap.get("MP_RECORDS");
		if(m_currentUser == null || m_schoolGroups == null)
		{
			collecting.add("One or more of the required job execution parameters was null." + NEWLINE);
			return false;
		}
		return true;
	}
	
	/**
	* Access the alphabetical candidate chooser letter for this student. 
	* @param chefid � The user's id.
	* @return The alphabetical candidate chooser letter, A-Z, or "".
	*/
	public String getSortLetter(String chefId)
	{
		String retVal = "";
		if(chefId != null)
		{
			try
			{
				//chefId has been converted to id
				String sortName = UserDirectoryService.getUser(chefId).getSortName();
				if(sortName != null)
				{
					retVal = sortName.substring(0,1).toUpperCase();
				}
			}
			catch(UserNotDefinedException e) 
			{
				m_logger.warn(this + ".getSortLetter for " + chefId + " " + e.toString());
			}
			catch(Exception e)
			{
				m_logger.warn(this + ".getSortLetter for " + chefId + " Exception " + e.toString());
			}
		}
		return retVal;
		
	}
	
	protected String getTime()
	{
		String now = null;
		long millis = System.currentTimeMillis();
		cal.setTimeInMillis(millis);
		now = formatter.format(cal.getTime());
		return now;
	}
	
	/**
	* Create a Time object from the raw time string.
	* Based on DissertationDataListenerService.parseOracleTimeString()
	* @param timeString The raw oracle time string.
	* @return The CHEF Time object.
	*/
	protected Time parseTimeString(String timeString)
	{
		Time retVal = null;
		if(timeString != null && !timeString.equals(""))
		{
			int year = 0;
			int month = 0;
			int day = 0;
			String[] parts = timeString.split("/");
			String[] yearParts = new String[2];
			for(int x = 0; x < parts.length; x++)
			try
			{
				if(parts[2].indexOf(" ")!= -1)
				{
					//"1/11/2006 0:00"
					yearParts = parts[2].split(" ");
					year = Integer.parseInt(yearParts[0]);
				}
				else
					year = Integer.parseInt(parts[2]);
			}
			catch(NumberFormatException nfe)
			{
				m_logger.warn("DISSERTATION : SERVICE: PARSE TIME STRING : YEAR : NumberFormatException  " + timeString);
			}
			
			try
			{
				month = Integer.parseInt(parts[0]);
			}
			catch(NumberFormatException nfe)
			{
				m_logger.warn("DISSERTATION : SERVICE: PARSE TIME STRING : MONTH : NumberFormatException  " + timeString);
			}
			
			try
			{
				day = Integer.parseInt(parts[1]);
			}
			catch(NumberFormatException nfe)
			{
				m_logger.warn("DISSERTATION : SERVICE: PARSE TIME STRING : DAY : NumberFormatException  " + timeString);
			}
			TimeBreakdown tb = TimeService.newTimeBreakdown(year, month, day, 0, 0, 0, 0);
			retVal = TimeService.newTimeLocal(tb);
		}
		return retVal;
	}
	
	/**
	*
	* Parse, validate, and create Office of Academic Records and Dissertations (OARD) records
	* 
	* @param String[] lns - lines read from the OARD data extract file
	* @param List collecting parameter for collecting results
	* @return boolean - true if validation errors, false otherwise
	*/
	private boolean createOARDRecords(String[] lns, List collecting)
	{
		boolean replace = true;
		String message = "";
		String prefix = "";
		int lineNumber = 0;
		boolean vErrors = false;
		
		if(metric.isInfoEnabled())
			metric.info("METRIC " + lns.length + " records in the OARD extract file. " + getTime());
		
		//iterate though each line in the input file
		for (int i = 0; i < lns.length; i++)
		{
			try
			{
				//skip last line which contains a single hex value 0x1A
				if(lns[i].length() > 1)
				{
					//replace commas used as field separators, but leave commas within quoted fields
					StringBuffer bufL = new StringBuffer(lns[i]);
					for (int j = 0; j < ((String) lns[i]).length(); j++)
					{
						char ch = lns[i].charAt(j);
						if(ch == '"') 
							replace = !replace;
						if(ch == ',')
						{
							if(replace) 
								bufL.setCharAt(j, '%');
							else
								bufL.setCharAt(j, ch);
						}
						else
							bufL.setCharAt(j, ch);
					}
						
					String line = bufL.toString();
					bufL.setLength(0);
									
					//get the fields
					String[] flds = line.split("[%]");
					
					lineNumber = i + 1;
					prefix = "Source: OARD File: Location: line " + lineNumber + ", field ";
					message = "";
						
					//check that we have the right number of fields
					if((flds.length==14))
					{
						OARDRecord oard = new OARDRecord();
						
						//* 1 �  Emplid   �  A8 - Student's emplid
						matcher = m_patternUMId.matcher(flds[0]);
						if(!matcher.matches())
						{
							vErrors = true;
							collecting.add(prefix + "1  Explanation: umid = " + flds[0] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted field
							oard.m_umid = flds[0].substring(1,flds[0].length()-1);
						}
							
						//* 2 �  Fos      �  A4    - Students field of study code
						matcher = m_patternFOS.matcher(flds[1]);
						if(!matcher.matches())
						{
							vErrors = true;
							collecting.add(prefix + "2  Explanation:  fos = " + flds[1] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted field
							oard.m_fos = flds[1].substring(1,flds[1].length()-1);
						}
							
						//we are not checking lname or fname - these come from UMIAC
						
						//* 3 �  Lname    �  A25 - Students last name
						//strip quotation marks from quoted field
						oard.m_lname = flds[2].substring(1,flds[2].length()-1);
						
						//* 4 �  Fname    �  A30 - Students first name
						//strip quotation marks from quoted field
						oard.m_fname = flds[3].substring(1,flds[3].length()-1);
						
						//* 5 �  Degterm trans   �  A7 - Students degree term as TT-CCYY (e.g. FA-2003)
						matcher = m_patternDegreeTermTrans.matcher(flds[4]);
						if(!(flds[4] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "5  Explanation: degreeterm_trans = " + flds[4] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted field
							oard.m_degreeterm_trans = flds[4].substring(1,flds[4].length()-1);
						}
							
						//* 6 �  Oral exam date  �  D - Date of oral defense
						matcher = m_patternDate.matcher(flds[5]);
						if(!(flds[5] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "6  Explanation: oral_exam_date_time = " + flds[5] + NEWLINE);
						}
						else
						{
							oard.m_oral_exam_date = flds[5];
						}
							
						//* 7 �  Oral exam time  �  A7 - Time of oral defense
						matcher = m_patternOralExamTime.matcher(flds[6]);
						if(!(flds[6] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "7  Explanation: oral_exam_time = " + flds[6] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted field
							oard.m_oral_exam_time = flds[6].substring(1,flds[6].length()-1);
						}
							
						//* 8 �  Oral exam place �  A25 - Place of oral defense
						matcher = m_patternOralExamPlace.matcher(flds[7]);
						if(!(flds[7] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "8  Explanation: oral_exam_place = " + flds[7] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted field
							oard.m_oral_exam_place = flds[7].substring(1,flds[7].length()-1);
						}
						
						//*9 �  First format date  �  D - date of pre defense meeting in Rackham
						matcher = m_patternDate.matcher(flds[8]);
						if(!(flds[8] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "9  Explanation: first_format_date = " + flds[8] + NEWLINE);
						}
						else
						{
							oard.m_first_format_date = flds[8];
						}
						 
						//*10 �  Oral report return date �  D
						matcher = m_patternDate.matcher(flds[9]);
						if(!(flds[9] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "10  Explanation: oral_report_return_date = " + flds[9] + NEWLINE);
						}
						else
						{
							oard.m_oral_report_return_date = flds[9];
						}

						//*11 �  Degree conferred date �  D - date the degree was conferred in OARD system
						matcher = m_patternDate.matcher(flds[10]);
						if(!(flds[10] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "11  Explanation: degree_conferred_date = " + flds[10] + NEWLINE);
						}
						else
						{
							oard.m_degree_conferred_date = flds[10];	
						}
						
						//*12 �  Update date  �  D - date record was last modified
						matcher = m_patternDate.matcher(flds[11]);
						if(!(flds[11] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "12  Explanation: update_date = " + flds[11] + NEWLINE);
						}
						else
						{
							oard.m_update_date = flds[11];	
						}
							
						//*13 �  Comm cert date  �  D -
						matcher = m_patternDate.matcher(flds[12]);
						if(!(flds[12] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "13  Explanation: comm_cert_date = " + flds[12] + NEWLINE);
						}
						else
						{
							oard.m_comm_cert_date = flds[12];
						}
							 
						//*14 �  Campus id  �  A1-A8 - uniqname
						// eid in terms of Sakai
						matcher = m_patternCampusId.matcher(flds[13]);
						if(!(flds[13] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "14  Explanation: campus_id = " + flds[13] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted field
							if(flds[13].indexOf("\r") != -1)
								oard.m_campus_id = flds[13].substring(1,flds[13].length()-2);
							else
								oard.m_campus_id = flds[13].substring(1,flds[13].length()-1);
						}
							
						//check that there is a group roll-up code that matches this field of study value
						String field_of_study = flds[1].substring(1,flds[1].length()-1);
						String rollup = getProgram(field_of_study);
						
						//no matching group roll-up code
						if(rollup==null)
						{
							vErrors = true;
							collecting.add(prefix + "1  Explanation: fos " + field_of_study + " does not match an existing group roll-up code." + NEWLINE);
						}
						if(!vErrors)
						{
							//add a record
							OARDRecords.add(oard);
							
							//add a uniqname
							ids.put(oard.m_umid, oard.m_campus_id);
						}
					}
					else
					{
						//number of fields exception
						lineNumber = i + 1;
						message = "Source: OARD File: Location: line " + lineNumber + " Explanation: has " 
							+ flds.length + " fields: 14 expected.";
						if(m_logger.isInfoEnabled())
							m_logger.info(this + ".validateOARD: " + message);
						collecting.add(message);
					}
				}//contains a single hex value 0x1A
			}
			catch (Exception e)
			{
				message = "Source: OARD File: Explanation: unexpected problem: "  + e.getMessage();
				if(m_logger.isWarnEnabled())
					m_logger.warn(this + ".validateOARD: " + message);
				collecting.add(message);
				
				//keep going
				continue;
			}
		}//for each line in the input file
	
		return vErrors;
		
	}//create OARD records
	
	/**
	*
	* Parse, validate, and create MPathways (MP) records
	* 
	* @param String[] lns - lines read from the data extract file
	* @param List collecting parameter for collecting results
	* @return boolean - true if validation errors, false otherwise
	*/
	private boolean createMPRecords(String[] lns, List collecting)
	{
		boolean replace = true;
		String field_of_study = "";
		String message = "";
		String prefix = "";
		int lineNumber = 0;
		boolean vErrors = false;
		
		if(metric.isInfoEnabled())
			metric.info("METRIC " + lns.length + " records in the MPathways extract file. " + getTime());
		
		//for each line in the MPathways extract file
		for (int i = 0; i < lns.length; i++)
		{
			try
			{
				//skip last line which might contain a single hex 0x1A
				if(lns[i].length() > 1)
				{
					//replace commas used as field separators, but leave commas within quoted fields
					StringBuffer bufL = new StringBuffer(lns[i]);
					for (int j = 0; j < ((String) lns[i]).length(); j++)
					{
						char ch = lns[i].charAt(j);
						if(ch == '"') 
							replace = !replace;
						if(ch == ',')
						{
							if(replace) 
								bufL.setCharAt(j, '%');
							else
								bufL.setCharAt(j, ch);
						}
						else
							bufL.setCharAt(j, ch);
					}
						
					String line = bufL.toString();
					bufL.setLength(0);
									
					//get the fields
					String[] flds = line.split("[%]");
					
					lineNumber = i + 1;
					prefix = "Source: MP File: Location: line " + lineNumber + ", field ";
					message = "";

					//check that we have the right number of fields
					if(flds.length == 11)
					{
						MPRecord mp = new MPRecord();
						
						//* 1 �  Emplid   �  A8 - Student's emplid
						matcher = m_patternUMId.matcher(flds[0]);
						if(!matcher.matches())
						{
							vErrors = true;
							collecting.add(prefix + "1  Explanation: umid = " + flds[0] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted fields
							mp.m_umid = flds[0].substring(1,flds[0].length()-1);
						}
						
						//* 2 �  Acad_prog �  A9	| Academic Program Code
						matcher = m_patternAcadProg.matcher(flds[1]);
						if(!matcher.matches())
						{
							vErrors = true;
							collecting.add(prefix + "2  Explanation: acad_prog = " + flds[1] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted field
							mp.m_acad_prog = flds[1].substring(1,flds[1].length()-1);
						}
						
						//* 3 �  Anticipate_Anticipate_1 �  A15	| Adv to cand term code
						matcher = m_patternAnticipate.matcher(flds[2]);
						if(!(flds[2] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "3  Explanation: anticipate = " + flds[2] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted fields
							mp.m_anticipate = flds[2].substring(1,flds[2].length()-1);
						}
						
						//* 4 �  Date_compl �  D	| Date milestone was completed 
						matcher = m_patternDateCompl.matcher(flds[3]);
						if(!(flds[3] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "4  Explanation:  date_compl = " + flds[3] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted field
							mp.m_date_compl = StringUtil.trimToNull(flds[3]);
						}
						
						//* 5 �  Milestone �  A10	| name of milestone PRELIM or ADVCAND or DISSERT
						matcher = m_patternMilestone.matcher(flds[4]);
						if(!(flds[4] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "5  Explanation: milestone = " + flds[4] + NEWLINE);
						}
						else
						{
							//strip quotation marks from quoted field
							mp.m_milestone = flds[4].substring(1,flds[4].length()-1);
						}
						
						//* 6 | Academic plan |  A4	| Field of study and degree (e.g. 1220PHD1)
						matcher = m_patternAcademicPlan.matcher(flds[5]);
						if(!matcher.matches())
						{
							vErrors = true;
							collecting.add(prefix + "6  Explanation: academic_plan = " + flds[5] + NEWLINE);
						}
						else
						{
							//get the field of study part of the academic plan for roll-up
							mp.m_academic_plan = flds[5].substring(1,flds[5].length()-1);
							
							//get the field of study part of the academic plan for roll-up
							field_of_study = flds[5].substring(1,5);
						}

						if(flds[4].equalsIgnoreCase("\"DISSERT\""))
						{
							//* 7 | Committee role
							matcher = m_patternRole.matcher(flds[6]);
							if(!matcher.matches())
							{
								vErrors = true;
								collecting.add(prefix + "7  Explanation: role = " + flds[6] + NEWLINE);
							}
							else
							{
								//strip quotation marks from quoted field
								mp.m_role = flds[6].substring(1,flds[6].length()-1);
								if(mp.m_role.equals("#EMPTY"))
									mp.m_role = "";
							}
							
							//* 8 | Committee member name
							matcher = m_patternMember.matcher(flds[7]);
							if(!matcher.matches())
							{
								vErrors = true;
								collecting.add(prefix + "8  Explanation: member = " + flds[7] + NEWLINE);
							}
							else
							{
								//strip quotation marks from quoted field
								mp.m_member = flds[7].substring(1,flds[7].length()-1);
								if(mp.m_member.equals("#EMPTY"))
									mp.m_member = "";
							}
							
							//* 9 | Eval_recvd, e.g., "12/16/2005 0:0" "1/4/2006 0:00"
							matcher = m_patternEvalDate.matcher(flds[8]);
							if(!matcher.matches())
							{
								vErrors = true;
								collecting.add(prefix + "9  Explanation: eval_date = " + flds[8] + NEWLINE);
							}
							else
							{
								//strip quotation marks from quoted field
								mp.m_eval_date = flds[8].substring(1,flds[8].length()-1);
								if(mp.m_eval_date.equals("#EMPTY"))
									mp.m_eval_date = "";
							}
						}
						
						//*10  | Campus id  | A1-A8   | uniqname
						// eid in terms of Sakai
						matcher = m_patternCampusId.matcher(flds[9]);
						if(!matcher.matches())
						{
							vErrors = true;
							collecting.add(prefix + "10  Explanation: campus_id = " + flds[9] + NEWLINE);
						}
						else
						{
							mp.m_campus_id = flds[9].substring(1,flds[9].length()-1);
						}
						
						//* 11 �  Committee approved date �  D - date committee was approved
						matcher = m_patternCommitteeApprovedDate.matcher(flds[10]);
						if(!(flds[10] == null || matcher.matches()))
						{
							vErrors = true;
							collecting.add(prefix + "11  Explanation: committee_approved_date = " + flds[10] + NEWLINE);
						}
						else
						{
							if(flds[10].indexOf("\r") != -1)
								mp.m_committee_approved_date = flds[10].substring(1,flds[10].length()-2);
							else
								mp.m_committee_approved_date = flds[10].substring(1,flds[10].length()-1);
							if(mp.m_committee_approved_date.equals("#EMPTY"))
								mp.m_committee_approved_date = "";
						}
							
						//check that there is a group roll-up code that matches this field of study value
						String rollup = getProgram(field_of_study);
						
						//no matching group roll-up code
						if(rollup == null)
						{
							collecting.add(prefix + "1  Explanation: field of study " + field_of_study + 
									" does not match an existing group roll-up code."  + NEWLINE);
							vErrors = true;
						}
						//add a record
						if(!vErrors)
						{
							MPRecords.add(mp);
						
							//add a uniqname
							ids.put(mp.m_umid, mp.m_campus_id);
						}
					}
					else
					{
						//alert that there is not the right number of fields
						vErrors = true;
						lineNumber = i + 1;
						message = "Source: MP File: Location: line " + lineNumber + " Explanation: has " 
							+ flds.length + " fields: 10 expected." + NEWLINE;
						if(m_logger.isInfoEnabled())
							m_logger.info(this + ".validateMP: " + message);
						collecting.add(message  + NEWLINE);
					}
				}//not a line with a single hex 0x1A
			}
			catch (Exception e)
			{
				message = "Source: MP File: Explanation: unexpected problem with data: "  + e;
				if(m_logger.isWarnEnabled())
						m_logger.warn(this + ".createMPRecord: " + message);
				collecting.add(message + NEWLINE);
				
				//keep going
				continue;
			}
		}//for each line
	
		return vErrors;
		
	}//create MP records
	
	/**
	* Use uploaded data to initialize and update CandidateInfo
	* (based on DissertationDataListenerService.queryDatabase())
	* 
	* @param OARDRecs - Vector of OARDRecord type
	* @param  MPRecs - Vector of MPRecord type
	* @param  ids - Hashtable of umid keys and chefid elements
	* @return rv - a Vector of error messages
	*/
	private boolean queryLists(List OARDRecords, List MPRecords, Hashtable ids, List collecting)
	{
		Vector data = new Vector();
		List OARDrecs = new Vector();
		List MPrecs = new Vector();
		String oneEmplid = null;
		String chefId = null;
		String program = null;
		String msg = null;
		String committeeEvalCompleted = null;
		String name = "";
		CandidateInfoEdit infoEdit = null;
		boolean commitEdit = false, existsOARDrecs = false, existsMPrecs = false;
		Map membersEvals = new TreeMap();
		Collection requiredFrom = new Vector();
		boolean lErrors = false;
		
		//get all the emplids in the upload
		Enumeration emplids = ids.keys();
		if(emplids != null)
		{
			//for each emplid
			while(emplids.hasMoreElements())
			{
				commitEdit = false;
				committeeEvalCompleted = "";
				
				//get student's emplid
				oneEmplid = (String)emplids.nextElement();
				
				//clear recs for student between emplids
				OARDrecs.clear();
				MPrecs.clear();
				
				//get all the MP recs for this student
				if((MPRecords!=null) && (MPRecords.size() > 0))
				{
					for(ListIterator i = MPRecords.listIterator(); i.hasNext(); )
					{
						MPRecord rec = (MPRecord) i.next();
						if(rec.m_umid.equals(oneEmplid)) 
							MPrecs.add(rec);
					}
					if((MPrecs != null) && (MPrecs.size() > 0))
						existsMPrecs = true;
					else
						existsMPrecs = false;
				}
				//get all the OARD recs for this student
				if((OARDRecords != null) && (OARDRecords.size() > 0))
				{
					for(ListIterator i = OARDRecords.listIterator(); i.hasNext(); )
					{
						OARDRecord rec = (OARDRecord) i.next();
						if(rec.m_umid.equals(oneEmplid)) 
							OARDrecs.add(rec);
					}
					if((OARDrecs != null) && (OARDrecs.size() > 0)) 
						existsOARDrecs = true;
					else
						existsOARDrecs = false;
				}
				try
				{
					//get CandidateInfo for this student
					infoEdit = DissertationService.getCandidateInfoEditForEmplid(oneEmplid);
					if(infoEdit == null)
					{
						//there is no CandidateInfo for this student, so create one
						infoEdit = DissertationService.addCandidateInfo(jobName);
						//infoEdit = addCandidateInfoFromListener("datalistener");
						infoEdit.setEmplid(oneEmplid);
						
						//set flag to save it later
						commitEdit = true;
					}
					
					//chefId contains Sakai id, so we need to translate eid of upload to id
					try
					{
						//if old candidateinfo record has chefId = eid, update it to id
						//chefId = infoEdit.getChefId();
						//if(chefId.equals(""))
						//{
							//ids contain emplid, eid (campus_id, uniqname)
							chefId = UserDirectoryService.getUserId((String)ids.get(oneEmplid));
							if(chefId != null)
								infoEdit.setChefId(chefId);
							
							//set flag to save it later
							commitEdit = true;
						//}
					}
					catch(Exception e)
					{
						lErrors = true;
						collecting.add("Skipping student, exception checking emplid '" + oneEmplid + "': " + e + NEWLINE);
						continue;
					}
			
					//check for student's Field of Study
					try
					{
						//try to get it from CandidateInfo
						program = infoEdit.getProgram();
						
						//if we didn't get it
						if(program == null || program.equals(""))
						{
							//if we have OARD data for this student, try there
							if(existsOARDrecs)
							{
								//for each OARD rec for this student
								for(ListIterator i = OARDrecs.listIterator(); i.hasNext(); )
								{
									OARDRecord rec = (OARDRecord) i.next();
									if(rec.m_fos != null) 
										program = rec.m_fos;
								}
							}
							if(program != null && !program.equals(""))
							{
								//set student's program
								infoEdit.setProgram(getProgram(program));
								infoEdit.setParentSite("diss" +  getProgram(program));
							}
							else if(existsMPrecs)
							{
								//otherwise try getting it from the Field of Study part of Academic Plan
								for(ListIterator i = MPrecs.listIterator(); i.hasNext(); )
								{
										MPRecord rec = (MPRecord) i.next();
										if(rec.m_academic_plan != null) 
											program = rec.m_academic_plan.substring(0,4);
								}
								if(program != null && !program.equals(""))
								{
									//set student's program
									infoEdit.setProgram(getProgram(program));
									infoEdit.setParentSite("diss" +  getProgram(program));
								}
								else
								{
									lErrors = true;
									collecting.add("Skipping student, student '" + oneEmplid + "' no program found" + NEWLINE);
									continue;
								}	
							}
						}
							
						//set flag to save this edit later
						commitEdit = true;
						
					}//check for student's Field of Study
					catch(Exception e)
					{
						lErrors = true;
						collecting.add("Skipping student, student '" + oneEmplid + "'  exception checking for Field of Study: " + e +
								NEWLINE);
						continue;
					}
					
					//set CandidateInfo properties used later
					if(existsMPrecs)
					{
						//we have MPathways data for this student
						infoEdit.setMPRecInExtract(true);
						for(ListIterator i = MPrecs.listIterator(); i.hasNext(); )
						{
							MPRecord rec = (MPRecord) i.next();
						
							//	ANTICIPATE
							infoEdit.setAdvCandDesc(rec.m_anticipate);
						
							//	DATE_COMPL
							if(rec.m_milestone.equalsIgnoreCase("prelim"))
							{
								infoEdit.setPrelimTimeMilestoneCompleted(parseTimeString(rec.m_date_compl));
								infoEdit.setPrelimMilestone(rec.m_milestone);
							}
							else if(rec.m_milestone.equalsIgnoreCase("advcand"))
							{
								infoEdit.setAdvcandTimeMilestoneCompleted(parseTimeString(rec.m_date_compl));
								infoEdit.setAdvcandMilestone(rec.m_milestone);
							}
							else if(rec.m_milestone.equalsIgnoreCase("dissert"))
							{
								//	EVAL_DATE
								if(!rec.m_eval_date.equals(""))
									infoEdit.addTimeCommitteeEval(parseTimeString(rec.m_eval_date));
								
								//	COMMITTE_APPROVED_DATE
								infoEdit.setTimeCommitteeApproval(parseTimeString(rec.m_committee_approved_date));
								
								//Add Committee Members and their Role and Evaluation Dates
								if(rec.m_member != null && !rec.m_member.equals(""))
								{
									//CT-603 if possible reverse name parts for display, otherwise pass through as is
									if(rec.m_member.indexOf(",") != -1) {
										String[] parts = rec.m_member.split(",");
										name = parts[1] + " " + parts[0];
									}
									else {
										name = rec.m_member;
									}
										
									//if report has been received, add the date received
									if(rec.m_eval_date != null && !rec.m_eval_date.equals(""))
									{
										//format date
										Time memberDate = parseTimeString(rec.m_eval_date);
										String memberEvalDate = memberDate.toStringLocalDate();
										committeeEvalCompleted = name + ", " + rec.m_role + ", received on " + memberEvalDate;
									}
									else
									{
										committeeEvalCompleted = name + ", " + rec.m_role;
									}
									
									//sorted according to the key's natural order
									membersEvals.put(rec.m_member, committeeEvalCompleted);
									
								}
								committeeEvalCompleted = "";
			
								//if there are committee evaluations
								if(!membersEvals.isEmpty())
								{
									requiredFrom = membersEvals.values();
									infoEdit.addCommitteeEvalsCompleted(requiredFrom);
										
									//clear for next infoEdit
									membersEvals.clear();
								}
							}
						}
					}
					if(existsOARDrecs)
					{
						//we have OARD data for this student
						infoEdit.setOARDRecInExtract(true);
						for(ListIterator i = OARDrecs.listIterator(); i.hasNext(); )
						{
							OARDRecord rec = (OARDRecord) i.next();
							
							/** set object data based on upload data */
						
							//	DEGREETERM_TRANS
							infoEdit.setDegreeTermTrans(rec.m_degreeterm_trans);
						
							//	ORAL_EXAM_DATE
							infoEdit.setTimeOralExam(parseTimeString(rec.m_oral_exam_date));
						
							//	ORAL_EXAM_TIME
							infoEdit.setOralExamTime(rec.m_oral_exam_time);
						
							//	ORAL_EXAM_PLACE
							infoEdit.setOralExamPlace(rec.m_oral_exam_place);
						
							//	FIRST_FORMAT_DATE
							infoEdit.setTimeFirstFormat(parseTimeString(rec.m_first_format_date));
						
							//	ORAL_REPORT_RETURN_DATE
							infoEdit.setTimeOralReportReturned(parseTimeString(rec.m_oral_report_return_date));
						
							//	COMM_CERT_DATE
							infoEdit.setTimeCommitteeCert(parseTimeString(rec.m_comm_cert_date));
							
							//	Degree conferred date
							infoEdit.setTimeDegreeConferred(parseTimeString(rec.m_degree_conferred_date));
						}
					}
				}
				catch(Exception e)
				{
					lErrors = true;
					collecting.add("Skipping student, emplid '" + oneEmplid + "' exception: " + e + NEWLINE);
					
					if(infoEdit != null && infoEdit.isActiveEdit())
						DissertationService.cancelEdit(infoEdit);
					continue;
				}
				
				//commit change if new data
				if(infoEdit != null && infoEdit.isActiveEdit())
				{
					if(commitEdit)
						DissertationService.commitEdit(infoEdit);
					else
						DissertationService.cancelEdit(infoEdit);
				}
				
				/** not all infoEdit properties persistent 
		 		*  so pass local instance rather than from db */
		
				//add this CandidateInfo to the collection
				data.add(infoEdit);
				
			}//for each emplid
			
			//on to apply business logic and data values to set step status
			lErrors = dumpData(data, collecting);
		}
		//return status of loading
		return lErrors;
			
	} //queryLists
	
	/** 
	* Send in a load of data from Rackham upload.
	* @param data Vector of CandidateInfo objects.
	* @param List collecting parameter for collecting results
	*/
	protected boolean dumpData(Vector data, List collecting)
	{
		CandidateInfoEdit info = null;
		CandidatePath path = null;
		Hashtable orderedStatus = null;
		String statusRef = null;
		String studentIdentifier = null;
		boolean lErrors = false;
		int processed = 0;
		
		if(data == null) 
			throw new IllegalArgumentException("CandidateInfo data sent to dumpData() was null");
		
		if(metric.isInfoEnabled())
			metric.info("METRIC " + data.size() + " students in upload. " + getTime());
		
		//for each CandidateInfo in data
		for(int x = 0; x < data.size(); x++)
		{
			try
			{
				// Note: infoEdit was committed or canceled in queryLists so no need to commit or cancel here
				info = (CandidateInfoEdit)data.get(x);
				try
				{
					//a string to identify the student by ids known to Rackham
					studentIdentifier = null;
					studentIdentifier = info.getEmplid() + " " + 
						UserDirectoryService.getUserEid(info.getChefId() + " ");
					if(studentIdentifier == null) {
						lErrors = true;
						collecting.add("Skipping student, emplid '" + info.getEmplid() + "' null studentIdentifier " + NEWLINE);
						continue;
					}
				}
				catch(Exception e)
				{
					lErrors = true;
					collecting.add("Skipping student, emplid '" + info.getEmplid() + "' could not get a CTools id: " + e + NEWLINE);
					continue;
				}
				
				//get the candidate path for this student
				try {
					path = DissertationService.getCandidatePathForCandidate(info.getChefId());
				}
				catch(MultipleObjectsException m) {
					lErrors = true;
					collecting.add("Skipping student, emplid '" + info.getEmplid() + "' has more than one path: " + m + NEWLINE);
					continue;
				}
				//if a path doesn't exist create one
				boolean created = false;
				if(path == null)
					created = createPath(studentIdentifier, info, collecting);
				if(created) {
					//try to get the path from storage
					path = DissertationService.getCandidatePathForCandidate(info.getChefId());
					if(path == null)
					{
						lErrors = true;
						collecting.add("Skipping student, '" + studentIdentifier + "' path is null." + NEWLINE);
						continue;
					}
				}

				//get the ordered step statuses
				orderedStatus = path.getOrderedStatus();
				
				//use the data to update step status for steps with an auto-validation number
				for(int y = 1; y < (orderedStatus.size()+1); y++)
				{
					statusRef = (String)orderedStatus.get("" + y);
					updateStepStatus(studentIdentifier, statusRef, info, collecting);
				}
				processed++;
				if(processed % METRIC_INTERVAL == 0) {
					if(metric.isInfoEnabled())
						metric.info("METRIC " + processed + " student checklists updated. " + getTime());
				}
			}
			catch(Exception e)
			{
				lErrors = true;
				collecting.add("Skipping student, '" + studentIdentifier + "' " + e + NEWLINE);
				continue;
			}
			
		}//for each CandidateInfo 
		
		if(metric.isInfoEnabled())
			metric.info("METRIC " + processed + " student checklists updated at the end of processing. " + getTime());
		
		return lErrors;
	}
	
	/**
	 * Set the status of the steps in the path  for those steps that have auto-validation numbers.
	 * Note: See CandidateInfo.getExternalValidation(autoValidNumber) for business logic.
	 * 
	 * @param statusRef
	 * @param info
	 */
	private void updateStepStatus(String studentIdentifier, String statusRef, 
			CandidateInfoEdit info, List collecting) {
		
		String autoValidationId = null;
		String oralExamText = null;
		String degreeTerm = null;
		Vector memberRole = new Vector();
		String newDegreeTerm = null;
		int autoValidNumber = 0;
		StepStatus status = null;
		StepStatusEdit statusEdit = null;
		Time completionTime = null;
		
		if(studentIdentifier == null || statusRef == null || info == null
				|| collecting == null) throw new IllegalArgumentException("a parameter in the call to updateStepStatus() was null");

		try {
			status = DissertationService.getStepStatus(statusRef);
		}
		catch(Exception e) {
			collecting.add("Skipping step update for'" + studentIdentifier + "': status reference '" + statusRef + "'" + e + NEWLINE);
			return;
		}
		
		//check if there is an auto-validation number currently being used
		autoValidationId = status.getAutoValidationId();
		if((!"".equals(autoValidationId)) && (!"None".equals(autoValidationId))
				&& (!"9".equals(autoValidationId)) && (!"10".equals(autoValidationId)) 
				&& (!"12".equals(autoValidationId)))
		{
			try
			{
				statusEdit = DissertationService.editStepStatus(statusRef);
				autoValidNumber = Integer.parseInt(autoValidationId);
				
				if(statusEdit.getAuxiliaryText() != null)
					statusEdit.setAuxiliaryText(null);
				
				if(autoValidNumber == 3 && ((Vector)info.getCommitteeEvalsCompleted()).size() > 0)
				{
					memberRole.clear();
					memberRole.add(START_ITALIC + "Committee:" + END_ITALIC);
					for(int i = 0; i < info.getCommitteeEvalsCompleted().size(); i++)
					{
						String temp = (String)info.getCommitteeEvalsCompleted().get(i);
						if(temp.indexOf(", received on ")!= -1)
							temp = temp.substring(0,temp.indexOf(", received on "));
						memberRole.add(temp);
					}
					statusEdit.setAuxiliaryText(memberRole);
				}
				if(autoValidNumber == 6 && ((Vector)info.getCommitteeEvalsCompleted()).size() > 0)
				{
					memberRole.clear();
					memberRole.add(START_ITALIC + "Evaluations required from:"+ END_ITALIC);
					memberRole.addAll(info.getCommitteeEvalsCompleted());
					statusEdit.setAuxiliaryText(memberRole);
				}
				//business logic for step completion
				completionTime = info.getExternalValidation(autoValidNumber);
				if(completionTime != null)
				{
					statusEdit.setCompleted(true);
					statusEdit.setTimeCompleted(completionTime);
					if(autoValidNumber == 2)
					{
						degreeTerm = info.getAdvCandDesc();
						if(degreeTerm != null && !degreeTerm.equals(""))
						{
							newDegreeTerm = translateDegreeTerm(degreeTerm,
									newDegreeTerm, autoValidNumber);
							if(newDegreeTerm != null)
								degreeTerm = newDegreeTerm;
							statusEdit.setTimeCompletedText(degreeTerm);
						}
					}
					if(autoValidNumber == 4)
					{
						oralExamText = info.getOralExamTime().toString() + " " + info.getOralExamPlace();
						statusEdit.setTimeCompletedText(oralExamText);
					}
					if(autoValidNumber == 11)
					{
						degreeTerm = info.getDegreeTermTrans();
						if(degreeTerm != null && !degreeTerm.equals(""))
						{
							newDegreeTerm = translateDegreeTerm(degreeTerm,
									newDegreeTerm, autoValidNumber);
							if(newDegreeTerm != null)
								degreeTerm = newDegreeTerm;
							statusEdit.setTimeCompletedText(degreeTerm);
						}
					}
				}
				else
				{
					//Note: if completion time is null because 
					//		there is a record with date set to null, set status to null
					//		the record is missing, do not change the existing status
					if((((autoValidNumber == 1) || (autoValidNumber == 2)) && info.getMPRecInExtract()) ||
					((autoValidNumber != 1) && (autoValidNumber != 2) && info.getOARDRecInExtract()))
					{
						statusEdit.setCompleted(false);
						statusEdit.setTimeCompleted(completionTime);
					}
				}
				//save the changes to status
				DissertationService.commitEdit(statusEdit);
			}
			catch(Exception e)
			{
				//cancel open edit
				if(statusEdit != null && statusEdit.isActiveEdit())
					DissertationService.cancelEdit(statusEdit);
				collecting.add("Skipping step update for'" + studentIdentifier + "': status reference '" + statusRef + "'" + 
						"processing step with autovalidation number '" + autoValidationId + "' " + e + NEWLINE);
			}
		}//has current auto-validation number
	}

	/**
	 * Edit the degree term string for improved readability
	 * 
	 * @param degreeTerm
	 * @param newDegreeTerm
	 * @param autoValidationNumber for translation appropriate to the incoming data
	 * @return translated degree term
	 */
	private String translateDegreeTerm(String degreeTerm, String newDegreeTerm, int autoValidationNumber) {
		if(autoValidationNumber == 2) {
			if(degreeTerm.startsWith("FA"))
				newDegreeTerm = degreeTerm.replaceFirst("FA", "Fall ");
			else if(degreeTerm.startsWith("WN"))
				newDegreeTerm = degreeTerm.replaceFirst("WN", "Winter ");
			else if(degreeTerm.startsWith("SP"))
				newDegreeTerm = degreeTerm.replaceFirst("SP", "Spring ");
			else if(degreeTerm.startsWith("SU"))
				newDegreeTerm = degreeTerm.replaceFirst("SU", "Summer ");
			else if(degreeTerm.startsWith("SS"))
				newDegreeTerm = degreeTerm.replaceFirst("SS", "Spring-Summer ");
		}
		if(autoValidationNumber == 11) {
			if(degreeTerm.startsWith("FA-"))
				newDegreeTerm = degreeTerm.replaceFirst("FA-", "Fall ");
			else if(degreeTerm.startsWith("WN-"))
				newDegreeTerm = degreeTerm.replaceFirst("WN-", "Winter ");
			else if(degreeTerm.startsWith("SP-"))
				newDegreeTerm = degreeTerm.replaceFirst("SP-", "Spring ");
			else if(degreeTerm.startsWith("SU-"))
				newDegreeTerm = degreeTerm.replaceFirst("SU-", "Summer ");
			else if(degreeTerm.startsWith("SS-"))
				newDegreeTerm = degreeTerm.replaceFirst("SS-", "Spring-Summer ");
		}
		return newDegreeTerm;
	}

	/**
	 * Create a new CandidatePath
	 * 
	 * @param studentIdentifier an identifier based on external ids
	 * @param info
	 * @param bufD
	 */
	private boolean createPath(String studentIdentifier, CandidateInfoEdit info, List collecting) {
		// Note: there is no student site id yet (or we don't know it)
		// site attribute is provisionally set to user Sakai id
		CandidatePathEdit pathEdit = null;
		String currentSite = info.getChefId();
		String parentSite = info.getParentSite();
		boolean created = false;
		
		if(studentIdentifier == null || info == null
				|| collecting == null) throw new IllegalArgumentException("a parameter in the call to createPath() was null");
		
		try {
			Dissertation dissertation = DissertationService.getDissertationForSite(parentSite);
			//if there is no dissertation for the student's parent site, use school's
			if(dissertation == null)
			{
				//set the dissertation type
				String schoolSite = DissertationService.getSchoolSite();
				if(parentSite.equals(m_musicPerformanceSite))
					dissertation = DissertationService.getDissertationForSite(schoolSite, DissertationService.DISSERTATION_TYPE_MUSIC_PERFORMANCE);
				else
					dissertation = DissertationService.getDissertationForSite(schoolSite, DissertationService.DISSERTATION_TYPE_DISSERTATION_STEPS);
				if(dissertation == null)
				{
					collecting.add("Could not create path for '" + studentIdentifier + "' because checklist for school is null." + NEWLINE);
					return created;
				}
			}

			//TODO get through Dissertation Service get a new path based on this dissertation
			//pathEdit = addCandidatePathFromListener(dissertation, currentSite);
			pathEdit = DissertationService.addCandidatePath(dissertation, currentSite);
			if(pathEdit == null)
			{
				collecting.add("Could not create path for '" + studentIdentifier + "' because path returned by addCandidatePath was null." + NEWLINE);
				return created;
			}
			//if sort letter is bad, path will be hidden from alphabetical candidate chooser
			pathEdit.setCandidate(info.getChefId());
			pathEdit.setSortLetter(getSortLetter(info.getChefId()));
			if(pathEdit.getSortLetter().equals("") || !((String)pathEdit.getSortLetter()).matches("[A-Z]"))
			{	
				collecting.add("Could not create a sort letter for '" + studentIdentifier + "', removing path and step status objects." + NEWLINE);
				//Note: if Sort Letter isn't set the alphabetical candidate chooser won't show this student under a letter
				// so remove records for this student from the Grad Tools tables
				cleanUp(studentIdentifier, info, collecting, pathEdit);
				return created;
			}
			
			//set parent department site id
			pathEdit.setParentSite(info.getParentSite());
			if(!(pathEdit.getParentSite().matches("^diss[0-9]*$")))
			{
				collecting.add("Parent site doesn't match dissBGG pattern for '" + studentIdentifier + "'.");
				return created;
			}
			
			//set dissertation steps type
			if(parentSite.equals(m_musicPerformanceSite))
				pathEdit.setType(DissertationService.DISSERTATION_TYPE_MUSIC_PERFORMANCE);
			else
				pathEdit.setType(DissertationService.DISSERTATION_TYPE_DISSERTATION_STEPS);
			
			//save and close the edit
			if(pathEdit != null && pathEdit.isActiveEdit()) {
				DissertationService.commitEdit(pathEdit);
				created = true;
			}
		}
		catch(Exception e)
		{
			collecting.add("Skipping student, '" + studentIdentifier + "' canceling creation of path: " + e + NEWLINE);
			if(pathEdit != null && pathEdit.isActiveEdit())
				DissertationService.cancelEdit(pathEdit);
		}
		return created;
	}

	/**
	 * Remove records for this student from the Grad Tools tables
	 * 
	 * @param studentIdentifier an identifier based on external ids
	 * @param info the CandidateInfo edit for this student
	 * @param collecting a collecting parameter pattern use
	 * @param pathEdit the CandidatePath edit for this student
	 * @throws IdUnusedException
	 * @throws InUseException
	 * @throws PermissionException
	 */
	private void cleanUp(String studentIdentifier, CandidateInfoEdit info,
			List collecting, CandidatePathEdit pathEdit)
			throws IdUnusedException, InUseException, PermissionException {
		StepStatusEdit statusEdit;
		Collection statusRefs;
		String statusRef;
		try
		{
			statusRefs = pathEdit.getOrderedStatus().values();
			Iterator i = statusRefs.iterator();
			while(i.hasNext())
			{
				statusRef = (String)i.next();
				statusEdit = DissertationService.editStepStatus(statusRef);
				DissertationService.removeStepStatus(statusEdit);
			}
			statusRefs = null;
			statusEdit = null;
			statusRef = null;

			DissertationService.removeCandidatePath(pathEdit);
			CandidateInfoEdit ci = DissertationService.getCandidateInfoEditForEmplid(info.getEmplid());
			DissertationService.removeCandidateInfo(ci);
		}
		catch(Exception e)
		{
			collecting.add("There was an exception removing table records for '" + studentIdentifier + "': " + e + NEWLINE);
		}
	}
	
	/*******************************************************************************
	* OARDRecord implementation
	*******************************************************************************/	
	/**
	*
	* Contains a Rackham OARD data record
	* 
	*/
	private class OARDRecord
	{
		/**
		* corresponding to OARD db output fields
		* All dates are formatted as mm/dd/ccyy.  
		* 
		* OARDEXT.txt Data Structure:
		* STRUCT � Field Name            �Field Type
		* 1 �  Emplid                    �  A8 - Student's emplid
		* 2 �  Fos                       �  A4    - Students field of study code
		* 3 �  Lname                     �  A25 - Students last name
		* 4 �  Fname                     �  A30 - Students first name
		* 5 �  Degterm trans             �  A7 - Students degree term as TT-CCYY (e.g. FA-2003)
		* 6 �  Oral exam date            �  D - Date of oral defense
		* 7 �  Oral exam time            �  A7 - Time of oral defense
		* 8 �  Oral exam place           �  A25 - Place of oral defense
		* 9 �  Committee approved date   �  D - date committee was approved
		*10 �  First format date         �  D - date of pre defense meeting in Rackham
		*11 �  Oral report return date   �  D
		*12 �  Degree conferred date     �  D - date the degree was conferred in OARD system
		*13 �  Update date               �  D - date record was last modified
		*14 �  Comm cert date            �  D -
		*15 |  Campus id                 |  A1-A8 - student's uniqname (Chef id)
		*/
		
		/*
		 * And here is the modified OARD structure:
STRUCT �         Field Name         �Field Type
     1 �  Emplid                    �  A8
     2 �  Fos                       �  A4
     3 �  Lname                     �  A25
     4 �  Fname                     �  A30
     5 �  Degterm trans             �  A7
     6 �  Oral exam date            �  D
     7 �  Oral exam time            �  A7
     8 �  Oral exam place           �  A25
     9 �  First format date         �  D
    10 �  Oral report return date   �  D
    11 �  Degree conferred date     �  D
    12 �  Update date               �  D
    13 �  Comm cert date            �  D
    14 �  Campus_id                 �  A12
*/
		
		public String m_umid = null;
		public String m_fos = null;
		public String m_lname = null;
		public String m_fname = null;
		public String m_degreeterm_trans = null;
		public String m_oral_exam_date = null;
		public String m_oral_exam_time = null;
		public String m_oral_exam_place = null;
		public String m_first_format_date = null;
		public String m_oral_report_return_date = null;
		public String m_degree_conferred_date = null;
		public String m_update_date = null;
		public String m_comm_cert_date = null;
		public String m_campus_id = null;
		
		public String getUmid(){ return m_umid; }
		public String getFos(){ return m_fos; }
		public String getLname(){ return m_lname; }
		public String getFname(){ return m_fname; }
		public String getDegreeterm_trans(){ return m_degreeterm_trans; }
		public String getOral_exam_date(){ return m_oral_exam_date; }
		public String getOral_exam_time(){ return m_oral_exam_time; }
		public String getOral_exam_place(){ return m_oral_exam_place; }
		public String getFirst_format_date(){ return m_first_format_date; }
		public String getOral_report_return_date(){ return m_oral_report_return_date; }
		public String getDegree_conferred_date(){ return m_degree_conferred_date; }
		public String getUpdate_date(){ return m_update_date; }
		public String getComm_cert_date(){ return m_comm_cert_date; }
		public String getCampusId() { return m_campus_id; }
		
	}
	

	
	/*******************************************************************************
	* MPRecord implementation
	*******************************************************************************/	
	/**
	*
	* Contains a Rackham MPathways data record
	* 
	*/
	private class MPRecord
	{
		/**
		* All dates are formatted as mm/dd/ccyy.  
		* MPEXT.txt Data Structure
		* STRUCT 	�  Field Name         		�Field Type
		* 
		* 1 		�  Emplid					�  A9	| Student's emplid
		* 2 		�  Acad_prog				�  A9	| Academic Program Code
		* 3 		�  Anticipate_Anticipate_1	�  A15	| Adv to cand term code
		* 4			�  Date_compl				�  D	| Date milestone was completed 
		* 5 		�  Milestone				�  A10	| name of milestone PRELIM or ADVCAND
		* 6 		|  Acad_plan				|  A4	| Field of study and degree (e.g. 1220PHD1)
		* 7 		|  Committee__Committee__1	|  A24  | Committee role
		* 8 		�  Committee__1				�  A23	| Member name
		* 9 		|  Eval_recvd				|  A14	| Eval received date
		*10 		|  Campus id				|  A1-A8| Student's uniqname (Chef id)
		*11 		�  Comm_appr_               �  A13
		*/
			
		private String m_umid = null;
		private String m_acad_prog = null;
		private String m_anticipate = null;
		private String m_date_compl = null;
		private String m_milestone = null;
		private String m_academic_plan = null;
		private String m_role = null;
		private String m_member = null;
		private String m_eval_date = null;
		private String m_campus_id = null;
		public String m_committee_approved_date = null;
		
		protected String getUmid(){ return m_umid; }
		protected String getAcad_prog(){ return m_acad_prog; }
		protected String getAnticipate(){ return m_anticipate; }
		protected String getDate_compl(){ return m_date_compl; }
		protected String getMilestone(){ return m_milestone; }
		protected String getAcademicPlan() { return m_academic_plan; }
		protected String getCommitteeRole() { return m_role; }
		protected String getCommitteeMember() { return m_member; }
		protected String getEvalDate() { return m_eval_date; }
		protected String getCampusId() { return m_campus_id; }
		protected String getCommitteeApprovedDate() { return m_committee_approved_date;}
		
	}
	
	/** 
	* Access the Rackham program id (Block Grant Group or BGG) 
	* for Rackham field of study id (FOS).
	* @return The program id.
	*/
	public String getProgram(String fos)
	{
		String retVal = "";
		if(fos != null)
			retVal = (String)m_schoolGroups.get(fos);
		return retVal;
	}
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.component.app.dissertation.StepChangeJob#init()
	 */
	public void init() 
	{
		jobName = null;
		buf = new StringBuffer();
		jobDetail = null;
		dataMap = null;
		announcement = null;
		cal = Calendar.getInstance();
		formatter = new SimpleDateFormat(DissertationService.STEP_JOB_DATE_FORMAT);
		ids = new Hashtable();
		OARDRecords = new Vector();
		MPRecords = new Vector();
		m_currentUser = null;
		m_oardFileName = null;
		m_mpFileName = null;
		m_musicPerformanceSite = null;
		m_schoolGroups = null;
		matcher = null;
	}

	/* (non-Javadoc)
	 * @see org.sakaiproject.component.app.dissertation.StepChangeJob#destroy()
	 */
	public void destroy() 
	{
		// TODO Auto-generated method stub
		
	}
}
