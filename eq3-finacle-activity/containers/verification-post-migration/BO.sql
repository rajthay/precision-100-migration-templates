========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
BO.sql 
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
'EQUATION_DR_ACC_NO'||'|'||
'FINACLE_DR_ACC_NO'||'|'||
'EQUATION_CR_ACC_NO'||'|'||
'FINACLE_CR_ACC_NO'||'|'||
'EQUATION_SI_FREQ_DAYS_NUM' ||'|'||
'LEGACY_RATE_CODE' ||'|'||
'FINACLE_RATE_CODE' ||'|'||
'LEGACY_CR_RATE_CODE' ||'|'||
'FINACLE_CR_RATE_CODE'||'|'||
'LEG_SI_REFERENCE_NUMBER'||'|'||
'ROBOT'||'|'||
'R0FRC'||'|'||
'LEG_AMOUNT_INDICATOR'||'|'||
'FIN_AMOUNT_INDICATOR'
from dual
union all
Select distinct 
'SAME CURRENCY BO' ||'|'||
to_char(si_srl_num) ||'|'||
to_char(r0ab)||'|'||
to_char(to_number(r0ab)) ||'|'||
to_char(r0an) ||'|'||
to_char(map_acc.fin_cif_id) ||'|'||
to_char(trim(mapfrequency(substr(r7frq,1,1))))||'|'||
to_char(si_rpt.SI_FREQ_TYPE) ||'|'||
case when to_char(trim(mapfrequency(substr(r7frq,1,1)))) = to_char(si_rpt.SI_FREQ_TYPE) then 'TRUE' else 'FALSE' end ||'|'||
case when trim(mapfrequency(substr(r7frq,1,1))) in('W','F','D') 
then '' else to_char(substr(r7frq,2,2)) end  ||'|'||
to_char(si_rpt.si_freq_start_dd) ||'|'||
case when (case when trim(mapfrequency(substr(r7frq,1,1))) in('W','F','D') 
then '' else to_char(substr(r7frq,2,2)) end) = lpad(to_char(si_rpt.si_freq_start_dd),2,0)  then 'TRUE' else 'FALSE' end  ||'|'||
case when r7fld = 9999999 then '' when get_date_fm_btrv(r7fld) <> 'ERROR' 
then to_char(to_date(get_date_fm_btrv(r7fld),'YYYYMMDD'),'DD-MM-YYYY') 
     end ||'|'||
case when to_char(si_rpt.SI_END_DATE,'DD-MM-YYYY')='31-12-2099' then ' ' else to_char(si_rpt.SI_END_DATE,'DD-MM-YYYY') end ||'|'||
case when (case when r7fld = 9999999 then ' ' when get_date_fm_btrv(r7fld) <> 'ERROR' 
then to_char(to_date(get_date_fm_btrv(r7fld),'YYYYMMDD'),'DD-MM-YYYY') 
     end) = (case when to_char(si_rpt.SI_END_DATE,'DD-MM-YYYY')='31-12-2099' then ' ' else to_char(si_rpt.SI_END_DATE,'DD-MM-YYYY') end) then 'TRUE' else 'FALSE' end ||'|'||
case when trim(mapfrequency(substr(r7frq,1,1))) ='M' then
    to_char(substr(r7frq,2,2))||substr(to_char(to_date(get_date_fm_btrv(r7npr),'YYYYMMDD'),'DD-MM-YYYY'),3,10)
    else to_char(to_date(get_date_fm_btrv(r7npr),'YYYYMMDD'),'DD-MM-YYYY')  end ||'|'||
to_char(si_rpt.NEXT_EXEC_DaTe,'DD-MM-YYYY') ||'|'||
case when (case when trim(mapfrequency(substr(r7frq,1,1))) ='M' then
    to_char(substr(r7frq,2,2))||substr(to_char(to_date(get_date_fm_btrv(r7npr),'YYYYMMDD'),'DD-MM-YYYY'),3,10)
    else to_char(to_date(get_date_fm_btrv(r7npr),'YYYYMMDD'),'DD-MM-YYYY')  end) = to_char(si_rpt.NEXT_EXEC_DaTe,'DD-MM-YYYY') then 'TRUE' else 'FALSE' end ||'|'||
case when trim(C8CCY)='DH' then  'AED'
else trim(c8ccy) end ||'|'||
to_char(si_rpt.crncy_code) ||'|'||
case when (case when trim(C8CCY)='DH' then  'AED'
else trim(c8ccy) end) = to_char(si_rpt.crncy_code) then 'TRUE' ELSE 'FALSE' end ||'|'||
case 
when r0FRC = 'F' then to_char(r7min/power(10,c8ced))
when r0FRC = 'R' then to_char(r7max/power(10,c8ced))
end
 ||'|'||
