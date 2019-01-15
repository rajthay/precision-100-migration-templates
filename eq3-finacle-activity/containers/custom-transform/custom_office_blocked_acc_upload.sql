
-- File Name		: custom_office_blocked_acc_upload.sql 
-- File Created for	: Upload file for office account freeze marking
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 13-08-2017
-------------------------------------------------------------------
drop table custom_office_acc_block;
create table custom_office_acc_block as
select distinct
rpad(foracid,16,' ') foracid,
rpad('T',1,' ') frez_code,           
rpad('017',5,' ') frez_reason_code,    
rpad(system_only_acct_flg,1,' ') system_only_acct_flg,
rpad(anw_non_cust_alwd_flg,1,' ') anw_non_cust_alwd_flg
from Office_acc_block
left join all_final_trial_balance on trim(account_number)=scab||scan||scas
--left join yp_mapping on MIGR_PLACEHOLDER =substr(fin_acc_num,6,13)
--inner join tbaadm.gam on foracid=case when scact='YP' then to_char(substr(fin_acc_num,1,5)||FINACLE_PLC) else to_char(fin_acc_num) end
inner join tbaadm.gam on foracid=fin_acc_num and gam.bank_id='01';
exit; 
