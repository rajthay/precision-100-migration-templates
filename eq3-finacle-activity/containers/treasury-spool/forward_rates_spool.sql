-- File Name		: forward_rates_spool.sql
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
spool $MIG_PATH/output/finacle/treasury/FORWARD_RATES.TXT
SELECT
'Response'||'|'||
'Currency Pair'||'|'||
'Currency One'||'|'||
'Currency Two'||'|'||
'Nominal'||'|'||
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
TRIM(NOMINAL)||'|'||
TO_CHAR(TRIM(BID),'fm99999999999990.00000000')||'|'||
TO_CHAR(TRIM(OFFER),'fm99999999999990.00000000')||'|'||
TRIM(BASE_DATE))
from FORWARD_RATES_O_TABLE;
exit; 
