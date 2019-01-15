-- File Name		: treasury_group_spool.sql
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
spool $MIG_PATH/output/finacle/treasurylimit/TREASURY_NOT_MIG_CPTY_CORE_FROM_CORE.TXT
SELECT 
'Response' ||'|'||
'Template' ||'|'||
'NAME' ||'|'||
'Mnemonic' ||'|'||
'Short Name 1' ||'|'||
'Short Name 2' ||'|'||
'EPG' ||'|'||
'Trade Role' ||'|'||
'CPTY_TYPE' ||'|'||
'CPTY_ROLE_DATA' ||'|'||
'COI' ||'|'||
'COUR' ||'|'||
'CPTY_DATA.CPTY_CATEGORY'||'|'||
'LBS_1' ||'|'||
'CPTY_DATA.CPTY_PARENT_DATA.$0.FETCH_MNEMONIC'||'|'||
'CPTY_DATA.CPTY_PARENT_DATA.$0.RELATIONSHIP'||'|'||
'CPTY_DATA.CPTY_PARENT_DATA.$0.ADD_ACTION'||'|'||
'ADDRESS_1' ||'|'||
'ADDRESS_2' ||'|'||
'ADDRESS_3' ||'|'||
'ADDRESS_4' ||'|'||
'PHONE' ||'|'||
'EMAIL_ID' ||'|'||
'CONFIRMATION_EMAIL_ID' ||'|'||
'FAX' ||'|'||
'CPTY_MEDIUM_DATA.$1.MEDIUM' ||'|'||
'CPTY_MEDIUM_DATA.$1.MEDIUM_ID' ||'|'||
'CONFIRM_METHOD' ||'|'||
'SETTLEMENT_METHOD' ||'|'||
'CPTY_ALIAS_DATA.$1.NAME' ||'|'||
'CPTY_ALIAS_DATA.$1.ALIASGROUP' ||'|'||
'CPTY_ALIAS_DATA.$1.COMMENTS' ||'|'||
'BROKER_EXCH_AMC_LIST_STR' ||'|'||
'INDUSTRY_DATA' ||'|'||
'CPTY_SETTLEMENT_DATA.CCY_CALENDAR_LIST' ||'|'||
'CPTY_SETTLEMENT_DATA.TAX_APPLICABILITY' ||'|'||
'CPTY_SETTLEMENT_DATA.TAX_PERCENTAGE' ||'|'||
'CPTY_SETTLEMENT_DATA.SCRIP_PAYIN_LAG' ||'|'||
'CPTY_SETTLEMENT_DATA.SCRIP_PAYOUT_LAG' ||'|'||
'CPTY_SETTLEMENT_DATA.FUNDS_PAYIN_LAG' ||'|'||
'CPTY_SETTLEMENT_DATA.FUNDS_PAYOUT_LAG' ||'|'||
'CPTY_SETTLEMENT_DATA.TRADING_PERIOD' ||'|'||
'CPTY_SETTLEMENT_DATA.TRADING_PERIOD_START' ||'|'||
'CPTY_SETTLEMENT_DATA.TRADING_PERIOD_END' ||'|'||
'CPTY_SETTLEMENT_DATA.NEXT_SCRIP_PAYIN' ||'|'||
'CPTY_SETTLEMENT_DATA.NEXT_FUNDS_PAYIN' ||'|'||
'CPTY_SETTLEMENT_DATA.NEXT_SCRIP_PAYOUT' ||'|'||
'CPTY_SETTLEMENT_DATA.NEXT_FUNDS_PAYOUT' ||'|'||
'CPTY_SETTLEMENT_DATA.INTRAPERIOD_SQ_OFF' ||'|'||
'LB_ACCT_ID' ||'|'||
'Currency' ||'|'||
'LB_ACCT_BRANCH' ||'|'||
'LB_ACCT_STATUS'
FROM DUAL
UNION ALL
select
TO_CHAR(
TRIM(RESPONSE                            )||'|'||
TRIM(TEMPLATE                            )||'|'||
TRIM(NAME                                )||'|'||
TRIM(MNEMONIC                            )||'|'||
TRIM(SHORT_NAME1                         )||'|'||
TRIM(SHORT_NAME2                         )||'|'||
TRIM(EPG                                 )||'|'||
TRIM(TRADE_ROLE                          )||'|'||
TRIM(CPTY_TYPE                           )||'|'||
TRIM(CPTY_ROLE_DATA                      )||'|'||
TRIM(COI                                 )||'|'||
TRIM(COUR                                )||'|'||
TRIM(CPTY_CATEGORY                       )||'|'||
TRIM(LBS_1                               )||'|'||
TRIM(PARENT_DATA_FETCH_MNEMONIC          )||'|'||
TRIM(PARENT_DATA_RELATIONSHIP            )||'|'||
TRIM(PARENT_DATA_ADD_ACTION              )||'|'||
TRIM(ADDRESS_1                           )||'|'||
TRIM(ADDRESS_2                           )||'|'||
TRIM(ADDRESS_3                           )||'|'||
TRIM(ADDRESS_4                           )||'|'||
TRIM(PHONE                               )||'|'||
TRIM(EMAIL_ID                            )||'|'||
TRIM(CONFIRMATION_EMAIL_ID               )||'|'||
TRIM(FAX                                 )||'|'||
TRIM(CPTY_MEDIUM_DATA_$1_MEDIUM          )||'|'||
TRIM(CPTY_MEDIUM_DATA_$1_MEDIUM_ID       )||'|'||
TRIM(CONFIRM_METHOD                      )||'|'||
TRIM(SETL_METHOD                         )||'|'||
TRIM(CPTY_ALIAS_DATA_$1_NAME             )||'|'||
TRIM(CPTY_ALIAS_DATA_$1_ALIASGROUP       )||'|'||
TRIM(CPTY_ALIAS_DATA_$1_COMMENTS         )||'|'||
TRIM(BROKER_EXCH_AMC_LIST_STR            )||'|'||
TRIM(INDUSTRY_DATA                       )||'|'||
TRIM(CPTY_SETL_DATA_CCY_CAL_LIST         )||'|'||
TRIM(CPTY_SETL_DATA_TAX_APPL             )||'|'||
TRIM(CPTY_SETL_DATA_TAX_PRCNTAGE         )||'|'||
TRIM(CPTY_SETL_DATA_SCRIP_PAYI_LAG       )||'|'||
TRIM(CPTY_SETL_DATA_SCRIP_PAYO_LAG       )||'|'||
TRIM(CPTY_SETL_DATA_FUNDS_PAYIN_LAG      )||'|'||
TRIM(CPTY_SETL_DATA_FUNDS_PAYO_LAG       )||'|'||
TRIM(CPTY_SETL_DATA_TRDNG_PRD            )||'|'||
TRIM(CPTY_SETL_DATA_TRDNG_PRD_STRT       )||'|'||
TRIM(CPTY_SETL_DATA_TRDNG_PRD_END        )||'|'||
TRIM(CPTY_SETL_DATA_NXT_SCRIP_PAYI       )||'|'||
TRIM(CPTY_SETL_DATA_NXT_FUNDS_PAYI       )||'|'||
TRIM(CPTY_SETL_DATA_NXT_SCRIP_PAYO       )||'|'||
TRIM(CPTY_SETL_DATA_NXT_FUNDS_PAYO       )||'|'||
TRIM(CPTY_SETL_DATA_INTRAPRD_SQ_OFF      )||'|'||
TRIM(LB_ACCT_ID                          )||'|'||
TRIM(CURRENCY                            )||'|'||
TRIM(LB_ACCT_BRANCH                      )||'|'||
TRIM(LB_ACCT_STATUS                      )
)
from TR_NOT_MIG_CPTY_CORE_O_TABLE;
exit; 
