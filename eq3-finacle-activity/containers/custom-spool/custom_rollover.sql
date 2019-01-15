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
spool $MIG_PATH/output/finacle/custom/custom_rollover.txt
select 
ACCOUNT_ID ||                  
ROLLOVER_MONTHS ||               
ROLLOVER_DAYS ||               
ROLLOVER_TYPE ||   
ROLLOVER_PRINCIPAL_AMOUNT ||    
PENDING_INTEREST_DEMANDS ||      
INT_PAY_AFTER_ROLLOVER ||
MAX_NUM_TIMES_ROLLOVER_ALLOWED ||
DEFERRED_INTEREST ||     
TENOR_FOR_INTEREST_RATE ||
SUSPEND_ROLLOVER ||
NUMBER_OF_TIME_ROLLOVER_DONE ||
ONLINE_BATCH_ROLLOVER ||  
ADVANCE_INT_RECOVERY_AC_ID ||
TRAN_EXCHANGE_RATE ||
TRAN_RATE ||          
TRAN_TREASURY_RATE ||            
TREASURY_REF_NO  ||              
ROLLOVER_EVENT 
from rollover_o_Table;
spool off;
 exit;
 
