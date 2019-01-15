
-- File Name		: spool Credit Card
-- File Created for	: Credit Card CIF Details.
-- Created By		: Kumaresan.B
-- Client		    : ENBD
-- Created On		: 16-02-2015
-------------------------------------------------------------------
--alter session set "_hash_join_enabled" = true;
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/credit/CREDITCARDCIF.txt
select 
seq_no||
card_no||
fin_cif_id
from CREDIT_CARD_CIF_O_TABLE 
order by seq_no;
exit;
 
