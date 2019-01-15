-- File Name		: CUSTOM_COL_LINKAGE_spool.sql
-- File Created for	: Upload file for col
-- Created By		: Revathi
-- Client		    : Emirates Islamic Bank
-- Created On		: 28-12-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/custom/colsecurity.txt
select 
trim(SECU_CODE)    ||'|'||
trim(SECU_TYPE)    ||'|'||
trim(COLLATERAL_TYPE_VALUE)    ||'|'||
trim(BANK_ID)    ||'|'||
trim(DEL_FLG)    ||'|'||
trim(ENTITY_CRE_FLG)    ||'|'||
trim(FREE_FIELD1)    ||'|'||
trim(FREE_FIELD2)    ||'|'||
trim(FREE_FIELD3)    ||'|'||
trim(FREE_FIELD4)    
from CUSTOM_COL_SECU_O_TABLE;
exit; 
