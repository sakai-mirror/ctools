-- This is the Oracle Sakai 2.0 -> 2.1 conversion script, CTools fall 05 -> winter 06
----------------------------------------------------------------------------------------------------------------------------------------
--
-- use this to convert a Sakai database from 2.0.0 or 2.0.1 to 2.1.0.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new tables, changed tables, and changed data.
--
----------------------------------------------------------------------------------------------------------------------------------------
-- YOU MUST MANUALLY ADJUST THIS SCRIPT!
-- The section where permissions are adjusted must be customize to your specific environment.
-- Look for the ADJUST ME notes below
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- from file "gradebook/component/src/sql/oracle/sakai_gradebook_2.0.1_to_2.1.sql"
-- Gradebook related tables changes needed between Sakai 2.01 and 2.1
alter table GB_GRADABLE_OBJECT_T add (NOT_COUNTED number(1,0));
update GB_GRADABLE_OBJECT_T set NOT_COUNTED=0 where NOT_COUNTED is NULL and POINTS_POSSIBLE is not NULL;
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- from file "legacy/component/src/sql/oracle/sakai_site_group.sql"
-- Site related tables added in Sakai 2.1
-----------------------------------------------------------------------------
-- SAKAI_SITE_GROUP
-----------------------------------------------------------------------------

CREATE TABLE SAKAI_SITE_GROUP (
       GROUP_ID             VARCHAR2(99) NOT NULL,
       SITE_ID              VARCHAR2(99) NOT NULL,
       TITLE                VARCHAR2(99) NULL,
       DESCRIPTION          CLOB NULL
);

ALTER TABLE SAKAI_SITE_GROUP
       ADD  ( PRIMARY KEY (GROUP_ID) ) ;

ALTER TABLE SAKAI_SITE_GROUP
       ADD  ( FOREIGN KEY (SITE_ID)
                             REFERENCES SAKAI_SITE ) ;

CREATE INDEX IE_SAKAI_SITE_GRP_SITE ON SAKAI_SITE_GROUP
(
       SITE_ID                       ASC
);

-----------------------------------------------------------------------------
-- SAKAI_SITE_GROUP_PROPERTY
-----------------------------------------------------------------------------

CREATE TABLE SAKAI_SITE_GROUP_PROPERTY (
       SITE_ID              VARCHAR2(99) NOT NULL,
       GROUP_ID             VARCHAR2(99) NOT NULL,
       NAME                 VARCHAR2(99) NOT NULL,
       VALUE                CLOB NULL
);

ALTER TABLE SAKAI_SITE_GROUP_PROPERTY
       ADD  ( PRIMARY KEY (GROUP_ID, NAME) ) ;

ALTER TABLE SAKAI_SITE_GROUP_PROPERTY
       ADD  ( FOREIGN KEY (GROUP_ID)
                             REFERENCES SAKAI_SITE_GROUP ) ;

ALTER TABLE SAKAI_SITE_GROUP_PROPERTY
       ADD  ( FOREIGN KEY (SITE_ID)
                             REFERENCES SAKAI_SITE ) ;

CREATE INDEX IE_SAKAI_SITE_GRP_PROP_SITE ON SAKAI_SITE_GROUP_PROPERTY
(
       SITE_ID                       ASC
);
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- from file "legacy/component/src/sql/oracle/sakai_site_2_1_0_003.sql"
-- Site related tables changes needed after 2.1.0.003
ALTER TABLE SAKAI_SITE_PAGE ADD (POPUP CHAR(1) DEFAULT '0' CHECK (POPUP IN (1, 0)));
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- from file "legacy/component/src/sql/oracle/sakai_user_2_1_0_004.sql"
-- User related tables changes needed after 2.1.0.004
ALTER TABLE SAKAI_USER ADD (EMAIL_LC VARCHAR2 (255));
UPDATE SAKAI_USER SET EMAIL_LC = LOWER(EMAIL);
DROP INDEX IE_SAKAI_USER_EMAIL;
CREATE INDEX IE_SAKAI_USER_EMAIL ON SAKAI_USER( EMAIL_LC ASC );
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- from file "legacy/component/src/sql/oracle/sakai_user_2_1_0.sql"
-----------------------------------------------------------------------------
-- Clear the password field for the postmaster if it has not yet been changed
-----------------------------------------------------------------------------
UPDATE SAKAI_USER SET PW='' WHERE USER_ID='postmaster' AND PW='ISMvKXpXpadDiUoOSoAf';
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- from file "legacy/component/src/sql/oracle/sakai_content_delete.sql"
-----------------------------------------------------------------------------
-- CONTENT_RESOURCE_DELETE
-- TODO: add CONTENT_RESOURCE_BODY_BINARY_DELETE table if required
-----------------------------------------------------------------------------

