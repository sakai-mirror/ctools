-- This combines and adapts, for ctools, the scripts to upgrade the Sakai database from 2.3.0 to 2.4.0.

-- $HeadURL$
-- $Id$

-- 2007/05/03: Start with the 013 QA tag conversion script.
-- 2007/05/04: This has the duplicate backfill lines commented out.  It also has manager / roster.export commented out and needs to have that put back in.
-- 2007/05/04: updated to be based on the 014 tag.
-- 2007/05/08: add comments, put manager / roster.export backfill back in.

-- 2007/05/10: There are no differences between the 2.3.1->2.4.0
--  conversion scripts between tags 014 and 015.  Put in the inserts
--  into the realm / role / function tables as they are harmless but
--  different ones are necessary for different CTools instances.  Add
--  Drew's version of permission backfill loop.  Take out references
--  to /site/mercury.  Take out duplicate updates.

-- 2007/05/11: Various changes by Drew Zhu.

-- ==============

-- sql to insert all roles mentioned
prompt sql to insert all roles mentioned
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Affiliate');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Assistant');

insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'CIG Coordinator');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Evaluator');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Instructor');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Member');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Observer');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Organizer');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Owner');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Program Admin');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Program Coordinator');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Reviewer');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Student');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Teaching Assistant');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'access');
insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'maintain');

-- sql to insert all functions mentioned
prompt sql to insert all functions mentioned
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'chat.delete.channel');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'chat.new.channel');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'chat.revise.channel');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'content.hidden');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.modify_associations');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.modify_goalsets');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.modify_links_from');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.modify_links_to');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.modify_ratings');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.view_any_links_from');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.view_any_links_to');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.view_own_ratings');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.view_ratings');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.view_visible_links_from');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'gmt.view_visible_links_to');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'mailtool.admin');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'mailtool.send');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'osp.reports.create');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'osp.reports.delete');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'osp.reports.edit');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'osp.reports.run');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'osp.reports.share');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'osp.reports.view');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'poll.add');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'poll.deleteAny');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'poll.deleteOwn');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'poll.editAny');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'poll.editOwn');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'poll.vote');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'roster.export');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'roster.viewall');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'roster.viewhidden');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'roster.viewofficialid');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'roster.viewsection');

-- sql to insert all realms mentioned

-- These would be better specified explictly naming the data fields. E.g. see the next line.
-- insert into SAKAI_REALM (REALM_KEY,REALM_ID) VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!site.template.project');

-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!group.template');
-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!group.template.course');
-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!site.template');
-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!site.template.course');
-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!site.template.portfolio');
-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!site.template.portfolioAdmin');
-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!site.template.project');
-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!site.user');
-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '/site/mercury');

-- =============================
----------------------------------------------------------------------------------------------------------------------------------------

-- SAK-6780 added SQL update scripts to add new tables and alter existing tables to support selective release and spreadsheet upload

-- Gradebook table changes between Sakai 2.3.0 and 2.3.1.

-- Add selective release support
prompt Add selective release support
alter table GB_GRADABLE_OBJECT_T add (RELEASED NUMBER(1,0));
update GB_GRADABLE_OBJECT_T set RELEASED=1 where RELEASED is NULL;

----------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------
-- new content.hidden permission
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- backfill new content.hidden permission into existing realms
----------------------------------------------------------------------------------------------------------------------------------------

-- This is the Oracle Sakai 2.3.0 (or later) -> 2.4.0 conversion script
----------------------------------------------------------------------------------------------------------------------------------------
--
-- use this to convert a Sakai database from 2.3.0 to 2.4.0.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------

-- OSP conversion
prompt OSP conversion
alter table osp_presentation_template add propertyFormType varchar2(36);
alter table osp_presentation add property_form varchar2(36);

-- 014: change on next line
prompt 014: change on next line
alter table osp_scaffolding add preview number(1,0) DEFAULT 0 not null;

-- 014: change on next line
alter table osp_wizard add preview number(1,0) DEFAULT 0 not null;	

alter table osp_review add review_item_id varchar2(36);

-- making sure these fields allow nulls
prompt making sure these fields allow nulls
ALTER TABLE osp_scaffolding MODIFY ( readyColor VARCHAR2(7) NULL );
ALTER TABLE osp_scaffolding MODIFY ( pendingColor VARCHAR2(7) NULL );
ALTER TABLE osp_scaffolding MODIFY ( completedColor VARCHAR2(7) NULL );
ALTER TABLE osp_scaffolding MODIFY ( lockedColor VARCHAR2(7) NULL );


update osp_list_config set selected_columns = replace(selected_columns, 'name', 'title') where selected_columns like '%name%';
update osp_list_config set selected_columns = replace(selected_columns, 'siteName', 'site.title') where selected_columns like '%siteName%';

--Updating for a change to the synoptic view for portfolio worksites
update sakai_site_tool_property set name='siteTypeList', value='portfolio,PortfolioAdmin' where value like 'portfolioWorksites';


----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------

-- SAMIGO conversion
-- SAK-6790 
prompt SAK-6790
alter table SAM_ASSESSMENTBASE_T MODIFY (CREATEDBY varchar(255) , LASTMODIFIEDBY varchar(255));
alter table SAM_SECTION_T MODIFY (CREATEDBY varchar(255), LASTMODIFIEDBY varchar(255));
alter table SAM_PUBLISHEDASSESSMENT_T MODIFY(CREATEDBY varchar(255), LASTMODIFIEDBY varchar(255));
alter table SAM_PUBLISHEDSECTION_T MODIFY(CREATEDBY varchar(255), LASTMODIFIEDBY varchar(255));
alter table SAM_ITEM_T MODIFY(ITEMIDSTRING varchar(255),  CREATEDBY varchar(255), LASTMODIFIEDBY varchar(255));
alter table SAM_ITEMFEEDBACK_T MODIFY(TYPEID varchar(255));
alter table SAM_ANSWERFEEDBACK_T MODIFY(TYPEID varchar(255));
alter table SAM_ATTACHMENT_T MODIFY(CREATEDBY varchar(255) , LASTMODIFIEDBY varchar(255));
alter table SAM_PUBLISHEDITEM_T MODIFY(ITEMIDSTRING varchar(255),  CREATEDBY varchar(255), LASTMODIFIEDBY varchar(255));
alter table SAM_PUBLISHEDITEMFEEDBACK_T MODIFY(TYPEID varchar(255));
alter table SAM_PUBLISHEDANSWERFEEDBACK_T MODIFY(TYPEID varchar(255));
alter table SAM_PUBLISHEDATTACHMENT_T  MODIFY(CREATEDBY varchar(255) , LASTMODIFIEDBY varchar(255));
alter table SAM_AUTHZDATA_T MODIFY(AGENTID varchar(255), LASTMODIFIEDBY varchar(255));
alter table SAM_ASSESSMENTGRADING_T MODIFY(AGENTID varchar(255) , GRADEDBY varchar(255));
alter table SAM_ITEMGRADING_T MODIFY(AGENTID varchar(255) , GRADEDBY varchar(255));
alter table SAM_GRADINGSUMMARY_T MODIFY(AGENTID varchar(255));
alter table SAM_MEDIA_T MODIFY(CREATEDBY varchar(255), LASTMODIFIEDBY varchar(255));
alter table SAM_TYPE_T MODIFY(CREATEDBY varchar(255) , LASTMODIFIEDBY varchar(255));

-- For performance
prompt For performance
prompt tablespace added by Zhu
create index SAM_ANSWERFEED_ANSWERID_I on SAM_ANSWERFEEDBACK_T (ANSWERID) tablespace CTOOLS_INDEXES;
create index SAM_ANSWER_ITEMTEXTID_I on SAM_ANSWER_T (ITEMTEXTID) tablespace CTOOLS_INDEXES;
create index SAM_ITEMFEED_ITEMID_I on SAM_ITEMFEEDBACK_T (ITEMID) tablespace CTOOLS_INDEXES;
create index SAM_ITEMMETADATA_ITEMID_I on SAM_ITEMMETADATA_T (ITEMID) tablespace CTOOLS_INDEXES;
create index SAM_ITEMTEXT_ITEMID_I on SAM_ITEMTEXT_T (ITEMID) tablespace CTOOLS_INDEXES;
create index SAM_ITEM_SECTIONID_I on SAM_ITEM_T (SECTIONID) tablespace CTOOLS_INDEXES;
create index SAM_QPOOL_OWNER_I on SAM_QUESTIONPOOL_T (OWNERID) tablespace CTOOLS_INDEXES;
prompt tablespace added by Zhu
-- SAK-7093
prompt SAK-7093
drop table SAM_STUDENTGRADINGSUMMARY_T cascade constraints;
drop sequence SAM_STUDENTGRADINGSUMMARY_ID_S;
prompt table modified by Zhu 1
create table SAM_STUDENTGRADINGSUMMARY_T (
STUDENTGRADINGSUMMARYID number(19,0) not null,
PUBLISHEDASSESSMENTID number(19,0) not null,
AGENTID varchar2(255) not null,
NUMBERRETAKE integer,
CREATEDBY varchar2(255) not null,
CREATEDDATE timestamp not null,
LASTMODIFIEDBY varchar2(255) not null,
LASTMODIFIEDDATE timestamp not null,
constraint PK_SAM_STUDENTGRADINGSUMMARY_T primary key (STUDENTGRADINGSUMMARYID) using index tablespace CTOOLS_INDEXES
);
prompt End table modified by Zhu
create sequence SAM_STUDENTGRADINGSUMMARY_ID_S;
create index SAM_PUBLISHEDASSESSMENT2_I on SAM_STUDENTGRADINGSUMMARY_T (PUBLISHEDASSESSMENTID) tablespace CTOOLS_INDEXES;


-- ----------------------------------------------------------------------------------------------------------------------------------------
-- -- new roster permissions
-- ----------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- -- backfill new roster permissions into existing realms
-- ----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- Site related tables changes needed for 2.4.0 (SAK-7341)
----------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE SAKAI_SITE ADD (CUSTOM_PAGE_ORDERED CHAR(1) DEFAULT '0' CHECK (CUSTOM_PAGE_ORDERED IN (1, 0)));

----------------------------------------------------------------------------------------------------------------------------------------
-- Post'em table changes needed for 2.4.0 
----------------------------------------------------------------------------------------------------------------------------------------
-- SAK-8232
prompt SAK-8232
ALTER TABLE SAKAI_POSTEM_STUDENT_GRADES MODIFY grade VARCHAR2 (2000);

-- SAK-6948
prompt SAK-6948
ALTER TABLE SAKAI_POSTEM_GRADEBOOK MODIFY title VARCHAR2 (255);

-- SAK-8213
prompt SAK-8213
ALTER TABLE SAKAI_REALM_ROLE_DESC ADD (PROVIDER_ONLY CHAR(1) NULL);

----------------------------------------------------------------------------------------------------------------------------------------
-- Add Moderator functionality to Message Center (SAK-8632)
----------------------------------------------------------------------------------------------------------------------------------------
-- add column to allow Moderator as template setting
prompt add column to allow Moderator as template setting
alter table MFR_AREA_T add (MODERATED NUMBER(1,0));
update MFR_AREA_T set MODERATED=0 where MODERATED is NULL;
alter table MFR_AREA_T modify (MODERATED NUMBER(1,0) not null);

-- change APPROVED column to allow null values to represent pending approvals
alter table MFR_MESSAGE_T modify (APPROVED NUMBER(1,0) null);

-- change MODERATED column in MFR_OPEN_FORUM_T to not null
update MFR_OPEN_FORUM_T set MODERATED=0 where MODERATED is NULL;
alter table MFR_OPEN_FORUM_T modify (MODERATED NUMBER(1,0) not null);

