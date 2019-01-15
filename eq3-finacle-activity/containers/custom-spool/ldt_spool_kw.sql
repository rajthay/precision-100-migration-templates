
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/laa/KW/RL006.txt
select 
Account_ID||Demand_Date||Demand_Effective_Date||Principal_Demand_ID||Demand_Amount||Late_Fee_Applied||Late_Fee_Amount||Late_Fee_Date||Status_Of_Late_Fee||Late_Fee_Currency_Code||Demand_Overdue_Date||Accrued_Penal_Interest_Amount||IBAN_Number 
from ldt_o_table;
exit;
 
