-- File Name		: spool CA1
-- File Created for	: Creation of source table
-- Created By		: R.Alavudeen Ali Badusha 
-- Client		    : ABK
-- Created On		: 09-07-2017
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/core/KW/CORE005_PCA.txt
select INDICATOR||ACCOUNT_NUMBER||AMOUNT||TRANSACTION_DATE||CURRENCY_CODE||SERVICE_OUTLET||DUMMY||';ODA_'||trim(SERVICE_OUTLET)||'_'||currency_code||'.txt' 
from AC_BALANCE_O_TABLE
left join tbaadm.gam on foracid=trim(account_number)  
where trim(DUMMY) = 'PCA'  and clr_bal_amt <> trim(amount) and  bank_id=get_param('BANK_ID') 
order by SERVICE_OUTLET,currency_code;
exit;
 