-- change MODERATED column in MFR_TOPIC_T to not null
update MFR_TOPIC_T set MODERATED=0 where MODERATED is NULL;
alter table MFR_TOPIC_T modify (MODERATED NUMBER(1,0) not null);

----------------------------------------------------------------------------------------------------------------------------------------
-- New Chat storage and permissions (SAK-8508)
----------------------------------------------------------------------------------------------------------------------------------------
prompt New Chat storage and permissions (SAK-8508)
--create new tables
--This is coming soon as soon as I can generate the ddl for Oracle...


-- 014: addition of contextdefaultchannel
prompt table modified by Zhu 2
CREATE TABLE CHAT2_CHANNEL ( 
    CHANNEL_ID           	VARCHAR2(99) NOT NULL,
    CONTEXT              	VARCHAR2(99) NOT NULL,
    CREATION_DATE        	TIMESTAMP(6) NULL,
    TITLE                	VARCHAR2(64) NULL,
    DESCRIPTION          	VARCHAR2(255) NULL,
    FILTERTYPE           	VARCHAR2(25) NULL,
    FILTERPARAM          	NUMBER(10,0) NULL,
    CONTEXTDEFAULTCHANNEL	NUMBER(1,0) NULL,
    ENABLE_USER_OVERRIDE 	NUMBER(1,0) NULL,
    constraint PK_CHAT2_CHANNEL PRIMARY KEY(CHANNEL_ID) using index tablespace CTOOLS_INDEXES
);


-- 014: added these two indices.
CREATE INDEX CHAT2_CHNL_CNTXT_I ON CHAT2_CHANNEL
(
       CONTEXT
);

CREATE INDEX CHAT2_CHNL_CNTXT_DFLT_I ON CHAT2_CHANNEL
(
       CONTEXT,
       CONTEXTDEFAULTCHANNEL
);

prompt table modified by Zhu 3
CREATE TABLE CHAT2_MESSAGE ( 
    MESSAGE_ID  	VARCHAR2(99) NOT NULL,
    CHANNEL_ID  	VARCHAR2(99) NULL,
    OWNER       	VARCHAR2(96) NOT NULL,
    MESSAGE_DATE	TIMESTAMP(6) NULL,
    BODY        	CLOB NOT NULL,
    constraint PK_CHAT2_MESSAGE PRIMARY KEY(MESSAGE_ID) using index tablespace CTOOLS_INDEXES
);
prompt table modified by Zhu 3

-- 014: addition.  Added these two indices.
CREATE INDEX CHAT2_MSG_CHNL_I ON CHAT2_MESSAGE
(
       CHANNEL_ID
);

CREATE INDEX CHAT2_MSG_CHNL_DATE_I ON CHAT2_MESSAGE
(
       CHANNEL_ID,
       MESSAGE_DATE
);



ALTER TABLE CHAT2_MESSAGE
    ADD ( FOREIGN KEY(CHANNEL_ID)
	REFERENCES CHAT2_CHANNEL(CHANNEL_ID)
);

-- chat conversion prep
alter table CHAT2_CHANNEL add migratedChannelId varchar2(99);
alter table CHAT2_MESSAGE add migratedMessageId varchar2(99);

-- Added because context needs to be 99
alter table CHAT2_CHANNEL modify CONTEXT VARCHAR2(99);

-- Added as it makes the conversion process linear rather than n^2.
create index ind_CHAT2_MESSAGE_4_CONVT on CHAT2_MESSAGE(MIGRATEDMESSAGEID) tablespace ctools_indexes;

----------------------------------------------------------------------------------------------------------------------------------------
-- New private folder (SAK-8759)
----------------------------------------------------------------------------------------------------------------------------------------

