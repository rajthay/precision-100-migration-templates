set head off
set feedback off
set term off
set lines 292
set page size 0
set pages 0
#set trimspool on
spool $MIG_PATH/output/finacle/custom/custom_provision.txt
select
rpad(nvl(trim(Account_ID),' '),16,' ')||
lpad(nvl(trim(Principal_Outstanding_Amount),' '),17,' ')||
lpad(nvl(trim(Effective_Collateral_Value),' '),17,' ')||
lpad(nvl(trim(Effective_Provision_Amount),' '),17,' ')||
lpad(nvl(trim(Adhoc_Provisional_Amount),' '),17,' ')||
lpad(nvl(trim(Last_Provisional_Date),' '),16,' ')||
lpad(nvl(trim(IAS_Provisional_Amount),' '),17,' ')||
lpad(nvl(trim(Discount_IAS_Provis_Amt),' '),17,' ')
from custom_provision_o_table;
spool off;
 exit;
 
