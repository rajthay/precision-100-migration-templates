-- File Name        : core01.sql
-- File Created for    : Upload file for SBA and CAA
-- Created By        : Kumaresan.B
-- Client            : ABK
-- Created On        : 25-05-2011
-------------------------------------------------------------------
TRUNCATE TABLE FREETEXT;
INSERT INTO FREETEXT(ACID,FREE_TEXT_3,FREE_TEXT_4) 
SELECT DISTINCT FIN_ACC_NUM,START_DATE,END_DATE FROM BEAM_MEMOPAD
     INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=TRIM(CUST_ACCT)
  WHERE (FIN_ACC_NUM,CREATE_DATE) IN( SELECT  FIN_ACC_NUM,MAX(CREATE_DATE)  CREATE_DATE FROM (
                                       SELECT DISTINCT FIN_ACC_NUM,CREATE_DATE FROM BEAM_MEMOPAD
                                                INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=TRIM(CUST_ACCT)
                                        WHERE UPPER(NOTE) LIKE '%FAX%' and SCHM_TYPE!='OOO'
                                       ) GROUP BY FIN_ACC_NUM
                                    )
    AND  UPPER(NOTE) LIKE '%FAX%' and  SCHM_TYPE!='OOO' ;
  COMMIT;
   DELETE FROM FREETEXT WHERE ACID IN(
 SELECT ACID FROM FREETEXT GROUP BY ACID HAVING COUNT(*)>1
 ) AND FREE_TEXT_5 IS NULL;
 COMMIT;
drop table chqbk;
create table chqbk as
select distinct DTABC,DTANC,DTASC from dtpf;
create index chqbk_idx on chqbk(DTABC,DTANC,DTASC);
--drop table acct_addr_type;
--create table acct_addr_type as
--select distinct syab||syan||syas leg_acc_num,syseq,addr_type from ret_addr_step2
--inner join sypf on svseq=syseq
--inner join map_acc on syab=leg_branch_id and leg_scan=syan and syas=leg_scas
--where schm_type in('SBA','CAA','ODA','PCA') and trim(syprim) is null  and trim(sxprim) is null ;
--create index acct_addr_idx on acct_addr_type(leg_acc_num);
drop table swift_code1;
create table swift_code1 as
select sxseq seq ,sxcus gfcus,sxclc gfclc,SVSWB||SVCNAS||SVSWL||SVSWBR swift_code from svpf
left join sxpf on sxseq=svseq
where trim(SVSWB||SVCNAS||SVSWL) is not null and SXSEQ is not null
union all
select svseq,gfcus,gfclc,SVSWB||SVCNAS||SVSWL||SVSWBR swift_code  from svpf
left join sxpf on sxseq=svseq
left join sypf on syseq=svseq
left join gfpf on gfcpnc=syan  
where trim(SVSWB||SVCNAS||SVSWL) is not null and SXSEQ is null;
drop table swift_code2;
create table swift_code2 as
select corp.seq,corp.GFCUS,corp.gfclc,nvl(BIC,SWIFT_CODE) SWIFT_CODE from swift_code1 corp
left join (select gfpf.GFCUS,gfpf.GFCLC,gfpf.GFCUN,cust.CMNE Treasury_cpty_Mnemonic,BIC from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on trim(map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC) = trim(gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC) and map_cif.INDIVIDUAL='N'
where cust.cmne not like 'AE%')opic on nvl(trim(corp.gfclc),' ')=nvl(trim(opic.gfclc),' ') and  trim(corp.gfcus)=trim(opic.gfcus);
truncate table AC1SBCA_O_TABLE;
insert into AC1SBCA_O_TABLE 
select distinct 
--   v_Account_Number             CHAR(16)
            rpad(fin_acc_num,16,' '),
--   v_With_holding_tax_flg        CHAR(1)
            rpad('N',1,' '),
--Withholding tax Amount scope flag
            lpad(' ',1,' '),
--   v_With_holding_tax_percent        CHAR(8)
            lpad(' ',8,' '),
--   v_With_holding_tax_floor_limit    CHAR(17)
            lpad(' ',17,' '),
--   v_CIF_ID                 CHAR(32)
            rpad(map_acc.fin_cif_id,32,' '),
--   v_Customer_Cr_Pref_Percent        CHAR(10)
            lpad(' ',10,' '),
--   v_Customer_Dr_Pref_Percent        CHAR(10)
            lpad(' ',10,' '),
--   v_Account_Cr_Pref_Percent         CHAR(10) ~!@
            --lpad(to_number(nvl(crdiff.D5DRAR,0) + nvl(crbase.D4BRAR,0) + nvl(s5ratc,0) + nvl(S5RTMC,0)),10,' '),
    --There are some accounts with negative preferentail after arriving the difference in net interest rate by base to interest table code, hence removing abs()
          --lpad(nvl(abs(CR_PREF_RATE),0),10,' '),
    -- lpad(nvl((CR_PREF_RATE),0),10,' '),
     --lpad(case when TO_number(CR_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(CR_PREF_RATE) else to_char(nvl(CR_PREF_RATE,0)) end,10,' ')
     lpad(nvl(TO_CHAR(CR_PREF_RATE,'fm990.0999999'),0),10,' '),
--   v_Account_Dr_Pref_Percent        CHAR(10) ~!@
            --lpad(to_number(nvl(drdiff.D5DRAR,0) + nvl(drbase.D4BRAR,0) + nvl(s5ratd,0) + nvl(S5RTMD,0)),10,' '),
            --lpad(nvl(case when nvl(dr_pref_rate,0) < 0 then
--nvl(dr_base_rate,0) + nvl(diff_dr_rate,0)+ nvl(dr_margin_rate,0) 
--nvl(dr_pref_rate,0)
--else nvl(dr_pref_rate,0) end,0),10,' '),
lpad(nvl(TO_CHAR(dr_pref_rate,'fm990.0999999'),0),10,' '),
--   v_Channel_Cr_Pref             CHAR(10)
            lpad(' ',10,' '),
--   v_Channel_Dr_Pref             CHAR(10)
            lpad(' ',10,' '),
--   v_Pegged_Flag             CHAR(1)
            'N',
--   v_Peg_Frequency_in_Mnth        CHAR(4)
            lpad(' ',4,' '),
--   v_Peg_Frequency_in_Days        CHAR(3)
            lpad(' ',3,' '),
--   v_Int_freq_type_Credit        CHAR(1) -- ~!@     
           case  when get_param('BANK_ID')='02' and map_acc.schm_code in('SCALC','CANOS') and trim(S5IFQC) is null then  'M'
           --when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
           --when map_acc.currency='CHF' and scbal > 0 then lpad(' ',1,' ') ------ based on spira id 6206 and vijay confirmation on 20-08-2017 changed--based on discussion with vijay and Niraj on 29-08-2017-CHF int paid flag update will be in post migration script
           when trim(S5IFQC) is not null then lpad(MapFrequency(substr(trim(S5IFQC),1,1)),1,' ') 
           when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null then gsp.INT_FREQ_TYPE_CR --added in Mock3B based on scheme validation Infosys request
           else lpad(' ',1,' ') end,
--   v_Int_freq_week_num_Credit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_week_day_Credit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_start_dd_Credit        CHAR(2) ~!@          
         --case when trim(S5IFQC) is not null and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D' 
         --then lpad(substr(trim(S5IFQC),2,2),2,' ') 
         --else lpad(' ',2,' ') end,
         case 
         when get_param('BANK_ID')='02' and map_acc.schm_code in('SCALC','CANOS') and trim(S5IFQC) is null then substr(get_param('NEXT_CR_INT_RDT'),1,2)
         --when trim(S5IFQC) is not null and S5NCDC='9999999' and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  then    substr(get_param('NEXT_CR_INT_RDT'),1,2)
         --when trim(S5IFQC) is not null and S5NCDC<>'9999999' and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D' then    substr(to_char(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),'DD-MM-YYYY'),1,2) 
         --when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',2,' ')---based on karthick and Vijay confirmation added
         --when map_acc.currency='CHF' and scbal > 0 then lpad(' ',2,' ') ------ based on spira id 6206 and vijay confirmation on 20-08-2017 changed--based on discussion with vijay and Niraj on 29-08-2017-CHF int paid flag update will be in post migration script
         when trim(S5IFQC)='V31' then '31'
         when trim(S5IFQC) is not null and S5NCDC='9999999' and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  then '31'
         when trim(S5IFQC) is not null and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D' then lpad(substr(trim(S5IFQC),2,2),2,' ') ---above two lines commented and uncommented this line on 27-03-2017. based on spira issue 5632
         --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null then to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         --then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(gsp.INT_FREQ_TYPE_CR)),'DD') --added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='D' then '00'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='M' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='Q' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR)is not null and trim(INT_FREQ_TYPE_CR)='H' then '31' --added in Mock3B based on scheme validation Infosys request
         else lpad(' ',2,' ') end,
