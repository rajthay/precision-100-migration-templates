
-- File Name		: TTUM1
-- File Created for	: Upload file for sum of all ledger balance currency wise, sol wise and scheme type wise
-- Created By		: Prashant
-- Client			: ENBD
-- Created On		: 01-11-2011
-------------------------------------------------------------------
--drop table all_final_trial_balance;
--create table all_final_trial_balance as select * from final_trial_balance;
truncate table TTUM1_O_TABLE ;
insert into TTUM1_O_TABLE 
select 
--Account Number
    rpad(ttum1_migr_acct,16,' '),
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when acbal > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs(acbal),17,' '),
--Transaction Particular
    rpad('TTUM1 Migration upload',30,' '),
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
from
(
select fin_sol_id,scccy,ttum1_migr_acct,sum(acbal) acbal
from
(
select a.scab,fin_sol_id,ttum1_migr_acct,scccy,(scbal+scsuma)/power(10,c8ced) acbal
from scpf a
inner join
(
select distinct scab,scan,scas,ttum1_migr_acct from all_final_trial_balance
---Every mock ensure to check one account (scab,scan,scas does not flow across multiple migr accounts. If flows them this logic of ttum1 will not work)
) b
on a.scab = b.scab and a.scan = b.scan and a.scas = b.scas
inner join c8pf on c8ccy = scccy
left join map_sol on a.scab = br_code
)
group by fin_sol_id,scccy,ttum1_migr_acct
having sum(acbal) <> 0
)X;
      COMMIT;
delete from TTUM1_O_TABLE  where trim(TRANSACTION_AMOUNT)= 0;
commit;
exit; 
