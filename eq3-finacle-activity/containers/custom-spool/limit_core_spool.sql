-- File Name		: limt_core_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 20-10-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 800
set page size 0
set pages 0
set trimspool on
column filename new_value filename;
select '/output/finacle/limit_core/limit_core_'||param_value||'_'||to_char(sysdate,'DDMMYYYY') filename from system_config where param_name='COUNTRY_CODE';
spool $MIG_PATH&filename..txt;
--spool $MIG_PATH/output/finacle/limit_core/limit_core.txt
select 
to_char(
TRIM(BORROWER_NAME) ||'|'||
TRIM(NODE_LEVEL) ||'|'||
TRIM(LIMIT_PREFIX) ||'|'||
TRIM(LIMIT_SUFFIX) ||'|'||
TRIM(LIMIT_DESC) ||'|'||
TRIM(CRNCY_CODE) ||'|'||
TRIM(PARENT_LIMIT_PREFIX) ||'|'||
TRIM(PARENT_LIMIT_SUFFIX) ||'|'||
TRIM(SANCTION_LIMIT) ||'|'||
TRIM(DRAWING_POWER_IND) ||'|'||
TRIM(LIMIT_APPROVAL_DATE) ||'|'||
TRIM(LIMIT_EXPIRY_DATE) ||'|'||
TRIM(LIMIT_REVIEW_DATE) ||'|'||
TRIM(APPROVAL_AUTH_CODE) ||'|'||
TRIM(APPROVAL_LEVEL) ||'|'||
TRIM(LIMIT_APPROVAL_REF) ||'|'||
TRIM(NOTES) ||'|'||
TRIM(TERMS_AND_CONDITIONS) ||'|'||
TRIM(LIMIT_TYPE) ||'|'||
TRIM(LOAN_TYPE) ||'|'||
TRIM(MASTER_LIMIT_NODE) ||'|'||
TRIM(MIN_COLL_VALUE_BASED_ON) ||'|'||
TRIM(DRWNG_POWER_PCNT) ||'|'||
TRIM(PATTERN_OF_FUNDING) ||'|'||
TRIM(DEBIT_ACCOUNT_FOR_FEES) ||'|'||
TRIM(COMMITTED_LINES) ||'|'||
TRIM(CONTRACT_SIGN_DATE) ||'|'||
TRIM(UPLOAD_STATUS) ||'|'||
TRIM(COND_PRECEDENT_FLG) ||'|'||
TRIM(GLOBAL_LIMIT_FLG) ||'|'||
TRIM(MAIN_PRODUCT_TYPE) ||'|'||
TRIM(PROJECT_NAME) ||'|'||
TRIM(PRODUCT_NAME) ||'|'||
TRIM(PURPOSE_OF_LIMIT) ||'|'||
TRIM(BANK_ID)
)
from LIMIT_CORE_O_TABLE ;
exit; 
