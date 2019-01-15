
-- File Name		: custom_account_name.sql 
-- File Created for	: Upload file for account name
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 12-06-2017
-------------------------------------------------------------------
drop table custom_account_name;
create table custom_account_name as 
select fin_acc_num,nvl(svna1,scshn) acct_name,schm_type from map_acc
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
left join sypf on syab||syan||syas = leg_branch_id||leg_scan||leg_scas and trim(SYPRIM) is null
LEFT JOIN SXPF ON trim(SXPRIM) IS NULL AND '0'||SXCLC||SXCUS=FIN_CIF_ID
left join svpf on svseq=NVL(syseq,SXSEQ)
where schm_type <> 'OOO';
commit;
exit; 
