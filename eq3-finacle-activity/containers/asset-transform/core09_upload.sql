-- File Name        : Lien_Upload.sql
-- File Created for    : Upload file for Lien
-- Created By        : Kumaresan
-- Client            : ABK
-- Created On        : 17-06-2015
-------------------------------------------------------------------
drop table  lien_depo;
create table  lien_depo as
select v5bal deposit_amount
 , trim(jubbn)||trim(jubno)||trim(jusfx) lien_account,juhamt lien_amt,trim(v5brnm)||trim(v5dlp)||trim(v5dlr) deal_ref,
 fin_acc_num,
            case when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')
            end deposit_open_date,
            to_date(get_date_fm_btrv(jusdte),'YYYYMMDD') lien_open_date,
             case when JUDLM<>0 then to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD') end date_last_maintained
  from map_acc
  inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
  inner join scpf on scab=leg_branch_id and scan=leg_scan and scas=leg_scas
  inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=map_acc.leg_acc_num 
  inner join otpf on trim(otbrnm)||trim(otdlp)||trim(otdlr)=map_acc.leg_acc_num
  inner join c8pf on c8ccy = scccy
  where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
  and schm_type ='TDA';  
--one 
--One account has multiple lien amount and linked with multiple deals. This can't be done because remarks and details will be duplicate
--drop table lien_depo1;
--create table  lien_depo1 as 
--select distinct row_number() over (partition by a.lien_account order by DEPOSIT_OPEN_DATE) row_number,
--sum(deposit_amount) over (partition by a.lien_account order by a.lien_account,DEPOSIT_OPEN_DATE) sum_amt,
--a.* from(select distinct DEPOSIT_AMOUNT,a.lien_account,dep.lien_amt,deal_ref,fin_acc_num,deposit_open_date,dep.lien_open_date from lien_depo a 
--inner join (select lien_account,sum(lien_amt) lien_amt,min(LIEN_OPEN_DATE) LIEN_OPEN_DATE from (select distinct lien_account,lien_amt,lien_open_date from lien_depo where trim(fin_acc_num) not in (select trim(Account_number) from lien_o_table) order by lien_account)
--group by lien_account) dep on dep.lien_account=a.lien_account)a 
truncate table LIEN_O_TABLE ;
----------------Lien marked for SBA/CAA and ODA account ------------------------
insert into LIEN_O_TABLE 
select distinct
        -- LIEN_ACCOUNT_NUMBER    NVARCHAR2(16),
       rpad(map_acc.fin_acc_num,16,' '),
       -- LIEN_AMOUNT            NVARCHAR2(17),
            lpad(to_number(juhamt)/POWER(10,C8CED),17,' '),
       -- CRNCY_CODE             NVARCHAR2(3)       
       lpad(scpf.scccy,3,' '),
       -- LIEN_REASON_CODE       NVARCHAR2(5),
        rpad(jupf.juhrc    ,5,' '),
       --  LIEN_START_DATE        NVARCHAR2(10),
        lpad(to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
        -- LIEN_EXPIRY_DATE       NVARCHAR2(10),
        case
        when juhed = '9999999' then '01-01-2099'
        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,
        -- LIEN_TYPE              NVARCHAR2(5),
        'ULIEN',
        -- ACCOUNT_ID             NVARCHAR2(16),
            lpad(' ',16,' '),
        -- SI_CERTIFICATE_NUMBER  NVARCHAR2(20),            
            lpad(' ',20,' '),
        -- LIMIT_PREFIX           NVARCHAR2(12),
            lpad(' ',12,' '),
        --  LIMIT_SUFFIX           NVARCHAR2(5),        
            lpad(' ',5,' '),
        -- DC_NUMBER              NVARCHAR2(16),    
            lpad(' ',16,' '),
        -- BG_NUMBER              NVARCHAR2(16),        
            lpad(' ',16,' '),
        -- SOL_ID                 NVARCHAR2(8),    
            rpad(map_acc.fin_sol_id,8,' '),
        --LIEN_REMARKS           NVARCHAR2(50),    
            --case when trim(JUHDD1) is not null then
            --lpad('REF: '||lpad(JUHNO,3,'0')||' '||trim(JUHDD1),50,' ')
            --else lpad('REF: '||lpad(JUHNO,3,'0')||' '||'Migrated Lien',50,' ')
            --end,
            case when trim(JUHDD1) is not null then
            lpad(to_char(trim(JUHDD1)),50,' ')
            else lpad('Migrated Lien',50,' ')
            end,--changed on 29-02-2016
        --requested_by_desc      nvarchar2(80),
            --lpad('Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')||' Date Last Maintained: '
            --     ||case when   get_date_fm_btrv(JUDLM)<>'ERROR'     then  to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY') else
            --' ' end,80,' '),
            lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
                 else ' ' end||
                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
                  else ' ' end,80,' '),--based on TFS 377025 changed on 03-03-2016
        --requested_department   nvarchar2(80),
            lpad(trim(JUACO)||':'||trim(C2RNM),80,' '),
        --contact_num            nvarchar2(80),        
                case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
                end,
        --IPO_INSTITUTION_NAME   NVARCHAR2(50),    
            lpad(' ',50,' '),
        --IPO_APP_NO             NVARCHAR2(16)     
            lpad(' ',16,' ')
  from map_acc
  inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
  inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas  
  inner join c8pf on c8ccy = scccy
  left join c2pf on C2RCD=juaco  
  where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
  and schm_type not in('OOO','TDA','TFS','OAB','CLA','LAA'); 
  --added CLA and LAA based on error from Infosys on 19/04/2017 