CREATE TABLE CONTENT_RESOURCE_DELETE
(
    RESOURCE_ID VARCHAR2 (255) NOT NULL,
    RESOURCE_UUID VARCHAR2 (36),
	IN_COLLECTION VARCHAR2 (255),
	FILE_PATH VARCHAR2 (128),
	DELETE_DATE DATE,
	DELETE_USERID VARCHAR2 (36),
    XML LONG
);

CREATE UNIQUE INDEX CONTENT_RESOURCE_UUID_DELETE_I ON CONTENT_RESOURCE_DELETE
(
	RESOURCE_UUID
);

CREATE INDEX CONTENT_RESOURCE_DELETE_INDEX ON CONTENT_RESOURCE_DELETE
(
	RESOURCE_ID
);
---------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------
-- from file "legacy/component/src/sql/oracle/sakai_content_2_1_0.sql"
ALTER TABLE CONTENT_RESOURCE ADD (RESOURCE_UUID VARCHAR2 (36));

CREATE INDEX CONTENT_UUID_RESOURCE_INDEX ON CONTENT_RESOURCE
(
	RESOURCE_UUID
);
---------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------
-- for the Samigo conversion
alter table SAM_ASSESSFEEDBACK_T add (SHOWSTUDENTQUESTIONSCORE integer);
alter table SAM_PUBLISHEDFEEDBACK_T add (SHOWSTUDENTQUESTIONSCORE integer);
---------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------
-- Permissions have changed.  The following will catch your database up.
-- Note there are ADJUST MEs here

-- functions new to Sakai 2.1
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'annc.all.groups');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'asn.grade');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.createAssessment');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.deleteAssessment.any');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.deleteAssessment.own');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.editAssessment.any');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.editAssessment.own');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.gradeAssessment.any');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.gradeAssessment.own');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.publishAssessment.any');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.publishAssessment.own');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.questionpool.copy.own');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.questionpool.create');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.questionpool.delete.own');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.questionpool.edit.own');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.submitAssessmentForGrade');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.takeAssessment');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.template.create');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.template.delete.own');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'assessment.template.edit.own');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'dropbox.maintain');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gradebook.editAssignments');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gradebook.gradeAll');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gradebook.gradeSection');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gradebook.viewOwnGrades');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'metaobj.create');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'metaobj.edit');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'metaobj.publish');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'metaobj.suggest.global.publish');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'rwiki.admin');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'rwiki.create');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'rwiki.delete');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'rwiki.read');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'rwiki.superadmin');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'rwiki.update');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'section.role.instructor');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'section.role.student');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'section.role.ta');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'site.upd.grp.mbrshp');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'site.upd.site.mbrshp');
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'site.viewRoster');

-- possibly new role names from Sakai 2.1
INSERT INTO SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Instructor');
INSERT INTO SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Student');

-- for each realm that has a role matching something in this table, we will add to that role the function from this table
-- these are the new permissions granted in the templates in Sakai 2.1
-- ADJUST ME: modify this table to match your role names and the functions you want to insert
create table PERMISSIONS_SRC_TEMP (ROLE_NAME VARCHAR2(99), FUNCTION_NAME VARCHAR2(99));

-- these are the new 'access' permissions (roles access, student, etc - also good for ta / teaching assistant)
-- ADJUST ME: adjust theses for your needs, either with different permissions, or duplicate for other roles than 'access'
insert into PERMISSIONS_SRC_TEMP values ('access','assessment.submitAssessmentForGrade');
insert into PERMISSIONS_SRC_TEMP values ('access','assessment.takeAssessment');
insert into PERMISSIONS_SRC_TEMP values ('access','gradebook.viewOwnGrades');
insert into PERMISSIONS_SRC_TEMP values ('access','rwiki.create');
insert into PERMISSIONS_SRC_TEMP values ('access','rwiki.read');
insert into PERMISSIONS_SRC_TEMP values ('access','rwiki.update');
insert into PERMISSIONS_SRC_TEMP values ('access','section.role.student');

