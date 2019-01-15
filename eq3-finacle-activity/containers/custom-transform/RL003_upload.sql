
-- File Name        : LRS_upload.sql
-- File Created for : Upload file for LRS
-- Created By       : R.Alavudeen Ali badusha
-- Client           : ABK
-- Created On       : 20-06-2016 
-------------------------------------------------------------------
DROP TABLE OMPF_TEST;
truncate table OMPF_MAIN;
CREATE TABLE OMPF_TEST AS
SELECT FIN_ACC_NUM,CONV_TO_VALID_DATE(GET_DATE_FM_BTRV(OMDTE),'yyyymmdd') OMDTE ,'        ' NO_OF_FLOWS,SUM(OMNWR) OMNWR FROM OMPF 
INNER JOIN MAP_ACC ON LEG_ACC_NUM=TRIM(OMBRNM)||TRIM(OMDLP)||TRIM(OMDLR)
left join v5pf on v5brnm||v5dlp||trim(v5dlr) = map_acc.leg_acc_num
left JOIN R8PF ON TRIM(R8LNP)=TRIM(OMDLP)
WHERE (nvl(r8crl,'N')='Y' or (schm_code in ('NAF','NFD') and trim(v5brr) is null))
AND SCHM_TYPE='LAA'
AND ((OMMVT = 'P' and OMMVTS='R') OR (OMMVT = 'I' AND trim(OMMVTS) IS NULL))
AND CONV_TO_VALID_DATE(GET_DATE_FM_BTRV(OMDTE),'yyyymmdd') > TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')
GROUP BY FIN_ACC_NUM,CONV_TO_VALID_DATE(GET_DATE_FM_BTRV(OMDTE),'yyyymmdd'),'        ';
CREATE INDEX OMPF_TEST_FIN_ACC_NUM ON OMPF_TEST(FIN_ACC_NUM);
CREATE INDEX OMPF_TEST_OMDTE ON OMPF_TEST(OMDTE);
CREATE INDEX OMPF_TEST_OMNWR ON OMPF_TEST(OMNWR);
DECLARE
   V_FIN_ACC_NUM VARCHAR2(13);
   CURSOR C1
   IS
   SELECT * FROM OMPF_TEST ORDER BY FIN_ACC_NUM,OMDTE;
   V_OMNWR NUMBER ;
   V_NO_FLOWS NUMBER := 0;
   V_OMDTE DATE; 
   START_FLG INT :=0;
BEGIN 
    FOR L_RECORD IN C1 LOOP
        IF(START_FLG = 0) THEN 
                   V_NO_FLOWS := 0;
                   V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
                   V_OMNWR := L_RECORD.OMNWR;
                   V_OMDTE := L_RECORD.OMDTE;
                   START_FLG := 1;
        END IF;
        IF (V_FIN_ACC_NUM = L_RECORD.FIN_ACC_NUM ) THEN
            IF (V_OMNWR = L_RECORD.OMNWR) THEN
                 V_NO_FLOWS := V_NO_FLOWS+1;
            ELSE 
            insert into OMPF_MAIN values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
               V_NO_FLOWS := 1;
               V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
               V_OMNWR := L_RECORD.OMNWR;
               V_OMDTE := L_RECORD.OMDTE;
            END IF;
         ELSE 
         insert into OMPF_MAIN values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
              V_NO_FLOWS := 1;
              V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
              V_OMNWR := L_RECORD.OMNWR;
              V_OMDTE := L_RECORD.OMDTE;
         END IF;     
    END LOOP;
    insert into OMPF_MAIN values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
    update OMPF_main set NO_OF_FLOWS='1' where NO_OF_FLOWS='0';
    COMMIT;
