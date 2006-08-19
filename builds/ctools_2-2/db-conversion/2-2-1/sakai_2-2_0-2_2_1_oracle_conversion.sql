-- This is the Oracle Sakai 2.2.0 -> 2.2.1 conversion script

-- This version annotated for UMich CTools

-- $HeadURL$
-- $Id$

----------------------------------------------------------------------------------------------------------------------------------------
--
-- use this to convert a Sakai database from 2.2.0 to 2.2.1.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
----------------------------------------------------------------------------------------------------------------------------------------

-- OSP-1607
-- http://bugs.osportfolio.org/jira/browse/OSP-1607
-- Increasing the size of fields that hold a site id to 99.  Some were not specifying a length and would result in a length of 255.  I'm leaving those alone for now.

-- UMICH: -- unclear if necessary, since size of column is unclear
prompt OSP-1607 Alter osp table site_id size

alter table osp_guidance modify site_id varchar2(99);
alter table osp_review modify site_id varchar2(99);
alter table osp_style modify site_id varchar2(99);
alter table osp_site_tool modify site_id varchar2(99);
alter table osp_presentation_template modify site_id varchar2(99);
alter table osp_presentation modify site_id varchar2(99);
alter table osp_presentation_layout modify site_id varchar2(99);
alter table osp_wizard modify site_id varchar2(99);

--------------------------------------------------------------------------------

-- SAK-5595
-- http://bugs.sakaiproject.org/jira/browse/SAK-5595
-- Conversion script error: missing column DURATION in SAM_MEDIA_T

-- UMICH: Use this.
prompt SAK-5595 Alter Sam media table
alter table SAM_MEDIA_T add (DURATION varchar(36)); 

---------------------------------------------------------------------------------

-- UMICH: Modified for local needs.

prompt OSP-1289 (modified) add metaobj.delete permissions

-- OSP-1289
-- http://bugs.osportfolio.org/jira/browse/OSP-1289
-- Need to add delete to the default metaobj permissions

-- This exists in testctools and production
INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'metaobj.delete');
-- There is no maintain role for UMich !site.template	
-- INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'metaobj.delete'));

-- So give it to the other maintain role (Owner) in !site.template
-- !site.template changes
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'metaobj.delete'));

-- !site.template.course
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'metaobj.delete'));
-- These 2 added per John L.
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'metaobj.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Affilate'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'metaobj.delete'));

-- These 2 added per John L.
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Owner'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'metaobj.delete'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.project'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Organizer'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'metaobj.delete'));

-- From original script
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'metaobj.delete'));

commit;

----------------------------------------------------------------------------------

-- UMICH: Use this.

prompt SAK-5564 Modify SAM ITEMGRADING SUBMITTEDDATE

-- SAK-5564
-- http://bugs.sakaiproject.org/jira/browse/SAK-5564
--  exception thrown when trying to update

alter table SAM_ITEMGRADING_T modify (SUBMITTEDDATE date null);

