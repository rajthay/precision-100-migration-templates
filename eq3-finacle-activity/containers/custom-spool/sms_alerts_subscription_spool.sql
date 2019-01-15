-- File Name		: sms_alerts_subscription_spool.sql
-- File Created for	: sms_alerts_subscription
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 18-11-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 800
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/ebanking/sms_alerts_subscription.txt
select 
TRIM(DB_TS                    )||'|'||
TRIM(BANK_ID                  )||'|'||
TRIM(ALERT_ID                 )||'|'||
TRIM(CORP_ID                  )||'|'||
TRIM(CUST_ID                  )||'|'||
TRIM(ALRT_ACCT_ID             )||'|'||
TRIM(RELATED_PARTY_ID         )||'|'||
TRIM(HOST_ID                  )||'|'||
TRIM(ENTITY_ID                )||'|'||
TRIM(ALERT_FREQ               )||'|'||
TRIM(DATA_CENTER_CODE         )||'|'||
TRIM(USER_CATEGORY_NAME       )||'|'||
TRIM(CHANNEL1                 )||'|'||
TRIM(CHANNEL2                 )||'|'||
TRIM(CHANNEL3                 )||'|'||
TRIM(CHANNEL4                 )||'|'||
TRIM(CHANNEL5                 )||'|'||
TRIM(CHANNEL6                 )||'|'||
TRIM(CHANNEL7                 )||'|'||
TRIM(CHANNEL8                 )||'|'||
TRIM(CHANNEL9                 )||'|'||
TRIM(CHANNEL10                )||'|'||
TRIM(CHANNEL11                )||'|'||
TRIM(CHANNEL12                )||'|'||
TRIM(AMOUNT1                  )||'|'||
TRIM(AMOUNT2                  )||'|'||
TRIM(AMOUNT3                  )||'|'||
TRIM(AMOUNT4                  )||'|'||
TRIM(AMOUNT5                  )||'|'||
TRIM(STRING1                  )||'|'||
TRIM(STRING2                  )||'|'||
TRIM(STRING3                  )||'|'||
TRIM(STRING4                  )||'|'||
TRIM(STRING5                  )||'|'||
TRIM(DATE1                    )||'|'||
TRIM(DATE2                    )||'|'||
TRIM(DATE3                    )||'|'||
TRIM(DATE4                    )||'|'||
TRIM(DATE5                    )||'|'||
TRIM(NUMBER1                  )||'|'||
TRIM(NUMBER2                  )||'|'||
TRIM(NUMBER3                  )||'|'||
TRIM(NUMBER4                  )||'|'||
TRIM(NUMBER5                  )||'|'||
TRIM(FREE_TEXT_1              )||'|'||
TRIM(FREE_TEXT_2              )||'|'||
TRIM(FREE_TEXT_3              )||'|'||
TRIM(ENTITY_CRE_FLG           )||'|'||
TRIM(DEL_FLG                  )||'|'||
TRIM(R_MOD_USER_ID            )||'|'||
TRIM(R_MOD_TIME               )||'|'||
TRIM(R_CRE_USER_ID            )||'|'||
TRIM(R_CRE_TIME               )||'|'||
TRIM(MKCT_REV_REF             )||'|'||
TRIM(RELATED_PARTY_HOST_ID    )||'|'||
TRIM(SUBSCRIPTION_TYPE        )||'|'||
TRIM(FREQ_ID                  )||'|'||
TRIM(FREQ_TYPE                )||'|'||
TRIM(ALERT_START_DATE         )||'|'||
TRIM(ALERT_END_DATE           )||'|'||
TRIM(NEXT_GEN_DATE            )||'|'||
TRIM(SUBSCRIPTION_NATURE      ) 
from SMS_ALERTS_suB_O_TABLE;
exit;
 
