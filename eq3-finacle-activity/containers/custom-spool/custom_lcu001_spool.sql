-- File Name		: custom_cchot01_spool.sql
-- File Created for	: Spooling file for Lockers details customization.
-- Created By		: Revathi
-- Client		    : EIB
-- Created On		: 29-11-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 1500
set page size 0
set pages 0
#set trimspool on
column filename new_value filename;
select '/output/finacle/locker/custom_lcu001_'||param_value||'_'||to_char(sysdate,'DDMMYYYY_HHMISS') filename from system_config where param_name='COUNTRY_CODE';
spool $MIG_PATH&filename..txt;
--#spool $MIG_PATH/output/finacle/locker/custom_lcu001.txt
select
SOL_ID      ||
CIF_ID      ||
CUSTOMER_NAME      ||
LOCKER_TYPE      ||
LOCKER_NO      ||
JOINT_HOLDERNAME_1      ||
JOINT_HOLDER_CIF_ID_1      ||
JOINT_HOLDER_RELATION_1      ||
JOINT_HOLDER_NAME_2      ||
JOINT_HOLDER_CIF_ID_2      ||
JOINT_HOLDER_RELATION_2      ||
JOINT_HOLDER_NAME_3      ||
JOINT_HOLDER_CIF_ID_3      ||
JOINT_HOLDER_RELATION_3      ||
OPACC      ||
SDACC      ||
CODE_WORD      ||
OPEN_DATE      ||
CLOSED_DATE      ||
FREQUENCY      ||
TOTAL_RENT      ||
REMARKS      ||
LAST_RENT_DATE      ||
DUE_DATE      ||
DUE_NOTICE_DATE      ||
DUE_RENT      ||
DELETE_FLAG      ||
FREE_TEXT_1      ||
FREE_TEXT_2      ||
PAYMENT_MODE      ||
PAYMENT_DATE      ||
RENT_PAID      ||
PREFERABLE_LANGUAGE_CODE      ||
CUSTOMER_NAMEIN_PREF_LANG_CODE      ||
MODE_OF_OPER_CODE
from custom_lcu001_o_table;
spool off;
exit;
 
