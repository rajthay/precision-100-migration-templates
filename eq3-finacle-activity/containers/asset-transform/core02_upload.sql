
-- File Name        : Core01.sql
-- File Created for    : Upload file for ODA Accounts
-- Created By        : Kumaresan.B
-- Client            : Emirates Islamic Bank
-- Created On        : 25-05-2015
-------------------------------------------------------------------
--create table sanction_limit as 
--SELECT DISTINCT fin_acc_num sanction_NUM,sum(lcamt/power(10,c8ced))lcamt,max(LCDTEX) LCDTEX FROM MAP_ACC
--INNER JOIN V5PF ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=V5ABD||V5AND||V5ASD
--inner join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
--INNER JOIN LDPF ON LDBRNM||trim(LDDLP)||trim(LDDLR)=V5BRNM||trim(V5DLP)||trim(V5DLR)
--INNER JOIN LcPF ON LCCMR=LDCMR
--inner join C8PF ON C8CCY=CURRENCY
--WHERE SCHM_TYPE='PCA' 
--and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '')
--group by fin_acc_num;
---------------------------------------------
drop table ps_amt;
create table ps_amt as 
select map_acc.fin_acc_num fin_num,sum(to_number((otdla)/POWER(10,c8pf.C8CED))) ds_amt
from map_acc
  inner join v5pf on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas 
  left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  inner join c8pf on c8ccy = otccy
  where map_acc.schm_type='PCA' and map_acc.schm_code='LDADV'
  and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '')
  group by fin_acc_num;
drop table pca_proper;
create table pca_proper as (
select a.* from ompf a 
inner join v5pf on  trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=a.ombrnm||trim(a.omdlp)||trim(a.omdlr)
left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
inner join map_acc on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas
where a.ommvt = 'P' and a.ommvts in ('R','M','U') and schm_type='PCA'
and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '')
);
create index pca_proper_idx on pca_proper(omabf,omanf,omasf);  
drop table pca_ioper;
create table pca_ioper as (
select a.* from ompf a 
inner join v5pf on  trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=a.ombrnm||trim(a.omdlp)||trim(a.omdlr)
left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
inner join map_acc on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas
where a.ommvt = 'I' and (trim(a.ommvts) is null or ommvts='D' ) and schm_type='PCA'
and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '')
);
create index pca_ioper_idx on pca_ioper(omabf,omanf,omasf);  
drop table pca_operacc;
create table pca_operacc as (
select distinct a.*,fin_acc_num,fin_sol_id,currency from (
select distinct a.ombrnm||trim(a.omdlp)||trim(a.omdlr) ompf_leg_num,a.omabf||trim(a.omanf)||trim(a.omasf) oper_leg_acc from pca_proper a
union all
select distinct a.ombrnm||trim(a.omdlp)||trim(a.omdlr) ompf_leg_num,a.omabf||trim(a.omanf)||trim(a.omasf) oper_leg_acc from  pca_ioper a  
)a
inner join map_acc on  leg_branch_id||leg_scan||leg_scas=oper_leg_acc
where schm_type in ('SBA','CAA','ODA'));
create index pca_oper_idx on pca_operacc(ompf_leg_num);  
--------------------------------------------------------
drop table sanction_limit;
create table sanction_limit as 
select sanction_NUM,sum(lcamt) lcamt,max(lcdtex) lcdtex from 
(SELECT DISTINCT fin_acc_num sanction_NUM,lcamt/power(10,c8ced)lcamt,LCDTEX FROM MAP_ACC
INNER JOIN V5PF ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=V5ABD||V5AND||V5ASD
inner join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
INNER JOIN LDPF ON LDBRNM||trim(LDDLP)||trim(LDDLR)=V5BRNM||trim(V5DLP)||trim(V5DLR)
INNER JOIN LcPF ON trim(LCCMR)=trim(LDCMR)
inner join C8PF ON C8CCY=CURRENCY
WHERE SCHM_TYPE='PCA' 
and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = ''))
group by sanction_NUM;
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
truncate table AC1ODCC_O_TABLE;
insert into AC1ODCC_O_TABLE
select distinct 
--   v_Account_Number             CHAR(16)
            rpad(map_acc.fin_acc_num,16,' '),
--   v_With_holding_tax_flg        CHAR(1)
            'N',
--   v_With_holding_tax_Amt_scope_flg    CHAR(1)
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
--   v_Account_Cr_Pref_Percent         CHAR(10)             
            --lpad(nvl(abs(CR_PREF_RATE),0),10,' '),
             lpad(nvl(TO_CHAR(CR_PREF_RATE,'fm990.0999999'),0),10,' '),
--   v_Account_Dr_Pref_Percent        CHAR(10)             
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
--   v_Int_freq_type_Credit        CHAR(1)
         case 
         --when map_acc.currency='CHF' and scbal > 0 then lpad(' ',1,' ') ------ based on spira id 6206 and vijay confirmation on 20-08-2017 changed--based on discussion with vijay and Niraj on 29-08-2017-CHF int paid flag update will be in post migration script
         when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
         when trim(S5IFQC) is not null then  lpad(MapFrequency(substr(trim(S5IFQC),1,1)),1,' ') 
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null then gsp.INT_FREQ_TYPE_CR --added in Mock3B based on scheme validation Infosys request
         else lpad(' ',1,' ') end,