insert into PERMISSIONS_SRC_TEMP values ('Student','assessment.submitAssessmentForGrade');
insert into PERMISSIONS_SRC_TEMP values ('Student','assessment.takeAssessment');
insert into PERMISSIONS_SRC_TEMP values ('Student','gradebook.viewOwnGrades');
insert into PERMISSIONS_SRC_TEMP values ('Student','rwiki.create');
insert into PERMISSIONS_SRC_TEMP values ('Student','rwiki.read');
insert into PERMISSIONS_SRC_TEMP values ('Student','rwiki.update');
insert into PERMISSIONS_SRC_TEMP values ('Student','section.role.student');

insert into PERMISSIONS_SRC_TEMP values ('Member','assessment.submitAssessmentForGrade');
insert into PERMISSIONS_SRC_TEMP values ('Member','assessment.takeAssessment');
insert into PERMISSIONS_SRC_TEMP values ('Member','gradebook.viewOwnGrades');
insert into PERMISSIONS_SRC_TEMP values ('Member','rwiki.create');
insert into PERMISSIONS_SRC_TEMP values ('Member','rwiki.read');
insert into PERMISSIONS_SRC_TEMP values ('Member','rwiki.update');
insert into PERMISSIONS_SRC_TEMP values ('Member','section.role.student');

-- insert into PERMISSIONS_SRC_TEMP values ('Observer','assessment.submitAssessmentForGrade');
-- insert into PERMISSIONS_SRC_TEMP values ('Observer','assessment.takeAssessment');
insert into PERMISSIONS_SRC_TEMP values ('Observer','gradebook.viewOwnGrades');
insert into PERMISSIONS_SRC_TEMP values ('Observer','rwiki.read');
insert into PERMISSIONS_SRC_TEMP values ('Observer','section.role.student');

-- these are the new 'maintain' permissions (roles maintain, instructor, etc
-- ADJUST ME: adjust these for your needs, either with different permissions, or duplicate for other roles than 'maintain'
insert into PERMISSIONS_SRC_TEMP values ('maintain','annc.all.groups');
insert into PERMISSIONS_SRC_TEMP values ('maintain','asn.grade');
insert into PERMISSIONS_SRC_TEMP values ('maintain','asn.submit');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.createAssessment');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.deleteAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.deleteAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.editAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.editAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.gradeAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.gradeAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.publishAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.publishAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.questionpool.copy.own');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.questionpool.create');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.questionpool.delete.own');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.questionpool.edit.own');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.template.create');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.template.delete.own');
insert into PERMISSIONS_SRC_TEMP values ('maintain','assessment.template.edit.own');
insert into PERMISSIONS_SRC_TEMP values ('maintain','dropbox.maintain');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gradebook.editAssignments');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gradebook.gradeAll');
insert into PERMISSIONS_SRC_TEMP values ('maintain','metaobj.create');
insert into PERMISSIONS_SRC_TEMP values ('maintain','metaobj.edit');
insert into PERMISSIONS_SRC_TEMP values ('maintain','metaobj.publish');
insert into PERMISSIONS_SRC_TEMP values ('maintain','metaobj.suggest.global.publish');
insert into PERMISSIONS_SRC_TEMP values ('maintain','rwiki.admin');
insert into PERMISSIONS_SRC_TEMP values ('maintain','rwiki.create');
insert into PERMISSIONS_SRC_TEMP values ('maintain','rwiki.read');
insert into PERMISSIONS_SRC_TEMP values ('maintain','rwiki.update');
insert into PERMISSIONS_SRC_TEMP values ('maintain','section.role.instructor');

insert into PERMISSIONS_SRC_TEMP values ('Organizer','annc.all.groups');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','asn.grade');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','asn.submit');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.createAssessment');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.deleteAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.deleteAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.editAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.editAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.gradeAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.gradeAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.publishAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.publishAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.questionpool.copy.own');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.questionpool.create');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.questionpool.delete.own');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.questionpool.edit.own');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.template.create');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.template.delete.own');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','assessment.template.edit.own');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','dropbox.maintain');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gradebook.editAssignments');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gradebook.gradeAll');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','metaobj.create');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','metaobj.edit');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','metaobj.publish');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','metaobj.suggest.global.publish');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','rwiki.admin');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','rwiki.create');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','rwiki.read');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','rwiki.update');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','section.role.instructor');

