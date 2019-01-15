 -- File Name           : cu1_upload.sql
-- File Created for    : Upload file for CU1
-- Created By          : Kumaresan.B
-- Client              : ABK
-- Created On          : 19-05-2016
-------------------------------------------------------------------
truncate table Cl007_O_TABLE;
insert into Cl007_O_TABLE
select 
--Trans_Type NVARCHAR2(1),
rpad('T',1,' '),
--Trans_Sub_Type NVARCHAR2(3),
rpad('BI',2,' '),
--Acc_Num NVARCHAR2(16),
rpad(fin_acc_num,16,' '),
--Curr NVARCHAR2(3),
rpad(map_acc.currency,3,' '),
--Sol_Id NVARCHAR2(4),
rpad(fin_sol_id,8,' '),
--Trans_Amt NVARCHAR2(20),
lpad(to_number(abs(otdla)/POWER(10,c8pf.C8CED)),17,' '),
--Part_Tran_Type NVARCHAR2(2),
rpad('D',1,' '),
--Type_of_demands NVARCHAR2(2),
rpad( 'P',1,' '),
--Value_Date NVARCHAR2(10),
--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') > trunc(to_date(get_date_fm_btrv(get_param('EODCYYMMDD')),'YYYYMMDD'),'MM') then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
	-- when omdte is not null then to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY')
	 --else get_param('EOD_DATE')	end,
	 get_param('EOD_DATE'), --As per Sandep bandela confirmation on 05-01-2017 changed to cut off_date
