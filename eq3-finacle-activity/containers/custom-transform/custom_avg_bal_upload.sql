-- File Name                       : custom_avg_bal_upload_ae.sql
-- File Created for            	   : average balance for cut off month 
-- Created By                      : Alavudeen Ali Badusha.R
-- Client                          : ABK
-- Created On                      : 30-01-2017
-------------------------------------------------------------------
drop table custom_avg_bal;
create table custom_avg_bal as
--select fin_acc_num,schm_type,SRBP03/power(10,c8ced) avg_bal from srpf  -- if it's cut off month end date then  SRBP01 field should be conoff month field.
select fin_acc_num,schm_type,to_number(SRBPTD)/power(10,c8ced) avg_bal from srpf 
inner join map_acc on srab||sran||sras=leg_branch_id||leg_scan||leg_scas
inner join c8pf on c8ccy=currency
where schm_type in ('SBA','CAA','ODA') and srsbtp='C';
--oda scheme type added on 08-06-2017 as per sandeep requirement.
exit; 
