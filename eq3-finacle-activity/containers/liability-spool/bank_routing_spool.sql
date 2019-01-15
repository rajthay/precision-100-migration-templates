-- File Name		: bank_routing_spool.sql
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
spool $MIG_PATH/output/finacle/ebanking/bank_routing.txt
select
TRIM(DB_TS) ||'|'||
TRIM(BANK_REF_NO) ||'|'||
TRIM(NETWORK_TYPE) ||'|'||
TRIM(SEQ_NO) ||'|'||
TRIM(ROUTING_NO) ||'|'||
TRIM(ROUTING_NUMBER_SOURCE) ||'|'||
TRIM(R_MOD_ID) ||'|'||
TRIM(R_MOD_TIME) ||'|'||
TRIM(R_CRE_ID) ||'|'||
TRIM(R_CRE_TIME) ||'|'||
TRIM(DEL_FLG)
from BANK_ROUTING_O_TABLE;
exit;
 
