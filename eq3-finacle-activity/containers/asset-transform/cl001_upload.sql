
-- File Name           : cu1_upload.sql
-- File Created for    : Upload file for CU1
-- Created By          : Kumaresan.B
-- Client              : ABK
-- Created On          : 19-05-2016
-------------------------------------------------------------------
--------operative accounts-----------
drop table ompf_prm;
create table ompf_prm as
select ombrnm,omdlp,omdlr,min(omdte) omdte from ompf where ommvt = 'P' and ommvts in ('R','M','U') and omabf is not null 
group by ombrnm,omdlp,omdlr;
create index ompf_prm_idx on ompf_prm(ombrnm,omdlp,omdlr,omdte);
drop table ompf_id;
create table ompf_id as
select ombrnm,omdlp,omdlr,min(omdte) omdte from ompf where ommvt = 'I' and (trim(ommvts) is null or ommvts='D') and omabf is not null 
group by ombrnm,omdlp,omdlr;
create index ompf_id_idx on ompf_id(ombrnm,omdlp,omdlr,omdte);
drop table cla_proper;
create table cla_proper as (
select a.* from ompf a 
inner join map_acc on leg_acc_num=a.ombrnm||trim(a.omdlp)||trim(a.omdlr)
inner join ompf_prm c on c.ombrnm=a.ombrnm and c.omdlp=a.omdlp and c.omdlr =a.omdlr and c.omdte = a.omdte 
where a.ommvt = 'P' and a.ommvts in ('R','M','U') and schm_type='CLA');
create index cla_proper_idx on cla_proper(omabf,omanf,omasf);  
drop table cla_ioper;
create table cla_ioper as (
select a.* from ompf a 
inner join map_acc on leg_acc_num=a.ombrnm||trim(a.omdlp)||trim(a.omdlr)
inner join ompf_id c on c.ombrnm=a.ombrnm and c.omdlp=a.omdlp and c.omdlr =a.omdlr and c.omdte = a.omdte 
where a.ommvt = 'I' and (trim(a.ommvts) is null or ommvts='D' ) and schm_type='CLA');
create index cla_ioper_idx on cla_ioper(omabf,omanf,omasf);  
drop table cla_operacc;
create table cla_operacc as (
select distinct a.*,fin_acc_num,fin_sol_id,currency from (
select distinct a.ombrnm||trim(a.omdlp)||trim(a.omdlr) ompf_leg_num,a.omabf||trim(a.omanf)||trim(a.omasf) oper_leg_acc from cla_proper a
union all
select distinct a.ombrnm||trim(a.omdlp)||trim(a.omdlr) ompf_leg_num,a.omabf||trim(a.omanf)||trim(a.omasf) oper_leg_acc from  cla_ioper a  
--inner join cla_ioper b on b.ombrnm=a.ombrnm and b.omdlp=a.omdlp and b.omdlr =a.omdlr 
--where a.omabf=b.omabf and a.omanf=b.omanf  and a.omasf = b.omasf
)a
inner join map_acc on  leg_branch_id||leg_scan||leg_scas=oper_leg_acc
where schm_type in ('SBA','CAA','ODA'));
create index cla_oper_idx on cla_operacc(ompf_leg_num);
------------------demand counter----------------
drop table cla_demand_count;
create table cla_demand_count as (    
    select lsbrnm,lsdlp,lsdlr,min(lsdte) lsdte from lspf
    inner join map_acc on leg_acc_num=lsbrnm||trim(lsdlp)||trim(lsdlr)
    where (LSAMTD - LSAMTP) <> 0  and lsdte <= get_param('EODCYYMMDD') 
    and schm_type ='CLA'  group by lsbrnm,lsdlp,lsdlr);
create index cla_dmd_cnt_idx on cla_demand_count(lsbrnm,lsdlp,lsdlr,lsbrnm||trim(lsdlp)||trim(lsdlr));
------------------------Interest table code----------------------
drop table cla_int_tbl;
create table cla_int_tbl as
  SELECT leg_acc_num int_acc_num, v5ccy, schm_code, v5brr, d4brar BASE_EQ_RATE, v5drr,d5drar DIFF_EQ_RATE, v5rtm,v5spr,v5rat, 
    CASE WHEN v5rat <> 0 THEN 'ZEROC' 
         else convert_codes('INT_TBL_CODE_CLA',trim(v5brr)) END INT_TBL_CODE,
    CASE 
    WHEN convert_codes('INT_TBL_CODE_CLA',trim(v5brr)) <> 'ZEROC' THEN v5rtm +nvl(d5drar,0)
    WHEN convert_codes('INT_TBL_CODE_CLA',trim(v5brr)) = 'ZEROC' and (trim(v5brr) is not null or v5rtm <> 0 )THEN nvl(d4brar,0) + v5rtm +nvl(d5drar,0)
         ELSE to_number(v5rat)
         END ACC_PREF_RATE,
case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end acct_open_date         
  FROM map_acc 
  inner join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr) = leg_acc_num
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num
  LEFT JOIN d4pf ON trim(v5brr) = d4brr and d4dte = 9999999 
  LEFT JOIN d5pf ON trim(v5drr) = d5drr and d5dte = 9999999
  left join map_codes on leg_code=trim(v5brr) 
  WHERE schm_type = 'CLA';
create index cla_int_tbl_idx on cla_int_tbl(int_acc_num);
create index cla_int_tbl_idx1 on cla_int_tbl(acct_open_date);
drop table cla_account_finacle_int_rate;
create table cla_account_finacle_int_rate
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
create index int_tbl_idx_2 on cla_account_finacle_int_rate(int_acc_num);
--Interest table base on the tenore less than 12 months---
drop table cla_acct_fin_int_rate_les12;
create table cla_acct_fin_int_rate_les12 as
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
create index int_tbl_idx_3 on cla_acct_fin_int_rate_les12(int_acc_num);     
--Interest table base on the tenore more than 12 months---
drop table cla_acct_fin_int_rate_more12;
/*
create table cla_acct_fin_int_rate_more12 as
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
and int_slab_dr_cr_flg = 'D' and LOAN_TENOR_MTHS>12
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
where del_flg = 'N' and bank_id = get_param('BANK_ID') and LOAN_TENOR_MTHS>12 )d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(INT_ACC_NUM)
where trim(csp.int_tbl_code)='CORTE' 
and (case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
     else 0 end)>12;
*/
----START OF TEMP FIX PRASHANT ABOVE commented query is the original. this query removes tenor condition
create table cla_acct_fin_int_rate_more12 as
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
where trim(csp.int_tbl_code)='CORTE' 
/*and (case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
     else 0 end)>12*/
;
--END OF TEMP FIX PRASHANT
create index int_tbl_idx_4 on cla_acct_fin_int_rate_more12(int_acc_num);
--Interest table base on the tenore more than 12 months for LAC scheme code---
drop table cla_lac_fin_int_rate_more12;
--START COMMENTED ORIGINAL CODE PRASHANT
/*
create table cla_lac_fin_int_rate_more12 as
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
and int_slab_dr_cr_flg = 'D' and LOAN_TENOR_MTHS>12
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
where del_flg = 'N' and bank_id = get_param('BANK_ID') and LOAN_TENOR_MTHS>12 
 )d  on d.int_tbl_code =csp.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
 inner join scpf on scab=s5ab and scan=s5an and scas=s5as
where csp.INT_TBL_CODE='CORTE' 
and (case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
     else 0 end)>12;
	*/ 
--END OF COMMENT PRASHANT
--START of change to remove less than 12 tenor condition Prashant
create table cla_lac_fin_int_rate_more12 as
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
where csp.INT_TBL_CODE='CORTE' 
/*and (case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
     else 0 end)>12 Prashant
*/
;
--end of Prashant change
create index cla_lac_idx on cla_lac_fin_int_rate_more12(s5ab||s5an||s5as);	 
--Interest table base on the tenore less than 12 months for LAC scheme code---	 
drop table cla_lac_fin_int_rate_les12;
create table cla_lac_fin_int_rate_les12 as
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
create index cla_lac_idx1 on cla_lac_fin_int_rate_les12(s5ab||s5an||s5as);
-----------------------------------------------------------------------------------------------
drop table iompf;
create table iompf as
select ombrnm,omdlp,omdlr,sum(omnwr) iomnwr   from ompf where OMMVT = 'I' and trim(ommvts) is null  group by ombrnm,omdlp,omdlr;
create index iompf_idx on iompf(ombrnm||trim(omdlp)||trim(omdlr));
drop table ompf_i_cla;
create table ompf_i_cla as
select * from ompf 
inner join map_acc on leg_acc_num=ombrnm||trim(omdlp)||trim(omdlr)
where ompf.ommvt='I'  and maP_acc.schm_code in ('BDT' ,'LDA');
create index ompf_i_cla_idx on ompf_i_cla(ombrnm||trim(omdlp)||trim(omdlr));
drop table ompf_cla;
create table ompf_cla as
select ombrnm||trim(omdlp)||trim(omdlr) ompf_leg_num,sum(omnwp) omnwp from ompf inner join map_acc on ombrnm||trim(omdlp)||trim(omdlr) =leg_acc_num where schm_type='CLA' and ommvt='P' and ommvts in ('C','O') group by ombrnm||trim(omdlp)||trim(omdlr);
create index ompf_cla_idx on ompf_cla(OMPF_LEG_NUM);
drop table owpf_note_cla;
create table owpf_note_cla as
select trim(owbrnm)||trim(owdlp)||trim(owdlr) leg_acc,OWSD1,OWSD2,OWSD3,OWSD4 from owpf 
where owmvt = 'P' and owmvts = 'C';
create index owpf_cla_idx on owpf_note_cla(leg_acc);
------------------------------------------------------------------------------------------------
truncate table Cl001_O_TABLE;
insert into Cl001_O_TABLE
select   distinct 
--acc_num NVARCHAR2(16),
rpad(map_acc.fin_acc_num,16,' '),
--Cust_Credit_Pref_Per NVARCHAR2(10),
lpad(' ',10,' '),
--Cust_Debit_Pref_Per NVARCHAR2(10),
lpad(' ',10,' '),
--Acct_ID_Credit_Pref_Per NVARCHAR2(10),
lpad(' ',10,' '),
--Acct_ID_Debit_Pref_Per NVARCHAR2(10),
--lpad(case when TO_number(ACC_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(ACC_PREF_RATE) else to_char(nvl(ACC_PREF_RATE,0)) end,10,' ') ,
--lpad(case when TO_number(ACTUAL_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(ACTUAL_PREF_RATE) else to_char(nvl(ACTUAL_PREF_RATE,0)) end,10,' ') ,
lpad(case 
 --when nvl(a.REPRICING_PLAN,'F')='F' and cla_int_tbl.int_acc_num is not null  then  to_char(cla_int_tbl.ACC_PREF_RATE)
 --when nvl(a.REPRICING_PLAN,'F')='F' and cla_int_tbl_les12.int_acc_num is not null  then  to_char(cla_int_tbl_les12.ACC_PREF_RATE)
 --when nvl(a.REPRICING_PLAN,'F')='F' and cla_int_tbl_more12.int_acc_num is not null  then  to_char(cla_int_tbl_more12.ACC_PREF_RATE)--changed on 25-05-2017 by Kumar
 when trim(cla_int_tbl.int_acc_num) is not null and 
 TO_number(cla_int_tbl.ACTUAL_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(cla_int_tbl.ACTUAL_PREF_RATE)  
 when trim(cla_int_tbl.int_acc_num) is not null and 
 TO_number(cla_int_tbl.ACTUAL_PREF_RATE)not  between 0.001 and 0.999 then to_char(nvl(cla_int_tbl.ACTUAL_PREF_RATE,0))
 when trim(cla_int_tbl_les12.int_acc_num) is not null and 
 TO_number(cla_int_tbl_les12.ACTUAL_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(cla_int_tbl_les12.ACTUAL_PREF_RATE)  
 when trim(cla_int_tbl_les12.int_acc_num) is not null and 
 TO_number(cla_int_tbl_les12.ACTUAL_PREF_RATE) not between 0.001 and 0.999 then to_char(nvl(cla_int_tbl_les12.ACTUAL_PREF_RATE,0))
 when trim(cla_int_tbl_more12.int_acc_num) is not null and 
 TO_number(cla_int_tbl_more12.ACTUAL_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(cla_int_tbl_more12.ACTUAL_PREF_RATE)  
 else to_char(nvl(cla_int_tbl_more12.ACTUAL_PREF_RATE,0)) 
 end 
 ,10,' '),
--Pegged_Flag NVARCHAR2(1),
rpad(GSP.PEG_INT_FOR_AC_FLG,1,' '),
--Peg_Freq_in_Months NVARCHAR2(4),
rpad(' ',4,' '),
--Peg_Freq_in_Days NVARCHAR2(3),
rpad(' ',3,' '),
--int_Route_Flag NVARCHAR2(1),
rpad(nvl(tbaadm.lsp.int_route_flg,' '),1,' '),---Based on discussion with sandeep and vijay --changed default value 'O' to scheme level flag on 15-07-2017
--rpad('O',1,' '),
--Acct_Currency_Code NVARCHAR2(3),
rpad(otccy,3,' '),
--Sol_ID NVARCHAR2(8),
rpad(map_acc.fin_sol_id,8,' '),
--GL_Sub_Head_Code NVARCHAR2(5),
--rpad(nvl(tbaadm.gss.gl_sub_head_code,' '),5,' '),
rpad(nvl(map_acc.gl_sub_headcode,' '),5,' '),
--Schm_Code NVARCHAR2(5),
rpad(map_acc.schm_code,5,' '),
--CIF_ID NVARCHAR2(32),
rpad(map_acc.fin_cif_id,32,' '),
--Acct_Open_Date NVARCHAR2(8),
rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD')
    else ' ' end,8,' '),  
--Sanction_Limit NVARCHAR2(17),
--case when obcrcl='Y' then lpad(abs(ompf_cla.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED)),17,' ') else lpad(abs(to_number(ompf_cla.omnwp/POWER(10,c8pf.C8CED))),17,' ') end,
--lpad(abs(to_number(ompf_cla.omnwp/POWER(10,c8pf.C8CED))),17,' '),
lpad(abs(to_number(otdla/POWER(10,c8pf.C8CED))),17,' '),------changes on 07-09-2017 based on vijay discussion in meeting original deal amount  changed to current outstanding deal amount
--Ledger_num NVARCHAR2(3),
rpad(' ',3,' '),
--   v_Sector_Code           CHAR(5)KTWORKS
    case when get_param('BANK_ID')='02'then rpad(convert_codes('SECTOR_CODE',trim(gf.GFC3R)),5,' ') 
      --else rpad(convert_codes('SECTOR_CODE',trim(gf.GFC2R)),5,' ') end,--changed on 07-03-2017 as per vijay confirmation
	  else rpad(convert_codes('SECTOR_CODE',trim(SCC2R)),5,' ') end,--changed on 17-08-2017 as per vijay discussion with Sandeep 
--   v_Sub_Sector_Code           CHAR(5)KTWORKS
    case when get_param('BANK_ID')='02' then rpad(nvl(trim(gf.GFC3R),'ZZZ'),5,' ')
          --else rpad(nvl(trim(gf.GFC2R),'ZZZ'),5,' ') end,--changed on 07-03-2017 as per vijay confirmation
		  else rpad(nvl(trim(SCC2R),'ZZZ'),5,' ') end,--changed on 17-08-2017 as per vijay discussion with Sandeep 
--Pur_of_Advance NVARCHAR2(5),
--rpad(nvl(SCC3R,'999'),5,' '),
    case when get_param('BANK_ID')='02' then rpad(nvl(trim(SCC3R),'999'),5,' ')
    else rpad(nvl(trim(SCC2R),'999'),5,' ') end,
--Nature_of_Advance NVARCHAR2(5),
rpad('999',5,' '),
--F_c_3 NVARCHAR2(5),
rpad(' ',5,' '),
--Sanction_ref_num NVARCHAR2(25),
rpad(' ',25,' '),
--Sanction_Limit_Date NVARCHAR2(8),
rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD') 
    else ' ' end,8,' '),  
--Sanction_Level_Code NVARCHAR2(5),
rpad('999',5,' '),
--Limit_Expiry_Date NVARCHAR2(8),
rpad(case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'YYYYMMDD')
     else ' ' end,8,' '),
--Sanction_Authority_Code NVARCHAR2(5),
rpad('999',5,' '),
--Loan_Paper_Date NVARCHAR2(8),
rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD') else ' ' end,8,' '),      
--Operative_Acct_ID NVARCHAR2(16),
rpad(case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end ,16,' '),
--Operative_Currency_Code NVARCHAR2(3),
rpad(case when oper.fin_acc_num is not  null then oper.currency else ' ' end ,3,' '),
--Operative_Sol_ID NVARCHAR2(8),
rpad(case when oper.fin_acc_num is not  null then oper.fin_sol_id else ' ' end ,8,' '),
--Demand_Satisfy_Method NVARCHAR2(1),
rpad(case when trim(oper.fin_acc_num) is not null then  'T' else 'N' end,1,' '),---'E' to 'T'  changed as per vijay mail dt 25-09-2017
--Lien_on_Operative_Acct_Flag NVARCHAR2(1),
rpad(case when oper.fin_acc_num is not null then LSP.lien_on_oper_Acct_flg else 'N' end,1,' '), 
--Demand_Satisfaction_Rate_Code NVARCHAR2(5),
rpad(' ',5,' '),
--int_table_code NVARCHAR2(5),
rpad( case 
--when nvl(a.REPRICING_PLAN,'F')='F' then  'ZEROC'--changed on 25-05-2017 by Kumar
when trim(cla_int_tbl.int_acc_num) is not null then 
nvl(cla_int_tbl.TBL_CODE,'ZEROC')
when trim(cla_int_tbl_les12.int_acc_num) is not null then
nvl(cla_int_tbl_les12.TBL_CODE,'ZEROC')
else nvl(cla_int_tbl_more12.TBL_CODE,'ZEROC') end ,5,' '),
--int_on_principal_Flag NVARCHAR2(1),
rpad(LSP.int_on_p_flg,1,' '),
--Penal_overdue_pr_demand_Flag NVARCHAR2(1),
rpad(LSP.pi_on_pdmd_ovdu_flg,1,' '),
--Pri_Dem_Od_end_month_Flag NVARCHAR2(1),
rpad(LSP.pdmd_ovdu_eom_flg,1,' '),
--int_On_int_Demand_Flag NVARCHAR2(1),
rpad(tbaadm.LSP.int_on_idmd_flg,1,' '),-----Based on discussion with sandeep and vijay --changed default value 'O' to scheme level flag on 15-07-2017
--rpad('N',1,' '),
--penal_overdue_int_demand_Flag NVARCHAR2(1),
rpad(LSP.pi_on_idmd_ovdu_flg,1,' '),
--int_Dem_Od_End_Month_Flag NVARCHAR2(1),
rpad(LSP.idmd_ovdu_eom_flg,1,' '),
--Transfer_Effective_Date NVARCHAR2(8),
rpad(to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),'YYYYMMDD'),8,' '),   
--Cumul_Normal_int_amount NVARCHAR2(17),
rpad(' ',17,' '),
--Cumul_penal_int_amount NVARCHAR2(17),
rpad(' ',17,' '),
--cumul_add_int_amount NVARCHAR2(17),
rpad(' ',17,' '),
--Liab_as_on_Transfer_Eff_date NVARCHAR2(17),
rpad(abs(to_number(otdla))/POWER(10,c8pf.C8CED),17,' '),
--Disb_in_Pres_Schedule NVARCHAR2(17),
--lpad(to_number(case when obcrcl='Y' and ompf_cla.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED) > 0 then ompf_cla.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED) when to_number(ompf_cla.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) > 0  then to_number(ompf_cla.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)
--  else 0 end),17,' '),
--lpad(to_number(case when to_number(ompf_cla.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) > 0  then to_number(ompf_cla.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)
--  else 0 end),17,' '),  ------commented on 07-09-2017 based on vijay discussion in meeting original deal amount  changed to current outstanding deal amount
rpad('0',17,' '),------added on 07-09-2017 based on vijay discussion in meeting original deal amount  changed to current outstanding deal amount
--Last_int_posted_date NVARCHAR2(8),
rpad( case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'YYYYMMDD')
               when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD') else ' ' end,8,' '),   
