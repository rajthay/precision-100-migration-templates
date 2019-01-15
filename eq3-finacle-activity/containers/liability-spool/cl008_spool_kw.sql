
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cla/KW/CL008.txt
select
TRAN_TYPE||
TRAN_SUB_TYPE||
FORACID||
TRAN_CRNCY_CODE||
SOL_ID||
TRAN_AMT||
PART_TRAN_TYPE||
TYPE_OF_DMDS||
VALUE_DATE||
FLOW_ID||
DMD_DATE||
LAST_TRAN_FLG||
NA||
ADV_PAY_FLG||
PREPAY_TYPE||
INT_COLL_ON_PREP_FLG||
TRAN_RMKS||
TRAN_PARTICULAR
from Cl008_O_TABLE
order by TRAN_CRNCY_CODE,SOL_ID,TRAN_PARTICULAR,LAST_TRAN_FLG;
exit;
 
