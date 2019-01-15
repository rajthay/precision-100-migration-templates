
-- File Name		: custom_acct_closed.sql
-- File Created for	: Spooling file for closed Accounts
-- Created By		: R.Alavudeen Ali Badusha 
-- Client		    : ABK
-- Created On		: 26-12-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/custom/advance_int.txt
select 
distinct 
ACCOUNT_ID||
START_DATE||
END_DATE||
SCH_BAL||
INT_AMOUNT
from custom_advance_int;
exit;
 
