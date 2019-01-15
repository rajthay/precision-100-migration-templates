-- File Name		: yield_curve_spool.sql
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
spool $MIG_PATH/output/finacle/treasury/YIELD_CURVE.TXT
SELECT 
'RESPONSE'||'|'||
'MRS_CURVE_ID'||'|'||
'TYPE'||'|'||
'DAY_CONVENTION'||'|'||
'CALENDAR_SET'||'|'||
'BASE_DATE'||'|'||
'CURVE_TYPE'
FROM DUAL
UNION ALL
select
TO_CHAR(TRIM(RESPONSE)||'|'||
TRIM(CURVE_ID)||'|'||
TRIM(TYPE)||'|'||
TRIM(DAY_CONVENTION)||'|'||
TRIM(CALENDAR_SET)||'|'||
TRIM(BASE_DATE)||'|'||
TRIM(CURVE_TYPE))
from YIELD_CURVE_O_TABLE;
exit;