COMMIT; 
---------------Lien marked for TDA account --One account link with one deal and sum of deposit amount matching with lien amount------------------------
insert into LIEN_O_TABLE 
select distinct
        -- LIEN_ACCOUNT_NUMBER    NVARCHAR2(16),
       rpad(map_acc.fin_acc_num,16,' '),
       -- LIEN_AMOUNT            NVARCHAR2(17),
            lpad(case when comments='ONE DEAL' then to_number(juhamt)/POWER(10,C8CED) else to_number(v5bal)/POWER(10,C8CED) end,17,' '), ---Based on Spira ticket no 7099 Script changed on 03-07-2017
       -- CRNCY_CODE             NVARCHAR2(3)       
       lpad(scpf.scccy,3,' '),
       -- LIEN_REASON_CODE       NVARCHAR2(5),
        rpad(jupf.juhrc    ,5,' '),
       --  LIEN_START_DATE        NVARCHAR2(10),
        lpad(to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
        -- LIEN_EXPIRY_DATE       NVARCHAR2(10),
        case
        when juhed = '9999999' then '01-01-2099'
        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,
        -- LIEN_TYPE              NVARCHAR2(5),
        'ULIEN',
        -- ACCOUNT_ID             NVARCHAR2(16),
            lpad(' ',16,' '),
        -- SI_CERTIFICATE_NUMBER  NVARCHAR2(20),            
            lpad(' ',20,' '),
        -- LIMIT_PREFIX           NVARCHAR2(12),
            lpad(' ',12,' '),
        --  LIMIT_SUFFIX           NVARCHAR2(5),        
            lpad(' ',5,' '),
        -- DC_NUMBER              NVARCHAR2(16),    
            lpad(' ',16,' '),
        -- BG_NUMBER              NVARCHAR2(16),        
            lpad(' ',16,' '),
        -- SOL_ID                 NVARCHAR2(8),    
            rpad(map_acc.fin_sol_id,8,' '),
        --LIEN_REMARKS           NVARCHAR2(50),    
            --case when trim(JUHDD1) is not null then
            --lpad('REF: '||lpad(JUHNO,3,'0')||' '||trim(JUHDD1),50,' ')
            --else lpad('REF: '||lpad(JUHNO,3,'0')||' '||'Migrated Lien',50,' ')
            --end,
            case when trim(JUHDD1) is not null then
            lpad(to_char(trim(JUHDD1)),50,' ')
            else lpad('Deposit Lien',50,' ')
            end,--changed on 29-02-2016
        --requested_by_desc      nvarchar2(80),
            --lpad('Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')||' Date Last Maintained: '
            --     ||case when   get_date_fm_btrv(JUDLM)<>'ERROR'     then  to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY') else
            --' ' end,80,' '),
            lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
                 else ' ' end||
                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
                  else ' ' end,80,' '),--based on TFS 377025 changed on 03-03-2016
        --requested_department   nvarchar2(80),
            lpad(trim(JUACO)||':'||trim(C2RNM),80,' '),
        --contact_num            nvarchar2(80),        
                case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
                end,
        --IPO_INSTITUTION_NAME   NVARCHAR2(50),    
            lpad(' ',50,' '),
        --IPO_APP_NO             NVARCHAR2(16)     
            lpad(' ',16,' ')
 from map_acc
  inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
  inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas
  inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=map_acc.leg_acc_num 
  inner join (select DISTINCT LIEN_ACCOUNT,'ONE DEAL' comments from lien_depo where LIEN_ACCOUNT in(select distinct LIEN_ACCOUNT from (select distinct lien_account,fin_acc_num from lien_depo) group by LIEN_ACCOUNT having count(*)=1)
  union all
select DISTINCT LIEN_ACCOUNT,'MULTI DEAL' comments from lien_depo where LIEN_ACCOUNT in(select LIEN_ACCOUNT from lien_depo group by LIEN_ACCOUNT,LIEN_AMT having count(*)>1 AND SUM(DEPOSIT_AMOUNT)=LIEN_AMT))deplien on deplien.LIEN_ACCOUNT=leg_branch_id||leg_scan||leg_scas
  --inner join (select fin_acc_num,sum(LIEN_AMT) LIEN_AMT,max(DEPOSIT_AMOUNT) DEPOSIT_AMOUNT from lien_depo group by fin_acc_num having sum(to_number(lien_amt)) <= max(to_number(deposit_amount)))dep_lien on  dep_lien.FIN_ACC_NUM=map_acc.fin_acc_num    
  inner join c8pf on c8ccy = scccy
  left join c2pf on C2RCD=juaco  
  where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
  and schm_type ='TDA';