insert into PERMISSIONS_SRC_TEMP values ('Owner','annc.all.groups');
insert into PERMISSIONS_SRC_TEMP values ('Owner','asn.grade');
insert into PERMISSIONS_SRC_TEMP values ('Owner','asn.submit');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.createAssessment');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.deleteAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.deleteAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.editAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.editAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.gradeAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.gradeAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.publishAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.publishAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.questionpool.copy.own');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.questionpool.create');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.questionpool.delete.own');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.questionpool.edit.own');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.template.create');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.template.delete.own');
insert into PERMISSIONS_SRC_TEMP values ('Owner','assessment.template.edit.own');
insert into PERMISSIONS_SRC_TEMP values ('Owner','dropbox.maintain');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gradebook.editAssignments');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gradebook.gradeAll');
insert into PERMISSIONS_SRC_TEMP values ('Owner','metaobj.create');
insert into PERMISSIONS_SRC_TEMP values ('Owner','metaobj.edit');
insert into PERMISSIONS_SRC_TEMP values ('Owner','metaobj.publish');
insert into PERMISSIONS_SRC_TEMP values ('Owner','metaobj.suggest.global.publish');
insert into PERMISSIONS_SRC_TEMP values ('Owner','rwiki.admin');
insert into PERMISSIONS_SRC_TEMP values ('Owner','rwiki.create');
insert into PERMISSIONS_SRC_TEMP values ('Owner','rwiki.read');
insert into PERMISSIONS_SRC_TEMP values ('Owner','rwiki.update');
insert into PERMISSIONS_SRC_TEMP values ('Owner','section.role.instructor');

insert into PERMISSIONS_SRC_TEMP values ('Affiliate','annc.all.groups');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','asn.grade');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','asn.submit');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.createAssessment');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.deleteAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.deleteAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.editAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.editAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.gradeAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.gradeAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.publishAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.publishAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.questionpool.copy.own');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.questionpool.create');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.questionpool.delete.own');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.questionpool.edit.own');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.template.create');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.template.delete.own');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','assessment.template.edit.own');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','dropbox.maintain');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gradebook.editAssignments');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gradebook.gradeAll');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','metaobj.create');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','metaobj.edit');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','metaobj.publish');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','metaobj.suggest.global.publish');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','rwiki.admin');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','rwiki.create');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','rwiki.read');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','rwiki.update');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','section.role.instructor');

insert into PERMISSIONS_SRC_TEMP values ('Instructor','annc.all.groups');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','asn.grade');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','asn.submit');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.createAssessment');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.deleteAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.deleteAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.editAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.editAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.gradeAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.gradeAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.publishAssessment.any');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.publishAssessment.own');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.questionpool.copy.own');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.questionpool.create');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.questionpool.delete.own');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.questionpool.edit.own');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.template.create');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.template.delete.own');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','assessment.template.edit.own');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','dropbox.maintain');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gradebook.editAssignments');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gradebook.gradeAll');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','metaobj.create');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','metaobj.edit');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','metaobj.publish');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','metaobj.suggest.global.publish');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','rwiki.admin');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','rwiki.create');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','rwiki.read');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','rwiki.update');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','section.role.instructor');

-- lookup the role and function numbers
create table PERMISSIONS_TEMP (ROLE_KEY INTEGER, FUNCTION_KEY INTEGER);
insert into PERMISSIONS_TEMP (ROLE_KEY, FUNCTION_KEY)
select SRR.ROLE_KEY, SRF.FUNCTION_KEY
from PERMISSIONS_SRC_TEMP TMPSRC
join SAKAI_REALM_ROLE SRR on (TMPSRC.ROLE_NAME = SRR.ROLE_NAME)
join SAKAI_REALM_FUNCTION SRF on (TMPSRC.FUNCTION_NAME = SRF.FUNCTION_NAME);

