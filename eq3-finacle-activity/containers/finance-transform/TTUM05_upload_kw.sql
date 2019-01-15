
-- File Name           : TTUM5
-- File Created for    : Upload file for Office accounts
-- Created By          : Kumaresan.B
-- Client               : EIB
-- Created On          : 19-01-2015
-------------------------------------------------------------------
---interest receivable/Payable customer accounts Same sol added on 04-06-2017 by kumar
drop table int_recv_pay_balance_trfr;
create table int_recv_pay_balance_trfr
as
SELECT 
s5ab,contra_basic,c8ccyn,S5ACT, INTEREST_FCY,b.leg_acc_num,b.scheme_code,b.scheme_type, int_paid_bacid,int_coll_bacid,int_pandl_bacid_cr,int_pandl_bacid_dr 
FROM ACCT_WISE_INT_RECV_PAY_MAP a
inner join (select * from all_final_trial_balance where fin_sol_id=new_fin_sol_id)b on b.leg_acc_num = BRN||TRIM(a.DEAL_TYPE)||TRIM(a.DEAL_REF)
left join (select schm_code,int_paid_bacid,int_coll_bacid,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss 
on gss.schm_code = b.scheme_code
where INTEREST_FCY <> 0; 
---interest receivable/Payable customer accounts difference sol added on 04-06-2017 by kumar
drop table int_recv_pay_bal_trfr_dif_sol;
create table int_recv_pay_bal_trfr_dif_sol
as
SELECT 
s5ab,contra_basic,c8ccyn,S5ACT, INTEREST_FCY,b.leg_acc_num,b.scheme_code,b.scheme_type, int_paid_bacid,int_coll_bacid,int_pandl_bacid_cr,int_pandl_bacid_dr 
FROM ACCT_WISE_INT_RECV_PAY_MAP a
inner join (select * from all_final_trial_balance where fin_sol_id<>new_fin_sol_id)b on b.leg_acc_num = BRN||TRIM(a.DEAL_TYPE)||TRIM(a.DEAL_REF)
left join (select schm_code,int_paid_bacid,int_coll_bacid,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss 
on gss.schm_code = b.scheme_code
where INTEREST_FCY <> 0; 
---interest receivable/Payable account where int miss match customer accounts same sol added on 04-06-2017 by kumar
drop table account_where_int_match;
create table account_where_int_match
as
select scab brn,scan basic,scas suf,scbal/power(10,c8ced)bal,interest from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
left join
(
select s5ab,contra_basic,c8ccyn,sum(interest_fcy)interest from int_recv_pay_balance_trfr
group by s5ab,contra_basic,c8ccyn
)b
on scab||scan||scas = s5ab||contra_basic||c8ccyn
inner join c8pf on c8ccy = scccy;
---interest receivable/Payable account where int miss match customer accounts difference sol added on 04-06-2017 by kumar
drop table acct_where_int_match_dif_sol;
create table acct_where_int_match_dif_sol
as
select scab brn,scan basic,scas suf,scbal/power(10,c8ced)bal,interest from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
left join
(
select s5ab,contra_basic,c8ccyn,sum(interest_fcy)interest from int_recv_pay_bal_trfr_dif_sol
group by s5ab,contra_basic,c8ccyn
)b
on scab||scan||scas = s5ab||contra_basic||c8ccyn
inner join c8pf on c8ccy = scccy;
-----------------------------interest_payable_diff  customer accounts same sol added on 04-06-2017 by kumar-----------------------------------
drop table interest_payable_diff;
create table interest_payable_diff as
select scab,scan,scas,ttum1_migr_acct,scsuma/power(10,c8ced)scsuma,nvl(interest,0)interest, scbal/power(10,c8ced) scbal, (scbal+scsuma)/power(10,c8ced) -nvl(interest,0) diff_amount,
fin_sol_id||CRNCY_ALIAS_NUM||'29398000' fin_acc_num,scccy,fin_sol_id
from scpf a
inner join
(select scab brn,scan basic,scas suf,scbal/power(10,c8ced)bal,interest,ttum1_migr_acct,fin_sol_id,CRNCY_ALIAS_NUM from
(
select * from all_final_trial_balance 
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
left join
(
select s5ab,contra_basic,c8ccyn,sum(interest_fcy)interest from int_recv_pay_balance_trfr
group by s5ab,contra_basic,c8ccyn
)b
on scab||scan||scas = s5ab||contra_basic||c8ccyn
inner join c8pf on c8ccy = scccy
where scbal/power(10,c8ced) <> nvl(interest,0)
)b
on brn||basic||suf = scab||scan||scas
inner join c8pf on c8ccy = scccy
where a.scbal <> 0 and nvl(interest,0) = scsuma/power(10,c8ced);
--where scbal/power(10,c8ced) = nvl(interest,0);  --- as per analysis interest receivable/payable from scsuma migrated and scbal balance(ie. Creadited in P&L) not migrated. As per Karthik sir confirmation commented on 10-04-2017.
-----------------------------interest_payable_diff_sol_dif  customer accounts difference sol added on 04-06-2017 by kumar-----------------------------------
drop table interest_payable_diff_sol_dif;
create table interest_payable_diff_sol_dif as
select scab,scan,scas,ttum1_migr_acct,scsuma/power(10,c8ced)scsuma,nvl(interest,0)interest, scbal/power(10,c8ced) scbal, (scbal+scsuma)/power(10,c8ced) -nvl(interest,0) diff_amount,
fin_sol_id||CRNCY_ALIAS_NUM||'29398000' fin_acc_num,scccy,fin_sol_id
from scpf a
inner join
(select scab brn,scan basic,scas suf,scbal/power(10,c8ced)bal,interest,ttum1_migr_acct,fin_sol_id,CRNCY_ALIAS_NUM from
(
select * from all_final_trial_balance 
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
left join
(
select s5ab,contra_basic,c8ccyn,sum(interest_fcy)interest from int_recv_pay_bal_trfr_dif_sol
group by s5ab,contra_basic,c8ccyn
)b
on scab||scan||scas = s5ab||contra_basic||c8ccyn
inner join c8pf on c8ccy = scccy
where scbal/power(10,c8ced) <> nvl(interest,0)
)b
on brn||basic||suf = scab||scan||scas
inner join c8pf on c8ccy = scccy
where a.scbal <> 0 and nvl(interest,0) = scsuma/power(10,c8ced);
--where scbal/power(10,c8ced) = nvl(interest,0);  --- as per analysis interest receivable/payable from scsuma migrated and scbal balance(ie. Creadited in P&L) not migrated. As per Karthik sir confirmation commented on 10-04-2017.
-----------------------------interest_payable  customer accounts same sol added on 04-06-2017 by kumar-----------------------------------
truncate table TTUM5_O_TABLE ;
insert into TTUM5_O_TABLE 
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(MAP_SOL.FIN_SOL_ID,8,' '),----------changed for m4   
   --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'D'
         else 'C'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR ENTRY',30,' '),
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
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_balance_trfr group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_balance_trfr on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join account_where_int_match on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL;
COMMIT;
-----------------------------interest_payable  customer accounts difference sol added on 04-06-2017 by kumar-----------------------------------
insert into TTUM5_O_TABLE
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(map_sol.fin_sol_id,8,' '),----------changed for m4   
   --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'D'
         else 'C'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR ENTRY',30,' '),
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
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL;
commit;
-----------------------------interest_payable  customer accounts same sol added on 04-06-2017 by kumar-----------------------------------
insert into TTUM5_O_TABLE 
select 
--Account Number
TO_CHAR (
MAP_SOL.FIN_SOL_ID 
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)IR_IP_ACCT,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(MAP_SOL.FIN_SOL_ID,8,' '),----changed for mock4kw
    --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR ENTRY',30,' '),
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
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_balance_trfr group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_balance_trfr on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join account_where_int_match on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL;
COMMIT;
-----------------------------interest_payable  customer accounts difference sol added on 04-06-2017 by kumar-----------------------------------
insert into TTUM5_O_TABLE 
select 
--Account Number
TO_CHAR (
'603'
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)IR_IP_ACCT,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    --rpad(map_sol.fin_sol_id,8,' '),
	rpad('603',8,' '),
    --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR ENTRY',30,' '),
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
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL;
commit;
/*--------Interest receivable/Payable Difference -------------------------------- commented on 17-04-2017 as per mock 3b observation. difference between scbal+scsuma-interest block
insert into TTUM5_O_TABLE 
select 
--Account Number
    fin_acc_num,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (diff_amount) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((diff_amount)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR DIFFERENCE ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((diff_amount)),17,' '),
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
from interest_payable_diff;
commit;
--------Interest receivable/Payable Difference Contra Entry--------------------------------
insert into TTUM5_O_TABLE 
select 
--Account Number
    TTUM1_MIGR_ACCT,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (diff_amount) > 0 then 'D'
         else 'C'
    end,
--Transaction Amount
    lpad(abs((diff_amount)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR DIFFERENCE ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((diff_amount)),17,' '),
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
from interest_payable_diff;
commit;*/
exit; 