COMMIT; 
--One account has one lien amount and linked with multiple deals. This has been marked as FIFO method 
drop table LIEN_DEPO1;
create table LIEN_DEPO1 as
select row_number() over (partition by lien_account order by DEPOSIT_OPEN_DATE) row_number,
sum(deposit_amount) over (partition by lien_account order by lien_account,DEPOSIT_OPEN_DATE) sum_amt,
a.* from (select distinct deposit_amount,lien_account,lien_amt,deal_ref,fin_acc_num,deposit_open_date,lien_open_date from lien_depo a where lien_account in (
select lien_account from (select distinct lien_account,lien_amt,lien_open_date from lien_depo where trim(fin_acc_num) not in (select trim(Account_number) from lien_o_table) order by lien_account)
group by lien_account having count(*) = 1))a;
--One account has one lien amount and linked with multiple deals. This has been marked as FIFO method 
insert into LIEN_O_TABLE 
select distinct
        -- LIEN_ACCOUNT_NUMBER    NVARCHAR2(16),
       rpad(map_acc.fin_acc_num,16,' '),
       -- LIEN_AMOUNT            NVARCHAR2(17),
            lpad(case when row_number=1 and lien_amt <= deposit_amount then lien_amt              
when lien_amt > sum_amt then to_number(deposit_amount)
when lien_amt <= sum_amt and (lien_amt - lag (sum_amt, 1) OVER (PARTITION BY lien_account  ORDER BY row_number)) > 0 then lien_amt - lag (sum_amt, 1) OVER (PARTITION BY lien_account  ORDER BY row_number) 
else 0 end/POWER(10,C8CED),17,' '),
       -- CRNCY_CODE             NVARCHAR2(3)       
       lpad(trim(scpf.scccy),3,' '),
       -- LIEN_REASON_CODE       NVARCHAR2(5),
        rpad(jupf.juhrc    ,5,' '),
       --  LIEN_START_DATE        NVARCHAR2(10),
        lpad(to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
        -- LIEN_EXPIRY_DATE       NVARCHAR2(10),
        case
        when juhed = '9999999' then '01-01-2099'
        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,
        -- LIEN_TYPE              NVARCHAR2(5),
        'ULIEN',
        -- ACCOUNT_ID             NVARCHAR2(16),
            lpad(' ',16,' '),
        -- SI_CERTIFICATE_NUMBER  NVARCHAR2(20),            
            lpad(' ',20,' '),
        -- LIMIT_PREFIX           NVARCHAR2(12),
            lpad(' ',12,' '),
        --  LIMIT_SUFFIX           NVARCHAR2(5),        
            lpad(' ',5,' '),
        -- DC_NUMBER              NVARCHAR2(16),    
            lpad(' ',16,' '),
        -- BG_NUMBER              NVARCHAR2(16),        
            lpad(' ',16,' '),
        -- SOL_ID                 NVARCHAR2(8),    
            rpad(map_acc.fin_sol_id,8,' '),
        --LIEN_REMARKS           NVARCHAR2(50),    
            --case when trim(JUHDD1) is not null then
            --lpad('REF: '||lpad(JUHNO,3,'0')||' '||trim(JUHDD1),50,' ')
            --else lpad('REF: '||lpad(JUHNO,3,'0')||' '||'Migrated Lien',50,' ')
            --end,
            case when trim(JUHDD1) is not null then
            lpad(to_char(trim(JUHDD1)),50,' ')
            else lpad('Deposit Lien',50,' ')
            end,--changed on 29-02-2016
        --requested_by_desc      nvarchar2(80),
            --lpad('Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')||' Date Last Maintained: '
            --     ||case when   get_date_fm_btrv(JUDLM)<>'ERROR'     then  to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY') else
            --' ' end,80,' '),
            lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
                 else ' ' end||
                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
                  else ' ' end,80,' '),--based on TFS 377025 changed on 03-03-2016
        --requested_department   nvarchar2(80),
            lpad(trim(JUACO)||':'||trim(C2RNM),80,' '),
        --contact_num            nvarchar2(80),        
                case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
                end,
        --IPO_INSTITUTION_NAME   NVARCHAR2(50),    
            lpad(' ',50,' '),
        --IPO_APP_NO             NVARCHAR2(16)     
            lpad(' ',16,' ')
