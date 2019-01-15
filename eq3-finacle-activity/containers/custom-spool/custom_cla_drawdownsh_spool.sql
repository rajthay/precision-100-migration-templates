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
spool $MIG_PATH/output/finacle/cla/KW/custom_cla_drawdown_sch.txt
select 
ACCOUNT_NUMBER||
START_DATE||                
END_DATE||                  
SCHEDULED_DRAW_DOWN_AMOUNT||
DRAW_DOWN_CURRENCY||        
CREDIT_ACCOUNT_NUM||        
ECS_MANDATE_SERIAL||        
MODE_OF_DRAW_DOWN||         
ACTUAL_DRAW_DOWN_AMOUNT||
REMARKS||                   
PAYSYS_ID  
from draw_down_o_table;
spool off;
exit; 