--   v_Int_freq_week_num_Credit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_week_day_Credit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_start_dd_Credit        CHAR(2)
         case 
         --when map_acc.currency='CHF' and scbal > 0 then lpad(' ',2,' ') ------ based on spira id 6206 and vijay confirmation on 20-08-2017 changed--based on discussion with vijay and Niraj on 29-08-2017-CHF int paid flag update will be in post migration script
         when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',2,' ') ---based on karthick and Vijay confirmation added
         --when trim(S5IFQC) is not null and S5NCDC='9999999' and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  then   substr(get_param('NEXT_CR_INT_RDT'),1,2)
         when trim(S5IFQC)='V31' then '31'
         when trim(S5IFQC) is not null and S5NCDC='9999999' and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'  then '31'
         when trim(S5IFQC) is not null and S5NCDC<>'9999999' and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'
         then    substr(to_char(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
         --when trim(S5IFQC) is not null and trim(MapFrequency(substr(trim(S5IFQC),1,1)))<>'D'
         --then lpad(substr(trim(S5IFQC),2,2),2,' ') 
         --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null then to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         --then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(gsp.INT_FREQ_TYPE_CR)),'DD') --added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='D' then '00'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='M' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='Q' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='H' then '31' --added in Mock3B based on scheme validation Infosys request
         else lpad(' ',2,' ') end,
--  v_Int_freq_hldy_stat_Credit        CHAR(1)
          case 
          --when map_acc.currency='CHF' and scbal > 0 then lpad(' ',1,' ') ------ based on spira id 6206 and vijay confirmation on 20-08-2017 changed--based on discussion with vijay and Niraj on 29-08-2017-CHF int paid flag update will be in post migration script
          when trim(s5pf.s5trcc) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
          when trim(S5IFQC) is not null  then 'N'
          when INT_PAID_FLG='Y' then 'N'
        else ' ' end,
--  v_Next_Cr_interest_run_date        CHAR(8)
       case  
       --when map_acc.currency='CHF' and scbal > 0 then lpad(' ',10,' ') ------ based on spira id 6206 and vijay confirmation on 20-08-2017 changed--based on discussion with vijay and Niraj on 29-08-2017-CHF int paid flag update will be in post migration script
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
         then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(gsp.INT_FREQ_TYPE_CR)),'DD-MM-YYYY')--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null and INT_FREQ_TYPE_CR='M' then '28-02-2017'--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null and INT_FREQ_TYPE_CR='Q' then '31-03-2017'--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_PAID_FLG='Y' and INT_FREQ_TYPE_CR is not null and INT_FREQ_TYPE_CR='H' then '30-06-2017' --added in Mock3B based on scheme validation Infosys request 
        else  lpad(' ',10,' ')end,
--   v_Int_freq_type_Debit        CHAR(1)--need to clarification
       case  when get_param('BANK_ID')='02' and map_acc.schm_code='360'  and trim(S5IFQD) is null then  'M'
       WHEN MAP_ACC.SCHM_TYPE='PCA' and trim(S5IFQD) is null then  'M'
       when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
       when trim(S5IFQD) is not null then 
       lpad(MapFrequency(substr(trim(S5IFQD),1,1)),1,' ') 
       when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null then gsp.INT_FREQ_TYPE_DR --added in Mock3B based on scheme validation Infosys request
       else lpad(' ',1,' ') end,
--   v_Int_freq_week_num_Debit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_week_day_Debit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_start_dd_Debit        CHAR(2)--need to clarification
        case   when get_param('BANK_ID')='02' and map_acc.schm_code='360' and trim(S5IFQD) is null then substr(get_param('NEXT_DR_INT_RDT'),1,2) 
        WHEN MAP_ACC.SCHM_TYPE='PCA' and trim(S5IFQD) is null then substr(get_param('NEXT_DR_INT_RDT'),1,2) 
        when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',2,' ') ---based on karthick and Vijay confirmation added
         when trim(S5IFQD)='V31' then '31'
         when trim(S5IFQD) is not null and S5NCDD='9999999' and trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D' then  '31'
         when trim(S5IFQD) is not null and S5NCDD<>'9999999' and trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D'
         then    substr(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
         --when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null then to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         --then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(trim(gsp.INT_FREQ_TYPE_DR))),'DD') --added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='D' then '00'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='M' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='Q' then '31'--added in Mock3B based on scheme validation Infosys request
         when gsp.INT_PAID_FLG='Y' and trim(INT_FREQ_TYPE_CR) is not null and trim(INT_FREQ_TYPE_CR)='H' then '31' --added in Mock3B based on scheme validation Infosys request 
         else lpad(' ',2,' ') end,       
--   v_Int_freq_hldy_stat_Debit        CHAR(1)--need to clarifivation
         --nvl(gsp.INT_FREQ_HLDY_STAT_DR,' '),
        case when get_param('BANK_ID')='02' and map_acc.schm_code='360' and trim(S5IFQD) is null then 'N'
        WHEN MAP_ACC.SCHM_TYPE='PCA' and trim(S5IFQD) is null then 'N'
        when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',1,' ') ---based on karthick and Vijay confirmation added
        when trim(S5IFQD) is not null then 'N'
        when INT_PAID_FLG='Y'  then 'N'
        else ' ' end,
-- v_Next_Debit_interest_run_dt        CHAR(8)            
        case  when get_param('BANK_ID')='02' and map_acc.schm_code='360' and trim(S5IFQD) is null then get_param('NEXT_DR_INT_RDT')
        WHEN MAP_ACC.SCHM_TYPE='PCA' and trim(S5IFQD) is null then get_param('NEXT_DR_INT_RDT')
        when trim(s5pf.s5trcd) ='ZERO' then lpad(' ',10,' ') ---based on karthick and Vijay confirmation added
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))='D'  and S5NCDD='9999999' then get_param('NEXT_DR_INT_RDT_DAILY') 
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))='D'  and S5NCDD<>'9999999'  then lpad(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when trim(trim(MapFrequency(substr(trim(S5IFQD),1,1))))<>'D'  and S5NCDD='9999999'  then get_param('NEXT_DR_INT_RDT')
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D'  and S5NCDD<>'9999999' and S5NCDD <> 0 and get_date_fm_btrv(S5NCDD) <> 'ERROR'
        then lpad(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when trim(MapFrequency(substr(trim(S5IFQD),1,1)))<>'D'  and S5NCDD<>'9999999' and S5NCDD = 0 and get_date_fm_btrv(S5NCDD) = 'ERROR' 
        then get_param('NEXT_DR_INT_RDT')
        --when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null then to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
        --then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(trim(gsp.INT_FREQ_TYPE_DR))),'DD-MM-YYYY') --added in Mock3B based on scheme validation Infosys requests
        when gsp.INT_COLL_FLG='Y' and trim(INT_FREQ_TYPE_DR) is not null then  to_char(si_next_exec_date(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
        then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,to_char(gsp.INT_FREQ_TYPE_DR)),'DD-MM-YYYY')--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_COLL_FLG='Y' and INT_FREQ_TYPE_DR is not null and INT_FREQ_TYPE_DR='M' then '28-02-2017'--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_COLL_FLG='Y' and INT_FREQ_TYPE_DR is not null and INT_FREQ_TYPE_DR='Q' then '31-03-2017'--added in Mock3B based on scheme validation Infosys request
        --when gsp.INT_COLL_FLG='Y' and INT_FREQ_TYPE_DR is not null and INT_FREQ_TYPE_DR='H' then '30-06-2017' --added in Mock3B based on scheme validation Infosys request
        else  lpad(' ',10,' ')end,
