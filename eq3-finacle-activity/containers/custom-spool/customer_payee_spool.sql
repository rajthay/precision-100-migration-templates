-- File Name		: customer_payee_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 28-09-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 800
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/ebanking/customer_payee.txt
select
TRIM(PAYEE_LIST_ID) ||'|'||
TRIM(BANK_ID) ||'|'||
TRIM(USER_ID) ||'|'||
TRIM(DB_TS) ||'|'||
TRIM(CORP_ID) ||'|'||
TRIM(BNF_ID) ||'|'||
TRIM(BNF_NIC_NAME) ||'|'||
TRIM(FREE_FIELD_1) ||'|'||
TRIM(FREE_FIELD_2) ||'|'||
TRIM(FREE_FIELD_3) ||'|'||
TRIM(FREE_FLG1) ||'|'||
TRIM(FREE_FLG2) ||'|'||
TRIM(DEL_FLG) ||'|'||
TRIM(R_MOD_ID) ||'|'||
TRIM(TO_CHAR(R_MOD_TIME,'DD-Mon-YYYY')) ||'|'||
TRIM(R_CRE_ID) ||'|'||
TRIM(TO_CHAR(R_CRE_TIME,'DD-Mon-YYYY')) ||'|'||
TRIM(CONSUMER_CD) ||'|'||
TRIM(RECEIVE_BILLS_FLG) ||'|'||
TRIM(AUTOPAY_FLG) ||'|'||
TRIM(AUTOPAY_AMT) ||'|'||
TRIM(AUTOPAY_CRN) ||'|'||
TRIM(AUTOPAY_ACID) ||'|'||
TRIM(AUTOPAY_BRCH_ID) ||'|'||
TRIM(AUTOPAY_MODE) ||'|'||
TRIM(SUBSCRIPTION_START_DATE) ||'|'||
TRIM(ADHOC_PAYEE) ||'|'||
TRIM(NICKNAME_CRE_ID) ||'|'||
TRIM(BNF_PYMT_DETAILS_1) ||'|'||
TRIM(BNF_PYMT_DETAILS_2) ||'|'||
TRIM(BNF_PYMT_DETAILS_3) ||'|'||
TRIM(BNF_PYMT_DETAILS_4) ||'|'||
TRIM(NOTIFICATION_REF_NO) ||'|'||
TRIM(MAX_AMT_IN_HOMECRN) ||'|'||
TRIM(REG_ACTIVE_FLG) ||'|'||
TRIM(CUSTOMER_ID) ||'|'||
TRIM(FILE_SEQN_NUM) ||'|'||
TRIM(FU_REC_NUM)
from CUSTOMER_PAYEE_O_TABLE;
exit;
 
