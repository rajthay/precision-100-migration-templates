-- File Name		: bank_details_spool.sql
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
spool $MIG_PATH/output/finacle/ebanking/bank_details.txt
select
TRIM(DB_TS) ||'|'||
TRIM(LANG_ID) ||'|'||
TRIM(BANK_REF_NO) ||'|'||
TRIM(BANK_TYPE) ||'|'||
TRIM(UPDATE_DATE) ||'|'||
TRIM(INSTITUTION_TYPE) ||'|'||
TRIM(INSTITUTION_NAME) ||'|'||
TRIM(SHORT_NAME) ||'|'||
TRIM(ADDRESS) ||'|'||
TRIM(ADDRESS2) ||'|'||
TRIM(ADDRESS3) ||'|'||
TRIM(CITY_ZIPCODE) ||'|'||
TRIM(COUNTRY_CODE) ||'|'||
TRIM(STATE_CODE) ||'|'||
TRIM(ZIP_EXTN) ||'|'||
TRIM(BRANCH_NAME) ||'|'||
TRIM(PH_AREA_CODE) ||'|'||
TRIM(PH_NO) ||'|'||
TRIM(PH_NO_EXTN) ||'|'||
TRIM(FAX_AREA_CODE) ||'|'||
TRIM(FAX_NO) ||'|'||
TRIM(FAX_NO_EXTN) ||'|'||
TRIM(SERVICES) ||'|'||
TRIM(EXTRA_INFO) ||'|'||
TRIM(INSTITUTION_IDENTIFIER) ||'|'||
TRIM(IBAN_SUPPORT_INDICATOR_FLAG) ||'|'||
TRIM(DIRECT_DEBIT_SUPPORT_FLAG) ||'|'||
TRIM(ROUTING_NUMBER_SOURCE) ||'|'||
TRIM(DEL_FLG) ||'|'||
TRIM(FREE_TXT1) ||'|'||
TRIM(FREE_TXT2) ||'|'||
TRIM(FREE_TXT3) ||'|'||
TRIM(FREE_NUM1) ||'|'||
TRIM(FREE_NUM2) ||'|'||
TRIM(FREE_DATE1) ||'|'||
TRIM(FREE_DATE2) ||'|'||
TRIM(R_MOD_ID) ||'|'||
TRIM(R_MOD_TIME) ||'|'||
TRIM(R_CRE_ID) ||'|'||
TRIM(R_CRE_TIME)
from BANK_DETAILS_O_TABLE;
exit;
 
