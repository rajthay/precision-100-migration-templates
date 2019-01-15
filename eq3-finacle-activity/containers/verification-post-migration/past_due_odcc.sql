========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
past_due_odcc.sql 
select distinct 
foracid,
Suspence_amt LEG_PAST_DUE_AMT,
DISCRET_ADVN_AMT FIN_PAST_DUE_AMT,
case when nvl(abs(Suspence_amt),'0')=nvl(DISCRET_ADVN_AMT,'0') then 'TRUE' else 'FALSE' end PAST_DUE_MATCH,
to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY') - case when past.acc_num is not null then to_date(pass_due_dt,'YYYYMMDD') else to_date(get_param('EOD_DATE'),'DD-MM-YYYY') end) LEG_PD_DAYS,
DB_STAT_DATE-DISCRET_ADVN_DUE_DATE FINACLE_PD_DAYS,
case when nvl(to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY') - case when past.acc_num is not null then to_date(pass_due_dt,'YYYYMMDD') else to_date(get_param('EOD_DATE'),'DD-MM-YYYY') end),0) = nvl(DB_STAT_DATE-DISCRET_ADVN_DUE_DATE,0) then 'TRUE' else 'FALSE' end PD_DAYS_MATCH,
to_char(case when past.acc_num is not null then to_char(to_date(pass_due_dt,'YYYYMMDD'),'DD-MM-YYYY') else lpad(' ',10,' ') end) LEG_PD_DATE,
DISCRET_ADVN_DUE_DATE FIN_PD_DATE,
case when nvl(trim(to_char(case when past.acc_num is not null then to_char(to_date(pass_due_dt,'YYYYMMDD'),'DD-MM-YYYY') else lpad(' ',10,' ') end)),'*')=nvl(to_char(DISCRET_ADVN_DUE_DATE,'DD-MM-YYYY'),'*') then 'TRUE' else 'FALSE' end PD_DATE_MATCH
from (select * from map_acc where schm_type in ('CAA','ODA'))map_acc
left join (select acc_num,past_due_flg,suspence_amt,min(PASS_DUE_DT) PASS_DUE_DT from  (
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LBD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where to_number(LP10_LMT_C)=0 
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LXD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0 and LP10_LED <> 0
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt,to_char( to_number(LP10_LGR_K)-to_number(LP10_LMT_K)) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXCESS' and to_number(LP10_LMT_C)<> 0)
    group by acc_num,past_due_flg,suspence_amt)past on fin_acc_num=trim(acc_num)
inner JOIN (select * from tbaadm.gam where gam.bank_id='01' and schm_type in ('CAA','ODA') )gam ON gam.foracid = map_acc.fin_acc_num
LEFT JOIN (select * from tbaadm.gac where bank_id='01')gac ON gac.acid = gam.acid     
left join (select * from TBAADM.dat where bank_id='01' and DISCRET_ADVN_DUE_DATE<'20-oct-2017')dat on dat.acid=gam.acid
left join (select * from tbaadm.gct where bank_id='01')gct on gct.bank_id=dat.bank_id 
