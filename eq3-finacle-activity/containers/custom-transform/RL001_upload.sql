
-- File Name           : LAM_upload.sql
-- File Created for    : Upload file for LAM
-- Created By          : Alavudeen Ali Badusha.R
-- Client              : ABK
-- Created On          : 20-06-2016 
-------------------------------------------------------------------
drop table ompf_pr_min;
create table ompf_pr_min as
select ombrnm,omdlp,omdlr,min(omdte) omdte from ompf where ommvt = 'P' and ommvts = 'R' and omabf is not null  and to_number(omdte) > to_number(get_param('EODCYYMMDD')) 
group by ombrnm,omdlp,omdlr;
CREATE INDEX OMPF_PR_MIN_IDX ON OMPF_PR_MIN(OMBRNM, OMDLP, OMDLR, OMDTE);
drop table ompf_i_min;
create table ompf_i_min as
select ombrnm,omdlp,omdlr,min(omdte) omdte from ompf where ommvt = 'I' and trim(ommvts) is null and omabf is not null and to_number(omdte) > to_number(get_param('EODCYYMMDD'))
group by ombrnm,omdlp,omdlr;
CREATE INDEX ompf_i_min_idx ON ompf_i_min(OMBRNM, OMDLP, OMDLR, OMDTE);
drop table proper;
create table proper as (
select /*+ index(a OMPF_IDX,OMPF_IDX1,OMPF_ID2,MOMPF_IDXXX) */ a.* from ompf a 
inner join map_acc on leg_acc_num=a.ombrnm||trim(a.omdlp)||trim(a.omdlr)
inner join ompf_pr_min c on c.ombrnm=a.ombrnm and c.omdlp=a.omdlp and c.omdlr =a.omdlr and c.omdte = a.omdte 
where a.ommvt = 'P' and a.ommvts ='R' and schm_type='LAA');
create index proper_idx on proper(omabf,omanf,omasf);  
drop table ioper;
create table ioper as (
select /*+ index(a OMPF_IDX,OMPF_IDX1,OMPF_ID2,MOMPF_IDXXX) */ a.* from ompf a 
inner join map_acc on leg_acc_num=a.ombrnm||trim(a.omdlp)||trim(a.omdlr)
inner join ompf_i_min c on c.ombrnm=a.ombrnm and c.omdlp=a.omdlp and c.omdlr =a.omdlr and c.omdte = a.omdte 
where a.ommvt = 'I' and trim(a.ommvts) is null and schm_type='LAA');
create index ioper_idx on ioper(omabf,omanf,omasf);  
drop table operacc;
create table operacc as (
select a.*,fin_acc_num, map_acc.fin_sol_id,currency from (
select distinct nvl(a.ombrnm||a.omdlp||a.omdlr,b.ombrnm||b.omdlp||b.omdlr) ompf_leg_num,nvl(a.omabf||trim(a.omanf)||trim(a.omasf),b.omabf||trim(b.omanf)||trim(b.omasf)) oper_leg_acc from proper a
full join ioper b on b.ombrnm=a.ombrnm and b.omdlp=a.omdlp and b.omdlr =a.omdlr 
--where a.omabf=b.omabf and a.omanf=b.omanf  and a.omasf = b.omasf
)a
inner join map_acc on  leg_branch_id||leg_scan||leg_scas=oper_leg_acc
where schm_type in ('SBA','CAA','ODA'));
create index oper_idx on operacc(ompf_leg_num);
drop table iompf_laa;
create table iompf_laa as
select trim(ombrnm)||trim(omdlp)||trim(omdlr) del_ref_num,sum(omnwr) iomnwr   from ompf where OMMVT = 'I' and ommvts is null  group by ombrnm,omdlp,omdlr;
create index iompf_laa_idx on iompf_laa(del_ref_num);
------------------demand counter----------------
drop table demand_count;
create table demand_count as (    
--(select a.lsbrnm,a.lsdlp,A.lsdlr,max(lsdte) lsdte from lspf a
--inner join (select lsbrnm,lsdlp,lsdlr,max(lspdte) lspdte from lspf where LSAMTP <> 0  and lsamtd <> 0 and LSPDTE <> '9999999'   and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr) b on a.lsbrnm||a.lsdlp||A.lsdlr=b.lsbrnm||b.lsdlp||b.lsdlr and a.lspdte=b.lspdte  
--where (LSAMTD - LSAMTP) <> 0 
--group by a.lsbrnm,a.lsdlp,A.lsdlr) )
    select lsbrnm,lsdlp,lsdlr,min(lsdte) lsdte from lspf
    inner join map_acc on leg_acc_num=lsbrnm||trim(lsdlp)||trim(lsdlr)
    where (LSAMTD - LSAMTP) <> 0  and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') 
    and schm_type ='LAA'  group by lsbrnm,lsdlp,lsdlr);
create index dmd_cnt_idx on demand_count(lsbrnm,lsdlp,lsdlr,lsbrnm||lsdlp||lsdlr);
------------------------Interest table code----------------------
drop table int_tbl;
create table int_tbl as
  SELECT leg_acc_num int_acc_num, v5dlp,v5ccy, schm_code , v5brr, d4brar BASE_EQ_RATE, v5drr,d5drar DIFF_EQ_RATE, v5rtm,v5spr,v5rat, 
    CASE WHEN v5rat <> 0 THEN 'ZEROL' 
         else convert_codes('INT_TBL_CODE',v5brr) END INT_TBL_CODE,
    CASE 
    WHEN convert_codes('INT_TBL_CODE',v5brr) <> 'ZEROL' THEN v5rtm +nvl(d5drar,0)
    WHEN convert_codes('INT_TBL_CODE',trim(v5brr)) = 'ZEROL' and (trim(v5brr) is not null or trim(v5rtm) <> 0 )THEN nvl(d4brar,0) + v5rtm +nvl(d5drar,0)
         ELSE to_number(v5rat)
         END ACC_PREF_RATE,
         case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end acct_open_date,
         case when R02RDT<>'0' and get_date_fm_btrv(R02RDT) <> 'ERROR' then to_date(get_date_fm_btrv(R02RDT),'YYYYMMDD') end Repricing_date
  FROM map_acc 
  inner join v5pf on v5brnm||v5dlp||trim(v5dlr) = leg_acc_num
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num -- Deal Account open date added on 22-05-2017
  left join (select  * from YRLN02PF where R02BRNM||TRIM(R02DLP)||TRIM(R02DLR)||trim(R02SEQ) in (select R02BRNM||TRIM(R02DLP)||TRIM(R02DLR)||max(trim(R02SEQ)) from YRLN02PF GROUP BY R02BRNM||TRIM(R02DLP)||TRIM(R02DLR)) and to_number(R02RDT) < to_number(get_param('EODCYYMMDD'))) rep_acc on R02BRNM||TRIM(R02DLP)||TRIM(R02DLR)=otbrnm||trim(otdlp)||trim(otdlr) 
  LEFT JOIN d4pf ON v5brr = d4brr and d4dte = 9999999 
  LEFT JOIN d5pf ON v5drr = d5drr and d5dte = 9999999
  left join map_codes on leg_code=v5brr 
  WHERE schm_type = 'LAA';
