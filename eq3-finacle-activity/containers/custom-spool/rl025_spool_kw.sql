set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/laa/KW/RL025.txt
select 
trim(INDICATOR)||'|'||             
trim(ACCOUNT_NUMBER)||'|'||         
trim(CURRENCY)||'|'||               
trim(SOL_ID)||'|'||                 
trim(DR_INT_ACCRUED_UPTO)||'|'||    
trim(DR_INT_BOOKED_UPTO)||'|'||     
trim(DR_INT_CALU_UPTO)||'|'||       
trim(NO_RECALC_BEFORE_DATE)||'|'||  
trim(DR_INT_ACCRUED)||'|'||         
trim(DR_INT_BOOKED)||'|'||          
trim(NEXT_INT_RUN_DATE_DR)||'|'||   
trim(PENAL_ACCRUED_AMOUNT_DR)||'|'||
trim(PENAL_BOOKED_AMOUNT_DR) 
from laa_eit;
exit;
 