prompt New private folder (SAK-8759)
INSERT INTO CONTENT_COLLECTION(COLLECTION_ID,XML,IN_COLLECTION) VALUES ('/private/',
'<?xml version="1.0" encoding="UTF-8"?>
<collection id="/private/">
	<properties>
		<property name="CHEF:creator" value="admin"/>
		<property name="CHEF:is-collection" value="true"/>
		<property name="DAV:displayname" value="private"/>
		<property name="CHEF:modifiedby" value="admin"/>
		<property name="DAV:getlastmodified" value="20020401000000000"/>
		<property name="DAV:creationdate" value="20020401000000000"/>
	</properties>
</collection>
','/');

----------------------------------------------------------------------------------------------------------------------------------------
-- Gradebook table changes needed for 2.4.0 (SAK-8711)
----------------------------------------------------------------------------------------------------------------------------------------
-- Add grade commments.
-- Gradebook table changes needed for 2.4.0 (SAK-8711)

prompt table modified by Zhu 4
create table GB_COMMENT_T (
        ID number(19,0) not null,
        VERSION number(10,0) not null,
        GRADER_ID varchar2(255 char) not null,
        STUDENT_ID varchar2(255 char) not null,
        COMMENT_TEXT clob,
        DATE_RECORDED timestamp not null,
        GRADABLE_OBJECT_ID number(19,0) not null,
        constraint PK_GB_COMMENT_T primary key (ID) using index tablespace CTOOLS_INDEXES,
        constraint UK_GB_COMMENT_T unique (STUDENT_ID, GRADABLE_OBJECT_ID) using index tablespace CTOOLS_INDEXES);
prompt end table modified by Zhu 4
alter table GB_COMMENT_T 
	add constraint FK7977DFF06F98CFF foreign key (GRADABLE_OBJECT_ID) references GB_GRADABLE_OBJECT_T;
create sequence GB_COMMENT_S;

-- Remove database-caching of calculated course grades.
alter table GB_GRADE_RECORD_T drop column SORT_GRADE;

----------------------------------------------------------------------------------------------------------------------------------------
-- CourseManagement Reference Impl table changes needed for 2.4.0
----------------------------------------------------------------------------------------------------------------------------------------
prompt CourseManagement Reference Impl table changes needed for 2.4.0
prompt table modified by Zhu 5
create table CM_SEC_CATEGORY_T (CAT_CODE varchar2(255 char) not null, 
                                CAT_DESCR varchar2(255 char), 
                                constraint PK_CM_SEC_CATEGORY_T primary key (CAT_CODE) using index tablespace CTOOLS_INDEXES);
prompt end table modified by Zhu 5

create index CM_ENR_USER on CM_ENROLLMENT_T (USER_ID) tablespace CTOOLS_INDEXES;
create index CM_MBR_CTR on CM_MEMBERSHIP_T (MEMBER_CONTAINER_ID) tablespace CTOOLS_INDEXES;
create index CM_MBR_USER on CM_MEMBERSHIP_T (USER_ID) tablespace CTOOLS_INDEXES;
create index CM_INSTR_IDX on CM_OFFICIAL_INSTRUCTORS_T (INSTRUCTOR_ID) tablespace CTOOLS_INDEXES;
alter table CM_ACADEMIC_SESSION_T modify (LAST_MODIFIED_DATE date);
alter table CM_ACADEMIC_SESSION_T modify (CREATED_DATE date);
alter table CM_ACADEMIC_SESSION_T modify (START_DATE date);
alter table CM_ACADEMIC_SESSION_T modify (END_DATE date);
alter table CM_CROSS_LISTING_T modify (LAST_MODIFIED_DATE date);
alter table CM_CROSS_LISTING_T modify (CREATED_DATE date);
alter table CM_ENROLLMENT_SET_T modify (LAST_MODIFIED_DATE date);
alter table CM_ENROLLMENT_SET_T modify (CREATED_DATE date);
alter table CM_ENROLLMENT_T modify (LAST_MODIFIED_DATE date);
alter table CM_ENROLLMENT_T modify (CREATED_DATE date);
alter table CM_ENROLLMENT_T add unique (USER_ID, ENROLLMENT_SET);
alter table CM_MEETING_T drop column TIME_OF_DAY;
alter table CM_MEETING_T add (START_TIME date);
alter table CM_MEETING_T add (FINISH_TIME date);
alter table CM_MEETING_T add (MONDAY number(1,0));
alter table CM_MEETING_T add (TUESDAY number(1,0));
alter table CM_MEETING_T add (WEDNESDAY number(1,0));
alter table CM_MEETING_T add (THURSDAY number(1,0));
alter table CM_MEETING_T add (FRIDAY number(1,0));
alter table CM_MEETING_T add (SATURDAY number(1,0));
alter table CM_MEETING_T add (SUNDAY number(1,0));
alter table CM_MEMBERSHIP_T add (STATUS varchar2(255 char));
alter table CM_MEMBERSHIP_T add unique (USER_ID, MEMBER_CONTAINER_ID);
alter table CM_MEMBER_CONTAINER_T modify (LAST_MODIFIED_DATE date);
alter table CM_MEMBER_CONTAINER_T modify (CREATED_DATE date);
alter table CM_MEMBER_CONTAINER_T add (MAXSIZE number(10,0));
alter table CM_MEMBER_CONTAINER_T modify (START_DATE date);
alter table CM_MEMBER_CONTAINER_T modify (END_DATE date);
alter table CM_MEMBER_CONTAINER_T drop constraint FKD96A9BC6D0C1EF35;
alter table CM_MEMBER_CONTAINER_T drop constraint FKD96A9BC66DFDE2;
alter table CM_MEMBER_CONTAINER_T drop column EQUIV_CANON_COURSE_ID;
alter table CM_MEMBER_CONTAINER_T drop column EQUIV_COURSE_OFFERING_ID;
alter table CM_OFFICIAL_INSTRUCTORS_T add unique (ENROLLMENT_SET_ID, INSTRUCTOR_ID);

----------------------------------------------------------------------------------------------------------------------------------------
--SAK-7752
--Add grade comments that were previously stored in Message Center table to the new gradebook table
----------------------------------------------------------------------------------------------------------------------------------------
prompt SAK-7752
INSERT INTO GB_COMMENT_T
(select GB_COMMENT_S.NEXTVAL, gb_grade_record_t.VERSION, gb_grade_record_t.GRADER_ID, gb_grade_record_t.STUDENT_ID, MFR_MESSAGE_T.GRADECOMMENT, gb_grade_record_t.DATE_RECORDED, GB_GRADABLE_OBJECT_T.ID
    from (select MAX(MFR_MESSAGE_T.MODIFIED) as MSG_MOD, MFR_MESSAGE_T.GRADEASSIGNMENTNAME as ASSGN_NAME, MFR_MESSAGE_T.CREATED_BY as CREATED_BY_STUDENT, MFR_AREA_T.CONTEXT_ID as CONTEXT from MFR_MESSAGE_T 
        join MFR_TOPIC_T on MFR_MESSAGE_T.surrogateKey = MFR_TOPIC_T.ID
    	join MFR_OPEN_FORUM_T on MFR_TOPIC_T.of_surrogateKey = MFR_OPEN_FORUM_T.ID
    	join MFR_AREA_T on MFR_OPEN_FORUM_T.surrogateKey = MFR_AREA_T.ID
    	where MFR_MESSAGE_T.GRADEASSIGNMENTNAME is not null and
            MFR_MESSAGE_T.GRADECOMMENT is not null
            group by MFR_MESSAGE_T.GRADEASSIGNMENTNAME, MFR_MESSAGE_T.CREATED_BY, MFR_AREA_T.CONTEXT_ID)
    join MFR_MESSAGE_T on (MFR_MESSAGE_T.MODIFIED = MSG_MOD and MFR_MESSAGE_T.GRADEASSIGNMENTNAME = ASSGN_NAME and MFR_MESSAGE_T.CREATED_BY = CREATED_BY_STUDENT)
    join GB_GRADEBOOK_T on CONTEXT = GB_GRADEBOOK_T.GRADEBOOK_UID
    join GB_GRADABLE_OBJECT_T on GB_GRADABLE_OBJECT_T.GRADEBOOK_ID = GB_GRADEBOOK_T.ID
    join GB_GRADE_RECORD_T on GB_GRADE_RECORD_T.STUDENT_ID = MFR_MESSAGE_T.CREATED_BY
    left join GB_COMMENT_T
        on (MFR_MESSAGE_T.CREATED_BY = GB_COMMENT_T.STUDENT_ID and GB_GRADABLE_OBJECT_T.ID = GB_COMMENT_T.GRADABLE_OBJECT_ID)
    where 
        GB_COMMENT_T.ID is null and  
        MFR_MESSAGE_T.GRADEASSIGNMENTNAME = GB_GRADABLE_OBJECT_T.NAME and
        MFR_MESSAGE_T.GRADECOMMENT is not null and
        GB_GRADE_RECORD_T.GRADABLE_OBJECT_ID = GB_GRADABLE_OBJECT_T.ID);

----------------------------------------------------------------------------------------------------------------------------------------
--SAK-8702 
--New ScheduledInvocationManager API for jobscheduler
----------------------------------------------------------------------------------------------------------------------------------------
prompt SAK-8702
prompt table modified by Zhu 6
CREATE TABLE SCHEDULER_DELAYED_INVOCATION (
	INVOCATION_ID VARCHAR2(36) NOT NULL,
	INVOCATION_TIME TIMESTAMP NOT NULL,
	COMPONENT VARCHAR2(2000) NOT NULL,
	CONTEXT VARCHAR2(2000) NULL,
	constraint PK_SDI PRIMARY KEY (INVOCATION_ID) using index tablespace CTOOLS_INDEXES
);
prompt end table modified by Zhu 6
CREATE INDEX SCHEDULER_DI_TIME_INDEX ON SCHEDULER_DELAYED_INVOCATION (INVOCATION_TIME);

----------------------------------------------------------------------------------------------------------------------------------------
--SAK-7557
--New Osp Reports Tables
----------------------------------------------------------------------------------------------------------------------------------------
prompt SAK-7557
prompt table modified by Zhu 7 
CREATE TABLE osp_report_def_xml (
   reportDefId VARCHAR2(36 CHAR) NOT NULL,
   xmlFile CLOB NOT NULL,
   constraint PK_osp_report_def_xml PRIMARY KEY  (reportDefId) using index tablespace CTOOLS_INDEXES
 );

prompt table modified by Zhu 8
 CREATE TABLE osp_report_xsl (
   	reportXslFileId VARCHAR2(36 CHAR) NOT NULL,
	reportXslFileRef VARCHAR2(255 CHAR),
	reportDefId VARCHAR2(36 CHAR),
	xslFile CLOB NOT NULL,
	constraint PK_osp_report_xsl PRIMARY KEY (reportXslFileId) using index tablespace CTOOLS_INDEXES
 );

 ALTER TABLE osp_report_xsl add CONSTRAINT FK25C0A259BE381194 FOREIGN KEY (reportDefId)	REFERENCES OSP_REPORT_DEF_XML (reportDefId);

----------------------------------------------------------------------------------------------------------------------------------------
--SAK-9029
--Poll Tool Tables
----------------------------------------------------------------------------------------------------------------------------------------
prompt SAK-9029
prompt table modified by Zhu 9
CREATE TABLE POLL_POLL (
  POLL_ID number(20,0) NOT NULL,
  POLL_OWNER varchar2(255) NULL,
  POLL_SITE_ID varchar2(255) NULL,
  POLL_DETAILS varchar2(255) NULL,
  POLL_CREATION_DATE timestamp NULL,
  POLL_TEXT clob,
  POLL_VOTE_OPEN timestamp NULL,
  POLL_VOTE_CLOSE timestamp NULL,
  POLL_MIN_OPTIONS number(11,0) NULL,
  POLL_MAX_OPTIONS number(11,0) NULL,
  POLL_DISPLAY_RESULT varchar2(255) NULL,
  POLL_LIMIT_VOTE number(1,0) NULL,
  constraint PK_POLL_POLL PRIMARY KEY  (POLL_ID) using index tablespace CTOOLS_INDEXES
);

-- 014: change _S to _SEQ
CREATE SEQUENCE POLL_POLL_ID_SEQ;
CREATE INDEX POLL_POLL_SITE_ID_IDX ON POLL_POLL (POLL_SITE_ID) tablespace CTOOLS_INDEXES;

prompt table modified by Zhu 10
CREATE TABLE POLL_OPTION (
  OPTION_ID number(20,0) NOT NULL,
  OPTION_POLL_ID number(20,0) NULL,
  OPTION_TEXT clob,
  constraint PK_POLL_OPTION PRIMARY KEY (OPTION_ID) using index tablespace CTOOLS_INDEXES
);

-- 014: change _S to _SEQ
CREATE SEQUENCE POLL_OPTION_ID_SEQ;
CREATE INDEX POLL_OPTION_POLL_ID_IDX ON POLL_OPTION (OPTION_POLL_ID) tablespace CTOOLS_INDEXES;

prompt table modified by Zhu 11
CREATE TABLE POLL_VOTE (
  VOTE_ID number(20,0) NOT NULL,
  USER_ID varchar2(255) NULL,
  VOTE_IP varchar2(255) NULL,
  VOTE_DATE timestamp NULL,
  VOTE_POLL_ID number(20,0) NULL,
  VOTE_OPTION number(20,0) NULL,
  VOTE_SUBMISSION_ID varchar2(255) NULL,
   constraint PK_POLL_VOTE PRIMARY KEY  (VOTE_ID) using index tablespace CTOOLS_INDEXES
);

-- 014: change _S to _SEQ
CREATE SEQUENCE POLL_VOTE_ID_SEQ;
CREATE INDEX POLL_VOTE_POLL_ID_IDX ON POLL_VOTE (VOTE_POLL_ID) tablespace CTOOLS_INDEXES;
CREATE INDEX POLL_VOTE_USER_ID_IDX ON POLL_VOTE (USER_ID) tablespace CTOOLS_INDEXES;


-----------------------------------------------------------------------------
-- SAK-8892 CONTENT_TYPE_REGISTRY
-----------------------------------------------------------------------------
prompt  SAK-8892 CONTENT_TYPE_REGISTRY
CREATE TABLE CONTENT_TYPE_REGISTRY
(
    CONTEXT_ID VARCHAR (99) NOT NULL,
	RESOURCE_TYPE_ID VARCHAR (255),
    ENABLED VARCHAR (1)
);

CREATE INDEX content_type_registry_idx ON CONTENT_TYPE_REGISTRY 
(
	CONTEXT_ID
);

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- -- SAK-9029 new mailtool permissions 
-- ----------------------------------------------------------------------------------------------------------------------------------------


-- ----------------------------------------------------------------------------------------------------------------------------------------
-- -- backfill new mailtool permissions into existing realms
-- ----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- SAK-8967 new chat permissions 
----------------------------------------------------------------------------------------------------------------------------------------


-- ----------------------------------------------------------------------------------------------------------------------------------------
-- -- backfill new chat permissions into existing realms
-- ----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- SAK-9327 poll permissions 
----------------------------------------------------------------------------------------------------------------------------------------


-- ----------------------------------------------------------------------------------------------------------------------------------------
-- -- backfill new Poll permissions into existing realms
-- ----------------------------------------------------------------------------------------------------------------------------------------


   -- update realms here.
-- sql to bind all realm / role / function tuples
prompt sql to bind all realm / role / function tuple
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = ''));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.user'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.user'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.user'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.delete.channel'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.new.channel'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'chat.revise.channel'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolioAdmin'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Program Admin'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolioAdmin'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Program Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'content.hidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_associations'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_goalsets'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.modify_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_any_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_own_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Evaluator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Evaluator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Evaluator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Reviewer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_ratings'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Reviewer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_from'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Reviewer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'gmt.view_visible_links_to'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.admin'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.admin'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.admin'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.admin'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.admin'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.admin'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.admin'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mailtool.send'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.share'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.share'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.share'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.share'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.share'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.share'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.share'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.share'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.share'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.create'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.edit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.run'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.share'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Observer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Observer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Evaluator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Reviewer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Observer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'osp.reports.view'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'CIG Coordinator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.add'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.deleteOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editAny'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.editOwn'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Evaluator'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.portfolio'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Reviewer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'poll.vote'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.export'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewall'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.export'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewall'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewhidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewofficialid'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.export'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewhidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewofficialid'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewsection'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.export'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewall'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.export'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewall'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewhidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewofficialid'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.export'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewhidden'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewofficialid'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Teaching Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewsection'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewall'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.export'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewsection'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewsection'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewsection'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewsection'));
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'access'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'roster.viewsection'));


 ----------------------------------------------------------------------------------------------------------------------------------------
 -- backfill new Poll permissions into existing realms
 ----------------------------------------------------------------------------------------------------------------------------------------
prompt backfill new Poll permissions into existing realms
 -- for each realm that has a role matching something in this table, we will add to that role the function from this table
 CREATE TABLE PERMISSIONS_SRC_TEMP (ROLE_NAME VARCHAR(99), FUNCTION_NAME VARCHAR(99));

 -- These are for the site templates
 -- ADJUST ME: adjust theses for your needs, either with different permissions,
 -- or duplicate for other roles than 'access', 'Student', 'maintain', 'Instructor' and 'Teaching Assistant'


