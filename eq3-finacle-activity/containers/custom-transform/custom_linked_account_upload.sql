
-- File Name		: custom_linked_account_upload.sql 
-- File Created for	: Upload file for linked account details
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 26-08-2017
-------------------------------------------------------------------
-------------------------------------------------------------------
truncate table LATU_o_table;
insert into LATU_o_table
select
--Account_Number
rpad(ma1.fin_acc_num,16,' '), 
--Linked_Account_Number
 rpad(ma2.fin_acc_num,16,' '),
--Link_Type
lpad(' ',5,' '),
--Linked_Amount
rpad(abs(to_number(otdla))/POWER(10,c8pf.C8CED),17,' '),
--Linked_Amount_Currency
rpad(ma2.currency,3,' '),
--Remarks
lpad(' ',60,' ')
from map_acc ma1 
left join map_acc ma2 on ma1.EXTERNAL_ACC=ma2.EXTERNAL_ACC
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = ma2.leg_acc_num
inner join c8pf on c8ccy = otccy 
where ma1.schm_type='CLA' and ma1.schm_code not in ('BDT','LAC','CLM') and ma1.fin_acc_num<>ma2.fin_acc_num;
commit;
exit; 