--  v_Int_freq_hldy_stat_Credit        CHAR(1)     
        case
        when get_param('BANK_ID')='02' and map_acc.schm_code in('SCALC','CANOS') and trim(S5IFQC) is null then 'N'
        --when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',1,' ')---based on karthick and Vijay confirmation added
        --when map_acc.currency='CHF' and scbal > 0 then ' ' ------ based on spira id 6206 and vijay confirmation on 20-08-2017 changed--based on discussion with vijay and Niraj on 29-08-2017-CHF int paid flag update will be in post migration script
        when trim(S5IFQC) is not null then 'N'
        when INT_PAID_FLG='Y' then 'N'
        else ' ' end,
--  v_Next_Cr_interest_run_date        CHAR(10)  ~!@ 
        case when get_param('BANK_ID')='02' and map_acc.schm_code in('SCALC','CANOS') and trim(S5IFQC) is null then get_param('NEXT_CR_INT_RDT')
        --when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',10,' ')---based on karthick and Vijay confirmation added
        --when map_acc.currency='CHF' and scbal > 0 then lpad(' ',10,' ') ------ based on spira id 6206 and vijay confirmation on 20-08-2017 changed--based on discussion with vijay and Niraj on 29-08-2017-CHF int paid flag update will be in post migration script
        when trim(MapFrequency(substr(trim(S5IFQC),1,1)))='D'  and S5NCDC='9999999' then get_param('NEXT_CR_INT_RDT_DAILY') 
        when trim(MapFrequency(substr(trim(S5IFQC),1,1)))='D'  and S5NCDC<>'9999999' then lpad(to_char(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  and S5NCDC='9999999'  then get_param('NEXT_CR_INT_RDT')
        when trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  and S5NCDC<>'9999999' and S5NCDC <> 0 and get_date_fm_btrv(S5NCDC) <> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  and S5NCDC<>'9999999' and S5NCDC = 0 and get_date_fm_btrv(S5NCDC) = 'ERROR'  then get_param('NEXT_CR_INT_RDT')
        when trim(S5IFQC) is not null then  lpad(get_param('NEXT_CR_INT_RDT'),10,' ')
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null then to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
        --then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(gsp.INT_FREQ_TYPE_CR)),'DD-MM-YYYY') --added in Mock3B based on scheme validation Infosys request
        when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null  then  to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(trim(gsp.INT_FREQ_TYPE_CR))),'DD-MM-YYYY')--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null and INT_FREQ_TYPE_CR='M' then '28-02-2017'--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null and INT_FREQ_TYPE_CR='Q' then '31-03-2017'--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null and INT_FREQ_TYPE_CR='H' then '30-06-2017' --added in Mock3B based on scheme validation Infosys request 
        else  lpad(' ',10,' ')end,-----changed on 09-04-17 by alavudeen based on gopal mail dt 05-04-2017
        --else  lpad(get_param('NEXT_CR_INT_RDT'),10,' ')end,-----changed on 12-3-17 by gopal for migration
--   v_Int_freq_type_Debit        CHAR(1) ~!@ 
       case  when get_param('BANK_ID')='02' and map_acc.schm_code in('CANOS','CAVOS')  and trim(S5IFQD) is null then  'M'
       --when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
       when trim(S5IFQD) is not null then lpad(MapFrequency(substr(trim(S5IFQD),1,1)),1,' ') 
       when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null then gsp.INT_FREQ_TYPE_DR --added in Mock3B based on scheme validation Infosys request
       else lpad(' ',1,' ') end,
--   v_Int_freq_week_num_Debit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_week_day_Debit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_start_dd_Debit        CHAR(2) ~!@
         case   when get_param('BANK_ID')='02' and map_acc.schm_code in('CANOS','CAVOS') and trim(S5IFQD) is null then substr(get_param('NEXT_DR_INT_RDT'),1,2) 
         --when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',2,' ') ---based on karthick and Vijay confirmation added
         when trim(S5IFQD)='V31' then '31'
         when trim(S5IFQD) is not null and S5NCDD='9999999' and trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D' then  '31'
         when trim(S5IFQD) is not null and S5NCDD<>'9999999' and trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D'
         then    substr(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
         --when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null then to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         --then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(trim(gsp.INT_FREQ_TYPE_DR))),'DD') --added in Mock3B based on scheme validation Infosys request
         when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null and trim(INT_FREQ_TYPE_DR)='D' then '00'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null and trim(INT_FREQ_TYPE_DR)='M' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null and trim(INT_FREQ_TYPE_DR)='Q' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null and trim(INT_FREQ_TYPE_DR)='H' then '31' --added in Mock3B based on scheme validation Infosys request 
         else lpad(' ',2,' ') end,
--   v_Int_freq_hldy_stat_Debit        CHAR(1)
            --nvl(gsp.INT_FREQ_HLDY_STAT_DR,' '),
        case 
        when get_param('BANK_ID')='02' and map_acc.schm_code in('CANOS','CAVOS') and trim(S5IFQD) is null then 'N'
        --when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
        when trim(S5IFQD) is not null  then 'N'
        when  INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null  then 'N'
        else ' ' end,
-- v_Next_Debit_interest_run_dt        CHAR(10)
        case when get_param('BANK_ID')='02' and map_acc.schm_code in('CANOS','CAVOS') and trim(S5IFQD) is null then get_param('NEXT_DR_INT_RDT')
        --when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',10,' ') ---based on karthick and Vijay confirmation added
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))='D'  and S5NCDD='9999999' then get_param('NEXT_DR_INT_RDT_DAILY') 
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))='D'  and S5NCDD<>'9999999'  then lpad(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when trim(trim(MapFrequency(substr(trim(S5IFQD),1,1))))<>'D'  and S5NCDD='9999999'  then get_param('NEXT_DR_INT_RDT')
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D'  and S5NCDD<>'9999999' and S5NCDD <> 0 and get_date_fm_btrv(S5NCDD) <> 'ERROR'
        then lpad(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D'  and S5NCDD<>'9999999' and S5NCDD = 0 and get_date_fm_btrv(S5NCDD) = 'ERROR' 
        then get_param('NEXT_DR_INT_RDT')
        when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null  then  to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
        then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(trim(gsp.INT_FREQ_TYPE_DR))),'DD-MM-YYYY')--added in Mock3B based on scheme validation Infosys request
        else  lpad(' ',10,' ')end,
--   v_Ledger_Number            CHAR(3)
            lpad(' ',3,' '),
--   v_Employee_Id            CHAR(10)
            lpad(' ',10,' '),
--  v_Account_Open_Date            CHAR(10)
    case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')          
         else lpad(' ',10,' ')
    end,
--   v_Mode_of_Operation_Code        CHAR(5)            
            case when trim(SCAIC7)='Y' then lpad('006',5,' ')
                 when trim(scai92)='Y' then lpad('011',5,' ')
            else lpad('999',5,' ') end,
--   v_Gl_Sub_Head_Code            CHAR(5)
            --lpad(case when past.acc_num is not null then nvl(PD_GL_SUB_HEAD_CODE,' ') else nvl(map_acc.GL_SUB_HEADCODE,' ') end,5,' '), ---changed on 06-03-17 based on 02-03-17 vijay mail
            lpad(nvl(map_acc.GL_SUB_HEADCODE,' '),5,' '), ---changed on 05-07-2017. BASED DISCUSSION BETWEEN MATHEW AND VIJAY.
--   v_Scheme_Code             CHAR(5)
            lpad(map_acc.SCHM_CODE,5,' '),
--   v_Cheque_Allowed_Flag        CHAR(1) ~!@
            --case when  dtabc is not null and dtanc is not null  and dtasc is not null then 'Y' else 'N' end,            
            case when r4ab is not null then 'Y' when  dtabc is not null then 'Y' else nvl(trim(CHQ_ALWD_FLG),'N') end, --As per Vijay and Sandeep confirmation script changed on 06-01-2017 during mock5 execution.
--  v_Pass_Book_Pass_Sheet_Code        CHAR(1)
           case 
           when map_acc.schm_code in ('SBGER','SBDAL','SBKID') and get_param('BANK_ID')='01' then 'B' --Statement should be "Both" for these scheme,changed based on email from Vijay on 2-May-2017
           when get_param('BANK_ID')='01' and scpf.scaiG6='Y' then 'N'
           when get_param('BANK_ID')='02' and scpf.scaid4='Y'  then 'N' 
           when get_param('BANK_ID')='02' and scpf.scaif0='Y'  then 'P' 
           else  'S' end,
