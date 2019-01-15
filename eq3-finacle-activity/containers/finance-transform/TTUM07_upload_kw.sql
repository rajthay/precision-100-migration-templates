
-- File Name        : TTUM7
-- File Created for    : Upload file for Office accounts
-- Created By        : Kumaresan
-- Client            : ABK
-- Created On        : 03-06-2011
-------------------------------------------------------------------
truncate table TTUM7_O_TABLE;
insert into TTUM7_O_TABLE
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(new_fin_sol_id,8,' '),
--Part Tran Type
   case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 SOL REV Migration',30,' '),
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
select new_fin_sol_id,scccy,new_fin_sol_id||substr(ttum1_migr_acct,4,13) ttum1_migr_acct, scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where fin_sol_id<>new_fin_sol_id and scbal<>0
union all
select fin_sol_id,scccy,ttum1_migr_acct, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where fin_sol_id<>new_fin_sol_id and scbal<>0
);
commit;
-----------------------------interest_payable  customer accounts difference sol added on 04-06-2017 by kumar-----------------------------------
/*insert into TTUM7_O_TABLE
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(fin_sol_id,8,' '),----------changed for m4   
   --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'D'
         else 'C'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('TTUM7 SOL REV INT RECV PAY DR CR ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((INTEREST_FCY)),17,' '),
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
from(
select '603' FIN_SOL_ID,scccy,'603'||substr(ttum1_migr_acct,4,13) ttum1_migr_acct,interest_fcy
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL
union all
select MAP_SOL.FIN_SOL_ID,scccy,ttum1_migr_acct ttum1_migr_acct,interest_fcy
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)*-1interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL);
commit;
-----------------------------interest_payable  customer accounts difference sol added on 04-06-2017 by kumar-----------------------------------
insert into TTUM7_O_TABLE 
select 
--Account Number
IR_IP_ACCT,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad('603',8,' '),----changed for mock4kw
    --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('TTUM7 SOL REV INT RECV PAY DR CR ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((INTEREST_FCY)),17,' '),
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
select '603' fin_sol_id,TO_CHAR (
'603' 
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)IR_IP_ACCT,scccy,INTEREST_FCY
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL
union all
select MAP_SOL.FIN_SOL_ID fin_sol_id,TO_CHAR (
MAP_SOL.FIN_SOL_ID
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)IR_IP_ACCT,scccy,INTEREST_FCY
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)*-1interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL
);
commit;*/
---Trade finance sol Reversal block--
insert into TTUM7_O_TABLE
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
    rpad('TTUM7 SOL REV Migration',30,' '),
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
select case when substr(trim(FIN_ACC_NUM),6,5)  in('70004','70011') then  '900'
         when substr(trim(FIN_ACC_NUM),6,5)  in('70000','70001','70002','70003','70010','70020',
         '70021','70022','70030','70031','70040','70041','70042','70043','70099') then  '700'
         when substr(FIN_ACC_NUM,1,3) ='700' then  '700'
         else fin_sol_id end fin_sol_id,  scccy, case when substr(trim(FIN_ACC_NUM),6,5)  in('70004','70011') then  trim(FIN_ACC_NUM)
         when substr(trim(FIN_ACC_NUM),6,5)  in('70000','70001','70002','70003','70010','70020',
         '70021','70022','70030','70031','70040','70041','70042','70043','70099') then  trim(FIN_ACC_NUM)
         else fin_acc_num end fin_acc_num,scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scbal<>0 and 
 SCHEME_TYPE='OAB'  and leg_acc_num  in(select leg_acc_num from tfs_sol_map_acc)
