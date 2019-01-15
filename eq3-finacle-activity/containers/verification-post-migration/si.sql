========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
si.sql 
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/si.dat
Select 
'TYPE_OF_SI' ||'|'||
'FINACLE_SI_SRL_NUM'  ||'|'||
'EQUATION_BRANCH_ID'||'|'||
'FINACLE_BRANCH_ID'||'|'||
'EQUATION_CLIENT_NO' ||'|'||
'FINACLE_CIF_ID' ||'|'||
--'EQUATION_SI_SRL_NUM'||'|'||
--'FINACLE_SI_SRL_NUM'||'|'||
'EQUATION_FREQ_TYPE'||'|'||
---'EQUATION_EXTRACTED_FREQ_TYPE'||'|'||
'FINACLE_SI_FREQ_TYPE'||'|'||
'SI_FREQ_TYPE_MATCH' ||'|'||
'EQUATION_FREQ_START_DD'||'|'||
'FINACLE_FREQ_START_DD'||'|'||
'FREQ_START_DD_MATCH' ||'|'||
'EQUATION_SI_END_DATE'||'|'||
'FINACLE_SI_END_DATE'||'|'||
'SI_END_DATE_MATCH'||'|'||
'EQUATION_SI_NEXT_EXEC_DT'||'|'||
'FINACLE_SI_NEXT_EXEC_DT'||'|'||
'NEXT_EXECUTION_DT_MATCH'||'|'||
--'LEG_BALANCE_INDICATOR' ||'|'||
--'FINACLE_BALANCE_INDICATOR' ||'|'||
--'BALANCE_INDICATOR_MATCH' ||'|'||
--'LEG_EXCESS_SHORT_INDICATOR' ||'|'||
--'FINACLE_EXCESS_SHORT_INDICATOR' ||'|'||
--'EXCESS_SHORT_INDICATOR_MATCH' ||'|'||
'EQUATION_CURRENCY'||'|'||
'FINACLE_CURRENCY'||'|'||
'CURRENCY_MATCH'||'|'||
'EQUATION_SI_AMT'||'|'||
'FINACLE_SI_AMT'||'|'||
'SI_AMT_MATCH'||'|'||
'INTERNAL_DR_ACC_NUM'||'|'||
'EQUATION_DR_ACC_NO'||'|'||
'FINACLE_DR_ACC_NO'||'|'||
'DR_ACC_MATCH'||'|'||
'INTERNAL_CR_ACC_NUM'||'|'||
'EQUATION_CR_ACC_NO'||'|'||
'FINACLE_CR_ACC_NO'||'|'||
'CR_ACC_MATCH'||'|'||
'EQUATION_SI_FREQ_DAYS_NUM' ||'|'||
'LEGACY_RATE_CODE' ||'|'||
'FINACLE_RATE_CODE' ||'|'||
'LEGACY_CR_RATE_CODE' ||'|'||
'FINACLE_CR_RATE_CODE'||'|'||
'LEG_SI_REFERENCE_NUMBER'||'|'||
'PR_SRL_NUM'||'|'||
'FIN_REF_NO'||'|'||
'PAYSIS_ID'||'|'||
'LEG_NAME'||'|'||
'FIN_NAME'||'|'||
'DETAILS_MATCH'||'|'||
'LEG_IBAN'||'|'||
'FIN_IBAN'||'|'||
'IBAN_MATCH'||'|'||
'LEG_PAYEE_BANK_CODE'||'|'||
'FIN_PAYEE_BANK_CODE'||'|'||
'PAYEE_BANK_CODE_MATCH'||'|'||
'LEG_PAYEE_BR_BRANCH'||'|'||
'FIN_PAYEE_BR_CODE'||'|'||
'PAYEE_BR_CODE_MATCH'
from dual
union all
Select distinct
'SAME CURRENCY SI' ||'|'||
to_char(SI_SRL_NUM) ||'|'|| 
to_char(r5ab) ||'|'||
to_char(nvl(map_acc.fin_sol_id,map_sol.fin_sol_id)) ||'|'||  
to_char(r5an) ||'|'||
to_char(map_ACC.fin_cif_id) ||'|'||
--'EQUATION_SI_SRL_NUM'||'|'||
--'FINACLE_SI_SRL_NUM'||'|'||
to_char(mapfrequency(substr(VW_ACTIVE_SI.r5afr,1,1))) ||'|'||
---'EQUATION_EXTRACTED_FREQ_TYPE'||'|'||
to_char(si_rpt.SI_FREQ_TYPE) ||'|'||
case when to_char(trim(mapfrequency(substr(VW_ACTIVE_SI.r5afr,1,1)))) = to_char(si_rpt.SI_FREQ_TYPE) then 'TRUE' else 'FALSE' end ||'|'||
case when trim(mapfrequency(substr(VW_ACTIVE_SI.r5afr,1,1))) in('W','F','D') 
then '' else to_char(substr(VW_ACTIVE_SI.r5afr,2,2)) end  ||'|'||
to_char(si_rpt.si_freq_start_dd) ||'|'||
case when (case when trim(mapfrequency(substr(VW_ACTIVE_SI.r5afr,1,1))) in('W','F','D') 
then '' else to_char(substr(VW_ACTIVE_SI.r5afr,2,2)) end) = lpad(to_char(si_rpt.si_freq_start_dd),2,0) then 'TRUE' else 'FALSE' end ||'|'||
  case
  when VW_ACTIVE_SI.r5fld='9999999' then ' '
  when get_date_fm_btrv(VW_ACTIVE_SI.r5fld)<>0 and get_date_fm_btrv(VW_ACTIVE_SI.r5fld) <> 'ERROR' then
  to_char(to_date(get_date_fm_btrv(VW_ACTIVE_SI.r5fld),'YYYYMMDD'),'DD-MM-YYYY') end ||'|'||
