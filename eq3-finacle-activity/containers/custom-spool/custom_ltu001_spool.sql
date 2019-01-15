-- File Name		: custom_cchot01_spool.sql
-- File Created for	: Spooling file for Lockers details customization.
-- Created By		: Revathi
-- Client		    : EIB
-- Created On		: 29-11-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 169
set page size 0
set pages 0
--#set trimspool on
column filename new_value filename;
select '/output/finacle/locker/custom_ltu001_'||param_value||'_'||to_char(sysdate,'DDMMYYYY_HHMISS') filename from system_config where param_name='COUNTRY_CODE';
spool $MIG_PATH&filename..txt;
--#spool $MIG_PATH/output/finacle/locker/custom_ltu001.txt
select
SOL_ID    ||
LOCKER_TYPE    ||
BRANCH_CLASSIFICATION    ||
REMARKS    ||
START_DATE    ||
END_DATE    ||
DELETE_FLAG    ||
RENT_EVENT_ID    
from custom_ltu001_o_table;
spool off;
exit;
 