to_char(si_rpt.fixed_amt) ||'|'||
case when (case 
when r0FRC = 'F' then to_char(r7min/power(10,c8ced))
when r0FRC = 'R' then to_char(r7max/power(10,c8ced))
end) = to_char(si_rpt.fixed_amt)  then 'TRUE' else 'FALSE' end ||'|'||
--case when r7bot <> 'D' then to_char(LEG_BO_ACCOUNT) else TO_CHAR(map_acc1.LEG_BRANCH_ID||MAP_ACC1.LEG_SCAN||MAP_ACC1.LEG_SCAS) end ||'|'||
case when r7bot <> 'D' then to_char(LEG_BO_ACCOUNT) else TO_CHAR(nvl(map_acc1.LEG_BRANCH_ID||MAP_ACC1.LEG_SCAN||MAP_ACC1.LEG_SCAS,map_off_acc1.leg_acc_num)) end ||'|'||
to_char(si_rpt.dr_acct_number) ||'|'||
TO_CHAR(map_acc2.LEG_BRANCH_ID||MAP_ACC2.LEG_SCAN||MAP_ACC2.LEG_SCAS) ||'|'||
to_char(si_rpt.cr_acct_number)||'|'||
' '  ||'|'||
''   ||'|'||
''   ||'|'||
''   ||'|'||
''   ||'|'||
R0SEQ||'|'||
R0BOT||'|'||
r0frc||'|'||
case 
when r7bot = 'D' and r7min/power(10,c8ced) = '0' then 'C'
when r7bot = 'D' and (r7min/power(10,c8ced) <> '0' or r7min is not null) then 'C'
when r7bot = 'D' then 'C'
when r7bot = 'S' then 'C'
when r7bot = 'L' and r0frc = 'R' then 'C'
when r7bot = 'L' and r0frc = 'F' then 'D'
when r0frc = 'F' and r7min < 0 then 'D'
when r0frc = 'F' and r7min >= 0 then 'C'
when r0frc = 'R' and r7min < 0 then 'D'
when r0frc = 'R' and r7min >= 0 then 'C'
end ||'|'||
BALANCE_IND
--select 
--trim(FIN_BO_cR_ACCT),trim(cR_ACCT_NUMBER),case 
--when r7bot <> 'D' then trim(FIN_BO_ACCOUNT)
--else trim(FIN_BO_DR_ACCT) end , trim(DR_ACCT_NUMBER)
from BALANCE_ORDER
left join map_acc on FIN_DR_ACCT=fin_Acc_num
left join c8pf on trim(c8ccy) = trim(currency)
left join scpf a on scab||scan||scas=r0ab||r0an||r0as
left JOIN (SELECT * FROM MAP_ACC) MAP_ACC1 ON trim(MAP_ACC1.FIN_ACC_NUM) = case when trim(r7bot) <> 'D' then FIN_BO_ACCOUNT 
else trim(FIN_BO_DR_ACCT) end
left JOIN (SELECT * FROM MAP_off_ACC) MAP_off_ACC1 ON trim(MAP_off_ACC1.FIN_ACC_NUM) = case when trim(r7bot) <> 'D' then FIN_BO_ACCOUNT 
else FIN_BO_DR_ACCT end
LEFT JOIN (SELECT * FROM MAP_ACC) MAP_ACC2 ON trim(MAP_ACC2.FIN_ACC_NUM) = trim(BALANCE_ORDER.FIN_BO_CR_ACCT)
left join crmuser.accounts b on b.ORGKEY = map_ACC.fin_cif_id
left join (select distinct gfcpnc, fin_cif_id, individual from map_cif where del_flg<>'Y')map_cif on map_cif.fin_cif_id = map_acc.fin_cif_id
LEFT join si_rpt on 
trim(FIN_DR_ACCT) = trim(DR_ACCT_NUMBER) and FIN_CR_ACCT = trim(CR_ACCT_NUMBER) and (case 
when r0FRC = 'F' then to_char(r7min/power(10,c8ced))
when r0FRC = 'R' then to_char(r7max/power(10,c8ced))
end) = to_char(si_rpt.fixed_amt)
where trim(FIN_DR_CURRENCY) = trim(FIN_CR_CURRENCY)
AND r7npr >get_param('EODCYYMMDD') AND r7fld>get_param('EODCYYMMDD')
and r0an not in ('855100','855000') and a.scact not in ('YL','YP')
and ((R0BOT in ('D','L','S') and R0frc ='F')or (R0BOT in ('S') and R0frc ='R'));

--where  to_date(get_date_fm_btrv(r7npr),'YYYYMMDD') > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
--and
--(CASE
--             WHEN r7fld = 9999999
--                THEN TO_DATE ('20991231', 'YYYYMMDD')
--             WHEN get_date_fm_btrv (r7fld) <> 'ERROR'
--                THEN TO_DATE (get_date_fm_btrv (r7fld), 'YYYYMMDD')
--          END > TO_DATE (get_param ('EOD_DATE'), 'DD-MM-YYYY')) 
--and trim(FUND_CCY) = trim(RECV_CCY) AND r7npr >get_param('EODCYYMMDD') AND r7fld>get_param('EODCYYMMDD')
--and r0an not in ('855100','855000') and a.scact not in ('YL','YP') 
