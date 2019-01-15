-- File Name           : cu1_upload.sql
-- File Created for    : Upload file for CU1
-- Created By          : Kumaresan.B
-- Client              : ABK
-- Created On          : 19-05-2016
-------------------------------------------------------------------
----------------PRINCIPAL AND INTEREST OVERDUE OUTSTANDING INFORMATION PASSED IN BELOW  ------------------------------------------------
truncate table Cl009_O_TABLE;
insert into Cl009_O_TABLE
select 
--Acc_ID NVARCHAR2(16),
rpad(Fin_acc_num,16,' '),
--Demand_Date NVARCHAR2(10),
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--Demand_Eff_Date NVARCHAR2(10),
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--Demand_Id NVARCHAR2(5),
rpad(case when lsmvt='P' then 'PRDEM' when lsmvt='I' then 'INDEM' else ' ' end,5,' '),
--Demand_Amt NVARCHAR2(17),
lpad(abs(to_number(lsamtd - lsamtp))/POWER(10,c8pf.C8CED),17,' '),
--Late_Fee_App NVARCHAR2(1),
rpad('N',1,' '),
--Late_Fee_Amt NVARCHAR2(17),
lpad(' ',17,' '),
--Late_Fee_Date NVARCHAR2(10),
rpad(' ',10,' '),
--Status_Of_Late_Fee NVARCHAR2(1),
rpad(' ',1,' '),
--Late_Fee_Curr_Code NVARCHAR2(3),
rpad(' ',3,' '),
--Demand_Overdue_Date NVARCHAR2(10),
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--Acc_Penal_Int_Amt NVARCHAR2(17),
lpad(' ',17,' '),
--IBAN_Number NVARCHAR2(34)
rpad(' ',34,' ')
FROM map_acc
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and map_acc.leg_acc_num=to_char(serial_deal)
inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num --b.leg_acc_num 
inner join c8pf on c8ccy = map_acc.currency
where map_acc.schm_type='CLA' and lsamtd <> 0 and (lsamtd -lsamtp) <> 0 and lsdte <= get_param('EODCYYMMDD');
commit;
------------------PRINCIPAL PENAL INTEREST OUTSTANDING INFORMATION PASSED IN BELOW  ------------------------------------------------
--insert into Cl009_O_TABLE
--select 
----   Account_ID             CHAR(16) NULL,
--rpad(Fin_acc_num,16,' '),
----   Demand_Date             CHAR(10) NULL,
--rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----   Demand_Effective_Date     CHAR(10) NULL,
--rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----   Principal_Demand_ID         CHAR(5) NULL,
--rpad('PIDEM',5,' '),
----   Demand_Amount         CHAR(17) NULL,
--lpad(abs(to_number(lsup))/POWER(10,c8pf.C8CED),17,' '),
----   Late_Fee_Applied         CHAR(1) NULL,
--rpad('N',1,' '),
----   Late_Fee_Amount         CHAR(17) NULL,
--lpad(' ',17,' '),
----   Late_Fee_Date         CHAR(10) NULL,
--rpad(' ',10,' '),
----   Status_Of_Late_Fee         CHAR(1) NULL,
--rpad(' ',1,' '),
----   Late_Fee_Currency_Code     CHAR(3) NULL,
--rpad(' ',3,' '),
----   Demand_Overdue_Date         CHAR(10) NULL,
--rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----   Accrued_Penal_Interest_Amount CHAR(17) NULL,
--lpad(' ',17,' '),
----   IBAN_Number             CHAR(34) NULL
--rpad(' ',34,' ')
--FROM map_acc
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and map_acc.leg_acc_num=to_char(serial_deal)
--inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =b.leg_acc_num 
--inner join c8pf on c8ccy = map_acc.currency
--where map_acc.schm_type='CLA'
--and lsmvt = 'P' and lsmvts ='R' and lsup <> 0 and lsdte <= get_param('EODCYYMMDD');
--commit;
-------------------LAC PRDEM Overdue------------------------
insert into Cl009_O_TABLE
select 
--Acc_ID NVARCHAR2(16),
rpad(Fin_acc_num,16,' '),
--Demand_Date NVARCHAR2(10),
case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') <  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then to_char(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),'DD-MM-YYYY') 
         else lpad( ' ',10,' ')  end,	
--Demand_Eff_Date NVARCHAR2(10),
case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') <  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then to_char(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),'DD-MM-YYYY') 
         else lpad( ' ',10,' ')  end,	
--Demand_Id NVARCHAR2(5),
rpad('PRDEM',5,' '),
--Demand_Amt NVARCHAR2(17),
lpad(to_char(to_number(abs(scbal))/POWER(10,C8CED)),17,' '),
--Late_Fee_App NVARCHAR2(1),
rpad('N',1,' '),
--Late_Fee_Amt NVARCHAR2(17),
lpad(' ',17,' '),
--Late_Fee_Date NVARCHAR2(10),
rpad(' ',10,' '),
--Status_Of_Late_Fee NVARCHAR2(1),
rpad(' ',1,' '),
--Late_Fee_Curr_Code NVARCHAR2(3),
rpad(' ',3,' '),
--Demand_Overdue_Date NVARCHAR2(10),
case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') <  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then to_char(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),'DD-MM-YYYY') 
         else lpad( ' ',10,' ')  end,	
--Acc_Penal_Int_Amt NVARCHAR2(17),
lpad(' ',17,' '),
--IBAN_Number NVARCHAR2(34)
rpad(' ',34,' ')
from map_acc 
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
inner join c8pf on c8ccy = currency
where map_acc.schm_type='CLA'  and map_acc.schm_code IN ('LAC','CLM')
and scbal <> 0 and SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') <  to_date(get_param('EOD_DATE'),'DD-MM-YYYY');
commit;
exit;
 