case when to_char(si_rpt.SI_END_DATE,'DD-MM-YYYY')='31-12-2099' then ' ' else to_char(si_rpt.SI_END_DATE,'DD-MM-YYYY') end ||'|'||
case when(case
  when VW_ACTIVE_SI.r5fld='9999999' then ' '
  when get_date_fm_btrv(VW_ACTIVE_SI.r5fld)<>0 and get_date_fm_btrv(VW_ACTIVE_SI.r5fld) <> 'ERROR' then
  to_char(to_date(get_date_fm_btrv(VW_ACTIVE_SI.r5fld),'YYYYMMDD'),'DD-MM-YYYY') end) = (case when to_char(si_rpt.SI_END_DATE,'DD-MM-YYYY')='31-12-2099' then ' ' else to_char(si_rpt.SI_END_DATE,'DD-MM-YYYY') end) then 'TRUE' else 'FALSE' end  ||'|'||
case when get_date_fm_btrv(VW_ACTIVE_SI.r5npr)<>0 and get_date_fm_btrv(VW_ACTIVE_SI.r5npr) <> 'ERROR' then 
  RPAD(to_char(to_date(get_date_fm_btrv(VW_ACTIVE_SI.r5npr),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end ||'|'||
to_char(si_rpt.NEXT_EXEC_DaTe,'DD-MM-YYYY') ||'|'||
case when (case when get_date_fm_btrv(VW_ACTIVE_SI.r5npr)<>0 and get_date_fm_btrv(VW_ACTIVE_SI.r5npr) <> 'ERROR' then 
  RPAD(to_char(to_date(get_date_fm_btrv(VW_ACTIVE_SI.r5npr),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end) = to_char(si_rpt.NEXT_EXEC_DaTe,'DD-MM-YYYY') then 'TRUE' else 'FALSE' end ||'|'||
FUND_CCY ||'|'||
to_char(si_rpt.crncy_code) ||'|'||
case when (case when trim(c8ccy)='DH' then 'AED' else trim(c8ccy) end) = to_char(si_rpt.crncy_code) then 'TRUE' else 'FALSE' end ||'|'||
to_char(abs(to_number(VW_ACTIVE_SI.r5rpa)/POWER(10,c8pf.C8CED))) ||'|'||
to_char(si_rpt.fixed_amt) ||'|'||
case when to_char(abs(to_number(VW_ACTIVE_SI.r5rpa)/POWER(10,c8pf.C8CED))) = to_char(si_rpt.fixed_amt) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(nvl(map_acc1.LEG_BRANCH_ID||MAP_ACC1.LEG_SCAN||MAP_ACC1.LEG_SCAS,map_off_acc1.leg_acc_num))||'|'||
to_char(r5ab||r5an||r5as)||'|'||
--to_char(af.scab||af.scan||af.scas)||'|'||
to_char(nvl(trim(map_acc1.fin_acc_num),map_off_acc1.fin_acc_num))||'|'||
to_char(si_rpt.dr_acct_number)||'|'||
case when trim(to_char(nvl(trim(map_acc1.fin_acc_num),map_off_acc1.fin_acc_num))) = trim(to_char(si_rpt.dr_acct_number)) then 'TRUE' else 'FALSE' end||'|'||
--to_char (nvl(map_acc2.LEG_BRANCH_ID||MAP_ACC2.LEG_SCAN||MAP_ACC2.LEG_SCAS,map_off_acc2.leg_acc_num)) ||'|'||
--to_char(af1.scab||af1.scan||af1.scas)||'|'||
to_char(r5rab||r5ran||r5ras)||'|'||
to_char(nvl(map_acc2.fin_acc_num,map_off_acc1.fin_acc_num)) ||'|'||
to_char(si_rpt.cr_acct_number)||'|'||
case when trim(to_char(nvl(map_acc2.fin_acc_num,map_off_acc1.fin_acc_num)))=trim(to_char(si_rpt.cr_acct_number)) then 'TRUE' else 'FALSE' end ||'|'||
' '  ||'|'||
' ' ||'|'||
' ' ||'|'||
' ' ||'|'||
' ' ||'|'||
to_char(R5sor)||'|'||
to_char(r5ab||r5an||r5as||R5SOR)||'|'||
to_char(si_rpt.REF_NUM)||'|'||
case when trim(rstd.REF_NUM) is not null then 'SWIFT' else '' end||'|'||
to_char(Details)||'|'||
to_char(PARTY_NAME)||'|'||
case when nvl(trim(Details),'.') = nvl(trim(PARTY_NAME),'.') then 'TRUE' else 'FALSE' end||'|'||
to_char(iban)||'|'||
to_char(OTHER_PARTY_NAME)||'|'||
case when nvl(trim(iban),'.')=nvl(trim(OTHER_PARTY_NAME),'.') then 'TRUE' else 'FALSE' end||'|'||
to_char(BENEF_BANK)||'|'||
to_char(PAYEE_BANK_CODE)||'|'|| 
case when nvl(trim(BENEF_BANK),'.') = nvl(trim(PAYEE_BANK_CODE),'.') then 'TRUE' else 'FALSE' end ||'|'||
to_char(BENEF_BRANCH) ||'|'||
to_char(PAYEE_BR_CODE)||'|'||
case when nvl(trim(BENEF_BRANCH),'.')=nvl(trim(PAYEE_BR_CODE),'.') then 'TRUE' else 'FALSE' end 
from active_si VW_ACTIVE_SI
inner join C8PF on C8CCYN = VW_ACTIVE_SI.R5CCY
inner join scpf on r5ab||r5an||r5as=scab||scan||scas
inner join map_sol on br_code=trim(r5ab)
left join (select * from map_cif where del_flg<>'Y')map_cif on map_cif.gfcpnc = trim(VW_ACTIVE_SI.r5an)
left join crmuser.accounts b on b.ORGKEY = map_cif.fin_cif_id
left join map_acc on leg_branch_id || leg_scan||leg_scas =  r5ab||r5an||r5as
inner join si_rpt on  abs(to_number(VW_ACTIVE_SI.r5rpa)/POWER(10,c8pf.C8CED)) = si_rpt.fixed_amt
and 
case when get_date_fm_btrv(VW_ACTIVE_SI.r5npr)<>0 and get_date_fm_btrv(VW_ACTIVE_SI.r5npr) <> 'ERROR' then 
  RPAD(to_char(to_date(get_date_fm_btrv(VW_ACTIVE_SI.r5npr),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end = to_char(si_rpt.NEXT_EXEC_DATE,'DD-MM-YYYY') 
and to_char(fund_account) = to_char(si_rpt.dr_acct_number) and trim(to_char(R5sor))=trim(si_rpt.ref_num)
left join (select * from map_acc) map_acc1 on trim(map_acc1.fin_acc_num) = trim(VW_ACTIVE_SI.FUND_ACCOUNT)
left join (select * from map_acc) map_acc2 on trim(map_acc2.fin_acc_num) = trim(VW_ACTIVE_SI.recv_account)
left join (select * from map_off_acc) map_off_acc1 on map_off_acc1.fin_acc_num = trim(VW_ACTIVE_SI.FUND_ACCOUNT)
left join (select * from map_off_acc) map_off_acc2 on map_off_acc2.fin_acc_num = trim(VW_ACTIVE_SI.recv_account)
left join siu_tt ON trim(FUND_ACCOUNT)||TRIM(R5SOR) =trim(FUND_ACCT_NUM)||TRIM(SO_REF)
left join SIU_TT_BANK on BANK_NAME=BENEF_ACCT_NAME
left join (select * from tbaadm.pyrd pd
inner join tbaadm.pyrh ph on pd.PR_SRL_NUM=ph.PR_SRL_NUM 
inner join tbaadm.rstd rs on rs.PR_SRL_NUM=ph.PR_SRL_NUM
left join tbaadm.gam on pd.acid=gam.acid)rstd  on trim(r5ab||r5an||r5as||R5SOR)= trim(rstd.REF_NUM)
left join all_final_trial_balance af on  trim(si_rpt.dr_acct_number)=af.fin_acc_num
--left join all_final_trial_balance af1 on  trim(si_rpt.cr_acct_number)=af1.fin_acc_num
WHERE trim(FUND_CCY) = trim(RECV_CCY) and  R5NPR>get_param('EODCYYMMDD') and r5fld>get_param('EODCYYMMDD');
exit; 
