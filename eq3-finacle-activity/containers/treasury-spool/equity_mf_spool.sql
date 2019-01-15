-- File Name		: equity_mf_spool.sql
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
spool $MIG_PATH/output/finacle/treasury/EQUITY_MF.TXT
SELECT 
'RESPONSE'||'|'||
'DEAL_IDENTIFIER'||'|'||
'TRADING_BOOK'||'|'||
'EQUITY_MF_DEFN_NAME'||'|'||
'ENTITY_NAME'||'|'||
'DEPT_NAME'||'|'||
'SUBTYPE'||'|'||
'BUY_OR_SELL'||'|'||
'IS_INVESTMENT'||'|'||
'COUNTERPARTY_STRING'||'|'||
'DEAL_DATE'||'|'||
'PAYIN_DATE'||'|'||
'PAYOUT_DATE'||'|'||
'CURRENCY_STRING'||'|'||
'PRICE_STRING'||'|'||
'QTY_TRADED'||'|'||
'EXCHANGE'||'|'||
'CONFIRM_METHOD'||'|'||
'EXCUTION_METHOD'||'|'||
'SI_FLOW_PAY_SSI_ID'||'|'||
'SI_FLOW_PAY_NOSTRO'||'|'||
'SI_FLOW_PAY_SETT_METHOD'||'|'||
'SI_FLOW_PAY_CPTY_AGENT'||'|'||
'SI_FLOW_REC_SSI_ID'||'|'||
'SI_FLOW_REC_NOSTRO'||'|'||
'SI_FLOW_REC_SETT_METHOD'||'|'||
'SI_FLOW_REC_CPTY_AGENT'||'|'||
'COST_OF_CARRY_REF_RATE_CODE'||'|'||
'SI_FLOW_REC.CUSTODIAN_ACCT'||'|'||
'HOLDING_ENTITY_NAME'||'|'||
'AUTO_OR_MANUAL_RESET'||'|'||
'SETTLEMENT'
FROM DUAL
UNION ALL
select
TO_CHAR(
''||'|'||
TRIM(DEAL_IDENTIFIER)||'|'||
TRIM(TRADING_BOOK)||'|'||
TRIM(EQUITY_MF_DEFN_NAME)||'|'||
TRIM(ENTITY_NAME)||'|'||
TRIM(DEPT_NAME)||'|'||
TRIM(SUBTYPE)||'|'||
TRIM(BUY_OR_SELL)||'|'||
TRIM(IS_INVESTMENT)||'|'||
TRIM(COUNTERPARTY_STRING)||'|'||
TRIM(DEAL_DATE)||'|'||
TRIM(PAYIN_DATE)||'|'||
TRIM(PAYOUT_DATE)||'|'||
TRIM(CURRENCY_STRING)||'|'||
TRIM(PRICE_STRING)||'|'||
TRIM(QTY_TRADED)||'|'||
TRIM(EXCHANGE)||'|'||
TRIM(CONFIRM_METHOD)||'|'||
TRIM(EXCUTION_METHOD)||'|'||
TRIM(SI_FLOW_PAY_SSI_ID)||'|'||
TRIM(SI_FLOW_PAY_NOSTRO)||'|'||
TRIM(SI_FLOW_PAY_SETT_METHOD)||'|'||
TRIM(SI_FLOW_PAY_CPTY_AGENT)||'|'||
TRIM(SI_FLOW_REC_SSI_ID)||'|'||
TRIM(SI_FLOW_REC_NOSTRO)||'|'||
TRIM(SI_FLOW_REC_SETT_METHOD)||'|'||
TRIM(SI_FLOW_REC_CPTY_AGENT)||'|'||
TRIM(COST_OF_CARRY_REF_RATE_CODE)||'|'||
TRIM(SI_FLOW_REC_CUSTODIAN_ACCT)||'|'||
TRIM(HOLDING_ENTITY_NAME)||'|'||
TRIM(AUTO_OR_MANUAL_RESET)||'|'||
TRIM(SETTLEMENT)
)
from EQUITY_MF_O_TABLE;
exit; 
