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

insert into cm_academic_session_t values(0, 1, 'admin', '10-APR-06', 'admin', '01-APR-06', 'WINTER 2006', 'WINTER_2006', 'WINTER 2006', '01-JAN-06', '20-APR-06');
insert into cm_academic_session_t values(1, 1, 'admin', '10-APR-06', 'admin', '10-APR-06', 'SPRING 2006', 'SPRING_2006', 'SPRING 2006', '01-MAY-06', '01-AUG-06');
insert into cm_academic_session_t values(2, 1, 'admin', '10-APR-07', 'admin', '01-APR-07', 'WINTER 2007', 'WINTER_2007', 'WINTER 2007', '01-JAN-07', '20-APR-07');
insert into cm_academic_session_t values(3, 1, 'admin', '10-APR-07', 'admin', '10-APR-07', 'SPRING 2007', 'SPRING_2007', 'SPRING 2007', '01-MAY-07', '01-AUG-07');

-- hsqldb
-- insert into cm_academic_session_t values(0, 1, 'admin', '2007-04-10', 'admin', '2007-04-10', 'WINTER 2007', 'WINTER_2007', 'WINTER 2007', '2007-01-01', '2007-04-30');
-- insert into cm_academic_session_t values(1, 1, 'admin', '2007-04-10', 'admin', '2007-04-10', 'SPRING 2007', 'SPRING_2007', 'SPRING 2007', '2007-05-01', '2007-08-01');
