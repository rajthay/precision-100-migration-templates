
-- File Name        : custom_draw_down_int_upload.sql 
-- File Created for    : Upload file for individual draw down interest
-- Created By        : R.Alavudeen Ali Badusha
-- Client            : ABK
-- Created On        : 10-05-2017
-------------------------------------------------------------------
truncate table draw_down_int_o_table;
insert into draw_down_int_o_table 
select 
--Account_Number  nvarchar2(16),
rpad(A.fin_acc_num,16,' '),
--Draw_Down_Date  nvarchar2(10), 
rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
    else ' ' end,10,' '),
--Draw_Down_Amount nvarchar2(17),
lpad(sum(abs(to_number(omnwp/POWER(10,c8pf.C8CED)))),17,' '),---Gop-- appended 1 to table name
--lpad(sum(abs(to_number(ompf_ld_cla.omnwp/POWER(10,c8pf.C8CED)))),17,' '),
--Effective_Int_Rate nvarchar2(10),
rpad(acc_pref_rate,10,' '),
--Event_Flag nvarchar2(1)
rpad(' ',1,' ')
from (select * from map_acc  where length(trim(leg_acc_num))<13)a
inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=serial_deal
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr)=b.LEG_ACC_NUM
inner join ompf on ombrnm||trim(omdlp)||trim(omdlr)=b.LEG_ACC_NUM
inner join c8pf on c8ccy = currency
where ommvt='P' and ommvts in ('C','O')
group by a.fin_acc_num,otsdte,acc_pref_rate;
commit;
exit;
 
