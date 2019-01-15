-- File Name		: payee_master_spool.sql
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
spool $MIG_PATH/output/finacle/ebanking/payee_master.txt
select
TRIM(BANK_ID) ||'~'||
TRIM(BNF_ID) ||'~'||
TRIM(DB_TS) ||'~'||
TRIM(LANG_ID) ||'~'||
TRIM(DISPLAY_ID) ||'~'||
TRIM(CORP_ID) ||'~'||
TRIM(BNF_CODE) ||'~'||
TRIM(BNF_NAME) ||'~'||
TRIM(BNF_ADDRESS_1) ||'~'||
TRIM(BNF_ADDRESS_2) ||'~'||
TRIM(BNF_ADDRESS_3) ||'~'||
TRIM(BNF_STATE) ||'~'||
TRIM(BNF_CNTRY) ||'~'||
TRIM(BNF_TEL) ||'~'||
TRIM(BNF_MOB) ||'~'||
TRIM(BNF_FAX) ||'~'||
TRIM(BNF_TYPE) ||'~'||
TRIM(OTH_BANK_REF_NO) ||'~'||
TRIM(BNF_BANK_NAME) ||'~'||
TRIM(BNF_BANK_ADDRESS) ||'~'||
TRIM(HOME_BANK_BRANCH_CODE) ||'~'||
TRIM(BNF_BANK_COUNTRY) ||'~'||
TRIM(ACCOUNT_ID) ||'~'||
TRIM(BNF_ACCT_CRN) ||'~'||
TRIM(BNF_COMM_IND) ||'~'||
TRIM(PAYEE_FORMAT) ||'~'||
TRIM(PYMT_FORMAT) ||'~'||
TRIM(TO_CHAR(EXPIRY_DATE,'DD-Mon-YYYY')) ||'~'||
TRIM(BNF_IND) ||'~'||
TRIM(FREE_FIELD_1) ||'~'||
TRIM(FREE_FIELD_2) ||'~'||
TRIM(FREE_FIELD_3) ||'~'||
TRIM(FREE_FIELD_4) ||'~'||
TRIM(FREE_FLG_1) ||'~'||
TRIM(FREE_FLG_2) ||'~'||
TRIM(FREE_FLG_3) ||'~'||
TRIM(FREE_FLG_4) ||'~'||
TRIM(FREE_IND_1) ||'~'||
TRIM(FREE_IND_2) ||'~'||
TRIM(BILL_EXPIRY_PRD) ||'~'||
TRIM(MIN_PMT_AMT) ||'~'||
TRIM(LATE_PYMT_FLG) ||'~'||
TRIM(PART_PYMT_FLG) ||'~'||
TRIM(EXS_PYMT_FLG) ||'~'||
TRIM(REAL_TIME_CREDIT_FLG) ||'~'||
TRIM(CHRG_PMT_FLG) ||'~'||
TRIM(PRENOTE_REQUIRED) ||'~'||
TRIM(DEL_FLG) ||'~'||
TRIM(GLOBAL_FLG) ||'~'||
TRIM(R_MOD_ID) ||'~'||
TRIM(TO_CHAR(R_MOD_TIME,'DD-Mon-YYYY')) ||'~'||
TRIM(R_CRE_ID) ||'~'||
TRIM(TO_CHAR(R_CRE_TIME,'DD-Mon-YYYY')) ||'~'||
TRIM(BNF_ACCT_TYPE) ||'~'||
TRIM(BNF_CITY_ZIP) ||'~'||
TRIM(BNF_BANK_CITY_ZIP) ||'~'||
TRIM(BNF_GROUP_ID) ||'~'||
TRIM(BNF_EMAIL) ||'~'||
TRIM(STD_IND_CD) ||'~'||
TRIM(DIVISION) ||'~'||
TRIM(ADDED_BANK_BRANCH_NAME) ||'~'||
TRIM(BANK_TYPE) ||'~'||
TRIM(BNF_CITY_CODE) ||'~'||
TRIM(BNF_ZIP_CODE) ||'~'||
TRIM(NETWORK_ID) ||'~'||
TRIM(BANK_IDENTIFIER) ||'~'||
TRIM(PTP_TYPE) ||'~'||
TRIM(PTP_ID) ||'~'||
TRIM(DELIVERY_MODES_SUPPORTED) ||'~'||
TRIM(FILE_SEQ_NUM) ||'~'||
TRIM(FU_REC_NUM) ||'~'||
TRIM(EXTERNAL_BILLER_ID) ||'~'||
TRIM(SERVICE_TYPE) ||'~'||
TRIM(AGGREGATOR_ID)
from PAYEE_MASTER_O_TABLE ;
exit;
 
