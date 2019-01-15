set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/collateral/COL_DEP.txt
select 
TRIM(COL_TYPE) ||'|'||
TRIM(COL_CODE) ||'|'||
TRIM(COL_CLASS) ||'|'||
TRIM(COL_GROUP) ||'|'||
TRIM(CEILING_LIMIT) ||'|'||
TRIM(MARGIN) ||'|'||
TRIM(DR_ACC_FOR_FEES) ||'|'||
TRIM(LTV_PCNT) ||'|'||
TRIM(LAST_VALUATION_DT) ||'|'||
TRIM(REASON_CODE) ||'|'||
TRIM(DEPOSIT_ACCOUNT_NUMBER) ||'|'||
TRIM(APPORTIONED_VALUE) ||'|'||
TRIM(REVIEW_DATE) ||'|'||
TRIM(DENOMINATION_NUMBER_1) ||'|'||
TRIM(DENOMINATION_NUMBER_2) ||'|'||
TRIM(FULL_BENEFIT_FLAG) ||'|'||
TRIM(RECEIVED_DATE) ||'|'||
TRIM(CEILING_LIMIT) ||'|'||
TRIM(DUE_DATE) ||'|'||
TRIM(LODGED_DATE) ||'|'||
TRIM(CIF_ID) ||'|'||
TRIM(NOTES) ||'|'||
TRIM(LINKAGE_TYPE) ||'|'||
TRIM(COLL_STATUS ) ||'|'||
TRIM(DEPOSIT_ACCOUNT_NUMBER) ||'|'||
TRIM(DP_CONTRBTN ) ||'|'||
TRIM(LIMIT_PREFIX) ||'|'||
TRIM(LIMIT_SUFFIX) ||'|'||
TRIM(UPLOAD_STATUS ) ||'|'||
TRIM(get_param('BANK_ID')) ||'|'||
TRIM(SERIAL_NUMBER) ||'|'||
TRIM(FORACID_COLL_VALUE ) ||'|'||
TRIM(SERIAL_NUMBER) ||'|'||
TRIM(CC_FINONE_ACCNT) 
from col_dep_o_table ;
exit; 