-- sql to entries to temp table to backfill new permissions
prompt sql to entries to temp table to backfill new permissions
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','chat.delete.channel');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','chat.new.channel');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','chat.revise.channel');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.modify_associations');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.modify_goalsets');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.modify_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.modify_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.modify_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.view_any_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.view_any_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.view_own_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.view_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.view_visible_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','gmt.view_visible_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','osp.reports.create');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','osp.reports.delete');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','osp.reports.edit');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','osp.reports.run');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','osp.reports.share');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','osp.reports.view');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','poll.add');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','poll.deleteAny');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','poll.deleteOwn');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','poll.editAny');
insert into PERMISSIONS_SRC_TEMP values ('Affiliate','poll.editOwn');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','chat.revise.channel');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.modify_associations');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.modify_goalsets');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.modify_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.modify_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.modify_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.view_any_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.view_any_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.view_own_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.view_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.view_visible_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','gmt.view_visible_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','osp.reports.create');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','osp.reports.edit');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','osp.reports.run');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','osp.reports.view');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','poll.add');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','poll.deleteOwn');
insert into PERMISSIONS_SRC_TEMP values ('Assistant','poll.editOwn');
insert into PERMISSIONS_SRC_TEMP values ('CIG Coordinator','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','chat.delete.channel');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','chat.new.channel');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','chat.revise.channel');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.modify_associations');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.modify_goalsets');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.modify_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.modify_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.modify_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.view_any_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.view_any_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.view_own_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.view_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.view_visible_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','gmt.view_visible_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','mailtool.admin');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','mailtool.send');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','osp.reports.create');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','osp.reports.delete');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','osp.reports.edit');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','osp.reports.run');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','osp.reports.share');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','osp.reports.view');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','poll.add');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','poll.deleteAny');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','poll.deleteOwn');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','poll.editAny');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','poll.editOwn');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','poll.vote');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','roster.export');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','roster.viewall');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','roster.viewhidden');
insert into PERMISSIONS_SRC_TEMP values ('Instructor','roster.viewofficialid');
insert into PERMISSIONS_SRC_TEMP values ('Member','gmt.view_own_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Member','gmt.view_visible_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Member','gmt.view_visible_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Member','osp.reports.view');
insert into PERMISSIONS_SRC_TEMP values ('Member','poll.vote');
insert into PERMISSIONS_SRC_TEMP values ('Observer','osp.reports.view');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','chat.delete.channel');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','chat.new.channel');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','chat.revise.channel');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.modify_associations');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.modify_goalsets');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.modify_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.modify_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.modify_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.view_any_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.view_any_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.view_own_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.view_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.view_visible_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','gmt.view_visible_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','osp.reports.create');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','osp.reports.delete');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','osp.reports.edit');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','osp.reports.run');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','osp.reports.share');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','osp.reports.view');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','poll.add');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','poll.deleteAny');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','poll.deleteOwn');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','poll.editAny');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','poll.editOwn');
insert into PERMISSIONS_SRC_TEMP values ('Organizer','poll.vote');
insert into PERMISSIONS_SRC_TEMP values ('Owner','chat.delete.channel');
insert into PERMISSIONS_SRC_TEMP values ('Owner','chat.new.channel');
insert into PERMISSIONS_SRC_TEMP values ('Owner','chat.revise.channel');
insert into PERMISSIONS_SRC_TEMP values ('Owner','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.modify_associations');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.modify_goalsets');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.modify_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.modify_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.modify_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.view_any_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.view_any_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.view_own_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.view_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.view_visible_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Owner','gmt.view_visible_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Owner','osp.reports.create');
insert into PERMISSIONS_SRC_TEMP values ('Owner','osp.reports.delete');
insert into PERMISSIONS_SRC_TEMP values ('Owner','osp.reports.edit');
insert into PERMISSIONS_SRC_TEMP values ('Owner','osp.reports.run');
insert into PERMISSIONS_SRC_TEMP values ('Owner','osp.reports.share');
insert into PERMISSIONS_SRC_TEMP values ('Owner','osp.reports.view');
insert into PERMISSIONS_SRC_TEMP values ('Owner','poll.add');
insert into PERMISSIONS_SRC_TEMP values ('Owner','poll.deleteAny');
insert into PERMISSIONS_SRC_TEMP values ('Owner','poll.deleteOwn');
insert into PERMISSIONS_SRC_TEMP values ('Owner','poll.editAny');
insert into PERMISSIONS_SRC_TEMP values ('Owner','poll.editOwn');
insert into PERMISSIONS_SRC_TEMP values ('Owner','poll.vote');
insert into PERMISSIONS_SRC_TEMP values ('Program Admin','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('Program Coordinator','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('Student','gmt.view_own_ratings');
insert into PERMISSIONS_SRC_TEMP values ('Student','gmt.view_visible_links_from');
insert into PERMISSIONS_SRC_TEMP values ('Student','gmt.view_visible_links_to');
insert into PERMISSIONS_SRC_TEMP values ('Student','mailtool.send');
insert into PERMISSIONS_SRC_TEMP values ('Student','poll.vote');
insert into PERMISSIONS_SRC_TEMP values ('Student','roster.viewsection');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','chat.delete.channel');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','chat.new.channel');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','chat.revise.channel');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','mailtool.admin');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','mailtool.send');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','poll.vote');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','roster.export');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','roster.viewhidden');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','roster.viewofficialid');
insert into PERMISSIONS_SRC_TEMP values ('Teaching Assistant','roster.viewsection');
insert into PERMISSIONS_SRC_TEMP values ('access','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('access','gmt.view_own_ratings');
insert into PERMISSIONS_SRC_TEMP values ('access','gmt.view_visible_links_from');
insert into PERMISSIONS_SRC_TEMP values ('access','gmt.view_visible_links_to');
insert into PERMISSIONS_SRC_TEMP values ('access','mailtool.send');
insert into PERMISSIONS_SRC_TEMP values ('access','poll.vote');
insert into PERMISSIONS_SRC_TEMP values ('access','roster.viewsection');
insert into PERMISSIONS_SRC_TEMP values ('maintain','chat.delete.channel');
insert into PERMISSIONS_SRC_TEMP values ('maintain','chat.new.channel');
insert into PERMISSIONS_SRC_TEMP values ('maintain','chat.revise.channel');
insert into PERMISSIONS_SRC_TEMP values ('maintain','content.hidden');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.modify_associations');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.modify_goalsets');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.modify_links_from');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.modify_links_to');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.modify_ratings');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.view_any_links_from');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.view_any_links_to');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.view_own_ratings');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.view_ratings');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.view_visible_links_from');
insert into PERMISSIONS_SRC_TEMP values ('maintain','gmt.view_visible_links_to');
insert into PERMISSIONS_SRC_TEMP values ('maintain','mailtool.admin');
insert into PERMISSIONS_SRC_TEMP values ('maintain','mailtool.send');
insert into PERMISSIONS_SRC_TEMP values ('maintain','osp.reports.create');
insert into PERMISSIONS_SRC_TEMP values ('maintain','osp.reports.delete');
insert into PERMISSIONS_SRC_TEMP values ('maintain','osp.reports.edit');
insert into PERMISSIONS_SRC_TEMP values ('maintain','osp.reports.run');
insert into PERMISSIONS_SRC_TEMP values ('maintain','osp.reports.share');
insert into PERMISSIONS_SRC_TEMP values ('maintain','osp.reports.view');
insert into PERMISSIONS_SRC_TEMP values ('maintain','poll.add');
insert into PERMISSIONS_SRC_TEMP values ('maintain','poll.deleteAny');
insert into PERMISSIONS_SRC_TEMP values ('maintain','poll.deleteOwn');
insert into PERMISSIONS_SRC_TEMP values ('maintain','poll.editAny');
insert into PERMISSIONS_SRC_TEMP values ('maintain','poll.editOwn');
insert into PERMISSIONS_SRC_TEMP values ('maintain','poll.vote');
insert into PERMISSIONS_SRC_TEMP values ('maintain','roster.export');
insert into PERMISSIONS_SRC_TEMP values ('maintain','roster.viewall');

-- ======================
-- count before the backfill so can see how many rows were added.
select count(*) from sakai_realm_rl_fn;

 -- lookup the role and function numbers
prompt lookup the role and function numbers
 create table PERMISSIONS_TEMP (ROLE_KEY INTEGER, FUNCTION_KEY INTEGER);
 insert into PERMISSIONS_TEMP (ROLE_KEY, FUNCTION_KEY)
 select SRR.ROLE_KEY, SRF.FUNCTION_KEY
 from PERMISSIONS_SRC_TEMP TMPSRC
 join SAKAI_REALM_ROLE SRR on (TMPSRC.ROLE_NAME = SRR.ROLE_NAME)
 join SAKAI_REALM_FUNCTION SRF on (TMPSRC.FUNCTION_NAME = SRF.FUNCTION_NAME);

