
-- File Name		: Custom_ltu001_upload.sql
-- File Created for	: Lockers Customisation
-- Created By		: Sharanappa
-- Client		    : ABK
-- Created On		: 21-10-2016
-------------------------------------------------------------------
truncate table custom_ltu001_o_table;
insert into custom_ltu001_o_table
select distinct
--  SOL_ID                 NVARCHAR2(8),
lpad(fin_sol_id,8,' '),
--  LOCKER_TYPE            NVARCHAR2(10),
lpad(trim(SDBTYP),10,' '),
--  BRANCH_CLASSIFICATION  NVARCHAR2(5),
lpad('',5,' '),--BRANCH_CLASSIFICATION
--  REMARKS                NVARCHAR2(100),
lpad(' ',100,' '),
--  START_DATE             NVARCHAR2(10),
lpad(trim('01-01-1900'),10,' '),
--  END_DATE               NVARCHAR2(10),
lpad('31-12-2099',10,' '),--as per andrew conformation default to 31-12-2099 changed on 03-02-2016
--  DELETE_FLAG            NVARCHAR2(1),
lpad('N',1,' '),
--  RENT_EVENT_ID          NVARCHAR2(25)
lpad(' ',25,' ')--RENT_EVENT_ID nedd to ask
--lpad('LOCKER RENTAL MIGRATION',25,' ')
from YSDBPF
inner join map_sol on br_code=SDBBRNM;
commit;
exit;
 
