
-- File Name		: custom_paid installment details.sql 
-- File Created for	: Upload file for paid installment details
-- Created By		: B. Kumaresan
-- Client			: ABK
-- Created On		: 30-05-2017
-------------------------------------------------------------------
--drop table migappkw.mig_c_amort;
--create table migappkw.mig_c_amort as
--select fin_acc_num,'01' shdl_num,
--lpad(row_number() over (partition by fin_acc_num order by case when ompf_pt.omdte is not null then  to_number(ompf_pt.omdte)
--else to_number(ompf_it.omdte) end ),4,'0')SERIAL_NUM, 
--case when  ompf_pt.omdte is not null and ompf_pt.omdte<>0 then to_date(get_date_fm_btrv(ompf_pt.omdte),'YYYYMMDD')
--when  ompf_it.omdte is not null and ompf_it.omdte<>0 then to_date(get_date_fm_btrv(ompf_it.omdte),'YYYYMMDD') 
--end FLOW_DATE,
--(case when ompf_pt.omdte is not null then  ompf_pt.omnwr
--else 0 end)/POWER(10,c8pf.C8CED)+(case when ompf_it.omdte is not null then  ompf_it.omnwr
--else 0 end)/POWER(10,c8pf.C8CED) INSTALLMENT_AMT,
--case when ompf_pt.omdte is not null then  to_number(ompf_pt.omnwr/POWER(10,c8pf.C8CED))
--else 0 end PRINCIPAL_AMT,
--case when ompf_it.omdte is not null then  to_number(ompf_it.omnwr/POWER(10,c8pf.C8CED))
--else 0 end INTEREST_AMT,
--0 PRINCIPAL_OUTSTANDING,0 FIXEDCHARGE_AMT,
--case when ompf_pt.ommvt='P' and  ompf_pt.ommvts='T'  then 'Normal Interest Demand'
--else 'Regular Installment' end FLOW_DESC,'N' DEL_FLG,'Y'ENTITY_CRE_FLG,'MIG1' RCRE_USER_ID,sysdate RCRE_TIME,'MIG1'LCHG_USER_ID,sysdate LCHG_TIME,get_param('BANK_ID') BANK_ID
--from map_acc 
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and map_acc.leg_acc_num=to_char(serial_deal) 
--left join (select * from ompf where to_number(omdte) <= to_number(get_param('EODCYYMMDD')) 
--and ommvt = 'P' and ommvts in('T') 
--order by to_number(omdte))ompf_pt on b.leg_acc_num=ompf_pt.ombrnm||trim(ompf_pt.omdlp)||trim(ompf_pt.omdlr)
--left join (select * from ompf where to_number(omdte) <= to_number(get_param('EODCYYMMDD')) 
--and ommvt = 'I' and ommvts='T' 
--order by to_number(omdte))ompf_it on b.leg_acc_num=ompf_it.ombrnm||trim(ompf_it.omdlp)||trim(ompf_it.omdlr)
--and ompf_it.omdte=ompf_pt.omdte
--inner join c8pf on c8ccy=currency
--where map_acc.schm_type in('CLA') ;
--------------------------- LAA------------
--insert into migappkw.mig_c_amort 
drop table migappkw.mig_c_amort;
create table migappkw.mig_c_amort as
select fin_acc_num,'01' shdl_num,
lpad(row_number() over (partition by fin_acc_num order by case when ompf_pt.omdte is not null then  to_number(ompf_pt.omdte)
else to_number(ompf_it.omdte) end ),4,'0')SERIAL_NUM, 
case when  ompf_pt.omdte is not null and ompf_pt.omdte<>0 then to_date(get_date_fm_btrv(ompf_pt.omdte),'YYYYMMDD')
when  ompf_it.omdte is not null and ompf_it.omdte<>0 then to_date(get_date_fm_btrv(ompf_it.omdte),'YYYYMMDD') 
end FLOW_DATE,
(case when ompf_pt.omdte is not null then  ompf_pt.omnwr
else 0 end)/POWER(10,c8pf.C8CED)+(case when ompf_it.omdte is not null then  ompf_it.omnwr
else 0 end)/POWER(10,c8pf.C8CED) INSTALLMENT_AMT,
case when ompf_pt.omdte is not null then  to_number(ompf_pt.omnwr/POWER(10,c8pf.C8CED))
else 0 end PRINCIPAL_AMT,
case when ompf_it.omdte is not null then  to_number(ompf_it.omnwr/POWER(10,c8pf.C8CED))
else 0 end INTEREST_AMT,
0 PRINCIPAL_OUTSTANDING,0 FIXEDCHARGE_AMT,
case when ompf_pt.ommvt='P' and  ompf_pt.ommvts='T'  then 'Normal Interest Demand'
else 'Regular Installment' end FLOW_DESC,'N' DEL_FLG,'Y'ENTITY_CRE_FLG,'MIG1' RCRE_USER_ID,sysdate RCRE_TIME,'MIG1'LCHG_USER_ID,sysdate LCHG_TIME,get_param('BANK_ID') BANK_ID
from map_acc 
left join (select * from ompf where to_number(omdte) <= to_number(get_param('EODCYYMMDD')) 
and ommvt = 'P' and ommvts in('T') 
order by to_number(omdte))ompf_pt on leg_acc_num=ompf_pt.ombrnm||trim(ompf_pt.omdlp)||trim(ompf_pt.omdlr)
left join (select * from ompf where to_number(omdte) <= to_number(get_param('EODCYYMMDD')) 
and ommvt = 'I' and ommvts='T' 
order by to_number(omdte))ompf_it on leg_acc_num=ompf_it.ombrnm||trim(ompf_it.omdlp)||trim(ompf_it.omdlr)
and ompf_it.omdte=ompf_pt.omdte
inner join c8pf on c8ccy=currency
where map_acc.schm_type in('LAA','CLA') 
union all
select fin_acc_num,'01' shdl_num,
lpad(row_number() over (partition by fin_acc_num order by case when ompf_pt.omdte is not null then  to_number(ompf_pt.omdte)
else to_number(ompf_it.omdte) end ),4,'0')SERIAL_NUM, 
case when  ompf_pt.omdte is not null and ompf_pt.omdte<>0 then to_date(get_date_fm_btrv(ompf_pt.omdte),'YYYYMMDD')
when  ompf_it.omdte is not null and ompf_it.omdte<>0 then to_date(get_date_fm_btrv(ompf_it.omdte),'YYYYMMDD') 
end FLOW_DATE,
(case when ompf_pt.omdte is not null then  ompf_pt.omnwr
else 0 end)/POWER(10,c8pf.C8CED)+(case when ompf_it.omdte is not null then  ompf_it.omnwr
else 0 end)/POWER(10,c8pf.C8CED) INSTALLMENT_AMT,
case when ompf_pt.omdte is not null then  to_number(ompf_pt.omnwr/POWER(10,c8pf.C8CED))
else 0 end PRINCIPAL_AMT,
case when ompf_it.omdte is not null then  to_number(ompf_it.omnwr/POWER(10,c8pf.C8CED))
else 0 end INTEREST_AMT,
0 PRINCIPAL_OUTSTANDING,0 FIXEDCHARGE_AMT,
case when ompf_pt.ommvt='P' and  ompf_pt.ommvts='T'  then 'Normal Interest Demand'
else 'Regular Installment' end FLOW_DESC,'N' DEL_FLG,'Y'ENTITY_CRE_FLG,'MIG1' RCRE_USER_ID,sysdate RCRE_TIME,'MIG1'LCHG_USER_ID,sysdate LCHG_TIME,get_param('BANK_ID') BANK_ID
from map_acc 
left join (select om1.* from ompf om1 
left join (select  ombrnm||trim(omdlp)||trim(omdlr) del_no,min(omdte) min_dt from ompf where ommvt in ('P','I') and (ommvts in('R') or trim(ommvts) is null)  
and to_number(omdte) >= to_number(get_param('EODCYYMMDD')) group by ombrnm||trim(omdlp)||trim(omdlr) )om2 on om1.ombrnm||trim(om1.omdlp)||trim(om1.omdlr)= om2.del_no 
where to_number(omdte) = to_number(min_dt) 
and ((OMMVT = 'P' and OMMVTS='R')) 
order by to_number(omdte))ompf_pt on leg_acc_num=ompf_pt.ombrnm||trim(ompf_pt.omdlp)||trim(ompf_pt.omdlr)
left join (select * from ompf om1
left join (select  ombrnm||trim(omdlp)||trim(omdlr) del_no,min(omdte) min_dt from ompf where ommvt in ('P','I') and (ommvts in('R') or trim(ommvts) is null) 
and to_number(omdte) >= to_number(get_param('EODCYYMMDD')) group by ombrnm||trim(omdlp)||trim(omdlr) )om2 on om1.ombrnm||trim(om1.omdlp)||trim(om1.omdlr)= om2.del_no 
where to_number(omdte) = to_number(min_dt) 
and (ommvt = 'I' and trim(ommvts) is null) 
order by to_number(omdte))ompf_it on leg_acc_num=ompf_it.ombrnm||trim(ompf_it.omdlp)||trim(ompf_it.omdlr)
inner join c8pf on c8ccy=currency
where map_acc.schm_type in('LAA','CLA') ;
commit;
delete from mig_c_amort where FLOW_DATE is null;
commit;
exit; 