create index int_tbl_idx on int_tbl(int_acc_num);
create index int_tbl_idx1 on int_tbl(acct_open_date);
drop table loan_account_finacle_int_rate;
create table loan_account_finacle_int_rate
as
SELECT a.*,REPRICING_PLAN,csp.int_tbl_code tbl_code,X.base_pcnt_dr,X.base_pcnt_cr,nvl(c.nrml_int_pcnt,0) cr_nrml_int_pcnt, nvl(d.nrml_int_pcnt,0) dr_nrml_int_pcnt,acc_pref_rate - (nvl(X.base_pcnt_dr,0) + nvl(d.nrml_int_pcnt,0))actual_pref_rate
from int_tbl a
left join r8pf on r8lnp=trim(v5dlp)
LEFT JOIN (SELECT * FROM TBAADM.GSP WHERE DEL_FLG= 'N' AND bank_id = get_param('BANK_ID'))GSP ON A.SCHM_CODE = GSP.SCHM_CODE
left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on a.schm_code = csp.schm_code and a.v5ccy = csp.crncy_code
left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  csp.int_tbl_code =b.int_tbl_code and  csp.CRNCY_CODE = b.CRNCY_CODE 
--and (CASE WHEN  GSP.schm_code in ('ERLI','GFX','NFX')  or  r8pf.r8crl = 'Y' or ( gsp.schm_code in ('NAF','NFD') and trim(v5brr) is null) THEN nvl(Repricing_date,acct_open_date) ELSE to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  END between b.start_date and b.MODIFY_END_DATE)
and (CASE WHEN  GSP.repricing_plan in ('F','M') or ( gsp.schm_code in ('NAF','NFD') and trim(v5brr) is null) THEN nvl(Repricing_date,acct_open_date) ELSE to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  END between b.start_date and b.MODIFY_END_DATE) ---changed on 01-08-2017 as per confirmation from Vijay,nagi,mehdi and hussaini reprising plan from bpd 
left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))X on  X.int_tbl_code =b.BASE_int_tbl_code and  X.CRNCY_CODE = b.CRNCY_CODE 
--and (CASE WHEN GSP.schm_code in ('ERLI','GFX','NFX')  or  r8pf.r8crl = 'Y' or (gsp.schm_code in ('NAF','NFD') and trim(v5brr) is null)  THEN nvl(Repricing_date,acct_open_date) ELSE to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  END between X.start_date and X.MODIFY_END_DATE)
and (CASE WHEN  GSP.repricing_plan in ('F','M') or ( gsp.schm_code in ('NAF','NFD') and trim(v5brr) is null) THEN nvl(Repricing_date,acct_open_date) ELSE to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  END between X.start_date and X.MODIFY_END_DATE) ---changed on 01-08-2017 as per confirmation from Vijay,nagi,mehdi and hussaini reprising plan from bpd 
left join (select a.* from tbaadm.LAVS a 
    inner join (select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') and int_slab_dr_cr_flg = 'C' group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'D'
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE;
create index int_tbl_idx_1 on loan_account_finacle_int_rate(int_acc_num);
drop table owpf_note_laa;
create table owpf_note_laa as
select trim(owbrnm)||trim(owdlp)||trim(owdlr) leg_acc,OWSD1,OWSD2,OWSD3,OWSD4 from owpf 
where owmvt = 'P' and owmvts = 'C';
create index owpf_idx1 on owpf_note_laa(leg_acc);
---------------------------------------------------------------
truncate table LAM_O_TABLE;
insert into LAM_O_TABLE
select distinct
    rpad(map_acc.fin_acc_num,16,' '),
-- v_Customer_Credit_Pref_Percent  CHAR(10)
    lpad(' ',10,' '),
-- v_Customer_Debit_Pref_Percent   CHAR(10)
    lpad(' ',10,' '),
-- v_Acct_ID_Credit_Pref_Percent   CHAR(10)
    lpad(' ',10,' '),
-- v_Acct_ID_Debit_Pref_Percent       CHAR(10)
--    lpad(case when TO_number(ACC_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(ACC_PREF_RATE) else to_char(nvl(ACC_PREF_RATE,0)) end,10,' ') ,
    lpad(case 
	when trim(ret_loan.deal_reference) is not null then '6' ---added on 30-04-2017 based on vijay mail dt 30-04-2017
    --when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then to_char(nvl(ACC_PREF_RATE,0))
	--when r8pf.r8crl = 'Y' then to_char(nvl(ACC_PREF_RATE,0))--changed on 22-05-2017 by kumar
	when TO_number(ACTUAL_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(ACTUAL_PREF_RATE) else to_char(nvl(ACTUAL_PREF_RATE,0)) end,10,' ') ,
-- v_Repricing_Plan           CHAR(1)
    --rpad( case when tbaadm.LSP.upfront_int_loan_flg = 'Y' then 'F' else tbaadm.GSP.repricing_plan end,1,' '),
    --rpad( case when obcrcl = 'Y' then 'F' else 'V' end,1,' '), --changed on 03-10-2016 because obpf -obcrcl has null value.
    --rpad( case when map_acc.schm_code in ('ERLI','GFX','NFX') THEN 'M' 	when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'F' when r8pf.r8crl = 'Y' then 'F' else 'V' end,1,' '), ---commented on 01-08-2017 as per confirmation from Vijay,nagi,mehdi and hussaini reprising plan from bpd 
	rpad( case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'F' else tbaadm.GSP.repricing_plan end,1,' '), ---changed on 01-08-2017 as per confirmation from Vijay,nagi,mehdi and hussaini reprising plan from bpd 
-- v_Pegging_Frequency_in_Months   CHAR(4)
    lpad(case when map_acc.schm_code in ('ERLI','GFX','NFX') THEN '60' else ' ' end,4,' '),
-- v_Pegging_Frequency_in_Days       CHAR(3)
    lpad(' ',3,' '),
--   v_Interest_Route_Flag       CHAR(1)
    --lpad(nvl(tbaadm.lsp.int_route_flg,' '),1,' '),
    lpad('O',1,' '),
	--lpad('L',1,' '), ---changed as per karthik sir confirmation on 27-04-2017.---- commented on 17-07-2017 based on mk5 observation --overdue interest not included in otdla hence commented
-- v_Acct_Currency_Code           CHAR(3)
    rpad(otccy,3,' '),
--   v_Sol_ID               CHAR(8)
    rpad(map_acc.fin_sol_id,8,' '),
--   v_GL_Sub_Head_Code           CHAR(5)
    --rpad(nvl(tbaadm.gss.gl_sub_head_code,' '),5,' '),
    rpad(nvl(map_acc.gl_sub_headcode,' '),5,' '),
--   v_Schm_Code             CHAR(5)
    rpad(map_acc.schm_code,5,' '),
--   v_CIF_ID                 CHAR(32)
    rpad(map_acc.fin_cif_id,32,' '),
--   v_Acct_Open_Date           CHAR(10)
    rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
    else ' ' end,10,' '),  
--   v_Sanction_Limit           CHAR(17)
    --lpad(to_number(omnwp)/POWER(10,c8pf.C8CED),17,' '),
    --case when obcrcl='Y' then lpad(ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED),17,' ')--changed on 03-10-2016 because obpf -obcrcl has null value.
    --case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null  then  lpad(ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED),17,' ')
	--when r8pf.r8crl='Y' then lpad(ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED),17,' ') else lpad(to_number(ompf.omnwp/POWER(10,c8pf.C8CED)),17,' ') end,---changed on 01-08-2017 as per vijay confirmation
	case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null  then  lpad(ompf.omnwp/POWER(10,c8pf.C8CED),17,' ')
	when r8pf.r8crl='Y' then lpad(ompf.omnwp/POWER(10,c8pf.C8CED),17,' ') else lpad(to_number(ompf.omnwp/POWER(10,c8pf.C8CED)),17,' ') end,
