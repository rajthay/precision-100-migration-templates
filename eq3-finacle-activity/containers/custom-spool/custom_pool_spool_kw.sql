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
spool $MIG_PATH/output/finacle/custom/custom_pool.txt
select 
Pool_Number||            
Account_Number||
Pool_Desc||              
Suspend_Flag||           
Suspend_Date||           
Order_of_Utilization||   
Alternate_Pool_Desc||    
Pool_Type||              
Auto_Regularize         
from custom_pool_o_table order by to_number(pool_number),ORDER_OF_UTILIZATION;
spool off;
 exit;
 
