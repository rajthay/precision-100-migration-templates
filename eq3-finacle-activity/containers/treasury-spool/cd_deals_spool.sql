-- File Name		: cd_deals_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 24-01-2017
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/treasury/cd_deals.txt
SELECT
'Response'||'|'||
'DEAL_DATE'||'|'||
'SETTLEMENT_DATE'||'|'||
'COUNTERPARTY_STRING'||'|'||
'TRADING_BOOK'||'|'||
'DEPT_NAME'||'|'||
'SUBTYPE'||'|'||
'BUY_OR_SELL'||'|'||
'MARKET'||'|'||
'SEC_DEFN_NAME'||'|'||
'PRICE_STRING'||'|'||
'YIELD'||'|'||
'QTY_TRADED'||'|'||
'IS_INVESTMENT'||'|'||
'CONFIRM_METHOD'||'|'||
'SI_FLOW_PAY.SSI_ID'||'|'||
'SI_FLOW_PAY.NOSTRO'||'|'||
'SI_FLOW_PAY.SETT_METHOD'||'|'||
'SI_FLOW_PAY.CPTY_AGENT'||'|'||
'SI_FLOW_REC.SSI_ID'||'|'||
'SI_FLOW_REC.NOSTRO'||'|'||
'SI_FLOW_REC.SETT_METHOD'||'|'||
'SI_FLOW_REC.CPTY_AGENT'||'|'||
'BANK_CUSTODIAN_ACCT'||'|'||
'COST_OF_CARRY_REF_RATE_CODE'
FROM DUAL
UNION ALL
select
TO_CHAR(
TRIM(RESPONSE                       )||'|'||    
TRIM( DEAL_DATE                     )||'|'||
TRIM( SETTLEMENT_DATE               )||'|'||
TRIM( COUNTERPARTY_STRING           )||'|'||
TRIM( TRADING_BOOK                  )||'|'||
TRIM( DEPT_NAME                     )||'|'||
TRIM( SUBTYPE                       )||'|'||
TRIM( BUY_OR_SELL                   )||'|'||
TRIM( MARKET                        )||'|'||
TRIM( SEC_DEFN_NAME                 )||'|'||
TRIM( PRICE_STRING                  )||'|'||
TRIM( YIELD                         )||'|'||
TRIM( QTY_TRADED                    )||'|'||
TRIM( IS_INVESTMENT                 )||'|'||
TRIM( CONFIRM_METHOD                )||'|'||
TRIM( SI_FLOW_PAY_SSI_ID            )||'|'||
TRIM( SI_FLOW_PAY_NOSTRO            )||'|'||
TRIM( SI_FLOW_PAY_SETT_METHOD       )||'|'||
TRIM( SI_FLOW_PAY_CPTY_AGENT        )||'|'||
TRIM( SI_FLOW_REC_SSI_ID            )||'|'||
TRIM( SI_FLOW_REC_NOSTRO            )||'|'||
TRIM( SI_FLOW_REC_SETT_METHOD       )||'|'||
TRIM( SI_FLOW_REC_CPTY_AGENT        )||'|'||
TRIM( BANK_CUSTODIAN_ACCT           )||'|'||
TRIM( COST_OF_CARRY_REF_RATE_CODE   )
)
from TR_CD_DEALS_O_TABLE;
exit; 