--   v_Ledger_Number           CHAR(3)
    rpad(' ',3,' '),
--   v_Sector_Code           CHAR(5)KTWORKS
    case when get_param('BANK_ID')='02'then rpad(convert_codes('SECTOR_CODE',trim(gf.GFC3R)),5,' ') 
      --else rpad(convert_codes('SECTOR_CODE',trim(gf.GFC2R)),5,' ') end,--changed on 07-03-2017 as per vijay confirmation
	  else rpad(convert_codes('SECTOR_CODE',trim(SCC2R)),5,' ') end,--changed on 17-08-2017 as per vijay discussion with Sandeep 
--   v_Sub_Sector_Code           CHAR(5)KTWORKS
    case when get_param('BANK_ID')='02' then rpad(nvl(trim(gf.GFC3R),'ZZZ'),5,' ')
          --else rpad(nvl(trim(gf.GFC2R),'ZZZ'),5,' ') end,--changed on 07-03-2017 as per vijay confirmation
		  else rpad(nvl(trim(SCC2R),'ZZZ'),5,' ') end,--changed on 17-08-2017 as per vijay discussion with Sandeep 
-- v_Purpose_of_Advance           CHAR(5)
    case when get_param('BANK_ID')='02' then rpad(nvl(trim(SCC3R),'999'),5,' ')
    else rpad(nvl(trim(SCC2R),'999'),5,' ') end,  
--  v_Nature_of_Advance           CHAR(5)
    rpad('999',5,' '),
--   v_Free_Code_3           CHAR(5)
    lpad(' ',5,' '),
--  v_Sanction_Reference_Number       CHAR(25)
    rpad(' ',25,' '),
--   v_Sanction_Limit_Date       CHAR(10)
      rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
    else ' ' end,10,' '),  
--   v_Sanction_Level_Code       CHAR(5)
    --rpad('99999',5,' '),
    rpad('999',5,' '),
--  v_Limit_Expiry_Date           CHAR(10)
    rpad(case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY')
     else '' end,10,' '),
--   v_Sanction_Authority_Code       CHAR(5)
    --rpad('99999',5,' '),
    rpad('999',5,' '),
--   v_Loan_Paper_Date           CHAR(10)
    rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end,10,' '),      
--  v_Operative_Acct_ID           CHAR(16)
    rpad(case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end ,16,' '),
--   v_Operative_Currency_Code       CHAR(3)
    rpad(case when oper.fin_acc_num is not  null then oper.currency else ' ' end ,3,' '),
--   v_Operative_Sol_ID           CHAR(8)
    rpad(case when oper.fin_acc_num is not  null then oper.fin_sol_id else ' ' end ,8,' '),
--   v_Demand_Satisfy_Method       CHAR(1)
    rpad(case when map_acc.schm_code in ('YCB','ZCB','ZFF','ZCO','YCO') then 'N' when trim(oper.fin_acc_num) is not null then  'E' else 'N' end,1,' '),
-- v_Lien_on_Operative_Acct_Flag   CHAR(1)
    rpad(case when oper.fin_acc_num is not null then tbaadm.LSP.lien_on_oper_Acct_flg else 'N' end,1,' '), 
-- v_Repayment_currency_rate_code  CHAR(5)
    rpad(' ',5,' '),
-- v_Interest_table_code       CHAR(5)
   -- rpad(nvl(int_tbl.INT_TBL_CODE,'ZEROL'),5,' '),
    case when trim(ret_loan.deal_reference) is not null then 'ZEROL' ---added on 30-04-2017 based on vijay mail dt 30-04-2017
	--when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'ZEROL'
	--when r8pf.r8crl = 'Y' then 'ZEROL'--changed on 22-05-2017 by kumar
	else rpad(nvl(int_tbl.TBL_CODE,'ZEROL'),5,' ') end,
-- v_Interest_on_principal_Flag       CHAR(1)
    rpad(nvl(tbaadm.LSP.int_on_p_flg,' '),1,' '),
-- v_Penal_int_ovdue_princ_dmd_Fl CHAR(1)
--    rpad(nvl(tbaadm.LSP.pi_on_pdmd_ovdu_flg,' '),1,' '),
     'N', --based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_Princ_Dmd_Ovdue_end_month_Fl CHAR(1)
    rpad(nvl(tbaadm.LSP.pdmd_ovdu_eom_flg,' '),1,' '),
--   v_Int_On_Int_Demand_Flag       CHAR(1)
    --rpad(nvl(tbaadm.LSP.int_on_idmd_flg,' '),1,' '),
    'N', --based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_penal_int_overdue_int_dmd_Fl CHAR(1)
    --rpad(nvl(tbaadm.LSP.pi_on_idmd_ovdu_flg,' '),1,' '),
    'N', --based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_Int_Demand_Ovdue_End_Mnth_Fl CHAR(1)
    rpad(nvl(tbaadm.LSP.idmd_ovdu_eom_flg,' '),1,' '),
-- v_Transfer_Effective_Date       CHAR(10) ~
    rpad(get_param('EOD_DATE'),10,' '),   
-- v_Cumulative_Normal_int_am       CHAR(17)
    lpad(' ',17,' '),  --Inital mapping not done. Field mapping and logic to be provide by bank 
--   v_Cumulative_penal_int_amt       CHAR(17)
    lpad(' ',17,' '),  --Inital mapping not done. Field mapping and logic to be provide by bank 
-- v_cumulative_additional_int_am CHAR(17)
    lpad(' ',17,' '),
-- v_Liab_Transfer_Effective_date  CHAR(17)
    rpad(to_number(otdla)/POWER(10,c8pf.C8CED),17,' '),
-- v_Disbursement_Previous_Sche    CHAR(17)
    --lpad(to_number(ompf.omnwp)/POWER(10,c8pf.C8CED) - otdla/POWER(10,c8pf.C8CED) ,17,' '),
    --lpad(to_number(case when obcrcl='Y' and ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED) > 0 then ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED) --changed on 03-10-2016 because obpf -obcrcl has null value.
    --lpad(case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null and ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED) > 0 then ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED)
	--when r8pf.r8crl='Y' and ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED) > 0 then ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED)
    --when nvl(trim(r8pf.r8crl),'N')='N' and (to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)) > 0  then to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) else 0 end,17,' '), ---changed on 01-08-2017 as per vijay confirmation--interest amount should not subtract
	--lpad(case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then ompf.omnwp/POWER(10,c8pf.C8CED)
	--when r8pf.r8crl='Y' then ompf.omnwp/POWER(10,c8pf.C8CED)
    --when nvl(trim(r8pf.r8crl),'N')='N' and (to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)) > 0  then to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) else 0 end,17,' '),	-- changed on 24-08-2017 as per Sandeep requirment changed done by Kumar
	lpad(case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null  and (to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)) > 0 then to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) 
	when r8pf.r8crl='Y' and (to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)) > 0 then to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) 
    when nvl(trim(r8pf.r8crl),'N')='N' and (to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)) > 0  then to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) else 0 end,17,' '),
