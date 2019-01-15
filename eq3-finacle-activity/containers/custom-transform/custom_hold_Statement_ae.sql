 
drop table Hold_statement;
create table Hold_statement as
select distinct Fin_acc_num,schm_type,'Y' Hold_statment from  scpf 
inner join map_acc on leg_branch_id||leg_Scan||leg_Scas=scab||Scan||Scas
where scai64='Y' and schm_type in ('SBA','CAA','ODA');
commit;
exit;
 