--Flow_Id NVARCHAR2(2),
rpad('DISBM',5,' '),
--Demand_Date NVARCHAR2(10),
rpad(' ',10,' '),
--Last_part_tran_flag NVARCHAR2(1),
rpad('N',1,' '),
--Trans_End_ind NVARCHAR2(1),
rpad('N',1,' '),
--Adv_Pay_flag NVARCHAR2(1),
rpad('N',1,' '),
--Prepay_Type NVARCHAR2(1),
rpad(' ',1,' '),
--Int_coll_on_prepay_flag NVARCHAR2(1),
rpad(' ',1,' '),
--Trans_Remarks NVARCHAR2(200),
rpad(' ',30,' '),
--Trans_Part NVARCHAR2(200)
rpad(fin_acc_num,50,' ')   
FROM MAP_ACC
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = leg_acc_num
left join (SELECT ombrnm,omdlp,omdlr ,Max(omdte) omdte FROM ompf WHERE  omdte <= get_param('EODCYYMMDD') GROUP BY ombrnm,omdlp,omdlr)ompf on leg_acc_num=ombrnm||trim(omdlp)||trim(omdlr)
inner join c8pf on c8ccy = otccy
where map_acc.schm_type='CLA' and OTDLA <> 0
union all
select 'T','BI',rpad((fin_sol_id||crncy_alias_num||'52000CLA'),16,' '), currency,rpad(fin_sol_id,8,' '),lpad(calc_bal,17,' '),'C',' ',rpad(get_param('EOD_DATE'),10,' '),rpad(' ',5,' '),rpad(' ',10,' '),'Y','N','N',' ',' ',rpad(' ',30,' '),rpad(fin_acc_num,50,' ')
from
--(select fin_acc_num,map_acc.fin_sol_id,currency,sum(to_number(abs(otdla)/POWER(10,c8pf.C8CED))) calc_bal ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
(select fin_acc_num,map_acc.fin_sol_id,currency,(to_number(abs(otdla)/POWER(10,c8pf.C8CED))) calc_bal 
from MAP_ACC
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = leg_acc_num
left join (SELECT ombrnm,omdlp,omdlr ,Max(omdte) omdte FROM ompf WHERE  omdte <= get_param('EODCYYMMDD') GROUP BY ombrnm,omdlp,omdlr)ompf on leg_acc_num=ombrnm||trim(omdlp)||trim(omdlr)
inner join c8pf on c8ccy = otccy
where map_acc.schm_type='CLA' and OTDLA <> 0
--group by currency,map_acc.fin_sol_id ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
order by currency,map_acc.fin_sol_id)
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on crncy_code=currency; 
commit;
---------------------------Balance transaction for LAC scheme code --------------------
insert into Cl007_O_TABLE
select 
--Trans_Type NVARCHAR2(1),
rpad('T',1,' '),
--Trans_Sub_Type NVARCHAR2(3),
rpad('BI',2,' '),
--Acc_Num NVARCHAR2(16),
rpad(fin_acc_num,16,' '),
--Curr NVARCHAR2(3),
rpad(map_acc.currency,3,' '),
--Sol_Id NVARCHAR2(4),
rpad(fin_sol_id,8,' '),
--Trans_Amt NVARCHAR2(20),
lpad(to_number(abs(scbal))/POWER(10,c8pf.C8CED),17,' '),
--Part_Tran_Type NVARCHAR2(2),
rpad('D',1,' '),
--Type_of_demands NVARCHAR2(2),
rpad( 'P',1,' '),
--Value_Date NVARCHAR2(10),
	 get_param('EOD_DATE'), --As per Sandep bandela confirmation on 05-01-2017 changed to cut off_date
--Flow_Id NVARCHAR2(2),
rpad('DISBM',5,' '),
--Demand_Date NVARCHAR2(10),
rpad(' ',10,' '),
--Last_part_tran_flag NVARCHAR2(1),
rpad('N',1,' '),
--Trans_End_ind NVARCHAR2(1),
rpad('N',1,' '),
--Adv_Pay_flag NVARCHAR2(1),
rpad('N',1,' '),
--Prepay_Type NVARCHAR2(1),
rpad(' ',1,' '),
--Int_coll_on_prepay_flag NVARCHAR2(1),
rpad(' ',1,' '),
--Trans_Remarks NVARCHAR2(200),
rpad(' ',30,' '),
--Trans_Part NVARCHAR2(200)
rpad(fin_acc_num,50,' ')   
from map_acc 
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
inner join c8pf on c8ccy = currency
where map_acc.schm_type='CLA'  and map_acc.schm_code IN ('LAC','CLM')
and scbal <> 0
union all
select 'T','BI',rpad((fin_sol_id||crncy_alias_num||'52000CLA'),16,' '), currency,rpad(fin_sol_id,8,' '),lpad(calc_bal,17,' '),'C',' ',rpad(get_param('EOD_DATE'),10,' '),rpad(' ',5,' '),rpad(' ',10,' '),'Y','N','N',' ',' ',rpad(' ',30,' '),rpad(fin_acc_num,50,' ')
from
--(select map_acc.fin_sol_id,currency,sum(to_number(abs(scbal))/POWER(10,c8pf.C8CED)) calc_bal  ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
(select fin_acc_num,map_acc.fin_sol_id,currency,(to_number(abs(scbal))/POWER(10,c8pf.C8CED)) calc_bal 
from map_acc 
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
inner join c8pf on c8ccy = currency
where map_acc.schm_type='CLA'  and map_acc.schm_code IN ('LAC','CLM')
and scbal <> 0
--group by currency,map_acc.fin_sol_id ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
order by currency,map_acc.fin_sol_id)
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on crncy_code=currency;
commit;
----Corporate Loan Drawdown bloack added on 04-06-2017--
--insert into Cl007_O_TABLE
--select 
----Trans_Type NVARCHAR2(1),
--rpad('T',1,' '),
----Trans_Sub_Type NVARCHAR2(3),
--rpad('BI',2,' '),
----Acc_Num NVARCHAR2(16),
--rpad(a.fin_acc_num,16,' '),
----Curr NVARCHAR2(3),
--rpad(a.currency,3,' '),
----Sol_Id NVARCHAR2(4),
--rpad(a.fin_sol_id,8,' '),
----Trans_Amt NVARCHAR2(20),
--lpad(sum(to_number(abs(otdla)/POWER(10,c8pf.C8CED))),17,' '),
----Part_Tran_Type NVARCHAR2(2),
--rpad('D',1,' '),
----Type_of_demands NVARCHAR2(2),
--rpad( 'P',1,' '),
----Value_Date NVARCHAR2(10),
--	 get_param('EOD_DATE'), 
--	-- case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
--    --else ' ' end,---changed based on requirement by sandeep on 05-07-2017 for mock5 migration-- commented on 20-08-2017 based on sandeep confirmation.
----Flow_Id NVARCHAR2(2),
--rpad('DISBM',5,' '),
----Demand_Date NVARCHAR2(10),
--rpad(' ',10,' '),
----Last_part_tran_flag NVARCHAR2(1),
--rpad('N',1,' '),
----Trans_End_ind NVARCHAR2(1),
--rpad('N',1,' '),
----Adv_Pay_flag NVARCHAR2(1),
--rpad('N',1,' '),
----Prepay_Type NVARCHAR2(1),
--rpad(' ',1,' '),
----Int_coll_on_prepay_flag NVARCHAR2(1),
--rpad(' ',1,' '),
----Trans_Remarks NVARCHAR2(200),
--rpad(' ',30,' '),
----Trans_Part NVARCHAR2(200)
--rpad(a.fin_acc_num,50,' ')   
----from map_acc a
----inner join cla_ld_acct_details b on b.fin_acc_num=a.fin_acc_num
----inner join c8pf on c8ccy = currency
----where OTDLA <> 0 
--from (select * from map_acc  where length(trim(leg_acc_num))<13)a
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=serial_deal
--inner join otpf on otbrnm||trim(otdlp)||trim(otdlr)=b.LEG_ACC_NUM
----inner join ompf on ombrnm||trim(omdlp)||trim(omdlr)=b.LEG_ACC_NUM
--inner join c8pf on c8ccy = currency
----where ommvt='P' and ommvts in ('C','O')
--group by a.fin_acc_num,a.currency,a.fin_sol_id,otsdte,acc_pref_rate---added based on requirement by sandeep on 05-07-2017 for mock5 migration
--union all
--select 'T','BI',rpad((fin_sol_id||crncy_alias_num||'52000CLA'),16,' '), currency,rpad(fin_sol_id,8,' '),lpad(calc_bal,17,' '),'C',' ',rpad(get_param('EOD_DATE'),10,' '),rpad(' ',5,' '),rpad(' ',10,' '),'Y','N','N',' ',' ',rpad(' ',30,' '),rpad(fin_acc_num,50,' ')
--from
--(select a.fin_acc_num,a.fin_sol_id,currency,sum(to_number(abs(otdla)/POWER(10,c8pf.C8CED))) calc_bal 
----from map_acc a
----inner join cla_ld_acct_details b on b.fin_acc_num=a.fin_acc_num
----inner join c8pf on c8ccy = currency
----where OTDLA <> 0
--from (select * from map_acc  where length(trim(leg_acc_num))<13)a
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=serial_deal
--inner join otpf on otbrnm||trim(otdlp)||trim(otdlr)=b.LEG_ACC_NUM
----inner join ompf on ombrnm||trim(omdlp)||trim(omdlr)=b.LEG_ACC_NUM
--inner join c8pf on c8ccy = currency
----where ommvt='P' and ommvts in ('C','O')
--group by a.fin_acc_num,a.currency,a.fin_sol_id,otsdte,acc_pref_rate---added based on requirement by sandeep on 05-07-2017 for mock5 migration
--order by currency,a.fin_sol_id)
--left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on crncy_code=currency; 
--commit;
exit; 
