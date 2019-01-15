
--Corporate Loan Drawdown bloack added on 04-06-2017--
--drop table cla_ld_accrual;
--create table cla_ld_accrual as
--select a.fin_acc_num,sum(to_number(v5am1)+to_number(V5AIM)) accrual
--from map_acc a
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--left join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr)=b.LEG_ACC_NUM
--group by a.fin_acc_num;
drop table s7pf_bal;
create table s7pf_bal as
select s7ab||s7an||s7as leg_num,s7bal1 min_bal,S7ND01 days,'01' Mnth,'01-01-2017' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal2,S7ND02,'02','01-02-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal3,S7ND03,'03','01-03-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal4,S7ND04,'04','01-04-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal5,S7ND05,'05','01-05-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal6,S7ND06,'06','01-06-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal7,S7ND07,'07','01-07-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal8,S7ND08,'08','01-08-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal9,S7ND09,'09','01-09-2016' dat from s7pf where s7sbtp='L' 
union all
--select s7ab||s7an||s7as leg_num,s7bala,S7ND10,'10','01-10-2016' dat from s7pf where s7sbtp='L' 
--union all
select s7ab||s7an||s7as leg_num,s7balb,S7ND11,'11','01-12-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7balc,S7ND12,'12','01-12-2016' dat from s7pf where s7sbtp='L' 
----if it's cutoff date in between  month --enable s7balm
union all 
select s7ab||s7an||s7as leg_num,s7balm,S7NDtd,to_char(to_date(get_param('EOD_DATE'),'DD-MM_YYYY'),'MM'),to_char(trunc(to_date(get_param('EOD_DATE'),'DD-MM_YYYY'),'MM'),'DD-MM-YYYY') Dat from s7pf where s7sbtp='L'
; 
drop table s7pf_bal1;
create table s7pf_bal1 as
select distinct leg_num,min_bal/power(10,c8ced) min_bal,days,mnth,s5ifqc,s5ncdc,S5CCY from s5pf
inner join s7pf_bal a on leg_num=s5ab||s5an||s5as
inner join map_acc on leg_branch_id||leg_scan||leg_scas=leg_num
inner join c8pf on s5ccy=c8ccy
where s5ncdc <> '9999999' and schm_type ='SBA'
--and to_number(to_char(add_months(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),case when substr(s5ifqc,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then -12
--    when substr(s5ifqc,0,1) in ('V') then -1 when substr(s5ifqc,0,1) in ('S','T','U') then -3 when substr(s5ifqc,0,1) in ('M','N','O','P','Q','R') then -6 else -1 end),'MM')) <= to_number(mnth)
and add_months(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),case when substr(s5ifqc,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then -12
   when substr(s5ifqc,0,1) in ('V') then -1 when substr(s5ifqc,0,1) in ('S','T','U') then -3 when substr(s5ifqc,0,1) in ('M','N','O','P','Q','R') then -6 else -1 end)  < to_date(dat,'DD-MM-YYYY')
order by leg_num,mnth;
drop table s7pf_bal2;
create table s7pf_bal2 as
select distinct leg_num,min_bal,s5ifqc from s7pf_bal1 
where (leg_num,min_bal) in (
select leg_num,min(to_number(min_bal)) min_bal from s7pf_bal1  group by leg_num);
--create table s7pf_bal2 as
--select distinct leg_num,min_bal,TRANSACTION_DATE,RUNNING_BALANCE,s5ifqc,
--case when TRANSACTION_DATE is not null then TRANSACTION_DATE else add_months(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),case when substr(s5ifqc,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then -12
--    when substr(s5ifqc,0,1) in ('V') then -1 when substr(s5ifqc,0,1) in ('S','T','U') then -3 when substr(s5ifqc,0,1) in ('M','N','O','P','Q','R') then -6 else -1 end) end tran_date 
-- from s7pf_bal1 
--left join archival_transaction b on to_char(transaction_date,'MM')=mnth and min_bal=RUNNING_BALANCE and leg_num=acc_number
--where (leg_num,mnth) in (
--select leg_num,min(mnth) mnth from s7pf_bal1 where (leg_num,min_bal) in (
--select leg_num,min(to_number(min_bal)) min_bal from s7pf_bal1  group by leg_num)
--group by leg_num );

