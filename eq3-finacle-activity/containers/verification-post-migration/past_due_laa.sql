========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
past_due_laa.sql 
select distinct
LEG_Branch_id||leg_scan||leg_scas LEG_ACC_NUMBER,
leg_acc_num LEG_DEAL_NUMBER,
map_acc.schm_code,
LEG_ACCT_TYPE,
foracid,
FIN_CIF_ID,
otdla/c8pwd AMOUNT_OUTSTANDING,
abs(lsamt.sp/c8pwd) LEG_PAST_DUE_AMT,
abs(LDT.DMD_AMT1) FIN_PAST_DUE_AMT,
case when nvl(abs(LDT.DMD_AMT1),0) = nvl(abs(lsamt.sp/c8pwd),0) then 'TRUE' else 'FALSE' end PAST_DUE_AMT_MATCH,
case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date(get_param('EOD_DATE'),'DD-MM-YYYY')) else 0 end LEG_PD_DAYS,
gac.DPD_CNTR FIN_PD_DAYS,
case when nvl(to_number(case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then abs(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD') - to_date(get_param('EOD_DATE'),'DD-MM-YYYY')) else 0 end),0) = nvl(gac.DPD_CNTr,0) then 'TRUE' else 'FALSE' end PD_DAYS_MATCH,
to_char(case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then to_char(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD'),'DD-MON-YYYY') else ' ' end) LEG_PD_DATE,
	to_char(dmd_date1,'DD-MON-YYYY') FIN_PD_DATE,
case when nvl(trim(to_char(case when ls.dte>0 and ls.dte is not null and ls.dte!= '9999999' then to_char(to_date(get_date_fm_btrv(ls.dte),'YYYYMMDD'),'DD-MON-YYYY') else ' ' end)),'*')=nvl(to_char(dmd_date1,'DD-MON-YYYY'),'*') then 'TRUE' else 'FALSE' end PD_DATE_MATCH,
--case when ls_fee.lsupp <> 0 then to_char(abs(to_number(ls_fee.lsupp))/POWER(10,c8pf.C8CED)) else '0' end LEG_SUSPENSE_AMT,
to_char(nvl(INT_SUSPENSE_AMT,0)) FIN_SUSPENSE_AMT
--case when (case when ls_fee.lsupp <> 0 then to_char(abs(to_number(ls_fee.lsupp))/POWER(10,c8pf.C8CED)) else '0' end)=to_char(nvl(SYS_CALC_CHRGE_AMT,0)) then 'TRUE' else 'FALSE' end SUSPENSE_MATCH
from (select * from map_acc where schm_type='LAA')map_acc
inner join c8pf on c8ccy = currency
left join (select trim(lsbrnm)||trim(lsdlp)||trim(lsdlr) del_num,sum((abs(lsamtd)-abs(lsamtp)))sp,min(lsdte)dte from lspf where lspdte='9999999' and TO_NUMBER(lsdte)<=TO_NUMBER(get_param('EODCYYMMDD')) and ((abs(lsamtd)-abs(lsamtp))+lsup)<>0 group by trim(lsbrnm)||trim(lsdlp)||trim(lsdlr))lsamt on lsamt.del_num =leg_acc_num
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num
inner JOIN (select * from tbaadm.gam where gam.bank_id='01' and schm_type='LAA')gam ON gam.foracid = map_acc.fin_acc_num 
left join (select acid,sum(dmd_amt)dmd_amt1,min(dmd_date)dmd_date1 from tbaadm.ldt where bank_id=get_param('BANK_ID') group by  acid)ldt on ldt.acid=gam.acid
LEFT JOIN (select * from tbaadm.gac where bank_id='01')gac ON gac.acid = gam.acid 
left join (select lsbrnm||trim(lsdlp)||trim(lsdlr) del_num ,sum(lsamtd - lsamtp) sp,min(lsdte)dte from lspf where lsmvt='P' and (LSAMTD - LSAMTP) < 0 and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)ls on ls.del_num=leg_acc_num
left join (select * from TBAADM.cot where bank_id='01')chat on chat.acid=gam.acid
 
