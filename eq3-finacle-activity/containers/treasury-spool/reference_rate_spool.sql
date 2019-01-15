-- File Name		: reference_rate_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 28-09-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/treasury/REFERENCE_RATE.TXT
SELECT 
'RESPONSE'||'|'|| 
'Rate Code'||'|'|| 
'Rate Currency'||'|'|| 
'Rate Value'||'|'|| 
'Effective Date'||'|'|| 
'COMMENTS'
FROM DUAL
UNION ALL
select
TO_CHAR(
TRIM(RESPONSE)||'|'||
TRIM("Rate Code")||'|'||
TRIM("Rate Currency")||'|'||
TRIM("Rate Value")||'|'||
TRIM("Effective Date")||'|'||
TRIM(COMMENTS)
)
from REFERENCE_RATE_O_TABLE;
exit; 