--   v_Freeze_Code             CHAR(1) ~!@
     case  when map_acc.schm_code='PICA' then 'T' --- changed on 20-12-2016 based on nancy,hiyam and darin meeting discussion confirmation
          when get_param('BANK_ID')='01' and trim(scc5r)is not null and trim(scc5r) in ('AL','BK','BW','CF','DC','DD','DE','DF','DG','DL','DT','DW','LA','LC','RA','RB','RC','UL','UM','US','UT','UV','UX','WA','WC','XX','017','020','081','083','084','085','093','097','161','164','LG','LH','LP','LR','NL','PL','LE','LD','LI') then  'T' --'LD added based on 05-09-2017 nagi mail to vijay spira id 7982 --based on 07-09-2017 nagi mail  WL,IF and SL removed
          when get_param('BANK_ID')='02' and trim(scc5r)is not null and trim(scc5r) in ('BK','BW','CF','DC','DD','DE','DF','DG','DL','DT','DW','IF','LA','LC','RA','RB','RC','UL','UM','US','UT','UV','UX','WA','WC','017','020','081','083','084','085','093','097','161','164','LP','WL','SL','PL','NL') then  'T'
          when trim(scc5r)is not null and trim(scc5r) in ('BM','BN','BP','012','095') then  'D'--'AL','BL removed based on 05-09-2017 nagi mail to vijay spira id 7982
          when trim(scc5r)is not null and trim(scc5r) in ('011','096') then  'C'
          when SCAI93='Y' then 'T' ----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          --when SCAI92='Y' then 'T' ----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          when trim(SCAI17)='Y' then 'T' ----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          when SCAI95='Y' then 'D'           
          --when SCAI81='Y' then 'T' -- changed on 16-01-2017 as per Vijay Confirmation ----based on 07-09-2017 nagi mail  WL and SL removed
          when SCAI83='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAI84='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAIG4='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          when get_param('BANK_ID')='02' and SCAI14='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          When get_param('BANK_ID')='02' and map_acc.schm_code='CAAA' and leg_acct_type in ('DL','DM','DN') then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          else ' ' end,    
