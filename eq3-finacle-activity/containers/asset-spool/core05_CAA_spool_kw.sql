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
spool $MIG_PATH/output/finacle/core/KW/CORE005_CAA.txt
select INDICATOR||ACCOUNT_NUMBER||AMOUNT||TRANSACTION_DATE||CURRENCY_CODE||SERVICE_OUTLET||DUMMY||';CAA_'||trim(SERVICE_OUTLET)||'_'||currency_code||'.txt' 
from AC_BALANCE_O_TABLE
left join tbaadm.gam on foracid=trim(account_number)  
where trim(DUMMY) = 'CAA'  and clr_bal_amt <> trim(amount) and  bank_id=get_param('BANK_ID')
--and trim(ACCOUNT_NUMBER) not in('0633488789001','0633502819001','0633509277135','0636475332001','0638533198001','0639510030001','0639535465001','0640511078001','0640545984001','0900136066201')
order by SERVICE_OUTLET,currency_code;
exit;
 
