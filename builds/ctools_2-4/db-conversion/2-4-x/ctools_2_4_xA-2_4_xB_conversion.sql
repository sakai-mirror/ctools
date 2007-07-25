-- Convert db from the UMich 2.4.xA to 2.4.xB.

-- $HeadURL:$
-- $Id:$




-- These are changes from trunk.
-- From revision 30105 of $S/reference/trunk/docs/conversion/sakai_2_4_0-2_5_0_oracle_conversion.sql

prompt SAK-9725 changes
-- This is the Oracle Sakai 2.4.0 (or later) -> 2.5.0 conversion script
----------------------------------------------------------------------------------------------------------------------------------------
--
-- use this to convert a Sakai database from 2.4.0 to 2.5.0.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
----------------------------------------------------------------------------------------------------------------------------------------

--metaobj conversion
alter TABLE metaobj_form_def add alternateCreateXslt varchar2(36) NULL;
alter TABLE metaobj_form_def add alternateViewXslt varchar2(36) NULL;

-- end SAK-9725

prompt SAK-9808
-- SAK-9808: Implement ability to delete threaded messages within Forums
alter table MFR_MESSAGE_T add DELETED number(1, 0) default '0' not null;
update MFR_MESSAGE_T set DELETED=0 where DELETED is NULL;
create index MFR_MESSAGE_DELETED_I on MFR_MESSAGE_T (DELETED);

-- end SAK-9808


-- SAK-10454: Added indexes to imporve Samigo performance
-- create index SAM_AMETADATA_ASSESSMENTID_I on SAM_ASSESSMETADATA_T (ASSESSMENTID);
-- create index SAM_ANSWER_ITEMID_I on SAM_ANSWER_T (ITEMID);
-- create index SAM_ASSGRAD_AID_PUBASSEID_T on SAM_ASSESSMENTGRADING_T (AGENTID,PUBLISHEDASSESSMENTID);
-- create index SAM_PUBMETDATA_ASSESSMENT_I on SAM_PUBLISHEDMETADATA_T(ASSESSMENTID);
-- create index SAM_QPOOLITEM_QPOOL_I on SAM_QUESTIONPOOLITEM_T (QUESTIONPOOLID);
-- create index SAM_SECUREDIP_ASSESSMENTID_I on SAM_SECUREDIP_T (ASSESSMENTID);
-- create index SAM_SECTION_ASSESSMENTID_I on SAM_SECTION_T (ASSESSMENTID);
-- create index SAM_SECTIONMETA_SECTIONID_I on SAM_SECTIONMETADATA_T (SECTIONID);

