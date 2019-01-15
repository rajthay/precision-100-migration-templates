========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
PCA_DISB.sql 
drop table pca_ac_fin_int_rt_less12_Rep;
create table pca_ac_fin_int_rt_less12_rep
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
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(INT_ACC_NUM);
create index pca_int_tbl_idx_2_rp on pca_ac_fin_int_rt_less12_rep(int_acc_num);
drop table pca_acc_fin_int_rate_less121;
create table pca_acc_fin_int_rate_less121 as
select pc.*,ID_DR_PREF_PCNT from pca_ac_fin_int_rt_less12_Rep pc
left join v5pf on trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)=int_acc_num
left join map_acc on  trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas
left join tbaadm.gam on foracid=fin_acc_num
left join (select * from tbaadm.disb where bank_id='01')disb on  rpc_acid=gam.acid  and trim(disb.remarks)=trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)
LEFT JOIN (select i1.* from tbaadm.itc i1
  left join (select * from tbaadm.itc where bank_id='01' and entity_type='RDISB')i2 on (i1.entity_id=i2.entity_id and i1.INT_TBL_CODE_SRL_NUM > i2.INT_TBL_CODE_SRL_NUM)
  where i1.bank_id='01' and i2.entity_id is null)itc  ON  ITC.ENTITY_TYPE='RDISB' and   disb.DISB_ID=itc.entity_id ;
--drop table pca_int_rate_more12_rep;
--create table pca_int_rate_more12_rep
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
--create index pca_int_tbl_idx_3_rep on pca_int_rate_more12_rep(int_acc_num);
--drop table pca_acc_fin_int_rate_more121;
--create table pca_acc_fin_int_rate_more121 as
--select pc.*,ID_DR_PREF_PCNT from pca_int_rate_more12_rep pc
--left join v5pf on trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)=int_acc_num
--left join map_acc on  trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas
--left join tbaadm.gam on foracid=fin_acc_num
--left join (select * from tbaadm.disb where bank_id='01')disb on  rpc_acid=gam.acid  and trim(disb.remarks)=trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)
--LEFT JOIN (select i1.* from tbaadm.itc i1
--  left join (select * from tbaadm.itc where bank_id='01' and entity_type='RDISB')i2 on (i1.entity_id=i2.entity_id and i1.INT_TBL_CODE_SRL_NUM > i2.INT_TBL_CODE_SRL_NUM)
--  where i1.bank_id='01' and i2.entity_id is null)itc  ON  ITC.ENTITY_TYPE='RDISB' and   disb.DISB_ID=itc.entity_id ;
select distinct
to_char(map_acc.EXTERNAL_ACC) EXTERNAL_ACC_NO,
leg_branch_id LEG_BRANCH,
to_char(SOL_DESC) SOL_DESCRIPTION,
to_char(map_acc.leg_scan) LEG_SCAN,
to_char(map_acc.leg_scas) LEG_SCAS,
to_char(DISB_ID) DISB_ID,
to_char(map_acc.CURRENCY) LEG_CURRENCY,
to_char(gam.acct_crncy_code) FIN_CURRENCY,
case when map_acc.CURRENCY=gam.acct_crncy_code then 'TRUE' else 'FALSE' end CURRENCY_MATCH,
to_char(gam.sol_id) FIN_SOL,
to_char(gam.cif_id) FIN_CIF_ID,
TO_CHAR(MAP_ACC.LEG_ACC_NUM) LEG_ACC_NUM,
to_char(gam.foracid) FIN_ACC_NUM,
TO_CHAR(MAP_ACC.LEG_CUST_TYPE) LEG_CUST_TYPE,  
to_char(gam.schm_code) FIN_SCHEME_CODE,
TO_CHAR(GSP.SCHM_DESC) SCHEME_DESCRIPTION,
  --DS_AMT           NVARCHAR2(17),
      to_number((otdla)/POWER(10,c8pf.C8CED)) LEG_DISB_AMT,
      disb.DISB_AMT FIN_DISB_AMT,
      case when (to_number((otdla)/POWER(10,c8pf.C8CED)))= disb.DISB_AMT then 'TRUE' else 'FALSE' end  DISB_AMT_MATCH,
    --DS_DATE          NVARCHAR2(10),
  case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') 
    else ' ' end LEG_DISB_DATE,
    disb.DISB_DATE FIN_DISB_DATE,
    case when (case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') 
    else ' ' end)=to_char(disb.DISB_DATE,'DD-MM-YYYY') then 'TRUE' else 'FALSE' end  DISB_DATE_MATCH, 
  --DS_DUE_DATE      NVARCHAR2(10),
  case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY')
     else ' ' end LEG_DUE_DATE,
     disb.DUE_DATE FIN_DUE_DATE,
     case when (case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY')
     else ' ' end) =to_char(disb.DUE_DATE,'DD-MM-YYYY') then 'TRUE' else 'FALSE' end DUE_DATE_MATCH, 