--   v_Ledger_Number            CHAR(3)
            lpad(' ',3,' '),
--   v_Employee_Id            CHAR(10)
            lpad(' ',10,' '),
--  v_Account_Open_Date            CHAR(8)
         case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')          
         else lpad(' ',10,' ')
         end,
--   v_Mode_of_Operation_Code        CHAR(5)
        case when SCAIC7='Y' then lpad('006',5,' ')
             when scai92='Y' then lpad('011',5,' ')
        else lpad('999',5,' ') end,
--   v_Gl_Sub_Head_Code            CHAR(5)
             --lpad(case when past.acc_num is not null then nvl(PD_GL_SUB_HEAD_CODE,' ') else nvl(map_acc.GL_SUB_HEADCODE,' ') end,5,' '), ---changed on 06-03-17 based on 02-03-17 vijay mail
             lpad(nvl(map_acc.GL_SUB_HEADCODE,' '),5,' '), ---changed on 05-07-2017. BASED DISCUSSION BETWEEN MATHEW AND VIJAY.
        --rpad(nvl(map_acc.GL_SUB_HEADCODE,' '),5,' '),             
--   v_Scheme_Code             CHAR(5)
            rpad(map_acc.SCHM_CODE,5,' '),
--   v_Cheque_Allowed_Flag        CHAR(1)
         --case when  dtabc is not null and dtanc is not null and dtasc is not null then 'Y'  else 'N'  end,
         case when r4ab is not null then 'Y' when  dtabc is not null then 'Y'  else nvl(trim(CHQ_ALWD_FLG ),'N') end, --As per Vijay and Sandeep confirmation script changed on 06-01-2017 during mock5 execution.
--  v_Pass_Book_Pass_Sheet_Code        CHAR(1)
            case when get_param('BANK_ID')='02' and scpf.scaif0='Y'  then 'P' 
            when get_param('BANK_ID')='02' and scpf.scaid4='Y'  then 'N' 
            else  'S' end, 
--   v_Freeze_Code             CHAR(1) ~!@
          case 
          when get_param('BANK_ID')='01' and trim(scc5r)is not null and trim(scc5r) in ('AL','BK','BW','CF','DC','DD','DE','DF','DG','DL','DT','DW','IF','LA','LC','RA','RB','RC','UL','UM','US','UT','UV','UX','WA','WC','XX','017','020','081','083','084','085','093','097','161','164','LG','LH','LP','LR','NL','PL','LD','LE','LI') then  'T' --'LD added based on 05-09-2017 nagi mail to vijay spira id 7982--based on 07-09-2017 nagi mail  WL and SL removed
          when get_param('BANK_ID')='02' and trim(scc5r)is not null and trim(scc5r) in ('BK','BW','CF','DC','DD','DE','DF','DG','DL','DT','DW','IF','LA','LC','RA','RB','RC','UL','UM','US','UT','UV','UX','WA','WC','017','020','081','083','084','085','093','097','161','164','LP','WL','SL','PL','NL') then  'T'
          when trim(scc5r)is not null and trim(scc5r) in ('BM','BN','BP','012','095') then  'D' --'AL','BL removed based on 05-09-2017 nagi mail to vijay spira id 7982
          when trim(scc5r)is not null and trim(scc5r) in ('011','096') then  'C'
          when SCAI93='Y' then 'T'----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          --when SCAI92='Y' then 'T'----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          when SCAI17='Y' then 'T'----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          when SCAI95='Y' then 'D' ----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          --when SCAI81='Y' then 'T' -- changed on 16-01-2017 as per Vijay Confirmation --based on 07-09-2017 nagi mail  WL and SL removed
          when SCAI83='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAI84='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAIG4='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          when get_param('BANK_ID')='02' and SCAI14='Y' then 'T' -- changed on 06-01-2017 as per Vijay Confirmation
          else ' ' end,