END; 
drop table ompf_eidem;
create table ompf_eidem as
select ombrnm,omdlp,omdlr,min(omdte) omdte,count(*) flows,omnwr from 
(select ombrnm,omdlp,omdlr,omdte,sum(omnwr) omnwr from ompf where omdte > get_param('EODCYYMMDD')  and omnwr <> 0 and ((ommvt ='P' and ommvts ='R') or (ommvt ='I' and trim(ommvts) is null) ) group by  ombrnm,omdlp,omdlr,omdte)
group by ombrnm,omdlp,omdlr,omnwr;
create index ompf_eidem_idx on ompf_eidem(ombrnm||omdlp||trim(omdlr));
drop table ompf_prdem;
create table ompf_prdem as
select * from ompf where omdte > get_param('EODCYYMMDD')  and omnwr <> 0 and ommvt ='P' and ommvts ='R';
create index ompf_prdem_idx on ompf_prdem(ombrnm||omdlp||trim(omdlr));
drop table ompf_indem; 
create table ompf_indem as 
select ombrnm,omdlp,omdlr ,min(omdte) omdte from ompf where omdte > get_param('EODCYYMMDD')  and ommvt ='I' and trim(ommvts) is null group by ombrnm,omdlp,omdlr;
create index ompf_indem_idx on ompf_indem(ombrnm||omdlp||trim(omdlr));
-----------------------------------------------
DROP TABLE OMPF_TEST1;
truncate table OMPF_MAIN1;
CREATE TABLE OMPF_TEST1 AS
SELECT FIN_ACC_NUM,CONV_TO_VALID_DATE(GET_DATE_FM_BTRV(OMDTE),'yyyymmdd') OMDTE ,'        ' NO_OF_FLOWS,OMNWR OMNWR FROM OMPF 
INNER JOIN MAP_ACC ON LEG_ACC_NUM=TRIM(OMBRNM)||TRIM(OMDLP)||TRIM(OMDLR)
left join v5pf on v5brnm||v5dlp||trim(v5dlr) = map_acc.leg_acc_num
left JOIN R8PF ON TRIM(R8LNP)=TRIM(OMDLP)
WHERE (nvl(trim(r8crl),'N')='N' and not(schm_code in ('NAF','NFD') and trim(v5brr) is null))
AND SCHM_TYPE='LAA'
AND ((OMMVT = 'P' and OMMVTS='R'))
AND CONV_TO_VALID_DATE(GET_DATE_FM_BTRV(OMDTE),'yyyymmdd') > TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY');
CREATE INDEX OMPF_TEST_FIN_ACC_NUM1 ON OMPF_TEST1(FIN_ACC_NUM);
CREATE INDEX OMPF_TEST_OMDTE1 ON OMPF_TEST1(OMDTE);
CREATE INDEX OMPF_TEST_OMNWR1 ON OMPF_TEST1(OMNWR);
DECLARE
   V_FIN_ACC_NUM VARCHAR2(13);
   CURSOR C1
   IS
   SELECT * FROM OMPF_TEST1 ORDER BY FIN_ACC_NUM,OMDTE;
   V_OMNWR NUMBER ;
   V_NO_FLOWS NUMBER := 0;
   V_OMDTE DATE; 
   START_FLG INT :=0;
BEGIN 
    FOR L_RECORD IN C1 LOOP
        IF(START_FLG = 0) THEN 
                   V_NO_FLOWS := 0;
                   V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
                   V_OMNWR := L_RECORD.OMNWR;
                   V_OMDTE := L_RECORD.OMDTE;
                   START_FLG := 1;
        END IF;
        IF (V_FIN_ACC_NUM = L_RECORD.FIN_ACC_NUM ) THEN
            IF (V_OMNWR = L_RECORD.OMNWR) THEN
                 V_NO_FLOWS := V_NO_FLOWS+1;
            ELSE 
            insert into OMPF_MAIN1 values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
               V_NO_FLOWS := 1;
               V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
               V_OMNWR := L_RECORD.OMNWR;
               V_OMDTE := L_RECORD.OMDTE;
            END IF;
         ELSE 
         insert into OMPF_MAIN1 values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
              V_NO_FLOWS := 1;
              V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
              V_OMNWR := L_RECORD.OMNWR;
              V_OMDTE := L_RECORD.OMDTE;
         END IF;     
    END LOOP;
    insert into OMPF_MAIN1 values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
    update OMPF_main1 set NO_OF_FLOWS='1' where NO_OF_FLOWS='0';
    COMMIT;
