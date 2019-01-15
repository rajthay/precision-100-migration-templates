--Created by KT
drop table ACTIVE_SI;
create table ACTIVE_SI as 
select * from VW_ACTIVE_SI; 
--where trim(r5ab)<>'0775' --based on requirement by maildt 30-07-2017. This has been commented.
--as per robin confirmation over phone to Gopal on 07-05-2017 after mock4 completion
--required changes have been done on 07-05-2017
create index ACTIVE_SI_idx on active_si( r5ab||r5an||r5as);
create index ACTIVE_SI_idx1 on active_si( r5an);
truncate table SIU_O_TABLE;
INSERT INTO SIU_O_TABLE   
 select 
--SOL_ID    CHAR(8 BYTE)
rpad( nvl(fund_sol_id,map_sol.fin_sol_id),8,' '),
--SI_FREQ_TYPE    CHAR(1 BYTE)
 rpad(trim(mapfrequency(substr(VW_ACTIVE_SI.r5afr,1,1))),1,' '),
--SI_FREQ_WEEK_NUM    CHAR(1 BYTE)
RPAD(' ',1,' '),
--SI_FREQ_WEEK_DAY    CHAR(1 BYTE)
RPAD(' ',1,' '),
--SI_FREQ_START_DD    CHAR(2 BYTE)
case when trim(mapfrequency(substr(VW_ACTIVE_SI.r5afr,1,1))) in('W','F','D') 
then lpad(' ',2,' ')
else lpad(to_char(substr(VW_ACTIVE_SI.r5afr,2,2)),2,' ') end,
--SI_FREQ_HLDY_STAT    CHAR(1 BYTE)
rpad('N',1,' '),
--SI_EXECUTION_CODE    CHAR(1 BYTE)
rpad('B',1,' '),
--SI_END_DATE    CHAR(8 BYTE)
  case
  when VW_ACTIVE_SI.r5fld='9999999' then RPAD('31-12-2099',10,' ')
  when get_date_fm_btrv(VW_ACTIVE_SI.r5fld)<>0 and get_date_fm_btrv(VW_ACTIVE_SI.r5fld) <> 'ERROR' then
  RPAD(to_char(to_date(get_date_fm_btrv(VW_ACTIVE_SI.r5fld),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')end,
--SI_NEXT_EXECUTION_DATE    CHAR(8 BYTE)
  case when get_date_fm_btrv(VW_ACTIVE_SI.r5npr)<>0 and get_date_fm_btrv(VW_ACTIVE_SI.r5npr) <> 'ERROR' then 
  RPAD(to_char(to_date(get_date_fm_btrv(VW_ACTIVE_SI.r5npr),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,
 --case when trim(mapfrequency(substr(VW_ACTIVE_SI.r5afr,1,1))) ='M' then
--RPAD(to_char(substr(VW_ACTIVE_SI.r5afr,2,2))||substr(to_char(to_date(get_date_fm_btrv(VW_ACTIVE_SI.r5npr),'YYYYMMDD'),'DD-MM-YYYY'),3,10),10,' ')
--else RPAD(to_char(to_date(get_date_fm_btrv(VW_ACTIVE_SI.r5npr),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,--changed on 10-01-2016
--TARGET_ACCOUNT    CHAR(16 BYTE)
--rPAD(get_siu_acc(r5ab||r5an||r5as),16,' '),
rPAD(fund_account,16,' '), ----added on 09-09-2017 based on sandeep requirement 
--  RPAD(' ',16,' '),
--BALANCE_INDICATOR    CHAR(1 BYTE)
--RPAD('F',1,' '), ----added on 09-09-2017 based on sandeep requirement 
RPAD('C',1,' '), ----F to C changed on 06-10-2017 based on sandeep requirement 
--RPAD(' ',1,' '),
--EXCESS_SHORT_INDICATOR    CHAR(1 BYTE)
RPAD('E',1,' '), ----added on 09-09-2017 based on sandeep requirement 
--RPAD(' ',1,' '),
--TARGET_BALANCE    CHAR(17 BYTE)
lpad(abs(to_number(VW_ACTIVE_SI.r5rpa)/POWER(10,c8pf.C8CED)),17,' '), ----added on 09-09-2017 based on sandeep requirement
--LPAD(' ',17,' '),
--AUTO_POST_FLAG    CHAR(1 BYTE)
RPAD('Y',1,' '),
--CARRY_FORWARD_ALLOWED_FLAG    CHAR(1 BYTE)
case when trim(mapfrequency(substr(VW_ACTIVE_SI.r5afr,1,1)))='M'
then RPAD('Y',1,' ') else RPAD('N',1,' ') end,
--VALIDATE_CRNCY_HOLIDAY_FLAG    CHAR(1 BYTE)
rpad('N',1,' '),
--DELETE_TRN_IF_NOT_POSTED    CHAR(1 BYTE)
rpad('Y',1,' ' ),
--CARRY_FORWARD_LIMIT    CHAR(5 BYTE)
rPAD('3',5,' ') end,--changed on 23-02-2016
--SI_CLASS    CHAR(1 BYTE)
 --case when trim(scai47)='Y' then 'B' else 'C' end,
 case when remarks ='OFFICE_ACC' then 'B' else 'C' end, --- changed on 10-01-2017 as per Mock5 observation
--CIF_ID    CHAR(32 BYTE)
RPAD(nvl(fund_cif_id,' '),32,' '),
--REMARKS    CHAR(50 BYTE)
RPAD(case when R5RFSO='I' then 'NO FUNDS BUT POSTED'
when R5RFSO = 'Y' and R5FLF= 'Y' then  'NO FUNDS DAILY RETRY'
when R5RFSO='R' then  'ACTIONED ON RETRY'
when R5FLF='N'  and R5RFSO = 'N' then 'ACTIONED NORMALLY'
else '' end,50,' '),
--CLOSURE_REMARKS    CHAR(50 BYTE)
RPAD(' ',50,' '),
--EXECUTION_CHARGE_CODE    CHAR(25 BYTE)
RPAD(case when remarks ='OFFICE_ACC' then ' ' 
          when gfpf.gfctp in('EC','EV','EW') and SO_REF is null then 'SI_STAFF' 
		  when gfpf.gfctp in('EC','EV','EW') and SO_REF is not null then 'SISTAFFOUTSIDE' 
		  when map_acc.schm_code='CAPRE' and SO_REF is null then 'SI_PRESTG' 
		  when map_acc.schm_code='CAPRE' and SO_REF is not null then 'SIPRESTOUTSIDE' 
		  when SO_REF is not null then 'SI_OUTSIDE_ABK' 
		  else 'SI_WITHIN_ABK' end,25,' '), ---  charge event id provided on 07-09-2017 based on sridhar requirement.
--FAILURE_CHARGE_CODE    CHAR(25 BYTE)
RPAD(' ',25,' '),
--CHARGE_RATE_CODE    CHAR(5 BYTE)
RPAD(case when remarks ='OFFICE_ACC' then ' ' else 'MID' end,5,' '),
--CHARGE_DEBIT_ACCOUNT_NUMBER    CHAR(16 BYTE)
RPAD(case when remarks ='OFFICE_ACC' then ' ' else fund_account end,16,' '), ---  charge event id provided on 07-09-2017 based on sridhar requirement.
--RPAD(' ',16,' '),
--AMOUNT_INDICATOR    CHAR(1 BYTE)
RPAD('F',1,' '),
--CREATE_MEMO_PAD_ENTRY    CHAR(1 BYTE)
RPAD('N',1,' '),
--CURRENCY_CODE    CHAR(3 BYTE)
RPAD(trim(c8ccy),3,' '),
--FIXED_AMOUNT    CHAR(17 BYTE)
lpad(abs(to_number(VW_ACTIVE_SI.r5rpa)/POWER(10,c8pf.C8CED)),17,' '),
--PART_TRAN_TYPE    CHAR(1 BYTE)
RPAD('D',1,' '),
--BALANCE_INDICATOR1    CHAR(1 BYTE)
RPAD('C',1,' '),
--EXCESS_SHORT_INDICATOR1    CHAR(1 BYTE)
RPAD(' ',1,' '),
--ACCOUNT_NUMBER    CHAR(16 BYTE)
RPAD(fund_account,16,' '),
--ACCOUNT_BALANCE    CHAR(17 BYTE)
LPAD(' ',17,' '),
--PERCENTAGE    CHAR(8 BYTE)
LPAD(' ',8,' '),
--AMOUNT_MULTIPLE    CHAR(17 BYTE)
LPAD(' ',17,' '),
--ADM_ACCOUNT_NO    CHAR(16 BYTE)
RPAD(fund_account,16,' '),
--ROUND_OFF_TYPE    CHAR(1 BYTE)
RPAD(' ',1,' '),
--ROUND_OFF_VALUE    CHAR(17 BYTE)
LPAD(' ',17,' '),
--COLLECT_CHARGES    CHAR(1 BYTE)
RPAD('N',1,' '),
--REPORT_CODE    CHAR(5 BYTE)
RPAD(' ',5,' '),
--REFERENCE_NUMBER    CHAR(20 BYTE)
RPAD(R5SOR,20,' '),
--TRAN_PARTICULAR    CHAR(50 BYTE)
rpad(nvl(trim(R5PYE),' '),50,' '),--changed on 17-02-2016
--TRAN_REMARKS    CHAR(30 BYTE)
RPAD(' ',30,' '),
--INTENT_CODE    CHAR(5 BYTE)
RPAD(' ',5,' '),
--DD_PAYABLE_BANK_CODE    CHAR(6 BYTE)
RPAD(' ',6,' '),
--DD_PAYABLE_BRANCH_CODE    CHAR(6 BYTE)
RPAD(' ',6,' '),
--PAYEE_NAME    CHAR(80 BYTE)
RPAD(' ',80,' '),
--PURCHASE_ACCOUNT_NUMBER    CHAR(16 BYTE)
RPAD(' ',16,' '),
--PURCHASE_NAME    CHAR(80 BYTE)
RPAD(' ',80,' '),
--CR_ADV_PYMNT_FLG    CHAR(1 BYTE)
RPAD(' ',1,' '),
--AMOUNT_INDICATOR1    CHAR(1 BYTE)
--RPAD('C',1,' '),
RPAD('F',1,' '),--changed on 06-01-2016
--CREATE_MEMO_PAD_ENTRY1    CHAR(1 BYTE)
RPAD('N',1,' '),
--ADM_ACCOUNT_NO1    CHAR(16 BYTE)
RPAD(case when so_ref is not null and remarks1 ='OFFICE_ACC' then  '9000110101000' else recv_account end,16,' '),------changed on 08-10-2017 discussion with abk vijay,robin and evolvus vijay and defaulted central bank account
--ROUND_OFF_TYPE1    CHAR(1 BYTE)
RPAD(' ',1,' '),
--ROUND_OFF_VALUE1    CHAR(17 BYTE)
LPAD(' ',17,' '),
--COLLECT_CHARGES1    CHAR(1 BYTE)
RPAD(case when remarks ='OFFICE_ACC' then 'N' else 'Y' end,1,' '), ---  charge event id provided on 07-09-2017 based on sridhar requirement.
--REPORT_CODE1    CHAR(5 BYTE)
RPAD(' ',5,' '),
--REFERENCE_NUMBER1    CHAR(20 BYTE)
RPAD(r5ab||r5an||r5as||R5SOR,20,' '),
--TRAN_PARTICULAR1    CHAR(50 BYTE)
RPAD(nvl(trim(R5NAR),' '),50,' '),
--TRAN_REMARKS1    CHAR(30 BYTE)
RPAD(' ',30,' '),
--INTENT_CODE1    CHAR(5 BYTE)
RPAD(' ',5,' '),
--SI_PRIORITY    CHAR(3 BYTE)
RPAD(' ',3,' '),
--SI_FREQ_CAL_BASE    CHAR(2 BYTE)
RPAD('00',2,' '),
--CR_CEILING_AMT    CHAR(17 BYTE)
LPAD(' ',17,' '),
--CR_CULATIVE_AMT    CHAR(17 BYTE)
LPAD(' ',17,' '),
--DR_CEILING_AMT    CHAR(17 BYTE)
LPAD(' ',17,' '),
--DR_CUMULATIVE_AMT    CHAR(17 BYTE)
LPAD(' ',17,' '),
--SI_freq_days_num  NVARCHAR2(3) NULL,
 LPAD(' ',3,' '),
--script_file_name
LPAD(' ',100,' ')     
from active_si VW_ACTIVE_SI
inner join C8PF on C8CCYN = VW_ACTIVE_SI.R5CCY
--inner join (select * from map_cif where del_flg<>'Y' and cif_seq='Y')map_cif on map_cif.gfcpnc = trim(VW_ACTIVE_SI.r5an)
--left join map_sol on br_code=r5ab 
left join siu_tt ON trim(FUND_ACCOUNT)||TRIM(R5SOR) =trim(FUND_ACCT_NUM)||TRIM(SO_REF)
inner join scpf on r5ab||r5an||r5as=scab||scan||scas
left join map_sol on trim(r5ab)=br_code
left join gfpf on '0'||gfclc||gfcus=FUND_CIF_ID
left join map_acc on fin_acc_num=fund_account
WHERE trim(FUND_CCY) = trim(RECV_CCY) and  R5NPR>get_param('EODCYYMMDD') and r5fld>get_param('EODCYYMMDD');
COMMIT;
update SIU_O_TABLE set sol_id= rpad(substr(trim(ACCOUNT_NUMBER),1,3),8,' ') where trim(SOL_ID) is null; 
commit;
exit; 
