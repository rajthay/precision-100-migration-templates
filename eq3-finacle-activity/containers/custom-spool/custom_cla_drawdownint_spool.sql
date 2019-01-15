-- File Name		: custom_pool_spool_kw.sql
-- File Created for	: Spooling file for sweeps pool upload
-- Created By		: R.Alavudeen Ali Badusha
-- Client		    : ABK
-- Created On		: 27-12-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 292
set page size 0
set pages 0
#set trimspool on
spool $MIG_PATH/output/finacle/cla/KW/custom_cla_drawdown_int.txt
select 
ACCOUNT_NUMBER||
DRAW_DOWN_DATE ||  
DRAW_DOWN_AMOUNT || 
EFFECTIVE_INT_RATE||
EVENT_FLAG        
from draw_down_int_o_table;
spool off;
 exit;
 