END; 
------------------------------------ Capitalised Loan EIDEM schedule -------------------------------------------------
truncate table LRS_O_TABLE;
insert into LRS_O_TABLE
select 
--   Account_Number         CHAR(16) NULL,
    rpad(map_acc.fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('EIDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
    case 
     --   when omdte is not null then to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY')
        when omdte is not null then to_char(omdte,'DD-MM-YYYY')--changed on 27-02-2017
        else get_param('EOD_DATE')
    end,
--   Frequency_Type         CHAR(1) NULL,
      case when regexp_like(substr(IZRFRQ,1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(IZRFRQ,1,1),'[M-R]') then 'H'
         when regexp_like(substr(IZRFRQ,1,1),'[S-U]') then 'Q'
         when regexp_like(substr(IZRFRQ,1,1),'[V]') then 'M'
         when regexp_like(substr(IZRFRQ,1,1),'[W]') then 'W'
         when regexp_like(substr(IZRFRQ,1,1),'[Y]') then 'F'
         when regexp_like(substr(IZRFRQ,1,1),'[Z]') then 'D'
		 when regexp_like(substr(trim(v5ifq),1,1),'[A-L]') then 'Y' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[M-R]') then 'H' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[S-U]') then 'Q' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[V]') then 'M'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[W]') then 'W'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[Y]') then 'F'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[Z]') then 'D'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
    else 'M' end,
--   Freq_Week_Num_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Week_Day_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Start_DD_for_Principal     CHAR(2) NULL,
    rpad(case when trim(IZRFRQ) is not null then to_char(substr(trim(IZRFRQ),2,2)) 
    when TRIM(v5ifq) is not null then to_char(substr(trim(v5ifq),2,2))   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	when omdte is not null then  substr(to_char(OMDTE,'DD-MM-YYYY'),1,2) ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	else '31' end,2,' '),
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
     --lpad(nvl(flows,1),3,' '),
     lpad(nvl(NO_OF_FLOWS,1),3,' '),---changed on 27-02-2017
--   Installment_Amount         CHAR(17) NULL,
    case 
        when  omnwr is not null then  lpad(to_char(to_number(omnwr)/POWER(10,C8CED)),17,' ')
        else lpad('0.01',17,' ')
    end,
--   Installment_Percentage     CHAR(8) NULL,
    lpad(' ',8,' '),
--   Number_of_Demands_Raised     CHAR(3) NULL,
    case 
        when  omnwr is not null then  lpad(' ',3,' ')
        else lpad('1',3,' ')
    end,
--   Next_Installment_Date     CHAR(10) NULL,
    lpad(' ',10,' '),        
--   Next_Int_Installment_Date     CHAR(10) NULL,
    rpad(' ',10,' '),
--   Frequency_Type_for_Interest     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_Number_for_Int CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_day_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Start_DD_for_Int     CHAR(2) NULL,
    rpad(' ',2,' '),
--   Freq_Months_for_Int     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Int     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Holiday_Status_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Installment_Indicator     CHAR(1) NULL
    rpad(' ',1,' ')
