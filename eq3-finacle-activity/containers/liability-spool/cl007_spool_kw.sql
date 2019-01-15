
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cla/KW/CL007.txt
select
TRANS_TYPE||
TRANS_SUB_TYPE||
ACC_NUM||
CURR||
SOL_ID||
TRANS_AMT||
PART_TRAN_TYPE||
TYPE_OF_DEMANDS||
VALUE_DATE||
FLOW_ID||
DEMAND_DATE||
LAST_PART_TRAN_FLAG||
TRANS_END_IND||
ADV_PAY_FLAG||
PREPAY_TYPE||
INT_COLL_ON_PREPAY_FLAG||
TRANS_REMARKS||
TRANS_PART||';CLAT_'||trim(SOL_ID)||'_'||CURR||'.txt' 
from Cl007_O_TABLE
order by CURR,SOL_ID,TRANS_PART,LAST_PART_TRAN_FLAG;
exit;
 