-- v_Debit_Int_Calc_upto_date      CHAR(10)
    rpad( case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY')
               when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') else '' end,10,' '),   
--   v_Repayment_Schedule_Date       CHAR(10) 
    rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end,10,' '),      
-- v_Repayment_Period_in_months       CHAR(3) KTWORKS change key_value to get_config
     rpad(
     --case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
     --else 0 end
     ,3,' '),                                                             
--   v_Repayment_Period_in_Days       CHAR(3) KTWORKS change key_value to get_config
lpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
          to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
--else 0 end
,3,' '),
--   v_Past_Due_Flag           CHAR(1)
    --lpad(case when iis.accc is not null then 'Y'
     --else 'N' end,1,' '), ---This is added on 02-08-2017. based on discussion with vijay and sandeep mail dt 02-08-2017.-----based on discussion with vijay on 06-08-2017 script changed-----commented on 11-09-2017 based on vijay confirmation
     lpad('N',1,' '),
--   v_Past_Due_Transfer_Date       CHAR(10)
--  rpad(case when iis.accc is not null then to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY')-to_number(nvl(MAXOFDUDAYS,0)),'DD-MM-YYYY')
--     else ' ' end,10,' '), ---This is added on 02-08-2017. based on discussion with vijay and sandeep mail dt 02-08-2017.-----based on discussion with vijay on 06-08-2017 script changed
	 --rpad(case  when iis.accc is not null and dmd_cnt.lsbrnm is not null and lsdte <> 0  then to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY')
     ----when iis.accc is not null then to_char(to_date(get_param('EODCYYMMDD'),'YYYYMMDD'),'DD-MM-YYYY')
	 --when iis.accc is not null then get_param('EOD_DATE')
	 --else ' ' end,10,' '), ---This is added on 02-08-2017. based on discussion with vijay and sandeep mail dt 02-08-2017.-----based on discussion with vijay on 06-08-2017 script changed-------commented on 11-09-2017 based on vijay confirmation
	 lpad(' ',10,' '),
-- v_Prv_To_Pd_GL_Sub_Head_Code       CHAR(5)
    --rpad(case when iis.accc is not null then nvl(tbaadm.gss.gl_sub_head_code,' ') else ' ' end,5,' '), ---This is added on 02-08-2017. based on discussion with vijay and sandeep mail dt 02-08-2017.--commented on 11-09-2017 based on vijay confirmation
	lpad(' ',5,' '),
--   v_Interest_Suspense_Amount       CHAR(17)
     --lpad(case when iis.accc is not null  then to_char(nvl(trim(TOTAL_INTEREST_PAST_DUE),0))
     --else ' ' end,17,' '), ---This is added on 02-08-2017. based on discussion with vijay and sandeep mail dt 02-08-2017.-----based on discussion with vijay on 06-08-2017 script changed--commented on 11-09-2017 based on vijay confirmation
	 lpad(' ',17,' '),
-- v_Penal_Interest_Suspense_Amt   CHAR(17)
    lpad(' ',17,' '),
--   v_Charge_Off_Flag           CHAR(1)
    'N',
--   v_Charge_Off_Date           CHAR(10)
    rpad(' ',10,' '),
--   v_Charge_Off_Principle       CHAR(17)
    rpad(' ',17,' '),
--   v_Pending_Interest           CHAR(17)
    lpad(' ',17,' '),
-- v_Principal_Recovery           CHAR(17)
    lpad(' ',17,' '),
-- v_Interest_Recovery           CHAR(17)
    lpad(' ',17,' '),
-- v_source_dealer_code           CHAR(20)
    rpad(' ',20,' '),
--   v_Disburse_dealer_code       CHAR(20)
    rpad(' ',20,' '),
--   v_Apply_late_fee_Flag       CHAR(1)
    rpad(tbaadm.lsp.apply_late_fee_flg,1,' '),
-- v_Late_Fee_Grace_Period_Months  CHAR(3)
    lpad(LATEFEE_GRACE_PERD_MNTHS,3,' '),
-- v_Late_Fee_Grace_Period_Days       CHAR(3)
    lpad(LATEFEE_GRACE_PERD_days,3,' '),
-- v_Instal_amt_collect_upfront       CHAR(1)
    lpad(tbaadm.lsp.upfront_instlmnt_coll,1,' '),
-- v_Num_of_instal_collec_upfront  CHAR(2)
    lpad(' ',2,' '),
-- v_upfront_instalment_amount       CHAR(17)
    lpad(' ',17,' '),
--   v_Demand_Past_Due_counter       CHAR(5)
    case --when iis.accc is not null then rpad(to_char(nvl(trim(MAXOFDUDAYS),'0')),5,' ')  --commented on 24-08-2017 based on discussion with vijay --from iis file maxofduedays not extracted actual overdue date considered.
	 when dmd_cnt.lsbrnm is not null and lsdte <> 0 and to_number(get_param('EODCYYMMDD'))-to_number(lsdte) >=0 then rpad(to_date(get_date_fm_btrv(get_param('EODCYYMMDD')),'YYYYMMDD')-to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),5,' ')
     else rpad('0',5,' ') end,
-- v_Sum_of_the_princ_demand_amt   CHAR(17)
    lpad(abs(to_number(nvl(sum_overdue,0)))/POWER(10,c8pf.C8CED),17,' '),
--   v_Payoff_Flag           CHAR(1)
    'N',
-- v_ExcLd_for_Combined_Statement  CHAR(1)
    ' ',
--   v_Statement_CIF_ID           CHAR(32)
    rpad(' ',32,' '),
--   v_Transfer_Cycle_String       CHAR(45)
    rpad( '000000000000000000000000000000000000000000000',45,' '),
--   v_Bank_IRR_Rate           CHAR(8)
    lpad(' ',8,' '),
--   v_Value_Of_Asset           CHAR(17)
    lpad(' ',17,' '),
--   v_Occupation_code_customer       CHAR(5)
    rpad(convert_codes('SUNDRY_ANALYSIS_CODE',trim(SCSAC)),5,' '),
--   v_Borrower_category_code       CHAR(5)
    rpad(' ',5,' '),
--   v_Mode_of_the_advance       CHAR(5)
    rpad(' ',5,' '),
--   v_Type_of_the_advance       CHAR(5)
    rpad(' ',5,' '),
--   v_guarantee_coverage_Code       CHAR(5)
    rpad(' ',5,' '),
--   v_Industry_Type           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_1           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_2           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_4           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_5           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_6           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_7           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_8           CHAR(5)
    rpad(' ',5,' ') ,
--   v_Free_Code_9           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_10           CHAR(5)
    rpad(' ',5,' '),
-- v_Acct_Location_Code           CHAR(5)
    rpad(' ',5, ' '),
-- v_credit_report_file_Ref_ID       CHAR(15)
    rpad(' ',15,' '),
-- v_DICGC_Fee_Percent           CHAR(8)
    lpad(' ',8,' '),
-- v_Last_Compound_Date           CHAR(10)KTWORKS 
    --rpad(case when tbaadm.LSP.int_on_idmd_flg ='Y' then get_param('EOD_DATE') else ' ' end ,10,' '),
    ' ',--based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_Daily_Compound_Interest_Flag  CHAR(1)
