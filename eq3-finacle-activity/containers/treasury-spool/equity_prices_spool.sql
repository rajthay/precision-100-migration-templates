-- File Name		: equity_prices_spool.sql
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
spool $MIG_PATH/output/finacle/treasury/EQUITY_PRICES.TXT
SELECT 
'RESPONSE'||'|'||
'Equity/MF Name'||'|'||
'Exchange/AMC'||'|'||
'Price'||'|'||
'BASE_DATE'
FROM DUAL
UNION ALL
select
TO_CHAR(TRIM(RESPONSE)||'|'||
TRIM(SECURITY)||'|'||
TRIM(EXCHANGE_AMC)||'|'||
TRIM(TO_CHAR(TRIM(PRICE),'99999999999999999990.99999999'))||'|'||
TRIM(BASE_DATE))
from EQUITY_PRICES_O_TABLE;
exit; 