--EIT FOR SBA CAA AND ODA---
truncate table CUSTOM_EIT;
insert into CUSTOM_EIT
select 
--ENTITY_ID,
gam.acid,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--ACCRUED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--INTEREST_CALC_UPTO_DATE_CR,
case when S5LCDC<>0 and   get_date_fm_btrv(S5LCDC) <> 'ERROR' then to_date(get_date_fm_btrv(S5LCDC),'YYYYMMDD') 
else to_date(get_param('EOD_DATE'),'DD-MM-YYYY') end, ---as per sandeep confirmation cut off date provided on 05-03-2017
--INTEREST_CALC_UPTO_DATE_DR,
case when S5LCDD<>0 and   get_date_fm_btrv(S5LCDD) <> 'ERROR' then to_date(get_date_fm_btrv(S5LCDD),'YYYYMMDD') 
else to_date(get_param('EOD_DATE'),'DD-MM-YYYY') end,
--LAST_INTEREST_RUN_DATE_CR,
case when S5LCDC<>0 and   get_date_fm_btrv(S5LCDC) <> 'ERROR' then to_date(get_date_fm_btrv(S5LCDC),'YYYYMMDD') 
else to_date(get_param('EOD_DATE'),'DD-MM-YYYY') end,
--LAST_INTEREST_RUN_DATE_DR,
case when S5LCDD<>0 and   get_date_fm_btrv(S5LCDD) <> 'ERROR' then to_date(get_date_fm_btrv(S5LCDD),'YYYYMMDD') 
else to_date(get_param('EOD_DATE'),'DD-MM-YYYY') end,
--XFER_MIN_BAL,
case when map_acc.schm_type='SBA' and min_bal is not null and s5pf.s5ifqc='Z' and scbal > 0 then scbal/power(10,c8ced) when map_acc.schm_type='SBA' and min_bal is not null then nvl(min_bal,0) else null end,
--XFER_MIN_BAL_DATE,
case when map_acc.schm_type='SBA' and min_bal is not null then to_date(get_param('EOD_DATE'),'DD-MM-YYYY') else null end,
--NRML_ACCRUED_AMOUNT_CR,
abs(to_number((s5am1c)/POWER(10,c8pf.C8CED))),
--NRML_BOOKED_AMOUNT_CR,
abs(to_number((s5am1c)/POWER(10,c8pf.C8CED))),
--NRML_BOOKED_AMOUNT_DR,
abs(to_number((s5am1d)/POWER(10,c8pf.C8CED))),
--NRML_ACCRUED_AMOUNT_DR
abs(to_number((s5am1d)/POWER(10,c8pf.C8CED)))
from map_acc
inner join scpf on scpf.scab=map_acc.leg_branch_id and scpf.scan=map_acc.leg_scan and scpf.scas=map_acc.leg_scas   
inner join s5pf on s5pf.s5ab=map_acc.leg_branch_id and s5pf.s5an=map_acc.leg_scan and s5pf.s5as=map_acc.leg_scas
--left join (select * from s7pf_bal2 where (leg_num,to_date(tran_date,'DD-MM-YYYY')) in ( 
--select leg_num, min(to_date(tran_date,'DD/MM/YYYY')) tran_date from s7pf_bal2 group by leg_num)) bal on leg_num=leg_branch_id||leg_scan||leg_scas
left join s7pf_bal2 on leg_num=leg_branch_id||leg_scan||leg_scas
left join (select * from tbaadm.gam where schm_type in('SBA','CAA','ODA')and bank_id=get_param('BANK_ID')) gam on gam.foracid=map_acc.fin_acc_num
inner join c8pf on c8ccy = map_acc.currency       
where map_acc.schm_type in ('SBA','CAA','ODA') and map_acc.schm_code<>'PISLA' and scai30 <> 'Y'
union
select 
--ENTITY_ID,
gam.acid,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--ACCRUED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 05-03-2017
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--BOOKED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 05-03-2017
--INTEREST_CALC_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--INTEREST_CALC_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--LAST_INTEREST_RUN_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--LAST_INTEREST_RUN_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--XFER_MIN_BAL,
0,
--XFER_MIN_BAL_DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--NRML_ACCRUED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_DR,
0,
--NRML_ACCRUED_AMOUNT_DR
(to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced)
from v5pf
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join c8pf on trim(c8ccy)=currency
left join ospf on v5brnm=osbrnm and v5dlp=osdlp and v5dlr=osdlr
left join (select * from otpf where OTTDT='L')otpf on  v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
left join (select * from tbaadm.gam where schm_type in('SBA','CAA','ODA')and bank_id=get_param('BANK_ID')) gam on gam.foracid=map_acc.fin_acc_num
where map_acc.SCHM_TYPE in('CAA') AND map_acc.schm_code='PISLA' and v5pf.v5tdt='L' and v5pf.v5bal<>'0' and scai30 <> 'Y';
commit;
--EIT FOR TDA--
insert into CUSTOM_EIT
select 
--ENTITY_ID,
gam.acid,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--ACCRUED_UPTO_DATE_DR,
case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') else NULL end, ---Based on Sandeep requirement added on 20-06-2017
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_DR,
case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') else NULL end, ---Based on Sandeep requirement added on 20-06-2017
--INTEREST_CALC_UPTO_DATE_CR,
case 
when map_acc.schm_code='TDATD' and v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999'  then to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD') ---added on 25-09-2017 based on vijay discussion with sandeep and ravi maturity dt provided for atd schm
when  trim(v5lre)=0 and v5lcd <> 0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') --Added by jagadeesh on 15/May as issue was reported by Infosys Spira 6335
when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1
when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')
when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1
else to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 end,
--INTEREST_CALC_UPTO_DATE_DR,
case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') else NULL end, ---Based on Sandeep requirement added on 20-06-2017
--LAST_INTEREST_RUN_DATE_CR,
case 
when map_acc.schm_code='TDATD' and v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999'  then to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD') ---added on 25-09-2017 based on vijay discussion with sandeep and ravi maturity dt provided for atd schm
when  trim(v5lre)=0 and v5lcd <> 0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') --Added by jagadeesh on 15/May as issue was reported by Infosys Spira 6335
when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1
when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')
when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1
else to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 end,
--LAST_INTEREST_RUN_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--XFER_MIN_BAL,
0,
--XFER_MIN_BAL_DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017,
--NRML_ACCRUED_AMOUNT_CR,
case when map_acc.schm_code='TDATD' then  to_number(nvl(atd_clmamount,0))/power(10,c8pf.c8ced)--(to_number(v5am1)+to_number(V5AIM)+to_number(nvl(atd_clmamount,0)))/power(10,c8pf.c8ced)--- TDATD scheme added based on vijay mail 11-08-2017 --changed on 19-09-2017 based on spira no 8631- logic removed and only paid amount provided for tdatd--int paid amont provided on 25-09-2017 based on vijay discussion with sandeep and ravi
--when map_acc.schm_code='TDGTD' then (to_number(v5am1)+to_number(V5AIM)+to_number(nvl(clmamount,0)))/power(10,c8pf.c8ced) -- TDGTD added based on spira 7674 and vijay mail dt 13-08-2017
when clmamount is not null then (to_number(v5am1)+to_number(V5AIM)+to_number(nvl(clmamount,0)))/power(10,c8pf.c8ced) -- TDGTD removed based on discussion with vijay and sridhar on 09-09-2017
else (to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced) end ,
--NRML_BOOKED_AMOUNT_CR,
case when map_acc.schm_code='TDATD' then to_number(nvl(atd_clmamount,0))/power(10,c8pf.c8ced) --(to_number(v5am1)+to_number(V5AIM)+to_number(nvl(atd_clmamount,0)))/power(10,c8pf.c8ced) --- TDATD scheme added based on vijay mail 11-08-2017 --changed on 19-09-2017 based on spira no 8631- logic removed and 0 provided for tdatd--int paid amont provided on 25-09-2017 based on vijay discussion with sandeep and ravi
--when map_acc.schm_code='TDGTD' then (to_number(v5am1)+to_number(V5AIM)+to_number(nvl(clmamount,0)))/power(10,c8pf.c8ced) -- TDGTD added based on spira 7674 and vijay mail dt 13-08-2017
when clmamount is not null then (to_number(v5am1)+to_number(V5AIM)+to_number(nvl(clmamount,0)))/power(10,c8pf.c8ced) -- TDGTD removed based on discussion with vijay and sridhar on 09-09-2017
else (to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced) end,
--NRML_BOOKED_AMOUNT_DR,
0,
--NRML_ACCRUED_AMOUNT_DR
0 
from v5pf
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join c8pf on trim(c8ccy)=currency
left join ospf on v5brnm=osbrnm and v5dlp=osdlp and v5dlr=osdlr
left join (select * from otpf where OTTDT='D')otpf on  v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
left join (select * from tbaadm.gam where schm_type in('TDA')and bank_id=get_param('BANK_ID')) gam on gam.foracid=map_acc.fin_acc_num
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) atd_clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') >= case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
                                                   when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and trim(v4dlp)='ATD' and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