--    rpad(tbaadm.LSP.int_on_idmd_flg,1,' '),
'N',--based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_CalculateOverdue_Int_rate_Fl  CHAR(1)
    rpad(' ',1,' '),
-- v_EI_paying_period_start_date   CHAR(10)
    rpad(--case  when obpf.obcrcl = 'Y' and v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY') --changed on 03-10-2016 because obpf -obcrcl has null value.
    case  
	when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null and v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY')
	when r8pf.r8crl= 'Y' and v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY')
               when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end,10,' '),
-- v_EI_paying_period_end_date       CHAR(10)
    rpad(case when otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt<>'9999999' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end,10,' '),
--   v_IRR_Rate               CHAR(8)
    lpad(' ',8,' '),
--   v_Advance_interest_amount       CHAR(17)
    lpad(' ',17,' '),
--   v_Amortised_Amount           CHAR(17)
    lpad(' ',17,' '),
--   v_Debit_Booked_Upto_Date       CHAR(10)
    rpad(' ',10,' '),
-- v_Adv_Int_Collection_upto_Date  CHAR(10)
    rpad(' ',10,' '),
--   v_Accrual_Rate           CHAR(9)
    lpad(' ',9,' '),
-- v_Int_Rate_Sanction_Limit_Flg   CHAR(1)
    case 
        when tbaadm.LSP.int_prod_method = 'S' then  'Y'
        else tbaadm.LSP.int_rate_based_on_sanct_lim
    end,
--   v_Interest_Rest_Frequency       CHAR(1) KTWORKS I will give you the map frequency function
    rpad(' ',1,' '),
--   v_Interest_Rest_Basis       CHAR(1)
    rpad(' ',1,' '),
-- v_Charge_Route_Flag           CHAR(1)
    rpad(tbaadm.LSP.chrg_route_flg,1,' '),
--  v_Final_Disbursement_Flag       CHAR(1)
    'Y',
-- v_Auto_Resch_after_Holiday_Prd  CHAR(1)
    rpad(' ',1,' '),
-- v_total_number_of_deferments       CHAR(2)
    lpad(' ',2,' '),
-- v_num_deferments_current_repay  CHAR(2)
    lpad(' ',2,' '),
--   v_End_Date               CHAR(10)
    rpad(' ',10,' '),
-- v_Penal_interest_on_Outstandin  CHAR(1)
    --case when tbaadm.LSP.pi_on_pdmd_ovdu_flg = 'N' then ' ' else tbaadm.LSP.pi_based_on_outstanding end,
    ' ', --based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
--   v_Charge_off_type           CHAR(1)
    rpad(' ',1,' ') ,
-- v_Deferred_appli_int_rate_fl    CHAR(1)
    rpad(' ',1,' '),
--   v_Def_applicable_int_rate       CHAR(10)
    rpad(' ',10,' '),
--   v_Deferred_Interest_Amount       CHAR(17)
    lpad(' ',17,' '),
-- v_Auto_Reschedule_Not_Allowed   CHAR(1)
    rpad( nvl(tbaadm.LSP.auto_reshdl_not_allowed,' '),1,' '),
-- v_Rescheduled_Overdue_Principa  CHAR(17)
    lpad(' ',17,' '),
-- v_Reschedule_Overdue_Interest   CHAR(17)
    lpad(' ',17,' '),
-- v_Loan_Type               CHAR(1)
    lpad('N',1,' '),
--   v_Pay_Off_Reason_Code       CHAR(5)
    rpad(' ',5,' '),
--   v_Related_Deposit_Acct_ID       CHAR(16)
    rpad(' ',16,' '),
-- v_Last_AckNowledgt_Dr_Prd_date  CHAR(10)
    rpad(' ',10,' '),
--   v_Refinance_Sanction_Date       CHAR(10)
    rpad(' ',10,' '),
--   v_Refinance_Amount           CHAR(17)
    lpad(' ',17,' '),
--   v_Subsidy_Acct_ID           CHAR(16)
    rpad(' ',16,' '),
--   v_Subsidy_Agency           CHAR(16)
    rpad(' ',16,' '),
--   v_Subsidy_Claimed_Date       CHAR(10)
    rpad(' ',10,' '),
--   v_Subsidy_Activity_Code       CHAR(10)
    rpad(' ',10,' '),
-- v_Debit_AckNowledgement_Type       CHAR(1)
    rpad(' ',1,' '),
-- v_Refinance_Sanction_Number       CHAR(25)
    rpad(' ',25,' '),
-- v_Refinance_Reference_Number       CHAR(25)
    rpad(' ',25,' '),
--   v_Refinance_Claimed_Date       CHAR(10)
    rpad(' ',10,' '),
--   v_Subsidy_Amount           CHAR(17)
    lpad(' ',17,' '),
--   v_Subsidy_Received_Date       CHAR(10)
    rpad(' ',10,' '),
--   v_Preprocess_Fee           CHAR(17)
    lpad(' ',17,' '),
--   v_Activity_Code           CHAR(6)
    rpad(' ',6,' '),
-- v_Probation_Period_in_Months       CHAR(3)
    lpad(' ',3,' '),
--   v_Probation_Period_in_Days       CHAR(3)
    lpad(' ',3,' '),
-- v_Compound_Rest_Indicator_Flag  CHAR(1)
    rpad(' ',1,' '),
--   v_Discounted_Int_Rate_Flag       CHAR(1)
    rpad(' ',1,' '),
--   v_Collect_Interest_Flag       CHAR(1)
    rpad('Y',1,' '),
--   v_Despatch_mode           CHAR(1)
    rpad('N',1,' '),
--   v_Acct_Manager           CHAR(15)
    --rpad(' ',15,' '),
    rpad( case when nrd.officer_code is not null and trim(nrd.loginid) is not null then to_char(trim(nrd.loginid))
when trim(scpf.scaco)='199' then '199_RBD'
	else nvl(convert_codes('RMCODE',trim(scpf.scaco)),'UBSADMIN') end,15,' '), -- changed on 06-01-2017 as per Vijay Confirmation
-- v_Mode_of_Oper_Code           CHAR(5)
    rpad(' ',5,' '),
--   v_Statement_Frequency_Type       CHAR(1)
    rpad(' ',1,' '),
-- v_Week_num_for_Statement_Date   CHAR(1)
    rpad(' ',1,' '),
-- v_Week_Day_for_Statement_Date   CHAR(1)
    rpad(' ',1,' '),
-- v_Week_Dt_for_Statement_Date       CHAR(2)
    rpad(' ',2,' '),
-- v_Statement_Freq_case_of_Hldys  CHAR(1)
    rpad(' ',1,' '),
--   v_Statement_of_the_Account       CHAR(1)
    'N',
--   v_Next_Print_date           CHAR(10)
    rpad(' ',10,' '),
-- v_Fixed_Rate_Term_in_Months       CHAR(3)
    lpad(' ',3,' '),
--   v_Fixed_Rate_Term_in_Days       CHAR(3)
    lpad(' ',3,' '),
-- v_Minimum_Int_Percent_Debit       CHAR(10)
    lpad(' ',10,' '),
-- v_Maximum_Int_Percent_Debit       CHAR(10)
    lpad(' ',10,' '),
--   v_Instalment_Income_Ratio       CHAR(9)
    lpad(' ',9,' '),
