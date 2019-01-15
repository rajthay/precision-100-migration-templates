
-- File Name		: custom_pca_disb.sql 
-- File Created for	: Upload file for disburshment details for PCA schmtype
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 19-06-2017
-------------------------------------------------------------------
--DROP TABLE OMPF_PCA;
--CREATE TABLE OMPF_PCA AS
--select trim(ombrnm)||trim(omdlp)||trim(omdlr)OMPF_LEG_NUM,sum(omnwp) omnwp
--from map_acc
--  inner join v5pf on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas 
--  left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
--  inner join ompf ON trim(ombrnm)||trim(omdlp)||trim(omdlr)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
--  where map_acc.schm_type='PCA' and map_acc.schm_code='LDADV'
--  and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '')
--  GROUP BY trim(ombrnm)||trim(omdlp)||trim(omdlr);
-----------------LEGACY INTEREST DETAILS BLOCK----------------------
drop table pca_int_tbl;
create table pca_int_tbl as
  SELECT trim(v5brnm)||trim(v5dlp)||trim(v5dlr)  int_acc_num, v5dlp,v5ccy, schm_code , v5brr, d4brar BASE_EQ_RATE, v5drr,d5drar DIFF_EQ_RATE, v5rtm,v5spr,v5rat, 
    CASE WHEN v5rat <> 0 THEN 'ZEROL' 
         else convert_codes('INT_TBL_CODE',v5brr) END INT_TBL_CODE,
    CASE 
    WHEN convert_codes('INT_TBL_CODE',v5brr) <> 'ZEROL' THEN v5rtm +nvl(d5drar,0)
    WHEN convert_codes('INT_TBL_CODE',trim(v5brr)) = 'ZEROL' and (trim(v5brr) is not null or trim(v5rtm) <> 0 )THEN nvl(d4brar,0) + v5rtm +nvl(d5drar,0)
         ELSE to_number(v5rat)
         END ACC_PREF_RATE,
         case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end acct_open_date
from map_acc
  inner join v5pf on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas 
  left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  LEFT JOIN d4pf ON v5brr = d4brr and d4dte = 9999999 
  LEFT JOIN d5pf ON v5drr = d5drr and d5dte = 9999999
  left join map_codes on leg_code=v5brr 
  where map_acc.schm_type='PCA' and map_acc.schm_code='LDADV'
  and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '');
