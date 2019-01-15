
-- File Name        : custom_rollover_upload.sql 
-- File Created for    : Upload file for LFR rollover details
-- Created By        : R.Alavudeen Ali Badusha
-- Client            : ABK
-- Created On        : 02-03-2016
-------------------------------------------------------------------
drop table Rollover_acct_opn_date;
create table Rollover_acct_opn_date as
select fin_acc_num,min(otsdte) otsdte,max(otmdt) otmdt,sum(otdla) otdla,min(v5lcd) v5lcd from map_acc a
inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
left join otpf on otbrnm||trim(otdlp)||trim(otdlr)=b.LEG_ACC_NUM
left join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr)=b.LEG_ACC_NUM
group by fin_acc_num;
truncate table rollover_o_Table; 
insert into  rollover_o_Table
select distinct 
--  ACCOUNT_ID                      NVARCHAR2(16),
rpad(map_acc.fin_acc_num,16,' '),
--  ROLLOVER_MONTHS                 NVARCHAR2(3),
lpad(round(((to_date(LIMIT_EXPIRY_DATE,'YYYYMMDD')-to_date(ACCT_OPEN_DATE,'YYYYMMDD'))-10)/30,0),3,' '),
--lpad(round(((to_date(LIMIT_EXPIRY_DATE,'YYYYMMDD')-case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end)-10)/30,0),3,' '), ---account open date taken as min start date from deal only for rollover--in master acct opn date is scoad tis is changed on 10-08-2017 as per vijay discussion with nancy
--  ROLLOVER_DAYS                   NVARCHAR2(3),
lpad('0',3,' '),
--  ROLLOVER_TYPE                   NVARCHAR2(1),
rpad('P',1,' '),
--  ROLLOVER_PRINCIPAL_AMOUNT       NVARCHAR2(17),
lpad(' ',17,' '),
--  PENDING_INTEREST_DEMANDS        NVARCHAR2(1),
lpad('O',1,' '),
--  INT_PAY_AFTER_ROLLOVER          NVARCHAR2(1),
rpad('S',1,' '),
--  MAX_NUM_TIMES_ROLLOVER_ALLOWED  NVARCHAR2(3),
--rpad(case when trim(ossrc) is null then '0' else '999' end,3,' '),
rpad('999',3,' '),
--  DEFERRED_INTEREST               NVARCHAR2(1),
lpad('D',1,' '),
--  TENOR_FOR_INTEREST_RATE         NVARCHAR2(1),
lpad('R',1,' '),
--  SUSPEND_ROLLOVER                NVARCHAR2(1),
rpad(' ',1,' '),    
--  NUMBER_OF_TIME_ROLLOVER_DONE    NVARCHAR2(3),
rpad(' ',3,' '),
--  ONLINE_BATCH_ROLLOVER           NVARCHAR2(1),
rpad(case when nvl(trim(ossrc),'F') = 'F' then 'O' else 'B' end,1,' '),
--  ADVANCE_INT_RECOVERY_AC_ID      NVARCHAR2(16),
rpad(' ',16,' '),
--  TRAN_EXCHANGE_RATE              NVARCHAR2(5),
--rpad('MID',5,' '), ----commented based on spira no 7957 and Vijay mail dt 27-08-2017 
rpad(' ',5,' '),
--  TRAN_RATE                       NVARCHAR2(10),
--rpad(abs(trim(ACCT_ID_DEBIT_PREF_PER)),10,' '), ----commented based on spira no 7957 and Vijay mail dt 27-08-2017 
rpad(' ',10,' '),
--  TRAN_TREASURY_RATE              NVARCHAR2(10),
--rpad(abs(trim(ACCT_ID_DEBIT_PREF_PER)),10,' '), ----commented based on spira no 7957 and Vijay mail dt 27-08-2017 
rpad(' ',10,' '),
--  TREASURY_REF_NO                 NVARCHAR2(20),
rpad(' ',20,' '),
--  ROLLOVER_EVENT                  NVARCHAR2(1)
rpad('R',1,' ')
from map_acc 
inner join cl001_o_table on trim(acc_num)=fin_acc_num
--inner join ld_deal_int_wise a on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and map_acc.leg_acc_num=to_char(serial_deal)
inner join ospf on trim(osbrnm)||trim(osdlp)||trim(osdlr)=leg_acc_num 
--left join Rollover_acct_opn_date roll on  roll.fin_acc_num=map_acc.fin_acc_num ---account open date taken as min start date from deal only for rollover--in master acct opn date is scoad tis is changed on 10-08-2017 as per vijay discussion with nancy
where schm_type='CLA' and map_acc.schm_code='LFR' and trim(ossrc) in ('A','R');
commit;
exit; 
