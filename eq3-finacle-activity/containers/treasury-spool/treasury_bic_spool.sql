-- File Name		: treasury_bic_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 10-05-2017
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/treasurylimit/TREASURY_BIC.TXT
SELECT 
'RESPONSE' ||'|'||
'FBO_TYPE' ||'|'||
'BIC_CODE' ||'|'||
'DESCRIPTION'
FROM DUAL
UNION ALL
select
TO_CHAR(
TRIM(RESPONSE                         )||'|'||
TRIM(FBO_TYPE                         )||'|'||
TRIM(BIC_CODE                       )||'|'||
TRIM(DESCRIPTION                  )
)
from TREASURY_BIC_O_TABLE;
exit; 
