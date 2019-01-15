-- File Name        : spool CA1
-- File Created for    : Creation of source table
-- Created By        : Niranjan I O
-- Client            : ABK trial and error run
-- Created On        : 28-02-2017
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 1200
set page size 0
set pages 0
set trimspool on
CHARACTERSET UTF8
spool $MIG_PATH/output/finacle/core/UAE/TESTCORE001.txt
select leg_branch_id        ||'|'||
fin_branch_id               ||'|'||
branch_id_match_flag        ||'|'||
leg_Customer_number         ||'|'||
fin_Customer_number         ||'|'||
customer_number_match_flag  ||'|'||
leg_suffix_number           ||'|'||
fin_suffix_number           ||'|'||
suffix_matach_flag          ||'|'||
leg_currency                ||'|'||
fin_currency                ||'|'||
currenct_match_flag         ||'|'||
leg_cif_id                  ||'|'||
fin_cif_id                  ||'|'||
cif_id_match_flag           ||'|'||
leg_account_number          ||'|'||         
fin_account_number          ||'|'||
acc_num_match_flag          ||'|'||
leg_cust_type               ||'|'||
fin_cust_type               ||'|'||
cust_type_match_flag        ||'|'||
leg_account_type            ||'|'||
leg_schm_code_type          ||'|'||
fin_schm_code_type          ||'|'||         
schm_code_match_flag        ||'|'||
leg_account_status          ||'|'||
fin_account_status          ||'|'||
fin_tbl_code                ||'|'||
leg_account_open_date       ||'|'||
fin_account_open_date       ||'|'||
acount_open_date_match_flag ||'|'||
leg_last_transaction_date   ||'|'||
fin_last_transaction_date   ||'|'||
last_transaction_date_match ||'|'||
leg_current_balance_amount  ||'|'||
fin_current_balance_amount  ||'|'||
current_bal_amt_match     
from testcore01_O_TABLE;
spool off;
exit;
 
