-- File Name		: custom_cchot01_spool.sql
-- File Created for	: Spooling file for Lockers details customization.
-- Created By		: Revathi
-- Client		    : EIB
-- Created On		: 29-11-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/custom/CCLNU.txt
trim(CIF_ID)      ||'|'||
trim(SOL_ID)      ||'|'||
trim(LOCKER_TYPE)      ||'|'||
trim(LOCKER_NO)      ||'|'||
trim(NOMINEE_NAME)      ||'|'||
trim(NOMINEE_CUSTOMER_ID)      ||'|'||
trim(REGISTRATION_NO)      ||'|'||
trim(RELATION)      ||'|'||
trim(ADDRESS_LINE_1)      ||'|'||
trim(ADDRESS_LINE_2)      ||'|'||
trim(ADDRESS_LINE_3)      ||'|'||
trim(CITY_CODE)      ||'|'||
trim(STATE_CODE)      ||'|'||
trim(COUNTRY_CODE)      ||'|'||
trim(PIN_CODE)      ||'|'||
trim(DATE_OF_BIRTH)      ||'|'||
trim(MINOR_FLAG)      ||'|'||
trim(CODE_WORD)      ||'|'||
trim(REMARKS)      ||'|'||
trim(DELETE_FLAG)      ||'|'||
trim(FREE_TEXT_1)      ||'|'||
trim(FREE_TEXT_2)      ||'|'||
trim(PREFERABLE_LANGUAGE_CODE)      ||'|'||
trim(ALTERNATE_NOMINEE_NAME)      ||'|'||
trim(GUARDIAN_NAME)      ||'|'||
trim(GUARDIAN_CODE)      ||'|'||
trim(GUARDIAN_ADDRESS1)      ||'|'||
trim(GUARDIAN_ADDRESS2)      ||'|'||
trim(GUARDIAN_CITY_CODE)      ||'|'||
trim(GUARDIAN_STATE_CODE)      ||'|'||
trim(GUARDIAN_COUNTRY_CODE)      ||'|'||
trim(GUARDIAN_PIN_CODE)      
from custom_lnu001_o_table;
spool off;
exit; 
