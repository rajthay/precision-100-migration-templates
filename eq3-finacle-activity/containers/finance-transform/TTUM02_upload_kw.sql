
-- File Name		: TTUM2
-- File Created for	: Upload file for Office accounts
-- Created By		: Prashant
-- Client		: ENBD
-- Created On		: 01-11-2011
-------------------------------------------------------------------
truncate table TTUM2_O_TABLE ;
truncate table TTUM2_O_TABLE_SET2;
insert into TTUM2_O_TABLE 
select 
--Account Number
	FIN_ACC_NUM,	
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||customer_account,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from 
(
select  fin_sol_id,  scccy,  fin_acc_num,scbal/power(10,c8ced) acbal,case when scact='MS' then to_char(trim(neean))
else to_char('') end customer_account
from all_final_trial_balance
left join c8pf on c8ccy = scccy
left join nepf on neab||nean||neas=scab||scan||scas
where scheme_type = 'OAB' and fin_acc_num is not null and scbal <> 0
and fin_acc_num not like '%NOT%' and fin_acc_num not like '%FIN_TRES%' and length(fin_acc_num) = 13 
and scact not in ('3A','3B','3C','3D','3E','3F','3G','3H','3I','3J','3K','3L','3W','3X','3Y','3Z','4A','RL','TL','YX')
and scab||scan||scas not in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840') --As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar
and leg_acc_num not in(select leg_acc_num from tfs_sol_map_acc)
--and scan not in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
--'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230',
--'970800')---TFA sol changes GL's ignoreing in TTUM2 and passing in TTUM7 changed on 22-08-2017 by kumar 
union all
select fin_sol_id,scccy,ttum1_migr_acct, sum((scbal/power(10,c8ced)))*-1 acbal,''
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scheme_type = 'OAB' and fin_acc_num is not null and scbal <> 0 
and fin_acc_num not like '%NOT%' and fin_acc_num not like '%FIN_TRES%' and length(fin_acc_num) = 13
and scact not in ('3A','3B','3C','3D','3E','3F','3G','3H','3I','3J','3K','3L','3W','3X','3Y','3Z','4A','RL','TL','YX') 
and scab||scan||scas not in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840') --As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar
and leg_acc_num not in(select leg_acc_num from tfs_sol_map_acc)
--and scan not in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
--'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230',
--'970800')---TFA sol changes GL's ignoreing in TTUM2 and passing in TTUM7 changed on 22-08-2017 by kumar 
group by fin_sol_id,scccy,ttum1_migr_acct
)  where fin_sol_id not in('900','600','005','015','003','603');
COMMIT;
--Divdend cheques for 2013
insert into TTUM2_O_TABLE_SET2
select 
--Account Number
    '6030148100035',
--Currency Code 
    rpad(trim(CURRENCY),3,' '),
--SOLID
    rpad('603',8,' '),
--Part Tran Type
    PART_TRAN_TYPE,
