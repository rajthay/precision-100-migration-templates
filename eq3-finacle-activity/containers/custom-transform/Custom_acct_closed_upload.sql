
-- File Name		: custom_acct_closed.sql 
-- File Created for	: Upload file for cloased account flag
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 10-01-2016
-------------------------------------------------------------------
drop table custom_acct_closed;
create table custom_acct_closed as
select fin_acc_num,'Y' Acct_cls_flg,case when sccad<>0 and get_date_fm_btrv(sccad)<> 'ERROR'
         then lpad(to_char(to_date(get_date_fm_btrv(sccad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')          
         else lpad(' ',10,' ')
         end Acct_cls_date from scpf
inner join map_acc on leg_branch_id||leg_scan||leg_Scas=scab||Scan||scas
where scai30='Y' and scbal = 0
and schm_type in ('SBA','CAA','ODA','PCA');
exit;

 