--Repayment_Schedule_Date NVARCHAR2(8),
rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD') else ' ' end,8,' '),      
--Repayment_Period_in_months NVARCHAR2(3),
rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
     else 0 end
     ,3,' '),                                                             
--Repayment_Period_in_Days NVARCHAR2(3),
lpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
          to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
else 0 end
,3,' '),
--Past_Due_Flag NVARCHAR2(1),
rpad('N',1,' '),
--Past_Due_date NVARCHAR2(8),
rpad(' ',8,' '),
--Normal_GL_subhead_Code NVARCHAR2(5),
rpad(' ',5,' '),
--Normal_int_Suspense_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Penal_int_Suspense_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Charge_Off_Flag NVARCHAR2(1),
rpad('N',1,' '),
--Charge_Off_date NVARCHAR2(8),
rpad(' ',8,' '),
--Charged_Off_Principal_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Charged_off_int_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Principal_rec NVARCHAR2(17),
rpad(' ',17,' '),
--int_rec NVARCHAR2(17),
rpad(' ',17,' '),
--Source_Dealer_Code NVARCHAR2(20),
rpad(' ',20,' '),
--Disburse_Dealer_Code NVARCHAR2(20),
rpad(' ',20,' '),
--Apply_late_fee_Flag NVARCHAR2(1),
rpad(lsp.apply_late_fee_flg,1,' '),
--Lt_Fee_GPeriod_Months NVARCHAR2(3),
rpad(LATEFEE_GRACE_PERD_MNTHS,3,' '),
--Lt_fee_gPeriod_days NVARCHAR2(3),
rpad(LATEFEE_GRACE_PERD_days,3,' '),
--Days_Past_Due_counter NVARCHAR2(5),
case when dmd_cnt.lsbrnm is not null and lsdte <> 0 and to_number(get_param('EODCYYMMDD'))-to_number(lsdte) >=0 then rpad(to_date(get_date_fm_btrv(get_param('EODCYYMMDD')),'YYYYMMDD')-to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),5,' ')
     else rpad('0',5,' ') end,
--Sum_pri_dem_amt NVARCHAR2(17),
lpad(abs(to_number(nvl(sum_overdue,0)))/POWER(10,c8pf.C8CED),17,' '),
--Payoff_Flag NVARCHAR2(1),
rpad('N',1,' '),
--Exclude_for_combined_st NVARCHAR2(1),
rpad(' ',1,' '),
--st_Cif_Id NVARCHAR2(32),
rpad(' ',32,' '),
--Transfer_Cycle_String NVARCHAR2(45),
rpad( '000000000000000000000000000000000000000000000',45,' '),
--Value_of_Asset NVARCHAR2(17),
rpad(' ',17,' '),
--Occ_code_of_the_cust NVARCHAR2(5),
rpad(convert_codes('SUNDRY_ANALYSIS_CODE',trim(SCSAC)),5,' '),
--Borrower_category_code NVARCHAR2(5),
rpad(' ',5,' '),
--Mode_of_Advance NVARCHAR2(5),
rpad(' ',5,' '),
--Type_of_Advance NVARCHAR2(5),
rpad(' ',5,' '),
--guarantee_coverage_Code NVARCHAR2(5),
rpad(' ',5,' '),
--Industry_Type NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_1 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_2 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_4 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_5 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_6 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_7 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_8 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_9 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_10 NVARCHAR2(5),
rpad(' ',5,' '),
--Acct_Location_Code NVARCHAR2(5),
rpad(' ',5,' '),
--Credit_File_ref_Id NVARCHAR2(15),
rpad(' ',15,' '),
--Last_Compound_Date NVARCHAR2(8),
--rpad(case when tbaadm.LSP.int_on_idmd_flg ='Y' then to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),'YYYYMMDD') else ' ' end ,8,' '),
rpad(' ',8,' '),
--Daily_Compound_int_Flag NVARCHAR2(1),
--rpad(tbaadm.LSP.int_on_idmd_flg,1,' '),
rpad(GSP.DAILY_COMP_INT_FLG,1,' '),
--EI_period_start_date NVARCHAR2(8),
rpad(case  --when obpf.obcrcl = 'Y' and v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'YYYYMMDD')
               when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD') else ' ' end,8,' '),