-- v_Freeze_Reason_Code             CHAR(5) ~!@
     case  when map_acc.schm_code='PICA' then rpad('LI',5,' ') --- changed on 20-12-2016 based on nancy,hiyam and darin meeting discussion confirmation
          when trim(scc5r)is not null and trim(scc5r) = 'AL' then  rpad('AL',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'BK' then  rpad('BK',5,' ')
          --when trim(scc5r)is not null and trim(scc5r) = 'BL' then  rpad('BL',5,' ') --'BL removed based on 05-09-2017 nagi mail to vijay spira id 7982
          when trim(scc5r)is not null and trim(scc5r) = 'BM' then  rpad('BM',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'BN' then  rpad('BN',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'BP' then  rpad('BP',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'BW' then  rpad('BW',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'CF' then  rpad('CF',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DC' then  rpad('DC',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DD' then  rpad('DD',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DE' then  rpad('DE',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DF' then  rpad('DF',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DG' then  rpad('DG',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DL' then  rpad('DL',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DT' then  rpad('DT',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DW' then  rpad('DW',5,' ')
          --when trim(scc5r)is not null and trim(scc5r) = 'IF' then  rpad('IF',5,' ') --removed based on 05-09-2017 nagi mail to vijay spira id 7982
          when trim(scc5r)is not null and trim(scc5r) = 'LA' then  rpad('LA',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LC' then  rpad('LC',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LD' then  rpad('LD',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LE' then  rpad('LE',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LI' then  rpad('LI',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'RA' then  rpad('RA',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'RB' then  rpad('RB',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'RC' then  rpad('RC',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'UL' then  rpad('UL',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'UM' then  rpad('UM',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'US' then  rpad('US',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'UT' then  rpad('UT',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'UV' then  rpad('UV',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'UX' then  rpad('UX',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'WA' then  rpad('WA',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'WC' then  rpad('WC',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'XX' then  rpad('XX',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LG' then  rpad('LG',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LH' then  rpad('LH',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LP' then  rpad('LP',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LR' then  rpad('LR',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'NL' then  rpad('NL',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'PL' then  rpad('PL',5,' ')
          --when trim(scc5r)is not null and trim(scc5r) = 'SL' then  rpad('SL',5,' ') --based on 07-09-2017 nagi mail  WL and SL removed
          --when trim(scc5r)is not null and trim(scc5r) = 'WL' then  rpad('WL',5,' ') --based on 07-09-2017 nagi mail  WL and SL removed
          when trim(scc5r)is not null and trim(scc5r) = '011' then  rpad('011',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '012' then  rpad('012',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '017' then  rpad('017',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '020' then  rpad('020',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '081' then  rpad('081',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '083' then  rpad('083',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '084' then  rpad('084',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '085' then  rpad('085',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '093' then  rpad('093',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '095' then  rpad('095',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '096' then  rpad('096',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '097' then  rpad('097',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '161' then  rpad('161',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '164' then  rpad('164',5,' ')
          when SCAI93='Y' then rpad('093',5,' ') ----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          --when SCAI92='Y' then rpad('092',5,' ') ----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          when SCAI17='Y' then rpad('017',5,' ')  ----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017         
          when SCAI95='Y' then rpad('095',5,' ')  ----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          --when SCAI81='Y' then rpad('081',5,' ') -- changed on 16-01-2017 as per Vijay Confirmation --based on 07-09-2017 nagi mail  WL and SL removed
          when SCAI83='Y' then rpad('083',5,' ') -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAI84='Y' then rpad('084',5,' ') -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAIG4='Y' then rpad('164',5,' ') -- changed on 06-01-2017 as per Vijay Confirmation
          when get_param('BANK_ID')='02' and SCAI14='Y' then rpad('DL',5,' ') -- changed on 06-01-2017 as per Vijay Confirmation
          When map_acc.schm_code='CAAA' and leg_acct_type in ('DL','DM','DN') then rpad('AA',5,' ') -- changed on 06-01-2017 as per Vijay Confirmation
          else rpad(' ',5,' ') end,
--  v_Free_Text                 CHAR(240)
            lpad(' ' ,240,' '),
--   v_Account_Dormant_Flag        CHAR(1)
      case when scai85 = 'Y' and get_param('BANK_ID')= '01' then 'D'
      when scai94 = 'Y' and get_param('BANK_ID')= '02' then 'D'
           when scai20 = 'Y' then 'I'                           
           else 'A' end,
--   v_Free_Code_1            CHAR(5)
            lpad(' ',5,' '),
            --lpad(case when scaij4='Y' then 'Y' else ' ' end,5,' '),--- based on Hiyam and Vijay requirement on CHANGE SIGNATURE REQ condition added on 30-07-2017--- as per sandeep requirement on 20-08-2017 changed to Free_code 7
--   v_Free_Code_2            CHAR(5)
            case when free.acid is not null then lpad('Y',5,' ') else lpad(' ',5,' ') end,
--   v_Free_Code_3            CHAR(5)--Mandatory Field          
      lpad('999',5,' '),
--   v_Free_Code_4            CHAR(5)
            lpad(' ',5,' '),            
--   v_Free_Code_5            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_6            CHAR(5)
            --lpad( case when map_acc.schm_code <> 'CAALT' and scaij3='Y' then 'Y' else ' ' end,5,' '),--- Based on MK5b issue discussion with vijay and sandeep on 20-08-2017 legacy all inactive and active tajer status need to migrate
            lpad( case when scaij3='Y' then 'Y' 
            when scaij2='Y' then 'N' 
            else ' ' end,5,' '),
--   v_Free_Code_7            CHAR(5)
            lpad(case when scaij4='Y' then 'Y' else ' ' end,5,' '),--- based on Hiyam and Vijay requirement on CHANGE SIGNATURE REQ condition added on 30-07-2017--- as per sandeep requirement on 20-08-2017 changed from Free_code 1
--   v_Free_Code_8            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_9            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_10            CHAR(5)            
             lpad(' ',5,' '),             
--   v_Interest_Table_Code        CHAR(5) 
            --lpad(nvl(inte.INT_TBL_CODE,' '),5,' '),
            lpad(case 
            --when trim(s5pf.s5trcc) ='ZERO' and  trim(s5pf.s5trcd) ='ZERO' then 'ZEROA'
            when inte.INT_TBL_CODE is not null then inte.INT_TBL_CODE
            else nvl(csp.INT_TBL_CODE,'ZEROA') end,5,' '),
--lpad(nvl(
--case when dr_pref_rate < 0 then inte.TBL_CODE_MIGR --'ZEROA'
--when inte.TBL_CODE_MIGR is not null then inte.TBL_CODE_MIGR
--else csp.INT_TBL_CODE end,' ') ,5,' '), -- commented on 12-Apr as this was repeated error in earlier mocks.
--   v_Account_Location_Code        CHAR(5)
            rpad(' ',5,' '),
--   v_Currency_Code             CHAR(3)            
            lpad(scccy,3,' '),
--   v_Service_Outlet             CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_Account_Mgr_User_Id        CHAR(15)            
 rpad( case when nrd.officer_code is not null and trim(nrd.loginid) is not null then to_char(trim(nrd.loginid))
when trim(scpf.scaco)='199' then '199_RBD'
 else nvl(convert_codes('RMCODE',trim(scpf.scaco)),'UBSADMIN') end,15,' '), -- changed on 06-01-2017 as per Vijay Confirmation
--   v_Account_Name             CHAR(80)
            rpad(regexp_replace(SCSHN,'[\,/]',''),80,' '),
--  v_Swift_Allowed_Flg             CHAR(1)
        case when swift_code is not null then 'Y' else 'N' end,----------changed on 08-01-2017 as per sandeep confirmation on Mock5 migration
--   v_Last_Transaction_Date        CHAR(8)
--     case when ext_acc is not null and to_date(modify_date,'DD-MON-YY')=to_date('23-06-2003','DD-MM-YYYY') and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null then to_char(add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12),'DD-MM-YYYY')
          --when ext_acc is null and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null  then to_char(add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12),'DD-MM-YYYY')
          --when ext_acc is not null  and trim(modify_date) is not null  then to_char(add_months(to_date(modify_date,'DD-MON-YY'),-12),'DD-MM-YYYY')
          --when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
           --lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        --else lpad(' ',10,' ')    end,  -----Changed on 27-sep-2017 , after discussion with vijay and new data provided by srini
		case when ext_acc is not null and to_date(modify_date,'DD-MON-YY')=to_date('23-06-2003','DD-MM-YYYY') and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null and add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12),'DD-MM-YYYY')
          when ext_acc is null and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null  and add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12),'DD-MM-YYYY')
          when ext_acc is not null  and trim(modify_date) is not null   and add_months(to_date(modify_date,'DD-MON-YY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(modify_date,'DD-MON-YY'),-12),'DD-MM-YYYY')
          when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
           lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        else lpad(' ',10,' ')
    end,
--  v_Last_Transaction_any_date        CHAR(8)      
       case when ext_acc is not null and to_date(modify_date,'DD-MON-YY')=to_date('23-06-2003','DD-MM-YYYY') and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null and add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12),'DD-MM-YYYY')
          when ext_acc is null and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null  and add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12),'DD-MM-YYYY')
          when ext_acc is not null  and trim(modify_date) is not null   and add_months(to_date(modify_date,'DD-MON-YY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(modify_date,'DD-MON-YY'),-12),'DD-MM-YYYY')
          when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
           lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        else lpad(' ',10,' ')
    end,
--   v_Exclude_for_combined_stateme    CHAR(1)
            lpad(' ',1,' '),
--   v_Statement_CIF_ID             CHAR(32)
            lpad(' ',32,' '),
--  v_Charge_Level_Code             CHAR(5)
            lpad(' ',5,' '),
-- v_PBF_download_Flag             CHAR(1)
            'N',
--   v_wtax_level_flg             CHAR(1)
           lpad(' ',1,' '),
--   v_Sanction_Limit             CHAR(17)
case when scodl <> 0 then lpad(abs(scodl)/power(10,c8ced),17,' ') else  lpad(' ',17,' ') end,
--   v_Drawing_Power             CHAR(17)--need  clarification
case when scodl <> 0 then lpad(abs(scodl)/power(10,c8ced),17,' ') else  lpad(' ',17,' ') end,
--   v_DACC_ABSOLUTE_LIMIT        CHAR(17)
            lpad(' ',17,' '),
-- v_DACC_PERCENT_LIMIT             CHAR(8)
            lpad(' ',8,' '),
--   v_Maximum_Allowed_Limit        CHAR(17)
            --lpad(9999999999999999/power(10,c8ced),17,' '),
            lpad(' ',17,' '),
--   v_Health_Code             CHAR(5)
            --lpad('1',5,' '),
            lpad(case when SCAIG7='N' and  SCAIJ6='N' then '1'
when SCAIG7='N' and  SCAIJ6='Y' then '2'
when SCAIG7='Y' and  SCAIJ6='N' then '4'
when SCAIG7='Y' and  SCAIJ6='Y' then '5'
else '1' end,5,' '),-----BASED ON VIJAY MAIL DATED 10-07-2017 script changed
--Sanction Level Code
            lpad(' ',5,' '),
--Sanction Reference Number
            lpad(' ',25,' '),
--   v_Limit_Sanction_Date        CHAR(8)
            lpad(' ',10,' '),
--   v_Limit_Expiring_Date        CHAR(8)--need  clarification
    case when scled <> 0 and get_date_fm_btrv(SCLED) <> 'ERROR' and scodl <> 0 then
        lpad(to_char(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
          else lpad(' ',10,' ')
        end,    
--   v_Account_Review_Date        CHAR(8)
            lpad(' ',10,' '),
--   v_Loan_Paper_Date             CHAR(8)
            lpad(' ',10,' '),
--   v_Sanction_Authority_Code        CHAR(5)
            lpad(' ',5,' '),
-- v_Last_Compound_date             CHAR(8)
            lpad(' ',10,' '),
--   v_Daily_compounding_of_int_fla    CHAR(1)
            lpad(' ',1,' '),
-- v_Comp_rest_day_flag             CHAR(1)
            lpad(' ',1,' '),
--   v_Use_discount_rate_flg        CHAR(1)
            lpad(' ',1,' '),
--   v_Dummy                 CHAR(100)
            lpad(' ',100,' '),
--   v_Account_status_date        CHAR(8)         
          case when ext_acc is not null and to_date(modify_date,'DD-MON-YY')=to_date('23-06-2003','DD-MM-YYYY') and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null 
and to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY') >= case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end
then to_char(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),'DD-MM-YYYY')
          when ext_acc is null and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null 
          and to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY') >= case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end
          then to_char(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),'DD-MM-YYYY')
          when ext_acc is not null and trim(modify_date) is not null  and to_date(modify_date,'DD-MON-YY') >= case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(to_date(modify_date,'DD-MON-YY'),'DD-MM-YYYY')
          when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
          when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')          
        else lpad(' ',10,' ')
    end,
--   v_Iban_number             CHAR(34)--need  clarification
            lpad(nvl(map_acc.iban_number,' '),34,' '),
--   v_Ias_code                 CHAR(5)
            lpad(' ',5,' '),
-- v_channel_id                 CHAR(5)
            lpad(' ',5,' '),
-- v_channel_level_code             CHAR(5)
            lpad(' ',5,' '),
--   v_int_suspense_amt             CHAR(17)
            --case when past.acc_num is not null then lpad(nvl(abs(SUSPENCE_AMT),0),17,' ') else lpad(' ',17,' ') end, ---changed on 06-03-17 based on 02-03-17 vijay mail
             lpad(' ',17,' '), --commented on  19-07-2017 based on discussion with vijay and natraj. commented because in legacy int susp. amt applied in equation --uncommented on 11-09-2017 based on vijay confirmation
            -- case when past.acc_num is not null then lpad(to_char(nvl(iis.amt,0)),17,' ') else lpad(' ',17,' ') end, ---based on discussion with vijay on 06-08-2017 script changed-----commented on 11-09-2017 based on vijay confirmation
--   v_penal_int_suspense_amt        CHAR(17)
            lpad('0',17,' '),
--   v_chrge_off_flg             CHAR(1)
            lpad(' ',1,' '),
--   v_pd_flg                 CHAR(1)
            --case when past.acc_num is not null then 'Y' else 'N' end, ---changed on 06-03-17 based on 02-03-17 vijay mail---commented on 11-09-2017 based on vijay confirmation
            lpad('N',1,' '),
--   v_pd_xfer_date             CHAR(8)
            --case when past.acc_num is not null then to_char(to_date(pass_due_dt,'YYYYMMDD'),'DD-MM-YYYY') else lpad(' ',10,' ') end, ---changed on 06-03-17 based on 02-03-17 vijay mail---commented on 11-09-2017 based on vijay confirmation
            lpad(' ',10,' '),
--   v_chrge_off_date             CHAR(8)
            lpad(' ',10,' '),
--   v_chrge_off_principal        CHAR(17)
            lpad(' ',17,' '),
--   v_pending_interest             CHAR(17)
            lpad(' ',17,' '),
-- v_principal_recovery             CHAR(17)
            lpad(' ',17,' '),
-- v_interest_recovery             CHAR(17)
            lpad(' ',17,' '),
--   v_charge_off_type             CHAR(1)
            lpad(' ',1,' '),
--   v_Master_acct_num             CHAR(16)
            lpad(' ',16,' '),
-- v_ps_diff_freq_rel_party_flg        CHAR(1)--need  clarification
            lpad(' ',1,' '),
--   v_swift_diff_freq_rel_party_fl    CHAR(1)
            lpad(' ',1,' '),
--   v_Address_Type             CHAR(12)
--    rpad(case --when addr.ADDR_TYPE is not null and trim(addr_type)='Add6' then to_char('Add'|| to_char(addr_num+1))  --- Add6 validation removed becuase sanjay given confirmation on 19-04-2017 for not to migrate.
--         when addr.ADDR_TYPE is not null  and addr.addr_type<>'Prime' then addr.ADDR_TYPE  else case when map_cif.individual='Y' then 'Mailing' else 'Registered' end end,12,' '),
    rpad(case when addr_ret.leg_acc_num is not null  then to_char(addr_ret.addresscategory)
    when addr_corp.leg_acc_num is not null   then to_char(addr_corp.addresscategory)  
    when map_cif.individual='Y' then 'Mailing'
    else 'Registered'  end,12,' '), --- changed 07-06-2017 as per cif address type changes 
-- v_Phone_Type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_Type                 CHAR(12)   
            lpad(' ',12,' '),
--   v_Alternate_Account_Name        CHAR(80)
            lpad(' ',80,' '),
--   v_Interest_Rate_Period_Months    CHAR(4)
            lpad(' ',4,' '),
-- v_Interest_Rate_Period_Days         CHAR(3)
            lpad(' ',3,' '),
--   v_Interpolation_Method         CHAR(1)
            lpad(' ',1,' '),
--   v_Is_Account_hedged_Flag         CHAR(1)
            lpad(' ',1,' '),
-- v_Used_for_netting_off_flag         CHAR(1)
            lpad(' ',1,' '),
-- v_Security_Indicator             CHAR(10)
            lpad(' ',10,' '),
--   v_Debt_Security             CHAR(1)
            lpad(' ',1,' '),
--   v_Security_Code             CHAR(8)
            lpad(' ',8,' '),
--   Debit_int_Method            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--  Service_Chrge_Coll_Flg        VARCHAR2(1) NUL
            lpad('Y',1,' '),
--   Last_Purge_Date                VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   Total_Profit_Amt              VARCHAR2(17) NULL
            lpad('0',17,' '),
--   Min_Age_Not_Met_Amt            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Br_Per_Prof_Paid_Flg            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--   Br_Per_Prof_Paid_Amt            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Prof_To_Be_Recovered            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Prof_Distr_Upto_Date            VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   Nxt_Profit_Distr_Date        VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   unclaim_status            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--   unclaim_status_date            VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   orig_gl_sub_head_code        VARCHAR2(16) NUL
            lpad(' ',16,' ')
    from map_acc
    inner join scpf  on scab=map_acc.leg_branch_id and scan=leg_scan and scas=leg_scas
    inner join c8pf  on c8ccy = scccy
    left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
    left join  chqbk on dtabc=scab and dtanc=scan and dtasc=scas
    left join r4pf on r4ab=leg_branch_id and r4an=leg_scan and r4as=leg_scas
    left join acct_interest_tbl inte on inte.s5ab=scab and inte.s5an=scan and inte.s5as=scas 
    left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
    --left join acct_addr_type addr on addr.leg_acc_num=scab||scan||scas
    left join acct_addr_type_ret addr_ret on addr_ret.leg_acc_num=scab||scan||scas
    left join acct_addr_type_corp addr_corp on addr_corp.leg_acc_num=scab||scan||scas
    left join (select distinct GFCUS,GFCLC,SWIFT_CODE from swift_code2) swift on nvl(trim(swift.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(swift.gfcus)=map_cif.gfcus
    --left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'Y' group by schm_code)gss  on map_acc.schm_code = gss.schm_code
    --left join (select * from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'Y')gss  on map_acc.schm_code = gss.schm_code
    --left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'N' group by schm_code)gss1  on map_acc.schm_code = gss1.schm_code
    left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code =map_acc.CURRENCY     
    left join (select *  from tbaadm.gsp   where bank_id = get_param('BANK_ID') and del_flg = 'N')gsp on  map_acc.schm_code = gsp.schm_code
    --left join custom_dpd on map_acc.fin_acc_num=trim(acc_num)
    left join (select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from ret_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id
    union 
    select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from corp_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id) cntr on cntr.fin_cif_id=map_acc.fin_cif_id 
    left join (select acc_num,past_due_flg,suspence_amt,min(PASS_DUE_DT) PASS_DUE_DT from  (
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LBD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where to_number(LP10_LMT_C)=0 
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LXD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0 and LP10_LED <> 0
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt,to_char( to_number(LP10_LGR_K)-to_number(LP10_LMT_K)) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXCESS' and to_number(LP10_LMT_C)<> 0)
    group by acc_num,past_due_flg,suspence_amt)past on fin_acc_num=trim(acc_num)
    left join Acc_dormant  on lpad(trim(ext_Acc),13,0)=fin_acc_num
    left join dormant_acc on  leg_branch_id||leg_scan||leg_scas=dormant_acc.scab||dormant_acc.scan||dormant_acc.scas--code changed for dormant account from Excel file based on the email from Vijay on 17-May-2017,Code chage date on 21/May 
    left join freetext free on map_acc.fin_acc_num=free.acid
    left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
    left join iis_account iis on map_acc.fin_acc_num=account
    where map_acc.schm_type in( 'SBA','CAA') and map_acc.schm_code<>'PISLA';
commit;
---DEAL to CAA---
insert into AC1SBCA_O_TABLE 
select distinct 
--   v_Account_Number             CHAR(16)
            rpad(fin_acc_num,16,' '),
--   v_With_holding_tax_flg        CHAR(1)
            rpad('N',1,' '),
--Withholding tax Amount scope flag
            lpad(' ',1,' '),
--   v_With_holding_tax_percent        CHAR(8)
            lpad(' ',8,' '),
--   v_With_holding_tax_floor_limit    CHAR(17)
            lpad(' ',17,' '),
--   v_CIF_ID                 CHAR(32)
            rpad(map_acc.fin_cif_id,32,' '),
--   v_Customer_Cr_Pref_Percent        CHAR(10)
            lpad(' ',10,' '),
--   v_Customer_Dr_Pref_Percent        CHAR(10)
            lpad(' ',10,' '),
--   v_Account_Cr_Pref_Percent         CHAR(10) ~!@
            --lpad(to_number(nvl(crdiff.D5DRAR,0) + nvl(crbase.D4BRAR,0) + nvl(s5ratc,0) + nvl(S5RTMC,0)),10,' '),
            lpad(nvl(abs(CR_PREF_RATE),0),10,' '),
--   v_Account_Dr_Pref_Percent        CHAR(10) ~!@
            --lpad(to_number(nvl(drdiff.D5DRAR,0) + nvl(drbase.D4BRAR,0) + nvl(s5ratd,0) + nvl(S5RTMD,0)),10,' '),
            lpad(nvl(case when dr_pref_rate < 0 then
dr_base_rate + diff_dr_rate+ dr_margin_rate else dr_pref_rate end,0),10,' '),
--   v_Channel_Cr_Pref             CHAR(10)
            lpad(' ',10,' '),
--   v_Channel_Dr_Pref             CHAR(10)
            lpad(' ',10,' '),
--   v_Pegged_Flag             CHAR(1)
            'N',
--   v_Peg_Frequency_in_Mnth        CHAR(4)
            lpad(' ',4,' '),
--   v_Peg_Frequency_in_Days        CHAR(3)
            lpad(' ',3,' '),
--   v_Int_freq_type_Credit        CHAR(1) -- ~!@     
          case  when get_param('BANK_ID')='02' and map_acc.schm_code='SCALC' and trim(S5IFQC) is null then  'M'
           --when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
           when trim(S5IFQC) is not null then lpad(MapFrequency(substr(trim(S5IFQC),1,1)),1,' ')
           when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null then gsp.INT_FREQ_TYPE_CR --added in Mock3B based on scheme validation Infosys request           
           else lpad(' ',1,' ') end,
--   v_Int_freq_week_num_Credit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_week_day_Credit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_start_dd_Credit        CHAR(2) ~!@          
         case 
         when get_param('BANK_ID')='02' and map_acc.schm_code='SCALC' and trim(S5IFQC) is null then substr(get_param('NEXT_CR_INT_RDT'),1,2)
         --when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',2,' ') ---based on karthick and Vijay confirmation added
         --when trim(S5IFQC) is not null and S5NCDC='9999999' and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  then    substr(get_param('NEXT_CR_INT_RDT'),1,2)
         --when trim(S5IFQC) is not null and S5NCDC<>'9999999' and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D' then    substr(to_char(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
         when trim(S5IFQC) is not null and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D' then lpad(substr(trim(S5IFQC),2,2),2,' ') ---above two lines commented and uncommented this line on 27-03-2017. based on spira issue 5632 send by sandeep
         --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null then to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         --then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(gsp.INT_FREQ_TYPE_CR)),'DD') --added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='D' then '00'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='M' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='Q' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='H' then '31' --added in Mock3B based on scheme validation Infosys request
         else lpad(' ',2,' ') end,
--  v_Int_freq_hldy_stat_Credit        CHAR(1)     
         case 
          when trim(S5IFQC) is not null then 'N'
          --when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
          when INT_PAID_FLG='Y' then 'N'
        else ' ' end,
--  v_Next_Cr_interest_run_date        CHAR(10)  ~!@ 
        case when get_param('BANK_ID')='02' and map_acc.schm_code='SCALC' and trim(S5IFQC) is null then get_param('NEXT_CR_INT_RDT')
        when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',10,' ') ---based on karthick and Vijay confirmation added
        when trim(MapFrequency(substr(trim(S5IFQC),1,1)))='D'  and S5NCDC='9999999' then get_param('NEXT_CR_INT_RDT_DAILY') 
        when trim(MapFrequency(substr(trim(S5IFQC),1,1)))='D'  and S5NCDC<>'9999999' then lpad(to_char(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  and S5NCDC='9999999'  then get_param('NEXT_CR_INT_RDT')
        when trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  and S5NCDC<>'9999999' and S5NCDC <> 0 and get_date_fm_btrv(S5NCDC) <> 'ERROR'
        then lpad(to_char(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  and S5NCDC<>'9999999' and S5NCDC = 0 and get_date_fm_btrv(S5NCDC) = 'ERROR' 
        then get_param('NEXT_CR_INT_RDT')
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null then to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
        --then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(gsp.INT_FREQ_TYPE_CR)),'DD-MM-YYYY') --added in Mock3B based on scheme validation Infosys request
        when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null  then  to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(trim(gsp.INT_FREQ_TYPE_CR))),'DD-MM-YYYY')--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null and INT_FREQ_TYPE_CR='M' then '28-02-2017'--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null and INT_FREQ_TYPE_CR='Q' then '31-03-2017'--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null and INT_FREQ_TYPE_CR='H' then '30-06-2017' --added in Mock3B based on scheme validation Infosys request 
        else  lpad(' ',10,' ')end,-- was blank, changed by gopal on 12-3-17
--   v_Int_freq_type_Debit        CHAR(1) ~!@ 
       case  when get_param('BANK_ID')='02' and map_acc.schm_code in('CANVOS','CAVOS')  and trim(S5IFQD) is null then  'M'
       --when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
       when trim(S5IFQD) is not null then 
       lpad(MapFrequency(substr(trim(S5IFQD),1,1)),1,' ')
       when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null then gsp.INT_FREQ_TYPE_DR --added in Mock3B based on scheme validation Infosys request       
       else lpad(' ',1,' ') end,
--   v_Int_freq_week_num_Debit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_week_day_Debit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_start_dd_Debit        CHAR(2) ~!@
         case   when get_param('BANK_ID')='02' and map_acc.schm_code in('CANVOS','CAVOS') and trim(S5IFQD) is null then substr(get_param('NEXT_DR_INT_RDT'),1,2) 
         --when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',2,' ') ---based on karthick and Vijay confirmation added
         when trim(S5IFQD) is not null and S5NCDD='9999999' and trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D'
         then    substr(get_param('NEXT_DR_INT_RDT'),1,2)         
         when trim(S5IFQD) is not null and S5NCDD<>'9999999' and trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D'
         then    substr(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
         --when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null then to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         --then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(trim(gsp.INT_FREQ_TYPE_DR))),'DD') --added in Mock3B based on scheme validation Infosys request
         when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null and trim(INT_FREQ_TYPE_DR)='D' then '00'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null and trim(INT_FREQ_TYPE_DR)='M' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null and trim(INT_FREQ_TYPE_DR)='Q' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null and trim(INT_FREQ_TYPE_DR)='H' then '31' --added in Mock3B based on scheme validation Infosys request 
         else lpad(' ',2,' ') end,
--   v_Int_freq_hldy_stat_Debit        CHAR(1)
            --nvl(gsp.INT_FREQ_HLDY_STAT_DR,' '),
        case 
        when get_param('BANK_ID')='02' and map_acc.schm_code in('CANVOS','CAVOS') and trim(S5IFQD) is null then 'N'
        --when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
        when trim(S5IFQD) is not null  then 'N'
        when INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null  then 'N'
        else ' ' end,
-- v_Next_Debit_interest_run_dt        CHAR(10)
        case when get_param('BANK_ID')='02' and map_acc.schm_code in('CANVOS','CAVOS') and trim(S5IFQD) is null then get_param('NEXT_DR_INT_RDT')
        --when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',10,' ') ---based on karthick and Vijay confirmation added
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))='D'  and S5NCDD='9999999' then get_param('NEXT_DR_INT_RDT_DAILY') 
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))='D'  and S5NCDD<>'9999999'  then lpad(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when trim(trim(MapFrequency(substr(trim(S5IFQD),1,1))))<>'D'  and S5NCDD='9999999'  then get_param('NEXT_DR_INT_RDT')
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D'  and S5NCDD<>'9999999' and S5NCDD <> 0 and get_date_fm_btrv(S5NCDD) <> 'ERROR'
        then lpad(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D'  and S5NCDD<>'9999999' and S5NCDD = 0 and get_date_fm_btrv(S5NCDD) = 'ERROR'
        then get_param('NEXT_DR_INT_RDT')
        --when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null then to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
        --then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(trim(gsp.INT_FREQ_TYPE_DR))),'DD-MM-YYYY') --added in Mock3B based on scheme validation Infosys requests
        when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null  then  to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
        then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(trim(gsp.INT_FREQ_TYPE_DR))),'DD-MM-YYYY')--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_COLL_FLG='Y' and INT_FREQ_TYPE_DR is not null and INT_FREQ_TYPE_DR='M' then '28-02-2017'--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_COLL_FLG='Y' and INT_FREQ_TYPE_DR is not null and INT_FREQ_TYPE_DR='Q' then '31-03-2017'--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_COLL_FLG='Y' and INT_FREQ_TYPE_DR is not null and INT_FREQ_TYPE_DR='H' then '30-06-2017' --added in Mock3B based on scheme validation Infosys request
        else  lpad(' ',10,' ')end,
--   v_Ledger_Number            CHAR(3)
            lpad(' ',3,' '),
--   v_Employee_Id            CHAR(10)
            lpad(' ',10,' '),
--  v_Account_Open_Date            CHAR(10)
    case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')          
         else lpad(' ',10,' ')
    end,
--   v_Mode_of_Operation_Code        CHAR(5)            
            case when SCAIC7='Y' then lpad('006',5,' ')
                 when scai92='Y' then lpad('011',5,' ')
            else lpad('999',5,' ') end,
--   v_Gl_Sub_Head_Code            CHAR(5)
            lpad(nvl(map_acc.GL_SUB_HEADCODE,' '),5,' '),
--   v_Scheme_Code             CHAR(5)
            lpad(map_acc.SCHM_CODE,5,' '),
--   v_Cheque_Allowed_Flag        CHAR(1) ~!@
            --case when  dtabc is not null and dtanc is not null  and dtasc is not null then 'Y' else 'N'  end,            
            case when r4ab is not null then 'Y' else CHQ_ALWD_FLG end, --As per Vijay and Sandeep confirmation script changed on 06-01-2017 during mock5 execution.
--  v_Pass_Book_Pass_Sheet_Code        CHAR(1)
            case when get_param('BANK_ID')='01' and scpf.scaiG6='Y' then 'N'
            else 'S' end,
--   v_Freeze_Code             CHAR(1) ~!@
     case  when map_acc.schm_code='PICA' then 'T' --- changed on 20-12-2016 based on nancy,hiyam and darin meeting discussion confirmation
          when trim(scc5r)is not null and trim(scc5r) in ('AL','BK','BW','CF','DC','DD','DE','DF','DG','DL','DT','DW','IF','LA','LC','RA','RB','RC','UL','UM','US','UT','UV','UX','WA','WC','XX','LD','017','017','020','081','083','084','085','093','097','161','164','LG','LH','LP','LR','NL','PL','LD') then  'T' --'LD added based on 05-09-2017 nagi mail to vijay spira id 7982) then  'T' --LD added based on 05-09-2017 nagi mail to vijay spira id 7982 --based on 07-09-2017 nagi mail  WL and SL removed
          when trim(scc5r)is not null and trim(scc5r) in ('BM','BN','BP','012','095') then  'D' --'AL','BL,LD removed based on 05-09-2017 nagi mail to vijay spira id 7982
          when trim(scc5r)is not null and trim(scc5r) in ('011','096') then  'C'
          when SCAI93='Y' then 'T'
          --when SCAI92='Y' then 'T'
          when SCAI17='Y' then 'T'
          when SCAI95='Y' then 'D'        
          --when SCAI81='Y' then 'T' -- changed on 16-01-2017 as per Vijay Confirmation --based on 07-09-2017 nagi mail  WL and SL removed
          when SCAI83='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAI84='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAIG4='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation          
          else ' ' end,    
-- v_Freeze_Reason_Code             CHAR(5) ~!@
     case 
     when map_acc.schm_code='PICA' then ' ' --- changed on 20-12-2016 based on nancy,hiyam and darin meeting discussion confirmation
          when trim(scc5r)is not null and trim(scc5r) = 'AL' then  rpad('AL',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'BK' then  rpad('BK',5,' ')
          --when trim(scc5r)is not null and trim(scc5r) = 'BL' then  rpad('BL',5,' ') --'BL removed based on 05-09-2017 nagi mail to vijay spira id 7982
          when trim(scc5r)is not null and trim(scc5r) = 'BM' then  rpad('BM',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'BN' then  rpad('BN',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'BP' then  rpad('BP',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'BW' then  rpad('BW',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'CF' then  rpad('CF',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DC' then  rpad('DC',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DD' then  rpad('DD',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DE' then  rpad('DE',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DF' then  rpad('DF',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DG' then  rpad('DG',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DL' then  rpad('DL',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DT' then  rpad('DT',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'DW' then  rpad('DW',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'IF' then  rpad('IF',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LA' then  rpad('LA',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LC' then  rpad('LC',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LD' then  rpad('LD',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'RA' then  rpad('RA',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'RB' then  rpad('RB',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'RC' then  rpad('RC',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'UL' then  rpad('UL',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'UM' then  rpad('UM',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'US' then  rpad('US',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'UT' then  rpad('UT',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'UV' then  rpad('UV',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'UX' then  rpad('UX',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'WA' then  rpad('WA',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'WC' then  rpad('WC',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'XX' then  rpad('XX',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LG' then  rpad('LG',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LH' then  rpad('LH',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LP' then  rpad('LP',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'LR' then  rpad('LR',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'NL' then  rpad('NL',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = 'PL' then  rpad('PL',5,' ')
          --when trim(scc5r)is not null and trim(scc5r) = 'SL' then  rpad('SL',5,' ') --based on 07-09-2017 nagi mail  WL and SL removed
          --when trim(scc5r)is not null and trim(scc5r) = 'WL' then  rpad('WL',5,' ') --based on 07-09-2017 nagi mail  WL and SL removed
          when trim(scc5r)is not null and trim(scc5r) = '011' then  rpad('011',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '012' then  rpad('012',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '017' then  rpad('017',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '020' then  rpad('020',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '081' then  rpad('081',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '083' then  rpad('083',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '084' then  rpad('084',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '085' then  rpad('085',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '093' then  rpad('093',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '095' then  rpad('095',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '096' then  rpad('096',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '097' then  rpad('097',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '161' then  rpad('161',5,' ')
          when trim(scc5r)is not null and trim(scc5r) = '164' then  rpad('164',5,' ')
          when SCAI93='Y' then rpad('093',5,' ')
          --when SCAI92='Y' then rpad('XX',5,' ')
          when SCAI17='Y' then rpad('017',5,' ')          
          when SCAI95='Y' then rpad('095',5,' ')
          --when SCAI81='Y' then rpad('081',5,' ') -- changed on 16-01-2017 as per Vijay Confirmation --based on 07-09-2017 nagi mail  WL and SL removed
          when SCAI83='Y' then rpad('083',5,' ') -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAI84='Y' then rpad('084',5,' ') -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAIG4='Y' then rpad('164',5,' ') -- changed on 06-01-2017 as per Vijay Confirmation
          else rpad(' ',5,' ') end,
--  v_Free_Text                 CHAR(240)
            lpad(' ' ,240,' '),
--   v_Account_Dormant_Flag        CHAR(1)
      case when scai85 = 'Y' and get_param('BANK_ID')= '01' then 'D'
      when scai94 = 'Y' and get_param('BANK_ID')= '02' then 'D'
           when scai20 = 'Y' then 'I'                           
           else 'A' end,
--   v_Free_Code_1            CHAR(5)
            lpad(case when scaij4='Y' then 'Y' else ' ' end,5,' '),
--   v_Free_Code_2            CHAR(5)
            --lpad(' ',5,' '),
            case when free.acid is not null then lpad('Y',5,' ') else lpad(' ',5,' ') end, --added based on the requirement for Fax indenminty
--   v_Free_Code_3            CHAR(5)--Mandatory Field          
      lpad('999',5,' '),
--   v_Free_Code_4            CHAR(5)
            lpad(' ',5,' '),            
--   v_Free_Code_5            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_6            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_7            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_8            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_9            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_10            CHAR(5)            
             lpad(' ',5,' '),             
--   v_Interest_Table_Code        CHAR(5) 
            --lpad(nvl(inte.INT_TBL_CODE,' '),5,' '),
--            lpad(case when inte.INT_TBL_CODE is not null then inte.INT_TBL_CODE
--            else csp.INT_TBL_CODE end,5,' '),
lpad(nvl(case 
--when trim(s5pf.s5trcc) ='ZERO' and  trim(s5pf.s5trcd) ='ZERO' then 'ZEROA'
when dr_pref_rate < 0 then 'ZEROA'
when inte.INT_TBL_CODE is not null then inte.INT_TBL_CODE
else nvl(csp.INT_TBL_CODE,'ZEROA') end,' ') ,5,' '),
--   v_Account_Location_Code        CHAR(5)
            rpad(' ',5,' '),
--   v_Currency_Code             CHAR(3)            
            lpad(scccy,3,' '),
--   v_Service_Outlet             CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_Account_Mgr_User_Id        CHAR(15)            
  rpad( case when nrd.officer_code is not null and trim(nrd.loginid) is not null then to_char(trim(nrd.loginid))
when trim(scpf.scaco)='199' then '199_RBD'
  else nvl(convert_codes('RMCODE',trim(scpf.scaco)),'UBSADMIN') end,15,' '), -- changed on 06-01-2017 as per Vijay Confirmation
--   v_Account_Name             CHAR(80)
            rpad(regexp_replace(SCSHN,'[\,/]',''),80,' '),
--  v_Swift_Allowed_Flg             CHAR(1)
            case when swift_code is not null then 'Y' else 'N' end,----------changed on 08-01-2017 as per sandeep confirmation on Mock5 migration
--   v_Last_Transaction_Date        CHAR(8)
     case when ext_acc is not null and to_date(modify_date,'DD-MON-YY')=to_date('23-06-2003','DD-MM-YYYY') and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null and add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12),'DD-MM-YYYY')
          when ext_acc is null and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null  and add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12),'DD-MM-YYYY')
          when ext_acc is not null  and trim(modify_date) is not null   and add_months(to_date(modify_date,'DD-MON-YY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(modify_date,'DD-MON-YY'),-12),'DD-MM-YYYY')
          when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
           lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        else lpad(' ',10,' ')
    end,
--  v_Last_Transaction_any_date        CHAR(8)      
       case when ext_acc is not null and to_date(modify_date,'DD-MON-YY')=to_date('23-06-2003','DD-MM-YYYY') and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null and add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12),'DD-MM-YYYY')
          when ext_acc is null and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null  and add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),-12),'DD-MM-YYYY')
          when ext_acc is not null  and trim(modify_date) is not null   and add_months(to_date(modify_date,'DD-MON-YY'),-12) >=  
case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(modify_date,'DD-MON-YY'),-12),'DD-MM-YYYY')
          when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
           lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        else lpad(' ',10,' ')
    end,
--   v_Exclude_for_combined_stateme    CHAR(1)
            lpad(' ',1,' '),
--   v_Statement_CIF_ID             CHAR(32)
            lpad(' ',32,' '),
--  v_Charge_Level_Code             CHAR(5)
            lpad(' ',5,' '),
-- v_PBF_download_Flag             CHAR(1)
            'N',
--   v_wtax_level_flg             CHAR(1)
           lpad(' ',1,' '),
--   v_Sanction_Limit             CHAR(17)
          -- lpad(-1*scodl/power(10,c8ced),17,' '),
           lpad(abs(scodl)/power(10,c8ced),17,' '),
--   v_Drawing_Power             CHAR(17)--need  clarification
            --lpad(-1*scodl/power(10,c8ced),17,' '),
            lpad(abs(scodl)/power(10,c8ced),17,' '),
--   v_DACC_ABSOLUTE_LIMIT        CHAR(17)
            lpad(' ',17,' '),
-- v_DACC_PERCENT_LIMIT             CHAR(8)
            lpad(' ',8,' '),
--   v_Maximum_Allowed_Limit        CHAR(17)
            --lpad(9999999999999999/power(10,c8ced),17,' '),
            lpad(' ',17,' '),
--   v_Health_Code             CHAR(5)
            --lpad(' ',5,' '),
            lpad(case when SCAIG7='N' and  SCAIJ6='N' then '1'
when SCAIG7='N' and  SCAIJ6='Y' then '2'
when SCAIG7='Y' and  SCAIJ6='N' then '4'
when SCAIG7='Y' and  SCAIJ6='Y' then '5'
else '1' end,5,' '),-----BASED ON VIJAY MAIL DATED 10-07-2017 script changed
--Sanction Level Code
            lpad(' ',5,' '),
--Sanction Reference Number
            lpad(' ',25,' '),
--   v_Limit_Sanction_Date        CHAR(8)
            lpad(' ',10,' '),
--   v_Limit_Expiring_Date        CHAR(8)--need  clarification
    case when scled <> 0 and get_date_fm_btrv(SCLED) <> 'ERROR' then
        lpad(to_char(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
          else lpad(' ',10,' ')
        end,    
--   v_Account_Review_Date        CHAR(8)
            lpad(' ',10,' '),
--   v_Loan_Paper_Date             CHAR(8)
            lpad(' ',10,' '),
--   v_Sanction_Authority_Code        CHAR(5)
            lpad(' ',5,' '),
-- v_Last_Compound_date             CHAR(8)
            lpad(' ',10,' '),
--   v_Daily_compounding_of_int_fla    CHAR(1)
            lpad(' ',1,' '),
-- v_Comp_rest_day_flag             CHAR(1)
            lpad(' ',1,' '),
--   v_Use_discount_rate_flg        CHAR(1)
            lpad(' ',1,' '),
--   v_Dummy                 CHAR(100)
            lpad(' ',100,' '),
--   v_Account_status_date        CHAR(8)         
        case when ext_acc is not null and to_date(modify_date,'DD-MON-YY')=to_date('23-06-2003','DD-MM-YYYY') and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null 
and to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY') >= case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end
then to_char(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),'DD-MM-YYYY')
          when ext_acc is null and trim(ACCOUNT_NUMBER_EXT) is not null and trim(LAST_DORMANCY_DATE) is not null 
          and to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY') >= case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end
          then to_char(to_date(LAST_DORMANCY_DATE,'MM-DD-YYYY'),'DD-MM-YYYY')
          when ext_acc is not null and trim(modify_date) is not null  and to_date(modify_date,'DD-MON-YY') >= case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(to_date(modify_date,'DD-MON-YY'),'DD-MM-YYYY')
          when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
          when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')          
        else lpad(' ',10,' ')
    end,
--   v_Iban_number             CHAR(34)--need  clarification
            lpad(nvl(map_acc.iban_number,' '),34,' '),
--   v_Ias_code                 CHAR(5)
            lpad(' ',5,' '),
-- v_channel_id                 CHAR(5)
            lpad(' ',5,' '),
-- v_channel_level_code             CHAR(5)
            lpad(' ',5,' '),
--   v_int_suspense_amt             CHAR(17)
            lpad(' ',17,' '),
--   v_penal_int_suspense_amt        CHAR(17)
            lpad(' ',17,' '),
--   v_chrge_off_flg             CHAR(1)
            lpad(' ',1,' '),
--   v_pd_flg                 CHAR(1)
            --case when acc_num is not null then 'Y' else 'N' end,
            'N',
--   v_pd_xfer_date             CHAR(8)
            --case when acc_num is not null then to_char(to_date(excess_since,'MM/DD/YYYY'),'DD-MM-YYYY') else lpad(' ',10,' ') end,
            lpad(' ',10,' '),
--   v_chrge_off_date             CHAR(8)
            lpad(' ',10,' '),
--   v_chrge_off_principal        CHAR(17)
            lpad(' ',17,' '),
--   v_pending_interest             CHAR(17)
            lpad(' ',17,' '),
-- v_principal_recovery             CHAR(17)
            lpad(' ',17,' '),
-- v_interest_recovery             CHAR(17)
            lpad(' ',17,' '),
--   v_charge_off_type             CHAR(1)
            lpad(' ',1,' '),
--   v_Master_acct_num             CHAR(16)
            lpad(' ',16,' '),
-- v_ps_diff_freq_rel_party_flg        CHAR(1)--need  clarification
            lpad(' ',1,' '),
--   v_swift_diff_freq_rel_party_fl    CHAR(1)
            lpad(' ',1,' '),
--   v_Address_Type             CHAR(12)
--    rpad(case  --when addr.ADDR_TYPE is not null and trim(addr_type)='Add6' then to_char('Add'|| to_char(addr_num+1))   --- Add6 validation removed becuase sanjay given confirmation on 19-04-2017 for not to migrate.
       --when addr.ADDR_TYPE is not null and addr.addr_type<>'Prime' then addr.ADDR_TYPE      --else case when map_cif.individual='Y' then 'Mailing'      else 'Registered' end end,12,' '),
           rpad(case when addr_ret.leg_acc_num is not null  then to_char(addr_ret.addresscategory)
    when addr_corp.leg_acc_num is not null   then to_char(addr_corp.addresscategory)  
    when map_cif.individual='Y' then 'Mailing'
    else 'Registered'  end,12,' '), --- changed 07-06-2017 as per cif address type changes 
-- v_Phone_Type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_Type                 CHAR(12)   
            lpad(' ',12,' '),
--   v_Alternate_Account_Name        CHAR(80)
            lpad(' ',80,' '),
--   v_Interest_Rate_Period_Months    CHAR(4)
            lpad(' ',4,' '),
-- v_Interest_Rate_Period_Days         CHAR(3)
            lpad(' ',3,' '),
--   v_Interpolation_Method         CHAR(1)
            lpad(' ',1,' '),
--   v_Is_Account_hedged_Flag         CHAR(1)
            lpad(' ',1,' '),
-- v_Used_for_netting_off_flag         CHAR(1)
            lpad(' ',1,' '),
-- v_Security_Indicator             CHAR(10)
            lpad(' ',10,' '),
--   v_Debt_Security             CHAR(1)
            lpad(' ',1,' '),
--   v_Security_Code             CHAR(8)
            lpad(' ',8,' '),
--   Debit_int_Method            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--  Service_Chrge_Coll_Flg        VARCHAR2(1) NUL
            lpad('Y',1,' '),
--   Last_Purge_Date                VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   Total_Profit_Amt              VARCHAR2(17) NULL
            lpad('0',17,' '),
--   Min_Age_Not_Met_Amt            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Br_Per_Prof_Paid_Flg            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--   Br_Per_Prof_Paid_Amt            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Prof_To_Be_Recovered            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Prof_Distr_Upto_Date            VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   Nxt_Profit_Distr_Date        VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   unclaim_status            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--   unclaim_status_date            VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   orig_gl_sub_head_code        VARCHAR2(16) NUL
            lpad(' ',16,' ')
from v5pf
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join c8pf  on c8ccy = scccy
left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
left join  chqbk on dtabc=scab and dtanc=scan and dtasc=scas
left join r4pf on r4ab=leg_branch_id and r4an=leg_scan and r4as=leg_scas
left join acct_interest_tbl inte on inte.s5ab=scab and inte.s5an=scan and inte.s5as=scas 
left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
--left join acct_addr_type addr on addr.leg_acc_num=scab||scan||scas
left join (select distinct GFCUS,GFCLC,SWIFT_CODE from swift_code2) swift on nvl(trim(swift.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(swift.gfcus)=map_cif.gfcus
--left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'Y' group by schm_code)gss  on map_acc.schm_code = gss.schm_code
--left join (select * from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'Y')gss  on map_acc.schm_code = gss.schm_code
--left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'N' group by schm_code)gss1  on map_acc.schm_code = gss1.schm_code
left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code =map_acc.CURRENCY     
left join (select *  from tbaadm.gsp   where bank_id = get_param('BANK_ID') and del_flg = 'N')gsp on  map_acc.schm_code = gsp.schm_code
--left join custom_dpd on map_acc.fin_acc_num=trim(acc_num)
left join (select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from ret_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id
union 
select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from corp_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id) cntr on cntr.fin_cif_id=map_acc.fin_cif_id 
left join Acc_dormant  on lpad(trim(ext_Acc),13,0)=fin_acc_num
left join dormant_acc on  leg_branch_id||leg_scan||leg_scas=dormant_acc.scab||dormant_acc.scan||dormant_acc.scas --code changed for dormant account from Excel file based on the email from Vijay on 17-May-2017,Code chage date on 21/May 
left join freetext free on map_acc.fin_acc_num=free.acid
left join acct_addr_type_ret addr_ret on addr_ret.leg_acc_num=scpf.scab||scpf.scan||scpf.scas
left join acct_addr_type_corp addr_corp on addr_corp.leg_acc_num=scpf.scab||scpf.scan||scpf.scas
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
where map_acc.schm_type in('CAA')  and v5pf.v5bal<>0;
commit;
UPDATE AC1SBCA_O_TABLE SET pd_xfer_date=GET_PARAM('EOD_DATE') WHERE TRIM(pd_xfer_date) IS NOT NULL AND TO_DATE(pd_xfer_date,'DD-MM-YYYY') < TO_DATE(Account_Open_Date,'DD-MM-YYYY');
COMMIT;
exit; 
