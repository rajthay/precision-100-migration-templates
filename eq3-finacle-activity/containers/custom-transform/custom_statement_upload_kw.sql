
-- File Name        : custom_statement_upload.sql 
-- File Created for    : Upload file for statement and swift  details
-- Created By        : R.Alavudeen Ali Badusha
-- Client            : ABK
-- Created On        : 06-06-2016
-------------------------------------------------------------------
truncate table  CUSTOM_STATEMENT_TABLE;
insert into CUSTOM_STATEMENT_TABLE 
select   
--  ACID                            VARCHAR2(11 CHAR),
gam.acid,
--  PS_REQD_FLG                     CHAR(1 BYTE),
case  --when scaiG6='Y' then 'N' based on spira id 7983 -- withholding stament condition removed --PS flag provided for all accounts
when substr(SCSFC,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L','Z','V','W','Y','S','M','T','U','N','O','P','Q','R') then 'Y' when trim(ps_freq_type) is not null then 'Y' else 'N' end,
--  PB_REQD_FLG                     CHAR(1 BYTE),
case  when map_acc.schm_code in ('SBGER','SBDAL','SBKID') then 'Y' else 'N' end,
--  SWIFT_STMT_REQD_FLG             CHAR(1 BYTE),
case when swift_code is not null then 'Y' when account is not null then 'Y' else 'N' end,
--  PS_LAST_PRNT_TIME               DATE,
case when scstml <> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') end,
--  PS_FREQ_TYPE                    CHAR(1 BYTE),
case --when scaiG6='Y' then ''      --based on spira id 7983 -- withholding stament condition removed --frequency type provided for all accounts
when substr(SCSFC,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then 'Y'
         when substr(SCSFC,0,1) in ('Z') then 'D'
         when substr(SCSFC,0,1) in ('V') then 'M'
         when substr(SCSFC,0,1) in ('W') then 'W'
         when substr(SCSFC,0,1) in ('Y') then 'F'
         when substr(SCSFC,0,1) in ('S','T','U') then 'Q'
         when substr(SCSFC,0,1) in ('M','N','O','P','Q','R') then 'H'
         else to_char(ps_freq_type)
    end ,
--  PS_FREQ_WEEK_NUM                CHAR(1 BYTE),
' ',
--  PS_FREQ_WEEK_DAY                NUMBER(1),
--case when scaiG6='Y' then '' when substr(SCSFC,0,1) in ('W') then  to_char(substr(SCSFC,2,2)) end,--as per spira ticket and discussion with Vijay and sandeep . this is commented due to front end issue.
'0', 
--  PS_FREQ_START_DD                NUMBER(2),
case --when scaiG6='Y' then ''    --based on spira id 7983 -- withholding stament condition removed-- frequency start dd provided for all accounts
         when substr(SCSFC,0,1) in ('V') then  to_char(substr(SCSFC,2,3))
         when substr(SCSFC,0,1) in ('S','T','U') then to_char(substr(SCSFC,2,3))
         when substr(SCSFC,0,1) in ('M','N','O','P','Q','R') then to_char(substr(SCSFC,2,3))
         when substr(SCSFC,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then to_char(substr(SCSFC,2,3))
         else '0'
    end,
--  PS_FREQ_HLDY_STAT               CHAR(1 BYTE),
'N',
--  PS_NEXT_DUE_DATE                DATE,
--casse when scaiG6='Y' then null    based on spira id 7983 -- withholding stament condition removed --next due date provided for all accounts
--when substr(SCSFC,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L','Z','V','W','Y','S','M','T','U','N','O','P','Q','R') then  to_date(si_next_exec_date(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end ,trim(mapfrequency(substr(trim(scsfc),1,1)))),'DD/MM/YY') 
--when trim(ps_freq_type) ='M' and (scstml <>  0 or scoad <> 0) and trim(scsfc) is not null then to_date(si_next_exec_date(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end ,trim(mapfrequency(substr(trim(scsfc),1,1)))),'DD/MM/YY') end,
case when trim(ps_freq_type) ='M' or trim(scsfc) is not null  then to_date(si_next_exec_date(to_date(case when substr(case when trim(scsfc) ='Z'  then lpad(to_char(substr(get_param('EOD_DATE'),1,2)+1),2,'0') else lpad(to_char(substr(nvl(trim(scsfc),'V31'),2,2)),2,'0') end||TO_CHAR(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') else to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,'MMYYYY'),1,4) in ('2902','3002','3102') then '28'
when substr(case when trim(scsfc) ='Z'  then lpad(to_char(substr(get_param('EOD_DATE'),1,2)+1),2,'0') else lpad(to_char(substr(nvl(trim(scsfc),'V31'),2,2)),2,'0') end||TO_CHAR(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') else to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,'MMYYYY'),1,4) in ('3104','3106','3109','3111') then '30'
else substr(case when trim(scsfc) ='Z'  then lpad(to_char(substr(get_param('EOD_DATE'),1,2)+1),2,'0') else lpad(to_char(substr(nvl(trim(scsfc),'V31'),2,2)),2,'0') end||TO_CHAR(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') else to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,'MMYYYY'),1,2) end||
substr(case when trim(scsfc) ='Z'  then lpad(to_char(substr(get_param('EOD_DATE'),1,2)+1),2,'0') else lpad(to_char(substr(nvl(trim(scsfc),'V31'),2,2)),2,'0') end||TO_CHAR(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') else to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,'MMYYYY'),3,6),'DDMMYYYY'),trim(mapfrequency(substr(nvl(trim(scsfc),'V'),1,1)))),'DD/MM/YY') 
end,
--  PS_DESPATCH_MODE                CHAR(1 BYTE),
case 
when map_acc.schm_code='SBAML' then 'N'  --condition added on 22-08-2017 based on vijay mail dated 21-08-2017
when scaiG6='Y' then 'N'  --based on spira id 7983 -- withholding stament condition removed --frequency type provided for all accounts but despatch mode marked as 'N'
when scaig6='N' and SCAI64='Y' then 'N'
    when scaig6='N' and SCAI64='N' then 'P'
    when scaig6='Y' and SCAI64='Y' then 'N'
    when scaig6='Y' and SCAI64='N' then 'N'
    ELSE  'N' end,
--  LOCAL_CAL_FLG                   CHAR(1 BYTE),
'N',
--  PB_LAST_PRNT_TIME               DATE,
case when map_acc.schm_code in ('SBGER','SBDAL','SBKID') and scstml <> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') end,
--  PB_LAST_PRNT_BAL                NUMBER(20,4),
'0',
--  PB_NUM_OF_BOOKS_PRNT            NUMBER(2),
'0',
--  PB_LAST_PRNT_LINE_NUM           NUMBER(2),
'0',
--  PB_LAST_PRNT_PAGE_NUM           NUMBER(2),
'0',
--  SWIFT_LAST_DATE                 DATE,
case when swift_code is not null then to_date(get_param('EOD_DATE'),'DD-MM-YYYY') when account is not null then to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  end,
--  SWIFT_STMT_SRL_NUM              NUMBER(5),
case when swift_code is not null then '0' when account is not null then '0' else '' end,
--  SWIFT_FREQ_TYPE                 CHAR(1 BYTE),
case 
    when substr(trim(FREQUENCY),0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then 'Y'
         when substr(trim(FREQUENCY),0,1) in ('Z') then 'D'
         when substr(trim(FREQUENCY),0,1) in ('V') then 'M'
         when substr(trim(FREQUENCY),0,1) in ('W') then 'W'
         when substr(trim(FREQUENCY),0,1) in ('Y') then 'F'
         when substr(trim(FREQUENCY),0,1) in ('S','T','U') then 'Q'
         when substr(trim(FREQUENCY),0,1) in ('M','N','O','P','Q','R') then 'H' 
         when swift_code is not null then 'D'
         when account is not null then 'D'
         end ,
--  SWIFT_FREQ_WEEK_NUM             CHAR(1 BYTE),
' ',
--  SWIFT_FREQ_WEEK_DAY             NUMBER(1),
case  when substr(trim(FREQUENCY),0,1) in ('W') then  to_char(substr(trim(FREQUENCY),2,2)) else '0' end,
--  SWIFT_FREQ_START_DD             NUMBER(2),
case     when substr(trim(FREQUENCY),0,1) in ('V') then  to_char(substr(trim(FREQUENCY),2,2))
         when substr(trim(FREQUENCY),0,1) in ('S','T','U') then to_char(substr(trim(FREQUENCY),2,2))
         when substr(trim(FREQUENCY),0,1) in ('M','N','O','P','Q','R') then to_char(substr(trim(FREQUENCY),2,2))
         when substr(trim(FREQUENCY),0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then to_char(substr(trim(FREQUENCY),2,2))
         else '0' 
         end,         
--  SWIFT_FREQ_HLDY_STAT            CHAR(1 BYTE),
'N',
--  SWIFT_NEXT_DUE_DATE             DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY')+1,
--  PB_LAST_PRNT_TRAN_ID            VARCHAR2(9 CHAR),
'',
--  PB_LAST_PRNT_PTRAN_NUM          VARCHAR2(4 CHAR),
'',
--  RCRE_USER_ID                    VARCHAR2(15 CHAR),
'',
--  RCRE_TIME                       DATE,
'',
--  LCHG_USER_ID                    VARCHAR2(15 CHAR),
'',
--  LCHG_TIME                       DATE,
'',
--  TS_CNT                          NUMBER(5),
'1',
--  SWFT_MSG_TYPE                   CHAR(1 BYTE),
case when swift_code is not null then 'N' when to_char(account) is not null then 'N' else 'N' end,
--  SWFT_MSG_RCVR_BIC               VARCHAR2(12 CHAR),
case when swift_code is not null then to_char(swift_code) when to_char(account) is not null then to_char(BICCODE) else '' end,
--  PAYSYS_ID                       VARCHAR2(5 CHAR),
case when swift_code is not null then 'SWIFT' when to_char(account) is not null then 'SWIFT' else '' end,
--  DEL_FLG                         CHAR(1 BYTE),
' ',
--  IC_NEXT_DUE_DATE                DATE,
'',
--  PS_DIFF_FREQ_REL_PARTY_FLG      CHAR(1 BYTE),
'N',
--  SWIFT_DIFF_FREQ_REL_PARTY_FLG   CHAR(1 BYTE),
'N',
--  INTRADAY_SWIFT_STMNT_SRL_NUM    NUMBER(5),
'0',
--  INTRADAY_SWIFT_LAST_DATE        DATE,
'',
--  GENERATE_STMNT_UNCONDITIONALLY  CHAR(1 BYTE),
'N',
--  BANK_ID                         VARCHAR2(8 CHAR),
'',
--  PS_FREQ_CAL_BASE                VARCHAR2(2 CHAR)
''
from map_acc
inner join  scpf  on leg_branch_id||leg_scan||leg_Scas=scab||scan||scas
inner join tbaadm.gsp on gsp.schm_code=map_acc.schm_code and bank_id='01'
left join (select * from map_cif where del_flg<>'Y' and is_joint<>'Y' ) map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
left join (select distinct GFCUS,GFCLC,SWIFT_CODE from swift_code2) swift on nvl(trim(swift.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(swift.gfcus)=map_cif.gfcus
left join kwt_swift on leg_branch_id||leg_Scan||leg_scas= trim(account)
inner join tbaadm.gam on foracid=fin_acc_num
where map_acc.schm_type in ('SBA','ODA','CAA','PCA') and scai30 <> 'Y'    ;
commit;
DELETE from custom_statement_table where rowid not in (select min(rowid) from custom_statement_table group by acid );
commit;
exit; 
