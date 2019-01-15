set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/laa/KW/RL005.txt
select TRANSACTION_TYPE||TRANSACTION_SUB_TYPE||ACCOUNT_NUMBER||CURRENCY||SERVICE_OUTLET||AMOUNT||PART_TRAN_TYPE||TYPE_OF_DEMANDS||VALUE_DATE||FLOW_ID||DEMAND_DATE||LAST_PART_TRANSACTION_FLAG||TRAN_END_IND||ADVANCE_PAYMENT_FLAG||PREPAYMENT_TYPE||INT_COLL_ON_PREPAYMENT_FLG
||TRANSACTION_REMARKS||TRANSACTION_PARTICULARS||';LAT1_'||trim(SERVICE_OUTLET)||'_'||CURRENCY||'.txt' 
from lat1_o_table  order by currency,service_outlet,TRANSACTION_PARTICULARS,last_part_transaction_flag ;
exit;
 
