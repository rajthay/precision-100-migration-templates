========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
sweeps.sql 
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/KW_SWEEPS.dat
select 
'LEG_ACC_NUM'||'|'||
'FIN_ACC_NUM'||'|'||
'ACC_NUM_MATCH'||'|'||
'LEG_POOL_NUMBER'||'|'||
'FIN_POOL_ID'||'|'||
'LEG_POOL_DESC'||'|'||
'FIN_POOL_DESC'||'|'||
'POOL_DESC_MATCH' ||'|'||
'LEG_SUSPEND_FLAG'||'|'||
'FIN_SUSPEND_FLAG'||'|'||
'SUSPEND_FLAG_MATCH' ||'|'||
'LEG_UTILIZATION_ORDER'||'|'||
'FIN_UTILIZATION_ORDER'||'|'||
'UTILIZATION_ORDER_MATCH'||'|'||
'LEG_POOL_TYPE'||'|'||
'FIN_POOL_TYPE'||'|'||
'POOL_TYPE_MATCH'
from dual
union all
select
to_char(case when r7bot <> 'D' then rPAD(FIN_BO_ACCOUNT,16,' ') else RPAD(FIN_BO_DR_ACCT,16,' ') end) ||'|'||
foracid||'|'||
case when case when r7bot <> 'D' then trim(FIN_BO_ACCOUNT) else trim(FIN_BO_DR_ACCT) end=foracid then 'TRUE' else 'FALSE' end ||'|'||
case when bo_fin_cif_id is null then RPAD(' ',6,' ') else RPAD(bo_fin_cif_id,6,' ') end||'|'||
POOL_OWNER_CUST_ID||'|'||
case when bo_fin_cif_id is null then (' ') else (bo_fin_cif_id) end||'|'||
to_char(POOL_DESC) ||'|'||
case when trim(case when bo_fin_cif_id is null then (' ') else (bo_fin_cif_id) end) = trim(to_char(POOL_DESC)) then 'TRUE' else 'FALSE' end||'|'||
'N'||'|'||
to_char(SUSPEND_FLG)||'|'||
case when ('N') = to_char(SUSPEND_FLG) then 'TRUE' else 'FALSE' end ||'|'||
to_char(R0SEQ) ||'|'||
ORDER_OF_UTILISATION||'|'||
case when to_number(trim(R0SEQ))= to_number(ORDER_OF_UTILISATION) then 'TRUE' else 'FALSE' end||'|'||
case when trim(FUND_CCY) <> trim(RECV_CCY) then 'M' else 'S' end||'|'||
POOL_TYPE ||'|'||
case when (case when trim(FUND_CCY) <> trim(RECV_CCY) then 'M' else 'S' end)= trim(POOL_TYPE) then 'TRUE' else 'FALSE' end 
from BALANCE_ORDER
inner join c8pf on trim(c8ccy) = trim(fund_ccy)
inner join map_acc on fin_acc_num=case when r7bot <> 'D' then trim(FIN_BO_ACCOUNT) else trim(FIN_BO_DR_ACCT) end
left join (select * from tbaadm.gam where bank_id='01')gam on foracid=fin_acc_num  
left join (select * from tbaadm.pft where bank_id='01')pft on gam.pool_id=pft.pool_id
where r7npr >get_param('EODCYYMMDD') AND r7fld>get_param('EODCYYMMDD')
and r0frc ='R' and map_acc.schm_type in ('SBA','CAA','ODA');
EXIT;




select 
trim(pool.Account_number) LEG_ACCOUNT,
foracid FIN_ACCOUNT,
case when trim(pool.Account_number)=foracid then 'TRUE' else 'FALSE' end ACCOUNT_MATCH,
pool.POOL_NUMBER LEG_POOL_NO,
POOL_OWNER_CUST_ID FIN_POOL_ID,
pool.POOL_DESC LEG_POOL_DESC,
pft.POOL_DESC FIN_POOL_DESC,
case when trim(pool.POOL_DESC) = trim(pft.POOL_DESC) then 'TRUE' else 'FALSE' end POOL_DESC_MATCH,
pool.SUSPEND_FLAG LEG_SUSPEND,
pft.SUSPEND_FLG FIN_SUSPEND,
case when trim(pool.SUSPEND_FLAG) = trim(pft.SUSPEND_FLG) then 'TRUE' else 'FALSE' end  SUSPEND_FLAG_MATCH,
pool.ORDER_OF_UTILIZATION LEG_ORDER_OF_UTILIZATION,
GAM.ORDER_OF_UTILISATION FIN_ORDER_OF_UTILISATION,
case when trim(pool.ORDER_OF_UTILIZATION) = trim(GAM.ORDER_OF_UTILISATION) then 'TRUE' else  'FALSE' end ORDER_OF_UTILISATION_MATCH,
pool.POOL_TYPE LEG_POOL_TYPE,
pft.POOL_TYPE  FIN_POOL_TYPE,
case when trim(pool.POOL_TYPE) = trim(pft.POOL_TYPE) then 'TRUE' else 'FALSE' end POOL_TYPE_MATCH 
from (select * from custom_pool_o_table where trim(ORDER_OF_UTILIZATION)='1') pool
inner join (select * from tbaadm.gam where bank_id='01' and ORDER_OF_UTILISATION='1')gam on gam.foracid=trim(pool.Account_number)
left join (select * from tbaadm.pft where bank_id='01')pft on gam.pool_id=pft.pool_id and trim(pool.POOL_DESC) = trim(pft.POOL_DESC) 
