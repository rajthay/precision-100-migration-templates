
-- File Name           : LAT1_upload.sql
-- File Created for    : Upload file for Loan Interest
-- Created By          : Alavudeen Ali Badusha.R
-- Client              : ABK
-- Created On          : 20-06-2016 
-------------------------------------------------------------------
-------INTEREST OVERDUE TRANSACTION PASSED IN BELOW ------------------------------------------------
truncate table LAT1_O_TABLE;
insert into LAT1_O_TABLE
select 
--   Transaction_Type         CHAR(1) NULL,
rpad('T',1,' '),
--   Transaction_sub_Type         CHAR(2) NULL,
rpad('BI',2,' '),
--   Account_Number         CHAR(16) NULL,
rpad(fin_acc_num,16,' '),
--   Currency             CHAR(3) NULL,
rpad(map_acc.currency,3,' '),
--   Service_Outlet         CHAR(8) NULL,
rpad(fin_sol_id,8,' '),
--   Amount             CHAR(17) NULL,
lpad(abs(to_number((lsamtd - lsamtp))/POWER(10,c8pf.C8CED)),17,' '),
--   Part_tran_type         CHAR(1) NULL,
rpad('D',1,' '),
--   Type_of_demands         CHAR(1) NULL,
rpad(' ',1,' '),
--   Value_Date             CHAR(10) NULL,
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--   Flow_Id             CHAR(5) NULL,
rpad('INDEM',5,' '),
--   Demand_Date             CHAR(10) NULL,
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--   Last_part_transaction_flag     CHAR(1) NULL,
rpad('N',1,' '),
--   Tran_end_ind             CHAR(1) NULL,
rpad('N',1,' '),
--   Advance_Payment_Flag         CHAR(1) NULL,
rpad(' ',1,' '),
--   Prepayment_Type         CHAR(1) NULL,
rpad(' ',1,' '),
--   int_coll_on_prepayment_flg     CHAR(1) NULL,
rpad(' ',1,' '),
--   Transaction_Remarks         CHAR(30) NULL,
rpad(' ',30,' '),
--   Transaction_Particulars     CHAR(50) NULL
rpad(fin_acc_num,50,' ')   
FROM map_acc
inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num 
inner join c8pf on c8ccy = map_acc.currency
where map_acc.schm_type='LAA'
and lsmvt = 'I' and lsamtd <> 0 and (lsamtd -lsamtp) < 0 and lsdte <= get_param('EODCYYMMDD');
commit;
-------PRINCIPAL PENAL INTEREST OVERDUE TRANSACTION PASSED IN BELOW ------------------------------------------------
--insert into LAT1_O_TABLE
--select 
----   Transaction_Type         CHAR(1) NULL,
--rpad('T',1,' '),
----   Transaction_sub_Type         CHAR(2) NULL,
--rpad('BI',2,' '),
----   Account_Number         CHAR(16) NULL,
--rpad(fin_acc_num,16,' '),
----   Currency             CHAR(3) NULL,
--rpad(currency,3,' '),
----   Service_Outlet         CHAR(8) NULL,
--rpad(fin_sol_id,8,' '),
----   Amount             CHAR(17) NULL,
--lpad(abs(to_number(lsup))/POWER(10,c8pf.C8CED),17,' '),
----   Part_tran_type         CHAR(1) NULL,
--rpad('D',1,' '),
----   Type_of_demands         CHAR(1) NULL,
--rpad(' ',1,' '),
----   Value_Date             CHAR(10) NULL,
--rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----   Flow_Id             CHAR(5) NULL,
--rpad('PIDEM',5,' '),
----   Demand_Date             CHAR(10) NULL,
--rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----   Last_part_transaction_flag     CHAR(1) NULL,
--rpad('N',1,' '),
----   Tran_end_ind             CHAR(1) NULL,
--rpad('N',1,' '),
----   Advance_Payment_Flag         CHAR(1) NULL,
--rpad(' ',1,' '),
----   Prepayment_Type         CHAR(1) NULL,
--rpad(' ',1,' '),
----   int_coll_on_prepayment_flg     CHAR(1) NULL,
--rpad(' ',1,' '),
----   Transaction_Remarks         CHAR(30) NULL,
--rpad(' ',30,' '),
----   Transaction_Particulars     CHAR(50) NULL
--rpad(fin_acc_num,50,' ')   
--FROM map_acc
--inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num 
--inner join c8pf on c8ccy = map_acc.currency
--where map_acc.schm_type='LAA'
--and lsmvt = 'P' and lsmvts ='R' and lsup <> 0 and lsdte <= get_param('EODCYYMMDD');
--commit;
-------CONTRA TRANSACTION FOR PRINCIPAL PENAL INTEREST AND INTEREST OVERDUE TRANSACTION IS PASSED IN BELOW ------------------------------------------------
insert into LAT1_O_TABLE
select 'T','BI',rpad((trim(Service_Outlet)||crncy_alias_num||'52000LAA'),16,' '), currency,rpad(Service_Outlet,8,' '),lpad(calc_bal,17,' '),'C',' ',get_param('EOD_DATE'),rpad(' ',5,' '),rpad(' ',10,' '),'Y','N','N',' ',' ',rpad(' ',30,' '),rpad(account_number,50,' ')
from
--(select Service_Outlet,currency,sum(Amount) calc_bal from LAT1_O_TABLE ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
(select account_number,Service_Outlet,currency,sum(Amount) calc_bal from LAT1_O_TABLE
group by account_number,currency,Service_Outlet ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
order by currency,Service_Outlet
)
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on crncy_code=currency; 
commit;
exit;
 