--EI_period_End_date NVARCHAR2(8),
rpad(case when otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt<>'9999999' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'YYYYMMDD') else ' ' end,8,' '),
--Charge_Route_flag NVARCHAR2(1),
rpad(LSP.chrg_route_flg,1,' '),
--Total_num_of_Deferments NVARCHAR2(2),
rpad(' ',2,' '),
--Def_in_curr_schedule NVARCHAR2(2),
rpad(' ',2,' '),
--Col_int_in_advance_flag NVARCHAR2(1),  AS PER NEW FORMAT NOT REQUIRED
--rpad(' ',1,' '),
--Res_acc NVARCHAR2(16),    AS PER NEW FORMAT NOT REQUIRED
--rpad(' ',16,' '),
--Draw_down_lvl_rate_flag NVARCHAR2(1),
rpad(' ',1,' '),
--EI_flag NVARCHAR2(1),
rpad(nvl(trim(LSP.ei_schm_flg),'N'),1,' '),
--Installment_date_extd NVARCHAR2(8),
rpad(' ',8,' '),
--Extended_overdue_Date NVARCHAR2(8),
rpad(' ',8,' '),
--Def_app_int_rate_flag NVARCHAR2(1),
rpad(' ',1,' '),
--Def_app_int_rate NVARCHAR2(10),
rpad(' ',10,' '),
--Deferred_int_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Last_prepayment_date NVARCHAR2(8),
rpad(' ',8,' '),
--rf_end_date NVARCHAR2(8),
rpad(' ',8,' '),
--rf_ref_num NVARCHAR2(25),
rpad(' ',25,' '),
--Charge_off_type NVARCHAR2(1),
rpad(' ',1,' '),
--Cry_reqd NVARCHAR2(1),
rpad(' ',1,' '),
--Cry_Currency NVARCHAR2(3),
rpad(' ',3,' '),
--Contract_date NVARCHAR2(8),
rpad(' ',8,' '),
--Crys_A_c NVARCHAR2(16),
rpad(' ',16,' '),
--acc_Status NVARCHAR2(1),
rpad(' ',1,' '),
--Comm_fee_methods NVARCHAR2(1),
rpad(' ',1,' '),
--Shift_installment_flag NVARCHAR2(1),
rpad(' ',1,' '),
--Parent_cif_id NVARCHAR2(32),
rpad(' ',32,' '),
--Peg_Review_Date NVARCHAR2(8),
rpad(' ',8,' '),
--rf_Ref_num1 NVARCHAR2(25),
rpad(' ',25,' '),
--Penal_int_based_on_Outstanding NVARCHAR2(1),
case when LSP.pi_on_pdmd_ovdu_flg = 'N' then ' ' else LSP.pi_based_on_outstanding end,
--Del_Reschedule_Method_Flag NVARCHAR2(1),
rpad(' ',1,' '),
--Probation_Period_in_Months NVARCHAR2(3),
rpad(' ',3,' '),
--Probation_Period_in_Days NVARCHAR2(3),
rpad(' ',3,' '),
--Total_num_of_Switch_Over NVARCHAR2(3),
rpad(' ',3,' '),
--Non_Starter_Flag NVARCHAR2(1),
rpad(' ',1,' '),
--Repricing_Plan NVARCHAR2(1),
rpad(nvl(a.REPRICING_PLAN,'F'),1,' '),
--Fixed_Rate_Term_in_Months NVARCHAR2(3),
rpad(' ',3,' '),
--Fixed_Rate_Term_in_Years NVARCHAR2(3),
rpad(' ',3,' '),
--Floating_int_Table_Code NVARCHAR2(5),
rpad(' ',5,' '),
--Fl_Rep_Freq NVARCHAR2(3),
rpad(' ',3,' '),
--Fl_Rep_Freq_In_Days NVARCHAR2(3),
rpad(' ',3,' '),
--Auto_Reschedule_Not_Allowed NVARCHAR2(1),
rpad( nvl(LSP.auto_reshdl_not_allowed,' '),1,' '),
--Res_Od_Principal NVARCHAR2(17),
rpad(' ',17,' '),
--Res_Od_int NVARCHAR2(17),
rpad(' ',17,' '),
--Loan_Type NVARCHAR2(1),
rpad('N',1,' '),
--Pay_Off_Reason_Code NVARCHAR2(5),
rpad(' ',5,' '),
--rf_Sanction_Date NVARCHAR2(8),
rpad(' ',8,' '),
--rf_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--sub_Acct_Id NVARCHAR2(16),
rpad(' ',16,' '),
--sub_Agency NVARCHAR2(5),
rpad(' ',5,' '),
--sub_Claimed_Date NVARCHAR2(8),
rpad(' ',8,' '),
--sub_Activity_Code NVARCHAR2(10),
rpad(' ',10,' '),
--Debit_Acknowledgement_Type NVARCHAR2(1),
rpad(' ',1,' '),
--rf_Sanction_num NVARCHAR2(25),
rpad(' ',25,' '),
--rf_Claimed_Date NVARCHAR2(8),
rpad(' ',8,' '),
--sub_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--sub_Received_Date NVARCHAR2(8),
rpad(' ',8,' '),
--Comp_Rest_Ind_Flag NVARCHAR2(1),
rpad(' ',1,' '),
--Collect_int_Flag NVARCHAR2(1),
--rpad(' ',1,' '),
rpad('Y',1,' '),
--Despatch_Mode NVARCHAR2(1),
rpad('N',1,' '),
--Acct_Manager NVARCHAR2(15),
rpad( case when nrd.officer_code is not null and trim(nrd.loginid) is not null then to_char(trim(nrd.loginid))
when trim(scpf.scaco)='199' then '199_RBD'
else nvl(convert_codes('RMCODE',trim(scpf.scaco)),'UBSADMIN') end,15,' '), -- changed on 06-01-2017 as per Vijay Confirmation
--Mode_of_Oper_Code NVARCHAR2(5),
rpad(' ',5,' '),
--st_Frequency_Type NVARCHAR2(1),
rpad(' ',1,' '),
--Week_num_for_st_Date NVARCHAR2(1),
rpad(' ',1,' '),
--Week_Day_for_st_Date NVARCHAR2(1),
rpad(' ',1,' '),
--Start_Date_for_acc_st NVARCHAR2(2),
rpad(' ',2,' '),
--st_Freq_Holidays NVARCHAR2(1),
rpad(' ',1,' '),
--st_of_the_acc NVARCHAR2(1),
rpad('N',1,' '),
--Next_Print_date NVARCHAR2(8),
rpad(' ',8,' '),
--min_Int_Per_Deb NVARCHAR2(10),
rpad(case when to_number(csp.min_int_pcnt_dr) > to_number(z.ACC_PREF_RATE) then to_char(z.ACC_PREF_RATE)  else ' ' end,10,' '),----added on 18-09-2017  as per sandeep and vijay requirement schm min rate is greater than the account rate
--max_Int_Per_Deb NVARCHAR2(10),
rpad(' ',10,' '),
--Product_Group NVARCHAR2(5),
rpad(' ',5,' '),
--Free_Text NVARCHAR2(240),
    case when trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null and trim(JGCF) is not null then     to_char(rpad('Govt fund :'|| trim(OWSD1)||' '||trim(OWSD2)||' '||trim(OWSD3)||' '||trim(OWSD4)||'Deal Notes :' ||trim(JGCF) ,240,' '))
    when trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null and trim(JGCF) is null then     to_char(rpad('Govt fund :' ||trim(OWSD1)||' '||trim(OWSD2)||' '||trim(OWSD3)||' '||trim(OWSD4),240,' '))
    when trim(OWSD1||OWSD2||OWSD3||OWSD4) is null and trim(JGCF) is not null then     to_char(rpad('Deal Notes :'||trim(JGCF),240,' '))
    else rpad(' ',240,' ') end,
--penal_prod_mthd__flg NVARCHAR2(1),
rpad(LSP.full_penal_mthd_flg,1,' '),
--penal_rate_mthd__flg NVARCHAR2(1),
rpad(' ',1,' '),
--Iban_num NVARCHAR2(34),
rpad(' ',34,' '),
--IAS_CLASSIFICATION_CODE NVARCHAR2(5),
rpad(' ',5,' '),
--Negotiated_Rate_Debit_Percent NVARCHAR2(10), AS PER NEW FORMAT NOT REQUIRED
--rpad(' ',10,' '),
--int_Rule_Code NVARCHAR2(5),
rpad(' ',5,' '),
--Recall_Flag NVARCHAR2(1),
rpad(' ',1,' '),
--Recall_Date NVARCHAR2(8),
rpad(' ',8,' '),
--dif_PS_Freq_For_Rel_Party NVARCHAR2(1),
rpad(' ',1,' '),
--dif_Swift_Freq_For_Rel_Party NVARCHAR2(1),
rpad(' ',1,' '),
--Penal_int_table_code NVARCHAR2(5),
rpad(' ',5,' '),
--Penal_Preferential_Percent NVARCHAR2(10),
rpad(' ',10,' '),
--int_table_Version NVARCHAR2(5),
rpad(' ',5,' '),
--Address_Type NVARCHAR2(12),
rpad(' ',12,' '),
--Related_Party_Phone_Type NVARCHAR2(12),
rpad(' ',12,' '),
--Related_Party_Email_Type NVARCHAR2(12),
rpad(' ',12,' '),
--Advance_int_amount NVARCHAR2(17),
rpad(case when MAP_ACC.schm_code in ('BDT','LDA') then TO_CHAR(ompf_i_cla.OMNWR/POWER(10,c8pf.C8CED)) else ' ' end,17,' '),
--Amortised_Amount NVARCHAR2(17),
rpad(case when MAP_ACC.schm_code in ('BDT','LDA') then TO_CHAR(abs(V5AM1)/POWER(10,c8pf.C8CED))  else ' ' end,17,' '),
--Adv_int_Coll_upto_Date NVARCHAR2(8),
rpad(case when MAP_ACC.schm_code in ('BDT','LDA') and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt<>'9999999' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'YYYYMMDD') else ' ' end,8,' '),
--Accr_Rate NVARCHAR2(9),
rpad(' ',9,' '),
--Accr_Penal_int_rec NVARCHAR2(17),
rpad(' ',17,' '),
--Penal_int_rec NVARCHAR2(17),
rpad(' ',17,' '),
--Coll_Int_rec NVARCHAR2(17),
rpad(' ',17,' '),
--Coll_Penal_Intt_rec NVARCHAR2(17)
rpad(' ',17,' '),
--MARKUP_INT_RATE_APPL_FLG NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--PREFERRED_CAL_BASE NVARCHAR2(2),    ADDED AS PER NEW FORMAT
rpad(' ',2,' '),
--AC_LEVEL_SPREAD NVARCHAR2(10),    ADDED AS PER NEW FORMAT
rpad(' ',10,' '),
--INT_RATE_PRD_IN_MONTHS NVARCHAR2(4),    ADDED AS PER NEW FORMAT
rpad(' ',4,' '),
--INT_RATE_PRD_IN_DAYS NVARCHAR2(3),    ADDED AS PER NEW FORMAT
rpad(' ',3,' '),
--ACCT_TYPE NVARCHAR2(5),    ADDED AS PER NEW FORMAT
rpad(' ',5,' '),
--INT_PEN_BREAKUP_REQD_FLG NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--CUMM_COMPINT_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
rpad(' ',17,' '),
--CUMM_PENALINT_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
rpad(' ',17,' '),
--CUMM_PENALPRNC_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
rpad(' ',17,' '),
--CUMM_COMPPRNC_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
rpad(' ',17,' '),
--APPLY_INT_ON_PYMT NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--CCY_HOL_TREATMENT_FLG NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad('N',1,' '),
--FIRST_DRDN_VAL_DATE_INT_RATE NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--INTERPOLATION_METHOD NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--SYN_ACCOUNT_TYPE NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--TRANCHE_ID NVARCHAR2(16),    ADDED AS PER NEW FORMAT
rpad(' ',16,' '),
--SYN_AGENT_REF_NUM NVARCHAR2(36),    ADDED AS PER NEW FORMAT
rpad(' ',36,' '),
--INTERPOL_REQD_CURHOL_BRKN_PRD NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--INT_RATE_REF_CRNCY_CODE NVARCHAR2(3),    ADDED AS PER NEW FORMAT
rpad(' ',3,' '),
--PROJECT_CRNCY_CODE NVARCHAR2(3),    ADDED AS PER NEW FORMAT
rpad(' ',3,' '),
--RATE_FIXING_METHOD NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--SECURITY_INDICATOR NVARCHAR2(10),    ADDED AS PER NEW FORMAT
rpad(' ',10,' '),
--DEBT_SENIORITY NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--SECURITY_CODE NVARCHAR2(8)    ADDED AS PER NEW FORMAT
rpad(' ',8,' ')
from map_acc 
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr) = map_acc.leg_acc_num
left join scpf on scab||scan||scas=V5ABD||v5AND||V5ASD
left join (select * from tbaadm.lsp where lsp.del_flg <> 'Y' and lsp.bank_id=get_param('BANK_ID'))lsp on lsp.schm_code = map_acc.schm_code and map_acc.currency=lsp.crncy_code 
left join (select * from tbaadm.gsp where gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID'))gsp on gsp.schm_code = map_acc.schm_code  
left join (select * from tbaadm.gss where gss.del_flg <> 'Y' and gss.DEFAULT_FLG ='Y' and gss.bank_id=get_param('BANK_ID'))gss on gss.schm_code = map_acc.schm_code  
left join (select * from tbaadm.csp where del_flg <> 'Y'  and bank_id=get_param('BANK_ID'))csp on csp.schm_code = map_acc.schm_code  and  csp.crncy_code=map_acc.currency
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num
--inner join (select ombrnm||omdlp||trim(omdlr) ompf_leg_num,sum(omnwp) omnwp from ompf inner join map_acc on ombrnm||omdlp||trim(omdlr) =leg_acc_num where schm_type='CLA' and ommvt='P' and ommvts in ('C','O') group by ombrnm||omdlp||trim(omdlr))OMPF ON OMPF_LEG_NUM=LEG_ACC_NUM
inner join ompf_cla ON OMPF_LEG_NUM=LEG_ACC_NUM
left join jgpf on jgbrnm||trim(jgdlp)||trim(jgdlr) = map_acc.leg_acc_num
inner join obpf on trim(obdlp)=trim(v5dlp)
--left join (select ombrnm,omdlp,omdlr,sum(omnwr) iomnwr   from ompf where OMMVT = 'I' and ommvts is null  group by ombrnm,omdlp,omdlr) iompf on iompf.ombrnm||iompf.omdlp||trim(iompf.omdlr)=LEG_ACC_NUM
left join iompf on iompf.ombrnm||trim(iompf.omdlp)||trim(iompf.omdlr)=LEG_ACC_NUM
left join (select lsbrnm,trim(lsdlp) lsdlp,trim(lsdlr)lsdlr,sum(lsamtd - lsamtp) sum_overdue from lspf where lsmvt='P' and (LSAMTD - LSAMTP) <> 0 and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,trim(lsdlp),trim(lsdlr))lspf on lspf.lsbrnm||lspf.lsdlp||lspf.lsdlr=leg_acc_num
left join cla_operacc oper on  trim(oper.ompf_leg_num)=leg_acc_num
left join demand_count dmd_cnt on  dmd_cnt.lsbrnm||trim(dmd_cnt.lsdlp)||trim(dmd_cnt.lsdlr)=leg_acc_num
left join cla_account_finacle_int_rate cla_int_tbl on trim(cla_int_tbl.int_acc_num)=leg_acc_num
left join cla_acct_fin_int_rate_les12 cla_int_tbl_les12 on trim(cla_int_tbl_les12.int_acc_num)=leg_acc_num
left join cla_acct_fin_int_rate_more12 cla_int_tbl_more12 on trim(cla_int_tbl_more12.int_acc_num)=leg_acc_num
left join cla_int_tbl z on trim(z.int_acc_num)=leg_acc_num
left join owpf_note_laa on trim(leg_acc)=map_acc.leg_acc_num
left join ompf_i_cla ompf_i_cla on  trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=ompf_i_cla.ombrnm||trim(ompf_i_cla.omdlp)||trim(ompf_i_cla.omdlr)  
inner join c8pf on c8ccy = otccy
left join repricing_plan_map a on a.schm_code=map_acc.schm_code
left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
left join gfpf gf on trim(gf.gfclc)=trim(map_cif.gfclc) and  trim(gf.gfcus)=trim(map_cif.gfcus)  and gf.gfcpnc=MAP_CIF.GFCPNC
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
where map_acc.schm_type='CLA' and  v5pf.v5tdt='L' and v5pf.v5bal<>'0';
commit;
---------------------------LAC scheme code upload-----------------
insert into Cl001_O_TABLE
select  distinct 
--acc_num NVARCHAR2(16),
rpad(map_acc.fin_acc_num,16,' '),
--Cust_Credit_Pref_Per NVARCHAR2(10),
lpad(' ',10,' '),
--Cust_Debit_Pref_Per NVARCHAR2(10),
lpad(' ',10,' '),
--Acct_ID_Credit_Pref_Per NVARCHAR2(10),
--lpad(nvl(TO_CHAR(CR_PREF_RATE,'fm990.0999999'),0),10,' '),
lpad(case when a.s5ab||a.s5an||a.s5as is not null then nvl(TO_CHAR(a.CR_PREF_RATE,'fm990.0999999'),0)
else nvl(TO_CHAR(b.CR_PREF_RATE,'fm990.0999999'),0) end,10,' '),--Based on Nancy spira 7035 changed on 22-06-2017 change done by  kumar
--Acct_ID_Debit_Pref_Per NVARCHAR2(10),
--lpad(nvl(TO_CHAR(DR_PREF_RATE,'fm990.0999999'),0),10,' '),
lpad(case when map_acc.currency <> 'KWD' then to_char(c.s5ratd) when a.s5ab||a.s5an||a.s5as is not null then nvl(TO_CHAR(a.DR_PREF_RATE,'fm990.0999999'),0)
else nvl(TO_CHAR(b.DR_PREF_RATE,'fm990.0999999'),0) end,10,' '),--Based on Nancy spira 7035 changed on 22-06-2017 change done by  kumar
--Pegged_Flag NVARCHAR2(1),
rpad(TBAADM.GSP.PEG_INT_FOR_AC_FLG,1,' '),
--Peg_Freq_in_Months NVARCHAR2(4),
rpad(' ',4,' '),
--Peg_Freq_in_Days NVARCHAR2(3),
rpad(' ',3,' '),
--int_Route_Flag NVARCHAR2(1),
rpad(nvl(tbaadm.lsp.int_route_flg,' '),1,' '),---Based on discussion with sandeep and vijay --changed default value 'O' to scheme level flag on 15-07-2017
--rpad('O',1,' '),
--Acct_Currency_Code NVARCHAR2(3),
rpad(map_acc.currency,3,' '),
--Sol_ID NVARCHAR2(8),
rpad(map_acc.fin_sol_id,8,' '),
--GL_Sub_Head_Code NVARCHAR2(5),
--rpad(nvl(tbaadm.gss.gl_sub_head_code,' '),5,' '),
rpad(nvl(map_acc.gl_sub_headcode,' '),5,' '),
--Schm_Code NVARCHAR2(5),
rpad(map_acc.schm_code,5,' '),
--CIF_ID NVARCHAR2(32),
rpad(map_acc.fin_cif_id,32,' '),
--Acct_Open_Date NVARCHAR2(8),
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'YYYYMMDD'),8,' ')          
         else lpad(' ',8,' ')  end,    
