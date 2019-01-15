-- File Name		: custom_cchot01_spool.sql
-- File Created for	: Spooling file for Lockers details customization.
-- Created By		: Revathi
-- Client		    : EIB
-- Created On		: 29-11-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 292
set page size 0
set pages 0
#set trimspool on
spool $MIG_PATH/output/finacle/custom/CCLKU.txt
select 
SOL_ID      ||
LOCKER_TYPE      ||
LOCKER_NO      ||
KEY_NO      ||
OCCUPIED_FLAG      ||
FREEZE_CODE      ||
FREEZE_REASON      ||
PURPOSE_USED      ||
REMARKS      ||
DELETE_FLAG      ||
PREFERABLE_LANG_CODE      ||
PREFERABLE_LANG_FREEZE_REASON      
from custom_lku001_o_table;
spool off;
exit;
 
