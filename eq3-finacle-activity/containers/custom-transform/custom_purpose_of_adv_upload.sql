
-- File Name		: custom_purpose_of_adv_upload.sql 
-- File Created for	: Upload file for sba and caa pupose of advance details
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 17-07-2017
-------------------------------------------------------------------
drop table purpose_of_advance;
create table purpose_of_advance as
select fin_acc_num,trim(SCC2R) Purpose_of_Advn_Code,schm_type from scpf
inner join map_acc on leg_branch_id||leg_scan||leg_Scas =scab||scan||Scas
where schm_type in ('SBA','CAA') and trim(SCC2R) is not null;
exit; 