--Sanction_Limit NVARCHAR2(17),
  lpad(abs(to_number(scbal)/POWER(10,c8pf.C8CED)),17,' '),
--Ledger_num NVARCHAR2(3),
rpad(' ',3,' '),
--   v_Sector_Code           CHAR(5)KTWORKS
    case when get_param('BANK_ID')='02'then rpad(convert_codes('SECTOR_CODE',trim(gf.GFC3R)),5,' ') 
      --else rpad(convert_codes('SECTOR_CODE',trim(gf.GFC2R)),5,' ') end,--changed on 07-03-2017 as per vijay confirmation
	  else rpad(convert_codes('SECTOR_CODE',trim(SCC2R)),5,' ') end,--changed on 17-08-2017 as per vijay discussion with Sandeep 
--   v_Sub_Sector_Code           CHAR(5)KTWORKS
    case when get_param('BANK_ID')='02' then rpad(nvl(trim(gf.GFC3R),'ZZZ'),5,' ')
          --else rpad(nvl(trim(gf.GFC2R),'ZZZ'),5,' ') end,--changed on 07-03-2017 as per vijay confirmation
		  else rpad(nvl(trim(SCC2R),'ZZZ'),5,' ') end,--changed on 17-08-2017 as per vijay discussion with Sandeep 
--Pur_of_Advance NVARCHAR2(5),
    case when get_param('BANK_ID')='02' then rpad(nvl(trim(SCC3R),'999'),5,' ')
    else rpad(nvl(trim(SCC2R),'999'),5,' ') end,
--Nature_of_Advance NVARCHAR2(5),
rpad('999',5,' '),
--F_c_3 NVARCHAR2(5),
rpad(' ',5,' '),
--Sanction_ref_num NVARCHAR2(25),
rpad(' ',25,' '),
--Sanction_Limit_Date NVARCHAR2(8),
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'YYYYMMDD'),8,' ')          
         else lpad(' ',8,' ')  end,    
--Sanction_Level_Code NVARCHAR2(5),
rpad('999',5,' '),
--Limit_Expiry_Date NVARCHAR2(8),
case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(SCLED ),'YYYYMMDD'),'YYYYMMDD'),8,' ')          
         else lpad(' ',8,' ')  end,    
--Sanction_Authority_Code NVARCHAR2(5),
rpad('999',5,' '),
--Loan_Paper_Date NVARCHAR2(8),
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'YYYYMMDD'),8,' ')          
         else lpad(' ',8,' ')  end,    
--Operative_Acct_ID NVARCHAR2(16),
rpad(case when oper_fin_num is not null then oper_fin_num when op_num  is not null then op_num else ' ' end,16,' '),
--Operative_Currency_Code NVARCHAR2(3),
rpad(case when oper_fin_num is not null then oper_currency  when op_num  is not null then op_ccy else ' ' end ,3,' '),
--Operative_Sol_ID NVARCHAR2(8),
rpad(case when oper_fin_num is not null then oper_fin_sol  when op_num  is not null then op_sol else ' ' end ,8,' '),
--Demand_Satisfy_Method NVARCHAR2(1),
rpad(case when oper_fin_num is not null then  'T' when op_num  is not null then 'T' else 'N' end,1,' '),---'E' to 'T'  changed as per vijay mail dt 25-09-2017
--Lien_on_Operative_Acct_Flag NVARCHAR2(1),
rpad(case when oper_fin_num is not null then LSP.lien_on_oper_Acct_flg when op_num  is not null then LSP.lien_on_oper_Acct_flg else 'N' end,1,' '), 
--Demand_Satisfaction_Rate_Code NVARCHAR2(5),
rpad(' ',5,' '),
--int_table_code NVARCHAR2(5),
rpad(case when map_acc.currency='AED' then 'ZAED'
when map_acc.currency='EUR' then 'ZEUR'
when map_acc.currency='GBP' then 'ZGBP'
when map_acc.currency='USD' then 'ZUSD'
when map_acc.currency='KWD' then 'CORTE'
else ' ' end ,5,' '),
--int_on_principal_Flag NVARCHAR2(1),
rpad(tbaadm.LSP.int_on_p_flg,1,' '),
--Penal_overdue_pr_demand_Flag NVARCHAR2(1),
rpad(tbaadm.LSP.pi_on_pdmd_ovdu_flg,1,' '),
--Pri_Dem_Od_end_month_Flag NVARCHAR2(1),
rpad(tbaadm.LSP.pdmd_ovdu_eom_flg,1,' '),
--int_On_int_Demand_Flag NVARCHAR2(1),
rpad(tbaadm.LSP.int_on_idmd_flg,1,' '), -----Based on discussion with sandeep and vijay --changed default value 'O' to scheme level flag on 15-07-2017
--rpad('N',1,' '),
--penal_overdue_int_demand_Flag NVARCHAR2(1),
rpad(tbaadm.LSP.pi_on_idmd_ovdu_flg,1,' '),
--int_Dem_Od_End_Month_Flag NVARCHAR2(1),
rpad(tbaadm.LSP.idmd_ovdu_eom_flg,1,' '),
--Transfer_Effective_Date NVARCHAR2(8),
rpad(to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),'YYYYMMDD'),8,' '),   
--Cumul_Normal_int_amount NVARCHAR2(17),
rpad(' ',17,' '),
--Cumul_penal_int_amount NVARCHAR2(17),
rpad(' ',17,' '),
--cumul_add_int_amount NVARCHAR2(17),
rpad(' ',17,' '),
--Liab_as_on_Transfer_Eff_date NVARCHAR2(17),
rpad(abs(to_number(scbal))/POWER(10,c8pf.C8CED),17,' '),
--Disb_in_Pres_Schedule NVARCHAR2(17),
rpad('0',17,' '),
--Last_int_posted_date NVARCHAR2(8),
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'YYYYMMDD'),8,' ')          
         else lpad(' ',8,' ')  end,    
--Repayment_Schedule_Date NVARCHAR2(8),
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'YYYYMMDD'),8,' ')          
         else lpad(' ',8,' ')  end,    
--Repayment_Period_in_months NVARCHAR2(3),
rpad(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(scled),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD'))) end
     else 0 end
     ,3,' '),                                                             
--Repayment_Period_in_Days NVARCHAR2(3),
lpad(case when scoad<>'0' and get_date_fm_btrv(scoad) <> 'ERROR' and scled<>'0' and get_date_fm_btrv(scled) <> 'ERROR' and scled <> '9999999' then 
case when last_day(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')) = to_date(get_date_fm_btrv(scoad),'YYYYMMDD') then 
          to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')-1,to_date(get_date_fm_btrv(scoad),'YYYYMMDD')-1 ))) 
     else to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),to_date(get_date_fm_btrv(scoad),'YYYYMMDD') ))) end
else 0 end
,3,' '),
--Past_Due_Flag NVARCHAR2(1),
rpad('N',1,' '),
--Past_Due_date NVARCHAR2(8),
rpad(' ',8,' '),
--Normal_GL_subhead_Code NVARCHAR2(5),
rpad(' ',5,' '),
--Normal_int_Suspense_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Penal_int_Suspense_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Charge_Off_Flag NVARCHAR2(1),
rpad('N',1,' '),
--Charge_Off_date NVARCHAR2(8),
rpad(' ',8,' '),
--Charged_Off_Principal_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Charged_off_int_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Principal_rec NVARCHAR2(17),
rpad(' ',17,' '),
--int_rec NVARCHAR2(17),
rpad(' ',17,' '),
--Source_Dealer_Code NVARCHAR2(20),
rpad(' ',20,' '),
--Disburse_Dealer_Code NVARCHAR2(20),
rpad(' ',20,' '),
--Apply_late_fee_Flag NVARCHAR2(1),
rpad(tbaadm.lsp.apply_late_fee_flg,1,' '),
--Lt_Fee_GPeriod_Months NVARCHAR2(3),
rpad(LATEFEE_GRACE_PERD_MNTHS,3,' '),
--Lt_fee_gPeriod_days NVARCHAR2(3),
rpad(LATEFEE_GRACE_PERD_days,3,' '),
--Days_Past_Due_counter NVARCHAR2(5),
rpad('0',5,' '),
--Sum_pri_dem_amt NVARCHAR2(17),
lpad(case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') <  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then abs(to_number(scbal)/POWER(10,c8pf.C8CED)) else 0 end,17,' '),
--Payoff_Flag NVARCHAR2(1),
rpad('N',1,' '),
--Exclude_for_combined_st NVARCHAR2(1),
rpad(' ',1,' '),
--st_Cif_Id NVARCHAR2(32),
rpad(' ',32,' '),
--Transfer_Cycle_String NVARCHAR2(45),
rpad( '000000000000000000000000000000000000000000000',45,' '),
--Value_of_Asset NVARCHAR2(17),
rpad(' ',17,' '),
--Occ_code_of_the_cust NVARCHAR2(5),
rpad(convert_codes('SUNDRY_ANALYSIS_CODE',trim(SCSAC)),5,' '),
--Borrower_category_code NVARCHAR2(5),
rpad(' ',5,' '),
--Mode_of_Advance NVARCHAR2(5),
rpad(' ',5,' '),
--Type_of_Advance NVARCHAR2(5),
rpad(' ',5,' '),
--guarantee_coverage_Code NVARCHAR2(5),
rpad(' ',5,' '),
--Industry_Type NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_1 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_2 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_4 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_5 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_6 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_7 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_8 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_9 NVARCHAR2(5),
rpad(' ',5,' '),
--F_c_10 NVARCHAR2(5),
rpad(' ',5,' '),
--Acct_Location_Code NVARCHAR2(5),
rpad(' ',5,' '),
--Credit_File_ref_Id NVARCHAR2(15),
rpad(' ',15,' '),
--Last_Compound_Date NVARCHAR2(8),
--rpad(case when tbaadm.LSP.int_on_idmd_flg ='Y' then to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),'YYYYMMDD') else ' ' end ,8,' '),
rpad(' ',8,' '),
--Daily_Compound_int_Flag NVARCHAR2(1),
--rpad(tbaadm.LSP.int_on_idmd_flg,1,' '),
rpad(tbaadm.GSP.DAILY_COMP_INT_FLG,1,' '),
--EI_period_start_date NVARCHAR2(8),
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'YYYYMMDD'),8,' ')          
         else lpad(' ',8,' ')  end,    
--EI_period_End_date NVARCHAR2(8),
case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(SCLED ),'YYYYMMDD'),'YYYYMMDD'),8,' ')          
         else lpad(' ',8,' ')  end,    
