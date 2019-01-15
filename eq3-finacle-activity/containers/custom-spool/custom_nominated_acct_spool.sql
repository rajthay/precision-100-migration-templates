
-- File Name		: custom_nominated_acct.sql
-- File Created for	: Spooling file for nominated Accounts
-- Created By		: Kumaresan.B
-- Client		    : EIB
-- Created On		: 10-01-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/custom/custom_nominated_acct.txt
select 
distinct 
FIN_ACC_NUM||'|'||
OPERATIVE_ACC_NUM 
from custom_nominatted_acct;
exit;
 