-- v_Freeze_Reason_Code             CHAR(5) ~!@
     rpad(case 
          when trim(scc5r)is not null and trim(scc5r) = 'AL' then  'AL'
          when trim(scc5r)is not null and trim(scc5r) = 'BK' then  'BK'
          --when trim(scc5r)is not null and trim(scc5r) = 'BL' then  'BL'--'BL removed based on 05-09-2017 nagi mail to vijay spira id 7982
          when trim(scc5r)is not null and trim(scc5r) = 'BM' then  'BM'
          when trim(scc5r)is not null and trim(scc5r) = 'BN' then  'BN'
          when trim(scc5r)is not null and trim(scc5r) = 'BP' then  'BP'
          when trim(scc5r)is not null and trim(scc5r) = 'BW' then  'BW'
          when trim(scc5r)is not null and trim(scc5r) = 'CF' then  'CF'
          when trim(scc5r)is not null and trim(scc5r) = 'DC' then  'DC'
          when trim(scc5r)is not null and trim(scc5r) = 'DD' then  'DD'
          when trim(scc5r)is not null and trim(scc5r) = 'DE' then  'DE'
          when trim(scc5r)is not null and trim(scc5r) = 'DF' then  'DF'
          when trim(scc5r)is not null and trim(scc5r) = 'DG' then  'DG'
          when trim(scc5r)is not null and trim(scc5r) = 'DL' then  'DL'
          when trim(scc5r)is not null and trim(scc5r) = 'DT' then  'DT'
          when trim(scc5r)is not null and trim(scc5r) = 'DW' then  'DW'
          when trim(scc5r)is not null and trim(scc5r) = 'IF' then  'IF'
          when trim(scc5r)is not null and trim(scc5r) = 'LA' then  'LA'
          when trim(scc5r)is not null and trim(scc5r) = 'LC' then  'LC'
          when trim(scc5r)is not null and trim(scc5r) = 'LD' then  'LD'
          when trim(scc5r)is not null and trim(scc5r) = 'RA' then  'RA'
          when trim(scc5r)is not null and trim(scc5r) = 'RB' then  'RB'
          when trim(scc5r)is not null and trim(scc5r) = 'RC' then  'RC'
          when trim(scc5r)is not null and trim(scc5r) = 'UL' then  'UL'
          when trim(scc5r)is not null and trim(scc5r) = 'UM' then  'UM'
          when trim(scc5r)is not null and trim(scc5r) = 'US' then  'US'
          when trim(scc5r)is not null and trim(scc5r) = 'UT' then  'UT'
          when trim(scc5r)is not null and trim(scc5r) = 'UV' then  'UV'
          when trim(scc5r)is not null and trim(scc5r) = 'UX' then  'UX'
          when trim(scc5r)is not null and trim(scc5r) = 'WA' then  'WA'
          when trim(scc5r)is not null and trim(scc5r) = 'WC' then  'WC'
          when trim(scc5r)is not null and trim(scc5r) = 'XX' then  'XX'
          when trim(scc5r)is not null and trim(scc5r) = 'LG' then  'LG'
          when trim(scc5r)is not null and trim(scc5r) = 'LH' then  'LH'
          when trim(scc5r)is not null and trim(scc5r) = 'LP' then  'LP'
          when trim(scc5r)is not null and trim(scc5r) = 'LR' then  'LR'
          when trim(scc5r)is not null and trim(scc5r) = 'NL' then  'NL'
          when trim(scc5r)is not null and trim(scc5r) = 'PL' then  'PL'
          --when trim(scc5r)is not null and trim(scc5r) = 'SL' then  'SL' --based on 07-09-2017 nagi mail  WL and SL removed
          --when trim(scc5r)is not null and trim(scc5r) = 'WL' then  'WL' --based on 07-09-2017 nagi mail  WL and SL removed
          when trim(scc5r)is not null and trim(scc5r) = 'LE' then  'LE'
          when trim(scc5r)is not null and trim(scc5r) = 'LI' then  'LI'
          when trim(scc5r)is not null and trim(scc5r) = '011' then  '011'
          when trim(scc5r)is not null and trim(scc5r) = '012' then  '012'
          when trim(scc5r)is not null and trim(scc5r) = '017' then  '017'
          when trim(scc5r)is not null and trim(scc5r) = '020' then  '020'
          when trim(scc5r)is not null and trim(scc5r) = '081' then  '081'
          when trim(scc5r)is not null and trim(scc5r) = '083' then  '083'
          when trim(scc5r)is not null and trim(scc5r) = '084' then  '084'
          when trim(scc5r)is not null and trim(scc5r) = '085' then  '085'
          when trim(scc5r)is not null and trim(scc5r) = '093' then  '093'
          when trim(scc5r)is not null and trim(scc5r) = '095' then  '095'
          when trim(scc5r)is not null and trim(scc5r) = '096' then  '096'
          when trim(scc5r)is not null and trim(scc5r) = '097' then  '097'
          when trim(scc5r)is not null and trim(scc5r) = '161' then  '161'
          when trim(scc5r)is not null and trim(scc5r) = '164' then  '164'
          when SCAI93='Y'then '093'----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          --when SCAI92='Y' then '092'----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          when SCAI17='Y' then '017'----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017
          when SCAI95='Y' then '095'----changed from top of case condition to here. based on Hiyam and Vijay confirmation on 08-08-2017 
          --when SCAI81='Y' then rpad('081',5,' ') -- changed on 16-01-2017 as per Vijay Confirmation --based on 07-09-2017 nagi mail  WL and SL removed
          when SCAI83='Y' then '083' -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAI84='Y' then '084' -- changed on 06-01-2017 as per Vijay Confirmation
          when SCAIG4='Y' then '164' -- changed on 06-01-2017 as per Vijay Confirmation
          when get_param('BANK_ID')='02' and SCAI14='Y' then 'DL' -- changed on 06-01-2017 as per Vijay Confirmation
          else ' ' end,5,' '),
-- v_Free_Text                 CHAR(240)
        lpad(' ',240,' '),
-- v_Account_Dormant_Flag        CHAR(1)
          case when scai85 = 'Y' and get_param('BANK_ID')= '01' then 'D'
      when scai94 = 'Y' and get_param('BANK_ID')= '02' then 'D'
           when scai20 = 'Y' then 'I'                           
           else 'A' end,
--   v_Free_Code_1            CHAR(5)
            lpad(' ',5,' '),
            --lpad(case when scaij4='Y' then 'Y' else ' ' end,5,' '),--- based on Hiyam and Vijay requirement on CHANGE SIGNATURE REQ condition added on 30-07-2017--- as per sandeep requirement on 20-08-2017 changed to Free_code 7
--   v_Free_Code_2            CHAR(5)
            --lpad(' ',5,' '),
            case when freetext.acid is not null then lpad('Y',5,' ') else lpad(' ',5,' ') end, --added for Sharanappa requirement
--   v_Free_Code_3            CHAR(5)
         case when map_acc.schm_type='PCA' then lpad('999',5,' ')
         else lpad(' ',5,' ') end,
