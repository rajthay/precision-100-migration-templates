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
spool $MIG_PATH/output/finacle/custom/coladvent.txt
select 
trim(CIF_ID)    ||'|'||
trim(INSTR_CODE)    ||'|'||
trim(INSTR_DESC)    ||'|'||
trim(INSTR_NAME)    ||'|'||
trim(INSTR_REF_CRNCY)    ||'|'||
trim(ISIN_OR_TICKER)    ||'|'||
trim(UNIT_PRICE)    ||'|'||
trim(QUANTITY)    ||'|'||
trim(BANK_ID)    ||'|'||
trim(ENTITY_CRE_FLG)    ||'|'||
trim(DEL_FLG)    
from custom_Col_Advent_o_table ;
exit; 
