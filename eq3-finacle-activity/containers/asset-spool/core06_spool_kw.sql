-- File Name		: spool CA06
-- File Created for	: Creation of Account intrest
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 26-05-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/core/KW/CORE006.txt
select 
ACCOUNT_NUMBER||
CRNCY_CODE||
SOL_ID||
NORMAL_CREDIT_ACCRUED_AMT||
LAST_CR_INT_APPLICATION_DT||
CREDIT_INT_ACCRUED_UPTO_DT||
CREDIT_INT_BOOKED_UPTO_DT||
NORMAL_DEBIT_ACCRUED_AMT||
LAST_DR_INT_APPLICATION_DT||
DEBIT_INT_ACCRUED_UPTO_DATE||
DEBIT_INT_BOOKED_UPTO_DATE||
DUMMY
from AC_INTEREST_O_TABLE;
exit;
 