--OPER_ACC_NUM     NVARCHAR2(16),
  case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end LEG_OPER_ACC,
  oper_gam.foracid FIN_OPER_ACC,
  case when (case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end) = (oper_gam.foracid) then 'TRUE' else 'FALSE' end OPER_ACC_MATCH,
  --INT_CODE         NVARCHAR2(5),
itc.INT_TBL_CODE INT_TABLE_CODE,
--PEGGED_FLG       NVARCHAR2(1),
GSP.PEG_INT_FOR_AC_FLG PEGGED_FLAG,
--ACC_PR_INT_DR    NVARCHAR2(10),
less.ACTUAL_PREF_RATE LEG_PREF_RATE,
itc.ID_DR_PREF_PCNT FIN_PREF_RATE,
case when less.ACTUAL_PREF_RATE=itc.ID_DR_PREF_PCNT then 'TRUE' else 'FALSE' end PREF_RATE_MATCH,  
less.ACC_PREF_RATE LEG_NET_RATE,
nvl(less.BASE_PCNT_DR,0)+nvl(less.DR_NRML_INT_PCNT,0)+ nvl(less.ACTUAL_PREF_RATE,0) FIN_NET_RATE,
case when to_char(less.ACC_PREF_RATE)=to_char(nvl(less.BASE_PCNT_DR,0)+nvl(less.DR_NRML_INT_PCNT,0)+ nvl(less.ACTUAL_PREF_RATE,0)) then 'TRUE' else 'FALSE' end NET_RATE_MATCH, 
    --REMARKS          NVARCHAR2(70)
  trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr) LEG_REMARKS,
  trim(disb.remarks) FIN_REMARKS,
  case when trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr) = trim(disb.remarks) then 'TRUE' else 'FALSE' end REMARKS_MATCH
  from map_acc
  inner join v5pf on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas 
  left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  inner join c8pf on c8ccy = otccy
  left join pca_acc_fin_int_rate_less12 less on trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)=less.int_acc_num
  --left join pca_acc_fin_int_rate_more12 more on trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)=more.int_acc_num
  left join (select * from tbaadm.gsp where gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID'))gsp on gsp.schm_code = map_acc.schm_code  
  left join pca_operacc oper on  trim(oper.ompf_leg_num)=trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)
  left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code =map_acc.CURRENCY
  left join (select * from tbaadm.gam where bank_id='01')gam on gam.foracid=map_acc.fin_acc_num
  left join (select * from tbaadm.disb where bank_id='01')disb on  rpc_acid=gam.acid  and trim(disb.remarks)=trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)
  LEFT JOIN (select * from TBAADM.SOL where bank_id=get_param('BANK_ID'))sol ON sol.SOL_ID = MAP_ACC.FIN_SOL_ID
  LEFT JOIN (select i1.* from tbaadm.itc i1
  left join (select * from tbaadm.itc where bank_id='01' and entity_type='RDISB')i2 on (i1.entity_id=i2.entity_id and i1.INT_TBL_CODE_SRL_NUM > i2.INT_TBL_CODE_SRL_NUM)
  where i1.bank_id='01' and i2.entity_id is null)itc  ON  ITC.ENTITY_TYPE='RDISB' and   disb.DISB_ID=itc.entity_id
    left join (select * from tbaadm.gac where bank_id='01')gac on gac.acid=gam.acid
  left join (select * from tbaadm.gam where bank_id='01')oper_gam on oper_gam.acid=gac.INT_DR_ACID
  --left join (select * from tbaadm.itc where bank_id='01' and entity_type='RDISB')itc on disb.DISB_ID=itc.entity_id
  where map_acc.schm_type='PCA' and map_acc.schm_code='LDADV'
  and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '') 
