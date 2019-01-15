
-- File Name		: custom_advance_int.sql 
-- File Created for	: Upload file for advance interest for BDT schm
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 25-01-2016
-------------------------------------------------------------------
truncate table custom_advance_int;
insert into custom_advance_int
select distinct
--account_id Nvarchar2(16),
rpad(fin_acc_num,16,' '),
--start_date Nvarchar2(10),
--rpad(ACCT_OPEN_DATE,8,' '),
to_char(to_date(ACCT_OPEN_DATE,'YYYYMMDD'),'DD-MM-YYYY'),
--End_date Nvarchar2(10),
--rpad(LIMIT_EXPIRY_DATE,8,' '),
to_char(to_date(LIMIT_EXPIRY_DATE,'YYYYMMDD'),'DD-MM-YYYY'),
--Sch_bal Nvarchar2(17),
lpad(SANCTION_LIMIT,17,' '),
--Int_amount Nvarchar2(17)
lpad(OMNWR/POWER(10,c8pf.C8CED),17,' ')
from map_acc 
inner join cl001_o_table on trim(acc_num)=fin_acc_num
inner join ompf ON trim(ombrnm)||trim(omdlp)||trim(omdlr)=LEG_ACC_NUM
inner join c8pf on c8ccy = currency
where map_acc.schm_code in ('BDT' ,'ATD')
and ommvt='I';
commit;
exit; 
