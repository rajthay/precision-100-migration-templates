
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/core/KW/CORE012.txt
select 
Account_Number||
tod_Amount||
TOD_Grant_Date||
TOD_Expiry_Date||
TOD_Penal_Start_Date||
TOD_Advance_Type||
TOD_Advance_Category||
TOD_Level_Interest_Flag||
TOD_Normal_Interest_Percent||
TOD_Penal_Interest_Percent||
TOD_Availed_Amount||
TOD_Regularized_Amount||
SOL_ID||
CRNCY_CODE||
Entity_Type||
Free_Text
from tod_o_table;
exit;
 
