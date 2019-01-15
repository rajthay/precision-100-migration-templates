 -- File Name           : cu1_upload.sql
-- File Created for    : Upload file for CU1
-- Created By          : Kumaresan.B
-- Client              : ABK
-- Created On          : 19-05-2016
-------------------------------------------------------------------
truncate table Cl008_O_TABLE;
insert into Cl008_O_TABLE
select 
--tran_type NVARCHAR2(1),
rpad('T',1,' '),
--tran_sub_type NVARCHAR2(2),
rpad('BI',2,' '),
--foracid NVARCHAR2(16),
rpad(fin_acc_num,16,' '),
--tran_crncy_code NVARCHAR2(3),
rpad(map_acc.currency,3,' '),
--sol_id NVARCHAR2(8),
rpad(fin_sol_id,8,' '),
--tran_amt NVARCHAR2(17),
lpad(abs(to_number((lsamtd - lsamtp))/POWER(10,c8pf.C8CED)),17,' '),
--part_tran_type NVARCHAR2(1),
rpad('D',1,' '),
--type_of_dmds NVARCHAR2(1),
rpad(' ',1,' '),
--value_date NVARCHAR2(10),
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--flow_id NVARCHAR2(5),
rpad('INDEM',5,' '),
--dmd_date NVARCHAR2(10),
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--last_tran_flg NVARCHAR2(1),
rpad('N',1,' '),
--NA NVARCHAR2(1),
rpad('N',1,' '),
--adv_pay_flg NVARCHAR2(1),
rpad(' ',1,' '),
--prepay_type NVARCHAR2(1),
rpad(' ',1,' '),
--int_coll_on_prep_flg NVARCHAR2(1),
rpad(' ',1,' '),
--tran_rmks NVARCHAR2(30),
rpad(' ',30,' '),
--tran_particular NVARCHAR2(50)
rpad(fin_acc_num,50,' ') 
FROM map_acc 
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and map_acc.leg_acc_num=to_char(serial_deal)
inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num --b.leg_acc_num 
inner join c8pf on c8ccy = map_acc.currency
where map_acc.schm_type='CLA'
and lsmvt = 'I' and lsamtd <> 0 and (lsamtd -lsamtp) <> 0 and lsdte <= get_param('EODCYYMMDD');
commit;
---------PRINCIPAL PENAL INTEREST OVERDUE TRANSACTION PASSED IN BELOW ------------------------------------------------
--insert into Cl008_O_TABLE
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
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and map_acc.leg_acc_num=to_char(serial_deal)
--inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =b.leg_acc_num 
--inner join c8pf on c8ccy = map_acc.currency
--where map_acc.schm_type='CLA'
--and lsmvt = 'P' and lsmvts ='R' and lsup <> 0 and lsdte <= get_param('EODCYYMMDD');
--commit;
-------CONTRA TRANSACTION FOR PRINCIPAL PENAL INTEREST AND INTEREST OVERDUE TRANSACTION IS PASSED IN BELOW ------------------------------------------------
insert into Cl008_O_TABLE
select 'T','BI',rpad((trim(Sol_id)||crncy_alias_num||'52000CLA'),16,' '), tran_crncy_code,rpad(sol_id,8,' '),lpad(calc_bal,17,' '),'C',' ',get_param('EOD_DATE'),rpad(' ',5,' '),rpad(' ',10,' '),'Y','N','N',' ',' ',rpad(' ',30,' '),rpad(foracid,50,' ')
from
--(select sol_id,tran_crncy_code,sum(tran_amt) calc_bal from Cl008_O_TABLE ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
(select foracid,sol_id,tran_crncy_code,sum(tran_amt) calc_bal from Cl008_O_TABLE
group by foracid,tran_crncy_code,sol_id ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
order by tran_crncy_code,sol_id
)
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on crncy_code=tran_crncy_code; 
commit;
exit; 
