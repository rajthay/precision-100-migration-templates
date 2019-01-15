
drop table ompf_ld_cla2;
create table ompf_ld_cla2 as
select ombrnm||trim(omdlp)||trim(omdlr) ompf_leg_num,sum(omnwp) omnwp from  map_acc a 
inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
inner join ompf on ombrnm||trim(omdlp)||trim(omdlr) =b.leg_acc_num 
where ommvt='P' and ommvts in ('C','O') group by ombrnm||trim(omdlp)||trim(omdlr);
truncate table draw_down_o_table;
--insert into draw_down_o_table
--select
----Account_Number nvarchar2(16),
--rpad(fin_acc_num,16,' '),
----Start_Date     nvarchar2(10),
--START_DATE,
----End_Date nvarchar2(10),
--end_date, ---- based on sandepp requirement on 20-06-2017 changed from start_date to end_date
----Scheduled_Draw_Down_Amount nvarchar2(17),
--lpad(AMT,17,' '),
----Draw_Down_Currency nvarchar2(3),
--rpad(otccy,3,' '),
----Credit_Account_Num nvarchar2(16),
--rpad(' ',16,' '),
----ECS_Mandate_Serial nvarchar2(12),
--rpad(' ',12,' '),
----Mode_of_Draw_Down nvarchar2(1),
--rpad(' ',1,' '),
----Actual_Draw_Down_Amount nvarchar2(17),
--lpad(AMT,17,' '),-----------------value added on 15-08-2017 as per vijay discussion with nancy and natraj
----Remarks nvarchar2(60),
--rpad(deal_num,60,' '),---- based on sandeep requirement on 20-06-2017 deal num added
----Paysys_ID nvarchar2(5)
--rpad(' ',5,' ')
--from (select fin_acc_num,otccy,--LISTAGG(trim(b.leg_acc_num), ',')  WITHIN GROUP (ORDER BY fin_acc_num) deal_num,
--b.leg_acc_num deal_num,
--rpad(case --when v5lre<>'0' and get_date_fm_btrv(v5lre) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD'),'DD-MM-YYYY') ---based on nancy mail dt 20-08-2017 v5lre(last roll over date) commented
--     when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
--    else ' ' end,10,' ') start_date,
--rpad((case when --v5ncd<>'0' and get_date_fm_btrv(v5ncd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5ncd),'YYYYMMDD'),'DD-MM-YYYY') ---based on nancy mail dt 20-08-2017 v5ncd(next cycle date) commented)
--     when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY')
--     else ' ' end),10,' ') end_date,
----lpad(sum(abs(to_number(ompf_ld_cla2.omnwp/POWER(10,c8pf.C8CED)))),17,' ') amt
--lpad((abs(to_number(v5bal)/POWER(10,c8pf.C8CED))),17,' ') amt
--from (select * from map_acc where length(trim(leg_acc_num))<13) a
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--left join otpf on otbrnm||trim(otdlp)||trim(otdlr)=b.LEG_ACC_NUM
--left join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr)=b.LEG_ACC_NUM
----left join ompf_ld_cla2 on ompf_leg_num=b.LEG_ACC_NUM
--inner join c8pf on c8ccy = currency
----group by fin_acc_num,otccy,rpad(case when v5lre<>'0' and get_date_fm_btrv(v5lre) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD'),'DD-MM-YYYY') when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
--    --else ' ' end,10,' ')
--);
--commit;
insert into draw_down_o_table
select
--Account_Number nvarchar2(16),
rpad(fin_acc_num,16,' '),
--Start_Date     nvarchar2(10),
rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
    else ' ' end,10,' '),
--End_Date nvarchar2(10),
rpad((case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY')
     else ' ' end),10,' '),
--Scheduled_Draw_Down_Amount nvarchar2(17),
--lpad(case when abs(v5bal) > omnwp then  (abs(to_number(omnwp)/POWER(10,c8pf.C8CED)))
--else (abs(to_number(v5bal)/POWER(10,c8pf.C8CED))) end,17,' '),
lpad(abs(to_number(otdla/POWER(10,c8pf.C8CED))),17,' '),------changes on 07-09-2017 based on vijay discussion in meeting original deal amount  changed to current outstanding deal amount
--Draw_Down_Currency nvarchar2(3),
rpad(otccy,3,' '),
--Credit_Account_Num nvarchar2(16),
rpad(' ',16,' '),
--ECS_Mandate_Serial nvarchar2(12),
rpad(' ',12,' '),
--Mode_of_Draw_Down nvarchar2(1),
rpad(' ',1,' '),
--Actual_Draw_Down_Amount nvarchar2(17),
--lpad((abs(to_number(v5bal)/POWER(10,c8pf.C8CED))),17,' '),
lpad((abs(to_number(omnwp)/POWER(10,c8pf.C8CED))),17,' '),------changed on 07-09-2017 as per dicussion with vijay,nataraj and sandeep and nancy mail
--Remarks nvarchar2(60),fs
rpad(A.leg_acc_num,60,' '),
--Paysys_ID nvarchar2(5)
rpad(' ',5,' ')
from map_acc a
left join otpf on otbrnm||trim(otdlp)||trim(otdlr)=a.LEG_ACC_NUM
left join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr)=a.LEG_ACC_NUM
inner join c8pf on c8ccy = currency
inner join ompf_cla ON OMPF_LEG_NUM=LEG_ACC_NUM
WHERE SCHM_TYPE='CLA' and a.schm_code not in ('BDT','LAC','CLM');
commit;
exit;
 
