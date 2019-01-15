-- File Name		: custom_interest_flag_upload.sql 
-- File Created for	: Upload file for intereag flag set to 'N' for 'ZERO' tiercode accounts
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 20-04-2016
-------------------------------------------------------------------
drop table interest_flag;
create table interest_flag as 
select fin_acc_num,case when trim(s5trcd) ='ZERO' then 'N' else null end int_coll_flg,case when trim(s5trcc) ='ZERO' then 'N' else null end int_pay_flg from acct_interest_tbl 
inner join map_acc on leg_branch_id||leg_scan||leg_scas = s5ab||s5an||s5as
where (s5trcd ='ZERO' or s5trcc='ZERO') and map_acc.schm_type in ('SBA','CAA','ODA');
exit; 
