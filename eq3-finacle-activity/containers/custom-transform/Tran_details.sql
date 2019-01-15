
truncate table tran_details;

insert into tran_details
------------------------------CA,SA OD Balance---------------------------
select 
to_char(account_number) account_number,
gl_sub_headcode ,
schm_code,
to_char(dummy) scheme_type,
case when to_number(amount) < 0 then 'D' else 'C' end dr_cr_ind,
abs(to_number(amount)) amount,
'BAL' out_file,
leg_acc_num,
to_char(leg_acct_type)scact,
to_char(currency_code)currency_code,
to_char(service_outlet)service_outlet,
case when to_number(amount) < 0 then abs(to_number(amount)) else 0 end dr_bal,
case when to_number(amount) >= 0 then abs(to_number(amount)) else 0 end cr_bal,
TO_CHAR(trim(dummy))
from ac_balance_o_table
inner join map_acc on fin_acc_num = trim(account_number)
union all
select 
'',--to_char(TTUM1_MIGR_ACCT),
'52000' ,
schm_code,
to_char(dummy) scheme_type,
case when to_number(amount) < 0 then 'C' else 'D' end dr_cr_ind,
abs(to_number(amount)) amount,
'BAL' out_file,
leg_acc_num,
to_char(leg_acct_type),
to_char(currency_code)currency_code,
to_char(service_outlet)service_outlet,
case when to_number(amount) >= 0 then abs(to_number(amount)) else 0 end dr_bal,
case when to_number(amount) < 0 then abs(to_number(amount)) else 0 end cr_bal,
to_char('52000'||trim(dummy))
from ac_balance_o_table
inner join map_acc on fin_acc_num = trim(account_number)
-------------------------------------PCA---------------------
union all
select 
to_char(account_number) account_number,
gl_sub_headcode ,
schm_code,
to_char('PCA') scheme_type,
case when to_number(amount) > 0 then 'D' else 'C' end dr_cr_ind, ----intentionally added the sign otherwise because its debit balance but there is not part tran indicator
abs(to_number(amount)) amount,
'PCA' out_file,
leg_acc_num,
to_char(leg_acct_type)scact,
to_char(currency)currency_code,
to_char(fin_sol_id)service_outlet,
case when to_number(amount) > 0 then abs(to_number(amount)) else 0 end dr_bal,
case when to_number(amount) <= 0 then abs(to_number(amount)) else 0 end cr_bal,
TO_CHAR(trim('PCA'))
from 
(
select account_number,sum(ds_amt) amount from pca_disb group by account_number
)
inner join map_acc on fin_acc_num = trim(account_number)
union all
select 
'',--to_char(TTUM1_MIGR_ACCT),
'52000' ,
schm_code,
to_char('PCA') scheme_type,
case when to_number(amount) > 0 then 'C' else 'D' end dr_cr_ind,
abs(to_number(amount)) amount,
'PCA' out_file,
leg_acc_num,
to_char(leg_acct_type),
to_char(currency)currency_code,
to_char(fin_sol_id)service_outlet,
case when to_number(amount) <= 0 then abs(to_number(amount)) else 0 end dr_bal,
case when to_number(amount) > 0 then abs(to_number(amount)) else 0 end cr_bal,
to_char('52000'||trim('PCA'))
from 
(
select account_number,sum(ds_amt) amount from pca_disb group by account_number
)a
inner join map_acc on fin_acc_num = trim(account_number)
------------------------------Term deposit---------------------------------------------
union all
select 
to_char(trim(account_number)),
to_char(case when substr(trim(account_number),11,3) = 'TDA'  then '52000' else gl_sub_head_code end) gl_sub_head_code,
scheme_code,
to_char('TDA') scheme_type,
to_char(PART_TRANSACTION_TYPE) dr_cr_ind,
abs(to_number(amount)) amount,
'TDT' out_file,
leg_acc_num,
to_char(scact)scact,
to_char(currency_code)currency_code,
to_char(sol_code)service_outlet,
case when PART_TRANSACTION_TYPE = 'D' then abs(to_number(amount)) else 0 end dr_bal,
case when PART_TRANSACTION_TYPE = 'C' then abs(to_number(amount)) else 0 end cr_bal,
case when substr(trim(account_number),11,3) = 'TDA'  then '52000TDA' else 'TDA' END
from tdt_o_table
left join all_final_trial_balance on fin_acc_num = trim(account_number)
-------------------LAT---
union all
select 
to_char(trim(account_number)),
to_char(case when substr(trim(account_number),11,3) = 'LAA'  then '52000' else gl_sub_head_code end )gl_sub_head_code,
scheme_code,
to_char('LAA') scheme_type,
PART_TRAN_TYPE dr_cr_ind,
abs(to_number(amount)) amount,
'LAT' out_file,
leg_acc_num,
to_char(scact)scact,
to_char(currency)currency_code,
to_char(service_outlet)service_outlet,
case when PART_TRAN_TYPE = 'D' then ABS(to_number(amount)) else 0 end dr_bal,
case when PART_TRAN_TYPE = 'C' then ABS(to_number(amount)) else 0 end cr_bal,
case when substr(trim(account_number),11,3) = 'LAA'  then '52000LAA' else 'LAA' END
from lat_o_table
left join all_final_trial_balance on fin_acc_num = trim(account_number)
union all
select 
to_char(trim(account_number)),
to_char(case when substr(trim(account_number),11,3) = 'LAA'  then '52000' else gl_sub_head_code end) gl_sub_head_code,
scheme_code,
to_char('LAA') scheme_type,
PART_TRAN_TYPE dr_cr_ind,
abs(to_number(amount)) amount,
'LAT1' out_file,
leg_acc_num,
to_char(scact)scact,
to_char(currency)currency_code,
to_char(service_outlet)service_outlet,
case when PART_TRAN_TYPE = 'D' then abs(to_number(amount)) else 0 end dr_bal,
case when PART_TRAN_TYPE = 'C' then abs(to_number(amount)) else 0 end cr_bal,
case when substr(trim(account_number),11,3) = 'LAA'  then '52000LAA' else 'LAA' END
from lat1_o_table
left join all_final_trial_balance on fin_acc_num = trim(account_number)
--------------------------------------CLA--------------------------------------
union all
select 
to_char(trim(acc_num)),
to_char(case when substr(trim(acc_num),11,3) = 'CLA'  then '52000' else gl_sub_headcode end) gl_sub_head_code,
schm_code,
to_char('CLA') scheme_type,
to_char(PART_TRAN_TYPE) dr_cr_ind,
abs(to_number(trans_amt)) amount,
'CLA' out_file,
'',
leg_acct_type,
to_char(curr)currency_code,
to_char(sol_id)service_outlet,
case when PART_TRAN_TYPE = 'D' then abs(to_number(trans_amt)) else 0 end dr_bal,
case when PART_TRAN_TYPE = 'C' then abs(to_number(trans_amt)) else 0 end cr_bal,
case when substr(trim(ACC_NUM),11,3) = 'CLA'  then '52000CLA' else 'CLA' END
from cl007_o_table
left join map_acc on fin_acc_num = trim(acc_num)
-----------------------TTUM1-------------------------------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM1',
'',
'',
currency_code,
substr(account_number,1,3),
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum1_o_table
------------TTUM2-------------------------------
union all
select 
trim(account_number),
--gam.gl_sub_head_code,
substr(account_number,6,5),
gam.schm_code,
gam.schm_type,
part_tran_type,
to_number(transaction_amount),
'TTUM2',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum2_o_table
left join tbaadm.gam on foracid = trim(account_number)
------------TTUM2_set2-------------------------------
union all
select 
trim(account_number),
--gam.gl_sub_head_code,
substr(account_number,6,5),
gam.schm_code,
gam.schm_type,
part_tran_type,
to_number(transaction_amount),
'TTUM2set2',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from TTUM2_O_TABLE_SET2
left join tbaadm.gam on foracid = trim(account_number)
------------TTUM3-------------------------------
union all
select 
trim(account_number),
case when substr(trim(account_number),6,5) = '52000'  then '52000' else gl_sub_head_code end gl_sub_head_code,
scheme_code,
scheme_type,
part_tran_type,
to_number(transaction_amount),
'TTUM3',
'',
'',
currency_code,
fin_sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
case when substr(trim(account_number),6,5) = '52000' then substr(trim(account_number),6,8) else scheme_type end 
from ttum3_o_table
left join all_final_trial_balance on fin_acc_num = trim(account_number)
------------TTUM4-------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM4',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum4_o_table
left join tbaadm.gam on foracid = trim(account_number)
-----------------------------TRY-----------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM4_TRY',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum4_try_o_table
left join tbaadm.gam on foracid = trim(account_number)
------------TTUM5-------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM5',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum5_o_table
left join tbaadm.gam on foracid = trim(account_number)
------------TTUM6-------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM6',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum6_o_table
left join tbaadm.gam on foracid = trim(account_number)
------------TTUM7-------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM7',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum7_o_table
left join tbaadm.gam on foracid = trim(account_number)
------------RLTL-------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'RLTL',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttumrltl_o_table
left join tbaadm.gam on foracid = trim(account_number);

commit;


 
