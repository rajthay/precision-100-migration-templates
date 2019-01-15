-- File Name		: Collateral_SPOOL
-- File Created for	: Creation of source table
-- Created By		: Kumaresan.B
-- Client		    : ABK
-- Created On		: 23-10-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 5000 
set page size 0
set pages 0
#set trimspool on
set trimspool on
spool $MIG_PATH/output/finacle/collatreal/COLL_MASTER.txt
select
record_indicator||
account_number||
currency_code||
security_code||
security_group_code||
security_class_code||
drawing_power_indicator||
penal_int_applicable||
lien_acid||
certificate_alpha||
certificate_no||
unit_value||
no_of_units||
security_value||
maximum_ceiling_limt||
margin_percent||
item_freq_type||
item_freq_week_num||
item_freq_week_day||
item_freq_start_day||
item_freq_holiday_status||
item_due_date||
received_date||
remarks||
debit_account_for_fees||
derived_value_indicator||
third_party_lien_amount||
assessed_value||
invoice_value||
market_value||
written_down_value||
apportioned_value||
purchase_date||
year_of_creation||
review_date||
net_value_remark1||
net_value_remark2||
net_value_remark3||
net_value_remark4||
net_value_amt1||
net_value_amt2||
net_value_amt3||
net_value_amt4||
net_value_operand1||
net_value_operand2||
net_value_operand3||
net_value_operand4||
full_benefit_flg||
lodge_date||
gross_value||
cif_id||
last_valuation_date||
seq_num||
distinctive_no_from||
distinctive_no_to||
vehicle_chassic_no||
vechicle_regis_no||
vechicle_engine_no||
property_doc_no||
property_add1||
property_add2||
property_city||
property_state||
property_pin_code||
guarantor_id||
guarantee_type||
life_insurance_policy_no||
life_insurance_policy_amt
from collateral_o_table;
exit;
 
