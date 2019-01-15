========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
ns_laa_master.sql 
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/KW_NONSTAFF_LAA.dat
select   
'EXTERNAL_ACC_NO'||'|'||
'LEG_BRCH_ID'||'|'||
'FINACLE_SOL_ID'||'|'||
'BRANCH_ID_MATCH'||'|'||
'LEG_CLIENT_NO'||'|'||
'LEG_SUFFIX'||'|'||
'LEG_CCY'||'|'||
'FINACLE_CCY'||'|'||
'CCY_MATCH'||'|'||
'FINACLE_CIF_ID'||'|'||
'LEG_CONTRACT'||'|'||
'LEG_DEAL_REF_NUMBER' ||'|'||
'FINACLE_ACCT_NUM'||'|'||
'LEG_CUST_TYPE'||'|'||
'LEG_ACCT_TYPE'||'|'||
'FINACLE_SCHEME_CODE'||'|'||
'FINACLE_CUST_NAME' ||'|'||
--'FINACLE_REPRICING_PLAN'||'|'||
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
'LEG_REPY_PRD_IN_MONS'||'|'||
'FINACLE_REPY_PRD_IN_MON'||'|'||
'REPY_PRD_IN_MON_MATCH'||'|'||
'LEG_LIAB_TRF_UPD_AMOUNT'||'|'||
'FINACLE_LIAB_TRF_UPD_AMOUNT'||'|'||
'LIAB_TRF_UPD_AMOUNT_MATCH'||'|'||
'LEG_REPAY_SCHEDULE_DATE'||'|'||
'FINACLE_REPAY_SCHEDULE_DATE'||'|'||
'REPAY_SCHEDULE_DATE_MATCH'||'|'||
'LEG_OPERATIVE_BRANCH'||'|'||
'LEG_OPERATIVE_CLIENT_NO'||'|'||
'LEG_OPERATIVE_ORDINAL'||'|'||
'LEG_OPERATIVE_ACC'||'|'||
'FIN_OPER_ACC'||'|'||
'OPERATIVE_ACC_MATCH'||'|'||
'LEG_OPERATIVE_CCY'||'|'||
'LEG_TENOR_IN_MONTHS'||'|'||
'FINACLE_TENOR_IN_MONTHS'||'|'||
'TENOR_IN_MONTHS_MATCH'||'|'||
'LEG_TENOR_IN_DAYS'||'|'||
'FINACLE_TENOR_IN_DAYS'||'|'||
'TENOR_IN_DAYS_MATCH'||'|'||
'PURPOSE_OF_LOAN'||'|'||
'FIN_PURPOSE_OF_LOAN'||'|'||
'PURPOSE_OF_LOAN_MATCH'||'|'||
'PURPOSE_OF_LOAN_DESC'||'|'||
'LEG_LEDGER_BAL'||'|'||
'FIN_LEDGER_BAL'||'|'||
'LEDGER_MATCH'||'|'||
'FIN_DUE_AMT'||'|'||
--'LEG_DUE_AMT'||'|'||
'EARLIER_DUE_AMT'||'|'||
'DUE_AMT_MATCH'||'|'||
'LEG_DUE_DAYS'||'|'||
'FIN_DUE_DAYS'||'|'||
'DUE_DAYS_MATCH'||'|'||
'LEG_DUE_DATE'||'|'||
'FIN_DUE_DATE'||'|'||
'DUE_DATE_MATCH'||'|'||
'LEG_ACCRUED_AMT'||'|'||
'FIN_ACCRUED_AMT'||'|'||
'ACCURUAL_MATCH'||'|'||
'REPRISING_DATE'||'|'||
'LEG_E2CODE'||'|'||
'FINACLE_REPRICING_PLAN'||'|'||
'TBL_CODE'||'|'||
'FIN_BASE_RATE'||'|'||
'FIN_DEBIT_PERCENT'||'|'||
'FIN_PREF_RATE'||'|'||
'FIN_NET_RATE'||'|'||
'LEGACY_NET_RATE'||'|'||
'NET_RATE_MATCH'||'|'||
'LEG_PRI_INSTALLMENT_AMOUNT'||'|'||
'FIN_PRI_INSTALLMENT_AMOUNT'||'|'||
'PRINCIPAL_INSTALLMENT_MATCH'||'|'||
'LEG_INT_INSTALLMENT_AMOUNT'||'|'||
'FIN_INT_INSTALLMENT_AMOUNT'||'|'||
'INTEREST_AMOUNT_MATCH'||'|'||
'TOTAL_LEG_INSTALLMENT_AMOUNT'||'|'||
'TOTAL_FIN_INSTALLMENT_AMOUNT'||'|'||
'INTALLMENT_AMOUNT_MATCH'
from dual
union all
select 
to_char(map_acc.EXTERNAL_ACC)||'|'||
to_char(map_acc.leg_branch_id) ||'|'|| 
to_char(gam.sol_id)||'|'||
case when substr(map_acc.leg_branch_id,2,4) = gam.sol_id then 'TRUE' else 'FALSE' end  ||'|'||
to_char(map_acc.leg_scan) ||'|'||
to_char(map_acc.LEG_SCAS)||'|'||
map_acc.currency||'|'||
gam.acct_crncy_code ||'|'||
CASE WHEN map_acc.currency = gam.acct_crncy_code THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(gam.cif_id) ||'|'||
map_acc.leg_acc_num||'|'||
to_char(V5DLR) ||'|'||
to_char(gam.foracid) ||'|'|| 
map_acc.leg_cust_type ||'|'||
map_acc.leg_acct_type ||'|'|| 
map_acc.schm_code ||'|'||
gam.ACCT_NAME||'|'||
--to_char(lrp.repricing_plan) ||'|'||
case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY') end ||'|'||
TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY')||'|'||
case when  case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end  = gam.acct_opn_date then 'TRUE' else 'FALSE' end ||'|'||
to_char(case when r8crl='Y' then (ompf.omnwp/POWER(10,c8pf.C8CED))-(nvl(iomnwr,0)/POWER(10,c8pf.C8CED))
    else to_number(ompf.omnwp)/POWER(10,c8pf.C8CED) end)||'|'||
    to_char(gam.sanct_lim) ||'|'||
