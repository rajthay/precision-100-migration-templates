
truncate table OFFSET_MIGRA_BAL;
truncate bal_tran_offbook_to_onbook;

INSERT INTO OFFSET_MIGRA_BAL 
select FORACID,ACCT_CRNCY_CODE,SOL_ID,CASE WHEN CLR_BAL_AMT>0 THEN 'D' ELSE 'C' END INDICATOR,ABS(CLR_BAL_AMT),'OFFSET MIGRA' 
from tbaadm.gam where clr_bal_amt!=0 AND BACID IN ('52000SBA','52000CAA','52000ODA');
commit;

INSERT INTO OFFSET_MIGRA_BAL 
select FORACID,ACCT_CRNCY_CODE,SOL_ID,CASE WHEN CLR_BAL_AMT>0 THEN 'D' ELSE 'C' END INDICATOR,ABS(CLR_BAL_AMT),'OFFSET MIGRA' 
from tbaadm.gam where clr_bal_amt!=0 AND BACID IN ('520000RX','520000TX','520000YF','520000YL');
commit;

insert into OFFSET_MIGRA_BAL
select * from( 
select FORACID,ACCT_CRNCY_CODE,SOL_ID,CASE WHEN CLR_BAL_AMT>0 THEN 'D' ELSE 'C' END INDICATOR,case when sol_id='612'
then ABS(CLR_BAL_AMT-5.016)
else ABS(CLR_BAL_AMT)  end AMOUNT ,'OFFSET MIGRA' 
from tbaadm.gam where clr_bal_amt!=0 AND BACID IN ('52000LAA')
union all
select  sol_id||substr(FORACID,4,7)||'0YD' FORACID,ACCT_CRNCY_CODE,SOL_ID, 'C'  INDICATOR,case when sol_id='612'
then ABS(CLR_BAL_AMT-5.016)
else ABS(CLR_BAL_AMT)  end AMOUNT ,'OFFSET MIGRA' 
from tbaadm.gam where clr_bal_amt!=0 AND BACID IN ('52000LAA'))
order by FORACID;
commit;

truncate table offset_ttum;
insert into offset_ttum
select 
--Account Number
    rpad(ACCOUNT,16,' '),
--Currency Code     
    rpad(ccy,3,' '),
--SOLID
    rpad(SOL_ID,8,' '),
--Part Tran Type
    INDICATOR,
--Transaction Amount
    lpad(abs(AMOUNT),17,' '),
--Transaction Particular
    rpad(PERTICULARS,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(AMOUNT),17,' '),
    rpad(ccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(get_param('EOD_DATE'),10,' '),
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
from OFFSET_MIGRA_BAL;
commit;
--INTEREST SUSPANCE AMOUNT MOVING OFF BOOK TO ON BOOK changed on 03-09-2017
insert into offset_ttum
select 
--Account Number
    rpad(ACCOUNT,16,' '),
--Currency Code     
    rpad(ccy,3,' '),
--SOLID
    rpad(SOL_ID,8,' '),
--Part Tran Type
    INDICATOR,
--Transaction Amount
    lpad(abs(AMOUNT),17,' '),
--Transaction Particular
    rpad(PERTICULARS,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(AMOUNT),17,' '),
    rpad(ccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(get_param('EOD_DATE'),10,' '),
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
from bal_tran_offbook_to_onbook;
commit; 

