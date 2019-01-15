
-- File Name           : LDT_upload.sql
-- File Created for    : Upload file for Loan Demand
-- Created By          : Alavudeen Ali Badusha.R
-- Client              : ENBD
-- Created On          : 08-07-2014 
-------------------------------------------------------------------
----------------PRINCIPAL AND INTEREST OVERDUE OUTSTANDING INFORMATION PASSED IN BELOW  ------------------------------------------------
truncate table LDT_O_TABLE;
insert into LDT_O_TABLE
select 
--   Account_ID             CHAR(16) NULL,
rpad(Fin_acc_num,16,' '),
--   Demand_Date             CHAR(10) NULL,
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--   Demand_Effective_Date     CHAR(10) NULL,
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--   Principal_Demand_ID         CHAR(5) NULL,
rpad(case when lsmvt='P' then 'PRDEM' when lsmvt='I' then 'INDEM' else ' ' end,5,' '),
--   Demand_Amount         CHAR(17) NULL,
lpad(abs(to_number(lsamtd - lsamtp))/POWER(10,c8pf.C8CED),17,' '),
--   Late_Fee_Applied         CHAR(1) NULL,
rpad(case when lsup <> 0 then 'B' else 'N' end,1,' '),
--   Late_Fee_Amount         CHAR(17) NULL,
lpad(case when lsup <> 0 then to_char(abs(to_number(lsup))/POWER(10,c8pf.C8CED)) else ' ' end,17,' '),
--   Late_Fee_Date         CHAR(10) NULL,
rpad(case when lsup <> 0 then to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end,10,' '),
--   Status_Of_Late_Fee         CHAR(1) NULL,
rpad(case when lsup <> 0 then 'A' else ' ' end,1,' '),
--   Late_Fee_Currency_Code     CHAR(3) NULL,
rpad(case when lsup <> 0 then currency else ' ' end,3,' '),
--   Demand_Overdue_Date         CHAR(10) NULL,
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--   Accrued_Penal_Interest_Amount CHAR(17) NULL,
lpad(' ',17,' '),
--   IBAN_Number             CHAR(34) NULL
rpad(' ',34,' ')
FROM map_acc
inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num 
inner join c8pf on c8ccy = map_acc.currency
where map_acc.schm_type='LAA' and lsamtd <> 0 and (lsamtd -lsamtp) < 0 and lsdte <= get_param('EODCYYMMDD');
commit;
----------------PRINCIPAL PENAL INTEREST OUTSTANDING INFORMATION PASSED IN BELOW  ------------------------------------------------
--insert into LDT_O_TABLE
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
--inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num 
--inner join c8pf on c8ccy = map_acc.currency
--where map_acc.schm_type='LAA'
--and lsmvt = 'P' and lsmvts ='R' and lsup <> 0 and lsdte <= get_param('EODCYYMMDD');
--commit;
exit;
 