-- insert the new functions into the roles of any existing realm that has the role (don't convert the "!site.helper")
insert into SAKAI_REALM_RL_FN (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
select
    SRRFD.REALM_KEY, SRRFD.ROLE_KEY, TMP.FUNCTION_KEY
from
    (select distinct SRRF.REALM_KEY, SRRF.ROLE_KEY from SAKAI_REALM_RL_FN SRRF) SRRFD
    join PERMISSIONS_TEMP TMP on (SRRFD.ROLE_KEY = TMP.ROLE_KEY)
    join SAKAI_REALM SR on (SRRFD.REALM_KEY = SR.REALM_KEY)
    where SR.REALM_ID != '!site.helper'
    and not exists (
        select 1
            from SAKAI_REALM_RL_FN SRRFI
            where SRRFI.REALM_KEY=SRRFD.REALM_KEY and SRRFI.ROLE_KEY=SRRFD.ROLE_KEY and  SRRFI.FUNCTION_KEY=TMP.FUNCTION_KEY
    );

-- clean up the temp tables
drop table PERMISSIONS_TEMP;
drop table PERMISSIONS_SRC_TEMP;

-- some permissions are no longer used - run this to clean them out
-- ADJUST ME: make sure this does not remove any functions you need!
-- ADJUST ME: Note that the GradTools "dis.*" permissions are removed - don't do that if you are using GradTools

-- the ones no longer needed for access
-- ADJUST ME: apply to other access roles (student, ta / teaching assistant, etc)
DELETE FROM SAKAI_REALM_RL_FN WHERE ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access') AND FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.access');

-- the ones no longer needed for maintain
-- ADJUST ME: apply to other maintain roles (instructor, etc)
DELETE FROM SAKAI_REALM_RL_FN WHERE ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain') AND FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.any');
DELETE FROM SAKAI_REALM_RL_FN WHERE ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain') AND FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.own');
DELETE FROM SAKAI_REALM_RL_FN WHERE ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain') AND FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'disc.read.drafts');
DELETE FROM SAKAI_REALM_RL_FN WHERE ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain') AND FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.maintain');
DELETE FROM SAKAI_REALM_RL_FN WHERE ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain') AND FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mail.delete.own');
DELETE FROM SAKAI_REALM_RL_FN WHERE ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain') AND FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mail.revise.any');
DELETE FROM SAKAI_REALM_RL_FN WHERE ROLE_KEY = (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain') AND FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mail.revise.own');

-- remove any grants to the functions about to be removed
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.any');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.own');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'crud.create');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'crud.delete');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'crud.read');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'crud.update');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'disc.read.drafts');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.access');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.maintain');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mail.delete.own');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mail.revise.any');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mail.revise.own');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'news.delete.own');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'news.new');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'news.read');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'news.revise.any');
DELETE FROM SAKAI_REALM_RL_FN WHERE FUNCTION_KEY = (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'news.revise.own');

-- remove the unused function definitions
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='chat.revise.any';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='chat.revise.own';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='crud.create';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='crud.delete';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='crud.read';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='crud.update';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='disc.read.drafts';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='gradebook.access';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='gradebook.maintain';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='mail.delete.own';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='mail.revise.any';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='mail.revise.own';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='news.delete.own';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='news.new';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='news.read';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='news.revise.any';
DELETE FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME='news.revise.own';

---------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------
-- new AuthzGroup (realm) templates "!group.template", "!group.template.course", and "!site.template.course"
-- from file "legacy/component/src/sql/oracle/sakai_realm.sql" (partial)
INSERT INTO SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!group.template', '', NULL, 'admin', 'admin', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.read'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.viewOwnGrades'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'section.role.student'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.new'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.read'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.revise.any'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.revise.own'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.delete.any'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.delete.own'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.read.drafts'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.gradeAll'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.editAssignments'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'section.role.instructor'));
INSERT INTO SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!group.template.course', '', (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), 'admin', 'admin', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.delete.any'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.delete.own'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.new'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.read'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.read.drafts'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.revise.any'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.revise.own'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.gradeAll'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.editAssignments'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'section.role.instructor'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.read'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.viewOwnGrades'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'section.role.student'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.delete.own'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.new'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.read'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.read.drafts'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.revise.any'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'annc.revise.own'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gradebook.gradeSection'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'section.role.ta'));
INSERT INTO SAKAI_REALM_ROLE_DESC VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), 'Can read, revise, delete and add both content and participants to a site.');
INSERT INTO SAKAI_REALM_ROLE_DESC VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), 'Can read content, and add content to a site where appropriate.');