--   v_Free_Code_4            CHAR(5)
          lpad(' ',5,' '),            
--   v_Free_Code_5            CHAR(5)         
         lpad(' ',5,' '),
--   v_Free_Code_6            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_7            CHAR(5)
            lpad(case when scaij4='Y' then 'Y' else ' ' end,5,' '),--- based on Hiyam and Vijay requirement on CHANGE SIGNATURE REQ condition added on 30-07-2017--- as per sandeep requirement on 20-08-2017 changed from Free_code 1
--   v_Free_Code_8            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_9            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_10            CHAR(5)            
            rpad(' ',5,' '),
--   v_Interest_Table_Code        CHAR(5)
            --lpad(nvl(case when dr_pref_rate < 0 then inte.TBL_CODE_MIGR --'ZEROA'
--when inte.TBL_CODE_MIGR is not null then inte.TBL_CODE_MIGR
--else csp.INT_TBL_CODE end,' '),5,' '), --commented as there is no tier based interest table code for Kuwait, changed for mock3B on 13-4-2017
lpad(case when inte.INT_TBL_CODE is not null then inte.INT_TBL_CODE else csp.INT_TBL_CODE end,5,' '),
--   v_Account_Location_Code        CHAR(5)
            rpad(' ',5,' '),
--   v_Currency_Code             CHAR(3)            
            rpad(trim(scccy),3,' '),
--   v_Service_Outlet             CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),--As per vijay sir confirmation all the corporate customer sol id will be moved to 603 sol
            --rpad(case when nvl(to_number(trim(scaco)),0)  between 100 and 198  then '603'    else to_char(map_acc.fin_sol_id) end,8,' '),
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
--  --case     when ext_acc is not null then to_char(add_months(to_date(modify_date,'DD-MON-YY'),-12),'DD-MM-YYYY')
    --when scdle <>0 and get_date_fm_btrv(scdle) <> 'ERROR' then
    --       lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
    --    else lpad(' ',10,' ') end,
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
	   --case 
       --when ext_acc is not null then to_char(add_months(to_date(modify_date,'DD-MON-YY'),-12),'DD-MM-YYYY')
       --when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then  lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
       -- else lpad(' ',10,' ') end,
--   v_Exclude_for_combined_statement    CHAR(1)
            lpad(' ',1,' '),
--   v_Statement_CIF_ID             CHAR(32)
            lpad(' ',32,' '),
-- v_Charge_Level_Code             CHAR(5)
            lpad(' ',5,' '),
-- v_PBF_download_Flag             CHAR(1)
            'N',
--   v_wtax_level_flg             CHAR(1)
            lpad(' ',1,' '),
--   v_Sector_Code            CHAR(5)     
            --rpad('H',5,' ')    
          case when get_param('BANK_ID')='02'then rpad(convert_codes('SECTOR_CODE',trim(gf.GFC3R)),5,' ') 
      --else rpad(convert_codes('SECTOR_CODE',trim(gf.GFC2R)),5,' ') end,--changed on 18-11-2016    
      else rpad(convert_codes('SECTOR_CODE',trim(scc2r)),5,' ') end,--changed on 17-08-2017 as per vijay discussion with Sandeep 
          --rpad(convert_codes('SECTOR_CODE',gfpf.GFCA2),5,' '),    
--   v_Sub_Sector_Code             CHAR(5)          
          -- rpad('CM',5,' '),
          case when get_param('BANK_ID')='02' then rpad(nvl(trim(gf.GFC3R),'ZZZ'),5,' ')
          --else rpad(nvl(trim(gf.GFC2R),'ZZZ'),5,' ') end,
          else rpad(nvl(trim(scc2r),'ZZZ'),5,' ') end,--changed on 17-08-2017 as per vijay discussion with Sandeep 
           --rpad(convert_codes('SUB_SECTOR_CODE',gfpf.GFCA2),5,' '),
--   v_Purpose_of_Advn_Code        CHAR(5)            
            case when get_param('BANK_ID')='02' then rpad(nvl(trim(SCC3R),'999'),5,' ')
    else rpad(nvl(trim(SCC2R),'999'),5,' ') end,
--   v_Nature_Of_Advn_Code        CHAR(5)
        rpad('999',5,' '),
-- v_Industry_Type_Code             CHAR(5) --Mandatory field need LOV Mapping         
     rpad(' ',5,' '),--need to get LOV mapping
-- v_Debit_Interest_Account_flg         CHAR(1)
        rpad(case WHEN MAP_ACC.SCHM_TYPE='PCA' and (operative_acc_num is not null or main_fin is not null or oper1.fin_acc_num is not null or pca_num is not null)  then 'O'----  changed from 'S' to 'O' on 31-07-2017 as per mock_fods observation and Niraj requirement.
        when operative_acc_num is not null then 'P' 
        when oper_fin is not null then 'P' 
        when map_acc.schm_code='360' then 'S'
        else ' '  end,1,' '),            
       --  case when operative_acc_num is not null then 'Y' else rpad(' ',1,' ') end,
--   v_Debit_Interest_Account         CHAR(16)
            lpad(case 
            when pca_num is not null then pca_oper_num
            when operative_acc_num is not null then operative_acc_num 
            when main_fin is not null then oper_fin 
            when oper1.fin_acc_num is not null then oper1.fin_acc_num
            else ' '  end,16,' '),            
            --lpad(operative_acc_num,16,' ')
--   v_Sanction_Limit             CHAR(17)
            case 
            when map_acc.schm_type='PCA' and nvl(lcamt,0) < nvl(ps_amt.ds_amt,0) then lpad(nvl(ps_amt.ds_amt,0),17,' ')
			when map_acc.schm_type='PCA' and nvl(lcamt,0) >= nvl(ps_amt.ds_amt,0) then lpad(nvl(lcamt,0),17,' ')
            when scodl <> 0 then lpad(abs(scodl)/power(10,c8ced),17,' ') 
            when map_acc.schm_code ='360' then lpad(abs(scbal)/power(10,c8ced),17,' ')  --changed on 24-01-2017 based on sandeep confirmation due to limit issue
            else  lpad(' ',17,' ') end,
