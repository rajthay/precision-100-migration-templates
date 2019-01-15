-- File Name		: sms_alerts_registration_spool.sql
-- File Created for	: sms_alerts_registration
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 17-11-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 800
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/ebanking/sms_alerts_registration.txt
select 
TRIM(REC_IDENTIFIER                 )||'|'||          
TRIM(SUB_DEL_IDENTIFIER             )||'|'||
TRIM(BANK_ID                        )||'|'||
TRIM(CUST_ID                        )||'|'||
TRIM(CORP_ID                        )||'|'||
TRIM(RELATED_PARTY_ID               )||'|'||
TRIM(HOST_ID                        )||'|'||
TRIM(CUST_FIRST_NAME                )||'|'||
TRIM(CUST_MID_NAME                  )||'|'||
TRIM(CUST_LAST_NAME                 )||'|'||
TRIM(USER_TYPE                      )||'|'||
TRIM(USER_SUB_TYPE                  )||'|'||
TRIM(LANG_CODE                      )||'|'||
TRIM(ALT_LANG_CODE                  )||'|'||
TRIM(PREF_TIME_ZONE                 )||'|'||
TRIM(DND_DATE_FROM                  )||'|'||
TRIM(DND_DATE_TO                    )||'|'||
TRIM(DND_TIME_FROM                  )||'|'||
TRIM(DND_TIME_TO                    )||'|'||
TRIM(BUSINESS_UNIT_ID               )||'|'||
TRIM(C_ADDR1                        )||'|'||
TRIM(C_ADDR2                        )||'|'||
TRIM(C_CITY                         )||'|'||
TRIM(C_STATE                        )||'|'||
TRIM(C_COUNTRY                      )||'|'||
TRIM(C_ZIP                          )||'|'||
TRIM(C_PHONE_NO                     )||'|'||
TRIM(C_MOBILE_NO                    )||'|'||
TRIM(C_FAX_NO                       )||'|'||
TRIM(C_EMAIL_ID                     )||'|'||
TRIM(CHANNEL_ADDR5                  )||'|'||
TRIM(CHANNEL_ADDR6                  )||'|'||
TRIM(CHANNEL_ADDR7                  )||'|'||
TRIM(CHANNEL_ADDR8                  )||'|'||
TRIM(CHANNEL_ADDR9                  )||'|'||
TRIM(CHANNEL_ADDR10                 )||'|'||
TRIM(DEBIT_ACCOUNT_ID               )||'|'||
TRIM(DEBIT_BRANCH_ID                )||'|'||
TRIM(DATE_FORMAT                    )||'|'||
TRIM(AMOUNT_FORMAT                  )||'|'||
TRIM(USER_CATEGORY_NAME             )||'|'||
TRIM(SCHEME_SUBSCRIPTION_START_DATE )||'|'||
TRIM(SCHEME_SUBSCRIPTION_END_DATE   )||'|'||
TRIM(SERVICE_PROVIDER  )             
from SMS_ALERTS_REG_O_TABLE;
exit; 
