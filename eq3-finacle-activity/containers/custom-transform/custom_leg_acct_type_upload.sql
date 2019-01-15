-- File Name		: custom_leg_acct_type_upload.sql 
-- File Created for	: Upload file for leg account type migration in account 
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 13-08-2017
-------------------------------------------------------------------
drop table custom_leg_acct_type;
create table custom_leg_acct_type as
select fin_acc_num,leg_acct_type,schm_code from map_Acc where schm_type <> 'OOO';
exit; 
