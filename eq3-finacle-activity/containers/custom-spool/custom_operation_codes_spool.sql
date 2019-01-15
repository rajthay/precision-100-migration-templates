-- File Name		: custom_operation_codes_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Kumaresan.B
-- Client		    : ABK
-- Created On		: 15-05-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/custom/operation_codes.txt
select
trim(REASON_CODE_DESC)    ||'|'||
trim(OPERATION)    ||'|'||
trim(REASON_CODE)    ||'|'||
trim(REASON_DESC)    ||'|'||
trim(REASON_CODE_REMOVED)    ||'|'||
trim(START_DATE)    ||'|'||
trim(EXPIRY_DATE)    ||'|'||
trim(USERFIELD1)    ||'|'||
trim(USERFIELD2)    ||'|'||
trim(USERFIELD3)    ||'|'||
trim(USERFIELD4)    ||'|'||
trim(USERFIELD5)    ||'|'||
trim(USERFIELD6)    ||'|'||
trim(USERFIELD7)    ||'|'||
trim(ORGKEY)    ||'|'||
trim(BANK_ID)
from CUSTOM_OPERATION_REASON_CODES;
spool off;
exit; 
