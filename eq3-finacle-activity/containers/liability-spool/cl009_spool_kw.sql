
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cla/KW/CL009.txt
select
ACC_ID||
DEMAND_DATE||
DEMAND_EFF_DATE||
DEMAND_ID||
DEMAND_AMT||
LATE_FEE_APP||
LATE_FEE_AMT||
LATE_FEE_DATE||
STATUS_OF_LATE_FEE||
LATE_FEE_CURR_CODE||
DEMAND_OVERDUE_DATE||
ACC_PENAL_INT_AMT||
IBAN_NUMBER
from Cl009_O_TABLE;
exit;
 