--Charge_Route_flag NVARCHAR2(1),
rpad(tbaadm.LSP.chrg_route_flg,1,' '),
--Total_num_of_Deferments NVARCHAR2(2),
rpad(' ',2,' '),
--Def_in_curr_schedule NVARCHAR2(2),
rpad(' ',2,' '),
--Col_int_in_advance_flag NVARCHAR2(1),  AS PER NEW FORMAT NOT REQUIRED
--rpad(' ',1,' '),
--Res_acc NVARCHAR2(16),    AS PER NEW FORMAT NOT REQUIRED
--rpad(' ',16,' '),
--Draw_down_lvl_rate_flag NVARCHAR2(1),
rpad(' ',1,' '),
--EI_flag NVARCHAR2(1),
rpad(nvl(trim(tbaadm.LSP.ei_schm_flg),'N'),1,' '),
--Installment_date_extd NVARCHAR2(8),
rpad(' ',8,' '),
--Extended_overdue_Date NVARCHAR2(8),
rpad(' ',8,' '),
--Def_app_int_rate_flag NVARCHAR2(1),
rpad(' ',1,' '),
--Def_app_int_rate NVARCHAR2(10),
rpad(' ',10,' '),
--Deferred_int_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Last_prepayment_date NVARCHAR2(8),
rpad(' ',8,' '),
--rf_end_date NVARCHAR2(8),
rpad(' ',8,' '),
--rf_ref_num NVARCHAR2(25),
rpad(' ',25,' '),
--Charge_off_type NVARCHAR2(1),
rpad(' ',1,' '),
--Cry_reqd NVARCHAR2(1),
rpad(' ',1,' '),
--Cry_Currency NVARCHAR2(3),
rpad(' ',3,' '),
--Contract_date NVARCHAR2(8),
rpad(' ',8,' '),
--Crys_A_c NVARCHAR2(16),
rpad(' ',16,' '),
--acc_Status NVARCHAR2(1),
rpad(' ',1,' '),
--Comm_fee_methods NVARCHAR2(1),
rpad(' ',1,' '),
--Shift_installment_flag NVARCHAR2(1),
rpad(' ',1,' '),
--Parent_cif_id NVARCHAR2(32),
rpad(' ',32,' '),
--Peg_Review_Date NVARCHAR2(8),
rpad(' ',8,' '),
--rf_Ref_num1 NVARCHAR2(25),
rpad(' ',25,' '),
--Penal_int_based_on_Outstanding NVARCHAR2(1),
case when tbaadm.LSP.pi_on_pdmd_ovdu_flg = 'N' then ' ' else tbaadm.LSP.pi_based_on_outstanding end,
--Del_Reschedule_Method_Flag NVARCHAR2(1),
rpad(' ',1,' '),
--Probation_Period_in_Months NVARCHAR2(3),
rpad(' ',3,' '),
--Probation_Period_in_Days NVARCHAR2(3),
rpad(' ',3,' '),
--Total_num_of_Switch_Over NVARCHAR2(3),
rpad(' ',3,' '),
--Non_Starter_Flag NVARCHAR2(1),
rpad(' ',1,' '),
--Repricing_Plan NVARCHAR2(1),
rpad('V',1,' '),
--Fixed_Rate_Term_in_Months NVARCHAR2(3),
rpad(' ',3,' '),
--Fixed_Rate_Term_in_Years NVARCHAR2(3),
rpad(' ',3,' '),
--Floating_int_Table_Code NVARCHAR2(5),
rpad(' ',5,' '),
--Fl_Rep_Freq NVARCHAR2(3),
rpad(' ',3,' '),
--Fl_Rep_Freq_In_Days NVARCHAR2(3),
rpad(' ',3,' '),
--Auto_Reschedule_Not_Allowed NVARCHAR2(1),
rpad( nvl(tbaadm.LSP.auto_reshdl_not_allowed,' '),1,' '),
--Res_Od_Principal NVARCHAR2(17),
rpad(' ',17,' '),
--Res_Od_int NVARCHAR2(17),
rpad(' ',17,' '),
--Loan_Type NVARCHAR2(1),
rpad('N',1,' '),
--Pay_Off_Reason_Code NVARCHAR2(5),
rpad(' ',5,' '),
--rf_Sanction_Date NVARCHAR2(8),
rpad(' ',8,' '),
--rf_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--sub_Acct_Id NVARCHAR2(16),
rpad(' ',16,' '),
--sub_Agency NVARCHAR2(5),
rpad(' ',5,' '),
--sub_Claimed_Date NVARCHAR2(8),
rpad(' ',8,' '),
--sub_Activity_Code NVARCHAR2(10),
rpad(' ',10,' '),
--Debit_Acknowledgement_Type NVARCHAR2(1),
rpad(' ',1,' '),
--rf_Sanction_num NVARCHAR2(25),
rpad(' ',25,' '),
--rf_Claimed_Date NVARCHAR2(8),
rpad(' ',8,' '),
--sub_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--sub_Received_Date NVARCHAR2(8),
rpad(' ',8,' '),
--Comp_Rest_Ind_Flag NVARCHAR2(1),
rpad(' ',1,' '),
--Collect_int_Flag NVARCHAR2(1),
--rpad(' ',1,' '),
rpad('Y',1,' '),
--Despatch_Mode NVARCHAR2(1),
rpad('N',1,' '),
--Acct_Manager NVARCHAR2(15),
rpad( case when nrd.officer_code is not null and trim(nrd.loginid) is not null  then to_char(trim(nrd.loginid))
when trim(scpf.scaco)='199' then '199_RBD'
else nvl(convert_codes('RMCODE',trim(scpf.scaco)),'UBSADMIN') end,15,' '), -- changed on 06-01-2017 as per Vijay Confirmation
--Mode_of_Oper_Code NVARCHAR2(5),
rpad(' ',5,' '),
--st_Frequency_Type NVARCHAR2(1),
rpad(' ',1,' '),
--Week_num_for_st_Date NVARCHAR2(1),
rpad(' ',1,' '),
--Week_Day_for_st_Date NVARCHAR2(1),
rpad(' ',1,' '),
--Start_Date_for_acc_st NVARCHAR2(2),
rpad(' ',2,' '),
--st_Freq_Holidays NVARCHAR2(1),
rpad(' ',1,' '),
--st_of_the_acc NVARCHAR2(1),
rpad('N',1,' '),
--Next_Print_date NVARCHAR2(8),
rpad(' ',8,' '),
--min_Int_Per_Deb NVARCHAR2(10),
rpad( case when to_number(min_int_pcnt_dr) > (case when c.S5RATD <> 0 then c.S5RATD when a.DR_BASE_RATE is not null and a.DR_MARGIN_RATE is not null then a.DR_BASE_RATE  + a.DR_MARGIN_RATE else b.DR_BASE_RATE + b.DR_MARGIN_RATE end) then to_char(case when c.S5RATD <> 0 then c.S5RATD when a.DR_BASE_RATE is not null and a.DR_MARGIN_RATE is not null then a.DR_BASE_RATE  + a.DR_MARGIN_RATE else b.DR_BASE_RATE + b.DR_MARGIN_RATE end)  else ' ' end,10,' '),
--max_Int_Per_Deb NVARCHAR2(10),
rpad(' ',10,' '),
--Product_Group NVARCHAR2(5),
rpad(' ',5,' '),
--Free_Text NVARCHAR2(240),
    rpad(' ',240,' '),
