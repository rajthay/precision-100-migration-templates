
-- File Name		: custom_past_due_date.sql 
-- File Created for	: Upload file for past due date 
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 11-09-2017
-------------------------------------------------------------------
drop table custom_excess_dt_casa_od;
create table custom_excess_dt_casa_od as
select distinct  FIN_ACC_NUM,SCHM_TYPE, to_char(to_date(pass_due_dt,'YYYYMMDD'),'DD-MM-YYYY') EXC_EXP_date
from map_Acc 
--inner join (select lp10_acct acc_num,'Y' past_due_flg, case when LP10_LED <> 0 then LP10_LED else LP10_LXD end pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0 and LP10_LED <> 0 union all
--select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt,to_char( to_number(LP10_LGR_K)-to_number(LP10_LMT_K)) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXCESS' and to_number(LP10_LMT_C)<> 0)past on fin_acc_num=trim(acc_num)
inner join (select acc_num,past_due_flg,suspence_amt,min(PASS_DUE_DT) PASS_DUE_DT from  (
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LBD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where to_number(LP10_LMT_C)=0 
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LXD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0 and LP10_LED <> 0
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt,to_char( to_number(LP10_LGR_K)-to_number(LP10_LMT_K)) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXCESS' and to_number(LP10_LMT_C)<> 0)
    group by acc_num,past_due_flg,suspence_amt)past on fin_acc_num=trim(acc_num)
where schm_type <> 'OOO' ;
exit; 
