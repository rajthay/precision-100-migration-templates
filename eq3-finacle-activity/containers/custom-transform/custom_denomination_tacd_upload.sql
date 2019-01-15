
drop table denom_table;
create table  denom_table as
select '001' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT01,case when CURRENCYCODE='EUR' then '500' when CURRENCYCODE='GBP' then '50' 
when CURRENCYCODE='KWD' then '20' when CURRENCYCODE='USD' then '100' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'N' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '002' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT02,case when CURRENCYCODE='EUR' then '200' when CURRENCYCODE='GBP' then '20'
when CURRENCYCODE='KWD' then '10' when CURRENCYCODE='USD' then '50'  else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'N' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault    where currencycode in ('EUR','GBP','KWD','USD')
union all
select '003' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT03,case when CURRENCYCODE='EUR' then '100' when CURRENCYCODE='GBP' then '10'
when CURRENCYCODE='KWD' then '5' when CURRENCYCODE='USD' then '20'  else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'N' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '004' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT04,case when CURRENCYCODE='EUR' then '50' when CURRENCYCODE='GBP' then '5'
when CURRENCYCODE='KWD' then '1' when CURRENCYCODE='USD' then '10'  else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'N' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '005' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT05,case when CURRENCYCODE='EUR' then '20' when CURRENCYCODE='GBP' then '0.01'
when CURRENCYCODE='KWD' then '0.500' when CURRENCYCODE='USD' then '5'  else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all 
select '006' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT06,case when CURRENCYCODE='EUR' then '10' when CURRENCYCODE='GBP' then '0.02'
when CURRENCYCODE='KWD' then '0.250' when CURRENCYCODE='USD' then '1'  else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '007' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT07,case when CURRENCYCODE='EUR' then '5' when CURRENCYCODE='GBP' then '0.05'
when CURRENCYCODE='KWD' then '0.100' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '008' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT08,case when CURRENCYCODE='EUR' then '0.10' when CURRENCYCODE='GBP' then '0.10'
when CURRENCYCODE='KWD' then '0.050' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '009' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT09,case when CURRENCYCODE='EUR' then '0.20'  when CURRENCYCODE='GBP' then '0.20'
when CURRENCYCODE='KWD' then '0.020' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '010' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT10,case when CURRENCYCODE='EUR' then '0.50'  when CURRENCYCODE='GBP' then '0.10'
when CURRENCYCODE='KWD' then '0.010' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '011' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT11,case when CURRENCYCODE='EUR' then '1'  when CURRENCYCODE='GBP' then '1'
when CURRENCYCODE='KWD' then '0.005' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '012' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT12,case when CURRENCYCODE='EUR' then '2'  when CURRENCYCODE='GBP' then '2'
when CURRENCYCODE='KWD' then '0.001' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '013' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT13,case when CURRENCYCODE='EUR' then '0.01'  when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '014' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT14,case when CURRENCYCODE='EUR' then '0.02'  when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '015' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT15,case when CURRENCYCODE='EUR' then '0.05'  when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault
union all
select '016' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT16,case when CURRENCYCODE='EUR' then  'XXX' when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX'else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '017' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT17,case when CURRENCYCODE='EUR' then 'XXX'  when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '018' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT18,case when CURRENCYCODE='EUR' then 'XXX'  when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '019' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT19,case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '020' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT20,case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD');
------------------------------------------------------
truncate table tacd_o_table;
insert into tacd_o_table
select distinct 
--TELLER_ACCT
fin_acc_num,
--CRNCY_CODE
scccy,
--TRAN_ID
fin_sol_id,
--TRAN_DATE
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--CASH_TYPE
'RGLR',
--SRL_NUM
srl_num,
--BANK_ID
'01',
--ENTITY_CRE_FLG
'Y',
--DEL_FLG
' ',
--DENOM_VALUE
DENOM_VALUE,
--DENOM_TYPE
DENOM_TYPE,
--STRAP_BUNDLE_SIZE
STRAP_BUNDLE_SIZE,
--DENOM_COUNT
case when STRAP_BUNDLE_SIZE is null then to_char(DENOMINATIONCOUNT01) else to_char(mod(DENOMINATIONCOUNT01,STRAP_BUNDLE_SIZE)) end,
--DENOM_COUNT_PAYBACK
'0',
--STRAP_BUNDLE_COUNT
case when STRAP_BUNDLE_SIZE is null then '0' else to_char(DENOMINATIONCOUNT01-mod(DENOMINATIONCOUNT01,STRAP_BUNDLE_SIZE)) end,
--STRAP_BUNDLE_COUNT_PAYBACK
'0',
--LCHG_USER_ID
'SYSTEM',
--LCHG_TIME
GET_PARAM('EOD_DATE'),
--RCRE_USER_ID
'SYSTEM',
--RCRE_TIME
GET_PARAM('EOD_DATE'),
--TS_CNT
'0'
from all_final_trial_balance 
inner join c8pf on c8ccy=scccy
inner join denom_table a on scccy=CURRENCYCODE and scab=branchid
where gl_sub_head_code='10003' and scbal <> 0 and scab||scan||Scas not in ('0601800009414');
commit;
delete from tacd_o_table where DENOM_VALUE='XXX';
commit;
----------------hEAD OFFICE ACCOUNT -----------------
insert into tacd_o_table
select distinct 
--TELLER_ACCT
fin_acc_num,
--CRNCY_CODE
scccy,
--TRAN_ID
fin_sol_id,
--TRAN_DATE
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--CASH_TYPE
'RGLR',
--SRL_NUM
SRL_NUM,
--BANK_ID
'01',
--ENTITY_CRE_FLG
'Y',
--DEL_FLG
' ',
--DENOM_VALUE
DENOM_VALUE,
--DENOM_TYPE
DENOM_TYPE,
--STRAP_BUNDLE_SIZE
BUNDAL_SIZE,
--DENOM_COUNT
case when BUNDAL_SIZE is null then to_char(NO_OF_BUNDLES) else to_char(mod(NO_OF_BUNDLES,BUNDAL_SIZE)) end,
--DENOM_COUNT_PAYBACK
'0',
--STRAP_BUNDLE_COUNT
case when BUNDAL_SIZE is null then '0' else to_char(NO_OF_BUNDLES-mod(NO_OF_BUNDLES,BUNDAL_SIZE)) end,
--STRAP_BUNDLE_COUNT_PAYBACK
'0',
--LCHG_USER_ID
'SYSTEM',
--LCHG_TIME
GET_PARAM('EOD_DATE'),
--RCRE_USER_ID
'SYSTEM',
--RCRE_TIME
GET_PARAM('EOD_DATE'),
--TS_CNT
'0'
from all_final_trial_balance 
inner join c8pf on c8ccy=scccy
inner join denom a on EQ_GL_AC_NUMBER=SCAB||SCAN||SCAS
where scbal <> 0 and scab||scan||Scas in (
'0500800051414',
'0900800000826',
'0900800000840',
'0900800000978');
commit;
exit; 
