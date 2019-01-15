set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/KW_CLA.dat
drop table cla_acc_fin_int_rate_report;
create table cla_acc_fin_int_rate_report
as
SELECT a.*,csp.int_tbl_code tbl_code,base_pcnt_dr,base_pcnt_cr,nvl(c.nrml_int_pcnt,0) cr_nrml_int_pcnt, nvl(d.nrml_int_pcnt,0) dr_nrml_int_pcnt,
acc_pref_rate - (nvl(base_pcnt_dr,0) + nvl(d.nrml_int_pcnt,0))actual_pref_rate
from
cla_int_tbl a
left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on
a.schm_code = csp.schm_code and a.v5ccy = csp.crncy_code
left join (select c.* from tbaadm.icv c
inner join ( 
select a.int_tbl_code,a.crncy_code,a.INT_TBL_VER_NUM,min(a.INT_VERSION) INT_VERSION 
from tbaadm.icv a
inner join ( 
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM 
from tbaadm.icv where del_flg = 'N' and bank_id = get_param('BANK_ID') 
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
where a.del_flg = 'N' and a.bank_id = get_param('BANK_ID')
group by a.int_tbl_code,a.crncy_code, a.INT_TBL_VER_NUM) d 
on d.int_tbl_code=c.int_tbl_code and d.crncy_code=c.crncy_code and d.INT_TBL_VER_NUM=c.INT_TBL_VER_NUM 
and c.INT_VERSION=d.INT_VERSION
where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and  c.START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  csp.int_tbl_code =b.int_tbl_code  and  csp.CRNCY_CODE = b.CRNCY_CODE
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'C'
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'D'
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
where trim(csp.int_tbl_code)<>'CORTE';
--WHERE A.SCHM_TYPE IN ('LAA','CLA')
create index int_tbl_idxrrr on cla_acc_fin_int_rate_report(int_acc_num);
drop table cla_account_finacle_int_rate1;
create table  cla_account_finacle_int_rate1 as
select cl.*, itc.ID_DR_PREF_PCNT  from cla_acc_fin_int_rate_report cl
inner join map_acc on leg_acc_num= INT_ACC_NUM
left join (select * from tbaadm.gam where bank_id='01' and schm_type='CLA')gam on gam.foracid=fin_acc_num
LEFT JOIN (select itc1.* from tbaadm.itc itc1  inner join
(select entity_id,max(LCHG_TIME) LCHG_TIME from tbaadm.itc  group by entity_id)itc2 on itc1.entity_id=itc2.entity_id and itc1.LCHG_TIME=itc2.LCHG_TIME
where itc1.entity_id in (select acid from tbaadm.gam where schm_type='CLA' and bank_id='01'))itc ON itc.entity_id = gam.acid;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop table cla_ac_fin_int_rate_les12_rep;
create table cla_ac_fin_int_rate_les12_rep as
SELECT a.*,csp.int_tbl_code tbl_code,base_pcnt_dr,base_pcnt_cr,nvl(trim(c.nrml_int_pcnt),0) cr_nrml_int_pcnt, nvl(trim(d.nrml_int_pcnt),0) dr_nrml_int_pcnt,
nvl(trim(acc_pref_rate),0) - (nvl(trim(base_pcnt_dr),0) + nvl(trim(d.nrml_int_pcnt),0))actual_pref_rate,d.LOAN_TENOR_MTHS LOAN_TENOR_MTHS_dr,c.LOAN_TENOR_MTHS LOAN_TENOR_MTHS_cr
from
cla_int_tbl a
left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on
a.schm_code = csp.schm_code and a.v5ccy = csp.crncy_code
left join (select c.* from tbaadm.icv c
inner join ( 
select a.int_tbl_code,a.crncy_code,a.INT_TBL_VER_NUM,min(a.INT_VERSION) INT_VERSION 
from tbaadm.icv a
inner join ( 
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM 
from tbaadm.icv where del_flg = 'N' and bank_id = get_param('BANK_ID') 
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
where a.del_flg = 'N' and a.bank_id = get_param('BANK_ID')
group by a.int_tbl_code,a.crncy_code, a.INT_TBL_VER_NUM) d 
on d.int_tbl_code=c.int_tbl_code and d.crncy_code=c.crncy_code and d.INT_TBL_VER_NUM=c.INT_TBL_VER_NUM 
and c.INT_VERSION=d.INT_VERSION
where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and  c.START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  csp.int_tbl_code =b.int_tbl_code  and  csp.CRNCY_CODE = b.CRNCY_CODE
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'C'
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'D' and LOAN_TENOR_MTHS<=12
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D' and LOAN_TENOR_MTHS<=12
where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(INT_ACC_NUM)
where trim(csp.int_tbl_code)='CORTE' AND 1=2 --Prashant
and (case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
     else 0 end)<=12;
create index int_tbl_idx_3_rep on cla_ac_fin_int_rate_les12_rep(int_acc_num);
drop table cla_acct_fin_int_rate_les121;
create table  cla_acct_fin_int_rate_les121 as
select cl.*, itc.ID_DR_PREF_PCNT  from cla_ac_fin_int_rate_les12_rep cl
inner join map_acc on leg_acc_num= INT_ACC_NUM
left join (select * from tbaadm.gam where bank_id='01' and schm_type='CLA')gam on gam.foracid=fin_acc_num
LEFT JOIN (select itc1.* from tbaadm.itc itc1  inner join
(select entity_id,max(LCHG_TIME) LCHG_TIME from tbaadm.itc  group by entity_id)itc2 on itc1.entity_id=itc2.entity_id and itc1.LCHG_TIME=itc2.LCHG_TIME
where itc1.entity_id in (select acid from tbaadm.gam where schm_type='CLA' and bank_id='01'))itc ON itc.entity_id = gam.acid;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop table cla_acc_fin_int_rt_more12_rep;
create table cla_acc_fin_int_rt_more12_rep as
SELECT a.*,csp.int_tbl_code tbl_code,base_pcnt_dr,base_pcnt_cr,nvl(trim(c.nrml_int_pcnt),0) cr_nrml_int_pcnt, nvl(trim(d.nrml_int_pcnt),0) dr_nrml_int_pcnt,
nvl(trim(acc_pref_rate),0) - (nvl(trim(base_pcnt_dr),0) + nvl(trim(d.nrml_int_pcnt),0))actual_pref_rate,d.LOAN_TENOR_MTHS LOAN_TENOR_MTHS_dr,c.LOAN_TENOR_MTHS LOAN_TENOR_MTHS_cr
from
cla_int_tbl a
left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on
a.schm_code = csp.schm_code and a.v5ccy = csp.crncy_code
left join (select c.* from tbaadm.icv c
inner join ( 
select a.int_tbl_code,a.crncy_code,a.INT_TBL_VER_NUM,min(a.INT_VERSION) INT_VERSION 
from tbaadm.icv a
inner join ( 
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM 
from tbaadm.icv where del_flg = 'N' and bank_id = get_param('BANK_ID') 
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
where a.del_flg = 'N' and a.bank_id = get_param('BANK_ID')
group by a.int_tbl_code,a.crncy_code, a.INT_TBL_VER_NUM) d 
on d.int_tbl_code=c.int_tbl_code and d.crncy_code=c.crncy_code and d.INT_TBL_VER_NUM=c.INT_TBL_VER_NUM 
and c.INT_VERSION=d.INT_VERSION
where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and  c.START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  csp.int_tbl_code =b.int_tbl_code  and  csp.CRNCY_CODE = b.CRNCY_CODE
--and (acct_open_date between b.start_date and b.MODIFY_END_DATE) 
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'C'
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'D' --and LOAN_TENOR_MTHS>12 prashant
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
where del_flg = 'N' and bank_id = get_param('BANK_ID') --and LOAN_TENOR_MTHS>12 prashant
)d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(INT_ACC_NUM)
where trim(csp.int_tbl_code)='CORTE';
create index int_tbl_idx_4_rep on cla_acc_fin_int_rt_more12_rep(int_acc_num);
drop table cla_acct_fin_int_rate_more121;
create table  cla_acct_fin_int_rate_more121 as
select cl.*, itc.ID_DR_PREF_PCNT  from cla_acc_fin_int_rt_more12_rep cl
inner join map_acc on leg_acc_num= INT_ACC_NUM
left join (select * from tbaadm.gam where bank_id='01' and schm_type='CLA')gam on gam.foracid=fin_acc_num
LEFT JOIN (select itc1.* from tbaadm.itc itc1  inner join
(select entity_id,max(LCHG_TIME) LCHG_TIME from tbaadm.itc  group by entity_id)itc2 on itc1.entity_id=itc2.entity_id and itc1.LCHG_TIME=itc2.LCHG_TIME
where itc1.entity_id in (select acid from tbaadm.gam where schm_type='CLA' and bank_id='01'))itc ON itc.entity_id = gam.acid;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop table cla_lac_fin_int_rt_mr12_rep;
create table cla_lac_fin_int_rt_mr12_rep as
select a.*,csp.int_tbl_code,base_pcnt_dr,base_pcnt_cr,
case 
when trim(s5trcc) like 'C%' then csp.int_tbl_code
when trim(s5trcd) is not null then s5trcd
when trim(s5trcc) is not null then s5trcc
when trim(s5trcd) is not null and trim(s5trcc) is not null then 'ZERO'
when trim(s5brrd) is not null and trim(s5brrc)  is not null then 'ZERO'
else csp.int_tbl_code end TBL_CODE_MIGR
,
case 
when trim(s5trcd) is not null then 0
when nvl(trim(s5ratd),0) <> 0 then (nvl(trim(s5ratd),0) - (nvl(base_pcnt_dr,0)+nvl(d.nrml_int_pcnt,0)))
when (nvl(dr_base_rate,0) + nvl(diff_dr_rate,0) + nvl(dr_margin_rate,0)) <> nvl(base_pcnt_dr,0) + nvl(d.nrml_int_pcnt,0)
 then ((nvl(dr_base_rate,0) + nvl(diff_dr_rate,0) + nvl(dr_margin_rate,0)) - (nvl(base_pcnt_dr,0)+nvl(d.nrml_int_pcnt,0)))
else 0 end dr_pref_rate
,
case 
when trim(s5trcc) is not null then 0
when nvl(trim(s5ratc),0) <> 0 then (nvl(trim(s5ratc),0) - (nvl(base_pcnt_cr,0)+nvl(c.nrml_int_pcnt,0)))
when (nvl(cr_base_rate,0) + nvl(diff_cr_rate,0) - nvl(cr_margin_rate,0)) <> nvl(base_pcnt_cr,0) + nvl(c.nrml_int_pcnt,0) then 
((nvl(cr_base_rate,0) + nvl(diff_cr_rate,0) - nvl(cr_margin_rate,0))-(nvl(base_pcnt_cr,0)+nvl(c.nrml_int_pcnt,0)))
else 0 end cr_pref_rate,
nvl(c.nrml_int_pcnt,0)cr_nrml_int_pcnt,
nvl(d.nrml_int_pcnt,0)dr_nrml_int_pcnt
from
ACCT_INTEREST_TEMP a
left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on
a.schm_code = csp.schm_code and a.s5ccy = csp.crncy_code
left join (select c.* from tbaadm.icv c
inner join ( 
select a.int_tbl_code,a.crncy_code,a.INT_TBL_VER_NUM,min(a.INT_VERSION) INT_VERSION 
from tbaadm.icv a
inner join ( 
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM 
from tbaadm.icv where del_flg = 'N' and bank_id = get_param('BANK_ID') 
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
where a.del_flg = 'N' and a.bank_id = get_param('BANK_ID')
group by a.int_tbl_code,a.crncy_code, a.INT_TBL_VER_NUM) d 
on d.int_tbl_code=c.int_tbl_code and d.crncy_code=c.crncy_code and d.INT_TBL_VER_NUM=c.INT_TBL_VER_NUM 
and c.INT_VERSION=d.INT_VERSION
where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID'))b  on csp.int_tbl_code =b.int_tbl_code  and   csp.CRNCY_CODE = b.CRNCY_CODE 
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'C'
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'D' --and LOAN_TENOR_MTHS>12 Prashant
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
where del_flg = 'N' and bank_id = get_param('BANK_ID') --and LOAN_TENOR_MTHS>12 Prashant
 )d  on d.int_tbl_code =csp.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
 inner join scpf on scab=s5ab and scan=s5an and scas=s5as
where csp.INT_TBL_CODE='CORTE';
create index cla_lac_idx_rep on cla_lac_fin_int_rt_mr12_rep(s5ab||s5an||s5as);
drop table cla_lac_fin_int_rate_more121;
create table  cla_lac_fin_int_rate_more121 as
select cl.*, itc.ID_DR_PREF_PCNT  from cla_lac_fin_int_rt_mr12_rep cl
inner join map_acc on leg_branch_id||leg_scan||leg_scas= s5ab||s5an||s5as
left join (select * from tbaadm.gam where bank_id='01' and schm_type='CLA')gam on gam.foracid=fin_acc_num
LEFT JOIN (select itc1.* from tbaadm.itc itc1  inner join
(select entity_id,max(LCHG_TIME) LCHG_TIME from tbaadm.itc  group by entity_id)itc2 on itc1.entity_id=itc2.entity_id and itc1.LCHG_TIME=itc2.LCHG_TIME
where itc1.entity_id in (select acid from tbaadm.gam where schm_type='CLA' and bank_id='01'))itc ON itc.entity_id = gam.acid;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop table cla_lac_fin_int_rate_les12_rep;
create table cla_lac_fin_int_rate_les12_rep as
select a.*,csp.int_tbl_code,base_pcnt_dr,base_pcnt_cr,
case 
when trim(s5trcc) like 'C%' then csp.int_tbl_code
when trim(s5trcd) is not null then s5trcd
when trim(s5trcc) is not null then s5trcc
when trim(s5trcd) is not null and trim(s5trcc) is not null then 'ZERO'
when trim(s5brrd) is not null and trim(s5brrc)  is not null then 'ZERO'
else csp.int_tbl_code end TBL_CODE_MIGR
,
case 
when trim(s5trcd) is not null then 0
when nvl(trim(s5ratd),0) <> 0 then (nvl(trim(s5ratd),0) - (nvl(base_pcnt_dr,0)+nvl(d.nrml_int_pcnt,0)))
when (nvl(dr_base_rate,0) + nvl(diff_dr_rate,0) + nvl(dr_margin_rate,0)) <> nvl(base_pcnt_dr,0) + nvl(d.nrml_int_pcnt,0)
 then ((nvl(dr_base_rate,0) + nvl(diff_dr_rate,0) + nvl(dr_margin_rate,0)) - (nvl(base_pcnt_dr,0)+nvl(d.nrml_int_pcnt,0)))
else 0 end dr_pref_rate
,
case 
when trim(s5trcc) is not null then 0
when nvl(trim(s5ratc),0) <> 0 then (nvl(trim(s5ratc),0) - (nvl(base_pcnt_cr,0)+nvl(c.nrml_int_pcnt,0)))
when (nvl(cr_base_rate,0) + nvl(diff_cr_rate,0) - nvl(cr_margin_rate,0)) <> nvl(base_pcnt_cr,0) + nvl(c.nrml_int_pcnt,0) then 
((nvl(cr_base_rate,0) + nvl(diff_cr_rate,0) - nvl(cr_margin_rate,0))-(nvl(base_pcnt_cr,0)+nvl(c.nrml_int_pcnt,0)))
else 0 end cr_pref_rate,
nvl(c.nrml_int_pcnt,0)cr_nrml_int_pcnt,
nvl(d.nrml_int_pcnt,0)dr_nrml_int_pcnt
from
ACCT_INTEREST_TEMP a
left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on
a.schm_code = csp.schm_code and a.s5ccy = csp.crncy_code
left join (select c.* from tbaadm.icv c
inner join ( 
select a.int_tbl_code,a.crncy_code,a.INT_TBL_VER_NUM,min(a.INT_VERSION) INT_VERSION 
from tbaadm.icv a
inner join ( 
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM 
from tbaadm.icv where del_flg = 'N' and bank_id = get_param('BANK_ID') 
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
where a.del_flg = 'N' and a.bank_id = get_param('BANK_ID')
group by a.int_tbl_code,a.crncy_code, a.INT_TBL_VER_NUM) d 
on d.int_tbl_code=c.int_tbl_code and d.crncy_code=c.crncy_code and d.INT_TBL_VER_NUM=c.INT_TBL_VER_NUM 
and c.INT_VERSION=d.INT_VERSION
where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID'))b  on csp.int_tbl_code =b.int_tbl_code  and   csp.CRNCY_CODE = b.CRNCY_CODE 
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'C'
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'D' and LOAN_TENOR_MTHS<=12
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
where del_flg = 'N' and bank_id = get_param('BANK_ID') and LOAN_TENOR_MTHS<=12 
 )d  on d.int_tbl_code =csp.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
 inner join scpf on scab=s5ab and scan=s5an and scas=s5as
where csp.INT_TBL_CODE='CORTE' and 1=2 -- prashant to not get any records
and (case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
     else 0 end)<=12;     
create index cla_lac_idx1_rep on cla_lac_fin_int_rate_les12_rep(s5ab||s5an||s5as);
drop table cla_lac_fin_int_rate_les121;
create table  cla_lac_fin_int_rate_les121 as
select cl.*, itc.ID_DR_PREF_PCNT  from cla_lac_fin_int_rate_les12_rep cl
inner join map_acc on leg_branch_id||leg_scan||leg_scas= s5ab||s5an||s5as
left join (select * from tbaadm.gam where bank_id='01' and schm_type='CLA')gam on gam.foracid=fin_acc_num
LEFT JOIN (select itc1.* from tbaadm.itc itc1  inner join
(select entity_id,max(LCHG_TIME) LCHG_TIME from tbaadm.itc  group by entity_id)itc2 on itc1.entity_id=itc2.entity_id and itc1.LCHG_TIME=itc2.LCHG_TIME
where itc1.entity_id in (select acid from tbaadm.gam where schm_type='CLA' and bank_id='01'))itc ON itc.entity_id = gam.acid;
update  cla_operacc set OMPF_LEG_NUM=trim(OMPF_LEG_NUM);
create index newww11 on cla_operacc(OMPF_LEG_NUM);     
update cla_account_finacle_int_rate1 set int_acc_num=trim(int_acc_num);
update cla_acct_fin_int_rate_les121 set int_acc_num=trim(int_acc_num);
update cla_acct_fin_int_rate_more121 set int_acc_num=trim(int_acc_num);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
Select    
'EXTERNAL_ACC_NO'||'|'||
'LEG_BRCH_ID'||'|'||
'LEG_CLIENT_NO'||'|'||
'LEG_SUFFIX'||'|'||
'LEG_CCY'||'|'||
'FINACLE_CCY'||'|'||
'CCY_MATCH'||'|'||
'FINACLE_SOL_ID'||'|'||
'FINACLE_CIF_ID'||'|'||
'LEG_CONTRACT'||'|'||
'LEG_DEAL_REF_NUMBER' ||'|'||
'FINACLE_ACCT_NUM'||'|'||
'LEG_CUST_TYPE'||'|'||
'LEG_ACCT_TYPE'||'|'||
'FINACLE_SCHEME_CODE'||'|'||
'SCHEME_DESCRIPTION'||'|'||
'LEGACY_CUST_NAME' ||'|'||
'FINACLE_CUST_NAME' ||'|'||
'LEGACY_NET_RATE'||'|'||
'FINACLE_NET_RATE'||'|'||
'NET_RATE_MATCH'||'|'||
'FINACLE_DEBIT_PREF_PERCENT'||'|'||
'BASE_DEBIT_PERCENT'||'|'||
'FINACLE_REPRICING_PLAN'||'|'||
'LEG_ACCT_OPN_DATE'||'|'||
'FINACLE_ACCT_OPN_DATE'||'|'||
'ACCT_OPN_DATE_MATCH'||'|'||
'LEG_SANCTION_LIMIT'||'|'||
'FINACLE_SANCTION_LIMIT'||'|'||
'SANCTION_LIMIT_MATCH'||'|'||
'LEG_LIMIT_SANCTION_DATE'||'|'||
'FINACLE_LIMIT_SANCTION_DATE'||'|'||
'LIMIT_SANCTION_DATE_MATCH'||'|'||
'LEG_LIMIT_EXPIRY_DATE'||'|'||
'FINACLE_LIMIT_EXPIRY_DATE'||'|'||
'LIMIT_EXPIRY_DATE_MATCH'||'|'||
'FINACLE_INT_TBL_CODE'||'|'||
'LEG_REPY_PRD_IN_MONS'||'|'||
'FINACLE_REPY_PRD_IN_MON'||'|'||
'REPY_PRD_IN_MON_MATCH'||'|'||
'LEG_LIAB_TRF_UPD_AMOUNT'||'|'||
'FINACLE_LIAB_TRF_UPD_AMOUNT'||'|'||
'LIAB_TRF_UPD_AMOUNT_MATCH'||'|'||
--'LEG_UPFRONT_INSTALLMENT_COLL'||'|'||
'FINACLE_UPFRONT_INSTALLMENT_COLL'||'|'||
--'UPFRONT_INSTLMNT_COLL_MATCH'||'|'||
'LEG_SUM_OF_THE_PRINC_DMD_AMT'||'|'||
'FINACLE_SUM_OF_THE_PRN_DMD_AMT'||'|'||
'SUM_OF_THE_PRN_DMD_AMT_MATCH'||'|'||
'LEG_DMD_SATISFY_MTHD'||'|'||
'FINACLE_DMD_SATISFY_MTHD'||'|'||
'DMD_SATISFY_MTHD_MATCH'||'|'||
'LEG_INT_RATE_ON_SANC_LMT'||'|'||
'FINACLE_INT_RATE_ON_SANC_LMT'||'|'||
'INT_RATE_ON_SANC_LMT_MATCH'||'|'||
'LEG_PI_BASED_ON_OUTSTANDING'||'|'||
'FIN_PI_BASED_ON_OUTSTANDING'||'|'||
'LEG_REPAY_SCHEDULE_DATE'||'|'||
'FINACLE_REPAY_SCHEDULE_DATE'||'|'||
'REPAY_SCHEDULE_DATE_MATCH'||'|'||
'LEG_OPERATIVE_BRANCH'||'|'||
'LEG_OPERATIVE_CLIENT_NO'||'|'||
'LEG_OPERATIVE_ORDINAL'||'|'||
'LEG_OPERATIVE_CCY'||'|'||
'LEG_OPERATIVE_ACC'||'|'||
'FIN_OPERATIVE_ACC'||'|'||
'OPERATIVE_ACC_MATCH'||'|'||
'LEG_TENOR_IN_MONTHS'||'|'||
'FINACLE_TENOR_IN_MONTHS'||'|'||
'TENOR_IN_MONTHS_MATCH'||'|'||
'LEG_TENOR_IN_DAYS'||'|'||
'FINACLE_TENOR_IN_DAYS'||'|'||
'TENOR_IN_DAYS_MATCH'||'|'||
'LEG_PURPOSE_OF_LOAN'||'|'||
'FIN_PURPOSE_OF_LOAN'||'|'||
'PURPOSE_OF_LOAN_MATCH'||'|'||
'FIN_DUE_AMT'||'|'||
'LEG_DUE_AMT'||'|'||
'DUE_AMT_MATCH'||'|'||
'FIN_DUE_DAYS'||'|'||
'FIN_DUE_DAYS'||'|'||
'DUE_DAYS_MATCH'||'|'||
'MANAGER'||'|'||
'LEG_INT_FREQ'||'|'||
'FIN_INT_FREQ'||'|'||
'FREQ_DESC' 
from dual
union all
select distinct
to_char(map_acc.EXTERNAL_ACC)||'|'||
to_char(map_acc.leg_branch_id) ||'|'||
to_char(map_acc.leg_scan) ||'|'||
to_char(map_acc.LEG_SCAS) ||'|'||
TO_CHAR(otccy) ||'|'||
to_char(gam.acct_crncy_code) ||'|'||
CASE WHEN TO_CHAR(otccy) = gam.acct_crncy_code THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(gam.sol_id) ||'|'||
to_char(gam.cif_id) ||'|'||
to_char(map_acc.leg_acc_num) ||'|'||
TO_CHAR(V5PF.V5DLR) ||'|'||
to_char(gam.foracid) ||'|'|| 
to_char(map_acc.leg_cust_type) ||'|'||
to_char(map_acc.leg_acct_type) ||'|'|| 
to_char(map_acc.schm_code) ||'|'||
to_char(gsp.SCHM_DESC)||'|'||
to_char(c_name.acct_name) ||'|'||
to_char(gam.ACCT_NAME) ||'|'||
to_char(nvl(nvl(c.ACC_PREF_RATE,nvl(e.ACC_PREF_RATE,d.ACC_PREF_RATE )),0))||'|'||
to_char(nvl((c.BASE_PCNT_DR+c.ACTUAL_PREF_RATE),nvl(nvl(e.BASE_PCNT_DR,0)+e.ACTUAL_PREF_RATE+e.DR_NRML_INT_PCNT,nvl(d.BASE_PCNT_DR,0)+d.ACTUAL_PREF_RATE+d.DR_NRML_INT_PCNT )))||'|'||
case when (to_number(nvl(c.ACC_PREF_RATE,nvl(e.ACC_PREF_RATE,d.ACC_PREF_RATE )))) =(to_number(to_char(nvl((c.BASE_PCNT_DR+c.ACTUAL_PREF_RATE),nvl(nvl(e.BASE_PCNT_DR,0)+e.ACTUAL_PREF_RATE+e.DR_NRML_INT_PCNT,nvl(d.BASE_PCNT_DR,0)+d.ACTUAL_PREF_RATE+d.DR_NRML_INT_PCNT ))))) then 'TRUE' ELSE 'FALSE' End||'|'||
to_char(nvl(c.ACTUAL_PREF_RATE,nvl(e.ACTUAL_PREF_RATE,d.ACTUAL_PREF_RATE )))||'|'||
to_char(nvl((c.BASE_PCNT_DR),nvl((d.BASE_PCNT_DR),(nvl(e.BASE_PCNT_DR,0)))))||'|'||
to_char(TRIM (lrp.repricing_plan)) ||'|'|| 
to_char(case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
            else ' ' end)  ||'|'||
TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY')||'|'||
case when  to_char(case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
            else ' ' end)  = TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY') then 'TRUE' else 'FALSE' end  ||'|'||
to_char(abs(to_number(otdla/POWER(10,c8pf.C8CED))))||'|'||
to_char(gam.sanct_lim) ||'|'||
CASE WHEN (abs(to_number(otdla/POWER(10,c8pf.C8CED))))  = TRIM(gam.sanct_lim) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
else ' ' end,10,' ')) ||'|'||
TO_CHAR (lht.lim_sanct_date,'DD-MM-YYYY') ||'|'||
case when trim(to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
else ' ' end,10,' ')))=trim(TO_CHAR(lht.lim_sanct_date,'DD-MM-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
to_char(rpad(case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MON-YYYY')
     else '' end,11,' ')) ||'|'||
TO_CHAR (lht.lim_exp_date,'DD-MON-YYYY') ||'|'||   
CASE WHEN (rpad(case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MON-YYYY')
     else '' end,11,' ')) = TO_CHAR (lht.lim_exp_date, 'DD-MON-YYYY') THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(cla_account_finacle_int_rate.INT_TBL_CODE) ||'|'||
to_char(TRIM (itc.int_tbl_code)) ||'|'||
to_char(rpad(
     --case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
     --else 0 end
     ,3,' '))||'|'||
to_char(TRIM (lam.rep_perd_mths)) ||'|'||
case when (trim(to_char(
     --case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
     --else 0 end
     )))=trim((to_char(lam.rep_perd_mths))) then 'TRUE' else 'FALSE' end ||'|'||
to_char(rpad(to_number(otdla)/POWER(10,c8pf.C8CED),17,' '))||'|'||
to_char(TRIM (lam.liab_as_on_xfer_eff_date))||'|'||
case when trim(to_char(rpad(to_number(otdla)/POWER(10,c8pf.C8CED),17,' '))) = trim(to_char( (lam.liab_as_on_xfer_eff_date))) then 'TRUE' else 'FALSE' end||'|'||
to_char(TRIM (lsp.upfront_instlmnt_coll)) ||'|'||
to_char(lpad(abs(to_number(nvl(sum_overdue,0)))/POWER(10,c8pf.C8CED),17,' '))||'|'||
to_char(TRIM(lam.sum_principal_dmd_amt))||'|'||
case when TRIM(to_char(lpad(abs(to_number(nvl(sum_overdue,0)))/POWER(10,c8pf.C8CED),17,' ')))=(to_char(TRIM(lam.sum_principal_dmd_amt))) then 'TRUE' else 'FALSE' END ||'|'||
to_char(TRIM (rpad(case when trim(oper.fin_acc_num) is not null then  'T' else 'N' end,1,' '))) ||'|'|| 
to_char(TRIM (lam.dmd_satisfy_mthd)) ||'|'|| 
CASE WHEN TRIM(case when trim(oper.fin_acc_num) is not null then  'T' else 'N' end) = TRIM(lam.dmd_satisfy_mthd) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(TRIM (lsp.int_rate_based_on_sanct_lim)) ||'|'|| 
to_char(TRIM (lam.int_rate_based_on_sanct_lim)) ||'|'|| 
CASE WHEN TRIM (lsp.int_rate_based_on_sanct_lim) = TRIM (lam.int_rate_based_on_sanct_lim) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(TRIM(lsp.pi_based_on_outstanding)) ||'|'||
to_char(TRIM(lam.pi_based_on_outstanding)) ||'|'|| 
to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY') else ' ' end,11,' '))||'|'||
TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')||'|'||  
case when (to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY') else ' ' end,11,' ')))=(TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
to_char(substr(oper.oper_leg_acc,1,4))||'|'||
to_char(substr(oper.oper_leg_acc,5,6))||'|'||
to_char(substr(oper.oper_leg_acc,11,3))||'|'||
to_char(oper.currency) ||'|'||
to_char(oper.fin_acc_num)||'|'||
to_char(gam_oper.foracid)||'|'||
case when nvl(to_char(oper.fin_acc_num),' ') = nvl(to_char(gam_oper.foracid),' ') then 'TRUE' else 'FALSE' end ||'|'||
to_char(rpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
     --else 0 end
     ,3,' '))||'|'||
to_char(lam.rep_perd_mths) ||'|'|| 
case when (trim(to_char(rpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
     --else 0 end
     ,3,' '))))=trim((to_char(lam.rep_perd_mths))) then 'TRUE' else 'FALSE' end ||'|'||
to_char(lpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
          to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
--else 0 end
,3,' '))||'|'||
to_char(lam.rep_perd_days) ||'|'||
case when to_char( 
case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
          to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
) =to_char(lam.rep_perd_days) then 'TRUE' else 'FALSE' end||'|'||
TO_CHAR(SCC2R)||'|'||
TO_CHAR(GAC.PURPOSE_OF_ADVN)||'|'||
CASE WHEN nvl(trim(TO_CHAR(SCC2R)),' ') = nvl(TO_CHAR(GAC.PURPOSE_OF_ADVN),' ') THEN 'TRUE' ELSE 'FALSE' END||'|'||
 LDT.DMD_AMT1||'|'||
(ls.sp/c8pwd)||'|'||
case when to_number(nvl(LDT.DMD_AMT1,0)) = nvl(to_number(ls.sp/c8pwd),0) then 'TRUE' else 'FALSE' end||'|'||
gac.DPD_CNTr||'|'||
case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date('20170905','YYYYMMDD')) else 0 end||'|'||
case when nvl(to_number(case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date('20170905','YYYYMMDD')) else 0 end),0) = nvl(to_number(gac.DPD_CNTr),0) then 'TRUE' else 'FALSE' end||'|'||
to_char(SCACO)||'|'||
S5IFQD||'|'||
to_char(eit.INT_FREQ_TYPE_DR)||'|'||
to_char(map_freq.value)
from map_acc map_acc
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr) = map_acc.leg_acc_num
left join scpf on scab||scan||scas=V5ABD||v5AND||V5ASD
left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
LEFT JOIN (select sanct_lim,foracid,acid,acct_opn_date,ACCT_NAME,cif_id,sol_id,acct_crncy_code from tbaadm.gam where bank_id=get_param('BANK_ID'))gam ON gam.foracid = map_acc.fin_acc_num
INNER JOIN (select * from tbaadm.lam where bank_id=get_param('BANK_ID'))lam ON lam.acid = gam.acid
left join (select upfront_instlmnt_coll,schm_code,crncy_code,del_flg,pi_based_on_outstanding,int_rate_based_on_sanct_lim from tbaadm.lsp where bank_id=get_param('BANK_ID'))lsp on lsp.schm_code = map_acc.schm_code and map_acc.currency=lsp.crncy_code and lsp.del_flg <> 'Y' 
left join (select schm_code,del_flg,SCHM_DESC from tbaadm.gsp where bank_id=get_param('BANK_ID'))gsp on gsp.schm_code = map_acc.schm_code and gsp.del_flg <> 'Y' 
left join (select schm_code,del_flg from tbaadm.gss where bank_id=get_param('BANK_ID'))gss on gss.schm_code = map_acc.schm_code and gss.del_flg <> 'Y' 
LEFT JOIN (select itc1.* from tbaadm.itc itc1  inner join
(select entity_id,max(LCHG_TIME) LCHG_TIME from tbaadm.itc  group by entity_id)itc2 on itc1.entity_id=itc2.entity_id and itc1.LCHG_TIME=itc2.LCHG_TIME
where itc1.entity_id in (select acid from tbaadm.gam where schm_type='CLA' and bank_id='01'))itc ON itc.entity_id = gam.acid
LEFT JOIN (select lim_sanct_date,lim_exp_date,acid from tbaadm.lht where bank_id=get_param('BANK_ID'))lht ON lht.acid = gam.acid
LEFT JOIN (select DPD_CNTr,acid,PURPOSE_OF_ADVN from tbaadm.gac where bank_id=get_param('BANK_ID'))gac ON gac.acid = gam.acid
LEFT JOIN (select repricing_plan,acid from tbaadm.lrp where bank_id=get_param('BANK_ID'))lrp ON lrp.acid = gam.acid
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num
inner join ompf_cla ON OMPF_LEG_NUM=LEG_ACC_NUM
inner join obpf on obdlp=v5dlp
left join (select acid,sum(dmd_amt)dmd_amt1,min(dmd_date)dmd_date1 from tbaadm.ldt where bank_id=get_param('BANK_ID') group by  acid)ldt on ldt.acid=gam.acid
left join iompf on iompf.ombrnm||trim(iompf.omdlp)||trim(iompf.omdlr)=LEG_ACC_NUM
left join (select lsbrnm,lsdlp,lsdlr,sum(lsamtd - lsamtp) sum_overdue from lspf where lsmvt='P' and (LSAMTD - LSAMTP) <> 0 and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num
left join cla_operacc oper on oper.ompf_leg_num=MAP_ACC.leg_acc_num
left join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam_oper on gam_oper.acid=lam.OP_ACID
left join demand_count dmd_cnt on  dmd_cnt.lsbrnm||trim(dmd_cnt.lsdlp)||trim(dmd_cnt.lsdlr)=leg_acc_num
inner join c8pf on c8ccy = otccy
left join (select lsbrnm||lsdlp||lsdlr del_num,sum((abs(lsamtd)-abs(lsamtp))+lsup)sp,min(lsdte)dte from lspf where lspdte='9999999' and lsdte<=1170131 and ((abs(lsamtd)-abs(lsamtp))+lsup)<>0 group by lsbrnm||lsdlp||lsdlr)ls on ls.del_num =leg_acc_num
left join cla_account_finacle_int_rate1 c on trim(int_acc_num)=leg_acc_num
left join cla_acct_fin_int_rate_les121 d on trim(d.int_acc_num)=leg_acc_num
left join cla_acct_fin_int_rate_more121 e on trim(e.int_acc_num)=leg_acc_num
left join (select * from tbaadm.eit where bank_id=get_param('BANK_ID'))eit on gam.acid=eit.entity_id
left join map_freq on substr(trim(S5IFQD),1,1)=map_freq.code
left join custom_account_name c_name on c_name.fin_acc_num=map_acc.fin_acc_num  
where map_acc.schm_type='CLA' and  v5pf.v5tdt='L' and v5pf.v5bal<>'0'
union
select distinct
to_char(map_acc.EXTERNAL_ACC)||'|'||
to_char(map_acc.leg_branch_id) ||'|'||
to_char(map_acc.leg_scan) ||'|'||
to_char(map_acc.LEG_SCAS) ||'|'||
TO_CHAR(scccy) ||'|'||
to_char(gam.acct_crncy_code) ||'|'||
CASE WHEN TO_CHAR(scccy) = gam.acct_crncy_code THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(gam.sol_id) ||'|'||
to_char(gam.cif_id) ||'|'||
to_char(map_acc.leg_acc_num) ||'|'||
TO_CHAR(scab||scan||scas) ||'|'||
to_char(gam.foracid) ||'|'|| 
to_char(map_acc.leg_cust_type) ||'|'||
to_char(map_acc.leg_acct_type) ||'|'|| 
to_char(map_acc.schm_code) ||'|'||
to_char(gsp.SCHM_DESC)||'|'||
to_char(c_name.acct_name) ||'|'||
to_char(gam.ACCT_NAME) ||'|'||
to_char(nvl(nvl(nvl(a.DR_BASE_RATE,0)+a.DR_MARGIN_RATE+a.S5RATD,b.DR_BASE_RATE+b.DR_MARGIN_RATE+a.S5RATD),0)) ||'|'||
to_char(nvl(nvl(nvl(a.BASE_PCNT_DR,0)+a.DR_PREF_RATE+a.DR_NRML_INT_PCNT,nvl(b.BASE_PCNT_DR,0)+b.DR_PREF_RATE+b.DR_NRML_INT_PCNT),0))||'|'||
--a.BASE_PCNT_DR,a.DR_PREF_RATE,a.DR_NRML_INT_PCNT,b.BASE_PCNT_DR,b.DR_PREF_RATE,b.DR_NRML_INT_PCNT||'|'||
case when (to_char(nvl(nvl(nvl(a.DR_BASE_RATE,0)+a.DR_MARGIN_RATE+a.S5RATD,b.DR_BASE_RATE+b.DR_MARGIN_RATE+a.S5RATD),0))) = (to_char(nvl(nvl(nvl(a.BASE_PCNT_DR,0)+a.DR_PREF_RATE+a.DR_NRML_INT_PCNT,nvl(b.BASE_PCNT_DR,0)+b.DR_PREF_RATE+b.DR_NRML_INT_PCNT),0))) then 'TRUE' ELSE 'FALSE' End ||'|'||
to_char(nvl(a.DR_PREF_RATE,nvl(b.DR_PREF_RATE,0)))||'|'||
to_char(nvl(a.BASE_PCNT_DR,nvl(b.BASE_PCNT_DR,0)))||'|'||
to_char(TRIM (lrp.repricing_plan)) ||'|'|| 
to_char(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY')          
         else lpad(' ',8,' ')  end)  ||'|'||
TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY')||'|'||
case when  to_char(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY')
         else lpad(' ',8,' ')  end)  = TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY') then 'TRUE' else 'FALSE' end  ||'|'||
to_char(abs(to_number(scbal)/POWER(10,c8pf.C8CED))) ||'|'||
to_char(gam.sanct_lim) ||'|'||
CASE WHEN (abs(to_number(scbal)/POWER(10,c8pf.C8CED)))  = TRIM(gam.sanct_lim) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY')          
         else lpad(' ',8,' ')  end) ||'|'||