from map_acc
inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas
inner join LIEN_DEPO1 a on a.fin_acc_num=map_acc.fin_acc_num 
inner join c8pf on c8ccy = map_acc.currency
left join c2pf on C2RCD=juaco  
where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
and schm_type ='TDA'; 
COMMIT;
--One account has multiple lien amount and linked with multiple deals. --based on naggi and vijay confirmation on 06-04-2017 taken one of deposit which is based on this (depoait_amount - sum(lien_amt)) > 0  condition and linked all the lien amount into that deal. 
insert into LIEN_O_TABLE 
select distinct
        -- LIEN_ACCOUNT_NUMBER    NVARCHAR2(16),
       rpad(fin_acc_num,16,' '),
        -- LIEN_AMOUNT            NVARCHAR2(17),
        lpad(to_number(juhamt)/POWER(10,C8CED),17,' '), 
       -- CRNCY_CODE             NVARCHAR2(3)       
       lpad(currency,3,' '),
       -- LIEN_REASON_CODE       NVARCHAR2(5),
        rpad(jupf.juhrc    ,5,' '),
       --  LIEN_START_DATE        NVARCHAR2(10),
        lpad(to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
        -- LIEN_EXPIRY_DATE       NVARCHAR2(10),
        case
        when juhed = '9999999' then '01-01-2099'
        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,
        -- LIEN_TYPE              NVARCHAR2(5),
        'ULIEN',
        -- ACCOUNT_ID             NVARCHAR2(16),
            lpad(' ',16,' '),
        -- SI_CERTIFICATE_NUMBER  NVARCHAR2(20),            
            lpad(' ',20,' '),
        -- LIMIT_PREFIX           NVARCHAR2(12),
            lpad(' ',12,' '),
        --  LIMIT_SUFFIX           NVARCHAR2(5),        
            lpad(' ',5,' '),
        -- DC_NUMBER              NVARCHAR2(16),    
            lpad(' ',16,' '),
        -- BG_NUMBER              NVARCHAR2(16),        
            lpad(' ',16,' '),
        -- SOL_ID                 NVARCHAR2(8),    
            rpad(map_acc.fin_sol_id,8,' '),
        --LIEN_REMARKS           NVARCHAR2(50),    
            case when trim(JUHDD1) is not null then
            lpad(to_char(trim(JUHDD1)),50,' ')
            else lpad('Deposit Lien',50,' ')
            end,--changed on 29-02-2016
        --requested_by_desc      nvarchar2(80),
            lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
                 else ' ' end||
                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
                  else ' ' end,80,' '),--based on TFS 377025 changed on 03-03-2016
        --requested_department   nvarchar2(80),
            lpad(trim(JUACO)||':'||trim(C2RNM),80,' '),
        --contact_num            nvarchar2(80),        
                case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
                end,
        --IPO_INSTITUTION_NAME   NVARCHAR2(50),    
            lpad(' ',50,' '),
        --IPO_APP_NO             NVARCHAR2(16)     
            lpad(' ',16,' ')
from map_acc
inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
inner join (select distinct a.LIEN_ACCOUNT,max(fin_acc_num) fin_num from lien_depo a
  inner join (select lien_account,sum(lien_amt) lien_amt from (select distinct lien_account,lien_amt from lien_depo) group by lien_account)b on a.lien_account=b.lien_account
  where (deposit_amount-b.lien_amt) > 0 and FIN_ACC_NUM not in (select trim(account_number) from lien_o_table) group by a.LIEN_ACCOUNT)lien on fin_num=fin_acc_num