--   v_Drawing_Power             CHAR(17)
            case 
            when map_acc.schm_type='PCA' and nvl(lcamt,0) < nvl(ps_amt.ds_amt,0) then lpad(nvl(ps_amt.ds_amt,0),17,' ')
			when map_acc.schm_type='PCA' and nvl(lcamt,0) >= nvl(ps_amt.ds_amt,0) then lpad(nvl(lcamt,0),17,' ')
            when scodl <> 0 then lpad(abs(scodl)/power(10,c8ced),17,' ') 
            when map_acc.schm_code ='360'  then lpad(abs(scbal)/power(10,c8ced),17,' ')  --changed on 24-01-2017 based on sandeep confirmation due to limit issue
            else  lpad(' ',17,' ') end,
--   v_DACC_ABSOLUTE_LIMIT        CHAR(17)
            lpad(' ',17,' '),
-- v_DACC_PERCENT_LIMIT             CHAR(8)
            lpad(' ',8,' '),
--   v_Maximum_Allowed_Limit        CHAR(17)            
--case when scodl <> 0 then lpad(abs(scodl)/power(10,c8ced),17,' ') 
--when map_acc.schm_code ='360'  then lpad(abs(scbal)/power(10,c8ced),17,' ') else  lpad(' ',17,' ') end, --changed on 24-01-2017 based on sandeep confirmation due to limit issue
lpad(9999999999999999/power(10,c8ced),17,' '),---changed on 22-03-2017-as per vijay mail dt 22-03-2017.
--   v_Health_Code             CHAR(5)--Mandatory need BPD Value
          --  lpad('SICBN',5,' '), --Mock 2 
--            lpad('1',5,' '),
lpad(case when SCAIG7='N' and  SCAIJ6='N' then '1'
when SCAIG7='N' and  SCAIJ6='Y' then '2'
when SCAIG7='Y' and  SCAIJ6='N' then '4'
when SCAIG7='Y' and  SCAIJ6='Y' then '5'
else '1' end,5,' '),-----BASED ON VIJAY MAIL DATED 10-07-2017 script changed
--   v_Sanction_Level_Code        CHAR(5)--Mandatory need BPD Value
        rpad('999',5,' '),
-- v_Sanction_Reference_Number        CHAR(25)
            lpad('1',25,' '),
--   v_Limit_Sanction_Date        CHAR(8)    
    case when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' and scodl <> 0 then
            lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            when map_acc.schm_code ='360' or map_acc.schm_type='PCA' and scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') --changed on 24-01-2017 based on sandeep confirmation due to limit issue
            else lpad(' ',10,' ')
        end,--changed on 23-12-2015