TO_CHAR (lht.lim_sanct_date,'DD-MM-YYYY') ||'|'||
case when trim(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY')          
         else lpad(' ',8,' ')  end)=trim(TO_CHAR(lht.lim_sanct_date,'DD-MM-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
to_char(case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(SCLED ),'YYYYMMDD'),'DD-MON-YYYY')          
         else lpad(' ',8,' ')  end) ||'|'||
TO_CHAR (lht.lim_exp_date,'DD-MON-YYYY') ||'|'||   
CASE WHEN (case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(SCLED ),'YYYYMMDD'),'DD-MON-YYYY')          
         else lpad(' ',8,' ')  end) = TO_CHAR (lht.lim_exp_date, 'DD-MON-YYYY') THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(TRIM (itc.int_tbl_code)) ||'|'||
to_char(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
     else 0 end)||'|'||
to_char(TRIM (lam.rep_perd_mths)) ||'|'||
case when (trim(to_char(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
     else 0 end)))=trim((to_char(lam.rep_perd_mths))) then 'TRUE' else 'FALSE' end ||'|'||
to_char(abs(to_number(scbal))/POWER(10,c8pf.C8CED))||'|'||
to_char(TRIM (lam.liab_as_on_xfer_eff_date))||'|'||
case when trim(to_char(abs(to_number(scbal))/POWER(10,c8pf.C8CED))) = trim(to_char( (lam.liab_as_on_xfer_eff_date))) then 'TRUE' else 'FALSE' end||'|'||
to_char(TRIM (lsp.upfront_instlmnt_coll)) ||'|'||
to_char(lpad(case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') <  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then abs(to_number(scbal)/POWER(10,c8pf.C8CED)) else 0 end,17,' '))||'|'||
to_char(TRIM(lam.sum_principal_dmd_amt))||'|'||
case when TRIM(to_char(lpad(case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') <  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then abs(to_number(scbal)/POWER(10,c8pf.C8CED)) else 0 end,17,' ')))=(to_char(TRIM(lam.sum_principal_dmd_amt))) then 'TRUE' else 'FALSE' END ||'|'||
to_char(rpad(case when oper_fin_num is not null then  'T' when op_num  is not null then 'T' else 'N' end,1,' ')) ||'|'|| 
to_char(TRIM (lam.dmd_satisfy_mthd)) ||'|'|| 
CASE WHEN (case when trim(oper_fin_num) is not null then  'E' else 'N' end) = TRIM(lam.dmd_satisfy_mthd) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(TRIM (lsp.int_rate_based_on_sanct_lim)) ||'|'|| 
to_char(TRIM (lam.int_rate_based_on_sanct_lim)) ||'|'|| 
CASE WHEN TRIM (lsp.int_rate_based_on_sanct_lim) = TRIM (lam.int_rate_based_on_sanct_lim) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(TRIM(lsp.pi_based_on_outstanding)) ||'|'||
to_char(TRIM(lam.pi_based_on_outstanding)) ||'|'|| 
to_char(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY')          
         else lpad(' ',8,' ')  end)||'|'||
TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')||'|'||  
case when (to_char(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY')          
         else lpad(' ',8,' ')  end))=(TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
to_char(substr(oper_fin_num,1,4))||'|'||
to_char(substr(oper_fin_num,5,6))||'|'||
to_char(substr(oper_fin_num,11,3))||'|'||
to_char(oper.oper_currency) ||'|'||
to_char(oper_fin_num)||'|'||
to_char(gam_oper.foracid)||'|'||
case when nvl(to_char(oper_fin_num),' ') = nvl(to_char(gam_oper.foracid),' ') then 'TRUE' else 'FALSE' end ||'|'||
    to_char(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
     else 0 end)||'|'||
to_char(lam.rep_perd_mths) ||'|'|| 
case when (trim(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
     else 0 end))=trim((to_char(lam.rep_perd_mths))) then 'TRUE' else 'FALSE' end ||'|'||
to_char(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then 
          to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1 ))) 
     else to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD') ))) end
else 0 end)||'|'||
to_char(lam.rep_perd_days) ||'|'||
case when to_char(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then 
          to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1 ))) 
     else to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD') ))) end
else 0 end) =to_char(lam.rep_perd_days) then 'TRUE' else 'FALSE' end||'|'||
TO_CHAR(SCC2R)||'|'||
TO_CHAR(GAC.PURPOSE_OF_ADVN)||'|'||
CASE WHEN nvl(trim(TO_CHAR(SCC2R)),' ') = nvl(TO_CHAR(GAC.PURPOSE_OF_ADVN),' ') THEN 'TRUE' ELSE 'FALSE' END||'|'||
 LDT.DMD_AMT1||'|'||
