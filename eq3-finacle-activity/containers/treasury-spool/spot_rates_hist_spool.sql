-- File Name		: spot_rates_spool.sql
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
spool $MIG_PATH/output/finacle/treasury/SPOT_RATES_HISTORY.TXT
SELECT
'Response'||'|'||
'Currency Pair'||'|'||
'Currency One'||'|'||
'Currency Two'||'|'||
'Bid'||'|'||
'Offer'||'|'||
'Base Date'
FROM DUAL
UNION ALL
select
TO_CHAR(TRIM(RESPONSE)||'|'||
TRIM(CURRENCY_PAIR)||'|'||
TRIM(CURRENCY_ONE)||'|'||
TRIM(CURRENCY_TWO)||'|'||
TO_CHAR(TRIM(BID),'fm99999999999990.00000000')||'|'||
TO_CHAR(TRIM(OFFER),'fm99999999999990.00000000')||'|'||
TRIM(BASE_DATE))
from SPOT_RATES_HIST_O_TABLE;
exit; 