group by v5brnm,v5dlp,v5dlr)atd_int_amt on atd_int_amt.v5brnm =v5pf.v5brnm and atd_int_amt.v5dlp=v5pf.v5dlp  and  atd_int_amt.v5dlr=v5pf.v5dlr
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') > case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
                                                    when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
where map_acc.SCHM_TYPE='TDA' and v5pf.v5tdt='D' and v5pf.v5bal<>'0' ;
commit;
--EIT FOR LAA,CLA--
insert into CUSTOM_EIT
select 
--ENTITY_ID,
gam.acid,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--ACCRUED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--BOOKED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--INTEREST_CALC_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--INTEREST_CALC_UPTO_DATE_DR,
case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
--LAST_INTEREST_RUN_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--LAST_INTEREST_RUN_DATE_DR,
case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
--XFER_MIN_BAL,
0,
--XFER_MIN_BAL_DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--NRML_ACCRUED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_DR,
case when map_acc.schm_code in ('BDT' ,'ATD') then 0 
when MAP_ACC.schm_code in ('AUT', 'GFX', 'NCL', 'NFX', 'RSL', 'SPR', 'VTP', 'YAB','ZAB') and ((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced))-  (to_number(nvl(sum_overdue,0))/power(10,c8pf.c8ced)) <= 0 then abs(((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced))-  (to_number(nvl(sum_overdue,0))/power(10,c8pf.c8ced)))-----based on vijay mail 17-06-2017 added  -- modified on 13-07-2017 based on edwin mail
else abs((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced)) end,
--NRML_ACCRUED_AMOUNT_DR
case when MAP_ACC.schm_code in ('AUT', 'GFX', 'NCL', 'NFX', 'RSL', 'SPR', 'VTP', 'YAB','ZAB') and ((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced))-  (to_number(nvl(sum_overdue,0))/power(10,c8pf.c8ced)) <= 0 then abs(((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced))-  (to_number(nvl(sum_overdue,0))/power(10,c8pf.c8ced)))-----based on vijay mail 17-06-2017 added  -- modified on 13-07-2017 based on edwin mail
else abs((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced)) end 
from v5pf
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join c8pf on trim(c8ccy)=currency
left join ospf on v5brnm=osbrnm and v5dlp=osdlp and v5dlr=osdlr
left join (select * from otpf where OTTDT='L')otpf on  v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
left join (select * from tbaadm.gam where schm_type in('CLA','LAA')and bank_id=get_param('BANK_ID')) gam on gam.foracid=map_acc.fin_acc_num
left join (select lsbrnm,lsdlp,lsdlr,sum((to_number((lsamtd - lsamtp)))) sum_overdue from lspf where LSMVT = 'I' and  (lsamtd -lsamtp) < 0  and LSAMTD <> 0 and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num---based on vijay mail 17-06-2017 added 
where map_acc.SCHM_TYPE in('CLA','LAA')  and v5pf.v5tdt='L' and v5pf.v5bal<>'0';
commit;
insert into CUSTOM_EIT
select 
--ENTITY_ID,
gam.acid,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--ACCRUED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--BOOKED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--INTEREST_CALC_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--INTEREST_CALC_UPTO_DATE_DR,
case when S5LCDD <>0 and get_date_fm_btrv(S5LCDD)<> 'ERROR' then to_date(get_date_fm_btrv(S5LCDD),'YYYYMMDD')-1 
when SCOAD <>0 and get_date_fm_btrv(SCOAD)<> 'ERROR' then to_date(get_date_fm_btrv(SCOAD),'YYYYMMDD')-1          
end,
--LAST_INTEREST_RUN_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--LAST_INTEREST_RUN_DATE_DR,
case when S5LCDD <>0 and get_date_fm_btrv(S5LCDD)<> 'ERROR' then to_date(get_date_fm_btrv(S5LCDD),'YYYYMMDD')-1 
when SCOAD <>0 and get_date_fm_btrv(SCOAD)<> 'ERROR' then to_date(get_date_fm_btrv(SCOAD),'YYYYMMDD')-1          
end,
--XFER_MIN_BAL,
0,
--XFER_MIN_BAL_DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--NRML_ACCRUED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_DR,
abs(to_number((s5am1d)/POWER(10,c8pf.C8CED))),
--NRML_ACCRUED_AMOUNT_DR
abs(to_number((s5am1d)/POWER(10,c8pf.C8CED)))
from map_acc 
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
inner join s5pf on s5pf.s5ab=map_acc.leg_branch_id and s5pf.s5an=map_acc.leg_scan and s5pf.s5as=map_acc.leg_scas
inner join c8pf on c8ccy = currency
left join (select * from tbaadm.gam where schm_type='CLA' and schm_code in ('LAC','CLM'))gam on gam.foracid=MAP_ACC.FIN_ACC_NUM
where map_acc.schm_type='CLA'  and map_acc.schm_code in ('LAC','CLM') and scbal <> 0;
commit;
----Corporate Loan Drawdown bloack added on 04-06-2017--
--insert into CUSTOM_EIT
--select 
----ENTITY_ID,
--gam.acid,
----FORACID, 
--a.fin_acc_num,
----SCHM_TYPE,
--a.schm_type,
----ACCRUED_UPTO_DATE_CR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
----ACCRUED_UPTO_DATE_DR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
----BOOKED_UPTO_DATE_CR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
----BOOKED_UPTO_DATE_DR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
----INTEREST_CALC_UPTO_DATE_CR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
----INTEREST_CALC_UPTO_DATE_DR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY') dedit_Int_Calculated_Upto,
----case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
----when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
----LAST_INTEREST_RUN_DATE_CR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
----LAST_INTEREST_RUN_DATE_DR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY') dedit_Int_Calculated_Upto,
----case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
----when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
----XFER_MIN_BAL,
--0,
----XFER_MIN_BAL_DATE,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
----NRML_ACCRUED_AMOUNT_CR,
--0,
----NRML_BOOKED_AMOUNT_CR,
--0,
----NRML_BOOKED_AMOUNT_DR,
--abs(to_number(accrual)/power(10,c8pf.c8ced)),
----NRML_ACCRUED_AMOUNT_DR
--abs(to_number(accrual)/power(10,c8pf.c8ced)) 
--from map_acc a
--inner join cla_ld_acct_details b on b.fin_acc_num=a.fin_acc_num
--inner join c8pf on trim(c8ccy)=currency
--left join cla_ld_accrual c on c.fin_acc_num=a.fin_acc_num
--left join (select * from tbaadm.gam where schm_type='CLA' --and schm_code='LD' commented on 14-06-2017 for CLA changes
--)gam on gam.foracid=a.FIN_ACC_NUM;
--commit; 
truncate table CUSTOM_EIT_PCA;
insert into CUSTOM_EIT_PCA
select 
--ENTITY_ID,
DISB_ID,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--ACCRUED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--BOOKED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--INTEREST_CALC_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--INTEREST_CALC_UPTO_DATE_DR,
case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
--LAST_INTEREST_RUN_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--LAST_INTEREST_RUN_DATE_DR,
case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
--XFER_MIN_BAL,
0,
--XFER_MIN_BAL_DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--NRML_ACCRUED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_DR,
abs((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced)),
--NRML_ACCRUED_AMOUNT_DR
abs((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced)),
--ADVANCE_INT
abs(v4aim1/power(10,c8pf.c8ced)),
--AMORT_AMT 
abs((to_number(v4aim1)-to_number(v5am1))/power(10,c8pf.c8ced)),
--OPER_ACID
gam.acid
from map_acc
  inner join v5pf on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas 
  left join v4pf on trim(v4brnm)||trim(v4dlp)||trim(v4dlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  inner join c8pf on c8ccy = otccy
  left join tbaadm.disb on disb.REMARKS=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  left join pca_operacc oper on OMPF_LEG_NUM =trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  left join tbaadm.gam on foracid=oper.fin_acc_num
  where map_acc.schm_type='PCA' and map_acc.schm_code='LDADV'
  and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '');
commit;  
exit; 