--   v_Product_Group           CHAR(5)
    rpad(' ',5,' '),
-- v_Free_Text               CHAR(240)
    case when trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null and trim(FTEXT) is not null then     to_char(rpad('Govt fund :'|| trim(OWSD1)||' '||trim(OWSD2)||' '||trim(OWSD3)||' '||trim(OWSD4)||'Deal Notes :' ||trim(FTEXT) ,240,' '))
    when trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null and trim(FTEXT) is null then     to_char(rpad('Govt fund :' ||trim(OWSD1)||' '||trim(OWSD2)||' '||trim(OWSD3)||' '||trim(OWSD4),240,' '))
    when trim(OWSD1||OWSD2||OWSD3||OWSD4) is null and trim(FTEXT) is not null then     to_char(rpad('Deal Notes :'||trim(FTEXT),240,' '))
    else rpad(' ',240,' ') end,
   ---------------rpad(' ',240,' '),
--   case when trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null then     to_char(rpad('Govt fund :' ||trim(OWSD1)||' '||trim(OWSD2)||' '||trim(OWSD3)||' '||trim(OWSD4),240,' '))
  --      else rpad(' ',240,' ') end,
-- v_Linked_Account_ID           CHAR(16)
    rpad(' ',16,' '),
-- v_Delinquency_Resch_Method_Flg  CHAR(1)
    rpad(' ',1,' '),
-- v_Total_Number_of_Switch_Over   CHAR(3)
    lpad(' ',3,' '),
--   v_Non_Starter_Flag           CHAR(1)
    rpad(' ',1,' '),
-- v_Floating_Interest_Table_Code  CHAR(5)
    rpad(' ',5,' '),
-- v_Floating_Repricing_Frequency  CHAR(3)
    lpad(' ',3,' '),
-- v_Floating_Repricing_Freq_Days  CHAR(3)
    lpad(' ',3,' '),
-- v_Single_EMI_Turn_Over_Diff_Fl  CHAR(1)
    rpad(' ',1,' '),
--   v_IBAN_Number           CHAR(34)
    lpad(nvl(map_acc.iban_number,' '),34,' '),
--   v_IAS_CLASSIFICATION_CODE       CHAR(5)
    rpad(' ',5,' '),
--   v_Account_Number1           CHAR(16)
    rpad(' ',16,' '),
--   v_Type_of_top_up           CHAR(1)
    rpad(' ',1,' '),
-- v_Negotiated_Rate_Debit_Percen CHAR(10)
    lpad(' ',10,' '),
-- v_Normal_Int_Product_Method       CHAR(1)
    rpad('F',1,' '),
-- v_Penal_Interest_Rate_Method       CHAR(1)
    --rpad(' ',1,' '),
    rpad('D',1,' '),    
--   v_Penal_Interest_Method       CHAR(1)
    --rpad(LSP.full_penal_mthd_flg,1,' '),
    'Y', --based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_hldy_prd_frm_first_disb_flg   CHAR(1)
    rpad(' ',1,' '),
--   v_EI_Scheme_Flag           CHAR(1)
    --rpad(nvl(tbaadm.LSP.ei_schm_flg,' '),1,' '),
    rpad(case 
	when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'Y'
	when r8pf.r8crl='Y' then 'Y'
    else 'N' end,1,' '),
-- v_EI_Method               CHAR(1)
    rpad(case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'R' else ' ' end,1,' '),
--   v_Ei_Formula_Flag           CHAR(1)
    rpad(case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'P' else ' ' end,1,' '),
--    rpad(lsp.ei_formula_flg,1,' '),
-- v_Normal_Holiday_Period_in_Mnt CHAR(3)
    lpad(' ',3,' '),
-- v_Holiday_Period_Interest_Flag  CHAR(1)
    rpad(' ',1,' '),
-- v_Holiday_Period_Interest_Amt   CHAR(17)
    lpad(' ',17,' '),
-- v_Resche_by_Adjust_TeNor_Amt       CHAR(1)
    rpad(' ',1,' '),
-- v_Auto_Reschedule_every_Disb       CHAR(1)
    rpad(' ',1,' '),
-- v_Auto_Reschule_Int_Rate_Chang  CHAR(1)
    rpad(' ',1,' '),
-- v_Auto_Reschedule_Prepayment       CHAR(1)
    rpad(' ',1,' '),
--   v_Rescheduling_Amount_flag       CHAR(1)
    rpad(' ',1,' '),
-- v_Capitalize_Int_on_Rephasemen  CHAR(1)
    rpad(' ',1,' '),
-- v_Carry_over_Demands           CHAR(1)
    rpad(' ',1,' '),
-- v_Type_Instalment_Combination   CHAR(1)
    rpad(' ',1,' '),
-- v_Cap_Int_to_EMI_Flg           CHAR(1)
    rpad(' ',1,' '),
-- v_Deferred_Int_Due_to_EMI_Cap   CHAR(17)
    lpad(' ',17,' '),
--   v_Month_for_Deferment       CHAR(2)
    lpad(' ',2,' '),
--   v_Num_Months_Deferred       CHAR(2)
    lpad(' ',2,' '),
-- v_Channel_Credit_Pref_Percent   CHAR(10)
    lpad(' ',10,' '),
-- v_Channel_Debit_Pref_Percent       CHAR(10)
    lpad(' ',10,' '),
-- v_Channel_Id               CHAR(5)
    rpad(' ',5,' '),
-- v_Channel_Level_Code           CHAR(5)
    rpad(' ',5,' '),
-- v_Instalment_Effective_Flag       CHAR(1)
    rpad(' ',1,' '),
--   v_Notice_Period           CHAR(3)
    rpad(' ',3,' '),
--   v_Shift_Instalment_Flag       CHAR(1)
    rpad(' ',1,' '),
--   v_Include_Maturity_Date       CHAR(1)
    rpad(' ',1,' '),
-- v_Interest_Rule_Code           CHAR(5)
    rpad(' ',5,' '),
-- v_Cumulative_Capitalize_Fees       CHAR(17)
    lpad(' ',17,' '),
-- v_upfront_instalment_int_amoun  CHAR(17)
    lpad( ' ',17,' '),
--  v_Recall_Flag           CHAR(1)
    rpad(' ',1,' '),
--   v_Recall_Date           CHAR(10)
    rpad(' ',10,' '),
-- v_Diff_PS_Freq_For_Rel_Part       CHAR(1)
    rpad(' ',1,' '),
-- v_Diff_Swift_Freq_For_Rel_Part  CHAR(1)
    rpad(' ',1,' '),
-- v_Penal_Interest_table_code       CHAR(5)
    rpad(' ',5,' '),
-- v_Penal_Preferential_Percent       CHAR(10)
    lpad(' ',10,' '),
--   v_RA_ref_number           CHAR(16)
    rpad(' ',16,' '),
--   v_Interest_table_Version       CHAR(5)
    rpad(' ',5,' '),
--   v_Address_Type           CHAR(12)
    rpad(' ',12,' '),
-- v_Phone_Type               CHAR(12)
    rpad(' ',12,' '),
-- v_Email_Type               CHAR(12)
    rpad(' ',12,' '),
-- v_Accrued_Penal_Int_Recover       CHAR(17)
    lpad(' ',17,' '),
