
truncate table tach_o_table;
insert into tach_o_table
select distinct 
--TELLER_ACCT
fin_acc_num,
--CRNCY_CODE
scccy,
--SOL_ID
fin_sol_id,
--TRAN_ID
null,
--TRAN_DATE
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BANK_ID
'01',
--STATUS
'O',
--ENTITY_CRE_FLG
'Y',
--DEL_FLG
' ',
--VAULT_BAL
sum(scbal/power(10,c8ced)),
--REG_AMT
'0',
--BAIT_AMT
'0',
--MUTILATED_AMT
'0',
--TOTAL_CASH_AMT
sum(scbal/power(10,c8ced)),
--PHYSICAL_CASH_AMT
'0',
--EXCESS_CASH
'0',
--SHORT_CASH
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
where gl_sub_head_code='10003' and scbal <> 0
group by fin_acc_num,scccy,fin_sol_id;
commit;
---------------HEAD OFFICE ACCOUNT-----------
insert into tach_o_table
select distinct 
--TELLER_ACCT
fin_acc_num,
--CRNCY_CODE
scccy,
--SOL_ID
fin_sol_id,
--TRAN_ID
null,
--TRAN_DATE
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BANK_ID
'01',
--STATUS
'O',
--ENTITY_CRE_FLG
'Y',
--DEL_FLG
' ',
--VAULT_BAL
sum(scbal/power(10,c8ced)),
--REG_AMT
'0',
--BAIT_AMT
'0',
--MUTILATED_AMT
'0',
--TOTAL_CASH_AMT
sum(scbal/power(10,c8ced)),
--PHYSICAL_CASH_AMT
'0',
--EXCESS_CASH
'0',
--SHORT_CASH
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
where scbal <> 0 AND TRIM(SCAB||SCAN||SCAS) IN  (
'0500800051414',
'0900800000826',
'0900800000840',
'0900800000978')
group by fin_acc_num,scccy,fin_sol_id;
commit;
exit;
 
