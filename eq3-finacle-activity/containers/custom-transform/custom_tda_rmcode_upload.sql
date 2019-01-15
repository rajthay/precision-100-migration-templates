
-- File Name		: custom_tda_rmcode_upload.sql 
-- File Created for	: Upload file for TDA rmcode details
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 20-08-2017
-------------------------------------------------------------------
drop table custom_tda_rmcode;
create table custom_tda_rmcode as
select fin_acc_num,case when nrd.officer_code is not null and trim(nrd.loginid) is not null then to_char(trim(nrd.loginid))
when trim(scpf.scaco)='199' then '199_RBD'
else nvl(convert_codes('RMCODE',trim(scpf.scaco)),'UBSADMIN') end RMCODE from map_acc
inner join scpf on scab||Scan||Scas=leg_branch_id||leg_scan||leg_scas
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
where schm_type='TDA';
exit; 
