-- File Name		: custom_cchot01_spool.sql
-- File Created for	: Spooling file for Lockers details customization.
-- Created By		: Revathi
-- Client		    : EIB
-- Created On		: 15-12-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/custom/custlockers.txt
select
trim(SOL_ID) ||'|'||
trim(LOCKER_TYPE) ||'|'||
trim(LOCKER_NO) ||'|'||
trim(CIF_ID) ||'|'||
trim(JOINT_HOLDER_CIF_4) ||'|'||
trim(JOINT_HOLDER_CIF_5) ||'|'||
trim(JOINT_HOLDER_CIF_6) ||'|'||
trim(JOINT_HOLDER_CIF_7) ||'|'||
trim(JOINT_HOLDER_CIF_8) ||'|'||
trim(JOINT_HOLDER_CIF_9) ||'|'||
trim(JOINT_HOLDER_CIF_10) ||'|'||
trim(JOINT_HOLDER_CIF_11) ||'|'||
trim(JOINT_HOLDER_CIF_12) ||'|'||
trim(JOINT_HOLDER_CIF_13) ||'|'||
trim(JOINT_HOLDER_CIF_14) ||'|'||
trim(JOINT_HOLDER_CIF_15) ||'|'||
trim(JOINT_HOLDER_CIF_16) ||'|'||
trim(JOINT_HOLDER_CIF_17) ||'|'||
trim(JOINT_HOLDER_CIF_18) ||'|'||
trim(JOINT_HOLDER_CIF_19) ||'|'||
trim(JOINT_HOLDER_CIF_20) ||'|'||
trim(ENTITY_CRE_FLG) ||'|'||
trim(DEL_FLG) ||'|'||
trim(BANK_ID) 
from custom_lockers_o_table;
spool off;
exit;
 
