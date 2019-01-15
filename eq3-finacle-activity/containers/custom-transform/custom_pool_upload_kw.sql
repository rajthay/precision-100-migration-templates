
-- File Name        : Custom_Pool_upload_kw.sql
-- File Created for : Sweeps pool Upload
-- Created By       : R.Alavudeen Ali Badusha
-- Client           : ABK
-- Created On       : 27-12-2016
-------------------------------------------------------------------
drop table sweeps;
create table sweeps as
select dense_rank() over(order by r0ab||r0an||r0as ) pool_num,FIN_BO_DR_ACCT,FIN_BO_CR_ACCT,FUND_CCY,RECV_CCY
--from BALANCE_ORDER a
from VW_SWEEPS a
inner join map_acc dr on dr.fin_acc_num=trim(FIN_BO_DR_ACCT)
inner join map_acc cr on cr.fin_acc_num=trim(FIN_BO_CR_ACCT)
where --r7npr >get_param('EODCYYMMDD') AND r7fld>get_param('EODCYYMMDD')
--and r0frc ='R' 
-- and 
dr.schm_type in ('SBA','CAA','ODA') and cr.schm_type in ('SBA','CAA','ODA');
truncate table custom_pool_o_table;
insert into custom_pool_o_table
select
--  Pool_Number                     Nvarchar2(6),
RPAD(pool_num,6,' '),
--  Account_Number                  Nvarchar2(16),
rPAD(acc_num,16,' '),
--  Pool_Desc                       Nvarchar2(50),
RPAD(fin_cif_id,50,' '),
--  Suspend_Flag                    Nvarchar2(1),
'N',
--  Suspend_Date                    Nvarchar2(10),
rpad(' ',10,' '),
--  Order_of_Utilization            Nvarchar2(4),
rpad(row_number() over( partition by pool_num order by pool_num),4,' '),
--  Alternate_Pool_Desc             Nvarchar2(50),
RPAD(fin_cif_id,50,' '),
--  Pool_Type                       Nvarchar2(1),
case when trim(FUND_CCY) <> trim(RECV_CCY) then 'M' else 'S' end,
--  Auto_Regularize                 Nvarchar2(1)
'Y'
from 
(select pool_num,fin_bo_dr_acct acc_num,substr(fin_bo_dr_acct,1,10) fin_cif_id,fund_ccy,recv_ccy from sweeps
union
select pool_num,fin_bo_cr_acct acc_num,substr(fin_bo_cr_acct,1,10) fin_cif_id,fund_ccy,recv_ccy from sweeps);
commit;
exit;
 
