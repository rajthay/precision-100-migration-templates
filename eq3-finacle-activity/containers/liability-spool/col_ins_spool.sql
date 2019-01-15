set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/others/COL10.txt
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
TRIM(REVIEW_DATE) ||'|'||
TRIM(RECEIVED_DATE) ||'|'||
TRIM(DUE_DATE) ||'|'||
TRIM(CIF_ID) ||'|'||
TRIM(NOTES) ||'|'||
TRIM(POLICY_AMOUNT) ||'|'||
TRIM(INS_POLICY_NUMBER) ||'|'||
TRIM(RISK_COVER_END_DATE) ||'|'||
TRIM(LAST_PREMIUM_PAID_DATE) ||'|'||
TRIM(LINKAGE_TYPE) ||'|'||
TRIM(ACCOUNT_TO_BE_LINKED) ||'|'||
TRIM(LIMIT_PREFIX) ||'|'||
TRIM(LIMIT_SUFFIX) ||'|'||
TRIM(SERIAL_NUMBER) ||'|'||
TRIM(MODEL) ||'|'||
TRIM(YEAR_OF_MANUFACTURE) ||'|'||
TRIM(NOTES0) ||'|'||
TRIM(ADDRESSLINE_1) ||'|'||
TRIM(ADDRESLINE_2) ||'|'||
TRIM(CITY_CODE) ||'|'||
TRIM(STATE_CODE) ||'|'||
TRIM(ZIP_CODE) ||'|'||
TRIM(TELEPHONE_NUMBER) ||'|'||
TRIM(INSPECTED_EMP_ID) ||'|'||
TRIM(NOTES1) ||'|'||
TRIM(NOTES2) ||'|'||
TRIM(INSURANCE_TYPE) ||'|'||
TRIM(INSURER_DETAILS) ||'|'||
TRIM(INSURANCE_POLICY_NUMBER) ||'|'||
TRIM(INSURANCE_POLICY_AMOUNT) ||'|'||
TRIM(RISK_COVER_START_DATE) ||'|'||
TRIM(PREMIUM_AMOUNT) ||'|'||
TRIM(FREQUENCY_OF_THE_STATEMENT) ||'|'||
TRIM(ITEMS_INSURED) ||'|'||
TRIM(NOTES3) 
from col_ins_o_table;
spool off;
exit; 
