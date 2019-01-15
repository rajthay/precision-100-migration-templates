-- File Name		: spot_position_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 11-01-2017
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/treasury/SPOT_POSITION_DEALS.TXT
SELECT
'Response'||'|'||
'PRODUCT_TYPE'||'|'||
'DEAL_DATE'||'|'||
'TRADING_BOOK'||'|'||
'MAIN_LEG.SPOT_TRD_BOOK'||'|'||
'MAIN_LEG.FWD_TRD_BOOK'||'|'||
'SUBTYPE'||'|'||
'DEPT_NAME'||'|'||
'ENTITY_NAME'||'|'||
'MAIN_LEG.SPOT_RISK_ENTITY'||'|'||
'MAIN_LEG.FWD_RISK_ENTITY'||'|'||
'MAIN_LEG.VALUE_DATE_ONE'||'|'||
'ACCOUNTING_CODE'||'|'||
'MAIN_LEG.CPTY'||'|'||
'MAIN_LEG.CCY_PAIR'||'|'||
'MAIN_LEG.FX_BUY_SELL'||'|'||
'MAIN_LEG.CCY_ONE_AMOUNT'||'|'||
'MARKET_SPOT_RATE'||'|'||
'MAIN_LEG.MARKET_SPOT_RATE'||'|'||
'MAIN_LEG.MARKET_FWD_RATE'||'|'||
'MAIN_LEG.CUSTOMER_SPOT_RATE'||'|'||
'MAIN_LEG.CUSTOMER_FWD_RATE'||'|'||
'MAIN_LEG.MARKET_FWD_POINTS'||'|'||
'MAIN_LEG.CUSTOMER_FWD_POINTS'||'|'||
'MEMO_FIELD_1'
FROM DUAL
UNION ALL
select
TO_CHAR(
trim(RESPONSE                    )||'|'||
trim(PRODUCT_TYPE                )||'|'||
trim(DEAL_DATE                   )||'|'||
trim(TRADING_BOOK                )||'|'||
trim(MAIN_LEG_SPOT_TRD_BOOK      )||'|'||
trim(MAIN_LEG_FWD_TRD_BOOK       )||'|'||
trim(SUBTYPE                     )||'|'||
trim(DEPT_NAME                   )||'|'||
trim(ENTITY_NAME                 )||'|'||
trim(MAIN_LEG_SPOT_RISK_ENTITY   )||'|'||
trim(MAIN_LEG_FWD_RISK_ENTITY    )||'|'||
trim(MAIN_LEG_VALUE_DATE_ONE     )||'|'||
trim(ACCOUNTING_CODE             )||'|'||
trim(MAIN_LEG_CPTY               )||'|'||
trim(MAIN_LEG_CCY_PAIR           )||'|'||
trim(MAIN_LEG_FX_BUY_SELL        )||'|'||
trim(MAIN_LEG_CCY_ONE_AMOUNT     )||'|'||
trim(MARKET_SPOT_RATE            )||'|'||
trim(MAIN_LEG_MARKET_SPOT_RATE   )||'|'||
trim(MAIN_LEG_MARKET_FWD_RATE    )||'|'||
trim(MAIN_LEG_CUSTOMER_SPOT_RATE )||'|'||
trim(MAIN_LEG_CUSTOMER_FWD_RATE  )||'|'||
trim(MAIN_LEG_MARKET_FWD_POINTS  )||'|'||
trim(MAIN_LEG_CUSTOMER_FWD_POINTS)||'|'||
trim(MEMO_FIELD_1                )
)
from SPOT_POSITION_DEALS_O_TABLE;
exit; 
