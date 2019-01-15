
-- File Name		: custom_acct_closed.sql
-- File Created for	: Spooling file for closed Accounts
-- Created By		: R.Alavudeen Ali Badusha 
-- Client		    : ABK
-- Created On		: 26-12-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/custom/account_closed.txt
select 
distinct 
FIN_ACC_NUM||'|'||
Acct_cls_flg||'|'||
Acct_cls_date 
from custom_acct_closed;
exit;
 