--Transaction Amount
    lpad(AMOUNT,17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||CHQ_NO,30,' '),
    rpad(' ',5,' '),
    rpad(CHQ_NO,20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(AMOUNT,17,' '),
    rpad(trim(CURRENCY),3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(CHQ_NO,16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from kcc_chq_2013;
commit;
--Divdend cheques for 2014
insert into TTUM2_O_TABLE_SET2
select 
--Account Number
    '6030148100036',
--Currency Code 
    rpad(trim(CURRENCY),3,' '),
--SOLID
    rpad('603',8,' '),
--Part Tran Type
    PART_TRAN_TYPE,
--Transaction Amount
    lpad(AMOUNT,17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||CHQ_NO,30,' '),
    rpad(' ',5,' '),
    rpad(CHQ_NO,20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(AMOUNT,17,' '),
    rpad(trim(CURRENCY),3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(CHQ_NO,16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from kcc_chq_2014;
commit;
--Divdend cheques for 2015
insert into TTUM2_O_TABLE_SET2
select 
--Account Number
    '6030148100037',
--Currency Code 
    rpad(trim(CURRENCY),3,' '),
--SOLID
    rpad('603',8,' '),
--Part Tran Type
    PART_TRAN_TYPE,
--Transaction Amount
    lpad(AMOUNT,17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||CHQ_NO,30,' '),
    rpad(' ',5,' '),
    rpad(CHQ_NO,20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(AMOUNT,17,' '),
    rpad(trim(CURRENCY),3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(CHQ_NO,16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from kcc_chq_2015;
commit;
--Divdend cheques for 2016
insert into TTUM2_O_TABLE_SET2
select 
--Account Number
    '6030148100038',
--Currency Code 
    rpad(trim(CURRENCY),3,' '),
--SOLID
    rpad('603',8,' '),
--Part Tran Type
    PART_TRAN_TYPE,
--Transaction Amount
    lpad(AMOUNT,17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||CHQ_NO,30,' '),
    rpad(' ',5,' '),
    rpad(CHQ_NO,20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(AMOUNT,17,' '),
    rpad(trim(CURRENCY),3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(CHQ_NO,16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from kcc_chq_2016;
commit;
insert into TTUM2_O_TABLE_SET2 
select 
--Account Number
	--case when trim(CURRENCY)='KWD' then '9000148602000'
	--when trim(CURRENCY)='USD' then '9000448602000' end,--As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar
	case when trim(CURRENCY)='KWD' then '9000148602001'
	when trim(CURRENCY)='USD' then '9000448602001' end,
--Currency Code 
    rpad(trim(CURRENCY),3,' '),
--SOLID
    rpad('900',8,' '),
--Part Tran Type
    case when (AMOUNT) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(regexp_replace(abs(AMOUNT),'[,]',''),17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||CHEQUE_NO,30,' '),
    rpad(' ',5,' '),
    rpad(CHEQUE_NO,20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(regexp_replace(abs(AMOUNT),'[,]',''),17,' '),
    rpad(trim(currency),3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(CHEQUE_NO,16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from certified_cheques;
commit;
insert into TTUM2_O_TABLE_SET2 
select 
--Account Number
	FIN_ACC_NUM,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||customer_account,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from 
(
select  fin_sol_id,  scccy,  fin_acc_num,scbal/power(10,c8ced) acbal,case when scact='MS' then to_char(trim(neean))
else to_char('') end customer_account
from all_final_trial_balance
left join c8pf on c8ccy = scccy
left join nepf on neab||nean||neas=scab||scan||scas
where scheme_type = 'OAB' and fin_acc_num is not null and scbal <> 0
and fin_acc_num not like '%NOT%' and fin_acc_num not like '%FIN_TRES%' and length(fin_acc_num) = 13 
and scact not in ('3A','3B','3C','3D','3E','3F','3G','3H','3I','3J','3K','3L','3W','3X','3Y','3Z','4A','RL','TL','YX') 
and scab||scan||scas not in ('0900802525414','0900802525840')
and scab||scan||scas not in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840') --As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar
and scab||scan||scas not in('0600802616414','0600802617414','0600802618414','0600802619414')--DIVIDEND cheques execlude changed on 29-09-2017
and leg_acc_num not in(select leg_acc_num from tfs_sol_map_acc)
--and scan not in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
--'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230',
--'970800')---TFA sol changes GL's ignoreing in TTUM2 and passing in TTUM7 changed on 22-08-2017 by kumar 
union all
select fin_sol_id,scccy,ttum1_migr_acct, sum((scbal/power(10,c8ced)))*-1 acbal,''
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scheme_type = 'OAB' and fin_acc_num is not null and scbal <> 0 
and fin_acc_num not like '%NOT%' and fin_acc_num not like '%FIN_TRES%' and length(fin_acc_num) = 13
and scact not in ('3A','3B','3C','3D','3E','3F','3G','3H','3I','3J','3K','3L','3W','3X','3Y','3Z','4A','RL','TL','YX')
and scab||scan||scas not in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840') --As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar 
and leg_acc_num not in(select leg_acc_num from tfs_sol_map_acc)
--and scan not in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
--'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230',
--'970800')---TFA sol changes GL's ignoreing in TTUM2 and passing in TTUM7 changed on 22-08-2017 by kumar 
group by fin_sol_id,scccy,ttum1_migr_acct
)  where fin_sol_id  in('900','600','005','015','003','603');
commit;
delete from TTUM2_O_TABLE  where trim(TRANSACTION_AMOUNT)= 0;
commit;
delete from TTUM2_O_TABLE_SET2 where trim(TRANSACTION_AMOUNT)= 0;
commit;
exit; 