create index pca_int_tbl_idx on pca_int_tbl(int_acc_num);
create index pca_int_tbl_idx1 on pca_int_tbl(acct_open_date);
-------------------------Finacle interest details and differential rate block-------------------
drop table pca_acc_fin_int_rate_less12;
create table pca_acc_fin_int_rate_less12
as
SELECT a.*,REPRICING_PLAN,csp.int_tbl_code tbl_code,X.base_pcnt_dr,X.base_pcnt_cr,nvl(c.nrml_int_pcnt,0) cr_nrml_int_pcnt, nvl(d.nrml_int_pcnt,0) dr_nrml_int_pcnt,acc_pref_rate - (nvl(X.base_pcnt_dr,0) + nvl(d.nrml_int_pcnt,0))actual_pref_rate
from pca_int_tbl a
LEFT JOIN (SELECT * FROM TBAADM.GSP WHERE DEL_FLG= 'N' AND bank_id = get_param('BANK_ID'))GSP ON A.SCHM_CODE = GSP.SCHM_CODE
left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on a.schm_code = csp.schm_code and a.v5ccy = csp.crncy_code
left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  csp.int_tbl_code =b.int_tbl_code and  csp.CRNCY_CODE = b.CRNCY_CODE 
and acct_open_date between b.start_date and b.MODIFY_END_DATE
left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))X on  X.int_tbl_code =b.BASE_int_tbl_code  
and  X.CRNCY_CODE = b.CRNCY_CODE and acct_open_date between X.start_date and X.MODIFY_END_DATE 
left join (select a.* from tbaadm.IVS a 
    inner join (select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM from tbaadm.IVS where del_flg = 'N' and bank_id = get_param('BANK_ID') and int_slab_dr_cr_flg = 'C' group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
left join (select a.* from tbaadm.IVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.IVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'D'
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(INT_ACC_NUM);----below lines are commented based on vijay mail dt 25-09-2017
--and (case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     else 0 end)<=12;
create index pca_int_tbl_idx_2 on pca_acc_fin_int_rate_less12(int_acc_num);
----below lines are commented based on vijay mail dt 25-09-2017
--drop table pca_acc_fin_int_rate_more12;
--create table pca_acc_fin_int_rate_more12
--as
--SELECT a.*,REPRICING_PLAN,'PCAEX' tbl_code,X.base_pcnt_dr,X.base_pcnt_cr,nvl(c.nrml_int_pcnt,0) cr_nrml_int_pcnt, nvl(d.nrml_int_pcnt,0) dr_nrml_int_pcnt,acc_pref_rate - (nvl(X.base_pcnt_dr,0) + nvl(d.nrml_int_pcnt,0))actual_pref_rate
--from pca_int_tbl a
--LEFT JOIN (SELECT * FROM TBAADM.GSP WHERE DEL_FLG= 'N' AND bank_id = get_param('BANK_ID'))GSP ON A.SCHM_CODE = GSP.SCHM_CODE
--left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on a.schm_code = csp.schm_code and a.v5ccy = csp.crncy_code
--left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  'PCAEX' =b.int_tbl_code and  csp.CRNCY_CODE = b.CRNCY_CODE 
--and acct_open_date between b.start_date and b.MODIFY_END_DATE
--left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))X on  X.int_tbl_code =b.BASE_int_tbl_code  
--and  X.CRNCY_CODE = b.CRNCY_CODE and acct_open_date between X.start_date and X.MODIFY_END_DATE
--left join (select a.* from tbaadm.IVS a 
--    inner join (select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM from tbaadm.IVS where del_flg = 'N' and bank_id = get_param('BANK_ID') and int_slab_dr_cr_flg = 'C' group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
--where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on 'PCAEX' =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
--left join (select a.* from tbaadm.IVS a
--inner join (
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
--from tbaadm.IVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--and int_slab_dr_cr_flg = 'D'
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
--where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on 'PCAEX' =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
--inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(INT_ACC_NUM)
--and (case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     else 0 end)>12;
--create index pca_int_tbl_idx_3 on pca_acc_fin_int_rate_more12(int_acc_num);
------------------------------------------------------------------------
truncate table pca_disb;
insert into pca_disb
select
  --ACCOUNT_NUMBER   NVARCHAR2(16),
  map_acc.fin_acc_num,
  --CRNCY_CODE       NVARCHAR2(3),
  map_acc.currency,
  --SOL_ID           NVARCHAR2(8),
  map_acc.fin_sol_id,
  --DS_AMT           NVARCHAR2(17),
  --abs(to_number(OMPF_PCA.omnwp/POWER(10,c8pf.C8CED))),
    to_number((otdla)/POWER(10,c8pf.C8CED)),
  --DS_CRNCY_CODE    NVARCHAR2(3),
  map_acc.currency,
  --DS_DATE          NVARCHAR2(10),
  case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') 
    else ' ' end,
  --DS_DUE_DATE      NVARCHAR2(10),
  case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY')
     else ' ' end,
  --PNL_INT_ST_DATE  NVARCHAR2(10),
  case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')+1,'DD-MM-YYYY')---as per niraj requirement on 22-07-2017 at the time of mk5a-observation. This has been added.
     else ' ' end,
  --OPER_ACC_NUM     NVARCHAR2(16),
  case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end,
  --INT_CODE         NVARCHAR2(5),
--csp.INT_TBL_CODE,
--NVL(LESS.TBL_CODE,MORE.TBL_CODE),--- INT TABLE CODE CHANGED ON 17-07-2017 BASED ON MK5 OBSERVATION AND INT TBL_CODE CODE CHANGED FROM ODPPC TO PCA12 AND PCAEX.
LESS.TBL_CODE,----below lines are commented based on vijay mail dt 25-09-2017
  --INT_CRNCY_CODE   NVARCHAR2(3),
  map_acc.currency,
  --PEGGED_FLG       NVARCHAR2(1),
  GSP.PEG_INT_FOR_AC_FLG,
  --PG_FREQ_IN_MON   NVARCHAR2(5),
  '',
  --PG_FREQ_IN_DAYS  NVARCHAR2(3),
  '',
  --CUST_PR_INT_DR   NVARCHAR2(10),
  '',
  --ACC_PR_INT_DR    NVARCHAR2(10),
  --nvl(less.ACTUAL_PREF_RATE,more.ACTUAL_PREF_RATE), --- INT TABLE CODE CHANGED ON 17-07-2017 BASED ON MK5 OBSERVATION AND INT TBL_CODE CODE CHANGED FROM ODPPC TO PCA12 AND PCAEX.
  less.ACTUAL_PREF_RATE,----below lines are commented based on vijay mail dt 25-09-2017
  --CHNL_PR_INT_DR   NVARCHAR2(10),
  '',
  --ECGC_FLG         NVARCHAR2(1),
  'N',
  --UPLOAD_STATUS    NVARCHAR2(1),
  '',
  --ACCT_SCHM        NVARCHAR2(5),
  map_acc.schm_code,
  --REMARKS          NVARCHAR2(70)
  trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)
  from map_acc
  inner join v5pf on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas 
  left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
  --inner join OMPF_PCA ON OMPF_LEG_NUM=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  inner join c8pf on c8ccy = otccy
  --inner join pca_account_finacle_int_rate int_tbl on trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)=int_acc_num
  left join pca_acc_fin_int_rate_less12 less on trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)=less.int_acc_num
  --left join pca_acc_fin_int_rate_more12 more on trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)=more.int_acc_num
  left join (select * from tbaadm.gsp where gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID'))gsp on gsp.schm_code = map_acc.schm_code  
  left join pca_operacc oper on  trim(oper.ompf_leg_num)=trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)
  left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code =map_acc.CURRENCY     
  where map_acc.schm_type='PCA' and map_acc.schm_code='LDADV'
  and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '');
  commit;
  exit;
   
