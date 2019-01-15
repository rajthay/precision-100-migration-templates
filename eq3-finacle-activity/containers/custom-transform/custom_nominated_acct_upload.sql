
-- File Name		: custom_nominated_acct_upload.sql 
-- File Created for	: Upload file for SBA and CAA nominated accounts
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 24-04-2017
-------------------------------------------------------------------
drop table custom_nominated_accounts;
create table custom_nominated_accounts as
select map_acc.fin_acc_num,operative_acc_num,schm_type from map_acc     
inner join (select map_acc.fin_acc_num fin_num, oper.fin_acc_num operative_acc_num  from ubpf inner join map_acc on ubab=leg_branch_id and uban=leg_scan and ubas=leg_scas
inner join (select leg_branch_id||leg_Scan||leg_Scas leg_acc_num,fin_acc_num from map_acc where SCHM_TYPE<>'OOO') oper on ubnab||ubnan||ubnas=oper.leg_acc_num 
where map_acc.schm_type<>'OOO') oper on oper.fin_num=fin_acc_num
where map_acc.schm_type in ('SBA','CAA');
exit;
 
