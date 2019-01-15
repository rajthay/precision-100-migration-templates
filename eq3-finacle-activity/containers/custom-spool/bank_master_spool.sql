
-- File Name		: bank_master_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 28-09-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 800
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/ebanking/bank_master.txt
select
TRIM(DB_TS) ||'|'||
TRIM(BANK_REF_NO) ||'|'||
TRIM(HOST_BANK_CODE) ||'|'||
TRIM(HOST_BRANCH_CODE) ||'|'||
TRIM(DEL_FLG) ||'|'||
TRIM(R_MOD_ID) ||'|'||
TRIM(R_MOD_TIME) ||'|'||
TRIM(R_CRE_ID) ||'|'||
TRIM(R_CRE_TIME)
from BANK_MASTER_O_TABLE;
exit;
 