inner join c8pf on c8ccy = map_acc.currency
left join c2pf on C2RCD=juaco  
where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
and schm_type ='TDA'; 
COMMIT;
--insert into lien_o_table 
--select distinct
--        -- LIEN_ACCOUNT_NUMBER    NVARCHAR2(16),
--       rpad(map_acc.fin_acc_num,16,' '),
--       -- LIEN_AMOUNT            NVARCHAR2(17),
--            lpad(lien_amt,17,' '),
--       -- CRNCY_CODE             NVARCHAR2(3)       
--       lpad(CURRENCY,3,' '),
--       -- LIEN_REASON_CODE       NVARCHAR2(5),
--        rpad(juhrc    ,5,' '),
--       --  LIEN_START_DATE        NVARCHAR2(10),
--        lpad(to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--        -- LIEN_EXPIRY_DATE       NVARCHAR2(10),
--        case
--        when juhed = '9999999' then '01-01-2099'
--        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,
--        -- LIEN_TYPE              NVARCHAR2(5),
--        'ULIEN',
--        -- ACCOUNT_ID             NVARCHAR2(16),
--            lpad(' ',16,' '),
--        -- SI_CERTIFICATE_NUMBER  NVARCHAR2(20),            
--            lpad(' ',20,' '),
--        -- LIMIT_PREFIX           NVARCHAR2(12),
--            lpad(' ',12,' '),
--        --  LIMIT_SUFFIX           NVARCHAR2(5),        
--            lpad(' ',5,' '),
--        -- DC_NUMBER              NVARCHAR2(16),    
--            lpad(' ',16,' '),
--        -- BG_NUMBER              NVARCHAR2(16),        
--            lpad(' ',16,' '),
--        -- SOL_ID                 NVARCHAR2(8),    
--            rpad(map_acc.fin_sol_id,8,' '),
--        --LIEN_REMARKS           NVARCHAR2(50),    
--            --case when trim(JUHDD1) is not null then
--            --lpad('REF: '||lpad(JUHNO,3,'0')||' '||trim(JUHDD1),50,' ')
--            --else lpad('REF: '||lpad(JUHNO,3,'0')||' '||'Migrated Lien',50,' ')
--            --end,
--            case when trim(JUHDD1) is not null then
--            lpad(to_char(trim(JUHDD1)),50,' ')
--            else lpad('Deposit Lien',50,' ')
--            end,--changed on 29-02-2016
--        --requested_by_desc      nvarchar2(80),
--            --lpad('Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')||' Date Last Maintained: '
--            --     ||case when   get_date_fm_btrv(JUDLM)<>'ERROR'     then  to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY') else
--            --' ' end,80,' '),
--            lpad(case when JUNIP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUNIP),'YYYYMMDD'),'DD-MM-YYYY')
--                 else ' ' end||
--                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
--                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
--                  else ' ' end,80,' '),--based on TFS 377025 changed on 03-03-2016
--        --requested_department   nvarchar2(80),
--            lpad(trim(JUACO)||':'||trim(C2RNM),80,' '),
--        --contact_num            nvarchar2(80),        
--                case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
--                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
--                end,
--        --IPO_INSTITUTION_NAME   NVARCHAR2(50),    
--            lpad(' ',50,' '),
--        --IPO_APP_NO             NVARCHAR2(16)     
--            lpad(' ',16,' ')
--from map_acc
--inner join lien_manual on leg_acc_num=deal_ac_number
--left join c2pf on C2RCD=juaco;
--commit;
--------------------------------------------------
--insert into LIEN_O_TABLE 
--select distinct
--        -- LIEN_ACCOUNT_NUMBER    NVARCHAR2(16),
--       rpad(map_acc.fin_acc_num,16,' '),
--       -- LIEN_AMOUNT            NVARCHAR2(17),
--            lpad(to_number((DEPOSIT_AMOUNT)/POWER(10,C8CED)),17,' '),
--       -- CRNCY_CODE             NVARCHAR2(3)       
--       lpad(trim(scpf.scccy),3,' '),
--       -- LIEN_REASON_CODE       NVARCHAR2(5),
--        rpad(jupf.juhrc    ,5,' '),
--       --  LIEN_START_DATE        NVARCHAR2(10),
--        lpad(to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--        -- LIEN_EXPIRY_DATE       NVARCHAR2(10),
--        case
--        when juhed = '9999999' then '01-01-2099'
--        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,
--        -- LIEN_TYPE              NVARCHAR2(5),
--        'ULIEN',
--        -- ACCOUNT_ID             NVARCHAR2(16),
--            lpad(' ',16,' '),
--        -- SI_CERTIFICATE_NUMBER  NVARCHAR2(20),            
--            lpad(' ',20,' '),
--        -- LIMIT_PREFIX           NVARCHAR2(12),
--            lpad(' ',12,' '),
--        --  LIMIT_SUFFIX           NVARCHAR2(5),        
--            lpad(' ',5,' '),
--        -- DC_NUMBER              NVARCHAR2(16),    
--            lpad(' ',16,' '),
--        -- BG_NUMBER              NVARCHAR2(16),        
--            lpad(' ',16,' '),
--        -- SOL_ID                 NVARCHAR2(8),    
--            rpad(map_acc.fin_sol_id,8,' '),
--        --LIEN_REMARKS           NVARCHAR2(50),    
--            --case when trim(JUHDD1) is not null then
--            --lpad('REF: '||lpad(JUHNO,3,'0')||' '||trim(JUHDD1),50,' ')
--            --else lpad('REF: '||lpad(JUHNO,3,'0')||' '||'Migrated Lien',50,' ')
--            --end,
--            case when trim(JUHDD1) is not null then
--            lpad(to_char(trim(JUHDD1)),50,' ')
--            else lpad('Deposit Lien',50,' ')
--            end,--changed on 29-02-2016
--        --requested_by_desc      nvarchar2(80),
--            --lpad('Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')||' Date Last Maintained: '
--            --     ||case when   get_date_fm_btrv(JUDLM)<>'ERROR'     then  to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY') else
--            --' ' end,80,' '),
--            lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
--                 else ' ' end||
--                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
--                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
--                  else ' ' end,80,' '),--based on TFS 377025 changed on 03-03-2016
--        --requested_department   nvarchar2(80),
--            lpad(trim(JUACO)||':'||trim(C2RNM),80,' '),
--        --contact_num            nvarchar2(80),        
--                case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
--                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
--                end,
--        --IPO_INSTITUTION_NAME   NVARCHAR2(50),    
--            lpad(' ',50,' '),
--        --IPO_APP_NO             NVARCHAR2(16)     
--            lpad(' ',16,' ')
--from map_acc
--inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
--inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas
--inner join (select *  from lien_depo where LIEN_ACCOUNT in( 
--    select LIEN_ACCOUNT from lien_depo
--    group by LIEN_ACCOUNT ,LIEN_AMT
--    having count(*)>1 AND SUM(DEPOSIT_AMOUNT)=LIEN_AMT 
--    ))dep_lien on dep_lien.FIN_ACC_NUM=map_acc.fin_acc_num  
--  inner join c8pf on c8ccy = map_acc.currency
--left join c2pf on C2RCD=juaco  
--where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
--else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
--and schm_type ='TDA'; 
--COMMIT;
-------------------------------------------Manual Liens added based on Email confirmation from Business (Email Subject : FW: Multi_lien_and_multi_deals .xls-----------------------------------------------------------------------------
insert into lien_o_table 
select distinct
        -- LIEN_ACCOUNT_NUMBER    NVARCHAR2(16),
       rpad(map_acc.fin_acc_num,16,' '),
       -- LIEN_AMOUNT            NVARCHAR2(17),
            lpad(lien_amt,17,' '),
       -- CRNCY_CODE             NVARCHAR2(3)       
       lpad(CURRENCY,3,' '),
       -- LIEN_REASON_CODE       NVARCHAR2(5),
        rpad(juhrc    ,5,' '),
       --  LIEN_START_DATE        NVARCHAR2(10),
        lpad(to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
        -- LIEN_EXPIRY_DATE       NVARCHAR2(10),
        case
        when juhed = '9999999' then '01-01-2099'
        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,
        -- LIEN_TYPE              NVARCHAR2(5),
        'ULIEN',
        -- ACCOUNT_ID             NVARCHAR2(16),
            lpad(' ',16,' '),
        -- SI_CERTIFICATE_NUMBER  NVARCHAR2(20),            
            lpad(' ',20,' '),
        -- LIMIT_PREFIX           NVARCHAR2(12),
            lpad(' ',12,' '),
        --  LIMIT_SUFFIX           NVARCHAR2(5),        
            lpad(' ',5,' '),
        -- DC_NUMBER              NVARCHAR2(16),    
            lpad(' ',16,' '),
        -- BG_NUMBER              NVARCHAR2(16),        
            lpad(' ',16,' '),
        -- SOL_ID                 NVARCHAR2(8),    
            rpad(map_acc.fin_sol_id,8,' '),
        --LIEN_REMARKS           NVARCHAR2(50),    
            --case when trim(JUHDD1) is not null then
            --lpad('REF: '||lpad(JUHNO,3,'0')||' '||trim(JUHDD1),50,' ')
            --else lpad('REF: '||lpad(JUHNO,3,'0')||' '||'Migrated Lien',50,' ')
            --end,
            case when trim(JUHDD1) is not null then
            lpad(to_char(trim(JUHDD1)),50,' ')
            else lpad('Deposit Lien',50,' ')
            end,--changed on 29-02-2016
        --requested_by_desc      nvarchar2(80),
            --lpad('Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')||' Date Last Maintained: '
            --     ||case when   get_date_fm_btrv(JUDLM)<>'ERROR'     then  to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY') else
            --' ' end,80,' '),
            lpad(case when JUNIP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUNIP),'YYYYMMDD'),'DD-MM-YYYY')
                 else ' ' end||
                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
                  else ' ' end,80,' '),--based on TFS 377025 changed on 03-03-2016
        --requested_department   nvarchar2(80),
            lpad(trim(JUACO)||':'||trim(C2RNM),80,' '),
        --contact_num            nvarchar2(80),        
                case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
                end,
        --IPO_INSTITUTION_NAME   NVARCHAR2(50),    
            lpad(' ',50,' '),
        --IPO_APP_NO             NVARCHAR2(16)     
            lpad(' ',16,' ')