-- insert the new functions into the roles of any existing realm that has the role (don't convert the "!site.helper")
--  insert into SAKAI_REALM_RL_FN (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
--  select
--      SRRFD.REALM_KEY, SRRFD.ROLE_KEY, TMP.FUNCTION_KEY
--  from
--      (select distinct SRRF.REALM_KEY, SRRF.ROLE_KEY from SAKAI_REALM_RL_FN SRRF) SRRFD
--      join PERMISSIONS_TEMP TMP on (SRRFD.ROLE_KEY = TMP.ROLE_KEY)
--      join SAKAI_REALM SR on (SRRFD.REALM_KEY = SR.REALM_KEY)
--      where SR.REALM_ID != '!site.helper'
--      and not exists (
--          select 1
--              from SAKAI_REALM_RL_FN SRRFI
--              where SRRFI.REALM_KEY=SRRFD.REALM_KEY and SRRFI.ROLE_KEY=SRRFD.ROLE_KEY and  SRRFI.FUNCTION_KEY=TMP.FUNCTION_KEY
--      )
-- ;

-- insert the new functions into the roles of any existing realm that has the role (don't convert the "!site.helper")
-- Statement provided by Drew.  It speeds the update up a great deal.  It also uses pl/sql
prompt Drew's loop
-- --Note:
-- --The 300 and 800 in the routine is based on the size of the SAKAI_REALM in current UM production database;
-- --Increase the 300 or 800 based on the size of the SAKAI_REALM table.
begin
 for i in 1 .. 300 loop
   insert into SAKAI_REALM_RL_FN (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
   select
    SRRFD.REALM_KEY, SRRFD.ROLE_KEY, TMP.FUNCTION_KEY
   from
    (select distinct SRRF.REALM_KEY, SRRF.ROLE_KEY from SAKAI_REALM_RL_FN SRRF) SRRFD
    join PERMISSIONS_TEMP TMP on (SRRFD.ROLE_KEY = TMP.ROLE_KEY)
    join SAKAI_REALM SR on (SRRFD.REALM_KEY = SR.REALM_KEY)
    where SR.REALM_ID != '!site.helper'
    and SR.REALM_KEY>=(i-1)*800 and SR.REALM_KEY<i*800
    and not exists (
        select 1
            from SAKAI_REALM_RL_FN SRRFI
            where SRRFI.REALM_KEY=SRRFD.REALM_KEY and SRRFI.ROLE_KEY=SRRFD.ROLE_KEY and  SRRFI.FUNCTION_KEY=TMP.FUNCTION_KEY
    );
 end loop;
 commit;
end;
/

prompt End of Drew's loop
-- clean up the temp tables
-- Leave commented out until we are sure the conversion works.

-- drop table PERMISSIONS_TEMP; -- NEED THIS
-- drop table PERMISSIONS_SRC_TEMP; -- NEED THIS

-- ====================== 
-- count post backfill to see how many rows were added.
select count(*) from sakai_realm_rl_fn;


-----------------------------------------------------------------------------
-- CITATION_COLLECTION
-----------------------------------------------------------------------------
prompt CITATION_COLLECTION
CREATE TABLE CITATION_COLLECTION
(
   COLLECTION_ID VARCHAR2 (36) NOT NULL,
		PROPERTY_NAME VARCHAR2 (255),
		PROPERTY_VALUE LONG
---    CONSTRAINT CITATION_COLLECTION_INDEX (COLLECTION_ID)
);

-----------------------------------------------------------------------------
-- CITATION_CITATION
-----------------------------------------------------------------------------

CREATE TABLE CITATION_CITATION
(
   CITATION_ID VARCHAR2 (36) NOT NULL,
		PROPERTY_NAME VARCHAR2 (255),
		PROPERTY_VALUE LONG
---    CONSTRAINT CITATION_CITATION_INDEX (CITATION_ID)
);

-----------------------------------------------------------------------------
-- CITATION_SCHEMA
-----------------------------------------------------------------------------

CREATE TABLE CITATION_SCHEMA
(
   SCHEMA_ID VARCHAR2 (36) NOT NULL,
		PROPERTY_NAME VARCHAR2 (255),
		PROPERTY_VALUE LONG
---    CONSTRAINT CITATION_SCHEMA_INDEX (SCHEMA_ID)
);

-----------------------------------------------------------------------------
-- CITATION_SCHEMA_FIELD
-----------------------------------------------------------------------------
prompt CITATION_SCHEMA_FIELD

CREATE TABLE CITATION_SCHEMA_FIELD
(
   SCHEMA_ID VARCHAR2 (36) NOT NULL,
   FIELD_ID VARCHAR2 (36) NOT NULL,
		PROPERTY_NAME VARCHAR2 (255),
		PROPERTY_VALUE LONG
---    CONSTRAINT CITATION_SCHEMA_INDEX (SCHEMA_ID, FIELD_ID)
);


------------------------------------------------------------------------
--- SAK-9436 Missing indexes in rwiki 
------------------------------------------------------------------------
prompt SAK-9436 Missing indexes in rwiki
--- its ok to ignore the drop errors, 
drop index rwikiproperties_name;
drop index  irwikicurrentcontent_rwi;
drop index  irwikihistorycontent_rwi;
drop index  irwikipagepresence_sid;
drop index  irwikihistory_name;
drop index  irwikihistory_realm;
drop index  irwikihistory_ref;
drop index  irwikihistoryobj_rwid;
drop index  irwikiobject_name;
drop index  irwikiobject_realm;
drop index  irwikiobject_ref;

drop index  irwikipr_userid;
drop index  irwikipm_sessionid;
drop index  irwikipm_user;
drop index  irwikipm_pagespace;
drop index  irwikipm_pagename;
drop index  irwikipt_user;
drop index  irwikipt_pagespace;
drop index  irwikipt_pavename;

prompt new indexes
create index irwikiproperties_name on rwikiproperties (name) tablespace CTOOLS_INDEXES;
create index irwikicurrentcontent_rwi on  rwikicurrentcontent (rwikiid)  tablespace CTOOLS_INDEXES;
create index irwikihistorycontent_rwi on  rwikihistorycontent (rwikiid) tablespace CTOOLS_INDEXES; 
create index irwikipagepresence_sid on  rwikipagepresence (sessionid)  tablespace CTOOLS_INDEXES;
create index irwikihistory_name on  rwikihistory (name) tablespace CTOOLS_INDEXES;
create index irwikihistory_realm on  rwikihistory (realm) tablespace CTOOLS_INDEXES;
create index irwikihistory_ref on  rwikihistory (referenced) tablespace CTOOLS_INDEXES;
create index irwikihistoryobj_rwid on  rwikihistory (rwikiobjectid) tablespace CTOOLS_INDEXES;
create index irwikiobject_name on  rwikiobject (name) tablespace CTOOLS_INDEXES;
create index irwikiobject_realm on  rwikiobject (realm) tablespace CTOOLS_INDEXES;
create index irwikiobject_ref on  rwikiobject (referenced) tablespace CTOOLS_INDEXES;

create index irwikipr_userid on  rwikipreference (userid) tablespace CTOOLS_INDEXES;
create index irwikipm_sessionid on  rwikipagemessage (sessionid) tablespace CTOOLS_INDEXES;
create index irwikipm_user on  rwikipagemessage (userid) tablespace CTOOLS_INDEXES;
create index irwikipm_pagespace on  rwikipagemessage (pagespace) tablespace CTOOLS_INDEXES;
create index irwikipm_pagename on  rwikipagemessage (pagename) tablespace CTOOLS_INDEXES;
create index irwikipt_user on  rwikipagetrigger (userid) tablespace CTOOLS_INDEXES;
create index irwikipt_pagespace on  rwikipagetrigger (pagespace) tablespace CTOOLS_INDEXES;
create index irwikipt_pavename on  rwikipagetrigger (pagename) tablespace CTOOLS_INDEXES;

------------------------------------------------------------------------
-- SAK-9439 Missing indexes in search
------------------------------------------------------------------------
prompt SAK-9439 Missing indexes in search
drop index   isearchbuilderitem_name;
drop index   isearchbuilderitem_ctx;
drop index   isearchbuilderitem_act;
drop index   isearchbuilderitem_sta;
drop index   isearchwriterlock_lk;


create index isearchbuilderitem_name on  searchbuilderitem (name) tablespace CTOOLS_INDEXES;
create index isearchbuilderitem_ctx on  searchbuilderitem (context)  tablespace CTOOLS_INDEXES;
create index isearchbuilderitem_act on  searchbuilderitem (searchaction) tablespace CTOOLS_INDEXES;
create index isearchbuilderitem_sta on  searchbuilderitem (searchstate) tablespace CTOOLS_INDEXES;
create index isearchwriterlock_lk on  searchwriterlock (lockkey) tablespace CTOOLS_INDEXES;

-- Drew suggests these.
create index IE_MAILARC_MSG_MESSAGE_ID on MAILARCHIVE_MESSAGE(MESSAGE_ID) tablespace ctools_indexes;
-- Current index on this file is provided above as part of the conversion.
-- create index idx_wikicurrentcontent_rwikiid on rwikicurrentcontent(rwikiid) tablespace ctools_indexes;

-- Add academic term information for CM.  This is probably not the final version of this.
prompt 2003
-- 2003
insert into cm_academic_session_t values(0, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2003', 'FALL 2003', 'F03', '01-SEP-03', '01-DEC-03');
prompt 2004
-- 2004 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(1, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'WINTER 2004', 'WINTER 2004', 'W04', '01-JAN-2004', '01-MAY-2004');
insert into cm_academic_session_t values(2, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING 2004', 'SPRING 2004', 'Sp04', '01-MAY-2004', '01-AUG-2004');
insert into cm_academic_session_t values(3, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING_SUMMER 2004', 'SPRING_SUMMER 2004', 'SpSu04', '15-MAY-2004', '01-AUG-2004');
insert into cm_academic_session_t values(4, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SUMMER 2004', 'SUMMER 2004', 'Su04', '01-AUG-2004', '01-AUG-2004');
insert into cm_academic_session_t values(5, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2004', 'FALL 2004', 'F04', '01-SEP-2004', '01-DEC-2004');

-- 2005 winter, spring spring_summer summer, fall
prompt 2005 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(6, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'WINTER 2005', 'WINTER 2005', 'W05', '01-JAN-2005', '01-MAY-2005');
insert into cm_academic_session_t values(7, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING 2005', 'SPRING 2005', 'Sp05', '01-MAY-2005', '01-AUG-2005');
insert into cm_academic_session_t values(8, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING_SUMMER 2005', 'SPRING_SUMMER 2005', 'SpSu05', '15-MAY-2005', '01-AUG-2005');
insert into cm_academic_session_t values(9, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SUMMER 2005', 'SUMMER 2005', 'Su05', '01-AUG-2005', '01-AUG-2005');
insert into cm_academic_session_t values(10, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2005', 'FALL 2005', 'F05', '01-SEP-2005', '01-DEC-2005');

-- 2006 winter, spring spring_summer summer, fall
prompt 2006 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(11, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'WINTER 2006', 'WINTER 2006', 'W06', '01-JAN-2006', '01-MAY-2006');
insert into cm_academic_session_t values(12, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING 2006', 'SPRING 2006', 'Sp06', '01-MAY-2006', '23-JUN-2006');
insert into cm_academic_session_t values(13, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING_SUMMER 2006', 'SPRING_SUMMER 2006', 'SpSu06', '01-MAY-2006', '18-AUG-2006');
insert into cm_academic_session_t values(14, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SUMMER 2006', 'SUMMER 2006', 'Su06', '28-JUN-2006', '18-AUG-2006');
insert into cm_academic_session_t values(15, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2006', 'FALL 2006', 'F06', '05-SEP-2006', '12-DEC-2006');

-- 2007 winter, spring spring_summer summer, fall
prompt 2007 winter, spring spring_summer summer, fall
insert into cm_academic_session_t values(16, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'WINTER 2007', 'WINTER 2007', 'W07', '04-JAN-2007', '26-APR-2007');
insert into cm_academic_session_t values(17, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING 2007', 'SPRING 2007', 'Sp07', '01-MAY-2007', '22-JUN-2007');
insert into cm_academic_session_t values(18, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SPRING_SUMMER 2007', 'SPRING_SUMMER 2007', 'SpSu07', '01-MAY-2007', '17-AUG-2007');
insert into cm_academic_session_t values(19, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'SUMMER 2007', 'SUMMER 2007', 'Su07', '27-JUN-2007', '17-AUG-2007');
insert into cm_academic_session_t values(20, 1, 'admin', '09-MAY-07', 'admin', '09-MAY-07', 'FALL 2007', 'FALL 2007', 'F07', '04-SEP-2007', '11-DEC-2007');


prompt adding muse, including indices for samigo

-- Add muse conversion 
-- This file was auto generated at Fri May 18 10:06:41 EDT 2007 from muse.presql.

-- This has been modified by hand to add indices.

-- ########## Current input file: muse.presql ###########
-- New indices, permissions, and template additions for Muse (mneme and ambrosia).
-- $HeadURL$
-- $Id$

-- 2007/05/18: created
-- 2007/05/21: incorporated suggested indices from Glenn and Drew.


-- Permissions required for mneme.
-- from JL
-- For course sites,
-- Owner grade,manage
-- Affiliate manage
-- Instructor grade manage
-- Assistant grade manage
-- Student submit
-- Observer - none

-- For project sites
-- Owner grade, manage
-- Organizer grade, manage
-- Member submit
-- Observer none

-- Per comments from Drew on 2007/05/18 email
 
-- Drew's indexes:
-- already covered by A below
-- 1. create index idx_ASSGRAD_AID_PUBASSEID on SAM_ASSESSMENTGRADING_T(AGENTID,PUBLISHEDASSESSMENTID) tablespace ctools_indexes;
-- already covered by B below
-- 2. create index IDX_ITEMGRADING_A_GRADINGID on SAM_ITEMGRADING_T(ASSESSMENTGRADINGID) tablespace ctools_indexes;

-- Want all remaining indices
-- 3. create index IDX_PUBANS_ITEMTEXTID on SAM_PUBLISHEDANSWER_T(ITEMTEXTID) tablespace ctools_indexes;
-- 4. create index IDX_PUBMETDATA_ASSESSMENTID on SAM_PUBLISHEDMETADATA_T(ASSESSMENTID) tablespace ctools_indexes;

-- Use similar naming convention as below
CREATE INDEX SAM_PBLSHDNSWR_ITMTXTD_I on SAM_PUBLISHEDANSWER_T(ITEMTEXTID) tablespace ctools_indexes;
CREATE INDEX SAM_PBLSHDMTDT_SSSSMNTD_I on SAM_PUBLISHEDMETADATA_T(ASSESSMENTID) tablespace ctools_indexes;


-----------------------------------------------------------------------------
-- Assessment Service DDL
-----------------------------------------------------------------------------

-- add tablespace to indices suggested by Glenn Golden.

-- A --
CREATE INDEX SAM_ASMNTGRDNG_PID_AGENT_I ON SAM_ASSESSMENTGRADING_T (
       PUBLISHEDASSESSMENTID    ASC, 
       AGENTID      ASC, 
       FORGRADE            ASC )
 tablespace ctools_indexes;

-- B --
CREATE INDEX SAM_ITEMGRADING_AG_PI_I ON SAM_ITEMGRADING_T
(
       ASSESSMENTGRADINGID    ASC,
       PUBLISHEDITEMID     ASC
) tablespace ctools_indexes;

-- C --
CREATE INDEX SAM_PUBLISHEDITEMMETADATA_IL_I ON SAM_PUBLISHEDITEMMETADATA_T
(
 ITEMID        ASC,
 LABEL        ASC
) tablespace ctools_indexes;

-- D --
CREATE INDEX SAM_PUBLISHEDITEMFEEDBACK_IT_I ON SAM_PUBLISHEDITEMFEEDBACK_T
(
 ITEMID        ASC,
 TYPEID        ASC
) tablespace ctools_indexes;

-- E --
CREATE INDEX SAM_PUBSECTIONMETADATA_IT_I ON SAM_PUBLISHEDSECTIONMETADATA_T
(
 SECTIONID       ASC,
 LABEL        ASC
) tablespace ctools_indexes;

-- sql to insert all roles mentioned
-- insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Affiliate');
-- insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Assistant');
-- insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Instructor');
-- insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Member');
-- insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Organizer');
-- insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Owner');
-- insert into SAKAI_REALM_ROLE VALUES (SAKAI_REALM_ROLE_SEQ.NEXTVAL, 'Student');

-- sql to insert all functions mentioned
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'mneme.grade');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'mneme.manage');
insert into SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'mneme.submit');

-- sql to insert all realms mentioned
-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!site.template.course');
-- insert into SAKAI_REALM VALUES (SAKAI_REALM_SEQ.NEXTVAL, '!site.template.project');

-- sql to bind all realm / role / function tuples
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.grade'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.manage'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affiliate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.manage'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.grade'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.manage'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.grade'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Assistant'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.manage'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Student'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.submit'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.grade'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.manage'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.grade'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.manage'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Member'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'mneme.submit'));

-- sql to add entries to temp table to backfill new permissions

-- lineCnt: 66 tupleCnt: 13
-- roleCnt: 7 functions: 3
-- realmCnt: 2 backfillCnt: 0


-- #######################################################

prompt adding samigo data (templates etc.)


-- Data load from samigo conversion for 2.4.0. sakai_samigo.sql

-- populate sam_type_t (TypeD)
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (1 , 'stanford.edu' ,'assessment.item' ,'Multiple Choice' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (2 , 'stanford.edu' ,'assessment.item' ,'Multiple Correct' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (3 , 'stanford.edu' ,'assessment.item' ,'Survey' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (4 , 'stanford.edu' ,'assessment.item' ,'True - False' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (5 , 'stanford.edu' ,'assessment.item' ,'Short Answer/Essay' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (6 , 'stanford.edu' ,'assessment.item' ,'File Upload' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (7 , 'stanford.edu' ,'assessment.item' ,'Audio Recording' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (8 , 'stanford.edu' ,'assessment.item' ,'Fill in Blank' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (11 , 'stanford.edu' ,'assessment.item' ,'Numeric Response' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (9 , 'stanford.edu' ,'assessment.item' ,'Matching' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (21 , 'stanford.edu' ,'assessment.section' ,'Default' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (22 , 'stanford.edu' ,'assessment.section' ,'Normal' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (41 , 'stanford.edu' ,'assessment.template' ,'Quiz' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (42 , 'stanford.edu' ,'assessment.template' ,'Homework' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (43 , 'stanford.edu' ,'assessment.template' ,'Mid Term' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (44 , 'stanford.edu' ,'assessment.template' ,'Final' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (61 , 'stanford.edu' ,'assessment' ,'Quiz' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (62 , 'stanford.edu' ,'assessment' ,'Homework' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (63 , 'stanford.edu' ,'assessment' ,'Mid Term' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (64 , 'stanford.edu' ,'assessment' ,'Final' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);

INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (0 , 'stanford.edu' ,'assessment.questionpool' ,'Default' ,
    'Stanford Question Pool',1 ,1 , SYSDATE ,1 ,SYSDATE);

INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (30 , 'stanford.edu' ,'assessment.questionpool.access' ,'Access Denied' ,
    'Access Denied',1 ,1 , SYSDATE ,1 ,SYSDATE);

INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (31 , 'stanford.edu' ,'assessment.questionpool.access' ,'Read Only' ,
    'Read Only',1 ,1 , SYSDATE ,1 ,SYSDATE);

INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (32 , 'stanford.edu' ,'assessment.questionpool.access' ,'Read and Copy' ,
    'Read and Copy',1 ,1 , SYSDATE ,1 ,SYSDATE);

INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (33 , 'stanford.edu' ,'assessment.questionpool.access' ,'Read/Write' ,
    'Read/Write',1 ,1 , SYSDATE ,1 ,SYSDATE);

INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (34 , 'stanford.edu' ,'assessment.questionpool.access' ,'Administration' ,
    'Adminstration',1 ,1 , SYSDATE ,1 ,SYSDATE);

INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (81 , 'stanford.edu' ,'assessment.taking' ,'Taking Assessment' ,
    'Taking Assessment',1 ,1 , SYSDATE ,1 ,SYSDATE);

INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (101 , 'stanford.edu' ,'assessment.published' ,'A Published Assessment' ,
    'A Published Assessment',1 ,1 , SYSDATE ,1 ,SYSDATE);

INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY" ,"DOMAIN" ,"KEYWORD",
    "DESCRIPTION" ,
    "STATUS" ,"CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (142 , 'stanford.edu' ,'assessment.template.system' ,'System Defined' ,NULL ,1 ,1 ,
    SYSDATE ,1 ,SYSDATE);

-- set up Default Template
INSERT INTO SAM_ASSESSMENTBASE_T ("ID" ,"ISTEMPLATE" ,
    "PARENTID" ,"TITLE" ,"DESCRIPTION" ,"COMMENTS" ,
    "ASSESSMENTTEMPLATEID" ,"TYPEID" ,"INSTRUCTORNOTIFICATION" ,
    "TESTEENOTIFICATION" ,"MULTIPARTALLOWED" ,"STATUS" ,
    "CREATEDBY" ,"CREATEDDATE" ,"LASTMODIFIEDBY" ,
    "LASTMODIFIEDDATE" )
    VALUES (sam_assessmentBase_id_s.nextVal,1 ,0 ,'Default Assessment Type' ,'System Defined Assessment Type' ,'comments' , NULL
    ,'142' ,1 ,1 ,1 ,1 ,'admin' ,SYSDATE ,'admin' ,SYSDATE  );

INSERT INTO SAM_ASSESSEVALUATION_T ("ASSESSMENTID" ,
    "EVALUATIONCOMPONENTS" ,"SCORINGTYPE" ,"NUMERICMODELID" ,
    "FIXEDTOTALSCORE" ,"GRADEAVAILABLE" ,"ISSTUDENTIDPUBLIC" ,
    "ANONYMOUSGRADING" ,"AUTOSCORING" ,"TOGRADEBOOK" )
    VALUES (1 ,'' ,1 ,'' , NULL , NULL , NULL ,1 , NULL ,2  );

INSERT INTO SAM_ASSESSFEEDBACK_T ("ASSESSMENTID" ,
    "FEEDBACKDELIVERY" ,"FEEDBACKAUTHORING" ,"SHOWQUESTIONTEXT" ,"SHOWSTUDENTRESPONSE"
    ,"SHOWCORRECTRESPONSE" ,"SHOWSTUDENTSCORE" ,"SHOWSTUDENTQUESTIONSCORE",
    "SHOWQUESTIONLEVELFEEDBACK" ,"SHOWSELECTIONLEVELFEEDBACK" ,
    "SHOWGRADERCOMMENTS" ,"SHOWSTATISTICS" ,"EDITCOMPONENTS" )
    VALUES (1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1  );

INSERT INTO SAM_ASSESSACCESSCONTROL_T ("ASSESSMENTID" ,
    "SUBMISSIONSALLOWED" ,"SUBMISSIONSSAVED" ,"ASSESSMENTFORMAT" ,
    "BOOKMARKINGITEM" ,"TIMELIMIT" ,"TIMEDASSESSMENT" ,
    "RETRYALLOWED" ,"LATEHANDLING" ,"STARTDATE" ,"DUEDATE" ,
    "SCOREDATE" ,"FEEDBACKDATE" ,"RETRACTDATE" ,"AUTOSUBMIT" ,
    "ITEMNAVIGATION" ,"ITEMNUMBERING" ,"SUBMISSIONMESSAGE" ,
    "RELEASETO" ,"USERNAME" ,"PASSWORD" ,"FINALPAGEURL" ,
    "UNLIMITEDSUBMISSIONS" )
    VALUES (1 ,NULL,1 ,1 , NULL , NULL , NULL , NULL ,1 ,
    TO_DATE('', 'dd-Mon-yyyy HH:MI:SS AM') ,TO_DATE('',
    'dd-Mon-yyyy HH:MI:SS AM') ,TO_DATE('', 'dd-Mon-yyyy HH:MI:SS
    AM') ,TO_DATE('', 'dd-Mon-yyyy HH:MI:SS AM') ,TO_DATE('',
    'dd-Mon-yyyy HH:MI:SS AM') ,1 ,2 ,1 ,'' ,'' ,'' ,'' ,'' ,
    1  );

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'finalPageURL_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'anonymousRelease_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'dueDate_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'description_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'metadataQuestions_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'bgImage_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'feedbackComponents_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'retractDate_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'feedbackType_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'timedAssessmentAutoSubmit_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'toGradebook_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'displayChunking_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'recordedScore_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'authenticatedRelease_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'displayNumbering_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'submissionMessage_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'releaseDate_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'assessmentAuthor_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'passwordRequired_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'author', '');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'submissionModel_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'ipAccessType_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'timedAssessment_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'metadataAssess_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'bgColor_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'testeeIdentity_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'templateInfo_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'itemAccessType_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'lateHandling_isInstructorEditable', 'true');

INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'feedbackAuthoring_isInstructorEditable', 'true');
INSERT INTO SAM_ASSESSMETADATA_T ("ASSESSMENTMETADATAID", "ASSESSMENTID","LABEL",
    "ENTRY")
    VALUES(sam_assessMetaData_id_s.nextVal, 1, 'releaseTo', 'SITE_MEMBERS');


-- 3. populate sam_functionData_t
INSERT INTO SAM_FUNCTIONDATA_T
        values (sam_functionId_s.nextval, 'take.published.assessment',
       'Take Assessment','Take Assessment', '81');
INSERT INTO SAM_FUNCTIONDATA_T
        values (sam_functionId_s.nextval, 'view.published.assessment',
        'View Assessment','View Assessment', '81');
INSERT INTO SAM_FUNCTIONDATA_T
        values (sam_functionId_s.nextval, 'submit.assessment',
       'Submit Assessment','Submit Assessment', '81');
INSERT INTO SAM_FUNCTIONDATA_T
        values (sam_functionId_s.nextval, 'submit.assessment.forgrade',
        'Submit Assessment For Grade','Submit Assessment For Grade', '81');

-- 6 new assessment types added in samigo 2.2 --
INSERT INTO SAM_ASSESSMENTBASE_T (ID ,ISTEMPLATE ,
    PARENTID ,TITLE ,DESCRIPTION ,COMMENTS,
    ASSESSMENTTEMPLATEID, TYPEID, INSTRUCTORNOTIFICATION,
    TESTEENOTIFICATION , MULTIPARTALLOWED, STATUS,
    CREATEDBY, CREATEDDATE, LASTMODIFIEDBY,
    LASTMODIFIEDDATE )
    VALUES (sam_assessmentBase_id_s.nextVal,1 ,0 ,'Formative Assessment' , 'System Defined Assessment Type', '', NULL
    ,'142' ,1 ,1 ,1 ,1 ,'admin' ,SYSDATE ,'admin' ,SYSDATE  )
;     

INSERT INTO SAM_ASSESSEVALUATION_T (ASSESSMENTID,
    EVALUATIONCOMPONENTS, SCORINGTYPE, NUMERICMODELID,
    FIXEDTOTALSCORE, GRADEAVAILABLE, ISSTUDENTIDPUBLIC,
    ANONYMOUSGRADING, AUTOSCORING,TOGRADEBOOK)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
     '' ,1 ,'' , NULL , NULL , NULL ,1 , NULL ,2  )
;
INSERT INTO SAM_ASSESSFEEDBACK_T (ASSESSMENTID,
    FEEDBACKDELIVERY, FEEDBACKAUTHORING, SHOWQUESTIONTEXT, SHOWSTUDENTRESPONSE,
    SHOWCORRECTRESPONSE, SHOWSTUDENTSCORE, SHOWSTUDENTQUESTIONSCORE,
    SHOWQUESTIONLEVELFEEDBACK, SHOWSELECTIONLEVELFEEDBACK,
    SHOWGRADERCOMMENTS, SHOWSTATISTICS, EDITCOMPONENTS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      1 ,3, 1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1  )
;
INSERT INTO SAM_ASSESSACCESSCONTROL_T (ASSESSMENTID,
    SUBMISSIONSALLOWED, SUBMISSIONSSAVED, ASSESSMENTFORMAT,
    BOOKMARKINGITEM, TIMELIMIT, TIMEDASSESSMENT,
    RETRYALLOWED, LATEHANDLING, STARTDATE, DUEDATE,
    SCOREDATE, FEEDBACKDATE, RETRACTDATE, AUTOSUBMIT,
    ITEMNAVIGATION, ITEMNUMBERING, SUBMISSIONMESSAGE,
    RELEASETO, USERNAME, PASSWORD, FINALPAGEURL,
    UNLIMITEDSUBMISSIONS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
                      NULL,1 ,1 , NULL , NULL , NULL , NULL ,1 ,
                      NULL, NULL, NULL, NULL, NULL,
                      1 ,2 ,1 ,'' ,'' ,'' ,'' ,'' ,
                      1  )
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'finalPageURL_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'anonymousRelease_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'dueDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'description_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataQuestions_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'bgImage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackComponents_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'retractDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessmentAutoSubmit_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'toGradebook_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayChunking_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'recordedScore_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'authenticatedRelease_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayNumbering_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionMessage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'assessmentAuthor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'passwordRequired_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'author', '')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionModel_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'ipAccessType_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessment_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataAssess_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'bgColor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'testeeIdentity_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'templateInfo_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'itemAccessType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'lateHandling_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackAuthoring_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseTo', 'SITE_MEMBERS')
;

INSERT INTO SAM_ASSESSMENTBASE_T (ID ,ISTEMPLATE ,
    PARENTID ,TITLE ,DESCRIPTION ,COMMENTS,
    ASSESSMENTTEMPLATEID, TYPEID, INSTRUCTORNOTIFICATION,
    TESTEENOTIFICATION , MULTIPARTALLOWED, STATUS,
    CREATEDBY, CREATEDDATE, LASTMODIFIEDBY,
    LASTMODIFIEDDATE )
    VALUES (sam_assessmentBase_id_s.nextVal,1 ,0 ,'Quiz' , 'System Defined Assessment Type', '', NULL
    ,'142' ,1 ,1 ,1 ,1 ,'admin' ,SYSDATE ,'admin' ,SYSDATE  )
;     

INSERT INTO SAM_ASSESSEVALUATION_T (ASSESSMENTID,
    EVALUATIONCOMPONENTS, SCORINGTYPE, NUMERICMODELID,
    FIXEDTOTALSCORE, GRADEAVAILABLE, ISSTUDENTIDPUBLIC,
    ANONYMOUSGRADING, AUTOSCORING,TOGRADEBOOK)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
     '' ,1 ,'' , NULL , NULL , NULL ,2 , NULL ,2  )
;
INSERT INTO SAM_ASSESSFEEDBACK_T (ASSESSMENTID,
    FEEDBACKDELIVERY, FEEDBACKAUTHORING, SHOWQUESTIONTEXT, SHOWSTUDENTRESPONSE,
    SHOWCORRECTRESPONSE, SHOWSTUDENTSCORE, SHOWSTUDENTQUESTIONSCORE,
    SHOWQUESTIONLEVELFEEDBACK, SHOWSELECTIONLEVELFEEDBACK,
    SHOWGRADERCOMMENTS, SHOWSTATISTICS, EDITCOMPONENTS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      2 ,1, 1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1  )
;
INSERT INTO SAM_ASSESSACCESSCONTROL_T (ASSESSMENTID,
    SUBMISSIONSALLOWED, SUBMISSIONSSAVED, ASSESSMENTFORMAT,
    BOOKMARKINGITEM, TIMELIMIT, TIMEDASSESSMENT,
    RETRYALLOWED, LATEHANDLING, STARTDATE, DUEDATE,
    SCOREDATE, FEEDBACKDATE, RETRACTDATE, AUTOSUBMIT,
    ITEMNAVIGATION, ITEMNUMBERING, SUBMISSIONMESSAGE,
    RELEASETO, USERNAME, PASSWORD, FINALPAGEURL,
    UNLIMITEDSUBMISSIONS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
                      1,1 ,3 , NULL , NULL , NULL , NULL ,2 ,
                      NULL, NULL, NULL, NULL, NULL,
                      1 ,1 ,1 ,'' ,'' ,'' ,'' ,'' ,
                      0  )
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'finalPageURL_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'anonymousRelease_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'dueDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'description_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataQuestions_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'bgImage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackComponents_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'retractDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessmentAutoSubmit_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'toGradebook_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayChunking_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'recordedScore_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'authenticatedRelease_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayNumbering_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionMessage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'assessmentAuthor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'passwordRequired_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'author', '')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionModel_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'ipAccessType_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessment_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataAssess_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'bgColor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'testeeIdentity_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'templateInfo_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'itemAccessType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'lateHandling_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackAuthoring_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseTo', 'SITE_MEMBERS')
;


INSERT INTO SAM_ASSESSMENTBASE_T (ID ,ISTEMPLATE ,
    PARENTID ,TITLE ,DESCRIPTION ,COMMENTS,
    ASSESSMENTTEMPLATEID, TYPEID, INSTRUCTORNOTIFICATION,
    TESTEENOTIFICATION , MULTIPARTALLOWED, STATUS,
    CREATEDBY, CREATEDDATE, LASTMODIFIEDBY,
    LASTMODIFIEDDATE )
    VALUES (sam_assessmentBase_id_s.nextVal,1 ,0 ,'Problem Set' , 'System Defined Assessment Type', '', NULL
    ,'142' ,1 ,1 ,1 ,1 ,'admin' ,SYSDATE ,'admin' ,SYSDATE  )
;     

INSERT INTO SAM_ASSESSEVALUATION_T (ASSESSMENTID,
    EVALUATIONCOMPONENTS, SCORINGTYPE, NUMERICMODELID,
    FIXEDTOTALSCORE, GRADEAVAILABLE, ISSTUDENTIDPUBLIC,
    ANONYMOUSGRADING, AUTOSCORING,TOGRADEBOOK)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
     '' ,1 ,'' , NULL , NULL , NULL ,2 , NULL ,2  )
;
INSERT INTO SAM_ASSESSFEEDBACK_T (ASSESSMENTID,
    FEEDBACKDELIVERY, FEEDBACKAUTHORING, SHOWQUESTIONTEXT, SHOWSTUDENTRESPONSE,
    SHOWCORRECTRESPONSE, SHOWSTUDENTSCORE, SHOWSTUDENTQUESTIONSCORE,
    SHOWQUESTIONLEVELFEEDBACK, SHOWSELECTIONLEVELFEEDBACK,
    SHOWGRADERCOMMENTS, SHOWSTATISTICS, EDITCOMPONENTS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      2 ,1, 1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1  )
;
INSERT INTO SAM_ASSESSACCESSCONTROL_T (ASSESSMENTID,
    SUBMISSIONSALLOWED, SUBMISSIONSSAVED, ASSESSMENTFORMAT,
    BOOKMARKINGITEM, TIMELIMIT, TIMEDASSESSMENT,
    RETRYALLOWED, LATEHANDLING, STARTDATE, DUEDATE,
    SCOREDATE, FEEDBACKDATE, RETRACTDATE, AUTOSUBMIT,
    ITEMNAVIGATION, ITEMNUMBERING, SUBMISSIONMESSAGE,
    RELEASETO, USERNAME, PASSWORD, FINALPAGEURL,
    UNLIMITEDSUBMISSIONS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
                      NULL,1 ,2 , NULL , NULL , NULL , NULL ,1 ,
                      NULL, NULL, NULL, NULL, NULL,
                      1 ,2 ,1 ,'' ,'' ,'' ,'' ,'' ,
                      1  )
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'finalPageURL_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'anonymousRelease_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'dueDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'description_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataQuestions_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'bgImage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackComponents_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'retractDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessmentAutoSubmit_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'toGradebook_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayChunking_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'recordedScore_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'authenticatedRelease_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayNumbering_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionMessage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'assessmentAuthor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'passwordRequired_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'author', '')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionModel_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'ipAccessType_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessment_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataAssess_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'bgColor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'testeeIdentity_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'templateInfo_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'itemAccessType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'lateHandling_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackAuthoring_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseTo', 'SITE_MEMBERS')
;



INSERT INTO SAM_ASSESSMENTBASE_T (ID ,ISTEMPLATE ,
    PARENTID ,TITLE ,DESCRIPTION ,COMMENTS,
    ASSESSMENTTEMPLATEID, TYPEID, INSTRUCTORNOTIFICATION,
    TESTEENOTIFICATION , MULTIPARTALLOWED, STATUS,
    CREATEDBY, CREATEDDATE, LASTMODIFIEDBY,
    LASTMODIFIEDDATE )
    VALUES (sam_assessmentBase_id_s.nextVal,1 ,0 ,'Survey' , 'System Defined Assessment Type', '', NULL
    ,'142' ,1 ,1 ,1 ,1 ,'admin' ,SYSDATE ,'admin' ,SYSDATE  )
;     

INSERT INTO SAM_ASSESSEVALUATION_T (ASSESSMENTID,
    EVALUATIONCOMPONENTS, SCORINGTYPE, NUMERICMODELID,
    FIXEDTOTALSCORE, GRADEAVAILABLE, ISSTUDENTIDPUBLIC,
    ANONYMOUSGRADING, AUTOSCORING,TOGRADEBOOK)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
     '' ,1 ,'' , NULL , NULL , NULL ,1 , NULL ,2  )
;
INSERT INTO SAM_ASSESSFEEDBACK_T (ASSESSMENTID,
    FEEDBACKDELIVERY, FEEDBACKAUTHORING, SHOWQUESTIONTEXT, SHOWSTUDENTRESPONSE,
    SHOWCORRECTRESPONSE, SHOWSTUDENTSCORE, SHOWSTUDENTQUESTIONSCORE,
    SHOWQUESTIONLEVELFEEDBACK, SHOWSELECTIONLEVELFEEDBACK,
    SHOWGRADERCOMMENTS, SHOWSTATISTICS, EDITCOMPONENTS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      1 ,3, 0 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ,1  )
;
INSERT INTO SAM_ASSESSACCESSCONTROL_T (ASSESSMENTID,
    SUBMISSIONSALLOWED, SUBMISSIONSSAVED, ASSESSMENTFORMAT,
    BOOKMARKINGITEM, TIMELIMIT, TIMEDASSESSMENT,
    RETRYALLOWED, LATEHANDLING, STARTDATE, DUEDATE,
    SCOREDATE, FEEDBACKDATE, RETRACTDATE, AUTOSUBMIT,
    ITEMNAVIGATION, ITEMNUMBERING, SUBMISSIONMESSAGE,
    RELEASETO, USERNAME, PASSWORD, FINALPAGEURL,
    UNLIMITEDSUBMISSIONS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
                      1,1 ,1 , NULL , NULL , NULL , NULL ,1 ,
                      NULL, NULL, NULL, NULL, NULL,
                      1 ,2 ,1 ,'' ,'' ,'' ,'' ,'' ,
                      0  )
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'finalPageURL_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'anonymousRelease_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'dueDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'description_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataQuestions_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'bgImage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackComponents_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'retractDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessmentAutoSubmit_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'toGradebook_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayChunking_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'recordedScore_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'authenticatedRelease_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayNumbering_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionMessage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'assessmentAuthor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'passwordRequired_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'author', '')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionModel_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'ipAccessType_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessment_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataAssess_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'bgColor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'testeeIdentity_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'templateInfo_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'itemAccessType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'lateHandling_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackAuthoring_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Survey'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseTo', 'SITE_MEMBERS')
;


INSERT INTO SAM_ASSESSMENTBASE_T (ID ,ISTEMPLATE ,
    PARENTID ,TITLE ,DESCRIPTION ,COMMENTS,
    ASSESSMENTTEMPLATEID, TYPEID, INSTRUCTORNOTIFICATION,
    TESTEENOTIFICATION , MULTIPARTALLOWED, STATUS,
    CREATEDBY, CREATEDDATE, LASTMODIFIEDBY,
    LASTMODIFIEDDATE )
    VALUES (sam_assessmentBase_id_s.nextVal,1 ,0 ,'Test' , 'System Defined Assessment Type', '', NULL
    ,'142' ,1 ,1 ,1 ,1 ,'admin' ,SYSDATE ,'admin' ,SYSDATE  )
;     

INSERT INTO SAM_ASSESSEVALUATION_T (ASSESSMENTID,
    EVALUATIONCOMPONENTS, SCORINGTYPE, NUMERICMODELID,
    FIXEDTOTALSCORE, GRADEAVAILABLE, ISSTUDENTIDPUBLIC,
    ANONYMOUSGRADING, AUTOSCORING,TOGRADEBOOK)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
     '' ,1 ,'' , NULL , NULL , NULL ,1 , NULL ,2  )
;
INSERT INTO SAM_ASSESSFEEDBACK_T (ASSESSMENTID,
    FEEDBACKDELIVERY, FEEDBACKAUTHORING, SHOWQUESTIONTEXT, SHOWSTUDENTRESPONSE,
    SHOWCORRECTRESPONSE, SHOWSTUDENTSCORE, SHOWSTUDENTQUESTIONSCORE,
    SHOWQUESTIONLEVELFEEDBACK, SHOWSELECTIONLEVELFEEDBACK,
    SHOWGRADERCOMMENTS, SHOWSTATISTICS, EDITCOMPONENTS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      2 ,1, 1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1  )
;
INSERT INTO SAM_ASSESSACCESSCONTROL_T (ASSESSMENTID,
    SUBMISSIONSALLOWED, SUBMISSIONSSAVED, ASSESSMENTFORMAT,
    BOOKMARKINGITEM, TIMELIMIT, TIMEDASSESSMENT,
    RETRYALLOWED, LATEHANDLING, STARTDATE, DUEDATE,
    SCOREDATE, FEEDBACKDATE, RETRACTDATE, AUTOSUBMIT,
    ITEMNAVIGATION, ITEMNUMBERING, SUBMISSIONMESSAGE,
    RELEASETO, USERNAME, PASSWORD, FINALPAGEURL,
    UNLIMITEDSUBMISSIONS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
                      1,1 ,1 , NULL , NULL , NULL , NULL ,2 ,
                      NULL, NULL, NULL, NULL, NULL,
                      1 ,1 ,1 ,'' ,'' ,'' ,'' ,'' ,
                      0  )
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'finalPageURL_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'anonymousRelease_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'dueDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'description_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataQuestions_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'bgImage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackComponents_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'retractDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessmentAutoSubmit_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'toGradebook_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayChunking_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'recordedScore_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'authenticatedRelease_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayNumbering_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionMessage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'assessmentAuthor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'passwordRequired_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'author', '')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionModel_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'ipAccessType_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessment_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataAssess_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'bgColor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'testeeIdentity_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'templateInfo_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'itemAccessType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'lateHandling_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackAuthoring_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseTo', 'SITE_MEMBERS')
;


INSERT INTO SAM_ASSESSMENTBASE_T (ID ,ISTEMPLATE ,
    PARENTID ,TITLE ,DESCRIPTION ,COMMENTS,
    ASSESSMENTTEMPLATEID, TYPEID, INSTRUCTORNOTIFICATION,
    TESTEENOTIFICATION , MULTIPARTALLOWED, STATUS,
    CREATEDBY, CREATEDDATE, LASTMODIFIEDBY,
    LASTMODIFIEDDATE )
    VALUES (sam_assessmentBase_id_s.nextVal,1 ,0 ,'Timed Test' , 'System Defined Assessment Type', '', NULL
    ,'142' ,1 ,1 ,1 ,1 ,'admin' ,SYSDATE ,'admin' ,SYSDATE)
;     

INSERT INTO SAM_ASSESSEVALUATION_T (ASSESSMENTID,
    EVALUATIONCOMPONENTS, SCORINGTYPE, NUMERICMODELID,
    FIXEDTOTALSCORE, GRADEAVAILABLE, ISSTUDENTIDPUBLIC,
    ANONYMOUSGRADING, AUTOSCORING,TOGRADEBOOK)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
     '' ,1 ,'' , NULL , NULL , NULL ,1 , NULL ,2  )
;
INSERT INTO SAM_ASSESSFEEDBACK_T (ASSESSMENTID,
    FEEDBACKDELIVERY, FEEDBACKAUTHORING, SHOWQUESTIONTEXT, SHOWSTUDENTRESPONSE,
    SHOWCORRECTRESPONSE, SHOWSTUDENTSCORE, SHOWSTUDENTQUESTIONSCORE,
    SHOWQUESTIONLEVELFEEDBACK, SHOWSELECTIONLEVELFEEDBACK,
    SHOWGRADERCOMMENTS, SHOWSTATISTICS, EDITCOMPONENTS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      2 ,1, 1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1  )
;
INSERT INTO SAM_ASSESSACCESSCONTROL_T (ASSESSMENTID,
    SUBMISSIONSALLOWED, SUBMISSIONSSAVED, ASSESSMENTFORMAT,
    BOOKMARKINGITEM, TIMELIMIT, TIMEDASSESSMENT,
    RETRYALLOWED, LATEHANDLING, STARTDATE, DUEDATE,
    SCOREDATE, FEEDBACKDATE, RETRACTDATE, AUTOSUBMIT,
    ITEMNAVIGATION, ITEMNUMBERING, SUBMISSIONMESSAGE,
    RELEASETO, USERNAME, PASSWORD, FINALPAGEURL,
    UNLIMITEDSUBMISSIONS)
    VALUES ((SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
                      1,1 ,1 , NULL , NULL , NULL , NULL ,2 ,
                      NULL, NULL, NULL, NULL, NULL,
                      1 ,1 ,1 ,'' ,'' ,'' ,'' ,'' ,
                      0  )
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'finalPageURL_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'anonymousRelease_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'dueDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'description_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataQuestions_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
     'bgImage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackComponents_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'retractDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessmentAutoSubmit_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'toGradebook_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayChunking_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'recordedScore_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'authenticatedRelease_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'displayNumbering_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionMessage_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseDate_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'assessmentAuthor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'passwordRequired_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'author', '')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'submissionModel_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'ipAccessType_isInstructorEditable', 'false')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'timedAssessment_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'metadataAssess_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'bgColor_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'testeeIdentity_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'templateInfo_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'itemAccessType_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'lateHandling_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'feedbackAuthoring_isInstructorEditable', 'true')
;
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL,
    ENTRY)
    VALUES(sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test'
     AND TYPEID='142' AND ISTEMPLATE=1),
      'releaseTo', 'SITE_MEMBERS')
;

commit;


-- -----------

-- add GMT tables
drop table GMT_CONTEXT_ASSOCIATION cascade constraints;
drop table GMT_GOAL cascade constraints;
drop table GMT_GOALSET cascade constraints;
drop table GMT_LINK cascade constraints;
drop table GMT_RATING cascade constraints;
create table GMT_CONTEXT_ASSOCIATION (FROM_CONTEXT varchar2(99 char) not null, TO_CONTEXT varchar2(99 char) not null, VERSION number(10,0) not null, constraint PK_GMT_CONTEXT_ASSOCIATION primary key (FROM_CONTEXT, TO_CONTEXT));
-- create table GMT_CONTEXT_ASSOCIATION (FROM_CONTEXT varchar2(99 char) not null, TO_CONTEXT varchar2(99 char) not null, VERSION number(10,0) not null, primary key (FROM_CONTEXT, TO_CONTEXT));
create table GMT_GOAL (ID varchar2(36 char) not null, VERSION number(10,0) not null, TITLE varchar2(255 char), DESCRIPTION clob, GOALSET_ID varchar2(36 char) not null, PARENT_GOAL_ID varchar2(36 char), constraint PK_GMT_GOAL primary key (ID));
-- create table GMT_GOAL (ID varchar2(36 char) not null, VERSION number(10,0) not null, TITLE varchar2(255 char), DESCRIPTION clob, GOALSET_ID varchar2(36 char) not null, PARENT_GOAL_ID varchar2(36 char), primary key (ID));
create table GMT_GOALSET (ID varchar2(36 char) not null, VERSION number(10,0) not null, SUGGESTED_BY varchar2(36 char), TITLE varchar2(255 char), DESCRIPTION clob, CONTEXT varchar2(99 char) not null, PUBLISHED number(1,0) not null, constraint PK_GMT_GOALSET primary key (ID));
-- create table GMT_GOALSET (ID varchar2(36 char) not null, VERSION number(10,0) not null, SUGGESTED_BY varchar2(36 char), TITLE varchar2(255 char), DESCRIPTION clob, CONTEXT varchar2(99 char) not null, PUBLISHED number(1,0) not null, primary key (ID));
create table GMT_LINK (ID varchar2(36 char) not null, VERSION number(10,0) not null, ACTIVITY_REF varchar2(255 char) not null, GOAL_ID varchar2(36 char) not null, RUBRIC clob, RATIONALE clob, EXPORT_STRING number(10,0) not null, VISIBLE number(1,0) not null, constraint PK_GMT_LINK primary key (ID), constraint UK_GMT_LINK unique (ACTIVITY_REF, GOAL_ID));
-- create table GMT_LINK (ID varchar2(36 char) not null, VERSION number(10,0) not null, ACTIVITY_REF varchar2(255 char) not null, GOAL_ID varchar2(36 char) not null, RUBRIC clob, RATIONALE clob, EXPORT_STRING number(10,0) not null, VISIBLE number(1,0) not null, primary key (ID), unique (ACTIVITY_REF, GOAL_ID));
create table GMT_RATING (ID varchar2(36 char) not null, VERSION number(10,0) not null, ITEM_REF varchar2(255 char) not null, LINK_ID varchar2(36 char) not null, RATING varchar2(255 char) not null, COMMENTS clob, constraint PK_GMT_RATING primary key (ID), constraint UK_GMT_RATING unique (ITEM_REF, LINK_ID));
-- create table GMT_RATING (ID varchar2(36 char) not null, VERSION number(10,0) not null, ITEM_REF varchar2(255 char) not null, LINK_ID varchar2(36 char) not null, RATING varchar2(255 char) not null, COMMENTS clob, primary key (ID), unique (ITEM_REF, LINK_ID));
alter table GMT_GOAL add constraint FK4D66888484568B1C foreign key (GOALSET_ID) references GMT_GOALSET;
alter table GMT_GOAL add constraint FK4D6688846E3F0D23 foreign key (PARENT_GOAL_ID) references GMT_GOAL;
alter table GMT_LINK add constraint FK4D68B96B5F1AA7B8 foreign key (GOAL_ID) references GMT_GOAL;
alter table GMT_RATING add constraint FK9FEF1ECE3E34DED8 foreign key (LINK_ID) references GMT_LINK;

commit;


-- This change was introducted in 2.4.x.  No
-- such changes should NOT be introducted into 
-- a maintenance branch, but so it goes.

prompt add column to MFR message table.


-- SAK-9808: Implement ability to delete threaded messages within Forums
-- need to add a bit field and index on it

-- alter table MFR_MESSAGE_T add DELETED number(1, 0) not null;
-- create index MFR_MESSAGE_DELETED_I on MFR_MESSAGE_T (DELETED);

-- Changed at Michigan  default added since we changed an existing table.
-- index put in tablespace.  Probably not needed.
alter table MFR_MESSAGE_T add DELETED number(1, 0) default 0 not null;
create index MFR_MESSAGE_DELETED_I on MFR_MESSAGE_T (DELETED) tablespace ctools_indexes;

commit;
-- end