from map_acc
inner join c8pf on c8ccy = currency
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=leg_acc_num
--inner join obpf on obdlp=v5dlp -----changed on 03-10-2016 because obpf -obcrcl has null value.
left join r8pf on r8lnp=trim(v5dlp)
--left join (select ombrnm,omdlp,omdlr,min(omdte) omdte,count(*) flows,omnwr from 
--(select ombrnm,omdlp,omdlr,omdte,sum(omnwr) omnwr from ompf where omdte > get_param('EODCYYMMDD')  and omnwr <> 0 and ((ommvt ='P' and ommvts ='R') or (ommvt ='I' and ommvts is null) ) group by  ombrnm,omdlp,omdlr,omdte)
--group by ombrnm,omdlp,omdlr,omnwr) 
--left join ompf_eidem on leg_acc_num=ombrnm||omdlp||trim(omdlr)
left join ompf_main on ompf_main.fin_acc_num=map_acc.fin_acc_num --changed on 27-02-2017
left join (select a.* from izpf a inner join (select izbrnm,izdlp,izdlr,max(izdtes) izdtes from izpf group by izbrnm,izdlp,izdlr)b on  a.izbrnm= b.izbrnm  and a.izdlp=b.izdlp and a.izdlr = b.izdlr and a.izdtes=b.izdtes)izpf on leg_acc_num=izbrnm||izdlp||trim(izdlr)
where map_acc.schm_type='LAA'  
and (nvl(r8crl,'N')='Y' or (schm_code in ('NAF','NFD') and trim(v5brr) is null))
--and nvl(obcrcl,'N')='Y' --changed on 03-10-2016 because obpf -obcrcl has null value.
order by map_acc.fin_acc_num;
commit;
------------------------------------ Non Capitalised Loan PRDEM schedule -------------------------------------------------
insert into LRS_O_TABLE
select 
--   Account_Number         CHAR(16) NULL,
    rpad(map_acc.fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('PRDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
    case 
        when omdte is not null then to_char(OMDTE,'DD-MM-YYYY')
        else get_param('EOD_DATE')
    end,
--   Frequency_Type         CHAR(1) NULL,
      case when map_acc.schm_code in ('BTP','FMP','FMX') then 'B'
	     when regexp_like(substr(trim(IZRFRQ),1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(trim(IZRFRQ),1,1),'[M-R]') then 'H'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[S-U]') then 'Q'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[V]') then 'M'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[W]') then 'W'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Y]') then 'F'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Z]') then 'D'
         when regexp_like(substr(trim(v5ifq),1,1),'[A-L]') then 'Y' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[M-R]') then 'H' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[S-U]') then 'Q' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[V]') then 'M'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[W]') then 'W'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[Y]') then 'F'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[Z]') then 'D'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	else 'M' end,
--   Freq_Week_Num_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Week_Day_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Start_DD_for_Principal     CHAR(2) NULL,
    --rpad(case when IZRFRQ is not null then to_char(substr(IZRFRQ,2,2)) else '31' end,2,' '),
    rpad(case when 	map_acc.schm_code in ('BTP','FMP','FMX') then ' '
	when trim(IZRFRQ) is not null then to_char(substr(trim(IZRFRQ),2,2))  
    when TRIM(v5ifq) is not null then to_char(substr(trim(v5ifq),2,2))   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	when omdte is not null then  substr(to_char(OMDTE,'DD-MM-YYYY'),1,2) 
    else substr(get_param('EOD_DATE'),1,2) end,2,' '),
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '), 
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
     lpad(nvl(NO_OF_FLOWS,1),3,' '),
--   Installment_Amount         CHAR(17) NULL,
    case 
        when  omnwr is not null then  lpad(to_char(to_number(omnwr)/POWER(10,C8CED)),17,' ')
        else lpad('0.01',17,' ')
    end,
--   Installment_Percentage     CHAR(8) NULL,
    lpad(' ',8,' '),
--   Number_of_Demands_Raised     CHAR(3) NULL,
    case 
        when  omnwr is not null then  lpad(' ',3,' ')
        else lpad('1',3,' ')
    end,
--   Next_Installment_Date     CHAR(10) NULL,
    lpad(' ',10,' '),        
--   Next_Int_Installment_Date     CHAR(10) NULL,
    rpad(' ',10,' '),
--   Frequency_Type_for_Interest     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_Number_for_Int CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_day_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Start_DD_for_Int     CHAR(2) NULL,
    rpad(' ',2,' '),
