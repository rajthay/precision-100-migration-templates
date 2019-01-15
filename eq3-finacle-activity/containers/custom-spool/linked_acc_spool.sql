
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cla/KW/linked_acc.txt
select 
Account_Number||Linked_Account_Number||Link_Type||Linked_Amount||Linked_Amount_Currency||Remarks
from LATU_o_table;
exit; 
