
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cla/KW/CL014.txt
select
ACCOUNT_NUMBER||'|'||
CURRENCY_CODE||'|'||
SOL_ID||'|'||
CR_INT_TRAN_AMT||'|'||
CR_INT_CALC_UPTO||'|'||
CR_INT_ACC_UPTO||'|'||
CR_INT_BOOKED_UPTO||'|'||
DEB_INT_TRANS_AMT||'|'||
DEB_INT_CALC_UPTO||'|'||
DEB_INT_ACCRUED_UPTO||'|'||
DEB_INT_BOOK_UPTO
from Cl014_O_TABLE;
exit;
 