--   Freq_Months_for_Int     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Int     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Holiday_Status_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Installment_Indicator     CHAR(1) NULL
    rpad(' ',1,' ')
from map_acc
inner join c8pf on c8ccy = currency
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=leg_acc_num
left join r8pf on r8lnp=trim(v5dlp)
left join OMPF_MAIN1  a on map_acc.fin_acc_num=a.FIN_ACC_NUM and OMNWR <> 0
left join (select a.* from izpf a inner join (select izbrnm,izdlp,izdlr,max(izdtes) izdtes from izpf group by izbrnm,izdlp,izdlr)b on  a.izbrnm= b.izbrnm  and a.izdlp=b.izdlp and a.izdlr = b.izdlr and a.izdtes=b.izdtes)izpf on leg_acc_num=izbrnm||izdlp||trim(izdlr)
where map_acc.schm_type='LAA'  
and (nvl(trim(r8crl),'N')='N' and not(schm_code in ('NAF','NFD') and trim(v5brr) is null)) 
order by map_acc.fin_acc_num;
commit; 
/*insert into LRS_O_TABLE
select 
--   Account_Number         CHAR(16) NULL,
    rpad(fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('PRDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
    case 
        when omdte is not null then to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY')
        else get_param('EOD_DATE')
    end,
--   Frequency_Type         CHAR(1) NULL,
      case when regexp_like(substr(trim(IZRFRQ),1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(trim(IZRFRQ),1,1),'[M-R]') then 'H'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[S-U]') then 'Q'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[V]') then 'M'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[W]') then 'W'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Y]') then 'F'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Z]') then 'D'
    else 'M' end,
--   Freq_Week_Num_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Week_Day_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Start_DD_for_Principal     CHAR(2) NULL,
    --rpad(case when IZRFRQ is not null then to_char(substr(IZRFRQ,2,2)) else '31' end,2,' '),
    rpad(case when trim(IZRFRQ) is not null then to_char(substr(trim(IZRFRQ),2,2))  
    when omdte is not null then  substr(to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2) 
    else substr(get_param('EOD_DATE'),1,2) end,2,' '),
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
     lpad('1',3,' '),
--   Installment_Amount         CHAR(17) NULL,
    case 
        when  omnwr is not null then  lpad(to_char(to_number(omnwr)/POWER(10,C8CED)),17,' ')
        else lpad('0.01',17,' ')
    end,
--   Installment_Percentage     CHAR(8) NULL,
    lpad(' ',8,' '),
--   Number_of_Demands_Raised     CHAR(3) NULL,
    case 
        when  omnwr is not null then  lpad(' ',3,' ')
        else lpad('1',3,' ')
    end,
--   Next_Installment_Date     CHAR(10) NULL,
    lpad(' ',10,' '),        
--   Next_Int_Installment_Date     CHAR(10) NULL,
    rpad(' ',10,' '),
--   Frequency_Type_for_Interest     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_Number_for_Int CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_day_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Start_DD_for_Int     CHAR(2) NULL,
    rpad(' ',2,' '),
--   Freq_Months_for_Int     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Int     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Holiday_Status_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Installment_Indicator     CHAR(1) NULL
    rpad(' ',1,' ')
from map_acc
inner join c8pf on c8ccy = currency
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=leg_acc_num
--inner join obpf on obdlp=v5dlp --changed on 03-10-2016 because obpf -obcrcl has null value.
left join r8pf on r8lnp=trim(v5dlp)
left join ompf_prdem  on leg_acc_num=ombrnm||omdlp||trim(omdlr)
left join (select a.* from izpf a inner join (select izbrnm,izdlp,izdlr,max(izdtes) izdtes from izpf group by izbrnm,izdlp,izdlr)b on  a.izbrnm= b.izbrnm  and a.izdlp=b.izdlp and a.izdlr = b.izdlr and a.izdtes=b.izdtes)izpf on leg_acc_num=izbrnm||izdlp||trim(izdlr)
where map_acc.schm_type='LAA'  
--and nvl(obcrcl,'N')='N' --changed on 03-10-2016 because obpf -obcrcl has null value.
and (nvl(trim(r8crl),'N')='N' and not(schm_code in ('NAF','NFD') and trim(v5brr) is null))
order by map_acc.fin_acc_num;
commit; */
------------------------------------ Non Capitalised Loan INDEM schedule -------------------------------------------------
insert into LRS_O_TABLE
select 
--   Account_Number         CHAR(16) NULL,
    rpad(fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('INDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
    case 
        when omdte is not null then to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY')
        else get_param('EOD_DATE')
    end,
--   Frequency_Type         CHAR(1) NULL,
    case when regexp_like(substr(trim(IZRFRQ),1,1),'[A-L]') then 'Y' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[M-R]') then 'H' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[S-U]') then 'Q' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[V]') then 'M' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[W]') then 'W' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Y]') then 'F' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Z]') then 'D' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	     when regexp_like(substr(trim(v5ifq),1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(trim(v5ifq),1,1),'[M-R]') then 'H'
         when regexp_like(substr(trim(v5ifq),1,1),'[S-U]') then 'Q'
         when regexp_like(substr(trim(v5ifq),1,1),'[V]') then 'M'
         when regexp_like(substr(trim(v5ifq),1,1),'[W]') then 'W'
         when regexp_like(substr(trim(v5ifq),1,1),'[Y]') then 'F'
         when regexp_like(substr(trim(v5ifq),1,1),'[Z]') then 'D'
    else 'M' end,
--   Freq_Week_Num_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Week_Day_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Start_DD_for_Principal     CHAR(2) NULL,
    rpad(case when trim(IZRFRQ) is not null then to_char(substr(trim(IZRFRQ),2,2))  ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	     when TRIM(v5ifq) is not null then to_char(substr(trim(v5ifq),2,2))   
      	 when omdte is not null then  substr(OMDTE,6,2) ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	    else '31' end,2,' '),
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
    lpad(' ',3,' '),
--   Installment_Amount         CHAR(17) NULL,
    lpad(' ',17,' '),
--   Installment_Percentage     CHAR(8) NULL,
    lpad(' ',8,' '),
--   Number_of_Demands_Raised     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Next_Installment_Date     CHAR(10) NULL,
    lpad(' ',10,' '),        
--   Next_Int_Installment_Date     CHAR(10) NULL,
    rpad(' ',10,' '),
--   Frequency_Type_for_Interest     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_Number_for_Int CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_day_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Start_DD_for_Int     CHAR(2) NULL,
    rpad(' ',2,' '),
--   Freq_Months_for_Int     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Int     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Holiday_Status_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Installment_Indicator     CHAR(1) NULL
    rpad(' ',1,' ')
from map_acc
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr) = map_acc.leg_acc_num
inner join c8pf on c8ccy = currency
--inner join obpf on obdlp=v5dlp ----changed on 03-10-2016 because obpf -obcrcl has null value.
left join r8pf on r8lnp=trim(v5dlp)
left join ompf_indem on leg_acc_num=ombrnm||omdlp||trim(omdlr)
left join (select a.* from izpf a inner join (select izbrnm,izdlp,izdlr,max(izdtes) izdtes from izpf group by izbrnm,izdlp,izdlr)b on  a.izbrnm= b.izbrnm  and a.izdlp=b.izdlp and a.izdlr = b.izdlr and a.izdtes=b.izdtes)izpf on leg_acc_num=izbrnm||izdlp||trim(izdlr)
where map_acc.schm_type='LAA' 
--and nvl(obcrcl,'N')='N' --changed on 03-10-2016 because obpf -obcrcl has null value.
and (nvl(trim(r8crl),'N')='N' and not(schm_code in ('NAF','NFD') and trim(v5brr) is null))
order by map_acc.fin_acc_num;
commit;
exit; 
