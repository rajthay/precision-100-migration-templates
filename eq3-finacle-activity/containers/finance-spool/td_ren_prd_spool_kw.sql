
-- File Name		: spool TAM
-- File Created for	: SPOOLING TAM MASTER
-- Created By		: Alavudeen Ali Badusha.R
-- Client		    : EmiratesNBD Bank
-- Created On		: 15-12-2014
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/tda/KW/TD_REN_PRD.txt
select 
trim(deposit_account_number)||'|'||
trim(PRD_IN_MNTHS_FOR_AUTO_RENEWAL)||'|'||
trim(PRD_IN_DAYS_FOR_AUTO_RENEWAL)
from TD_REN_PRD;
exit;
 