CASE WHEN case when r8crl='Y' then (ompf.omnwp/POWER(10,c8pf.C8CED))-(nvl(iomnwr,0)/POWER(10,c8pf.C8CED))
    else to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)end = gam.sanct_lim THEN 'TRUE' ELSE 'FALSE' END ||'|'||
case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')end ||'|'||
TO_CHAR (lht.lim_sanct_date,'DD-MM-YYYY') ||'|'||
case when case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')end =lht.lim_sanct_date then 'TRUE' else 'FALSE' end ||'|'||
case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MON-YYYY')end ||'|'||
TO_CHAR (lht.lim_exp_date,'DD-MON-YYYY') ||'|'||   
CASE WHEN case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')end = lht.lim_exp_date THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end)||'|'||
to_char(lam.rep_perd_mths)||'|'||
case when case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end=lam.rep_perd_mths then 'TRUE' else 'FALSE' end ||'|'||
to_char(to_number(otdla)/POWER(10,c8pf.C8CED))||'|'||
to_char(lam.liab_as_on_xfer_eff_date)||'|'||
case when to_number(otdla)/POWER(10,c8pf.C8CED)=lam.liab_as_on_xfer_eff_date then 'TRUE' else 'FALSE' END ||'|'||
case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY') end ||'|'||
TO_CHAR (lam.rep_shdl_date,'DD-MON-YYYY')||'|'||  
case when case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end=lam.rep_shdl_date then 'TRUE' else 'FALSE' end ||'|'||
to_char(substr(NEEAN,1,4))||'|'||
to_char(substr(NEEAN,5,6))||'|'||
to_char(substr(NEEAN,11,3))||'|'||
to_char(NEEAN)||'|'||
CASE WHEN L.OP_ACID IS NOT NULL THEN G1.FORACID ELSE '' END ||'|'||
case when to_char(nvl(trim(NEEAN),' ')) = to_char(nvl(CASE WHEN trim(L.OP_ACID) IS NOT NULL THEN trim(G1.FORACID) END,' ')) then 'TRUE' else 'FALSE' end ||'|'||
to_char(oper.currency) ||'|'||
to_char(case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end )||'|'||
to_char(lam.rep_perd_mths) ||'|'|| 
case when case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end=lam.rep_perd_mths then 'TRUE' else 'FALSE' end ||'|'||
to_char(case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
 else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end)||'|'||
