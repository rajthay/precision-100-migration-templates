-- File Name		: custom_limit_link_acct_spool.sql
-- File Created for	: Spooling file for Limit linking to account spool
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
spool $MIG_PATH/output/finacle/custom/custom_limit_link_acct.txt
select 
OLD_CIF||'|'||
FIN_CIF_ID||'|'||
FIN_ACC_NUM||'|'||
EFFECTIVE_DATE||'|'||
LIMIT_PREFIX||'|'||
SUFFIX 
from custom_limit_link_acct;
exit;
 