union all
select fin_sol_id,scccy,TTUM1_MIGR_ACCT, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scbal<>0
and SCHEME_TYPE='OAB' and leg_acc_num  in(select leg_acc_num from tfs_sol_map_acc)
);    
commit;
---Trade finance sol Reversal block Added on 22-08-2017 as per  Sanjay mail on Mon 8/14/2017 5:08 PM
/*insert into TTUM7_O_TABLE
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
    rpad('TTUM7 SOL REV Migration',30,' '),
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
select case when scan in(
'900050','900055','900060','900075','900090','900190','901050','901075',
'901090','903290','903590','907000','915127','915128','915129','915130',
'915205','915210','915228','915229','915230','970800') then '700'
when scan='913500' then '900' end fin_sol_id,scccy,
case when  scan in(
'900050','900055','900060','900075','900090','900190','901050','901075',
'901090','903290','903590','907000','915127','915128','915129','915130',
'915205','915210','915228','915229','915230','970800') then  '700'||substr(trim(FIN_ACC_NUM),4,13)
when scan='913500' then '900'||substr(trim(FIN_ACC_NUM),4,13) end fin_acc_num,scbal/power(10,c8ced) acbal      
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scbal<>0 and 
SCHEME_TYPE='OAB' and scan in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230','970800')
union all
select fin_sol_id,scccy,TTUM1_MIGR_ACCT, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scbal<>0
and SCHEME_TYPE='OAB' and scan in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230','970800')
);*/    
commit;
--As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar--
insert into TTUM7_O_TABLE
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
    rpad('TTUM7 SOL REV Migration',30,' '),
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
from (
select case when new_fin_sol_id<>'005' then
'603' else
new_fin_sol_id end fin_sol_id  ,scccy,(case when new_fin_sol_id<>'005' then
'603' else
new_fin_sol_id end)||substr(fin_acc_num,4,13) fin_acc_num, scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scbal<>0
and scab||scan||scas  in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840')
union all
select fin_sol_id,scccy,ttum1_migr_acct, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scab||scan||scas  in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840')
and scbal<>0);    
commit;
--Overdue interest TTUM transaction added on 29-06-2017 by Kumar--
/*insert into TTUM7_O_TABLE
select 
--Account Number
    FIN_ACC_NUM,
--Currency Code 
    rpad(currency,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
   Part_Tran_Type,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 Overdue interest Migration',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(currency,3,' '),
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
from (
select fin_sol_id,to_char(currency) currency, case when trim(NPL) in('20','50')
then to_char(map_acc.fin_sol_id||cnc.CRNCY_ALIAS_NUM||PAST_DUE_INT_COLL_BACID)
else to_char(map_acc.fin_sol_id||cnc.CRNCY_ALIAS_NUM||PRINCIPAL_LOSSLINE_BACID) end fin_Acc_num,to_number(TOTAL_INTEREST_PAST_DUE) acbal,
'D' Part_Tran_Type 
from iis 
left join map_Acc on DEL_REF=substr(leg_acc_num,8,15) and trim(ACC_NO)=fin_cif_id
left join (select * from tbaadm.gsp where bank_id=get_param('BANK_ID'))gss on gss.schm_code=MAP_ACC.SCHM_CODE
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on cnc.CRNCY_CODE=map_acc.currency
where leg_acc_num is   not null and trim(PAST_DUE_INT_COLL_BACID) is not null and triM(PRINCIPAL_LOSSLINE_BACID) is not null
union all
select '003','KWD','0030152000013',sum(to_number(TOTAL_INTEREST_PAST_DUE)),'C'
from iis 
left join map_Acc on DEL_REF=substr(leg_acc_num,8,15) and trim(ACC_NO)=fin_cif_id
left join (select * from tbaadm.gsp where bank_id=get_param('BANK_ID'))gss on gss.schm_code=MAP_ACC.SCHM_CODE
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on cnc.CRNCY_CODE=map_acc.currency
where leg_acc_num is   not null and trim(PAST_DUE_INT_COLL_BACID) is not null and triM(PRINCIPAL_LOSSLINE_BACID) is not null
group by '003','KWD','0030152000013','C'
);
commit;*/
--TRY MIGR SOL and account type merge  changed on 09-06-2017 by Kumar--
/*insert into TTUM7_O_TABLE
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(new_fin_sol_id,8,' '),
--Part Tran Type
   case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 TRY SOL REV Migration',30,' '),
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
select '005' new_fin_sol_id,scccy,'005'||substr(TTUM1_MIGR_ACCT,4,2)||'520000V6' ttum1_migr_acct, scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scbal<>0 and scact in('VC','V6') 
union all
select fin_sol_id,scccy,ttum1_migr_acct, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scbal<>0 and scact in('VC','V6') 
);
commit;*/
--TRY MIGR SOL and account type merge  changed on 09-06-2017 by Kumar--
/*insert into TTUM7_O_TABLE
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(new_fin_sol_id,8,' '),
--Part Tran Type
   case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 TRY SOL REV Migration',30,' '),
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
select '005' new_fin_sol_id,scccy,'005'||substr(TTUM1_MIGR_ACCT,4,2)||'520000W6' ttum1_migr_acct, scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scbal<>0 and scact in('W5','W6') 
union all
select fin_sol_id,scccy,ttum1_migr_acct, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scbal<>0 and scact in('W5','W6') 
);
commit;*/
--TRY MIGR SOL and account type merge  changed on 09-06-2017 by Kumar--
insert into TTUM7_O_TABLE
select 
--Account Number
    fin_acc_num,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(new_fin_sol_id,8,' '),
