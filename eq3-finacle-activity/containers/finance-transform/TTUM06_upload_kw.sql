
-- File Name           : TTUM7_upload.sql
-- File Created for    : Upload file for YP split 
-- Created By          : R.Alavudeen Ali Badusha
-- Client              : ABK
-- Created On          : 13-04-2017
-------------------------------------------------------------------
truncate table TTUM6_O_TABLE ;
insert into TTUM6_O_TABLE 
select 
--Account Number
rpad(SUBSTR(FIN_ACC_NUM,1,5)||TO_CHAR(Finacle_PLC),16,' '),
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(FIN_SOL_ID,8,' '),----------changed for m4   
--Part Tran Type
    CASE WHEN SCBAL <0 THEN 'D' ELSE 'C' END,
--Transaction Amount
    lpad(abs(SCBAL)/POWER(10,C8CED),17,' '),
--Transaction Particular
    rpad('YP SPLIT DR CR ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(SCBAL)/POWER(10,C8CED),17,' '),
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
FROM
(
select * from all_final_trial_balance where scact = 'YP' and substr(fin_acc_num,6,8) like '52000%' AND SCBAL <> 0
 )A
LEFT JOIN YP_MAPPING ON  MigR_placeholder = substr(fin_acc_num,6,8)
INNER JOIN C8PF ON C8CCY = SCCCY
union
select 
--Account Number
rpad(FIN_ACC_NUM,16,' '),
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(FIN_SOL_ID,8,' '),----------changed for m4   
--Part Tran Type
    CASE WHEN SCBAL <0 THEN 'C' ELSE 'D' END,
--Transaction Amount
    lpad(abs(SCBAL)/POWER(10,C8CED),17,' '),
--Transaction Particular
    rpad('YP SPLIT DR CR CONTRA ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(SCBAL)/POWER(10,C8CED),17,' '),
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
FROM
(
select * from all_final_trial_balance where scact = 'YP' and substr(fin_acc_num,6,8) like '52000%' AND SCBAL <> 0
 )A
LEFT JOIN YP_MAPPING ON  MigR_placeholder = substr(fin_acc_num,6,8)
INNER JOIN C8PF ON C8CCY = SCCCY;
commit;
exit; 
