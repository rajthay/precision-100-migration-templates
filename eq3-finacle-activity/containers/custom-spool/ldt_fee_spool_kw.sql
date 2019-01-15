
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/laa/KW/RL007.txt
select
ACCOUNT_ID||DEMAND_DATE||DEMAND_EFFECTIVE_DATE||PRINCIPAL_DEMAND_ID||DEMAND_AMOUNT||LATE_FEE_APPLIED||LATE_FEE_AMOUNT||LATE_FEE_DATE||STATUS_OF_LATE_FEE||LATE_FEE_CURRENCY_CODE||DEMAND_OVERDUE_DATE||ACCRUED_PENAL_INT_AMT
from ldt_fee_o_table;
exit; 
