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

