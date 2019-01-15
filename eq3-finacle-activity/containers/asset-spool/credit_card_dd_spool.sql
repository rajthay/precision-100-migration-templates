-- File Name		: spool Credit Card Account
-- File Created for	: Credit Card CIF Details.
-- Created By		: Kumaresan.B
-- Client		    : ENBD
-- Created On		: 18-02-2015
-------------------------------------------------------------------
--alter session set "_hash_join_enabled" = true;
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/credit/CREDITCARDDD.txt
select
SEQ_NO||
ACCOUNT_NO||
FIN_ACC_NUM||
FIN_SOL_ID
from credit_card_dd_o_table
order by to_number(SEQ_NO);
exit;
 
