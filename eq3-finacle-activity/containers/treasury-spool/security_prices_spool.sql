-- File Name		: security_prices_spool.sql
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
spool $MIG_PATH/output/finacle/treasury/SECURITY_PRICES.TXT
SELECT
'RESPONSE'||'|'||
'Security'||'|'||
'Bid'||'|'||
'Offer'||'|'||
'Base Date'
FROM DUAL
UNION ALL
select
TO_CHAR(TRIM(RESPONSE)||'|'||
TRIM(SECURITY)||'|'||
TO_CHAR(TRIM(BID),'9999999999999999999.99999999')||'|'||
TO_CHAR(TRIM(OFFER),'9999999999999999999.99999999')||'|'||
TRIM(BASE_DATE))
from SECURITY_PRICES_O_TABLE;
exit; 
