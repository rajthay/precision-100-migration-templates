-- File Name		: spool CA1
-- File Created for	: Creation of source table
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 26-05-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 5000 
set page size 0
set pages 0
#set trimspool on
set trimspool on
spool $MIG_PATH/output/finacle/custom/INT_TBL_CODE.txt
select entity_id             ||
entity_type                  ||
start_date                   ||
end_date                     ||
int_tbl_code                 ||
cust_cr_pref_pcnt            ||
cust_dr_pref_pcnt            ||
id_cr_pref_pcnt              ||
id_dr_pref_pcnt              ||
pegged_flg                   ||
peg_frequency_in_months      ||
peg_frequency_in_days        ||
min_int_pcnt_cr              ||
min_int_pcnt_dr              ||
max_int_pcnt_cr              ||
max_int_pcnt_dr              ||
ac_level_nrml_pcnt_dr        ||
ac_level_spread              ||
ac_level_comp_int_pcnt       ||
ac_level_comp_prnc_pcnt      ||
ac_level_pen_int_pcnt_for_int||
ac_level_pen_int_pcnt_for_prn||
ac_level_penal_pcnt_dr       ||
reason_code                  ||
compound_prnc_pcnt           ||
compound_int_pcnt            ||
penalty_int_pcnt_for_prnc    ||
penalty_int_pcnt_for_int     ||
chnl_dr_pref_pcnt            ||
chnl_cr_pref_pcnt            ||
negotiated_rate_dr           ||
int_version                  ||
int_rate_prd_in_months       ||
int_rate_prd_in_days         ||
peg_review_date              ||
review_reqd_on_start_date    ||
interpolation_method         
from int_tbl_code; 
exit;
 