--penal_prod_mthd__flg NVARCHAR2(1),
rpad(LSP.full_penal_mthd_flg,1,' '),
--penal_rate_mthd__flg NVARCHAR2(1),
rpad(' ',1,' '),
--Iban_num NVARCHAR2(34),
rpad(' ',34,' '),
--IAS_CLASSIFICATION_CODE NVARCHAR2(5),
rpad(' ',5,' '),
--Negotiated_Rate_Debit_Percent NVARCHAR2(10), AS PER NEW FORMAT NOT REQUIRED
--rpad(' ',10,' '),
--int_Rule_Code NVARCHAR2(5),
rpad(' ',5,' '),
--Recall_Flag NVARCHAR2(1),
rpad(' ',1,' '),
--Recall_Date NVARCHAR2(8),
rpad(' ',8,' '),
--dif_PS_Freq_For_Rel_Party NVARCHAR2(1),
rpad(' ',1,' '),
--dif_Swift_Freq_For_Rel_Party NVARCHAR2(1),
rpad(' ',1,' '),
--Penal_int_table_code NVARCHAR2(5),
rpad(' ',5,' '),
--Penal_Preferential_Percent NVARCHAR2(10),
rpad(' ',10,' '),
--int_table_Version NVARCHAR2(5),
rpad(' ',5,' '),
--Address_Type NVARCHAR2(12),
rpad(' ',12,' '),
--Related_Party_Phone_Type NVARCHAR2(12),
rpad(' ',12,' '),
--Related_Party_Email_Type NVARCHAR2(12),
rpad(' ',12,' '),
--Advance_int_amount NVARCHAR2(17),
rpad(' ',17,' '),
--Amortised_Amount NVARCHAR2(17),
rpad(' ',17,' '),
--Adv_int_Coll_upto_Date NVARCHAR2(8),
rpad(' ',8,' '),
--Accr_Rate NVARCHAR2(9),
rpad(' ',9,' '),
--Accr_Penal_int_rec NVARCHAR2(17),
rpad(' ',17,' '),
--Penal_int_rec NVARCHAR2(17),
rpad(' ',17,' '),
--Coll_Int_rec NVARCHAR2(17),
rpad(' ',17,' '),
--Coll_Penal_Intt_rec NVARCHAR2(17)
rpad(' ',17,' '),
--MARKUP_INT_RATE_APPL_FLG NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--PREFERRED_CAL_BASE NVARCHAR2(2),    ADDED AS PER NEW FORMAT
rpad(' ',2,' '),
--AC_LEVEL_SPREAD NVARCHAR2(10),    ADDED AS PER NEW FORMAT
rpad(' ',10,' '),
--INT_RATE_PRD_IN_MONTHS NVARCHAR2(4),    ADDED AS PER NEW FORMAT
rpad(' ',4,' '),
--INT_RATE_PRD_IN_DAYS NVARCHAR2(3),    ADDED AS PER NEW FORMAT
rpad(' ',3,' '),
--ACCT_TYPE NVARCHAR2(5),    ADDED AS PER NEW FORMAT
rpad(' ',5,' '),
--INT_PEN_BREAKUP_REQD_FLG NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--CUMM_COMPINT_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
rpad(' ',17,' '),
--CUMM_PENALINT_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
rpad(' ',17,' '),
--CUMM_PENALPRNC_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
rpad(' ',17,' '),
--CUMM_COMPPRNC_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
rpad(' ',17,' '),
--APPLY_INT_ON_PYMT NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--CCY_HOL_TREATMENT_FLG NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad('N',1,' '),
--FIRST_DRDN_VAL_DATE_INT_RATE NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--INTERPOLATION_METHOD NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--SYN_ACCOUNT_TYPE NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--TRANCHE_ID NVARCHAR2(16),    ADDED AS PER NEW FORMAT
rpad(' ',16,' '),
--SYN_AGENT_REF_NUM NVARCHAR2(36),    ADDED AS PER NEW FORMAT
rpad(' ',36,' '),
--INTERPOL_REQD_CURHOL_BRKN_PRD NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--INT_RATE_REF_CRNCY_CODE NVARCHAR2(3),    ADDED AS PER NEW FORMAT
rpad(' ',3,' '),
--PROJECT_CRNCY_CODE NVARCHAR2(3),    ADDED AS PER NEW FORMAT
rpad(' ',3,' '),
--RATE_FIXING_METHOD NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--SECURITY_INDICATOR NVARCHAR2(10),    ADDED AS PER NEW FORMAT
rpad(' ',10,' '),
--DEBT_SENIORITY NVARCHAR2(1),    ADDED AS PER NEW FORMAT
rpad(' ',1,' '),
--SECURITY_CODE NVARCHAR2(8)    ADDED AS PER NEW FORMAT
rpad(' ',8,' ')
from map_acc 
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
--left join (select fin_cif_id,max(fin_acc_num) oda_oper_acc from map_acc where fin_cif_id in (select fin_cif_id from map_acc a where schm_code IN ('LAC','CLM') ) and schm_code NOT IN ('LAC','CLM') and schm_type  in ('ODA') group by fin_cif_id)oper_oda on oper_oda.fin_cif_id=map_acc.fin_cif_id
--left join (select fin_cif_id,max(fin_acc_num) CAA_oper_acc from map_acc where fin_cif_id in (select fin_cif_id from map_acc a where schm_code IN ('LAC','CLM') ) and schm_code NOT IN ('LAC','CLM') and schm_type  in ('CAA') group by fin_cif_id)oper_caa on oper_caa.fin_cif_id=map_acc.fin_cif_id
--left join (select fin_acc_num,fin_sol_id,currency from map_acc)oper on oper.fin_acc_num=nvl(oda_oper_acc,caa_oper_acc)
--left join (select ACCOUNT_NO,fin_acc_num,fin_sol_id,currency from lac_operative_account
--inner join map_acc on nvl(trim(OD_BILLING_ACCOUNT),trim(OTHER_BILLING_ACCOUNT))=fin_acc_num)oper on replace(trim(ACCOUNT_NO),'-','')=map_acc.leg_branch_id||map_acc.leg_Scan
--left join (select distinct replace(trim(account_no),'-',''),map_acc.fin_acc_num,trim(OD_BILLING),trim(ACCOUNT),oper.fin_acc_num oper_fin_num,oper.fin_sol_id oper_fin_sol,oper.currency oper_currency 
--from lac_operative_account inner join map_cif on gfclc||gfcus=to_number(replace(trim(account_no),'-','')) inner join map_acc on map_cif.fin_cif_id=map_acc.fin_cif_id 
--left join map_acc oper on nvl(trim(OD_BILLING),trim(ACCOUNT))=oper.fin_acc_num where map_acc.schm_code in ('LAC','CLM'))oper on oper.fin_acc_num=map_acc.fin_acc_num
left join (select distinct trim(LAC_ACC_NO) LAC_ACC_NO,map_acc.fin_acc_num,trim(BILLING_ACCOUNT) BILLING_ACCOUNT,oper.fin_acc_num oper_fin_num,oper.fin_sol_id oper_fin_sol,oper.currency oper_currency from map_acc 
inner join lac_operative_account a on lac_acc_no=fin_acc_num inner  join map_acc oper on billing_account=oper.fin_acc_num where map_acc.schm_code in ('LAC','CLM')) oper on oper.fin_acc_num=map_acc.fin_acc_num
left join (select a.fin_acc_num main_num,b.fin_acc_num op_num,b.currency op_ccy,b.fin_sol_id op_sol from ubpf 
inner join map_acc a on ubab||uban||ubas =a.leg_branch_id||a.leg_Scan||a.leg_Scas
inner join map_acc b on ubnab||ubnan||ubnas =b.leg_branch_id||b.leg_Scan||b.leg_Scas
where a.schm_code='LAC')op on op.main_num=map_acc.fin_acc_num
--left join (select fin_acc_num,fin_sol_id,currency from map_acc) oper on oper.fin_acc_num=nvl(oda_oper_acc,caa_oper_acc)
left join tbaadm.lsp lsp on lsp.schm_code = map_acc.schm_code and map_acc.currency=lsp.crncy_code and lsp.del_flg <> 'Y' and lsp.bank_id=get_param('BANK_ID')
left join tbaadm.gsp gsp on gsp.schm_code = map_acc.schm_code and gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID')
left join tbaadm.gss gss on gss.schm_code = map_acc.schm_code and gss.del_flg <> 'Y' and   gss.DEFAULT_FLG ='Y' and gss.bank_id=get_param('BANK_ID')
left join (select * from tbaadm.csp where del_flg <> 'Y'  and bank_id=get_param('BANK_ID'))csp on csp.schm_code = map_acc.schm_code  and  csp.crncy_code=map_acc.currency
left join cla_lac_fin_int_rate_more12 a on  a.s5ab||a.s5an||a.s5as=leg_branch_id||leg_scan||leg_scas
left join cla_lac_fin_int_rate_les12 b on  b.s5ab||b.s5an||b.s5as=leg_branch_id||leg_scan||leg_scas
left join ACCT_INTEREST_TEMP c on leg_branch_id||leg_scan||leg_Scas=c.s5ab||c.s5an||c.s5as
inner join c8pf on c8ccy = map_acc.currency
left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
left join gfpf gf on trim(gf.gfclc)=trim(map_cif.gfclc) and  trim(gf.gfcus)=trim(map_cif.gfcus)  and gf.gfcpnc=MAP_CIF.GFCPNC 
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
where map_acc.schm_type='CLA'  and map_acc.schm_code IN ('LAC','CLM')
and scbal <> 0;
commit;
--Corporate Loan Drawdown  bloack added on 04-06-2017--
-----cla account details-------------------
--drop table cla_ld_acct_details;
--create table cla_ld_acct_details as
----select fin_acc_num,min(otsdte) otsdte,max(otmdt) otmdt,sum(otdla) otdla,min(v5lcd) v5lcd from map_acc a
--select fin_acc_num,min(scoad) otsdte,max(otmdt) otmdt,sum(otdla) otdla,min(v5lcd) v5lcd from map_acc a--- added on 30-07-2017 based on acct_open_date logic change requirement mail by vijay on 30-07-2017
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--inner join scpf s on s.scab||s.Scan||s.Scas= b.scab||b.Scan||b.Scas--- added on 30-07-2017 based on acct_open_date logic change requirement mail by vijay on 30-07-2017
--left join otpf on otbrnm||trim(otdlp)||trim(otdlr)=b.LEG_ACC_NUM
--left join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr)=b.LEG_ACC_NUM
--group by fin_acc_num;
----- sanction limit--------------------
--drop table ompf_ld_cla1;
-----Gop-- appended 1 to table name
--create table ompf_ld_cla1 as---Gop-- appended 1 to table name
----select fin_acc_num,sum(omnwp) omnwp from map_acc a ---commentd on 08-08-2017 based on Nancy mail dt 08-08-2017 and vijay confirmation--commented due to outstanding balance need to provided instead of original deal amount
--select fin_acc_num,sum(otdla) omnwp from map_acc a ---ADDED on 08-08-2017 based on Nancy mail dt 08-08-2017 and vijay confirmation--added due to outstanding balance need to provided instead of original deal amount
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
----inner join ompf on ombrnm||trim(omdlp)||trim(omdlr)=b.LEG_ACC_NUM where ommvt='P' and ommvts in ('C','O')---commentd on 08-08-2017 based on Nancy mail dt 08-08-2017 and vijay confirmation--commented due to outstanding balance need to provided instead of original deal amount
--inner join otpf on otbrnm||trim(otdlp)||trim(otdlr)=b.LEG_ACC_NUM --ADDED on 08-08-2017 based on Nancy mail dt 08-08-2017 and vijay confirmation--added due to outstanding balance need to provided instead of original deal amount
--group by fin_acc_num;
----------for free_text--------------
--drop table owpf_ld_cla;
--create table owpf_ld_cla as 
--select distinct fin_acc_num leg_acc,OWSD1,OWSD2,OWSD3,OWSD4  from map_acc a
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--inner join (select distinct owbrnm||trim(owdlp)||trim(owdlr) owpf_num ,OWSD1,OWSD2,OWSD3,OWSD4 from owpf where trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null and owmvt = 'P' and owmvts = 'C' ) owpf on owpf_num=b.LEG_ACC_NUM;
--------------------------- not corte table code--------------
--drop table cla_ld_acct_fin_int_rate;
--create table cla_ld_acct_fin_int_rate
--as
--select 
--a.fin_acc_num,csp.int_tbl_code tbl_code,base_pcnt_dr,base_pcnt_cr,nvl(c.nrml_int_pcnt,0) cr_nrml_int_pcnt, nvl(d.nrml_int_pcnt,0) dr_nrml_int_pcnt,acc_pref_rate,
--acc_pref_rate - (nvl(base_pcnt_dr,0) + nvl(d.nrml_int_pcnt,0))actual_pref_rate
--from map_acc a
--inner join (select distinct scab||scan||scas acc_num,acc_pref_rate,serial_deal from ld_deal_int_wise) bb on leg_branch_id||leg_scan||leg_scas=acc_num and a.leg_acc_num=to_char(serial_deal)
--inner join cla_ld_acct_details c on c.fin_acc_num=a.fin_acc_num
--left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on
--a.schm_code = csp.schm_code and a.currency = csp.crncy_code
--left join (select c.* from tbaadm.icv c
--inner join ( 
--select a.int_tbl_code,a.crncy_code,a.INT_TBL_VER_NUM,min(a.INT_VERSION) INT_VERSION 
--from tbaadm.icv a
--inner join ( 
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM 
--from tbaadm.icv where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--where a.del_flg = 'N' and a.bank_id = get_param('BANK_ID')
--group by a.int_tbl_code,a.crncy_code, a.INT_TBL_VER_NUM) d 
--on d.int_tbl_code=c.int_tbl_code and d.crncy_code=c.crncy_code and d.INT_TBL_VER_NUM=c.INT_TBL_VER_NUM 
--and c.INT_VERSION=d.INT_VERSION
--where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and  c.START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  csp.int_tbl_code =b.int_tbl_code  and  csp.CRNCY_CODE = b.CRNCY_CODE
--left join (select a.* from tbaadm.LAVS a
--inner join (
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
--from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--and int_slab_dr_cr_flg = 'C'
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
--where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
--left join (select a.* from tbaadm.LAVS a
--inner join (
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
--from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--and int_slab_dr_cr_flg = 'D'
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
--where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
--where trim(csp.int_tbl_code)<>'CORTE';
--------------------corte table code less than 12 months tenor
--drop table cla_ld_acct_fin_int_rate_les12;
--create table cla_ld_acct_fin_int_rate_les12 as
--SELECT a.fin_acc_num,csp.int_tbl_code tbl_code,base_pcnt_dr,base_pcnt_cr,nvl(trim(c.nrml_int_pcnt),0) cr_nrml_int_pcnt, nvl(trim(d.nrml_int_pcnt),0) dr_nrml_int_pcnt,acc_pref_rate,
--nvl(trim(acc_pref_rate),0) - (nvl(trim(base_pcnt_dr),0) + nvl(trim(d.nrml_int_pcnt),0))actual_pref_rate,d.LOAN_TENOR_MTHS LOAN_TENOR_MTHS_dr,c.LOAN_TENOR_MTHS LOAN_TENOR_MTHS_cr
--from map_acc a
--inner join (select distinct scab||scan||scas acc_num,acc_pref_rate,serial_deal from ld_deal_int_wise) bb on leg_branch_id||leg_scan||leg_scas=acc_num and a.leg_acc_num=to_char(serial_deal)
--inner join cla_ld_acct_details c on c.fin_acc_num=a.fin_acc_num  
--left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on
--a.schm_code = csp.schm_code and a.currency = csp.crncy_code
--left join (select c.* from tbaadm.icv c
--inner join ( 
--select a.int_tbl_code,a.crncy_code,a.INT_TBL_VER_NUM,min(a.INT_VERSION) INT_VERSION 
--from tbaadm.icv a
--inner join ( 
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM 
--from tbaadm.icv where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--where a.del_flg = 'N' and a.bank_id = get_param('BANK_ID')
--group by a.int_tbl_code,a.crncy_code, a.INT_TBL_VER_NUM) d 
--on d.int_tbl_code=c.int_tbl_code and d.crncy_code=c.crncy_code and d.INT_TBL_VER_NUM=c.INT_TBL_VER_NUM 
--and c.INT_VERSION=d.INT_VERSION
--where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and  c.START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  csp.int_tbl_code =b.int_tbl_code  and  csp.CRNCY_CODE = b.CRNCY_CODE
--left join (select a.* from tbaadm.LAVS a
--inner join (
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
--from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--and int_slab_dr_cr_flg = 'C'
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
--where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
--left join (select a.* from tbaadm.LAVS a
--inner join (
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
--from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--and int_slab_dr_cr_flg = 'D' and LOAN_TENOR_MTHS<=12
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D' and LOAN_TENOR_MTHS<=12
--where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
--where trim(csp.int_tbl_code)='CORTE' 
--and (case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     else 0 end)<=12;
-------------------------corte table code more than 12 months tenor-------------------------
--drop table cla_ld_acct_fin_int_rate_mor12;
--create table cla_ld_acct_fin_int_rate_mor12 as
--SELECT a.fin_acc_num,csp.int_tbl_code tbl_code,base_pcnt_dr,base_pcnt_cr,nvl(trim(c.nrml_int_pcnt),0) cr_nrml_int_pcnt, nvl(trim(d.nrml_int_pcnt),0) dr_nrml_int_pcnt,acc_pref_rate,
--nvl(trim(acc_pref_rate),0) - (nvl(trim(base_pcnt_dr),0) + nvl(trim(d.nrml_int_pcnt),0))actual_pref_rate,d.LOAN_TENOR_MTHS LOAN_TENOR_MTHS_dr,c.LOAN_TENOR_MTHS LOAN_TENOR_MTHS_cr
--from map_acc a
--inner join (select distinct scab||scan||scas acc_num,acc_pref_rate,serial_deal from ld_deal_int_wise) bb on leg_branch_id||leg_scan||leg_scas=acc_num and a.leg_acc_num=to_char(serial_deal)
--inner join cla_ld_acct_details c on c.fin_acc_num=a.fin_acc_num  
--left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on
--a.schm_code = csp.schm_code and a.currency = csp.crncy_code
--left join (select c.* from tbaadm.icv c
--inner join ( 
--select a.int_tbl_code,a.crncy_code,a.INT_TBL_VER_NUM,min(a.INT_VERSION) INT_VERSION 
--from tbaadm.icv a
--inner join ( 
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM 
--from tbaadm.icv where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--where a.del_flg = 'N' and a.bank_id = get_param('BANK_ID')
--group by a.int_tbl_code,a.crncy_code, a.INT_TBL_VER_NUM) d 
--on d.int_tbl_code=c.int_tbl_code and d.crncy_code=c.crncy_code and d.INT_TBL_VER_NUM=c.INT_TBL_VER_NUM 
--and c.INT_VERSION=d.INT_VERSION
--where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and  c.START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  csp.int_tbl_code =b.int_tbl_code  and  csp.CRNCY_CODE = b.CRNCY_CODE
--left join (select a.* from tbaadm.LAVS a
--inner join (
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
--from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--and int_slab_dr_cr_flg = 'C'
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
--where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
--left join (select a.* from tbaadm.LAVS a
--inner join (
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
--from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--and int_slab_dr_cr_flg = 'D' and LOAN_TENOR_MTHS>12
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D' and LOAN_TENOR_MTHS>12
--where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
--where trim(csp.int_tbl_code)='CORTE' 
--and (case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     else 0 end)>12;
----------------------------------------------------------------------------------------------------------------------------------
--insert into Cl001_O_TABLE
--select   distinct
----acc_num NVARCHAR2(16),
--rpad(a.fin_acc_num,16,' '),
----Cust_Credit_Pref_Per NVARCHAR2(10),
--lpad(' ',10,' '),
----Cust_Debit_Pref_Per NVARCHAR2(10),
--lpad(' ',10,' '),
----Acct_ID_Credit_Pref_Per NVARCHAR2(10),
--lpad(' ',10,' '),
----Acct_ID_Debit_Pref_Per NVARCHAR2(10),
--lpad(case 
--when trim(c.fin_acc_num) is not null and TO_number(c.ACTUAL_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(c.ACTUAL_PREF_RATE)  
--when trim(c.fin_acc_num) is not null and TO_number(c.ACTUAL_PREF_RATE)not  between 0.001 and 0.999 then to_char(nvl(c.ACTUAL_PREF_RATE,0))
--when trim(d.fin_acc_num) is not null and TO_number(d.ACTUAL_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(d.ACTUAL_PREF_RATE)  
--when trim(d.fin_acc_num) is not null and TO_number(d.ACTUAL_PREF_RATE) not between 0.001 and 0.999 then to_char(nvl(d.ACTUAL_PREF_RATE,0))
--when trim(e.fin_acc_num) is not null and TO_number(e.ACTUAL_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(e.ACTUAL_PREF_RATE)  
--else to_char(nvl(e.ACTUAL_PREF_RATE,0)) 
--end,10,' '),
----Pegged_Flag NVARCHAR2(1),
----rpad(GSP.PEG_INT_FOR_AC_FLG,1,' '),
--rpad('Y',1,' '),--changed on 15-06-2017 new issue came in while upload. change done by Kumar
----Peg_Freq_in_Months NVARCHAR2(4),
--rpad(' ',4,' '),
----Peg_Freq_in_Days NVARCHAR2(3),
--rpad(' ',3,' '),
----int_Route_Flag NVARCHAR2(1),
----rpad('O',1,' '),
--rpad(nvl(tbaadm.lsp.int_route_flg,' '),1,' '),---Based on discussion with sandeep and vijay --changed default value 'O' to scheme level flag on 15-07-2017
----Acct_Currency_Code NVARCHAR2(3),
--rpad(currency,3,' '),
----Sol_ID NVARCHAR2(8),
--rpad(a.fin_sol_id,8,' '),
----GL_Sub_Head_Code NVARCHAR2(5),
----rpad(nvl(tbaadm.gss.gl_sub_head_code,' '),5,' '),
--rpad(nvl(a.gl_sub_headcode,' '),5,' '),
----Schm_Code NVARCHAR2(5),
--rpad(a.schm_code,5,' '),
----CIF_ID NVARCHAR2(32),
--rpad(a.fin_cif_id,32,' '),
----Acct_Open_Date NVARCHAR2(8),
--rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD')
--    else ' ' end,8,' '),  
----Sanction_Limit NVARCHAR2(17),
--lpad(NVL(LCAMTU,0)+abs(to_number(omnwp/POWER(10,c8pf.C8CED))),17,' ') end, ---lcamtu condition added on 07-07-2017 based on nancy mail 05-07-2017
----Ledger_num NVARCHAR2(3),
--rpad(' ',3,' '),
----   v_Sector_Code           CHAR(5)KTWORKS
----rpad(convert_codes('SECTOR_CODE',trim(gf.GFC2R)),5,' '),
--rpad(convert_codes('SECTOR_CODE',trim(SCC2R)),5,' '),--changed on 17-08-2017 as per vijay discussion with Sandeep 
----   v_Sub_Sector_Code           CHAR(5)KTWORKS
----rpad(nvl(trim(gf.GFC2R),'ZZZ'),5,' '),
--rpad(nvl(trim(SCC2R),'ZZZ'),5,' '),--changed on 17-08-2017 as per vijay discussion with Sandeep 
----Pur_of_Advance NVARCHAR2(5),
--rpad(nvl(trim(SCC2R),'999'),5,' '),
----Nature_of_Advance NVARCHAR2(5),
--rpad('999',5,' '),
----F_c_3 NVARCHAR2(5),
--rpad(' ',5,' '),
----Sanction_ref_num NVARCHAR2(25),
--rpad(' ',25,' '),
----Sanction_Limit_Date NVARCHAR2(8),
--rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD') 
--    else ' ' end,8,' '),  
----Sanction_Level_Code NVARCHAR2(5),
--rpad('999',5,' '),
----Limit_Expiry_Date NVARCHAR2(8),
--rpad(case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'YYYYMMDD')
--     else ' ' end,8,' '),
----Sanction_Authority_Code NVARCHAR2(5),
--rpad('999',5,' '),
----Loan_Paper_Date NVARCHAR2(8),
--rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD') else ' ' end,8,' '),      
----Operative_Acct_ID NVARCHAR2(16),
--rpad(case when oper_num is not null then oper_num else ' ' end ,16,' '),
----Operative_Currency_Code NVARCHAR2(3),
--rpad(case when oper_ccy is not  null then oper_ccy  else ' ' end ,3,' '),
----Operative_Sol_ID NVARCHAR2(8),
--rpad(case when oper_sol_id is not  null then oper_sol_id else ' ' end ,8,' '),
----Demand_Satisfy_Method NVARCHAR2(1),
--rpad(case when oper_num is not null then  'E' else 'N' end,1,' '),
----Lien_on_Operative_Acct_Flag NVARCHAR2(1),
--rpad(case when oper_num is not null then LSP.lien_on_oper_Acct_flg else 'N' end,1,' '), 
----Demand_Satisfaction_Rate_Code NVARCHAR2(5),
--rpad(' ',5,' '),
----int_table_code NVARCHAR2(5),
--rpad( case when nvl(f.REPRICING_PLAN,'F')='F' then  'ZEROC' 
--       when trim(c.fin_acc_num) is not null then  nvl(c.TBL_CODE,'ZEROC')
--       when trim(d.fin_acc_num) is not null then nvl(d.TBL_CODE,'ZEROC')
--      else nvl(e.TBL_CODE,'ZEROC') end ,5,' '),
----int_on_principal_Flag NVARCHAR2(1),
--rpad(LSP.int_on_p_flg,1,' '),
----Penal_overdue_pr_demand_Flag NVARCHAR2(1),
--rpad(LSP.pi_on_pdmd_ovdu_flg,1,' '),
----Pri_Dem_Od_end_month_Flag NVARCHAR2(1),
--rpad(LSP.pdmd_ovdu_eom_flg,1,' '),
----int_On_int_Demand_Flag NVARCHAR2(1),
--rpad(tbaadm.LSP.int_on_idmd_flg,1,' '),-----Based on discussion with sandeep and vijay --changed default value 'O' to scheme level flag on 15-07-2017
----rpad('N',1,' '),
----penal_overdue_int_demand_Flag NVARCHAR2(1),
--rpad(LSP.pi_on_idmd_ovdu_flg,1,' '),
----int_Dem_Od_End_Month_Flag NVARCHAR2(1),
--rpad(LSP.idmd_ovdu_eom_flg,1,' '),
----Transfer_Effective_Date NVARCHAR2(8),
--rpad(to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),'YYYYMMDD'),8,' '),   
----Cumul_Normal_int_amount NVARCHAR2(17),
--rpad(' ',17,' '),
----Cumul_penal_int_amount NVARCHAR2(17),
--rpad(' ',17,' '),
----cumul_add_int_amount NVARCHAR2(17),
--rpad(' ',17,' '),
----Liab_as_on_Transfer_Eff_date NVARCHAR2(17),
--rpad(abs(to_number(otdla))/POWER(10,c8pf.C8CED),17,' '),
----Disb_in_Pres_Schedule NVARCHAR2(17),
--lpad(case  when to_number(g.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) > 0  then to_number(g.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)
--  else 0 end,17,' '),
----Last_int_posted_date NVARCHAR2(8),
--rpad( case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'YYYYMMDD')
--               when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD') else ' ' end,8,' '),   
----Repayment_Schedule_Date NVARCHAR2(8),
--rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD') else ' ' end,8,' '),      
----Repayment_Period_in_months NVARCHAR2(3),
--rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     else 0 end
--     ,3,' '),                                                             
----Repayment_Period_in_Days NVARCHAR2(3),
--lpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
--          to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
--     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
--else 0 end
--,3,' '),
----Past_Due_Flag NVARCHAR2(1),
--rpad('N',1,' '),
----Past_Due_date NVARCHAR2(8),
--rpad(' ',8,' '),
----Normal_GL_subhead_Code NVARCHAR2(5),
--rpad(' ',5,' '),
----Normal_int_Suspense_Amount NVARCHAR2(17),
--rpad(' ',17,' '),
----Penal_int_Suspense_Amount NVARCHAR2(17),
--rpad(' ',17,' '),
----Charge_Off_Flag NVARCHAR2(1),
--rpad('N',1,' '),
----Charge_Off_date NVARCHAR2(8),
--rpad(' ',8,' '),
----Charged_Off_Principal_Amount NVARCHAR2(17),
--rpad(' ',17,' '),
----Charged_off_int_Amount NVARCHAR2(17),
--rpad(' ',17,' '),
----Principal_rec NVARCHAR2(17),
--rpad(' ',17,' '),
----int_rec NVARCHAR2(17),
--rpad(' ',17,' '),
----Source_Dealer_Code NVARCHAR2(20),
--rpad(' ',20,' '),
----Disburse_Dealer_Code NVARCHAR2(20),
--rpad(' ',20,' '),
----Apply_late_fee_Flag NVARCHAR2(1),
--rpad(lsp.apply_late_fee_flg,1,' '),
----Lt_Fee_GPeriod_Months NVARCHAR2(3),
--rpad(LATEFEE_GRACE_PERD_MNTHS,3,' '),
----Lt_fee_gPeriod_days NVARCHAR2(3),
--rpad(LATEFEE_GRACE_PERD_days,3,' '),
----Days_Past_Due_counter NVARCHAR2(5),
--rpad('0',5,' '),
----Sum_pri_dem_amt NVARCHAR2(17),
--lpad('0',17,' '),
----Payoff_Flag NVARCHAR2(1),
--rpad('N',1,' '),
----Exclude_for_combined_st NVARCHAR2(1),
--rpad(' ',1,' '),
----st_Cif_Id NVARCHAR2(32),
--rpad(' ',32,' '),
----Transfer_Cycle_String NVARCHAR2(45),
--rpad( '000000000000000000000000000000000000000000000',45,' '),
----Value_of_Asset NVARCHAR2(17),
--rpad(' ',17,' '),
----Occ_code_of_the_cust NVARCHAR2(5),
--rpad(convert_codes('SUNDRY_ANALYSIS_CODE',trim(SCSAC)),5,' '),
----Borrower_category_code NVARCHAR2(5),
--rpad(' ',5,' '),
----Mode_of_Advance NVARCHAR2(5),
--rpad(' ',5,' '),
----Type_of_Advance NVARCHAR2(5),
--rpad(' ',5,' '),
----guarantee_coverage_Code NVARCHAR2(5),
--rpad(' ',5,' '),
----Industry_Type NVARCHAR2(5),
--rpad(' ',5,' '),
----F_c_1 NVARCHAR2(5),
--rpad(' ',5,' '),
----F_c_2 NVARCHAR2(5),
--rpad(' ',5,' '),
----F_c_4 NVARCHAR2(5),
--rpad(' ',5,' '),
----F_c_5 NVARCHAR2(5),
--rpad(' ',5,' '),
----F_c_6 NVARCHAR2(5),
--rpad(' ',5,' '),
----F_c_7 NVARCHAR2(5),
--rpad(' ',5,' '),
----F_c_8 NVARCHAR2(5),
--rpad(' ',5,' '),
----F_c_9 NVARCHAR2(5),
--rpad(' ',5,' '),
----F_c_10 NVARCHAR2(5),
--rpad(' ',5,' '),
----Acct_Location_Code NVARCHAR2(5),
--rpad(' ',5,' '),
----Credit_File_ref_Id NVARCHAR2(15),
--rpad(' ',15,' '),
----Last_Compound_Date NVARCHAR2(8),
----rpad(case when tbaadm.LSP.int_on_idmd_flg ='Y' then to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),'YYYYMMDD') else ' ' end ,8,' '),
--rpad(' ',8,' '),
----Daily_Compound_int_Flag NVARCHAR2(1),
----rpad(tbaadm.LSP.int_on_idmd_flg,1,' '),
--rpad(GSP.DAILY_COMP_INT_FLG,1,' '),
----EI_period_start_date NVARCHAR2(8),
--rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'YYYYMMDD') 
--    else ' ' end,8,' '),
----EI_period_End_date NVARCHAR2(8),
--rpad(case when otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt<>'9999999' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'YYYYMMDD') else ' ' end,8,' '),
----Charge_Route_flag NVARCHAR2(1),
--rpad(LSP.chrg_route_flg,1,' '),--changed on 15-06-2017 new issue came in while upload. change done by Kumar--based on discussion with vijay and sandeep uncommented on 15-07-2017
----rpad('O',1,' '),
----Total_num_of_Deferments NVARCHAR2(2),
--rpad(' ',2,' '),
----Def_in_curr_schedule NVARCHAR2(2),
--rpad(' ',2,' '),
----Col_int_in_advance_flag NVARCHAR2(1),  AS PER NEW FORMAT NOT REQUIRED
----rpad(' ',1,' '),
----Res_acc NVARCHAR2(16),    AS PER NEW FORMAT NOT REQUIRED
----rpad(' ',16,' '),
----Draw_down_lvl_rate_flag NVARCHAR2(1),
--rpad('N',1,' '),----changed y to n on 15-07-2017 based on discussion with vijay and sandeep
----EI_flag NVARCHAR2(1),
--rpad(nvl(trim(LSP.ei_schm_flg),'N'),1,' '),
----Installment_date_extd NVARCHAR2(8),
--rpad(' ',8,' '),
----Extended_overdue_Date NVARCHAR2(8),
--rpad(' ',8,' '),
----Def_app_int_rate_flag NVARCHAR2(1),
--rpad(' ',1,' '),
----Def_app_int_rate NVARCHAR2(10),
--rpad(' ',10,' '),
----Deferred_int_Amount NVARCHAR2(17),
--rpad(' ',17,' '),
----Last_prepayment_date NVARCHAR2(8),
--rpad(' ',8,' '),
----rf_end_date NVARCHAR2(8),
--rpad(' ',8,' '),
----rf_ref_num NVARCHAR2(25),
--rpad(' ',25,' '),
----Charge_off_type NVARCHAR2(1),
--rpad(' ',1,' '),
----Cry_reqd NVARCHAR2(1),
--rpad(' ',1,' '),
----Cry_Currency NVARCHAR2(3),
--rpad(' ',3,' '),
----Contract_date NVARCHAR2(8),
--rpad(' ',8,' '),
----Crys_A_c NVARCHAR2(16),
--rpad(' ',16,' '),
----acc_Status NVARCHAR2(1),
--rpad(' ',1,' '),
----Comm_fee_methods NVARCHAR2(1),
--rpad(' ',1,' '),
----Shift_installment_flag NVARCHAR2(1),
--rpad(' ',1,' '),
----Parent_cif_id NVARCHAR2(32),
--rpad(' ',32,' '),
----Peg_Review_Date NVARCHAR2(8),
--rpad(' ',8,' '),
----rf_Ref_num1 NVARCHAR2(25),
--rpad(' ',25,' '),
----Penal_int_based_on_Outstanding NVARCHAR2(1),
--case when LSP.pi_on_pdmd_ovdu_flg = 'N' then ' ' else LSP.pi_based_on_outstanding end,
----Del_Reschedule_Method_Flag NVARCHAR2(1),
--rpad(' ',1,' '),
----Probation_Period_in_Months NVARCHAR2(3),
--rpad(' ',3,' '),
----Probation_Period_in_Days NVARCHAR2(3),
--rpad(' ',3,' '),
----Total_num_of_Switch_Over NVARCHAR2(3),
--rpad(' ',3,' '),
----Non_Starter_Flag NVARCHAR2(1),
--rpad(' ',1,' '),
----Repricing_Plan NVARCHAR2(1),
--rpad(nvl(f.REPRICING_PLAN,'F'),1,' '),
----Fixed_Rate_Term_in_Months NVARCHAR2(3),
--rpad(' ',3,' '),
----Fixed_Rate_Term_in_Years NVARCHAR2(3),
--rpad(' ',3,' '),
----Floating_int_Table_Code NVARCHAR2(5),
--rpad(' ',5,' '),
----Fl_Rep_Freq NVARCHAR2(3),
--rpad(' ',3,' '),
----Fl_Rep_Freq_In_Days NVARCHAR2(3),
--rpad(' ',3,' '),
----Auto_Reschedule_Not_Allowed NVARCHAR2(1),
--rpad( nvl(LSP.auto_reshdl_not_allowed,' '),1,' '),
----Res_Od_Principal NVARCHAR2(17),
--rpad(' ',17,' '),
----Res_Od_int NVARCHAR2(17),
--rpad(' ',17,' '),
----Loan_Type NVARCHAR2(1),
--rpad('N',1,' '),
----Pay_Off_Reason_Code NVARCHAR2(5),
--rpad(' ',5,' '),
----rf_Sanction_Date NVARCHAR2(8),
--rpad(' ',8,' '),
----rf_Amount NVARCHAR2(17),
--rpad(' ',17,' '),
----sub_Acct_Id NVARCHAR2(16),
--rpad(' ',16,' '),
----sub_Agency NVARCHAR2(5),
--rpad(' ',5,' '),
----sub_Claimed_Date NVARCHAR2(8),
--rpad(' ',8,' '),
----sub_Activity_Code NVARCHAR2(10),
--rpad(' ',10,' '),
----Debit_Acknowledgement_Type NVARCHAR2(1),
--rpad(' ',1,' '),
----rf_Sanction_num NVARCHAR2(25),
--rpad(' ',25,' '),
----rf_Claimed_Date NVARCHAR2(8),
--rpad(' ',8,' '),
----sub_Amount NVARCHAR2(17),
--rpad(' ',17,' '),
----sub_Received_Date NVARCHAR2(8),
--rpad(' ',8,' '),
----Comp_Rest_Ind_Flag NVARCHAR2(1),
--rpad(' ',1,' '),
----Collect_int_Flag NVARCHAR2(1),
----rpad(' ',1,' '),
--rpad('Y',1,' '),
----Despatch_Mode NVARCHAR2(1),
--rpad('N',1,' '),
----Acct_Manager NVARCHAR2(15),
--rpad( case when nrd.officer_code is not null  and trim(nrd.loginid) is not null  then to_char(trim(nrd.loginid))
--else nvl(convert_codes('RMCODE',trim(scpf.scaco)),'UBSADMIN') end,15,' '), -- changed on 06-01-2017 as per Vijay Confirmation
----Mode_of_Oper_Code NVARCHAR2(5),
--rpad(' ',5,' '),
----st_Frequency_Type NVARCHAR2(1),
--rpad(' ',1,' '),
----Week_num_for_st_Date NVARCHAR2(1),
--rpad(' ',1,' '),
----Week_Day_for_st_Date NVARCHAR2(1),
--rpad(' ',1,' '),
----Start_Date_for_acc_st NVARCHAR2(2),
--rpad(' ',2,' '),
----st_Freq_Holidays NVARCHAR2(1),
--rpad(' ',1,' '),
----st_of_the_acc NVARCHAR2(1),
--rpad('N',1,' '),
----Next_Print_date NVARCHAR2(8),
--rpad(' ',8,' '),
----min_Int_Per_Deb NVARCHAR2(10),
--rpad(' ',10,' '),
----max_Int_Per_Deb NVARCHAR2(10),
--rpad(' ',10,' '),
----Product_Group NVARCHAR2(5),
--rpad(' ',5,' '),
----Free_Text NVARCHAR2(240),
--    case when trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null and trim(JGCF) is not null then     to_char(rpad('Govt fund :'|| trim(OWSD1)||' '||trim(OWSD2)||' '||trim(OWSD3)||' '||trim(OWSD4)||'Deal Notes :' ||trim(JGCF) ,240,' '))
--    when trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null and trim(JGCF) is null then     to_char(rpad('Govt fund :' ||trim(OWSD1)||' '||trim(OWSD2)||' '||trim(OWSD3)||' '||trim(OWSD4),240,' '))
--    when trim(OWSD1||OWSD2||OWSD3||OWSD4) is null and trim(JGCF) is not null then     to_char(rpad('Deal Notes :'||trim(JGCF),240,' '))
--    else rpad(' ',240,' ') end,
----penal_prod_mthd__flg NVARCHAR2(1),
--rpad(LSP.full_penal_mthd_flg,1,' '),
----penal_rate_mthd__flg NVARCHAR2(1),
--rpad(' ',1,' '),
----Iban_num NVARCHAR2(34),
--rpad(' ',34,' '),
----IAS_CLASSIFICATION_CODE NVARCHAR2(5),
--rpad(' ',5,' '),
----Negotiated_Rate_Debit_Percent NVARCHAR2(10), AS PER NEW FORMAT NOT REQUIRED
----rpad(' ',10,' '),
----int_Rule_Code NVARCHAR2(5),
--rpad(' ',5,' '),
----Recall_Flag NVARCHAR2(1),
--rpad(' ',1,' '),
----Recall_Date NVARCHAR2(8),
--rpad(' ',8,' '),
----dif_PS_Freq_For_Rel_Party NVARCHAR2(1),
--rpad(' ',1,' '),
----dif_Swift_Freq_For_Rel_Party NVARCHAR2(1),
--rpad(' ',1,' '),
----Penal_int_table_code NVARCHAR2(5),
--rpad(' ',5,' '),
----Penal_Preferential_Percent NVARCHAR2(10),
--rpad(' ',10,' '),
----int_table_Version NVARCHAR2(5),
--rpad(' ',5,' '),
----Address_Type NVARCHAR2(12),
--rpad(' ',12,' '),
----Related_Party_Phone_Type NVARCHAR2(12),
--rpad(' ',12,' '),
----Related_Party_Email_Type NVARCHAR2(12),
--rpad(' ',12,' '),
----Advance_int_amount NVARCHAR2(17),
--rpad(' ',17,' '),
----Amortised_Amount NVARCHAR2(17),
--rpad(' ',17,' '),
----Adv_int_Coll_upto_Date NVARCHAR2(8),
--rpad(' ',8,' '),
----Accr_Rate NVARCHAR2(9),
--rpad(' ',9,' '),
----Accr_Penal_int_rec NVARCHAR2(17),
--rpad(' ',17,' '),
----Penal_int_rec NVARCHAR2(17),
--rpad(' ',17,' '),
----Coll_Int_rec NVARCHAR2(17),
--rpad(' ',17,' '),
----Coll_Penal_Intt_rec NVARCHAR2(17)
--rpad(' ',17,' '),
----MARKUP_INT_RATE_APPL_FLG NVARCHAR2(1),    ADDED AS PER NEW FORMAT
--rpad(' ',1,' '),
----PREFERRED_CAL_BASE NVARCHAR2(2),    ADDED AS PER NEW FORMAT
--rpad(' ',2,' '),
----AC_LEVEL_SPREAD NVARCHAR2(10),    ADDED AS PER NEW FORMAT
--rpad(' ',10,' '),
----INT_RATE_PRD_IN_MONTHS NVARCHAR2(4),    ADDED AS PER NEW FORMAT
--rpad(' ',4,' '),
----INT_RATE_PRD_IN_DAYS NVARCHAR2(3),    ADDED AS PER NEW FORMAT
--rpad(' ',3,' '),
----ACCT_TYPE NVARCHAR2(5),    ADDED AS PER NEW FORMAT
--rpad(' ',5,' '),
----INT_PEN_BREAKUP_REQD_FLG NVARCHAR2(1),    ADDED AS PER NEW FORMAT
--rpad(' ',1,' '),
----CUMM_COMPINT_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
--rpad(' ',17,' '),
----CUMM_PENALINT_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
--rpad(' ',17,' '),
----CUMM_PENALPRNC_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
--rpad(' ',17,' '),
----CUMM_COMPPRNC_INT NVARCHAR2(17),    ADDED AS PER NEW FORMAT
--rpad(' ',17,' '),
----APPLY_INT_ON_PYMT NVARCHAR2(1),    ADDED AS PER NEW FORMAT
--rpad(' ',1,' '),
----CCY_HOL_TREATMENT_FLG NVARCHAR2(1),    ADDED AS PER NEW FORMAT
--rpad('N',1,' '),
----FIRST_DRDN_VAL_DATE_INT_RATE NVARCHAR2(1),    ADDED AS PER NEW FORMAT
--rpad(' ',1,' '),
----INTERPOLATION_METHOD NVARCHAR2(1),    ADDED AS PER NEW FORMAT
--rpad(' ',1,' '),
----SYN_ACCOUNT_TYPE NVARCHAR2(1),    ADDED AS PER NEW FORMAT
--rpad(' ',1,' '),
----TRANCHE_ID NVARCHAR2(16),    ADDED AS PER NEW FORMAT
--rpad(' ',16,' '),
----SYN_AGENT_REF_NUM NVARCHAR2(36),    ADDED AS PER NEW FORMAT
--rpad(' ',36,' '),
----INTERPOL_REQD_CURHOL_BRKN_PRD NVARCHAR2(1),    ADDED AS PER NEW FORMAT
--rpad(' ',1,' '),
----INT_RATE_REF_CRNCY_CODE NVARCHAR2(3),    ADDED AS PER NEW FORMAT
--rpad(' ',3,' '),
----PROJECT_CRNCY_CODE NVARCHAR2(3),    ADDED AS PER NEW FORMAT
--rpad(' ',3,' '),
----RATE_FIXING_METHOD NVARCHAR2(1),    ADDED AS PER NEW FORMAT
--rpad(' ',1,' '),
----SECURITY_INDICATOR NVARCHAR2(10),    ADDED AS PER NEW FORMAT
--rpad(' ',10,' '),
----DEBT_SENIORITY NVARCHAR2(1),    ADDED AS PER NEW FORMAT
--rpad(' ',1,' '),
----SECURITY_CODE NVARCHAR2(8)    ADDED AS PER NEW FORMAT
--rpad(' ',8,' ')
--from map_acc a
--inner join cla_ld_acct_details b on b.fin_acc_num=a.fin_acc_num
--left join cla_ld_acct_fin_int_rate c on  c.fin_acc_num=a.fin_acc_num
--left join cla_ld_acct_fin_int_rate_les12 d on  d.fin_acc_num=a.fin_acc_num
--left join cla_ld_acct_fin_int_rate_mor12 e on  e.fin_acc_num=a.fin_acc_num
--left join (select * from tbaadm.lsp where lsp.del_flg <> 'Y' and lsp.bank_id=get_param('BANK_ID'))lsp on lsp.schm_code = a.schm_code and a.currency=lsp.crncy_code 
--left join (select * from tbaadm.gsp where gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID'))gsp on gsp.schm_code = a.schm_code  
--left join (select * from tbaadm.gss where gss.del_flg <> 'Y' and gss.DEFAULT_FLG ='Y' and gss.bank_id=get_param('BANK_ID'))gss on gss.schm_code = a.schm_code  
--left join (select * from map_cif where del_flg<>'Y' and is_joint <> 'Y') map_cif on map_cif.FIN_CIF_ID=a.FIN_CIF_ID
--left join gfpf gf on trim(gf.gfclc)=trim(map_cif.gfclc) and  trim(gf.gfcus)=trim(map_cif.gfcus)  and gf.gfcpnc=MAP_CIF.GFCPNC and trim(GFC2R) is not null
--inner join c8pf on c8ccy = currency
--left join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
--left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
----left join (select distinct  c.fin_acc_num,oper.fin_acc_num oper_num,oper.fin_sol_id oper_sol_id,oper.currency oper_ccy from map_acc c
----inner join ld_deal_int_wise a on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and c.leg_acc_num=to_char(serial_deal)
----inner join ompf a on ombrnm||trim(omdlp)||trim(omdlr)=a.leg_acc_num
----inner join map_acc oper on  oper.leg_branch_id||oper.leg_scan||oper.leg_scas=omabf||trim(omanf)||trim(omasf)
----where --c.schm_code='LD' and --commented on 14-06-2017 for CLA changes
----oper.schm_type in ('SBA','CAA','ODA'))oper on oper.fin_acc_num=a.fin_acc_num
--left join (select a.fin_acc_num,oper_num,oper.fin_sol_id oper_sol_id,oper.currency oper_ccy from (
--select distinct  c.fin_acc_num ,max(b.fin_acc_num) oper_num from map_acc c
--inner join ld_deal_int_wise a on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and c.leg_acc_num=to_char(serial_deal)
--inner join ompf a on ombrnm||trim(omdlp)||trim(omdlr)=a.leg_acc_num
--inner join map_acc b on  b.leg_branch_id||b.leg_scan||b.leg_scas=omabf||trim(omanf)||trim(omasf)
--where --c.schm_code='LD' and --commented on 14-06-2017 for CLA changes
--b.schm_type in ('SBA','CAA','ODA') group by c.fin_acc_num)a inner join map_acc oper on oper.fin_acc_num=a.fin_acc_num)oper on oper.fin_acc_num=a.fin_acc_num
--left join repricing_plan_map f on f.schm_code=a.schm_code
--left join ompf_ld_cla1 g on g.fin_acc_num=a.fin_acc_num ---gop-appended 1 to tablename
--left join owpf_ld_cla h on leg_acc=a.fin_acc_num
--LEFT JOIN (select fin_num,sum(lcamtu) lcamtu from (
--select distinct C.fin_acc_num FIN_NUM,(lcamtu/power(10,c8ced))lcamtu,lccmr from map_acc c
--inner join ld_deal_int_wise a on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and c.leg_acc_num=to_char(serial_deal)
--inner join ldpf on ldbrnm||trim(lddlp)||trim(lddlr)=a.leg_acc_num
--inner join lcpf on lccmr=ldcmr
--inner join C8PF ON C8CCY=CURRENCY)
--GROUP BY fin_num)PEND_COMMIT_AMT ON  PEND_COMMIT_AMT.FIN_NUM=A.FIN_ACC_NUM
--left join jgpf on jgbrnm||trim(jgdlp)||trim(jgdlr) = a.leg_acc_num;
--commit;
delete from Cl001_O_TABLE where rowid not in (select min(rowid) from Cl001_O_TABLE group by acc_num);
commit; 
exit; 