-- v_Penal_Interest_Recovery       CHAR(17)
    lpad(' ',17,' '),
-- v_Collection_Interest_Recovery  CHAR(17)
    lpad(' ',17,' '),
-- v_Collection_Penal_Int_Recover  CHAR(17)
    lpad(' ',17,' '),
--   v_Mark_Up_Applicable_Flag       CHAR(1)   
    rpad(' ',1,' '),
-- v_Pref_Calendar_base_processin CHAR(2)
    rpad(' ',2,' '),
-- v_Purchase_Reference           CHAR(12)
    rpad(' ',12,' '),
--  v_Frez_code               CHAR(1)
    rpad(' ',1,' '),
--   v_Frez_reason_code           CHAR(5)
    rpad(' ',5,' '),
--   Bank_Profit_Share_Pcnt    CHAR(10) NULL,
lpad(' ',10,' '),
--   Bank_Loss_Share_Pcnt    CHAR(10) NULL,
lpad(' ',10,' '),
--   Next_Profit_Adj_Due_Dt    CHAR(10) NULL,
rpad(' ',10,' '),
--   Profit_Adj_Freq    CHAR(1) NULL,
rpad(' ',1,' '),
--   Week_Num_for_Profit_Adj    CHAR(1) NULL,
lpad(' ',1,' '),
--   Week_Day_for_Profit_Adj    CHAR(1) NULL,
lpad(' ',1,' '),
--   Start_Day_for_Profit_Adj    CHAR(2) NULL,
lpad(' ',2,' '),
--   Profit_Adj_Freq_holidays    CHAR(1) NULL,
rpad(' ',1,' '),
--   Adj_Freq_Calendar_Base    CHAR(2) NULL,
rpad(' ',2,' '),
--   Salam_Sale_Ref_ID    CHAR(10) NULL,
rpad(' ',10,' '),
--   Salam_Asset_Code    CHAR(12) NULL,
rpad(' ',12,' '),
--   Seller_Dealer_ID    CHAR(15) NULL,
rpad(' ',15,' '),
--   Salam_Seller_Det    CHAR(50) NULL,
rpad(' ',50,' '),
--   Para_Salam_Seller_Ref_ID    CHAR(10) NULL,
rpad(' ',10,' '),
--   Para_Salam_Asset_Code    CHAR(12) NULL,
rpad(' ',12,' '),
--   Buyer_Dealer_ID    CHAR(15) NULL,
rpad(' ',15,' '),
--   Salam_Buyer_Details    CHAR(50) NULL,
rpad(' ',50,' '),
--   Purchase_Price_Per_Unit    CHAR(17) NULL,
lpad(' ',17,' '),
--   Dealer_Id    CHAR(15) NULL,
rpad(' ',15,' '),
--   Asset_Code    CHAR(15) NULL,
rpad(' ',15,' '),
--   Margin_Money_Acc_Flag    CHAR(1) NULL,
rpad(' ',1,' '),
--   Margin_Money_Type    CHAR(1) NULL,
rpad(' ',1,' '),
--   Margin_Money_Pcnt    CHAR(3) NULL,
lpad(' ',3,' '),
--   Margin_Money_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Invoice_Amount    CHAR(17) NULL,
lpad(' ',17,' '),
--   Debit_Account_ID    CHAR(25) NULL,
rpad(' ',25,' '),
--   Purchase_Aqad_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Sale_Aqad_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Purc_Aqad_Ref    CHAR(12) NULL,
rpad(' ',12,' '),
--   Sale_Aqad_Ref    CHAR(12) NULL,
rpad(' ',12,' '),
--   Purc_Aqad_Date    CHAR(10) NULL,
rpad(' ',10,' '),
--   Purc_Aqad_DateHH    CHAR(2) NULL,
rpad(' ',2,' '),
--   Purc_Aqad_DateMM    CHAR(2) NULL,
rpad(' ',2,' '),
--   Purc_Aqad_DateSS    CHAR(2) NULL,
rpad(' ',2,' '),
--   Sale_Aqad_Date    CHAR(10) NULL,
rpad(' ',10,' '),
--   Sale_Aqad_DateHH    CHAR(2) NULL,
rpad(' ',2,' '),
--   Sale_Aqad_DateMM    CHAR(2) NULL,
rpad(' ',2,' '),
--   Sale_Aqad_DateSS    CHAR(2) NULL,
rpad(' ',2,' '),
--   No_Of_Units    CHAR(5) NULL,
lpad(' ',5,' '),
--   Asset_Particulars    CHAR(30) NULL,
rpad(' ',30,' '),
--   Unearned_Income    CHAR(17) NULL,
lpad(' ',17,' '),
--   Security_Dep_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Adj_Advance_Rent    CHAR(1) NULL,
rpad(' ',1,' '),
--   Repossess_Flag    CHAR(1) NULL,
rpad(' ',1,' '),
--   Cumu_Deposit_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Last_Dep_Date    CHAR(10) NULL,
rpad(' ',10,' '),
--   Istisna_with_Parallel_Istisna    CHAR(1) NULL,
rpad(' ',1,' '),
--   Construction_TenorMM    CHAR(3) NULL,
lpad(' ',3,' '),
--   SettlementTenorMM    CHAR(3) NULL,
lpad(' ',3,' '),
--   SettlementTenorDD    CHAR(3) NULL,
lpad(' ',3,' '),
--   Istisna_Contract_ID    CHAR(15) NULL,
rpad(' ',15,' '),
--   Cost_Of_Construction    CHAR(17) NULL,
lpad(' ',17,' '),
--   Unearned_Inc_for_Cons_Prd    CHAR(17) NULL,
lpad(' ',17,' '),
--   Unearned_Inc_for_Settle_Prd    CHAR(17) NULL,
lpad(' ',17,' '),
--   Const_Prd_Profit_Method    CHAR(1) NULL,
rpad(' ',1,' '),
--   Retention_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Retentio_Rel_Flg    CHAR(1) NULL,
rpad(' ',1,' '),
--   Parallel_Istisna_Delivery_Dt    CHAR(10) NULL,
rpad(' ',10,' '),
--   Builder_Profit    CHAR(1) NULL,
rpad(' ',1,' '),
--   Builder_Profit_Pcnt    CHAR(10) NULL,
lpad(' ',10,' '),
--   Builder_Profit_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Notes    CHAR(80) NULL,
rpad(' ',80,' '),
--   Builder_ACC_ID    CHAR(16) NULL,
lpad(' ',16,' '),
--   Is_CP_Over    CHAR(1) NULL,
rpad(' ',1,' '),
--   Rebate_Benefit_Amount    CHAR(17) NULL,
lpad(' ',17,' '),
--   Process_Rebate_on_Mat    CHAR(1) NULL,
rpad(' ',1,' '),
--   Print_Print_Statement    CHAR(1) NULL,
rpad(' ',1,' '),
--   Print_Advice_for_SI    CHAR(1) NULL,
rpad(' ',1,' '),
--   Print_Deposit_Notice    CHAR(1) NULL,
rpad(' ',1,' '),
--   Print_Loan_Notice    CHAR(1) NULL,
rpad(' ',1,' '),
--   Interest_Certificate    CHAR(1) NULL,
rpad(' ',1,' '),
--   Interest_Rate_Change_Adv    CHAR(1) NULL,
rpad(' ',1,' '),
--   Collect_Excess_Profit    CHAR(1) NULL,
rpad(' ',1,' '),
--   Carry_Forward    CHAR(1) NULL,
rpad(' ',1,' '),
--   Adj_Order_for_CF_PL    CHAR(1) NULL,
rpad(' ',1,' '),
--   Expected_Turnover_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Turn_Over_Currency    CHAR(3) NULL,
rpad(' ',3,' '),
--   Expected_Profit_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Profit_Currency    CHAR(3) NULL,
rpad(' ',3,' '),
--   Nature_of_Business    CHAR(255) NULL,
rpad(' ',255,' '),
--   Free_Text2    CHAR(255) NULL,
--case when trim(FTEXT) is not null then     to_char(rpad('Deal Notes :'||trim(FTEXT),255,' ')) else rpad(' ',255,' ') end,
rpad(' ',255,' '),
--rpad(' ',255,' '),
--   Asset_Id    CHAR(16) NULL,
rpad(' ',16,' '),
--   Lease_type    CHAR(1) NULL,
rpad(' ',1,' '),
--   End_of_Lease_Option    CHAR(1) NULL,
rpad(' ',1,' '),
--   Collect_security_Deposit    CHAR(1) NULL,
rpad(' ',1,' '),
--   Adjust_Security_Deposit    CHAR(1) NULL,
rpad(' ',1,' '),
--   Agreed_Usage_Freq    CHAR(1) NULL,
rpad(' ',1,' '),
--   Agreed_Usage    CHAR(17) NULL,
lpad(' ',17,' '),
--   Collect_Tax    CHAR(1) NULL,
rpad(' ',1,' '),
--   Collect_Insu_Premium    CHAR(1) NULL,
rpad(' ',1,' '),
--   Residual_Value_type    CHAR(1) NULL,
rpad(' ',1,' '),
--   Guaranteed_by    CHAR(1) NULL,
rpad(' ',1,' '),
--   Apply_Lease_Canc_Fee    CHAR(1) NULL,
rpad(' ',1,' '),
--   Lease_Canc_not_acce_after_days    CHAR(2) NULL,
lpad(' ',2,' '),
--   Lease_Canc_not_accp_after_Mths    CHAR(2) NULL,
lpad(' ',2,' '),
--   Expected_Future_Value    CHAR(17) NULL,
lpad(' ',17,' '),
--   Carry_Over_Rents    CHAR(1) NULL,
rpad(' ',1,' '),
--   Rent_Dmd_OD_at_end_of_Mnth    CHAR(1) NULL,
rpad(' ',1,' '),
--   Rent_Dmd_OD_at_end_of_days    CHAR(3) NULL,
rpad(' ',3,' '),
--   Rent_OD_After_MMMDDD    CHAR(3) NULL,
lpad(' ',3,' '),
--   Lnk_Trade_Fin_Entity_Type    CHAR(5) NULL,
rpad(' ',5,' '),
--   Linked_Entity_Sol_ID    CHAR(8) NULL,
rpad(' ',8,' '),
--   Linked_Trade_Fin_Entity_ID    CHAR(16) NULL,
rpad(' ',16,' '),
--   Intend_to_Export    CHAR(1) NULL,
rpad(' ',1,' '),
--   Exp_Financing_Type    CHAR(1) NULL,
rpad(' ',1,' '),
--   Exp_Financing_Perc    CHAR(8) NULL,
lpad(' ',8,' '),
--   Broken_Prd_Int_Flag    CHAR(1) NULL,
rpad(' ',1,' '),
--   Normal_Hldy_Prd_in_Days    CHAR(2) NULL
rpad(' ',2,' ')       
from map_acc 
inner join v5pf on v5brnm||v5dlp||trim(v5dlr) = map_acc.leg_acc_num
left join scpf on scab||scan||scas=V5ABD||v5AND||V5ASD
left join tbaadm.lsp on tbaadm.lsp.schm_code = map_acc.schm_code and map_acc.currency=lsp.crncy_code and lsp.del_flg <> 'Y' and lsp.bank_id=get_param('BANK_ID')
left join tbaadm.gsp on tbaadm.gsp.schm_code = map_acc.schm_code and gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID')
left join tbaadm.gss on tbaadm.gss.schm_code = map_acc.schm_code and gss.del_flg <> 'Y' and gss.default_flg='Y' and  gss.bank_id=get_param('BANK_ID')
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num
--left join jgpf on jgbrnm||trim(jgdlp)||trim(jgdlr) = map_acc.leg_acc_num------changed by gopal because of duplicates in free text
left join (SELECT trim(jgbrnm)||trim(jgdlp)||trim(jgdlr) jgacc, LISTAGG(trim(jgcf), ',')  WITHIN GROUP (ORDER BY trim(jgbrnm)||trim(jgdlp)||trim(jgdlr)) FTEXT
FROM jgpf
GROUP BY trim(jgbrnm)||trim(jgdlp)||trim(jgdlr))jgpf on jgacc=map_acc.leg_acc_num 
inner join (select ombrnm||omdlp||trim(omdlr) ompf_leg_num,sum(omnwp) omnwp from ompf inner join map_acc on ombrnm||omdlp||trim(omdlr) =leg_acc_num where schm_type='LAA' and ommvt='P' and ommvts in ('C','O') group by ombrnm||omdlp||trim(omdlr))OMPF ON trim(OMPF_LEG_NUM)=LEG_ACC_NUM
--inner join obpf on obdlp=v5dlp
left join r8pf on r8lnp=trim(v5dlp)
--left join (select ombrnm,omdlp,omdlr,sum(omnwr) iomnwr   from ompf where OMMVT = 'I' and ommvts is null  group by ombrnm,omdlp,omdlr) iompf on iompf.ombrnm||iompf.omdlp||trim(iompf.omdlr)=LEG_ACC_NUM
left join iompf_laa on iompf_laa.del_ref_num=map_acc.LEG_ACC_NUM
left join (select lsbrnm,lsdlp,lsdlr,sum(lsamtd - lsamtp) sum_overdue from lspf where lsmvt='P' and (LSAMTD - LSAMTP) < 0 and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num
left join operacc oper on  trim(oper.ompf_leg_num)=leg_acc_num
left join demand_count dmd_cnt on  dmd_cnt.lsbrnm||trim(dmd_cnt.lsdlp)||trim(dmd_cnt.lsdlr)=leg_acc_num
left join loan_account_finacle_int_rate int_tbl on trim(int_acc_num)=leg_acc_num
left join owpf_note_laa on leg_acc=map_acc.leg_acc_num
left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
left join gfpf gf on gf.gfcus=map_cif.gfcus and gf.gfclc=map_cif.gfclc and gf.gfcpnc=MAP_CIF.GFCPNC
left  join retail_loans_2008 ret_loan on leg_acc_num=trim(deal_branch)||trim(ret_loan.deal_type)||trim(deal_reference)
inner join c8pf on c8ccy = otccy
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
left join iis_laa_account iis on trim(v5dlr)=dlref and act=v5act and v5brnm =substr(accc,1,4)
where map_acc.schm_type='LAA';
commit;
-----------duplicate deleted because in tbaadm.gss table duplicate entry's. Eq one product linked with multiple gl sub head code----------------------------
delete from lam_o_table where rowid not in (select min(rowid) from lam_o_table group by account_number);
commit; 
exit; 
