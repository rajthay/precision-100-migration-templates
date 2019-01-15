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
spool $MIG_PATH/output/finacle/custom/colguarantee.txt
select 
trim(SECU_LINKAGE_TYPE)    ||'|'||
trim(SECU_SRL_NUM)    ||'|'||
trim(BANK_ID)    ||'|'||
trim(ENTITY_CRE_FLG)    ||'|'||
trim(DEL_FLG)    ||'|'||
trim(FREE_FIELD1)    ||'|'||
trim(FREE_FIELD2)    ||'|'||
trim(FREE_FIELD3)    ||'|'||
trim(FREE_FIELD4)    ||'|'||
trim(JOINT_INDIVIDUAL)    ||'|'||
trim(LIMITED)    ||'|'||
trim(GUARANTOR_ID)    ||'|'||
trim(GUARANTOR_NAME1)    ||'|'||
trim(GUARANTOR_NAME2)    ||'|'||
trim(GUARANTOR_NAME3)    ||'|'||
trim(GUARANTOR_NAME4)    ||'|'||
trim(GUARANTOR_NAME5)    ||'|'||
trim(GUARANTOR_NAME6)    ||'|'||
trim(GUARANTOR_NAME7)    ||'|'||
trim(GUARANTOR_NAME8)    ||'|'||
trim(GUARANTOR_NAME9)    ||'|'||
trim(GUARANTOR_NAME10)    ||'|'||
trim(BOARD_RES)    ||'|'||
trim(ATTESTATIONBY)    ||'|'||
trim(COLLATERAL_TYPE_VALUE)    
from CUSTOM_COL_GUARANTEE_O_TABLE;
exit; 
