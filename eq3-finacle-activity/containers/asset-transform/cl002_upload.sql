
-- File Name           : cu1_upload.sql
-- File Created for    : Upload file for CU1
-- Created By          : Kumaresan.B
-- Client              : ABK
-- Created On          : 19-05-2016
-------------------------------------------------------------------
drop table ompf_cla_prdem;
create table ompf_cla_prdem as
select * from ompf where to_number(omdte) > to_number(get_param('EODCYYMMDD'))  and omnwr <> 0 and ommvt ='P' and ommvts in ('R','M','U');
create index ompf_cla_prdem_idx on ompf_cla_prdem(ombrnm||trim(omdlp)||trim(omdlr));
drop table ompf_cla_indem;
create table ompf_cla_indem as
select ombrnm,omdlp,omdlr ,min(omdte) omdte,max(omdte) max_omdte,COUNT(*) INDEM_CNT from ompf where to_number(omdte) > to_number(get_param('EODCYYMMDD'))  and ommvt ='I' and (trim(ommvts) is null or ommvts='D') group by ombrnm,omdlp,omdlr;
create index ompf_cla_indem_idx on ompf_cla_indem(ombrnm||omdlp||omdlr);
drop table ompf_cla_prdem1;
create table ompf_cla_prdem1 as
select ombrnm,omdlp,omdlr ,min(omdte) omdte,max(omdte) max_omdte from ompf_cla_prdem group by ombrnm,omdlp,omdlr;
create index ompf_cla_prdem_idx1 on ompf_cla_prdem1(ombrnm||trim(omdlp)||trim(omdlr));
drop table num_of_flow;
create table num_of_flow as
select fin_acc_num, 
case when regexp_like(substr(trim(S5IFQD),1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(trim(S5IFQD),1,1),'[M-R]') then 'H'
         when regexp_like(substr(trim(S5IFQD),1,1),'[S-U]') then 'Q'
         when regexp_like(substr(trim(S5IFQD),1,1),'[V]') then 'M'
         when regexp_like(substr(trim(S5IFQD),1,1),'[W]') then 'W'
         when regexp_like(substr(trim(S5IFQD),1,1),'[Y]') then 'F'
         when regexp_like(substr(trim(S5IFQD),1,1),'[Z]') then 'D'
    else 'M' end FRQ,
round(MONTHS_BETWEEN(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'), to_date(get_date_fm_btrv(S5ncdd),'YYYYMMDD'))/case when regexp_like(substr(trim(S5IFQD),1,1),'[A-L]') then '12' 
         when regexp_like(substr(trim(S5IFQD),1,1),'[M-R]') then '6'
         when regexp_like(substr(trim(S5IFQD),1,1),'[S-U]') then '3'
         when regexp_like(substr(trim(S5IFQD),1,1),'[V]') then '1'
   else '1' end,0) number_of_flow
from map_acc 
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
left join s5pf on scab||scan||scas=s5ab||s5an||s5as
inner join c8pf on c8ccy = currency
where map_acc.schm_type='CLA'  and map_acc.schm_code IN ('LAC','CLM')
and scbal <> 0 and case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR'  then to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') end >=  to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
order by fin_acc_num;
commit;
------------------------------------ Non Capitalised Loan PRDEM schedule -------------------------------------------------
truncate table Cl002_O_TABLE;
insert into Cl002_O_TABLE
select 
--Acc_Num NVARCHAR2(16),
rpad(fin_acc_num,16,' '),
--Flow_ID NVARCHAR2(5),
rpad('PRDEM',5,' '),
--Flow_Start_Date NVARCHAR2(10),
case 
        when omdte is not null then to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY')
        else get_param('EOD_DATE')
    end,
--Freq_Type NVARCHAR2(1),
case when regexp_like(substr(trim(IZRFRQ),1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(trim(IZRFRQ),1,1),'[M-R]') then 'H'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[S-U]') then 'Q'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[V]') then 'M'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[W]') then 'W'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Y]') then 'F'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Z]') then 'D'
    else 'M' end,
--Freq_Week_Number_for_pri NVARCHAR2(1),
rpad(' ',1,' '),
--Freq_Week_Day_for_pri NVARCHAR2(1),
rpad(' ',1,' '),
--Freq_Start_DD_for_pri NVARCHAR2(2),
rpad(case when IZRFRQ is not null then to_char(substr(trim(IZRFRQ),2,2))  
    when omdte is not null then  substr(to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2) 
    else substr(get_param('EOD_DATE'),1,2) end,2,' '),
