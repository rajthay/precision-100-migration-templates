-- File Name		: spool CA1
-- File Created for	: Creation of source table
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
spool $MIG_PATH/output/finacle/core/KW/CORE008.txt
select ACCOUNT_NUMBER||BEGIN_CHEQUE_NUMBER||SP_ACCEPTANCE_DATE||CHEQUE_DATE||CHEQUE_AMOUNT||SPT_O_TABLE.PAYEE_NAME||NO_OF_LEAVES||CHEQUE_ALPHA_CODE||REASON_CODE_FOR_STOP_PAYMENT||ACCOUNT_BALANCE||CURRENCY_CODE
from SPT_O_TABLE;
--inner join (select * from tbaadm.gam where bank_id=get_param('BANK_ID')) gam on gam.foracid=trim(account_number) 
--left join  (select * from tbaadm.spt where bank_id=get_param('BANK_ID')) spt on gam.acid=spt.acid and to_number(trim(begin_cheque_number))=spt.begin_chq_num 
--where  spt.begin_chq_num is null;
exit;
 