to_char(lam.rep_perd_days) ||'|'||
case when case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
     to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
 =lam.rep_perd_days then 'TRUE' else 'FALSE' end ||'|'||
to_char(SCC2R)||'|'||
TO_CHAR(GAC.PURPOSE_OF_ADVN)||'|'||
case when nvl(TRIM(SCC2R),' ') = nvl(GAC.PURPOSE_OF_ADVN,' ') then 'TRUE' else 'FALSE' end ||'|'||
REF_DESC||'|'||
case when  V5BAL is not null then to_char(to_number(v5bal)/POWER(10,C8CED)) else '0.01' end||'|'||
to_char(gam.CLR_BAL_AMT)||'|'||
case when case when  V5BAL is not null then to_number(v5bal)/POWER(10,C8CED) else 0.01 end=gam.CLR_BAL_AMT then 'TRUE' else 'FALSE' end ||'|'||
abs(LDT.DMD_AMT1)||'|'||
--abs(ls.sp/c8pwd)||'|'||
abs(lsamt.sp/c8pwd)||'|'||
case when nvl(abs(LDT.DMD_AMT1),0) = nvl(abs(lsamt.sp/c8pwd),0) then 'TRUE' else 'FALSE' end ||'|'||
case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date(get_param('EOD_DATE'),'DD-MM-YYYY')) else 0 end||'|'||
gac.DPD_CNTr||'|'||
case when nvl(to_number(case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date(get_param('EOD_DATE'),'DD-MM-YYYY')) else 0 end),0) = nvl(gac.DPD_CNTr,0) then 'TRUE' else 'FALSE' end||'|'||
to_char(case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then to_char(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD'),'DD-MON-YYYY') else ' ' end)||'|'||
to_char(DB_STAT_DATE - gac.DPD_CNTR)||'|'||
case when (to_char(case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then to_char(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD'),'DD-MON-YY') else '20-FEB-17' end)) = (to_char(DB_STAT_DATE - gac.DPD_CNTR)) then 'TRUE' else 'FALSE' end||'|'||
to_char(eitt.NRML_ACCRUED_AMOUNT_DR)||'|'||
to_char(eit.NRML_ACCRUED_AMOUNT_DR)||'|'||
case when to_char(nvl(eitt.NRML_ACCRUED_AMOUNT_DR,'0'))=to_char(nvl(eit.NRML_ACCRUED_AMOUNT_DR,'0')) then 'TRUE' else 'FALSE' end||'|'||
itb.REPRICING_DATE||'|'||
to_char(v5pf.v5brr)||'|'||
to_char(lrp.repricing_plan)||'|'||
to_char(TBL_CODE)||'|'||
to_char(nvl(lt.BASE_PCNT_DR,0))||'|'||
--to_char(fin_interest_rates.base_rate) ||'|'||
to_char(nvl(lt.DR_NRML_INT_PCNT,0))||'|'||
--to_char(fin_interest_rates.NRML_INT_PCNT)||'|'||
to_char(nvl(lt.ACTUAL_PREF_RATE,0))||'|'||
--to_char(fin_interest_rates.pref_rate)||'|'||
--abs(to_number(to_char(fin_interest_rates.FIN_NET_RATE)))||'|'||
abs(to_number(to_char(nvl(lt.BASE_PCNT_DR,0)+nvl(lt.DR_NRML_INT_PCNT,0)+nvl(lt.ACTUAL_PREF_RATE,0))))||'|'||
to_char(nvl(lt.acc_pref_rate,0))||'|'||
case when abs(to_number(to_char(nvl(lt.acc_pref_rate,0))))=abs(to_number(to_char(nvl(lt.BASE_PCNT_DR,0)+nvl(lt.DR_NRML_INT_PCNT,0)+nvl(lt.ACTUAL_PREF_RATE,0)))) then 'TRUE' else 'FALSE' end ||'|'||
--case when abs(to_number(to_char(lt.acc_pref_rate)))=abs(to_number(to_char(fin_interest_rates.FIN_NET_RATE))) then 'TRUE' else 'FALSE' end ||'|'||
case when ina.ins is null then 0 else to_number(ina.ins)/POWER(10,C8CED) end||'|'||
nvl(lrs.PRINCIPAL_AMT,0) ||'|'||
case when case when ina.ins is null then 0 else to_number(ina.ins)/POWER(10,C8CED)end = lrs.PRINCIPAL_AMT then 'TRUE' else 'FALSE' end||'|'||
case when ii.ins is null then 0 else  to_number(ii.ins)/POWER(10,C8CED) end||'|'||
nvl(lrs.INTEREST_AMT,0)||'|'||
case when case when ii.ins is null then 0 else  to_number(ii.ins)/POWER(10,C8CED) end = lrs.INTEREST_AMT then 'TRUE' else 'FALSE' end ||'|'||
to_char(case when ina.ins is null and ii.ins is null then 0 else (case when ina.ins is null then 0 else to_number(ina.ins)/POWER(10,C8CED) end)+(case when ii.ins is null then 0 else to_number(ii.ins)/POWER(10,C8CED) end) end)||'|'||
to_char(nvl(lrs.INSTALLMENT_AMT,0))||'|'||
case when case when ina.ins is null and ii.ins is null then 0 else (case when ina.ins is null then 0 else to_number(ina.ins)/POWER(10,C8CED) end)+(case when ii.ins is null then 0 else to_number(ii.ins)/POWER(10,C8CED) end) end = lrs.INSTALLMENT_AMT then 'TRUE' else 'FALSE' end --||'|'|| 
--lid.isd||'|'||
--lrs_lid.Inst_date
from (select * from map_acc where schm_type='LAA') map_acc
inner join (select * from map_cif where IS_JOINT<>'Y' ) map_cif on MAP_ACC.FIN_CIF_ID=map_cif.fin_cif_id
INNER join (select * from gfpf where gfctp not in('EC','EV','EW'))gfpf on nvl(TRIM(gfpf.gfclc),' ')=nvl(TRIM(map_cif.gfclc),' ') and  TRIM(gfpf.gfcus)=TRIM(map_cif.gfcus)
inner JOIN tbaadm.gam ON gam.foracid = map_acc.fin_acc_num and gam.bank_id=get_param('BANK_ID') and gam.schm_type='LAA'
inner join v5pf on v5brnm||v5dlp||trim(v5dlr) = leg_acc_num
LEFT JOIN tbaadm.lrp ON lrp.acid = gam.acid and lrp.bank_id=get_param('BANK_ID')
inner join otpf on otbrnm||otdlp||trim(otdlr) = leg_acc_num
inner join (select ombrnm||omdlp||trim(omdlr) ompf_leg_num,sum(omnwp) omnwp from ompf inner join map_acc on ombrnm||omdlp||trim(omdlr) =leg_acc_num where schm_type='LAA' and ommvt='P' and ommvts in ('C','O') group by ombrnm||omdlp||trim(omdlr))OMPF ON OMPF_LEG_NUM=LEG_ACC_NUM
inner join c8pf on c8ccy = currency
left join iompf_laa on del_ref_num=LEG_ACC_NUM
left join r8pf on trim(r8lnp)=trim(v5dlp)
LEFT JOIN tbaadm.lht ON lht.acid = gam.acid and lht.bank_id=get_param('BANK_ID')
LEFT JOIN (select i1.* from tbaadm.itc i1
left join (select * from tbaadm.itc where bank_id='01')i2 on (i1.entity_id=i2.entity_id and i1.INT_TBL_CODE_SRL_NUM > i2.INT_TBL_CODE_SRL_NUM)  
where i1.bank_id='01' and i2.entity_id is null)itc  ON itc.entity_id = gam.acid AND ITC.ENTITY_TYPE='ACCNT'  and itc.bank_id=get_param('BANK_ID')
INNER JOIN tbaadm.lam  ON lam.acid = gam.acid AND LAM.bank_id=get_param('BANK_ID')
left join operacc oper on  TRIM(oper.ompf_leg_num)=leg_acc_num
left join  nepf on trim(OPER_LEG_ACC)=trim(neab)||trim(nean)||trim(neas)
LEFT JOIN TBAADM.LAM L ON L.ACID=gam.ACID AND gam.BANK_ID=L.BANK_ID
LEFT JOIN TBAADM.GAM G1 ON G1.ACID=L.OP_ACID AND L.BANK_ID=G1.BANK_ID
LEFT JOIN tbaadm.gac ON gac.acid = gam.acid AND GAC.bank_id=get_param('BANK_ID')
left join scpf on scab||scan||scas=V5ABD||v5AND||V5ASD
left join loan_account_finacle_int_rate lt on lt.int_acc_num=leg_acc_num
left JOIN TBAADM.RCT ON GAC.PURPOSE_OF_ADVN=RCT.REF_CODE AND RCT.BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='41'
left join (select o1.ombrnm||o1.omdlp||trim(o1.omdlr) del_ref_num,o1.omnwr ins,to_date(get_date_fm_btrv(o1.OmDTE),'YYYYMMDD') isd from ompf o1 inner join map_acc on o1.ombrnm||o1.omdlp||trim(o1.omdlr) =leg_acc_num 
INNER JOIN (select ombrnm,omdlp,omdlr, min(om.omdte) omdte from ompf om where om.ommvt='P' and om.OMMVTs='R' and TO_NUMBER(om.omdte)>TO_NUMBER(get_param('EODCYYMMDD')-1) and om.omnwr!=0 GROUP BY ombrnm,omdlp,omdlr)OM ON om.ombrnm=o1.ombrnm AND om.omdlp=o1.omdlp AND om.omdlr=o1.omdlr and oM.omdte=o1.omdte 
where o1.ommvt='P' and o1.OMMVTs='R' AND schm_type='LAA')ina on ina.del_ref_num=leg_acc_num
LEFT JOIN (select distinct ca1.foracid,ca1.flow_date,ca1.INSTALLMENT_AMT,ca1.PRINCIPAL_AMT,ca1.INTEREST_AMT,ca1.BANK_ID from custom.c_amort ca1 where ca1.bank_id='01' 
and ca1.SERIAL_NUM=(select min(ca2.serial_num) from custom.c_amort ca2 where INSTALLMENT_AMT<>0 and flow_date > to_date('3-7-2017','DD-MM-YYYY') and ca1.foracid=ca2.foracid group by ca2.foracid) ) lrS ON lrs.foracid = gam.foracid 
--LEFT JOIN (select distinct ca1.foracid,ca1.flow_date Inst_date,ca1.INSTALLMENT_AMT,ca1.PRINCIPAL_AMT,ca1.INTEREST_AMT,ca1.BANK_ID from custom.c_amort ca1 where ca1.bank_id='01' 
--and ca1.SERIAL_NUM=(select max(ca2.serial_num) from custom.c_amort ca2 where INSTALLMENT_AMT<>0 and flow_date < to_date('3-7-2017','DD-MM-YYYY') and ca1.foracid=ca2.foracid group by ca2.foracid) ) lrS_lid ON lrs.foracid = gam.foracid  
left join (select o2.ombrnm||o2.omdlp||trim(o2.omdlr) del_ref_num,o2.omnwr ins,to_date(get_date_fm_btrv(o2.OmDTE),'YYYYMMDD') isd from ompf o2 inner join map_acc on o2.ombrnm||o2.omdlp||trim(o2.omdlr) =leg_acc_num 
INNER JOIN (select ombrnm,omdlp,omdlr, min(om.omdte) omdte from ompf om where om.ommvt in ('I','P') and (TRIM(om.OMMVTs)= 'R' or TRIM(om.OMMVTs) IS NULL) and TO_NUMBER(om.omdte)>TO_NUMBER(get_param('EODCYYMMDD')-1) and om.omnwr!=0 GROUP BY ombrnm,omdlp,omdlr)OM ON om.ombrnm=o2.ombrnm AND om.omdlp=o2.omdlp AND om.omdlr=o2.omdlr and oM.omdte=o2.omdte 
where o2.ommvt='I' and TRIM(o2.OMMVTs) IS NULL AND schm_type='LAA')ii on ii.del_ref_num=leg_acc_num
--left join (select o1.ombrnm||o1.omdlp||trim(o1.omdlr) del_ref_num,o1.omnwr ins,to_date(get_date_fm_btrv(o1.OmDTE),'YYYYMMDD') isd from ompf o1 inner join map_acc on o1.ombrnm||o1.omdlp||trim(o1.omdlr) =leg_acc_num 
--INNER JOIN (select ombrnm,omdlp,omdlr, max(om.omdte) omdte from ompf om where om.ommvt in ('P','I') and TO_NUMBER(om.omdte)<TO_NUMBER(get_param('EODCYYMMDD')) and om.omnwr!=0 GROUP BY ombrnm,omdlp,omdlr)OM ON om.ombrnm=o1.ombrnm AND om.omdlp=o1.omdlp AND om.omdlr=o1.omdlr and oM.omdte=o1.omdte 
--where o1.ommvt in ('P','I') AND schm_type='LAA')lid on lid.del_ref_num=leg_acc_num
left join (select acid,sum(dmd_amt)dmd_amt1,min(dmd_date)dmd_date1 from tbaadm.ldt where bank_id=get_param('BANK_ID') group by  acid)ldt on ldt.acid=gam.acid
left join (select trim(lsbrnm)||trim(lsdlp)||trim(lsdlr) del_num,sum((abs(lsamtd)-abs(lsamtp)))sp,min(lsdte)dte from lspf where lspdte='9999999' and TO_NUMBER(lsdte)<=TO_NUMBER(get_param('EODCYYMMDD')) and ((abs(lsamtd)-abs(lsamtp))+lsup)<>0 group by trim(lsbrnm)||trim(lsdlp)||trim(lsdlr))lsamt on lsamt.del_num =leg_acc_num
left join (select lsbrnm||trim(lsdlp)||trim(lsdlr) del_num ,sum(lsamtd - lsamtp) sp,min(lsdte)dte from lspf where lsmvt='P' and (LSAMTD - LSAMTP) < 0 and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)ls on ls.del_num=leg_acc_num
left join tbaadm.gct gct on gct.bank_id='01' 
left join CUSTOM_EIT eitt on eitt.foracid=gam.foracid
left join int_tbl itb on itb.INT_ACC_NUM = leg_acc_num
left join (select * from tbaadm.eit where bank_id='01')eit on eit.entity_id=gam.acid
where map_acc.schm_type='LAA'  and gfpf.gfctp not in('EC','EV','NW');
exit; 
