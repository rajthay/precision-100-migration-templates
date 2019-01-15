set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/laa/KW/RL004.txt
select TRANSACTION_TYPE||TRANSACTION_SUB_TYPE||ACCOUNT_NUMBER||CURRENCY||SERVICE_OUTLET||AMOUNT||PART_TRAN_TYPE||TYPE_OF_DEMANDS||VALUE_DATE||FLOW_ID||DEMAND_DATE||LAST_PART_TRANSACTION_FLAG||TRAN_END_IND||ADVANCE_PAYMENT_FLAG||PREPAYMENT_TYPE||INT_COLL_ON_PREPAYMENT_FLG
||TRANSACTION_REMARKS||TRANSACTION_PARTICULARS||';RL004_'||CURRENCY||'_'||trim(SERVICE_OUTLET)||'.txt' 
from lat_o_table 
--left join (select * from tbaadm.gam where bank_id='01')gam on gam.foracid=trim(TRANSACTION_PARTICULARS) 
 --where gam.CLR_BAL_AMT=0
order by currency,service_outlet,TRANSACTION_PARTICULARS,part_tran_type desc
--from lat_o_table  order by service_outlet,TRANSACTION_PARTICULARS,last_part_transaction_flag ;
exit;
 
