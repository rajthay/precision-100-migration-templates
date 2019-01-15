drop table custom_deal_ref_num;
create table custom_deal_ref_num as
select to_char(fin_acc_num) fin_acc_num,to_char(leg_acc_num) deal_ref_num from map_acc where schm_type in ('LAA','TDA') and schm_code NOT IN ('LAC','CLM') and length(leg_acc_num) > 5
union
select to_char(fin_acc_num) fin_acc_num,to_char(leg_branch_id||leg_scan||leg_scas) deal_ref_num from map_acc where schm_type in ('CLA') and schm_code NOT IN ('LAC','CLM') and length(leg_acc_num) > 5
union
select to_char(fin_acc_num),to_char(svna3) from svpf inner join sypf on syseq = svseq
inner join map_acc on syab||syan||syas = leg_branch_id||leg_scan||leg_scas
where trim(syprim) is null and map_acc.schm_code like 'P%'
and trim(SVNA3) is not null;
commit;
exit; 