from map_acc
inner join lien_manual on leg_acc_num=deal_ac_number
left join c2pf on C2RCD=juaco;
commit;
-------------- Deposit collateral Lien marked --- process collateral amount taken and subtracted with lien amount which is extracted by previous uploads-----------------------------
--insert into LIEN_O_TABLE
--select  distinct
--        -- LIEN_ACCOUNT_NUMBER    NVARCHAR2(16),
--       rpad(map_acc.fin_acc_num,16,' '),
--       -- LIEN_AMOUNT            NVARCHAR2(17),
--            --lpad(case when account_number is null then  to_char(CEILING_LIMIT)
----when to_number(CEILING_LIMIT) > to_number(LIEN_AMOUNT) then to_char(to_number(CEILING_LIMIT) - to_number(LIEN_AMOUNT))
----end,17,' '),   ---script changed on 12-07-2017 based on mk5 observation earlier lien amount calculated based on ceilimt_limit now changed to collateral value
--            lpad(case when account_number is null then  to_char(COLL_VALUE)
--when to_number(COLL_VALUE) > to_number(LIEN_AMOUNT) then to_char(to_number(COLL_VALUE) - to_number(COLL_VALUE)
--end,17,' '),
--       -- CRNCY_CODE             NVARCHAR2(3)       
--       lpad(trim(map_acc.currency),3,' '),
--       -- LIEN_REASON_CODE       NVARCHAR2(5),
--        rpad('019'    ,5,' '),
--       --  LIEN_START_DATE        NVARCHAR2(10),
--        lpad(case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            else  rpad(' ',10,' ')
--            end,10,' '),
--        -- LIEN_EXPIRY_DATE       NVARCHAR2(10),        
--         lpad('01-01-2099',10,' '),
--        -- LIEN_TYPE              NVARCHAR2(5),
--        'ULIEN',
--        -- ACCOUNT_ID             NVARCHAR2(16),
--            lpad(' ',16,' '),
--        -- SI_CERTIFICATE_NUMBER  NVARCHAR2(20),            
--            lpad(' ',20,' '),
--        -- LIMIT_PREFIX           NVARCHAR2(12),
--            lpad(' ',12,' '),
--        --  LIMIT_SUFFIX           NVARCHAR2(5),        
--            lpad(' ',5,' '),
--        -- DC_NUMBER              NVARCHAR2(16),    
--            lpad(' ',16,' '),
--        -- BG_NUMBER              NVARCHAR2(16),        
--            lpad(' ',16,' '),
--        -- SOL_ID                 NVARCHAR2(8),    
--            rpad(map_acc.fin_sol_id,8,' '),
--        --LIEN_REMARKS           NVARCHAR2(50),
--            lpad('Deposit Lien',50,' '),            
--        --requested_by_desc      nvarchar2(80),        
--            lpad(' ' ,80,' '),
--        --requested_department   nvarchar2(80),
--            lpad(' ' ,80,' '),
--        --contact_num            nvarchar2(80),        
--                lpad(' ' ,80,' '),
--        --IPO_INSTITUTION_NAME   NVARCHAR2(50),    
--            lpad(' ',50,' '),
--        --IPO_APP_NO             NVARCHAR2(16)     
--            lpad(' ',16,' ')
--from col_dep_o_table a
--left join (select account_number,sum(lien_amount) lien_amount from LIEN_O_TABLE group by account_number)lien on   trim(a.DEPOSIT_ACCOUNT_NUMBER)=trim(account_number)
--inner join map_acc on fin_acc_num=trim(a.DEPOSIT_ACCOUNT_NUMBER)
--inner join v5pf on LEG_ACC_NUM=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
--left join (select * from otpf where ottdt='D')otpf on v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
----WHERE  to_number(CEILING_LIMIT) > to_number(LIEN_AMOUNT) OR trim(account_number) IS NULL
--WHERE  to_number(COLL_VALUE) > to_number(LIEN_AMOUNT) OR trim(account_number) IS NULL;
-----script changed on 12-07-2017 based on mk5 observation earlier lien amount calculated based on ceilimt_limit now changed to collateral value
--commit;
----------------Salary Lien------------------------
insert into LIEN_O_TABLE 
select distinct
        -- LIEN_ACCOUNT_NUMBER    NVARCHAR2(16),
       rpad(map_acc.fin_acc_num,16,' '),
       -- LIEN_AMOUNT            NVARCHAR2(17),
            lpad(to_number(juhamt)/POWER(10,C8CED),17,' '),
       -- CRNCY_CODE             NVARCHAR2(3)       
       lpad(map_acc.currency,3,' '),
       -- LIEN_REASON_CODE       NVARCHAR2(5),
        rpad('SAL' ,5,' '),
       --  LIEN_START_DATE        NVARCHAR2(10),
        lpad(to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
        -- LIEN_EXPIRY_DATE       NVARCHAR2(10),
        case
        when juhed = '9999999' then '01-01-2099'
        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,
        -- LIEN_TYPE              NVARCHAR2(5),
        'ULIEN',
        -- ACCOUNT_ID             NVARCHAR2(16),
            lpad(' ',16,' '),
        -- SI_CERTIFICATE_NUMBER  NVARCHAR2(20),            
            lpad(' ',20,' '),
        -- LIMIT_PREFIX           NVARCHAR2(12),
            lpad(' ',12,' '),
        --  LIMIT_SUFFIX           NVARCHAR2(5),        
            lpad(' ',5,' '),
        -- DC_NUMBER              NVARCHAR2(16),    
            lpad(' ',16,' '),
        -- BG_NUMBER              NVARCHAR2(16),        
            lpad(' ',16,' '),
        -- SOL_ID                 NVARCHAR2(8),    
            rpad(map_acc.fin_sol_id,8,' '),
        --LIEN_REMARKS           NVARCHAR2(50),    
            lpad('Loan Recovery From Salary Account/'||reco.fin_acc_num,50,' '),
        --requested_by_desc      nvarchar2(80),
            lpad(' ',80,' '),
        --requested_department   nvarchar2(80),
            lpad(trim(JUACO)||':'||trim(C2RNM),80,' '),
        --contact_num            nvarchar2(80),        
                 lpad(' ',80,' '),
        --IPO_INSTITUTION_NAME   NVARCHAR2(50),    
            lpad(' ',50,' '),
        --IPO_APP_NO             NVARCHAR2(16)     
            lpad(' ',16,' ')
  from map_acc
   inner join salary_lien on map_Acc.leg_branch_id||leg_scan||leg_scas= jubbn||jubno||jusfx
  inner join map_acc reco on reco.leg_acc_num= regexp_replace(substr(trim(JUHDD1),6,30),'[ ,-]','')  
  inner join c8pf on c8ccy = map_Acc.currency
  left join c2pf on C2RCD=juaco  
  where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
  else to_date(get_date_fm_btrv(juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY');
COMMIT; 
delete from lien_o_table where to_number(lien_amount)=0;
commit;
exit; 
