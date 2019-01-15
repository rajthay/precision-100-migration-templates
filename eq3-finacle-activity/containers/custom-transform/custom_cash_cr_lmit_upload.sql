-- File Name		: custom_cash_cr_limit_upload.sql 
-- File Created for	: Upload file for cash deposit restricted for Currency exchange companies.
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 12-04-2016
-------------------------------------------------------------------
drop table custom_cash_cr_limit;
create table custom_cash_cr_limit as
select Fin_acc_num,'0' cash_cr_limit, schm_type from map_acc 
inner join scpf on scab||Scan||Scas=leg_branch_id||leg_scan||leg_scas
where schm_type in ('SBA','CAA','ODA')
and trim(scc3r)='EX';
exit; 