(ls.sp/c8pwd)||'|'||
case when to_number(nvl(LDT.DMD_AMT1,0)) = nvl(to_number(ls.sp/c8pwd),0) then 'TRUE' else 'FALSE' end||'|'||
gac.DPD_CNTr||'|'||
case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date('20170206','YYYYMMDD')) else 0 end||'|'||
case when nvl(to_number(case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date('20170206','YYYYMMDD')) else 0 end),0) = nvl(to_number(gac.DPD_CNTr),0) then 'TRUE' else 'FALSE' end||'|'||
TO_char(scaco)||'|'||
S5IFQD||'|'||
to_char(eit.INT_FREQ_TYPE_DR)||'|'||
to_char(map_freq.value)
from map_acc map_acc 
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
left join (select a.fin_acc_num main_num,b.fin_acc_num op_num,b.currency op_ccy,b.fin_sol_id op_sol from ubpf 
inner join map_acc a on ubab||uban||ubas =a.leg_branch_id||a.leg_Scan||a.leg_Scas
inner join map_acc b on ubnab||ubnan||ubnas =b.leg_branch_id||b.leg_Scan||b.leg_Scas
where a.schm_code='LAC')op on op.main_num=map_acc.fin_acc_num
left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
left join tbaadm.lsp lsp on lsp.schm_code = map_acc.schm_code and map_acc.currency=lsp.crncy_code and lsp.del_flg <> 'Y' and lsp.bank_id=get_param('BANK_ID')
left join tbaadm.gsp gsp on gsp.schm_code = map_acc.schm_code and gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID')
left join tbaadm.gss gss on gss.schm_code = map_acc.schm_code and gss.del_flg <> 'Y' and   gss.DEFAULT_FLG ='Y' and gss.bank_id=get_param('BANK_ID')
LEFT JOIN (select sanct_lim,foracid,acid,acct_opn_date,ACCT_NAME,cif_id,sol_id,acct_crncy_code from tbaadm.gam where bank_id=get_param('BANK_ID'))gam ON gam.foracid = map_acc.fin_acc_num
INNER JOIN (select * from tbaadm.lam where bank_id=get_param('BANK_ID'))lam ON lam.acid = gam.acid
LEFT JOIN (select itc1.* from tbaadm.itc itc1 
 inner join
(select entity_id,max(LCHG_TIME) LCHG_TIME from tbaadm.itc  group by entity_id)itc2 on itc1.entity_id=itc2.entity_id and itc1.LCHG_TIME=itc2.LCHG_TIME
where itc1.entity_id in (select acid from tbaadm.gam where schm_type='CLA' and bank_id='01'))itc ON itc.entity_id = gam.acid
LEFT JOIN (select * from tbaadm.lht where bank_id=get_param('BANK_ID'))lht ON lht.acid = gam.acid
left join (select distinct trim(LAC_ACC_NO) LAC_ACC_NO,map_acc.fin_acc_num,trim(BILLING_ACCOUNT) BILLING_ACCOUNT,oper.fin_acc_num oper_fin_num,oper.fin_sol_id oper_fin_sol,oper.currency oper_currency from map_acc 
inner join lac_operative_account a on lac_acc_no=fin_acc_num inner  join map_acc oper on billing_account=oper.fin_acc_num where map_acc.schm_code in ('LAC','CLM')) oper on oper.fin_acc_num=map_acc.fin_acc_num
--left join (select distinct trim(LAC_ACC_NO) LAC_ACC_NO,map_acc.fin_acc_num,trim(BILLING_ACCOUNT) BILLING_ACCOUNT,oper.fin_acc_num oper_fin_num,oper.fin_sol_id oper_fin_sol,oper.currency oper_currency from map_acc 
--inner join lac_operative_account a on lac_acc_no=fin_acc_num inner  join map_acc oper on billing_account=oper.fin_acc_num where map_acc.schm_code in ('LAC','CLM')) oper on oper.fin_acc_num=map_acc.fin_acc_num
LEFT JOIN (select * from tbaadm.gac where bank_id=get_param('BANK_ID'))gac ON gac.acid = gam.acid
LEFT JOIN (select * from tbaadm.lrp where bank_id=get_param('BANK_ID'))lrp ON lrp.acid = gam.acid
left join (select acid,sum(dmd_amt)dmd_amt1,min(dmd_date)dmd_date1 from tbaadm.ldt where bank_id=get_param('BANK_ID') group by  acid)ldt on ldt.acid=gam.acid
left join tbaadm.lsp on tbaadm.lsp.schm_code = map_acc.schm_code and map_acc.currency=lsp.crncy_code and lsp.del_flg <> 'Y' and lsp.bank_id=get_param('BANK_ID')
left join tbaadm.gsp on tbaadm.gsp.schm_code = map_acc.schm_code and gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID')
left join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam_oper on gam_oper.acid=lam.OP_ACID
left join tbaadm.gss on tbaadm.gss.schm_code = map_acc.schm_code and gss.del_flg <> 'Y' and   gss.DEFAULT_FLG ='Y' and gss.bank_id=get_param('BANK_ID')
left join (select lsbrnm,lsdlp,lsdlr,sum(lsamtd - lsamtp) sum_overdue from lspf where lsmvt='P' and (LSAMTD - LSAMTP) <> 0 and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num
left join (select lsbrnm||lsdlp||lsdlr del_num,sum((abs(lsamtd)-abs(lsamtp))+lsup)sp,min(lsdte)dte from lspf where lspdte='9999999' and lsdte<=1170131 and ((abs(lsamtd)-abs(lsamtp))+lsup)<>0 group by lsbrnm||lsdlp||lsdlr)ls on ls.del_num =leg_acc_num
left join cla_lac_fin_int_rate_more121 a on  a.s5ab||a.s5an||a.s5as=leg_branch_id||leg_scan||leg_scas
left join cla_lac_fin_int_rate_les121 b on  b.s5ab||b.s5an||b.s5as=leg_branch_id||leg_scan||leg_scas
inner join c8pf on c8ccy = currency
left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
left join gfpf gf on trim(gf.gfclc)=trim(map_cif.gfclc) and  trim(gf.gfcus)=trim(map_cif.gfcus)  and gf.gfcpnc=MAP_CIF.GFCPNC 
left join (select * from tbaadm.eit where bank_id=get_param('BANK_ID'))eit on gam.acid=eit.entity_id
left join map_freq on substr(trim(S5IFQD),1,1)=map_freq.code
left join custom_account_name c_name on c_name.fin_acc_num=map_acc.fin_acc_num
where map_acc.schm_type='CLA'  and map_acc.schm_code in ('LAC','CLM')
and scbal <> 0;
--Select    
--'LEG_BRCH_ID'||'|'||
--'LEG_CLIENT_NO'||'|'||
--'LEG_SUFFIX'||'|'||
--'LEG_CCY'||'|'||
--'FINACLE_CCY'||'|'||
--'CCY_MATCH'||'|'||
--'FINACLE_SOL_ID'||'|'||
--'FINACLE_CIF_ID'||'|'||
--'LEG_CONTRACT'||'|'||
--'LEG_DEAL_REF_NUMBER' ||'|'||
--'FINACLE_ACCT_NUM'||'|'||
--'LEG_CUST_TYPE'||'|'||
--'LEG_ACCT_TYPE'||'|'||
--'FINACLE_SCHEME_CODE'||'|'||
--'SCHEME_DESCRIPTION'||'|'||
--'LEGACY_CUST_NAME' ||'|'||
--'FINACLE_CUST_NAME' ||'|'||
--'LEGACY_NET_RATE'||'|'||
--'FINACLE_NET_RATE'||'|'||
--'NET_RATE_MATCH'||'|'||
--'FINACLE_DEBIT_PREF_PERCENT'||'|'||
--'BASE_DEBIT_PERCENT'||'|'||
--'FINACLE_REPRICING_PLAN'||'|'||
--'LEG_ACCT_OPN_DATE'||'|'||
--'FINACLE_ACCT_OPN_DATE'||'|'||
--'ACCT_OPN_DATE_MATCH'||'|'||
--'LEG_SANCTION_LIMIT'||'|'||
--'FINACLE_SANCTION_LIMIT'||'|'||
--'SANCTION_LIMIT_MATCH'||'|'||
--'LEG_LIMIT_SANCTION_DATE'||'|'||
--'FINACLE_LIMIT_SANCTION_DATE'||'|'||
--'LIMIT_SANCTION_DATE_MATCH'||'|'||
--'LEG_LIMIT_EXPIRY_DATE'||'|'||
--'FINACLE_LIMIT_EXPIRY_DATE'||'|'||
--'LIMIT_EXPIRY_DATE_MATCH'||'|'||
--'FINACLE_INT_TBL_CODE'||'|'||
--'LEG_REPY_PRD_IN_MONS'||'|'||
--'FINACLE_REPY_PRD_IN_MON'||'|'||
--'REPY_PRD_IN_MON_MATCH'||'|'||
--'LEG_LIAB_TRF_UPD_AMOUNT'||'|'||
--'FINACLE_LIAB_TRF_UPD_AMOUNT'||'|'||
--'LIAB_TRF_UPD_AMOUNT_MATCH'||'|'||
----'LEG_UPFRONT_INSTALLMENT_COLL'||'|'||
--'FINACLE_UPFRONT_INSTALLMENT_COLL'||'|'||
----'UPFRONT_INSTLMNT_COLL_MATCH'||'|'||
--'LEG_SUM_OF_THE_PRINC_DMD_AMT'||'|'||
--'FINACLE_SUM_OF_THE_PRN_DMD_AMT'||'|'||
--'SUM_OF_THE_PRN_DMD_AMT_MATCH'||'|'||
--'LEG_DMD_SATISFY_MTHD'||'|'||
--'FINACLE_DMD_SATISFY_MTHD'||'|'||
--'DMD_SATISFY_MTHD_MATCH'||'|'||
--'LEG_INT_RATE_ON_SANC_LMT'||'|'||
--'FINACLE_INT_RATE_ON_SANC_LMT'||'|'||
--'INT_RATE_ON_SANC_LMT_MATCH'||'|'||
--'LEG_PI_BASED_ON_OUTSTANDING'||'|'||
--'FIN_PI_BASED_ON_OUTSTANDING'||'|'||
--'LEG_REPAY_SCHEDULE_DATE'||'|'||
--'FINACLE_REPAY_SCHEDULE_DATE'||'|'||
--'REPAY_SCHEDULE_DATE_MATCH'||'|'||
--'LEG_OPERATIVE_BRANCH'||'|'||
--'LEG_OPERATIVE_CLIENT_NO'||'|'||
--'LEG_OPERATIVE_ORDINAL'||'|'||
--'LEG_OPERATIVE_CCY'||'|'||
--'LEG_OPERATIVE_ACC'||'|'||
--'FIN_OPERATIVE_ACC'||'|'||
--'OPERATIVE_ACC_MATCH'||'|'||
--'LEG_TENOR_IN_MONTHS'||'|'||
--'FINACLE_TENOR_IN_MONTHS'||'|'||
--'TENOR_IN_MONTHS_MATCH'||'|'||
--'LEG_TENOR_IN_DAYS'||'|'||
--'FINACLE_TENOR_IN_DAYS'||'|'||
--'TENOR_IN_DAYS_MATCH'||'|'||
--'LEG_PURPOSE_OF_LOAN'||'|'||
--'FIN_PURPOSE_OF_LOAN'||'|'||
--'PURPOSE_OF_LOAN_MATCH'||'|'||
--'FIN_DUE_AMT'||'|'||
--'LEG_DUE_AMT'||'|'||
--'DUE_AMT_MATCH'||'|'||
--'FIN_DUE_DAYS'||'|'||
--'FIN_DUE_DAYS'||'|'||
--'DUE_DAYS_MATCH'||'|'||
--'MANAGER'||'|'||
--'LEG_INT_FREQ'||'|'||
--'FIN_INT_FREQ'||'|'||
--'FREQ_DESC' 
--from dual
--union all
--select distinct
--to_char(map_acc.leg_branch_id) ||'|'||
--to_char(map_acc.leg_scan) ||'|'||
--to_char(map_acc.LEG_SCAS) ||'|'||
--TO_CHAR(otccy) ||'|'||
--to_char(gam.acct_crncy_code) ||'|'||
--CASE WHEN TO_CHAR(otccy) = gam.acct_crncy_code THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(gam.sol_id) ||'|'||
--to_char(gam.cif_id) ||'|'||
--to_char(map_acc.leg_acc_num) ||'|'||
--TO_CHAR(V5PF.V5DLR) ||'|'||
--to_char(gam.foracid) ||'|'|| 
--to_char(map_acc.leg_cust_type) ||'|'||
--to_char(map_acc.leg_acct_type) ||'|'|| 
--to_char(map_acc.schm_code) ||'|'||
--to_char(gsp.SCHM_DESC)||'|'||
--to_char(gam.ACCT_NAME) ||'|'||
--to_char(gam.ACCT_NAME) ||'|'||
--to_char(nvl(nvl(c.ACC_PREF_RATE,nvl(e.ACC_PREF_RATE,d.ACC_PREF_RATE )),0))||'|'||
--to_char(nvl((c.BASE_PCNT_DR+c.ACTUAL_PREF_RATE),nvl(e.BASE_PCNT_DR+e.ACTUAL_PREF_RATE+e.DR_NRML_INT_PCNT,d.BASE_PCNT_DR+d.ACTUAL_PREF_RATE+d.DR_NRML_INT_PCNT )))||'|'||
--case when (to_number(nvl(c.ACC_PREF_RATE,nvl(e.ACC_PREF_RATE,d.ACC_PREF_RATE )))) = (to_number(nvl((c.BASE_PCNT_DR+c.ACTUAL_PREF_RATE),nvl(e.BASE_PCNT_DR+e.ACTUAL_PREF_RATE+e.DR_NRML_INT_PCNT,d.BASE_PCNT_DR+d.ACTUAL_PREF_RATE+d.DR_NRML_INT_PCNT )))) then 'TRUE' ELSE 'FALSE' End||'|'||
--to_char(nvl(c.ACTUAL_PREF_RATE,nvl(e.ACTUAL_PREF_RATE,d.ACTUAL_PREF_RATE )))||'|'||
--to_char(nvl((c.BASE_PCNT_DR),nvl((d.BASE_PCNT_DR),(e.BASE_PCNT_DR))))||'|'||
--to_char(TRIM (lrp.repricing_plan)) ||'|'|| 
--to_char(case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
--            else ' ' end)  ||'|'||
--TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY')||'|'||
--case when  to_char(case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
--            else ' ' end)  = TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY') then 'TRUE' else 'FALSE' end  ||'|'||
--to_char(case when obcrcl='Y' then lpad(abs(ompf_cla.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED)),17,' ')
--    else lpad(abs(to_number(ompf_cla.omnwp/POWER(10,c8pf.C8CED))),17,' ') end)||'|'||
--to_char(gam.sanct_lim) ||'|'||
--CASE WHEN (case when obcrcl='Y' then ompf_cla.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED)
--    else to_number(ompf_cla.omnwp/POWER(10,c8pf.C8CED)) end)  = TRIM(gam.sanct_lim) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
--else ' ' end,10,' ')) ||'|'||
--TO_CHAR (lht.lim_sanct_date,'DD-MM-YYYY') ||'|'||
--case when trim(to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
--else ' ' end,10,' ')))=trim(TO_CHAR(lht.lim_sanct_date,'DD-MM-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(rpad(case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MON-YYYY')
--     else '' end,11,' ')) ||'|'||
--TO_CHAR (lht.lim_exp_date,'DD-MON-YYYY') ||'|'||   
--CASE WHEN (rpad(case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MON-YYYY')
--     else '' end,11,' ')) = TO_CHAR (lht.lim_exp_date, 'DD-MON-YYYY') THEN 'TRUE' ELSE 'FALSE' END ||'|'||
----to_char(cla_account_finacle_int_rate.INT_TBL_CODE) ||'|'||
--to_char(TRIM (itc.int_tbl_code)) ||'|'||
--to_char(rpad(
--     --case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     --else 0 end
--     ,3,' '))||'|'||
--to_char(TRIM (lam.rep_perd_mths)) ||'|'||
--case when (trim(to_char(
--     --case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     --else 0 end
--     )))=trim((to_char(lam.rep_perd_mths))) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(rpad(to_number(otdla)/POWER(10,c8pf.C8CED),17,' '))||'|'||
--to_char(TRIM (lam.liab_as_on_xfer_eff_date))||'|'||
--case when trim(to_char(rpad(to_number(otdla)/POWER(10,c8pf.C8CED),17,' '))) = trim(to_char( (lam.liab_as_on_xfer_eff_date))) then 'TRUE' else 'FALSE' end||'|'||
--to_char(TRIM (lsp.upfront_instlmnt_coll)) ||'|'||
--to_char(lpad(abs(to_number(nvl(sum_overdue,0)))/POWER(10,c8pf.C8CED),17,' '))||'|'||
--to_char(TRIM(lam.sum_principal_dmd_amt))||'|'||
--case when TRIM(to_char(lpad(abs(to_number(nvl(sum_overdue,0)))/POWER(10,c8pf.C8CED),17,' ')))=(to_char(TRIM(lam.sum_principal_dmd_amt))) then 'TRUE' else 'FALSE' END ||'|'||
--to_char(TRIM (rpad(case when trim(oper.fin_acc_num) is not null then  'E' else 'N' end,1,' '))) ||'|'|| 
--to_char(TRIM (lam.dmd_satisfy_mthd)) ||'|'|| 
--CASE WHEN TRIM(case when trim(oper.fin_acc_num) is not null then  'E' else 'N' end) = TRIM(lam.dmd_satisfy_mthd) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(TRIM (lsp.int_rate_based_on_sanct_lim)) ||'|'|| 
--to_char(TRIM (lam.int_rate_based_on_sanct_lim)) ||'|'|| 
--CASE WHEN TRIM (lsp.int_rate_based_on_sanct_lim) = TRIM (lam.int_rate_based_on_sanct_lim) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(TRIM(lsp.pi_based_on_outstanding)) ||'|'||
--to_char(TRIM(lam.pi_based_on_outstanding)) ||'|'|| 
--to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY') else ' ' end,11,' '))||'|'||
--TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')||'|'||  
--case when (to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY') else ' ' end,11,' ')))=(TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(substr(oper.oper_leg_acc,1,4))||'|'||
--to_char(substr(oper.oper_leg_acc,5,6))||'|'||
--to_char(substr(oper.oper_leg_acc,11,3))||'|'||
--to_char(oper.currency) ||'|'||
--to_char(oper.fin_acc_num)||'|'||
--to_char(gam_oper.foracid)||'|'||
--case when nvl(to_char(oper.fin_acc_num),' ') = nvl(to_char(gam_oper.foracid),' ') then 'TRUE' else 'FALSE' end ||'|'||
--to_char(rpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     --else 0 end
--     ,3,' '))||'|'||
--to_char(lam.rep_perd_mths) ||'|'|| 
--case when (trim(to_char(rpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     --else 0 end
--     ,3,' '))))=trim((to_char(lam.rep_perd_mths))) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(lpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
--          to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
--     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
----else 0 end
--,3,' '))||'|'||
--to_char(lam.rep_perd_days) ||'|'||
--case when to_char( 
--case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
--          to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
--     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
--) =to_char(lam.rep_perd_days) then 'TRUE' else 'FALSE' end||'|'||
--TO_CHAR(SCC2R)||'|'||
--TO_CHAR(GAC.PURPOSE_OF_ADVN)||'|'||
--CASE WHEN nvl(trim(TO_CHAR(SCC2R)),' ') = nvl(TO_CHAR(GAC.PURPOSE_OF_ADVN),' ') THEN 'TRUE' ELSE 'FALSE' END||'|'||
-- LDT.DMD_AMT1||'|'||
--(ls.sp/c8pwd)||'|'||
--case when to_number(nvl(LDT.DMD_AMT1,0)) = nvl(to_number(ls.sp/c8pwd),0) then 'TRUE' else 'FALSE' end||'|'||
--gac.DPD_CNTr||'|'||
--case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date('20170206','YYYYMMDD')) else 0 end||'|'||
--case when nvl(to_number(case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date('20170206','YYYYMMDD')) else 0 end),0) = nvl(to_number(gac.DPD_CNTr),0) then 'TRUE' else 'FALSE' end||'|'||
--to_char(SCACO)||'|'||
--S5IFQD||'|'||
--to_char(eit.INT_FREQ_TYPE_DR)||'|'||
--to_char(map_freq.value)
--from map_acc map_acc
--inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr) = map_acc.leg_acc_num
--left join scpf on scab||scan||scas=V5ABD||v5AND||V5ASD
--left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
--LEFT JOIN (select sanct_lim,foracid,acid,acct_opn_date,ACCT_NAME,cif_id,sol_id,acct_crncy_code from tbaadm.gam where bank_id=get_param('BANK_ID'))gam ON gam.foracid = map_acc.fin_acc_num
--INNER JOIN (select * from tbaadm.lam where bank_id=get_param('BANK_ID'))lam ON lam.acid = gam.acid
--left join (select upfront_instlmnt_coll,schm_code,crncy_code,del_flg,pi_based_on_outstanding,int_rate_based_on_sanct_lim from tbaadm.lsp where bank_id=get_param('BANK_ID'))lsp on lsp.schm_code = map_acc.schm_code and map_acc.currency=lsp.crncy_code and lsp.del_flg <> 'Y' 
--left join (select schm_code,del_flg,SCHM_DESC from tbaadm.gsp where bank_id=get_param('BANK_ID'))gsp on gsp.schm_code = map_acc.schm_code and gsp.del_flg <> 'Y' 
--left join (select schm_code,del_flg from tbaadm.gss where bank_id=get_param('BANK_ID'))gss on gss.schm_code = map_acc.schm_code and gss.del_flg <> 'Y' 
--LEFT JOIN (select itc1.* from tbaadm.itc itc1  inner join
--(select entity_id,max(LCHG_TIME) LCHG_TIME from tbaadm.itc  group by entity_id)itc2 on itc1.entity_id=itc2.entity_id and itc1.LCHG_TIME=itc2.LCHG_TIME
--where itc1.entity_id in (select acid from tbaadm.gam where schm_type='CLA' and bank_id='01'))itc ON itc.entity_id = gam.acid
--LEFT JOIN (select lim_sanct_date,lim_exp_date,acid from tbaadm.lht where bank_id=get_param('BANK_ID'))lht ON lht.acid = gam.acid
--LEFT JOIN (select DPD_CNTr,acid,PURPOSE_OF_ADVN from tbaadm.gac where bank_id=get_param('BANK_ID'))gac ON gac.acid = gam.acid
--LEFT JOIN (select repricing_plan,acid from tbaadm.lrp where bank_id=get_param('BANK_ID'))lrp ON lrp.acid = gam.acid
--inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num
--inner join ompf_cla ON OMPF_LEG_NUM=LEG_ACC_NUM
--inner join obpf on obdlp=v5dlp
--left join (select acid,sum(dmd_amt)dmd_amt1,min(dmd_date)dmd_date1 from tbaadm.ldt where bank_id=get_param('BANK_ID') group by  acid)ldt on ldt.acid=gam.acid
--left join iompf on iompf.ombrnm||trim(iompf.omdlp)||trim(iompf.omdlr)=LEG_ACC_NUM
--left join (select lsbrnm,lsdlp,lsdlr,sum(lsamtd - lsamtp) sum_overdue from lspf where lsmvt='P' and (LSAMTD - LSAMTP) <> 0 and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num
--left join cla_operacc oper on  trim(oper.ompf_leg_num)=trim(MAP_ACC.leg_acc_num)
--left join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam_oper on gam_oper.acid=lam.OP_ACID
--left join demand_count dmd_cnt on  dmd_cnt.lsbrnm||trim(dmd_cnt.lsdlp)||trim(dmd_cnt.lsdlr)=leg_acc_num
--inner join c8pf on c8ccy = otccy
--left join (select lsbrnm||lsdlp||lsdlr del_num,sum((abs(lsamtd)-abs(lsamtp))+lsup)sp,min(lsdte)dte from lspf where lspdte='9999999' and lsdte<=1170131 and ((abs(lsamtd)-abs(lsamtp))+lsup)<>0 group by lsbrnm||lsdlp||lsdlr)ls on ls.del_num =leg_acc_num
--left join cla_account_finacle_int_rate c on trim(int_acc_num)=leg_acc_num
--left join cla_acct_fin_int_rate_les12 d on trim(d.int_acc_num)=leg_acc_num
--left join cla_acct_fin_int_rate_more12 e on trim(e.int_acc_num)=leg_acc_num
--left join (select * from tbaadm.eit where bank_id=get_param('BANK_ID'))eit on gam.acid=eit.entity_id
--left join map_freq on substr(trim(S5IFQD),1,1)=map_freq.code
--where map_acc.schm_type='CLA' and  v5pf.v5tdt='L' and v5pf.v5bal<>'0'
--union all
--select distinct
--to_char(map_acc.leg_branch_id) ||'|'||
--to_char(map_acc.leg_scan) ||'|'||
--to_char(map_acc.LEG_SCAS) ||'|'||
--TO_CHAR(scccy) ||'|'||
--to_char(gam.acct_crncy_code) ||'|'||
--CASE WHEN TO_CHAR(scccy) = gam.acct_crncy_code THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(gam.sol_id) ||'|'||
--to_char(gam.cif_id) ||'|'||
--to_char(map_acc.leg_acc_num) ||'|'||
--TO_CHAR(scab||scan||scas) ||'|'||
--to_char(gam.foracid) ||'|'|| 
--to_char(map_acc.leg_cust_type) ||'|'||
--to_char(map_acc.leg_acct_type) ||'|'|| 
--to_char(map_acc.schm_code) ||'|'||
--to_char(gsp.SCHM_DESC)||'|'||
--to_char(gam.ACCT_NAME) ||'|'||
--to_char(gam.ACCT_NAME) ||'|'||
--to_char(nvl(nvl(a.DR_BASE_RATE+a.DR_MARGIN_RATE,b.DR_BASE_RATE+b.DR_MARGIN_RATE),0))||'|'||
--to_char(nvl(nvl(a.BASE_PCNT_DR+a.DR_PREF_RATE+a.DR_NRML_INT_PCNT,b.BASE_PCNT_DR+b.DR_PREF_RATE+b.DR_NRML_INT_PCNT),0))||'|'||
--case when (to_char(nvl(nvl(a.DR_BASE_RATE+a.DR_MARGIN_RATE,b.DR_BASE_RATE+b.DR_MARGIN_RATE),0))) = (to_char(nvl(nvl(a.BASE_PCNT_DR+a.DR_PREF_RATE+a.DR_NRML_INT_PCNT,b.BASE_PCNT_DR+b.DR_PREF_RATE+b.DR_NRML_INT_PCNT),0))) then 'TRUE' ELSE 'FALSE' End||'|'||
--to_char(nvl(a.DR_PREF_RATE,b.DR_PREF_RATE))||'|'||
--to_char(nvl(a.BASE_PCNT_DR,b.BASE_PCNT_DR))||'|'||
--to_char(TRIM (lrp.repricing_plan)) ||'|'|| 
--to_char(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY')          
--         else lpad(' ',8,' ')  end)  ||'|'||
--TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY')||'|'||
--case when  to_char(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY')
--         else lpad(' ',8,' ')  end)  = TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY') then 'TRUE' else 'FALSE' end  ||'|'||
--to_char(abs(to_number(scbal)/POWER(10,c8pf.C8CED))) ||'|'||
--to_char(gam.sanct_lim) ||'|'||
--CASE WHEN (abs(to_number(scbal)/POWER(10,c8pf.C8CED)))  = TRIM(gam.sanct_lim) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY')          
--         else lpad(' ',8,' ')  end) ||'|'||
--TO_CHAR (lht.lim_sanct_date,'DD-MM-YYYY') ||'|'||
--case when trim(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY')          
--         else lpad(' ',8,' ')  end)=trim(TO_CHAR(lht.lim_sanct_date,'DD-MM-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(SCLED ),'YYYYMMDD'),'DD-MON-YYYY')          
--         else lpad(' ',8,' ')  end) ||'|'||
--TO_CHAR (lht.lim_exp_date,'DD-MON-YYYY') ||'|'||   
--CASE WHEN (case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(SCLED ),'YYYYMMDD'),'DD-MON-YYYY')          
--         else lpad(' ',8,' ')  end) = TO_CHAR (lht.lim_exp_date, 'DD-MON-YYYY') THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(TRIM (itc.int_tbl_code)) ||'|'||
--to_char(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
--     else 0 end)||'|'||
--to_char(TRIM (lam.rep_perd_mths)) ||'|'||
--case when (trim(to_char(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
--     else 0 end)))=trim((to_char(lam.rep_perd_mths))) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(abs(to_number(scbal))/POWER(10,c8pf.C8CED))||'|'||
--to_char(TRIM (lam.liab_as_on_xfer_eff_date))||'|'||
--case when trim(to_char(abs(to_number(scbal))/POWER(10,c8pf.C8CED))) = trim(to_char( (lam.liab_as_on_xfer_eff_date))) then 'TRUE' else 'FALSE' end||'|'||
--to_char(TRIM (lsp.upfront_instlmnt_coll)) ||'|'||
--to_char(lpad(case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') <  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then abs(to_number(scbal)/POWER(10,c8pf.C8CED)) else 0 end,17,' '))||'|'||
--to_char(TRIM(lam.sum_principal_dmd_amt))||'|'||
--case when TRIM(to_char(lpad(case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') <  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then abs(to_number(scbal)/POWER(10,c8pf.C8CED)) else 0 end,17,' ')))=(to_char(TRIM(lam.sum_principal_dmd_amt))) then 'TRUE' else 'FALSE' END ||'|'||
--to_char(rpad(case when trim(oper_fin_num) is not null then  'E' else 'N' end,1,' ')) ||'|'|| 
--to_char(TRIM (lam.dmd_satisfy_mthd)) ||'|'|| 
--CASE WHEN (case when trim(oper_fin_num) is not null then  'E' else 'N' end) = TRIM(lam.dmd_satisfy_mthd) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(TRIM (lsp.int_rate_based_on_sanct_lim)) ||'|'|| 
--to_char(TRIM (lam.int_rate_based_on_sanct_lim)) ||'|'|| 
--CASE WHEN TRIM (lsp.int_rate_based_on_sanct_lim) = TRIM (lam.int_rate_based_on_sanct_lim) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(TRIM(lsp.pi_based_on_outstanding)) ||'|'||
--to_char(TRIM(lam.pi_based_on_outstanding)) ||'|'|| 
--to_char(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY')          
--         else lpad(' ',8,' ')  end)||'|'||
--TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')||'|'||  
--case when (to_char(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY')          
--         else lpad(' ',8,' ')  end))=(TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(substr(oper_fin_num,1,4))||'|'||
--to_char(substr(oper_fin_num,5,6))||'|'||
--to_char(substr(oper_fin_num,11,3))||'|'||
--to_char(oper.oper_currency) ||'|'||
--to_char(oper_fin_num)||'|'||
--to_char(gam_oper.foracid)||'|'||
--case when nvl(to_char(oper_fin_num),' ') = nvl(to_char(gam_oper.foracid),' ') then 'TRUE' else 'FALSE' end ||'|'||
--    to_char(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
--     else 0 end)||'|'||
--to_char(lam.rep_perd_mths) ||'|'|| 
--case when (trim(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
--     else 0 end))=trim((to_char(lam.rep_perd_mths))) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
--case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then 
--          to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1 ))) 
--     else to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD') ))) end
--else 0 end)||'|'||
--to_char(lam.rep_perd_days) ||'|'||
--case when to_char(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
--case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then 
--          to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1 ))) 
--     else to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD') ))) end
--else 0 end) =to_char(lam.rep_perd_days) then 'TRUE' else 'FALSE' end||'|'||
--TO_CHAR(SCC2R)||'|'||
--TO_CHAR(GAC.PURPOSE_OF_ADVN)||'|'||
--CASE WHEN nvl(trim(TO_CHAR(SCC2R)),' ') = nvl(TO_CHAR(GAC.PURPOSE_OF_ADVN),' ') THEN 'TRUE' ELSE 'FALSE' END||'|'||
-- LDT.DMD_AMT1||'|'||
--(ls.sp/c8pwd)||'|'||
--case when to_number(nvl(LDT.DMD_AMT1,0)) = nvl(to_number(ls.sp/c8pwd),0) then 'TRUE' else 'FALSE' end||'|'||
--gac.DPD_CNTr||'|'||
--case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date('20170206','YYYYMMDD')) else 0 end||'|'||
--case when nvl(to_number(case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date('20170206','YYYYMMDD')) else 0 end),0) = nvl(to_number(gac.DPD_CNTr),0) then 'TRUE' else 'FALSE' end||'|'||
--TO_char(scaco)||'|'||
--S5IFQD||'|'||
--to_char(eit.INT_FREQ_TYPE_DR)||'|'||
--to_char(map_freq.value)
--from map_acc map_acc 
--inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
--left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
--left join tbaadm.lsp lsp on lsp.schm_code = map_acc.schm_code and map_acc.currency=lsp.crncy_code and lsp.del_flg <> 'Y' and lsp.bank_id=get_param('BANK_ID')
--left join tbaadm.gsp gsp on gsp.schm_code = map_acc.schm_code and gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID')
--left join tbaadm.gss gss on gss.schm_code = map_acc.schm_code and gss.del_flg <> 'Y' and   gss.DEFAULT_FLG ='Y' and gss.bank_id=get_param('BANK_ID')
--LEFT JOIN (select sanct_lim,foracid,acid,acct_opn_date,ACCT_NAME,cif_id,sol_id,acct_crncy_code from tbaadm.gam where bank_id=get_param('BANK_ID'))gam ON gam.foracid = map_acc.fin_acc_num
--INNER JOIN (select * from tbaadm.lam where bank_id=get_param('BANK_ID'))lam ON lam.acid = gam.acid
--LEFT JOIN (select itc1.* from tbaadm.itc itc1 
-- inner join
--(select entity_id,max(LCHG_TIME) LCHG_TIME from tbaadm.itc  group by entity_id)itc2 on itc1.entity_id=itc2.entity_id and itc1.LCHG_TIME=itc2.LCHG_TIME
--where itc1.entity_id in (select acid from tbaadm.gam where schm_type='CLA' and bank_id='01'))itc ON itc.entity_id = gam.acid
--LEFT JOIN (select * from tbaadm.lht where bank_id=get_param('BANK_ID'))lht ON lht.acid = gam.acid
--left join (select distinct trim(LAC_ACC_NO) LAC_ACC_NO,map_acc.fin_acc_num,trim(BILLING_ACCOUNT) BILLING_ACCOUNT,oper.fin_acc_num oper_fin_num,oper.fin_sol_id oper_fin_sol,oper.currency oper_currency from map_acc 
--inner join lac_operative_account a on lac_acc_no=fin_acc_num inner  join map_acc oper on billing_account=oper.fin_acc_num where map_acc.schm_code in ('LAC','CLM')) oper on oper.fin_acc_num=map_acc.fin_acc_num
----left join (select distinct trim(LAC_ACC_NO) LAC_ACC_NO,map_acc.fin_acc_num,trim(BILLING_ACCOUNT) BILLING_ACCOUNT,oper.fin_acc_num oper_fin_num,oper.fin_sol_id oper_fin_sol,oper.currency oper_currency from map_acc 
----inner join lac_operative_account a on lac_acc_no=fin_acc_num inner  join map_acc oper on billing_account=oper.fin_acc_num where map_acc.schm_code in ('LAC','CLM')) oper on oper.fin_acc_num=map_acc.fin_acc_num
--LEFT JOIN (select * from tbaadm.gac where bank_id=get_param('BANK_ID'))gac ON gac.acid = gam.acid
--LEFT JOIN (select * from tbaadm.lrp where bank_id=get_param('BANK_ID'))lrp ON lrp.acid = gam.acid
--left join (select acid,sum(dmd_amt)dmd_amt1,min(dmd_date)dmd_date1 from tbaadm.ldt where bank_id=get_param('BANK_ID') group by  acid)ldt on ldt.acid=gam.acid
--left join tbaadm.lsp on tbaadm.lsp.schm_code = map_acc.schm_code and map_acc.currency=lsp.crncy_code and lsp.del_flg <> 'Y' and lsp.bank_id=get_param('BANK_ID')
--left join tbaadm.gsp on tbaadm.gsp.schm_code = map_acc.schm_code and gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID')
--left join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam_oper on gam_oper.acid=lam.OP_ACID
--left join tbaadm.gss on tbaadm.gss.schm_code = map_acc.schm_code and gss.del_flg <> 'Y' and   gss.DEFAULT_FLG ='Y' and gss.bank_id=get_param('BANK_ID')
--left join (select lsbrnm,lsdlp,lsdlr,sum(lsamtd - lsamtp) sum_overdue from lspf where lsmvt='P' and (LSAMTD - LSAMTP) <> 0 and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num
--left join (select lsbrnm||lsdlp||lsdlr del_num,sum((abs(lsamtd)-abs(lsamtp))+lsup)sp,min(lsdte)dte from lspf where lspdte='9999999' and lsdte<=1170131 and ((abs(lsamtd)-abs(lsamtp))+lsup)<>0 group by lsbrnm||lsdlp||lsdlr)ls on ls.del_num =leg_acc_num
--left join cla_lac_fin_int_rate_more12 a on  a.s5ab||a.s5an||a.s5as=leg_branch_id||leg_scan||leg_scas
--left join cla_lac_fin_int_rate_les12 b on  b.s5ab||b.s5an||b.s5as=leg_branch_id||leg_scan||leg_scas
--inner join c8pf on c8ccy = currency
--left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
--left join gfpf gf on trim(gf.gfclc)=trim(map_cif.gfclc) and  trim(gf.gfcus)=trim(map_cif.gfcus)  and gf.gfcpnc=MAP_CIF.GFCPNC 
--left join (select * from tbaadm.eit where bank_id=get_param('BANK_ID'))eit on gam.acid=eit.entity_id
--left join map_freq on substr(trim(S5IFQD),1,1)=map_freq.code
--where map_acc.schm_type='CLA'  and map_acc.schm_code in ('LAC','CLM')
--and scbal <> 0;
----union all
----select  distinct
----to_char(a.leg_branch_id) ||'|'||
----to_char(a.leg_scan) ||'|'||
----to_char(a.LEG_SCAS) ||'|'||
----TO_CHAR(scccy) ||'|'||
----to_char(gam.acct_crncy_code) ||'|'||
----CASE WHEN TO_CHAR(scccy) = gam.acct_crncy_code THEN 'TRUE' ELSE 'FALSE' END ||'|'||
----to_char(gam.sol_id) ||'|'||
----to_char(gam.cif_id) ||'|'||
----to_char(a.leg_acc_num) ||'|'||
----TO_CHAR(scpf.scab||scpf.scan||scpf.scas) ||'|'||
----to_char(gam.foracid) ||'|'|| 
----to_char(a.leg_cust_type) ||'|'||
----to_char(a.leg_acct_type) ||'|'|| 
----to_char(a.schm_code) ||'|'||
----to_char(gsp.SCHM_DESC)||'|'||
----to_char(gam.ACCT_NAME) ||'|'||
----to_char(gam.ACCT_NAME) ||'|'||
----to_char(nvl((c.ACC_PREF_RATE),nvl((d.ACC_PREF_RATE),(e.ACC_PREF_RATE))))||'|'||
----to_char(nvl((c.ACC_PREF_RATE),nvl((d.ACC_PREF_RATE),(e.ACC_PREF_RATE))))||'|'||
------to_char(itc.MAX_INT_PCNT_DR+ID_DR_PREF_PCNT)||'|'||
----case when (to_number(to_char(nvl((c.ACC_PREF_RATE),nvl((d.ACC_PREF_RATE),(e.ACC_PREF_RATE)))))) = (to_number(nvl((c.ACC_PREF_RATE),nvl((d.ACC_PREF_RATE),(e.ACC_PREF_RATE))))) then 'TRUE' ELSE 'FALSE' End||'|'||
----to_char(nvl((c.ACTUAL_PREF_RATE),nvl((d.ACTUAL_PREF_RATE),(e.ACTUAL_PREF_RATE))))||'|'||
----to_char(nvl((c.BASE_PCNT_DR),nvl((d.BASE_PCNT_DR),(e.BASE_PCNT_DR))))||'|'||
----to_char(TRIM (lrp.repricing_plan)) ||'|'|| 
----to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
----    else ' ' end,11,' '))  ||'|'||
----TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY')||'|'||
----case when  to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
----    else ' ' end,11,' '))  = TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY') then 'TRUE' else 'FALSE' end  ||'|'||
----to_char(NVL(LCAMTU,0)+abs(to_number(omnwp/POWER(10,c8pf.C8CED)))) ||'|'||
----to_char(gam.sanct_lim) ||'|'||
----CASE WHEN (NVL(LCAMTU,0)+abs(to_number(omnwp/POWER(10,c8pf.C8CED))))  = TRIM(gam.sanct_lim) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
----to_char(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') 
----    else ' ' end) ||'|'||
----TO_CHAR (lht.lim_sanct_date,'DD-MM-YYYY') ||'|'||
----case when trim(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') 
----    else ' ' end)=trim(TO_CHAR(lht.lim_sanct_date,'DD-MM-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
----to_char(case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MON-YYYY')
----     else ' ' end) ||'|'||
----TO_CHAR (lht.lim_exp_date,'DD-MON-YYYY') ||'|'||   
----CASE WHEN (case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MON-YYYY')
----     else ' ' end) = TO_CHAR (lht.lim_exp_date, 'DD-MON-YYYY') THEN 'TRUE' ELSE 'FALSE' END ||'|'||
----to_char(TRIM (itc.int_tbl_code)) ||'|'||
----to_char(rpad(
----     --case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
----     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
----     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
----     --else 0 end
----     ,3,' '))||'|'||
----to_char(TRIM (lam.rep_perd_mths)) ||'|'||
----case when (trim(to_char(
----     --case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
----     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
----     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
----     --else 0 end
----     )))=trim((to_char(lam.rep_perd_mths))) then 'TRUE' else 'FALSE' end ||'|'||
----to_char(rpad(to_number(otdla)/POWER(10,c8pf.C8CED),17,' '))||'|'||
----to_char(TRIM (lam.liab_as_on_xfer_eff_date))||'|'||
----case when trim(to_char(rpad(to_number(otdla)/POWER(10,c8pf.C8CED),17,' '))) = trim(to_char( (lam.liab_as_on_xfer_eff_date))) then 'TRUE' else 'FALSE' end||'|'||
----to_char(TRIM (lsp.upfront_instlmnt_coll)) ||'|'||
----to_char('0')||'|'||
----to_char(TRIM(lam.sum_principal_dmd_amt))||'|'||
----case when TRIM(to_char('0'))=(to_char(TRIM(lam.sum_principal_dmd_amt))) then 'TRUE' else 'FALSE' END ||'|'||
----to_char(TRIM (rpad(case when oper_num is not null then  'E' else 'N' end,1,' '))) ||'|'|| 
----to_char(TRIM (lam.dmd_satisfy_mthd)) ||'|'|| 
----CASE WHEN TRIM(rpad(case when oper_num is not null then  'E' else 'N' end,1,' ')) = TRIM(lam.dmd_satisfy_mthd) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
----to_char(TRIM (lsp.int_rate_based_on_sanct_lim)) ||'|'|| 
----to_char(TRIM (lam.int_rate_based_on_sanct_lim)) ||'|'|| 
----CASE WHEN TRIM (lsp.int_rate_based_on_sanct_lim) = TRIM (lam.int_rate_based_on_sanct_lim) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
----to_char(TRIM(lsp.pi_based_on_outstanding)) ||'|'||
----to_char(TRIM(lam.pi_based_on_outstanding)) ||'|'|| 
----to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY') else ' ' end,11,' '))||'|'||
----TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')||'|'||  
----case when (to_char(rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY') else ' ' end,11,' ')))=(TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
----to_char(substr(case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end,1,4))||'|'||
----to_char(substr(case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end,5,6))||'|'||
----to_char(substr(case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end,11,3))||'|'||
----to_char(oper.oper_ccy) ||'|'||
----to_char(case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end)||'|'||
----to_char(gam_oper.foracid)||'|'||
----case when nvl(to_char(case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end),' ') = nvl(to_char(gam_oper.foracid),' ') then 'TRUE' else 'FALSE' end ||'|'||
----to_char(rpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
----     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
----     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
----     --else 0 end
----     ,3,' '))||'|'||
----to_char(lam.rep_perd_mths) ||'|'|| 
----case when (trim(to_char(rpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
----     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
----     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
----     --else 0 end
----     ,3,' '))))=trim((to_char(lam.rep_perd_mths))) then 'TRUE' else 'FALSE' end ||'|'||
----to_char(lpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
----case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
----          to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
----     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
------else 0 end
----,3,' '))||'|'||
----to_char(lam.rep_perd_days) ||'|'||
----case when to_char( 
----case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
----          to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
----     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
----) =to_char(lam.rep_perd_days) then 'TRUE' else 'FALSE' end||'|'||
----TO_CHAR(SCC2R)||'|'||
----TO_CHAR(GAC.PURPOSE_OF_ADVN)||'|'||
----CASE WHEN nvl(trim(TO_CHAR(SCC2R)),' ') = nvl(TO_CHAR(GAC.PURPOSE_OF_ADVN),' ') THEN 'TRUE' ELSE 'FALSE' END||'|'||
---- LDT.DMD_AMT1||'|'||
----(to_char('0'))||'|'||
----case when to_number(nvl(LDT.DMD_AMT1,0)) = to_char('0') then 'TRUE' else 'FALSE' end||'|'||
----gac.DPD_CNTr||'|'||
----'0'||'|'||
----case when '0' = nvl(to_number(gac.DPD_CNTr),0) then 'TRUE' else 'FALSE' end||'|'||
----to_char(SCACO)||'|'||
----S5IFQD||'|'||
----to_char(eit.INT_FREQ_TYPE_DR)||'|'||
----to_char(map_freq.value)
----from map_acc a
----LEFT JOIN (select sanct_lim,foracid,acid,acct_opn_date,ACCT_NAME,cif_id,sol_id,acct_crncy_code from tbaadm.gam where bank_id=get_param('BANK_ID'))gam ON gam.foracid = a.fin_acc_num
----LEFT JOIN (select * from tbaadm.gac where bank_id=get_param('BANK_ID'))gac ON gac.acid = gam.acid
----LEFT JOIN (select * from tbaadm.itc where bank_id=get_param('BANK_ID'))itc ON itc.entity_id = gam.acid
----LEFT JOIN (select * from tbaadm.lht where bank_id=get_param('BANK_ID'))lht ON lht.acid = gam.acid
----LEFT JOIN (select * from tbaadm.lrp where bank_id=get_param('BANK_ID'))lrp ON lrp.acid = gam.acid
----INNER JOIN (select * from tbaadm.lam where bank_id=get_param('BANK_ID'))lam ON lam.acid = gam.acid
----left join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam_oper on gam_oper.acid=lam.OP_ACID  
----left join (select acid,sum(dmd_amt)dmd_amt1,min(dmd_date)dmd_date1 from tbaadm.ldt where bank_id=get_param('BANK_ID') group by  acid)ldt on ldt.acid=gam.acid
----inner join cla_ld_acct_details b on b.fin_acc_num=a.fin_acc_num
----left join cla_ld_acct_fin_int_rate c on  c.fin_acc_num=a.fin_acc_num
----left join cla_ld_acct_fin_int_rate_les12 d on  d.fin_acc_num=a.fin_acc_num
----left join cla_ld_acct_fin_int_rate_mor12 e on  e.fin_acc_num=a.fin_acc_num
----left join (select * from tbaadm.lsp where lsp.del_flg <> 'Y' and lsp.bank_id=get_param('BANK_ID'))lsp on lsp.schm_code = a.schm_code and a.currency=lsp.crncy_code 
----left join (select * from tbaadm.gsp where gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID'))gsp on gsp.schm_code = a.schm_code  
----left join (select * from tbaadm.gss where gss.del_flg <> 'Y' and gss.DEFAULT_FLG ='Y' and gss.bank_id=get_param('BANK_ID'))gss on gss.schm_code = a.schm_code  
----left join (select * from map_cif where del_flg<>'Y' and is_joint <> 'Y') map_cif on map_cif.FIN_CIF_ID=a.FIN_CIF_ID
----left join gfpf gf on trim(gf.gfclc)=trim(map_cif.gfclc) and  trim(gf.gfcus)=trim(map_cif.gfcus)  and gf.gfcpnc=MAP_CIF.GFCPNC and trim(GFC2R) is not null
----inner join c8pf on c8ccy = currency
----left join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
----left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
----left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
----left join (select a.fin_acc_num,oper_num,oper.fin_sol_id oper_sol_id,oper.currency oper_ccy from (
----select distinct  c.fin_acc_num ,max(b.fin_acc_num) oper_num from map_acc c
----inner join ld_deal_int_wise a on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and c.leg_acc_num=to_char(serial_deal)
----inner join ompf a on ombrnm||trim(omdlp)||trim(omdlr)=a.leg_acc_num
----inner join map_acc b on  b.leg_branch_id||b.leg_scan||b.leg_scas=omabf||trim(omanf)||trim(omasf)
----where --c.schm_code='LD' and --commented on 14-06-2017 for CLA changes
----b.schm_type in ('SBA','CAA','ODA') group by c.fin_acc_num)a inner join map_acc oper on oper.fin_acc_num=a.fin_acc_num)oper on oper.fin_acc_num=a.fin_acc_num
----left join repricing_plan_map f on f.schm_code=a.schm_code
----left join ompf_ld_cla1 g on g.fin_acc_num=a.fin_acc_num 
----left join owpf_ld_cla h on leg_acc=a.fin_acc_num
----LEFT JOIN (select fin_num,sum(lcamtu) lcamtu from (
----select distinct C.fin_acc_num FIN_NUM,(lcamtu/power(10,c8ced))lcamtu,lccmr from map_acc c
----inner join ld_deal_int_wise a on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and c.leg_acc_num=to_char(serial_deal)
----inner join ldpf on ldbrnm||trim(lddlp)||trim(lddlr)=a.leg_acc_num
----inner join lcpf on lccmr=ldcmr
----inner join C8PF ON C8CCY=CURRENCY)
----GROUP BY fin_num)PEND_COMMIT_AMT ON  PEND_COMMIT_AMT.FIN_NUM=A.FIN_ACC_NUM
----left join jgpf on jgbrnm||trim(jgdlp)||trim(jgdlr) = a.leg_acc_num
----left join (select * from tbaadm.eit where bank_id=get_param('BANK_ID'))eit on gam.acid=eit.entity_id
----left join map_freq on substr(trim(S5IFQD),1,1)=map_freq.code;
exit; 
