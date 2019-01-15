
-- File Name         : TTUM3
-- File Created for  : Upload file for Office accounts
-- Created By        : Kumaresan.B
-- Client            : EIB
-- Created On        : 13-08-2015
-------------------------------------------------------------------
drop table future_tran;
create table future_tran as (
select saab,saan,saas,c8ccy,saama/power(10,c8ced) saama,sanegp,savfr,new_FIN_SOL_ID FIN_SOL_ID,fin_acc_num,TTUM1_MIGR_ACCT from 
scpf
inner join sapf on scpf.scab = saab and scpf.scan = saan and scpf.scas = saas 
inner join (select * from all_final_trial_balance where scheme_type in ('SBA','CAA','ODA'))a on scpf.scab = a.scab and scpf.scan = a.scan and scpf.scas =  a.scas
inner join c8pf on c8ccy =  saccy 
where savfr > get_param('EODCYYMMDD') 
and (to_number(scpf.scsum1) + to_number(scpf.scsum2)) <> 0);
-- delete for more than 999 days future transaction date --
delete  future_tran where to_date(get_date_fm_btrv(savfr),'YYYYMMDD')>to_date('2020','YYYY');
commit;
truncate table TTUM3_O_TABLE ;
insert into TTUM3_O_TABLE 
select 
--Account Number
    rpad(FIN_ACC_NUM,16,' '),
--Currency Code 	
	rpad(c8ccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when to_number(saama) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs(to_number(saama)),17,' '),
--Transaction Particular
    rpad('TTUM3 Migration- '||to_char(saab)||to_char(saan)||trim(saas)||trim(c8ccy),30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((saama)),17,' '),
    rpad(c8ccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(to_char(to_date(get_date_fm_btrv(savfr),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
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
from future_tran ;
commit;
insert into TTUM3_O_TABLE
--union for OABMIGR account
select 
--Account Number
    rpad(TTUM1_MIGR_ACCT,16,' '),
--Currency Code 
    rpad(c8ccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when to_number(saama) > 0 then 'D'
         else 'C'
    end,
--Transaction Amount
    lpad(abs(to_number(saama)),17,' '),
--Transaction Particular
    rpad('TTUM3 Migration Contra' ,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((saama)),17,' '),
    rpad(c8ccy,3,' '),
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
from future_tran;
COMMIT;
exit; 