--Part Tran Type
   case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 TRY SOL REV Migration',30,' '),
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
select '005' new_fin_sol_id,scccy,fin_acc_num , scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scbal<>0 and scact in('YX') 
union all
select map_sol.fin_sol_id,scccy,ttum1_migr_acct, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
left join map_sol on br_code=scab
where scbal<>0 and scact in('YX')
);
commit;
--- Advance interest balance transfer ttum added on 20-07-2017--
insert into ttum7_o_table
select 
--Account Number
    FIN_ACC_NUM,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(NEW_FIN_SOL_ID,8,' '),
--Part Tran Type
   Part_Tran_Type,
--Transaction Amount
    lpad( abs(acbal),17,' '),
--Transaction Particular
    rpad('TTUM7 Advance interest Migration',30,' '),
    rpad(' ',5,' '), 
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(acbal),17,' '),
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
from (
select new_fin_sol_id,scccy,fin_acc_num,sum(acbal)  acbal, Part_Tran_Type from (
select   new_fin_sol_id,scccy,NEW_FIN_SOL_ID||cnc.CRNCY_ALIAS_NUM||gsp.ADVANCE_INT_BACID fin_acc_num,
abs((nvl(to_number(V4AIM1),0)-nvl(to_number(V5AM1),0)) / power(10,c8ced)) acbal,'C' Part_Tran_Type  
from all_final_trial_balance
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=leg_acc_num
inner join c8pf on c8ccy = v5ccy
left join v4pf on trim(v4brnm)||trim(v4dlp)||trim(v4dlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
left join (select * from tbaadm.gsp where bank_id=get_param('BANK_ID'))gsp on gsp.schm_code=scheme_code
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on cnc.CRNCY_CODE=scccy
where  DEAL_TYPE iN('LDA','BDT') and scbaL<>0 and (nvl(to_number(V4AIM1),0)-nvl(to_number(V5AM1),0))<>0)
group by new_fin_sol_id,scccy,fin_acc_num,Part_Tran_Type
union  all
select fin_sol_id,scccy,ttum1_migr_acct,sum(scbal/power(10,c8ced))acbal,'D'Part_Tran_Type from all_final_trial_balance
inner join c8pf on c8ccy = scccy 
where scact='YU' and scbal<>0
group by fin_sol_id,scccy,ttum1_migr_acct,'D' 
having sum(scbal/power(10,c8ced))<>0
);
commit;
--update ttum7_o_table  set TRANSACTION_AMOUNT=lpad(to_number(TRANSACTION_AMOUNT)-111.364,17,' '),
--REFERENCE_AMOUNT=lpad(to_number(REFERENCE_AMOUNT)-111.364,17,' ')  where trim(account_number)='60101520000YU';
--commit;-- this update for 10 Aug advance interst scabl balance
update ttum7_o_table  set TRANSACTION_AMOUNT=lpad(to_number(TRANSACTION_AMOUNT)-0.001,17,' '),
REFERENCE_AMOUNT=lpad(to_number(REFERENCE_AMOUNT)-0.001,17,' ')  where trim(account_number)='60101520000YU';
commit;-- this update for 30 JUN advance interst scabl balance
exit;