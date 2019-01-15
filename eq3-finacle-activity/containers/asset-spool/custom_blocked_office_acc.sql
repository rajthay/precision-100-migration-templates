
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/custom/custom_blocked_off_acc.txt
select 
distinct 
foracid||
frez_code||
frez_reason_code||
system_only_acct_flg||
anw_non_cust_alwd_flg
from CUSTOM_OFFICE_ACC_BLOCK;
exit;
 
