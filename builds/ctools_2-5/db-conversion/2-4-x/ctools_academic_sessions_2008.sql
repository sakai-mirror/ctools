-----------------------------------------------------------------------------
-- Add terms table for 2.4 course management code.  We aren't using the default
-- Hibernate implementation, so this needs to be done separately.

-- $HeadURL$
-- $Id$

-----------------------------------------------------------------------------
-- CM_ACADEMIC_SESSION_T
-----------------------------------------------------------------------------

-- CREATE TABLE CM_ACADEMIC_SESSION_T
-- (
--     ACADEMIC_SESSION_ID 	INT 	NOT NULL,
-- 	VERSION INT 			NOT 	NULL,
-- 	LAST_MODIFIED_BY 		VARCHAR(99),
-- 	LAST_MODIFIED_DATE		DATE,
-- 	CREATED_BY				VARCHAR(99),
-- 	CREATED_DATE			DATE,
-- 	ENTERPRISE_ID			VARCHAR(99) NOT NULL,
--     TITLE					VARCHAR(99) NOT NULL,
--     DESCRIPTION				VARCHAR(99) NOT NULL,
--     START_DATE				DATE,
--     END_DATE				DATE
-- );

-- ALTER TABLE CM_ACADEMIC_SESSION_T
--        ADD  ( PRIMARY KEY (ENTERPRISE_ID) ) ;

       
-- CREATE SEQUENCE CM_ACADEMIC_SESSION_S;

-- insert into cm_academic_session_t values(0, 1, 'admin', '10-APR-06', 'admin', '01-APR-06', 'WINTER 2006', 'WINTER_2006', 'WINTER 2006', '01-JAN-06', '20-APR-06');
-- insert into cm_academic_session_t values(1, 1, 'admin', '10-APR-06', 'admin', '10-APR-06', 'SPRING 2006', 'SPRING_2006', 'SPRING 2006', '01-MAY-06', '01-AUG-06');
-- insert into cm_academic_session_t values(2, 1, 'admin', '10-APR-07', 'admin', '01-APR-07', 'WINTER 2007', 'WINTER_2007', 'WINTER 2007', '01-JAN-07', '20-APR-07');
-- insert into cm_academic_session_t values(3, 1, 'admin', '10-APR-07', 'admin', '10-APR-07', 'SPRING 2007', 'SPRING_2007', 'SPRING 2007', '01-MAY-07', '01-AUG-07');

-- add for testing
-- 2003
-- insert into cm_academic_session_t values(0, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2003', 'FALL_2003', 'FALL 2003', '01-SEP-03', '01-DEC-03');

-- -- 2004 winter, spring spring_summer summer, fall
-- insert into cm_academic_session_t values(1, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'WINTER 2004', 'WINTER_2004', 'WINTER 2004', '01-JAN-2004', '01-MAY-2004');
-- insert into cm_academic_session_t values(2, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING 2004', 'SPRING_2004', 'SPRING 2004', '01-MAY-2004', '01-AUG-2004');
-- insert into cm_academic_session_t values(3, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING SUMMER 2004', 'SPRING_SUMMER_2004', 'SPRING_SUMMER 2004', '15-MAY-2004', '01-AUG-2004');
-- insert into cm_academic_session_t values(4, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SUMMER 2004', 'SUMMER_2004', 'SUMMER 2004', '01-AUG-2004', '01-AUG-2004');
-- insert into cm_academic_session_t values(5, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2004', 'FALL_2004', 'FALL 2004', '01-SEP-2004', '01-DEC-2004');

-- -- 2005 winter, spring spring_summer summer, fall
-- insert into cm_academic_session_t values(6, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'WINTER 2005', 'WINTER_2005', 'WINTER 2005', '01-JAN-2005', '01-MAY-2005');
-- insert into cm_academic_session_t values(7, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING 2005', 'SPRING_2005', 'SPRING 2005', '01-MAY-2005', '01-AUG-2005');
-- insert into cm_academic_session_t values(8, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING SUMMER 2005', 'SPRING_SUMMER_2005', 'SPRING_SUMMER 2005', '15-MAY-2005', '01-AUG-2005');
-- insert into cm_academic_session_t values(9, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SUMMER 2005', 'SUMMER_2005', 'SUMMER 2005', '01-AUG-2005', '01-AUG-2005');
-- insert into cm_academic_session_t values(10, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2005', 'FALL_2005', 'FALL 2005', '01-SEP-2005', '01-DEC-2005');

-- -- 2006 winter, spring spring_summer summer, fall
-- insert into cm_academic_session_t values(11, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'WINTER 2006', 'WINTER_2006', 'WINTER 2006', '01-JAN-2006', '01-MAY-2006');
-- insert into cm_academic_session_t values(12, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING 2006', 'SPRING_2006', 'SPRING 2006', '01-MAY-2006', '23-JUN-2006');
-- insert into cm_academic_session_t values(13, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING SUMMER 2006', 'SPRING_SUMMER_2006', 'SPRING_SUMMER 2006', '01-MAY-2006', '18-AUG-2006');
-- insert into cm_academic_session_t values(14, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SUMMER 2006', 'SUMMER_2006', 'SUMMER 2006', '28-JUN-2006', '18-AUG-2006');
-- insert into cm_academic_session_t values(15, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2006', 'FALL_2006', 'FALL 2006', '05-SEP-2006', '12-DEC-2006');

-- -- 2007 winter, spring spring_summer summer, fall
-- insert into cm_academic_session_t values(16, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'WINTER 2007', 'WINTER_2007', 'WINTER 2007', '04-JAN-2007', '26-APR-2007');
-- insert into cm_academic_session_t values(17, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING 2007', 'SPRING_2007', 'SPRING 2007', '01-MAY-2007', '22-JUN-2007');
-- insert into cm_academic_session_t values(18, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING SUMMER 2007', 'SPRING_SUMMER_2007', 'SPRING_SUMMER 2007', '01-MAY-2007', '17-AUG-2007');
-- insert into cm_academic_session_t values(19, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SUMMER 2007', 'SUMMER_2007', 'SUMMER 2007', '27-JUN-2007', '17-AUG-2007');
-- insert into cm_academic_session_t values(20, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2007', 'FALL_2007', 'FALL 2007', '04-SEP-2007', '11-DEC-2007');

 -- 2008 winter, spring spring_summer summer, fall
 insert into cm_academic_session_t values(21, 1, 'admin', '10-OCT-07', 'admin', '10-OCT-07', 'WINTER 2008', 'WINTER 2008', 'W08', '03-JAN-2008', '25-APR-2008');
 insert into cm_academic_session_t values(22, 1, 'admin', '10-OCT-07', 'admin', '10-OCT-07', 'SPRING 2008', 'SPRING 2008', 'Sp08', '28-APR-2008', '21-JUN-2008');
 insert into cm_academic_session_t values(23, 1, 'admin', '10-OCT-07', 'admin', '10-OCT-07', 'SPRING_SUMMER 2008', 'SPRING_SUMMER 2008', 'SpSu08', '28-APR-2008', '16-AUG-2008');
 insert into cm_academic_session_t values(24, 1, 'admin', '10-OCT-07', 'admin', '10-OCT-07', 'SUMMER 2008', 'SUMMER 2008', 'Su08', '24-JUN-2008', '16-AUG-2008');


