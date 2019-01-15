
-- File Name		: user_account_access_spool.sql
-- File Created for	: user account access
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 18-06-2017
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 3000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/ebanking/corp_e_banking_user1.txt
select
TRIM(REC_NUM) ||'|'||
TRIM(CUST_ID) ||'|'||
TRIM(USER_TYPE) ||'|'||
TRIM(CORP_USER) ||'|'||
TRIM(SALUTATION) ||'|'||
TRIM(C_L_NAME) ||'|'||
TRIM(C_M_NAME) ||'|'||
TRIM(C_F_NAME) ||'|'||
TRIM(C_EMAIL_ID) ||'|'||
TRIM(C_ADDR1) ||'|'||
TRIM(C_ADDR2) ||'|'||
TRIM(C_ADDR3) ||'|'||
TRIM(C_CITY) ||'|'||
TRIM(C_STATE) ||'|'||
TRIM(C_CNTRY) ||'|'||
TRIM(C_ZIP) ||'|'||
TRIM(C_PHONE_NO) ||'|'||
TRIM(C_M_PHONE_NO) ||'|'||
TRIM(C_FAX_NO) ||'|'||
TRIM(PRIM_ACID) ||'|'||
TRIM(P_BRANCH_ID) ||'|'||
TRIM(C_GENDER) ||'|'||
TRIM(to_char(DATE_OF_BIRTH,'DD-Mon-YYYY')) ||'|'||
TRIM(MARITAL_STATUS) ||'|'||
TRIM(to_char(ANNIVERSARY_DATE,'DD-Mon-YYYY')) ||'|'||
TRIM(OCCUPATION) ||'|'||
TRIM(PASSPORT_NUMBER) ||'|'||
TRIM(PASSPORT_ISSUE_DATE) ||'|'||
TRIM(PASSPORT_DETAILS) ||'|'||
TRIM(PASSPORT_EXPIRY_DATE) ||'|'||
TRIM(PAN_NATIONAL_ID) ||'|'||
TRIM(PRINCIPAL_ID) ||'|'||
TRIM(BAY_USER_ID) ||'|'||
TRIM(LANG_ID) ||'|'||
TRIM(SMS_ENABLED) ||'|'||
TRIM(SMS_MOBILE_NO) ||'|'||
TRIM(IS_MASTER_CIF)||'|'||
trim(SERVICE_PROVIDER)
from CORP_E_BANKING_USER_O_TABLE
ORDER BY REC_NUM;
  exit;
 
