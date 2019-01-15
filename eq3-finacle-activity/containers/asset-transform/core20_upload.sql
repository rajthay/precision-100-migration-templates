
drop table BALANCE_ORDER;
create table BALANCE_ORDER as select * from VW_BALANCE_ORDER; 
--where trim(r0ab)<>'0775' --based on requirement by maildt 30-07-2017. This has been commented.
create index BALANCE_ORDER_IDX on BALANCE_ORDER(r0ab||r0an||r0as);
--create index BALANCE_ORDER_IDX1 on BALANCE_ORDER(scccy);
truncate table bo_o_table;
INSERT INTO BO_O_TABLE 
select
--SOL_ID CHAR(8 BYTE)
rpad(FIN_DR_SOL,8,' '),
--SI_FREQ_TYPE CHAR(1 BYTE)
rpad(mapfrequency(substr(trim(r7frq),1,1)),1,' '),
--SI_FREQ_WEEK_NUM CHAR(1 BYTE)
RPAD(' ',1,' '),
--SI_FREQ_WEEK_DAY CHAR(1 BYTE)
RPAD(' ',1,' '),     
--SI_FREQ_START_DD CHAR(2 BYTE)
case when trim(mapfrequency(substr(r7frq,1,1))) in('W','F','D') 
then lpad(' ',2,' ')
else lpad(to_char(substr(r7frq,2,2)),2,' ') end,
--SI_FREQ_HLDY_STAT CHAR(1 BYTE)
'N',
--SI_EXECUTION_CODE CHAR(1 BYTE)
'A',
--SI_END_DATE CHAR(8 BYTE)
   case
     when r7fld = 9999999 then '31-12-2099'
	 when get_date_fm_btrv(r7fld) <> 'ERROR' 
