---------------------------------------------------------------------------------------------------------------
-- backfill new site permissions into existing site realms.
---------------------------------------------------------------------------------------------------------------
-- This failed in the original 2.1.2 -> 2.2.0 conversion.  This is a fixed version of that sql.

-- $HeadURL$
-- $Id$



-- for each realm that has a grant of the 'annc.all.groups', we add these others:
prompt create temp permission table.
CREATE TABLE PERMISSIONS_TEMP (FUNCTION_KEY INTEGER);
INSERT INTO PERMISSIONS_TEMP VALUES ((SELECT FUNCTION_KEY FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME ='asn.all.groups'));
INSERT INTO PERMISSIONS_TEMP VALUES ((SELECT FUNCTION_KEY FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME ='calendar.all.groups'));
INSERT INTO PERMISSIONS_TEMP VALUES ((SELECT FUNCTION_KEY FROM SAKAI_REALM_FUNCTION WHERE FUNCTION_NAME ='content.all.groups'));


-- this is wrong, since the join will prevent anything from being found (the function name isn't in the temp table),
-- so use the following one.

-- INSERT INTO SAKAI_REALM_RL_FN (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
-- SELECT
--     SRRF.REALM_KEY, SRRF.ROLE_KEY, TMP.FUNCTION_KEY
-- FROM
--     SAKAI_REALM_RL_FN SRRF
--     JOIN PERMISSIONS_TEMP TMP ON (SRRF.FUNCTION_KEY = TMP.FUNCTION_KEY)
--     WHERE SRRF.FUNCTION_KEY = (SELECT FUNCTION_KEY FROM SAKAI_REALM_FUNCTION SRF WHERE SRF.FUNCTION_NAME ='annc.all.groups')
--     AND NOT EXISTS (
--         SELECT 1
--             FROM SAKAI_REALM_RL_FN SRRFI
--             WHERE SRRFI.REALM_KEY=SRRF.REALM_KEY AND SRRFI.ROLE_KEY=SRRF.ROLE_KEY AND SRRFI.FUNCTION_KEY=TMP.FUNCTION_KEY
--     );

-- sample
-- -- construct tuples for update 
-- -- based on function key and realm  Realm is just to restrict the size of the query
-- -- and should be deleted when do for real.
-- insert  into SAKAI_REALM_RL_FN (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
-- select SRRF.REALM_KEY, SRRF.ROLE_KEY, TMP.FUNCTION_KEY
-- from  SAKAI_REALM_RL_FN SRRF, DLH_PERMISSIONS_TEMP TMP
-- where SRRF.FUNCTION_KEY = 169 and SRRF.REALM_KEY=76769  
-- AND NOT EXISTS (
--         SELECT 1
--             FROM SAKAI_REALM_RL_FN SRRFI
--             WHERE SRRFI.REALM_KEY=SRRF.REALM_KEY AND SRRFI.ROLE_KEY=SRRF.ROLE_KEY AND SRRFI.FUNCTION_KEY=TMP.FUNCTION_KEY)

prompt update the *.all.groups permissions based on the occurance of annc.all.groups in a realm.

insert  into SAKAI_REALM_RL_FN (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
select SRRF.REALM_KEY, SRRF.ROLE_KEY, TMP.FUNCTION_KEY
from  SAKAI_REALM_RL_FN SRRF, PERMISSIONS_TEMP TMP
where SRRF.FUNCTION_KEY = (SELECT FUNCTION_KEY FROM SAKAI_REALM_FUNCTION SRF WHERE SRF.FUNCTION_NAME ='annc.all.groups')
AND NOT EXISTS (
        SELECT 1
            FROM SAKAI_REALM_RL_FN SRRFI
            WHERE SRRFI.REALM_KEY=SRRF.REALM_KEY AND SRRFI.ROLE_KEY=SRRF.ROLE_KEY AND SRRFI.FUNCTION_KEY=TMP.FUNCTION_KEY);

prompt delete temporary permissions table

DROP TABLE PERMISSIONS_TEMP;

prompt update finished.

-- end


