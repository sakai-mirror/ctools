-----------------------------------------------------------------------------
-- Add terms table for 2.4 course management code.  We aren't using the default
-- Hibernate implementation, so this needs to be done separately.

-- $HeadURL$
-- $Id$

-----------------------------------------------------------------------------
-- CM_ACADEMIC_SESSION_T
-----------------------------------------------------------------------------

CREATE TABLE CM_ACADEMIC_SESSION_T
(
    ACADEMIC_SESSION_ID 	INT 	NOT NULL,
	VERSION INT 			NOT 	NULL,
	LAST_MODIFIED_BY 		VARCHAR(99),
	LAST_MODIFIED_DATE		DATE,
	CREATED_BY				VARCHAR(99),
	CREATED_DATE			DATE,
	ENTERPRISE_ID			VARCHAR(99) NOT NULL,
    TITLE					VARCHAR(99) NOT NULL,
    DESCRIPTION				VARCHAR(99) NOT NULL,
    START_DATE				DATE,
    END_DATE				DATE
);

ALTER TABLE CM_ACADEMIC_SESSION_T
       ADD  ( PRIMARY KEY (ENTERPRISE_ID) ) ;

       
CREATE SEQUENCE CM_ACADEMIC_SESSION_S;

-- insert into cm_academic_session_t values(0, 1, 'admin', '10-APR-06', 'admin', '01-APR-06', 'WINTER 2006', 'WINTER_2006', 'WINTER 2006', '01-JAN-06', '20-APR-06');
-- insert into cm_academic_session_t values(1, 1, 'admin', '10-APR-06', 'admin', '10-APR-06', 'SPRING 2006', 'SPRING_2006', 'SPRING 2006', '01-MAY-06', '01-AUG-06');
-- insert into cm_academic_session_t values(2, 1, 'admin', '10-APR-07', 'admin', '01-APR-07', 'WINTER 2007', 'WINTER_2007', 'WINTER 2007', '01-JAN-07', '20-APR-07');
-- insert into cm_academic_session_t values(3, 1, 'admin', '10-APR-07', 'admin', '10-APR-07', 'SPRING 2007', 'SPRING_2007', 'SPRING 2007', '01-MAY-07', '01-AUG-07');

-- add for testing
-- 2003
insert into cm_academic_session_t values(0, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2003', 'FALL_2003', 'FALL 2003', '01-SEP-03', '01-DEC-03');

-- 2004 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(1, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Winter 2004', 'Winter_2004', 'Winter 2004', '01-JAN-2004', '01-MAY-2004');
insert into cm_academic_session_t values(2, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Spring 2004', 'Spring_2004', 'Spring 2004', '01-MAY-2004', '01-AUG-2004');
insert into cm_academic_session_t values(3, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Spring Summer 2004', 'Spring_Summer_2004', 'Spring_Summer 2004', '15-MAY-2004', '01-AUG-2004');
insert into cm_academic_session_t values(4, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Summer 2004', 'Summer_2004', 'Summer 2004', '01-AUG-2004', '01-AUG-2004');
insert into cm_academic_session_t values(5, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Fall 2004', 'Fall_2004', 'Fall 2004', '01-SEP-2004', '01-DEC-2004');

-- 2005 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(6, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Winter 2005', 'Winter_2005', 'Winter 2005', '01-JAN-2005', '01-MAY-2005');
insert into cm_academic_session_t values(7, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Spring 2005', 'Spring_2005', 'Spring 2005', '01-MAY-2005', '01-AUG-2005');
insert into cm_academic_session_t values(8, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Spring Summer 2005', 'Spring_Summer_2005', 'Spring_Summer 2005', '15-MAY-2005', '01-AUG-2005');
insert into cm_academic_session_t values(9, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Summer 2005', 'Summer_2005', 'Summer 2005', '01-AUG-2005', '01-AUG-2005');
insert into cm_academic_session_t values(10, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Fall 2005', 'Fall_2005', 'Fall 2005', '01-SEP-2005', '01-DEC-2005');

-- 2006 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(11, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Winter 2006', 'Winter_2006', 'Winter 2006', '01-JAN-2006', '01-MAY-2006');
insert into cm_academic_session_t values(12, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Spring 2006', 'Spring_2006', 'Spring 2006', '01-MAY-2006', '23-JUN-2006');
insert into cm_academic_session_t values(13, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Spring Summer 2006', 'Spring_Summer_2006', 'Spring_Summer 2006', '01-MAY-2006', '18-AUG-2006');
insert into cm_academic_session_t values(14, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Summer 2006', 'Summer_2006', 'Summer 2006', '28-JUN-2006', '18-AUG-2006');
insert into cm_academic_session_t values(15, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Fall 2006', 'Fall_2006', 'Fall 2006', '05-SEP-2006', '12-DEC-2006');

-- 2007 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(16, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Winter 2007', 'Winter_2007', 'Winter 2007', '04-JAN-2007', '26-APR-2007');
insert into cm_academic_session_t values(17, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Spring 2007', 'Spring_2007', 'Spring 2007', '01-MAY-2007', '22-JUN-2007');
insert into cm_academic_session_t values(18, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Spring Summer 2007', 'Spring_Summer_2007', 'Spring_Summer 2007', '01-MAY-2007', '17-AUG-2007');
insert into cm_academic_session_t values(19, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Summer 2007', 'Summer_2007', 'Summer 2007', '27-JUN-2007', '17-AUG-2007');
insert into cm_academic_session_t values(20, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'Fall 2007', 'Fall_2007', 'Fall 2007', '04-SEP-2007', '11-DEC-2007');


-- hsqldb
-- insert into cm_academic_session_t values(0, 1, 'admin', '2007-04-10', 'admin', '2007-04-10', 'WINTER 2007', 'WINTER_2007', 'WINTER 2007', '2007-01-01', '2007-04-30');
-- insert into cm_academic_session_t values(1, 1, 'admin', '2007-04-10', 'admin', '2007-04-10', 'SPRING 2007', 'SPRING_2007', 'SPRING 2007', '2007-05-01', '2007-08-01');
