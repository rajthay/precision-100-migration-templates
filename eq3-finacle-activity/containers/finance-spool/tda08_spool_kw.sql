set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/tda/KW/TD008.txt
select 
trim(IND)||'|'||                         
trim(ACCT_number)||'|'||                 
trim(crncy_code)||'|'||                  
trim(sol_id)||'|'||                      
trim(accrued_upto_date_cr)||'|'||        
trim(booked_upto_date_cr)||'|'||         
trim(interest_calc_upto_date_cr)||'|'||  
trim(no_recalc_before_date)||'|'||       
trim(nrml_accrued_amount_cr)||'|'||      
trim(nrml_booked_amount_cr)
from TDINTEREST_O_TABLE;
exit;
 
