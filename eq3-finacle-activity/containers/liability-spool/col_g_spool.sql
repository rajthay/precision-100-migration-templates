set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/collateral/COL_GUA.txt
select  
TRIM(COL_TYPE) ||'|'||
TRIM(COL_CODE) ||'|'||
TRIM(COL_CLASS) ||'|'||
TRIM(COL_GROUP) ||'|'||
TRIM(CEILING_LIMIT) ||'|'||
TRIM(MARGIN_PCNT) ||'|'||
TRIM(DR_ACC_FOR_FEES) ||'|'||
TRIM(LTV_PCNT) ||'|'||
TRIM(LAST_VALUATION_DT) ||'|'||
TRIM(GUARANTOR_TYPE) ||'|'||
TRIM(GUARANTOR_ID) ||'|'||
TRIM(GUARANTOR_NAME) ||'|'||--GUARANTOR_NAME
TRIM(GUARANTEE_TYPE) ||'|'||
TRIM(REVIEW_DT) ||'|'||
TRIM(GUARANTEE_PCNT) ||'|'||
TRIM(GUARANTEE_AMT) ||'|'||
TRIM(RECEIVED_DT) ||'|'||
TRIM(COL_VALUE) ||'|'||
TRIM(DUE_DATE) ||'|'||
TRIM(ADDRESS_LINE1) ||'|'||
TRIM(ADDRESS_LINE2) ||'|'||
TRIM(CITY_CODE) ||'|'||
TRIM(STATE_CODE) ||'|'||
TRIM(COUNTRY_CODE) ||'|'||
TRIM(POSTAL_CODE) ||'|'||
TRIM(LODGED_DATE) ||'|'||--LODGED_DATE
TRIM(GUARANTOR_ID) ||'|'||
TRIM(NOTES) ||'|'||
TRIM(LINKAGE_TYPE) ||'|'||
TRIM(COLL_STATUS) ||'|'||--COLL_STATUS
TRIM(FORACID ) ||'|'||--FORACID
TRIM(DP_CONTRBTN) ||'|'||--DP_CONTRBTN
TRIM(LIMIT_PREFIX) ||'|'||
TRIM(LIMIT_SUFFIX) ||'|'||
TRIM(UPLOAD_STATUS) ||'|'||--UPLOAD_STATUS
TRIM(get_param('BANK_ID')) ||'|'||
TRIM(SERIAL_NUMBER) ||'|'||
TRIM(FORACID_COLL_VALUE) ||'|'||--FORACID_COLL_VALUE
TRIM(SERIAL_NUMBER) ||'|'||
TRIM(CC_FINONE_ACCNT )--CC_FINONE_ACCNT
from col_g_o_table;
exit; 