then RPAD(to_char(to_date(get_date_fm_btrv(r7fld),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') 
     end,
--SI_NEXT_EXECUTION_DATE CHAR(8 BYTE)
	case  when get_date_fm_btrv(r7npr) <> 'ERROR' 
    then to_char(to_date(get_date_fm_btrv(r7npr),'YYYYMMDD'),'DD-MM-YYYY') 
    end,
--TARGET_ACCOUNT CHAR(16 BYTE)
rPAD(roab_acc,16,' '),
--BALANCE_INDICATOR CHAR(1 BYTE)
--case 
--when r7bot = 'D' and r7min/power(10,c8ced) = '0' then 'C'
--when r7bot = 'D' and (r7min/power(10,c8ced) <> '0' or r7min is not null) then 'C'
--when r7bot = 'D' then 'C'
--when r7bot = 'S' then 'C'
--when r7bot = 'L' and r0frc = 'R' then 'C'
--when r7bot = 'L' and r0frc = 'F' then 'D'
--when r0frc = 'F' and r7min < 0 then 'D'
--when r0frc = 'F' and r7min >= 0 then 'C'
--when r0frc = 'R' and r7min < 0 then 'D'
--when r0frc = 'R' and r7min >= 0 then 'C'
--end ,------ commented and defaulted to 'F' as per vijay mail dt 05-10-2017
'F',
--EXCESS_SHORT_INDICATOR CHAR(1 BYTE)
case 
when r7bot = 'D' and r0FRC  = 'F' then 'S'
when r7bot = 'S' and r0FRC =  'R' then 'E'
when r7bot = 'L' and r0frc = 'F' then 'S'
when r7bot = 'L' and r0frc = 'R' then 'E'
end ,
--TARGET_BALANCE CHAR(17 BYTE)
case 
when r0FRC = 'F' then rpad(r7min/power(10,c8ced),17,' ')
when r0FRC = 'R' then rpad(r7max/power(10,c8ced),17,' ')
end,
--AUTO_POST_FLAG CHAR(1 BYTE)
'Y',
--CARRY_FORWARD_ALLOWED_FLAG CHAR(1 BYTE) 
'N', 
--VALIDATE_CRNCY_HOLIDAY_FLAG CHAR(1 BYTE) 
'N',
--DELETE_TRN_IF_NOT_POSTED CHAR(1 BYTE)
'Y',
--CARRY_FORWARD_LIMIT CHAR(5 BYTE)
rPAD('3',5,' '),
--SI_CLASS CHAR(1 BYTE)
case 
   when FIN_DR_CIF is null then 'B'
else 'C' end,
--CIF_ID CHAR(32 BYTE)
case 
   when FIN_DR_CIF is null then RPAD(' ',32,' ')
else RPAD(FIN_DR_CIF,32,' ') end,
--REMARKS CHAR(50 BYTE)
case
when R7FNR2||R7FNR3 is not null then to_char(RPAD(substr(R7FNR2||R7FNR3,1,50),50,' '))
else RPAD(' ',50,' ') end,
--CLOSURE_REMARKS CHAR(50 BYTE)
rpad('BOF'||r0ab||r0an||r0as||r0bot||R0FRC||R0FRAB||R0FRAN||R0FRAS,50,' '),
--EXECUTION_CHARGE_CODE CHAR(25 BYTE)
RPAD(' ',25,' '),
--FAILURE_CHARGE_CODE CHAR(25 BYTE)
RPAD(' ',25,' '),
--CHARGE_RATE_CODE CHAR(5 BYTE)
RPAD(' ',5,' '),
--CHARGE_DEBIT_ACCOUNT_NUMBER CHAR(16 BYTE) 
RPAD(' ',16,' '),
--AMOUNT_INDICATOR CHAR(1 BYTE)
--case 
--when r7bot = 'D' and r0FRC  = 'F' then 'C'
--when r7bot = 'S' and r0FRC =  'R' then 'V'
--when r7bot = 'L' and r0frc = 'F' then 'C'
--when r7bot = 'L' and r0frc = 'R' then 'V'
--end ,
case 
when r7bot = 'D' and r0FRC  = 'F' then 'V'
when r7bot = 'S' and r0FRC =  'R' then 'V'
when r7bot = 'L' and r0frc = 'F' then 'V'
when r7bot = 'L' and r0frc = 'R' then 'V'
end ,  --------changed on 10-06-2017 . based on mk4a observation and sandeep requirement.
--CREATE_MEMO_PAD_ENTRY CHAR(1 BYTE)
'N',
--CURRENCY_CODE CHAR(3 BYTE)
case when trim(FIN_DR_CURRENCY)='DH' then  RPAD('AED',3,' ')
else rpad(trim(FIN_DR_CURRENCY),3,' ') end,
--FIXED_AMOUNT CHAR(17 BYTE)
case
 when r7bot = 'S' and r0min > 0 and r0max > 0 and r0min=r0max then rpad(r0max/power(10,c8ced),17,' ')
else LPAD(' ',17,' ') end,
--PART_TRAN_TYPE CHAR(1 BYTE)
'D',
--BALANCE_INDICATOR1 CHAR(1 BYTE)
--case 
--when r7bot = 'D' and r7min/power(10,c8ced) = '0' then 'C'
--when r7bot = 'D' and (r7min/power(10,c8ced) <> '0' or r7min is not null) then 'C'
--when r7bot = 'D' then 'C'
--when r7bot = 'S' then 'C'
--when r7bot = 'L' and r0frc = 'R' then 'C'
--when r7bot = 'L' and r0frc = 'F' then 'D'
--end,------ commented and defaulted to 'F' as per vijay mail dt 05-10-2017
'F',
--EXCESS_SHORT_INDICATOR1 CHAR(1 BYTE)
case 
when r7bot = 'D' and r0FRC  = 'F' then 'S'
when r7bot = 'S' and r0FRC =  'R' then 'E'
when r7bot = 'L' and r0frc = 'F' then 'S'
when r7bot = 'L' and r0frc = 'R' then 'E'
end ,
--ACCOUNT_NUMBER CHAR(16 BYTE)
RPAD(nvl(FIN_DR_ACCT,' '),16,' ') ,
--ACCOUNT_BALANCE CHAR(17 BYTE)
case 
when r0FRC = 'F' then rpad(r7min/power(10,c8ced),17,' ')
when r0FRC = 'R' then rpad(r7max/power(10,c8ced),17, ' ')
end,
--PERCENTAGE CHAR(8 BYTE)
LPAD(' ',8,' '),
--AMOUNT_MULTIPLE CHAR(17 BYTE)
case
when r7bot = 'S' then rpad(r0inc/power(10,c8ced),17, ' ')
else LPAD(' ',17,' ') end,
--ADM_ACCOUNT_NO CHAR(16 BYTE)
RPAD(NVL(FIN_DR_ACCT,' '),16,' '),
--ROUND_OFF_TYPE CHAR(1 BYTE)
case
 when r7bot = 'S' then 'L'
else RPAD(' ',1,' ') end,
--ROUND_OFF_VALUE CHAR(17 BYTE)
case
 when r7bot = 'S' and r0min > 0 and r0max > 0 and r0min=r0max then LPAD('1',17,' ')
when r7bot = 'S' then LPAD('1',17,' ')
else RPAD(' ',17,' ') end,
--COLLECT_CHARGES CHAR(1 BYTE)
'N',
--REPORT_CODE CHAR(5 BYTE)
RPAD(' ',5,' '),
--REFERENCE_NUMBER CHAR(20 BYTE)
RPAD(' ',20,' '),
--TRAN_PARTICULAR CHAR(50 BYTE)
case
 when R7FDRF||r7Fnr1 is not null then RPAD(substr(R7FDRF||r7Fnr1,1,50),50,' ')
 else RPAD(' ',50,' ') end,
--TRAN_REMARKS CHAR(30 BYTE)
RPAD(' ',30,' '),
--INTENT_CODE CHAR(5 BYTE)
RPAD(' ',5,' '),
--DD_PAYABLE_BANK_CODE CHAR(6 BYTE)
RPAD(' ',6,' '),
--DD_PAYABLE_BRANCH_CODE CHAR(6 BYTE)
RPAD(' ',6,' '),
--PAYEE_NAME CHAR(80 BYTE)
RPAD(' ',80,' '),
--PURCHASE_ACCOUNT_NUMBER CHAR(16 BYTE)
RPAD(' ',16,' '),
--PURCHASE_NAME CHAR(80 BYTE)
RPAD(' ',80,' '),
--CR_ADV_PYMNT_FLG CHAR(1 BYTE)
RPAD(' ',1,' '),
--AMOUNT_INDICATOR1 CHAR(1 BYTE)
--case 
--when r7bot = 'D' and r0FRC  = 'F' then 'V'
--when r7bot = 'S' and r0FRC =  'R' then 'C'
--when r7bot = 'L' and r0frc = 'F' then 'V'
--when r7bot = 'L' and r0frc = 'R' then 'C'
--end ,
case 
when r7bot = 'D' and r0FRC  = 'F' then 'C'
when r7bot = 'S' and r0FRC =  'R' then 'C'
when r7bot = 'L' and r0frc = 'F' then 'C'
when r7bot = 'L' and r0frc = 'R' then 'C'
end ,    --------changed on 10-06-2017 . based on mk4a observation and sandeep requirement.
--CREATE_MEMO_PAD_ENTRY1 CHAR(1 BYTE)
'N',
--ADM_ACCOUNT_NO1 CHAR(16 BYTE)
RPAD(nvl(FIN_CR_ACCT,' '),16,' '),
--ROUND_OFF_TYPE1 CHAR(1 BYTE)
RPAD(' ',1,' '),
--ROUND_OFF_VALUE1 CHAR(17 BYTE)
LPAD(' ',17,' '),
--COLLECT_CHARGES1 CHAR(1 BYTE)
'N',
--REPORT_CODE1 CHAR(5 BYTE)
RPAD(' ',5,' '),
--REFERENCE_NUMBER1 CHAR(20 BYTE)
RPAD(' ',20,' '),
--TRAN_PARTICULAR1 CHAR(50 BYTE)
case
when R7RDRF||r7rnr1 is not null then RPAD(substr(R7RDRF||r7rnr1,1,50),50,' ')
else RPAD(' ',50,' ') end,
--TRAN_REMARKS1 CHAR(30 BYTE)
case
when R7RNR2||R7RNR3 is not null then RPAD(substr(R7RNR2||R7RNR3,1,30),30,' ')
else RPAD(' ',30,' ') end,
--INTENT_CODE1 CHAR(5 BYTE)
RPAD(' ',5,' '),
--SI_PRIORITY CHAR(3 BYTE)
RPAD(r0seq,3,' '),
--SI_FREQ_CAL_BASE CHAR(2 BYTE)
'00',
--CR_CEILING_AMT CHAR(17 BYTE)
LPAD(' ',17,' '),
--CR_CULATIVE_AMT CHAR(17 BYTE)
LPAD(' ',17,' '),
--DR_CEILING_AMT CHAR(17 BYTE)
LPAD(' ',17,' '),
--DR_CUMULATIVE_AMT CHAR(17 BYTE)
lpad(' ',17,' '),
--SI_freq_days_num  NVARCHAR2(3) NULL,
 LPAD(' ',3,' '),
--script_file_name
LPAD(' ',100,' ') 
from BALANCE_ORDER
inner join c8pf on trim(c8ccy) = trim(FIN_DR_CURRENCY)
left join scpf a on scab||scan||scas=r0ab||r0an||r0as
where trim(FIN_DR_CURRENCY) = trim(FIN_CR_CURRENCY)
AND r7npr >get_param('EODCYYMMDD') AND r7fld>get_param('EODCYYMMDD')
and r0an not in ('855100','855000') and scact not in ('YL','YP')
and ((R0BOT in ('D','L','S') and R0frc ='F')or (R0BOT in ('S') and R0frc ='R'));
--and TRIM(r0frc) ='F'
commit;
update bo_O_TABLE set sol_id= rpad(substr(trim(ACCOUNT_NUMBER),1,3),8,' ') where trim(SOL_ID) is null;
commit;
exit;
