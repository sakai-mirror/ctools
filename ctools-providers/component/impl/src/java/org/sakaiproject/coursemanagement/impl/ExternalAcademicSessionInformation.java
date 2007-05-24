package org.sakaiproject.coursemanagement.impl;

import java.util.List;

import org.sakaiproject.coursemanagement.api.AcademicSession;
import org.sakaiproject.coursemanagement.api.exception.IdNotFoundException;

interface ExternalAcademicSessionInformation {

	public abstract AcademicSession getAcademicSession(final String eid)
			throws IdNotFoundException;

	public abstract List<AcademicSession> getAcademicSessions(
			CourseManagementServiceUnivOfMichImpl impl);

}