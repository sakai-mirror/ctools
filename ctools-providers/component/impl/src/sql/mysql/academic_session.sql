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

CREATE INDEX IE_CM_ACADEMIC_SESSION_ID ON CM_ACADEMIC_SESSION_T
(
	ACADEMIC_SESSION_ID		ASC
);

-- Add academic term information for CM.  This is probably not the final version of this.
prompt 2003
-- 2003
insert into cm_academic_session_t values(0, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'FALL 2003', 'FALL 2003', 'F03', '2003-09-03', '2003-12-01');

-- 2004 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(1, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'WINTER 2004', 'WINTER 2004', 'W04', '2004-01-01', '2004-05-01');
insert into cm_academic_session_t values(2, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SPRING 2004', 'SPRING 2004', 'Sp04', '2004-05-01', '2004-08-01');
insert into cm_academic_session_t values(3, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SPRING SUMMER 2004', 'SPRING_SUMMER 2004', 'SpSu04', '2004-05-15', '2004-08-01');
insert into cm_academic_session_t values(4, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SUMMER 2004', 'SUMMER 2004', 'Su04', '2004-08-01', '2004-09-01');
insert into cm_academic_session_t values(5, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'FALL 2004', 'FALL 2004', 'F04', '2004-09-01', '2004-12-30');

-- 2005 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(6, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'WINTER 2005', 'WINTER 2005', 'W05', '2005-01-01', '2005-05-01');
insert into cm_academic_session_t values(7, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SPRING 2005', 'SPRING 2005', 'Sp05', '2005-05-01', '2005-08-01');
insert into cm_academic_session_t values(8, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SPRING SUMMER 2005', 'SPRING_SUMMER 2005', 'SpSu05', '2005-05-15', '2005-08-01');
insert into cm_academic_session_t values(9, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SUMMER 2005', 'SUMMER 2005', 'Su05', '2005-08-01', '2005-09-01');
insert into cm_academic_session_t values(10, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'FALL 2005', 'FALL 2005', 'F05', '2005-09-01', '2005-12-30');

-- 2006 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(11, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'WINTER 2006', 'WINTER 2006', 'W06', '2006-01-01', '2006-05-01');
insert into cm_academic_session_t values(12, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SPRING 2006', 'SPRING 2006', 'Sp06', '2006-05-01', '2006-06-23');
insert into cm_academic_session_t values(13, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SPRING SUMMER 2006', 'SPRING_SUMMER 2006', 'SpSu06', '2006-05-01', '2006-08-18');
insert into cm_academic_session_t values(14, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SUMMER 2006', 'SUMMER 2006', 'Su06', '2006-06-28', '2006-08-18');
insert into cm_academic_session_t values(15, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'FALL 2006', 'FALL 2006', 'F06', '2006-09-05', '2006-12-12');

-- 2007 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(16, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'WINTER 2007', 'WINTER 2007', 'W07', '2007-01-04', '2007-04-26');
insert into cm_academic_session_t values(17, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SPRING 2007', 'SPRING 2007', 'Sp07', '2007-05-01', '2007-06-22');
insert into cm_academic_session_t values(18, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SPRING SUMMER 2007', 'SPRING_SUMMER 2007', 'SpSu07', '2007-05-01', '2007-08-17');
insert into cm_academic_session_t values(19, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'SUMMER 2007', 'SUMMER 2007', 'Su07', '2007-06-27', '2007-08-17');
insert into cm_academic_session_t values(20, 1, 'admin', '2007-05-09', 'admin', '2007-05-09', 'FALL 2007', 'FALL 2007', 'F07', '2007-09-04', '2007-12-11');