--Freq_months_for_pri NVARCHAR2(4),
lpad(' ',4,' '),
--Freq_Days_for_pri NVARCHAR2(3),
lpad(' ',3,' '),
--Freq_Hol_St_Prl NVARCHAR2(1),
rpad('N',1,' '),
--Number_of_Flows NVARCHAR2(3),
lpad('1',3,' '),
--Inst_Amt NVARCHAR2(17),
case 
        when  omnwr is not null then  lpad(to_char(to_number(omnwr/POWER(10,C8CED))),17,' ')
        else lpad('0.01',17,' ')
    end,
--Inst_Per NVARCHAR2(8),
lpad(' ',8,' '),
--Number_of_Dem_Rsd NVARCHAR2(3),
    case 
        when  omnwr is not null then  lpad(' ',3,' ')
        else lpad('1',3,' ')
    end,
--Next_Ins_Dt NVARCHAR2(10),
 lpad(' ',10,' '),   
--Next_Int_Ins_Dt NVARCHAR2(10),
rpad(' ',10,' '),
--Freq_Type_for_Int NVARCHAR2(1),
rpad(' ',1,' '),
--Freq_Week_Number_for_Int NVARCHAR2(1),
rpad(' ',1,' '),
--Freq_Week_day_for_Int NVARCHAR2(1),
rpad(' ',1,' '),
--Freq_Start_DD_for_Int NVARCHAR2(2),
rpad(' ',2,' '),
--Freq_Months_for_Int NVARCHAR2(4),
rpad(' ',4,' '),
--Freq_Days_for_Int NVARCHAR2(3),
rpad(' ',3,' '),
--Freq_Hol_St_Int NVARCHAR2(1),
rpad(' ',1,' '),
--Inst_Ind NVARCHAR2(1)
rpad(' ',1,' ')
from map_acc
inner join c8pf on c8ccy = currency
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=leg_acc_num
inner join obpf on trim(obdlp)=trim(v5dlp)
left join ompf_cla_prdem on leg_acc_num=ombrnm||trim(omdlp)||trim(omdlr)
left join (select a.* from izpf a inner join (select izbrnm,izdlp,izdlr,max(izdtes) izdtes from izpf group by izbrnm,izdlp,izdlr)b on  a.izbrnm= b.izbrnm  and a.izdlp=b.izdlp and a.izdlr = b.izdlr and a.izdtes=b.izdtes)izpf on leg_acc_num=izbrnm||trim(izdlp)||trim(izdlr)
where map_acc.schm_type='CLA'  --and nvl(obcrcl,'N')='N'
order by fin_acc_num;
commit;
------------------------------------ Non Capitalised Loan INDEM schedule--next schedule date after cut off-------------------------------------------------
insert into Cl002_O_TABLE
select distinct 
--   Account_Number         CHAR(16) NULL,
    rpad(fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('INDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
    case 
        when ompf_cla_indem.omdte is not null then to_char(to_date(get_date_fm_btrv(ompf_cla_indem.omdte),'YYYYMMDD'),'DD-MM-YYYY')
        WHEN ompf_cla_prdem1.omdte is not null then to_char(to_date(get_date_fm_btrv(ompf_cla_prdem1.omdte),'YYYYMMDD'),'DD-MM-YYYY')
        else get_param('EOD_DATE')
    end,
--   Frequency_Type         CHAR(1) NULL,
    case when regexp_like(substr(trim(v5ifq),1,1),'[A-L]') then 'Y' 
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
    --rpad( case 
    --    when ompf_cla_indem.omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(ompf_cla_indem.omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
    --    WHEN ompf_cla_prdem1.omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(ompf_cla_prdem1.omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
    --    else SUBSTR(get_param('EOD_DATE'),1,2)
    --end,2,' '),
	   rpad(case when TRIM(v5ifq) is not null then to_char(substr(trim(v5ifq),2,2)) 
	             when ompf_cla_indem.omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(ompf_cla_indem.omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2)  ---added on 24-09-2017 as per vijay mail dt 24-09-2017 and spira no 8654
                 WHEN ompf_cla_prdem1.omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(ompf_cla_prdem1.omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2) ---added on 24-09-2017 as per vijay mail dt 24-09-2017 and spira no 8654
	       else '31' end,2,' '),--Vijay sir conformation changed on 22-205-2017 by Kumar
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
    --lpad(case when indem_cnt > 1 and ompf_cla_indem.max_omdte is not null and round((to_date(get_date_fm_btrv(ompf_cla_indem.max_omdte),'YYYYMMDD') - to_date(get_date_fm_btrv(ompf_cla_indem.omdte),'YYYYMMDD'))/case when regexp_like(substr(trim(v5ifq),1,1),'[A-L]') then 360 
    --     when regexp_like(substr(trim(v5ifq),1,1),'[M-R]') then 180 when regexp_like(substr(trim(v5ifq),1,1),'[S-U]') then 90 when regexp_like(substr(trim(v5ifq),1,1),'[V]') then 30
    --     when regexp_like(substr(trim(v5ifq),1,1),'[W]') then 7 when regexp_like(substr(trim(v5ifq),1,1),'[Y]') then 1 when regexp_like(substr(trim(v5ifq),1,1),'[Z]') then 1     else 30 end)  > 0 then 
    --to_char(round((to_date(get_date_fm_btrv(ompf_cla_indem.max_omdte),'YYYYMMDD') - to_date(get_date_fm_btrv(ompf_cla_indem.omdte),'YYYYMMDD'))/case when regexp_like(substr(trim(v5ifq),1,1),'[A-L]') then 360 
    --        when regexp_like(substr(trim(v5ifq),1,1),'[M-R]') then 180 when regexp_like(substr(trim(v5ifq),1,1),'[S-U]') then 90 when regexp_like(substr(trim(v5ifq),1,1),'[V]') then 30  
    --     when regexp_like(substr(trim(v5ifq),1,1),'[W]') then 7 when regexp_like(substr(trim(v5ifq),1,1),'[Y]') then 1 when regexp_like(substr(trim(v5ifq),1,1),'[Z]') then 1 else 30 end))
    --when indem_cnt > 1  then '1' else '0' end,3,' '),
	lpad(case when trim(INDEM_CNT) is not null then to_char(to_number(INDEM_CNT)-1) else '0' end,3,' '),
--   Installment_Amount         CHAR(17) NULL,
    lpad('0',17,' '),
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
inner join obpf on trim(obdlp)=trim(v5dlp)
left join ompf_cla_indem on leg_acc_num=ompf_cla_indem.ombrnm||trim(ompf_cla_indem.omdlp)||trim(ompf_cla_indem.omdlr)--- changed on 13-04-2017 as per mock3b observation
left join ompf_cla_prdem1 on leg_acc_num=ompf_cla_prdem1.ombrnm||trim(ompf_cla_prdem1.omdlp)||trim(ompf_cla_prdem1.omdlr) --- changed on 13-04-2017 as per mock3b observation
--left join ompf_cla_prdem on leg_acc_num=ompf_cla_prdem.ombrnm||trim(ompf_cla_prdem.omdlp)||trim(ompf_cla_prdem.omdlr) 
--left join ompf_cla_indem on ompf_cla_prdem.ombrnm||trim(ompf_cla_prdem.omdlp)||trim(ompf_cla_prdem.omdlr)=ompf_cla_indem.ombrnm||trim(ompf_cla_indem.omdlp)||trim(ompf_cla_indem.omdlr) --and ompf_cla_prdem.OMDTE = ompf_cla_indem.OMDTE
--left join ompf_cla_prdem on  ompf_cla_prdem.ombrnm||trim(ompf_cla_prdem.omdlp)||trim(ompf_cla_prdem.omdlr) =ompf_cla_indem.ombrnm||trim(ompf_cla_indem.omdlp)||trim(ompf_cla_indem.omdlr) AND 
--ompf_cla_prdem.OMDTE = ompf_cla_indem.OMDTE
where map_acc.schm_type='CLA' --and nvl(obcrcl,'N')='N'
;
commit;
----------------------------------------- Non Capitalised Loan INDEM schedule--last schedule maturity date-------------------------------------------------
insert into Cl002_O_TABLE
select distinct 
--   Account_Number         CHAR(16) NULL,
    rpad(fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('INDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
    case 
        when ompf_cla_indem.max_omdte is not null then to_char(to_date(get_date_fm_btrv(ompf_cla_indem.max_omdte),'YYYYMMDD'),'DD-MM-YYYY')
        else get_param('EOD_DATE')
    end,
--   Frequency_Type         CHAR(1) NULL,
    case when regexp_like(substr(trim(v5ifq),1,1),'[A-L]') then 'Y' 
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
    --rpad( case 
    --    when ompf_cla_indem.max_omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(ompf_cla_indem.max_omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
    --    else SUBSTR(get_param('EOD_DATE'),1,2)
   -- end,2,' '),
   rpad(case when TRIM(v5ifq) is not null then to_char(substr(trim(v5ifq),2,2)) 
             when ompf_cla_indem.max_omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(ompf_cla_indem.max_omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2) ---added on 24-09-2017 as per vijay mail dt 24-09-2017 and spira no 8654
        else '31' end,2,' '),--Vijay sir conformation changed on 22-205-2017 by Kumar
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
    lpad(' ',3,' '),
--   Installment_Amount         CHAR(17) NULL,
    lpad('0',17,' '),
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
inner join obpf on trim(obdlp)=trim(v5dlp)
left join ompf_cla_indem on leg_acc_num=ompf_cla_indem.ombrnm||trim(ompf_cla_indem.omdlp)||trim(ompf_cla_indem.omdlr)--- changed on 13-04-2017 as per mock3b observation
where map_acc.schm_type='CLA' AND TO_NUMBER(INDEM_CNT) > 1 ; 
--and nvl(obcrcl,'N')='N';
commit;
---------------------- PRDEM for LAC Scheme code-----------------------
insert into Cl002_O_TABLE
select 
--Acc_Num NVARCHAR2(16),
rpad(fin_acc_num,16,' '),
--Flow_ID NVARCHAR2(5),
rpad('PRDEM',5,' '),
--Flow_Start_Date NVARCHAR2(10),
case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') >=  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then to_char(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),'DD-MM-YYYY') 
         else lpad( get_param('EOD_DATE'),10,' ')  end,	
--Freq_Type NVARCHAR2(1),
     'B',
--Freq_Week_Number_for_pri NVARCHAR2(1),
rpad(' ',1,' '),
--Freq_Week_Day_for_pri NVARCHAR2(1),
rpad(' ',1,' '),
--Freq_Start_DD_for_pri NVARCHAR2(2),
--rpad(case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR'  then  substr(to_char(to_date(get_date_fm_btrv(scled),'YYYYMMDD'),'DD-MM-YYYY'),1,2)   else substr(get_param('EOD_DATE'),1,2) end,2,' '),
rpad(' ',2,' '),
--Freq_months_for_pri NVARCHAR2(4),
lpad(' ',4,' '),
--Freq_Days_for_pri NVARCHAR2(3),
lpad(' ',3,' '),
--Freq_Hol_St_Prl NVARCHAR2(1),
rpad('N',1,' '),
--Number_of_Flows NVARCHAR2(3),
lpad('1',3,' '),
--Inst_Amt NVARCHAR2(17),
case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') >=  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then lpad(to_char(to_number(abs(scbal))/POWER(10,C8CED)),17,' ')
         else lpad( '0.01',17,' ')  end,	
--Inst_Per NVARCHAR2(8),
lpad(' ',8,' '),
--Number_of_Dem_Rsd NVARCHAR2(3),
	case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') >=  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then lpad(' ',3,' ')
         else lpad('1',3,' ') end,	
--Next_Ins_Dt NVARCHAR2(10),
 lpad(' ',10,' '),   
--Next_Int_Ins_Dt NVARCHAR2(10),
rpad(' ',10,' '),
--Freq_Type_for_Int NVARCHAR2(1),
rpad(' ',1,' '),
--Freq_Week_Number_for_Int NVARCHAR2(1),
rpad(' ',1,' '),
--Freq_Week_day_for_Int NVARCHAR2(1),
rpad(' ',1,' '),
--Freq_Start_DD_for_Int NVARCHAR2(2),
rpad(' ',2,' '),
--Freq_Months_for_Int NVARCHAR2(4),
rpad(' ',4,' '),
--Freq_Days_for_Int NVARCHAR2(3),
rpad(' ',3,' '),
--Freq_Hol_St_Int NVARCHAR2(1),
rpad(' ',1,' '),
--Inst_Ind NVARCHAR2(1)
rpad(' ',1,' ')
from map_acc 
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
inner join c8pf on c8ccy = currency
where map_acc.schm_type='CLA'  and map_acc.schm_code IN ('LAC','CLM')
and scbal <> 0
order by fin_acc_num;
commit;
--------------------------INDEM for LAC scheme code ---------------
insert into Cl002_O_TABLE
select 
--   Account_Number         CHAR(16) NULL,
    rpad(map_acc.fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('INDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
--when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') >=  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then to_char(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),'DD-MM-YYYY') 
case when S5NCDD<>'9999999' and S5NCDD <> 0 and SCLED <> 0 and get_date_fm_btrv(S5NCDD) <> 'ERROR' and to_date(get_date_fm_btrv(s5ncdd),'YYYYMMDD') >=  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') and to_date(get_date_fm_btrv(s5ncdd),'YYYYMMDD') <=  to_date(get_date_fm_btrv(SCLED),'YYYYMMDD')  then lpad(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') ---instead of limit expiry date next interest cycle date has been provided on 23-08-2017 based on spira no 7994.
     when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') >=  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then to_char(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),'DD-MM-YYYY')     
		 else lpad( get_param('EOD_DATE'),10,' ')  end,	
--   Frequency_Type         CHAR(1) NULL,
    case when regexp_like(substr(trim(S5IFQD),1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(trim(S5IFQD),1,1),'[M-R]') then 'H'
         when regexp_like(substr(trim(S5IFQD),1,1),'[S-U]') then 'Q'
         when regexp_like(substr(trim(S5IFQD),1,1),'[V]') then 'M'
         when regexp_like(substr(trim(S5IFQD),1,1),'[W]') then 'W'
         when regexp_like(substr(trim(S5IFQD),1,1),'[Y]') then 'F'
         when regexp_like(substr(trim(S5IFQD),1,1),'[Z]') then 'D'
    else 'M' end, ---Based on Nancy spira id 7994 frequency has been modified on 20-08-2017
--   Freq_Week_Num_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Week_Day_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Start_DD_for_Principal     CHAR(2) NULL,
rpad(case --when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') >=  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then  substr(to_char(to_date(get_date_fm_btrv(scled),'YYYYMMDD'),'DD-MM-YYYY'),1,2) 
when TRIM(S5IFQD) is not null then to_char(substr(trim(S5IFQD),2,2))
when S5NCDD<>'9999999' and S5NCDD <> 0 and get_date_fm_btrv(S5NCDD) <> 'ERROR' then substr(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),1,2)  ---instead of limit expiry date next interest cycle date has been provided on 23-08-2017 based on spira no 7994.
    else substr(get_param('EOD_DATE'),1,2) end,2,' '),
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
    lpad(case when to_number(number_of_flow)<0 then ' ' else to_char(nvl(number_of_flow,0)) end,3,' '),
--   Installment_Amount         CHAR(17) NULL,
    lpad('0',17,' '),
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
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
left join s5pf on scab||scan||scas=s5ab||s5an||s5as
inner join c8pf on c8ccy = currency
left join num_of_flow fl on fl.fin_acc_num=map_acc.fin_acc_num
where map_acc.schm_type='CLA'  and map_acc.schm_code IN ('LAC','CLM')
and scbal <> 0 
order by map_acc.fin_acc_num;
commit;
--------------------------LAST INDEM for LAC scheme code ---------------
insert into Cl002_O_TABLE
select 
--   Account_Number         CHAR(16) NULL,
    rpad(map_acc.fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('INDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') >=  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then to_char(to_date(get_date_fm_btrv(SCLED),'YYYYMMDD'),'DD-MM-YYYY') 
-- when S5NCDD<>'9999999' and S5NCDD <> 0 and get_date_fm_btrv(S5NCDD) <> 'ERROR' then lpad(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') ---instead of limit expiry date next interest cycle date has been provided on 23-08-2017 based on spira no 7994.
         else lpad( get_param('EOD_DATE'),10,' ')  end,	
--   Frequency_Type         CHAR(1) NULL,
    case when regexp_like(substr(trim(S5IFQD),1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(trim(S5IFQD),1,1),'[M-R]') then 'H'
         when regexp_like(substr(trim(S5IFQD),1,1),'[S-U]') then 'Q'
         when regexp_like(substr(trim(S5IFQD),1,1),'[V]') then 'M'
         when regexp_like(substr(trim(S5IFQD),1,1),'[W]') then 'W'
         when regexp_like(substr(trim(S5IFQD),1,1),'[Y]') then 'F'
         when regexp_like(substr(trim(S5IFQD),1,1),'[Z]') then 'D'
    else 'M' end, ---Based on Nancy spira id 7994 frequency has been modified on 20-08-2017
--   Freq_Week_Num_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Week_Day_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Start_DD_for_Principal     CHAR(2) NULL,
rpad(case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR' and to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') >=  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') then  substr(to_char(to_date(get_date_fm_btrv(scled),'YYYYMMDD'),'DD-MM-YYYY'),1,2) 
--when when TRIM(S5IFQD) is not null then to_char(substr(trim(S5IFQD),2,2))
--when S5NCDD<>'9999999' and S5NCDD <> 0 and get_date_fm_btrv(S5NCDD) <> 'ERROR' then substr(to_char(to_date(get_date_fm_btrv(S5NCDD),'YYYYMMDD'),'DD-MM-YYYY'),1,2)  ---instead of limit expiry date next interest cycle date has been provided on 23-08-2017 based on spira no 7994.
    else substr(get_param('EOD_DATE'),1,2) end,2,' '),
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
    lpad(' ',3,' '),
--   Installment_Amount         CHAR(17) NULL,
    lpad('0',17,' '),
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
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
left join s5pf on scab||scan||scas=s5ab||s5an||s5as
inner join c8pf on c8ccy = currency
left join num_of_flow fl on fl.fin_acc_num=map_acc.fin_acc_num
where map_acc.schm_type='CLA'  and map_acc.schm_code IN ('LAC','CLM')
and scbal <> 0 and case when SCLED <>0 and get_date_fm_btrv(SCLED)<> 'ERROR'  then to_date(get_date_fm_btrv(SCLED),'YYYYMMDD') end >  to_date(get_param('EOD_DATE'),'DD-MM-YYYY') and to_number(number_of_flow)>0
order by map_acc.fin_acc_num;
commit;
----Corporate Loan Drawdown bloack added on 04-06-2017--
--drop table ompf_cla_ld_prdem;
--create table ompf_cla_ld_prdem as
--select fin_acc_num,omdte,sum(omnwr) omnwr from map_acc a
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--inner join ompf on ombrnm||trim(omdlp)||trim(omdlr)=b.LEG_ACC_NUM
--where to_number(omdte) > to_number(get_param('EODCYYMMDD'))  and omnwr <> 0 and ommvt ='P' and ommvts in ('R','M','U')
--group by fin_acc_num,omdte;
--drop table ompf_cla_ld_indem;
--create table ompf_cla_ld_indem as
--select fin_acc_num,min(omdte) omdte,max(omdte) max_omdte,COUNT(*) INDEM_CNT from map_acc a
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--inner join (select distinct ombrnm,omdlp,omdlr,omdte from  ompf where to_number(omdte) > to_number(get_param('EODCYYMMDD')) and ommvt ='I' and (trim(ommvts) is null or ommvts='D')) on ombrnm||trim(omdlp)||trim(omdlr)=b.LEG_ACC_NUM 
--group by fin_acc_num;
--drop table ompf_cla_ld_prdem1;
--create table ompf_cla_ld_prdem1 as
--select fin_acc_num,min(omdte) omdte,max(omdte) max_omdte from map_acc a
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--inner join ompf on ombrnm||trim(omdlp)||trim(omdlr)=b.LEG_ACC_NUM  
--where to_number(omdte) > to_number(get_param('EODCYYMMDD'))  and omnwr <> 0 and ommvt ='P' and ommvts in ('R','M','U')
--group by fin_acc_num;
-------------------------------------- Non Capitalised Loan PRDEM schedule -------------------------------------------------
--insert into Cl002_O_TABLE
--select 
----Acc_Num NVARCHAR2(16),
--rpad(a.fin_acc_num,16,' '),
----Flow_ID NVARCHAR2(5),
--rpad('PRDEM',5,' '),
----Flow_Start_Date NVARCHAR2(10),
--case 
--        when omdte is not null then to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY')
--        else get_param('EOD_DATE')
--    end,
----Freq_Type NVARCHAR2(1),
-- 'M',
----Freq_Week_Number_for_pri NVARCHAR2(1),
--rpad(' ',1,' '),
----Freq_Week_Day_for_pri NVARCHAR2(1),
--rpad(' ',1,' '),
----Freq_Start_DD_for_pri NVARCHAR2(2),
--rpad(substr(get_param('EOD_DATE'),1,2),2,' '),
----Freq_months_for_pri NVARCHAR2(4),
--lpad(' ',4,' '),
----Freq_Days_for_pri NVARCHAR2(3),
--lpad(' ',3,' '),
----Freq_Hol_St_Prl NVARCHAR2(1),
--rpad('N',1,' '),
----Number_of_Flows NVARCHAR2(3),
--lpad('1',3,' '),
----Inst_Amt NVARCHAR2(17),
--case 
--        when  omnwr is not null then  lpad(to_char(to_number(omnwr/POWER(10,C8CED))),17,' ')
--        else lpad('0.01',17,' ')
--    end,
----Inst_Per NVARCHAR2(8),
--lpad(' ',8,' '),
----Number_of_Dem_Rsd NVARCHAR2(3),
--    case 
--        when  omnwr is not null then  lpad(' ',3,' ')
--        else lpad('1',3,' ')
--    end,
----Next_Ins_Dt NVARCHAR2(10),
-- lpad(' ',10,' '),   
----Next_Int_Ins_Dt NVARCHAR2(10),
--rpad(' ',10,' '),
----Freq_Type_for_Int NVARCHAR2(1),
--rpad(' ',1,' '),
----Freq_Week_Number_for_Int NVARCHAR2(1),
--rpad(' ',1,' '),
----Freq_Week_day_for_Int NVARCHAR2(1),
--rpad(' ',1,' '),
----Freq_Start_DD_for_Int NVARCHAR2(2),
--rpad(' ',2,' '),
----Freq_Months_for_Int NVARCHAR2(4),
--rpad(' ',4,' '),
----Freq_Days_for_Int NVARCHAR2(3),
--rpad(' ',3,' '),
----Freq_Hol_St_Int NVARCHAR2(1),
--rpad(' ',1,' '),
----Inst_Ind NVARCHAR2(1)
--rpad(' ',1,' ')
--from map_acc a
--inner join c8pf on c8ccy = currency
--left join ompf_cla_ld_prdem b on b.fin_acc_num=a.fin_acc_num
--where length(trim(leg_Acc_num))<13
--order by a.fin_acc_num;
--commit;
-------------------------------------- Non Capitalised Loan INDEM schedule--next schedule date after cut off-------------------------------------------------
--insert into Cl002_O_TABLE
--select distinct 
----   Account_Number         CHAR(16) NULL,
--    rpad(a.fin_acc_num,16,' '),
----   Flow_ID             CHAR(5) NULL,
--    rpad('INDEM',5,' '),
----   Flow_Start_Date         CHAR(10) NULL,
--    --case 
--      --  when b.omdte is not null then to_char(to_date(get_date_fm_btrv(b.omdte),'YYYYMMDD'),'DD-MM-YYYY')
--      --  WHEN c.omdte is not null then to_char(to_date(get_date_fm_btrv(c.omdte),'YYYYMMDD'),'DD-MM-YYYY')
--      --  else get_param('EOD_DATE')
--    --end,
--	case 
--        when e.omdte is not null then to_char(to_date(get_date_fm_btrv(e.omdte),'YYYYMMDD'),'DD-MM-YYYY')
--        WHEN c.omdte is not null then to_char(to_date(get_date_fm_btrv(c.omdte),'YYYYMMDD'),'DD-MM-YYYY')
--        else get_param('EOD_DATE')
--    end,
----   Frequency_Type         CHAR(1) NULL,
--    'M',
----   Freq_Week_Num_for_Principal     CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Freq_Week_Day_for_Principal     CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Freq_Start_DD_for_Principal     CHAR(2) NULL,
--    --rpad( case 
--        --when b.omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(b.omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
--        --WHEN c.omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(c.omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
--        --else SUBSTR(get_param('EOD_DATE'),1,2)
--    --end,2,' '),
--	rpad( case 
--        when e.omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(e.omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
--        WHEN c.omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(c.omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
--        else SUBSTR(get_param('EOD_DATE'),1,2)
--    end,2,' '),
----   Freq_Months_for_Principal     CHAR(4) NULL,
--    lpad(' ',4,' '),
----   Freq_Days_for_Principal     CHAR(3) NULL,
--    lpad(' ',3,' '),
----   Freq_Hldy_Status_Principal     CHAR(1) NULL,
--    rpad('N',1,' '),
----   Number_of_Flows         CHAR(3) NULL,
--	--lpad(case when trim(INDEM_CNT) is not null then to_char(to_number(INDEM_CNT)-1) else '0' end,3,' '),	--commented on 08-06-2017 based on discussion with vijay and sandeep. based on mk4a observation
--     lpad(case when e.omdte = b.max_omdte then ' ' else '1' end,3,' '),
--	--   Installment_Amount         CHAR(17) NULL,
--    lpad('0',17,' '),
----   Installment_Percentage     CHAR(8) NULL,
--    lpad(' ',8,' '),
----   Number_of_Demands_Raised     CHAR(3) NULL,
--    lpad(' ',3,' '),
----   Next_Installment_Date     CHAR(10) NULL,
--    lpad(' ',10,' '),        
----   Next_Int_Installment_Date     CHAR(10) NULL,
--    rpad(' ',10,' '),
----   Frequency_Type_for_Interest     CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Frequency_Week_Number_for_Int CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Frequency_Week_day_for_Int     CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Frequency_Start_DD_for_Int     CHAR(2) NULL,
--    rpad(' ',2,' '),
----   Freq_Months_for_Int     CHAR(4) NULL,
--    lpad(' ',4,' '),
----   Freq_Days_for_Int     CHAR(3) NULL,
--    lpad(' ',3,' '),
----   Freq_Holiday_Status_for_Int     CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Installment_Indicator     CHAR(1) NULL
--    rpad(' ',1,' ')
--from map_acc a
--inner join c8pf on c8ccy = currency
--inner join ld_deal_int_wise d on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--inner join (select distinct ombrnm,omdlp,omdlr,omdte from  ompf where to_number(omdte) > to_number(get_param('EODCYYMMDD')) and ommvt ='I' and (trim(ommvts) is null or ommvts='D'))e on ombrnm||trim(omdlp)||trim(omdlr)=d.LEG_ACC_NUM 
--left join ompf_cla_ld_indem b on b.fin_acc_num=a.fin_acc_num
--left join ompf_cla_ld_prdem1 c on c.fin_acc_num=a.fin_acc_num
--where length(trim(a.leg_Acc_num))<13;
--commit;
------------------------------------------- Non Capitalised Loan INDEM schedule--last schedule maturity date-------------------------------------------------
--insert into Cl002_O_TABLE
--select distinct 
----   Account_Number         CHAR(16) NULL,
--    rpad(a.fin_acc_num,16,' '),
----   Flow_ID             CHAR(5) NULL,
--    rpad('INDEM',5,' '),
----   Flow_Start_Date         CHAR(10) NULL,
--    case 
--        when b.max_omdte is not null then to_char(to_date(get_date_fm_btrv(b.max_omdte),'YYYYMMDD'),'DD-MM-YYYY')
--        else get_param('EOD_DATE')
--    end,
----   Frequency_Type         CHAR(1) NULL,
--    'M',
----   Freq_Week_Num_for_Principal     CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Freq_Week_Day_for_Principal     CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Freq_Start_DD_for_Principal     CHAR(2) NULL,
--    rpad( case 
--        when b.max_omdte is not null then SUBSTR(to_char(to_date(get_date_fm_btrv(b.max_omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2)
--        else SUBSTR(get_param('EOD_DATE'),1,2)
--    end,2,' '),
----   Freq_Months_for_Principal     CHAR(4) NULL,
--    lpad(' ',4,' '),
----   Freq_Days_for_Principal     CHAR(3) NULL,
--    lpad(' ',3,' '),
----   Freq_Hldy_Status_Principal     CHAR(1) NULL,
--    rpad('N',1,' '),
----   Number_of_Flows         CHAR(3) NULL,
--    lpad(' ',3,' '),
----   Installment_Amount         CHAR(17) NULL,
--    lpad('0',17,' '),
----   Installment_Percentage     CHAR(8) NULL,
--    lpad(' ',8,' '),
----   Number_of_Demands_Raised     CHAR(3) NULL,
--    lpad(' ',3,' '),
----   Next_Installment_Date     CHAR(10) NULL,
--    lpad(' ',10,' '),        
----   Next_Int_Installment_Date     CHAR(10) NULL,
--    rpad(' ',10,' '),
----   Frequency_Type_for_Interest     CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Frequency_Week_Number_for_Int CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Frequency_Week_day_for_Int     CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Frequency_Start_DD_for_Int     CHAR(2) NULL,
--    rpad(' ',2,' '),
----   Freq_Months_for_Int     CHAR(4) NULL,
--    lpad(' ',4,' '),
----   Freq_Days_for_Int     CHAR(3) NULL,
--    lpad(' ',3,' '),
----   Freq_Holiday_Status_for_Int     CHAR(1) NULL,
--    rpad(' ',1,' '),
----   Installment_Indicator     CHAR(1) NULL
--    rpad(' ',1,' ')
--from map_acc a
--inner join c8pf on c8ccy = currency
--inner join ld_deal_int_wise d on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--inner join (select distinct ombrnm,omdlp,omdlr,omdte from  ompf where to_number(omdte) > to_number(get_param('EODCYYMMDD')) and ommvt ='I' and (trim(ommvts) is null or ommvts='D'))e on ombrnm||trim(omdlp)||trim(omdlr)=d.LEG_ACC_NUM 
--left join ompf_cla_ld_indem b on b.fin_acc_num=a.fin_acc_num
--left join ompf_cla_ld_prdem1 c on c.fin_acc_num=a.fin_acc_num
--where TO_NUMBER(INDEM_CNT) > 1 and length(trim(leg_Acc_num))<13 ; 
--commit;
exit;
 