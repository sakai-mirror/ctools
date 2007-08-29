-- $HeadURL$
-- $Id$

--Chat SAK-10163
 ALTER TABLE CHAT2_CHANNEL ADD PLACEMENT_ID varchar2(99) NULL;
 ALTER TABLE CHAT2_CHANNEL RENAME COLUMN contextDefaultChannel TO placementDefaultChannel;
	 
--  update CHAT2_CHANNEL cc
--  set cc.PLACEMENT_ID = (select st.TOOL_ID from SAKAI_SITE_TOOL st where st.REGISTRATION = 'sakai.chat'
--     and cc.placementDefaultChannel = 1
--     and cc.CONTEXT = st.SITE_ID )
--  where EXISTS
--  (select st.TOOL_ID from SAKAI_SITE_TOOL st where st.REGISTRATION = 'sakai.chat'
--     and cc.placementDefaultChannel = 1
--     and cc.CONTEXT = st.SITE_ID)

update CHAT2_CHANNEL cc
   set cc.PLACEMENT_ID = (select st.TOOL_ID from SAKAI_SITE_TOOL st where st.REGISTRATION = 'sakai.chat'
      and cc.placementDefaultChannel = 1
      and cc.CONTEXT = st.SITE_ID 
      and ROWNUM = 1 )
   where EXISTS
   (select st.TOOL_ID from SAKAI_SITE_TOOL st where st.REGISTRATION = 'sakai.chat'
      and cc.placementDefaultChannel = 1
      and cc.CONTEXT = st.SITE_ID 
      and ROWNUM = 1);

-- SAK-11204 	  	 
-- Force this to happen and report problems bu having a non failing SQL statement first
SELECT 1 FROM DUAL;

ALTER TABLE CALENDAR_EVENT ADD COLUMN(RANGE_START INTEGER), COLUMN(RANGE_END INTEGER);

CREATE INDEX CALENDAR_EVENT_RSTART ON CALENDAR_EVENT(RANGE_START);
CREATE INDEX CALENDAR_EVENT_REND ON CALENDAR_EVENT(RANGE_END);