--   v_Limit_Expiring_Date        CHAR(8)     
        case 
        when map_acc.schm_type='PCA' and LCDTEX is not null then lpad(to_char(to_date(get_date_fm_btrv(LCDTEX),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        when scled <> 0 and get_date_fm_btrv(SCLED) <> 'ERROR' and scodl <> 0  then
        lpad(to_char(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
          when map_acc.schm_code ='360'   then lpad('31-12-2099',10,' ')  --changed on 24-01-2017 based on sandeep confirmation due to limit issue
          when  scodl <> 0 or  map_acc.schm_type='PCA' then lpad('31-12-2099',10,' ') 
          else lpad(' ',10,' ')
        end,
--   v_Account_Review_Date        CHAR(8)        
       case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD')+1,'DD-MM-YYYY'),10,' ')   --- +1 to -1 changed on 26-07-2017 as per sandeep and ravi confirmation 
         else lpad(' ',10,' ')
         end,          
--   v_Loan_Paper_Date             CHAR(8)
       case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
         then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')          
         else lpad(' ',10,' ')
         end,
--   v_Sanction_Authority_Code        CHAR(5)
     lpad('999',5,' '),
--   v_ECGC_Applicable_Flag        CHAR(1)
            case when map_acc.schm_code='360' and (pca_num is not null or oper1.fin_acc_num is not null or operative_acc_num is not null or oper_fin is not null) then  lpad('N',1,' ')
            WHEN MAP_ACC.SCHM_TYPE='PCA' and (pca_num is not null or oper1.fin_acc_num is not null or  operative_acc_num is not null or oper_fin is not null) then  lpad('N',1,' ')
            else lpad(' ',1,' ') end,
--   v_ECGC_Account            CHAR(16)
            lpad(' ',16,' '),
--   v_Due_Date                CHAR(8)
           case when map_acc.schm_code='360' then lpad('31-12-2099',10,' ')
           when map_acc.schm_type='PCA' then lpad('31-12-2099',10,' ')
           else lpad(' ',10,' ') end,
--   v_RPC_Account_Flag            CHAR(1)
            case when map_acc.schm_code='360' and (pca_num is not null or oper1.fin_acc_num is not null or operative_acc_num is not null or oper_fin is not null) then  lpad('Y',1,' ')
            when map_acc.schm_type='PCA' and (pca_num is not null or oper1.fin_acc_num is not null or operative_acc_num is not null or oper_fin is not null) then  lpad('Y',1,' ')
            when map_acc.schm_type='PCA' then  lpad('N',1,' ')
            when map_acc.schm_code='360'  then  lpad('N',1,' ')
            else lpad(' ',1,' ') end,
--   v_Disbursement_Indicator        CHAR(1)
            case when map_acc.schm_code='360' and (pca_num is not null or oper1.fin_acc_num is not null or operative_acc_num is not null or oper_fin is not null) then  lpad('M',1,' ')
            when map_acc.schm_type='PCA' and (pca_num is not null or oper1.fin_acc_num is not null or operative_acc_num is not null or oper_fin is not null) then  lpad('M',1,' ')
            else lpad(' ',1,' ') end,
-- v_Last_Compound_date            CHAR(8)
            lpad(' ',10,' '),
--   v_Daily_compounding_of_int_flg    CHAR(1)
            lpad(' ',1,' '),
-- v_Comp_rest_day_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Use_discount_rate_flg        CHAR(1)
            lpad(' ',1,' '),
--   v_Dummy                CHAR(100)
            lpad(' ',100,' '),
--   v_Account_Status_Date        CHAR(8)
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
		--case 
          --  when trim(LAST_DORMANCY_DATE) is not null then lpad(to_char(to_date(LAST_DORMANCY_DATE,'MM/DD/YYYY'),'DD-MM-YYYY'),10,' ')--code changed for dormant account from Excel file based on the email from Vijay on 17-May-2017,Code chage date on 21/May 
           -- when scdlm <> 0 and get_date_fm_btrv(scdlm) <> 'ERROR' then
           -- lpad(to_char(to_date(get_date_fm_btrv(scdlm),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
           -- else lpad(get_param('EOD_DATE'),10,' ')
           -- end,
--   v_Iban_number            CHAR(34)
            lpad(map_acc.iban_number,34,' '),
--   v_Ias_code                CHAR(5)
            lpad(' ',5,' '),
-- v_Channel_id                CHAR(5)
            lpad(' ',5,' '),
-- v_Channel_level_code            CHAR(5)
            lpad(' ',5,' '),
--   v_int_suspense_amt            CHAR(17)            
           --case when past.acc_num is not null then lpad(nvl(abs(SUSPENCE_AMT),0),17,' ') else lpad(' ',17,' ') end, ---changed on 06-03-17 based on 02-03-17 vijay mail
           lpad(' ',17,' '), --commented on  19-07-2017 based on discussion with vijay and natraj. commented because in legacy int susp. amt applied in equation ------uncommented on 11-09-2017 based on vijay confirmation
           --case when past.acc_num is not null then lpad(to_char(nvl(iis.amt,0)),17,' ') else lpad(' ',17,' ') end, ---based on discussion with vijay on 06-08-2017 script changed---commented on 11-09-2017 based on vijay confirmation
--   v_penal_int_suspense_amt        CHAR(17)
            lpad(' ',17,' '),
--   v_chrge_off_flg            CHAR(1)
            lpad(' ',1,' '),
--   v_pd_flg                CHAR(1)          
    --case when past.acc_num is not null then 'Y' else 'N' end, ---changed on 06-03-17 based on 02-03-17 vijay mail---commented on 11-09-2017 based on vijay confirmation
            lpad('N',1,' '),
--   v_pd_xfer_date            CHAR(8)    
    --case when acc_num is not null then to_char(to_date(excess_since,'MM/DD/YYYY'),'DD-MM-YYYY') else lpad(' ',10,' ') end,
    --case when past.acc_num is not null then to_char(to_date(pass_due_dt,'YYYYMMDD'),'DD-MM-YYYY') else lpad(' ',10,' ') end, ---changed on 06-03-17 based on 02-03-17 vijay mail---commented on 11-09-2017 based on vijay confirmation
            lpad(' ',10,' '),
    --   v_chrge_off_date            CHAR(8)
            lpad(' ',10,' '),
--   v_chrge_off_principal        CHAR(17)
            lpad(' ',17,' '),
--   v_pending_interest            CHAR(17)
            lpad(' ',17,' '),
-- v_principal_recovery            CHAR(17)
            lpad(' ',17,' '),
-- v_interest_recovery            CHAR(17)
            lpad(' ',17,' '),
--   v_charge_off_type            CHAR(1)
            lpad(' ',1,' '),
--   v_master_acct_num            CHAR(16)
            lpad(' ',16,' '),
--   v_penal_prod_mthd_flg        CHAR(1)
            lpad(' ',1,' '),
--   v_penal_rate_mthd_flg        CHAR(1)
            lpad(' ',1,' '),
-- v_waive_min_coll_int            CHAR(1)
            lpad(' ',1,' '),
-- v_rule_code                CHAR(5)
            lpad(' ',5,' '),
-- v_ps_diff_freq_rel_party_flg        CHAR(1)
            lpad(' ',1,' '),
--   v_swift_diff_freq_rel_party_flg    CHAR(1)
            lpad(' ',1,' '),
--   v_Address_Type            CHAR(12)
--rpad(case --when addr.ADDR_TYPE is not null and trim(addr_type)='Add6' then to_char('Add'|| to_char(addr_num+1)) --- Add6 validation removed becuase sanjay given confirmation on 19-04-2017 for not to migrate.
      --when addr.ADDR_TYPE is not null  and addr.addr_type<>'Prime' then addr.ADDR_TYPE     else case when map_cif.individual='Y' then 'Mailing'      else 'Registered' end end,12,' '),
             rpad(case when addr_ret.leg_acc_num is not null  then to_char(addr_ret.addresscategory)
    when addr_corp.leg_acc_num is not null   then to_char(addr_corp.addresscategory)
    when map_cif.individual='Y' then 'Mailing'
    else 'Registered'  end,12,' '), --- changed 07-06-2017 as per cif address type changes 
-- v_Phone_Type                CHAR(12)
            lpad(' ',12,' '),
-- v_Email_Type                CHAR(12)
            lpad(' ',12,' '),
-- v_accrued_penal_int_recovery        CHAR(17)
            lpad(' ',17,' '),
-- v_penal_int_recovery            CHAR(17)
            lpad(' ',17,' '),
-- v_coll_int_recovery            CHAR(17)
            lpad(' ',17,' '),
--   v_coll_penal_int_recovery        CHAR(17)
            lpad(' ',17,' '),
--   v_pending_penal_interest        CHAR(17)
            lpad(' ',17,' '),
--   v_pending_penal_booked_interest    CHAR(17)
            lpad(' ',17,' '),
--   v_int_rate_prd_in_months         CHAR(3)
            lpad(' ',3,' '),
--   v_int_rate_prd_in_days        CHAR(3)
            lpad(' ',3,' '),
-- v_penal_int_tbl_code            CHAR(5)
            lpad(' ',5,' '),
--   v_penal_pref_pcnt            CHAR(10)
            --lpad(PENAL_DR_RATE,10,' '),
         lpad(' ',10,' '),             --- changed on 01-02-2017 based on kumaresan and Vijay  confirmation
--   v_interpolation_method        CHAR(1)
            lpad(' ',1,' '),
--   v_Is_account_hedged_flag        CHAR(1)
            lpad(' ',1,' '),
--   v_used_for_netting_of_flag        CHAR(1)
            lpad(' ',1,' '),
--   v_Alternate_account_name        CHAR(80)
            lpad(' ',80,' '),
-- v_Security_Indicator            CHAR(10)
            lpad(' ',10,' '),
--   v_Debt_seniority            CHAR(1)
            lpad(' ',1,' '),
--   v_Security_Code            CHAR(8)
            rpad(' ',8,' ') ,
--Debit Interest Method (1)
            lpad(' ',1,' '),
--Service charge collection flag (1)
            lpad('Y',1,' '),
--Last purge date (10)
            lpad(' ',10,' ')
from map_acc
inner join scpf  on scab=map_acc.leg_branch_id and scan=leg_scan and scas=leg_scas
inner join c8pf  on c8ccy = scccy
left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
left join acct_interest_tbl inte on inte.s5ab=scab and inte.s5an=scan and inte.s5as=scas 
left join  chqbk on dtabc=scab and dtanc=scan and dtasc=scas
left join r4pf on r4ab=leg_branch_id and r4an=leg_scan and r4as=leg_scas
--left join acct_addr_type addr on addr.leg_acc_num=scab||scan||scas
left join acct_addr_type_ret addr_ret on addr_ret.leg_acc_num=scab||scan||scas
left join acct_addr_type_corp addr_corp on addr_corp.leg_acc_num=scab||scan||scas
left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
left join (select distinct GFCUS,GFCLC,SWIFT_CODE from swift_code2) swift on nvl(trim(swift.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(swift.gfcus)=map_cif.gfcus
--left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'Y' group by schm_code)gss  on map_acc.schm_code = gss.schm_code
--left join (select * from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'Y')gss  on map_acc.schm_code = gss.schm_code
--left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'N' group by schm_code)gss1  on map_acc.schm_code = gss1.schm_code
left join gfpf gf on trim(gf.gfcus)=map_cif.gfcus and nvl(trim(gf.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and gf.gfcpnc=MAP_CIF.GFCPNC
left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code =map_acc.CURRENCY     
left join (select *  from tbaadm.gsp   where bank_id = get_param('BANK_ID') and del_flg = 'N')gsp on  map_acc.schm_code = gsp.schm_code
left join (select map_acc.fin_acc_num fin_num, oper.fin_acc_num operative_acc_num  from ubpf inner join map_acc on ubab=leg_branch_id and uban=leg_scan and ubas=leg_scas
inner join (select leg_branch_id||leg_Scan||leg_Scas leg_acc_num,fin_acc_num from map_acc where SCHM_TYPE<>'OOO') oper on ubnab||ubnan||ubnas=oper.leg_acc_num 
where map_acc.schm_type<>'OOO') oper on oper.fin_num=fin_acc_num
left join (select distinct main.fin_acc_num Main_fin,main.schm_type main_schm,oper.fin_acc_num oper_fin,oper.schm_type oper_type from gvpf   --- gvpf_ods changed to gvpf as per vijay confirmation on 15-07-2017 based on pca operative account issue
inner join map_cif on nvl(gvclc,' ')=nvl(map_cif.gfclc,' ') and  gvcus=map_cif.gfcus 
inner join map_acc main on main.fin_cif_id=map_cif.fin_cif_id and schm_type='PCA' AND GVCCY=MAIN.CURRENCY
inner join map_acc oper on oper.leg_branch_id||oper.leg_Scan||oper.leg_Scas=trim(GVABF)||trim(GVANF)||trim(GVASF) AND GVCCY=OPER.CURRENCY and oper.schm_type <> 'OOO') oper1 on oper1.main_fin=map_acc.fin_acc_num 
--left join ((select distinct ubab,uban,ubas,oper.fin_acc_num operative_acc_num from ubpf inner join map_acc oper on ubnab=oper.leg_branch_id and ubnan=oper.leg_scan and ubnas=oper.leg_scas 
--where oper.SCHM_TYPE<>'OOO'))oper on ubab=leg_branch_id and uban=leg_scan and ubas=leg_scas
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
left join dormant_acc on  leg_branch_id||leg_scan||leg_scas=dormant_acc.scab||dormant_acc.scan||dormant_acc.scas --code changed for dormant account from Excel file based on the email from Vijay on 17-May-2017,Code chage date on 21/May 
left join freetext on map_acc.fin_acc_num=freetext.acid
left join sanction_limit on sanction_num=map_acc.fin_acc_num
left join (SELECT a.*,fin_acc_num,currency,fin_sol_id FROM pca_operative_account a inner join map_Acc b on fin_acc_num=operative_account where schm_type <> 'OOO') oper1 on leg_branch_id||leg_scan||leg_scas=oper1.leg_acc_num
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
left join iis_account iis on map_acc.fin_acc_num=iis.account
left join ps_amt on ps_amt.fin_num=map_acc.fin_acc_num
left join (select distinct map_acc.fin_acc_num pca_num,a.fin_acc_num pca_oper_num from pca_operacc a
inner join v5pf on trim(ompf_leg_num)=trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)
inner join map_Acc on v5abd||v5and||v5asd=leg_branch_id||leg_scan||leg_scas
where schm_type='PCA')pca_oper  on  pca_oper.pca_num=map_acc.fin_acc_num
where map_acc.schm_type in('ODA','PCA');
commit; 
exit; 
