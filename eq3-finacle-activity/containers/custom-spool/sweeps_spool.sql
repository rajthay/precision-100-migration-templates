-- File Name		: spool CA1
-- File Created for	: Creation of source table
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 26-05-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 1033
set page size 0
set pages 0
set trimspool off
spool $MIG_PATH/output/finacle/core/KW/SWEEPS.txt
select 
POOL_NUMBER||
ACCOUNT_NUMBER||      
POOL_DESC||           
SUSPEND_FLAG||        
SUSPEND_DATE||        
ORDER_OF_UTILIZATION||
ALTERNATE_POOL_DESC|| 
POOL_TYPE||           
AUTO_REGULARIZE     
from custom_pool_o_table;
--from custom_pool_o_table; --where trim(pool_desc) not in (select distinct POOL_DESC from tbaadm.pft);
exit;
 
