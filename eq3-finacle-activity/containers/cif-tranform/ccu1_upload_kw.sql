-- File Name        : cropcu1_upload.sql
-- File Created for    : Upload file for cropcu1
-- Created By        : Kumaresan
-- Client            : ABK
-- Created On        : 25-04-2016
-------------------------------------------------------------------
drop table last_dormant_dt;
create table last_dormant_dt as
select distinct fin_cif_id,scai85
from map_acc
inner join scpf  on scab=map_acc.leg_branch_id and scan=leg_scan and scas=leg_scas
where acc_closed is null and schm_type in ('SBA','CAA','ODA','PCA');
drop table corp_swift_code1;
create table corp_swift_code1 as
select distinct sxseq seq ,sxcus gfcus,sxclc gfclc,SVSWB||SVCNAS||SVSWL swift_code from svpf
left join sxpf on sxseq=svseq
where trim(SVSWB||SVCNAS||SVSWL) is not null and SXSEQ is not null
union
select distinct svseq,gfcus,gfclc,SVSWB||SVCNAS||SVSWL swift_code  from svpf
left join sxpf on sxseq=svseq
left join sypf on syseq=svseq
left join gfpf on gfcpnc=syan  
where trim(SVSWB||SVCNAS||SVSWL) is not null and SXSEQ is null;
drop table corp_swift_code;
create table corp_swift_code as
select corp.seq,corp.GFCUS,corp.gfclc,nvl(BIC,SWIFT_CODE) SWIFT_CODE from corp_swift_code1 corp
left join (select gfpf.GFCUS,gfpf.GFCLC,gfpf.GFCUN,cust.CMNE Treasury_cpty_Mnemonic,BIC from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on trim(map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC) = trim(gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC) and map_cif.INDIVIDUAL='N'
where cust.cmne not like 'AE%')opic on nvl(trim(corp.gfclc),' ')=nvl(trim(opic.gfclc),' ') and  trim(corp.gfcus)=trim(opic.gfcus);
set define off;
truncate table CU1CORP_O_TABLE;
insert into CU1CORP_O_TABLE
select 
--   CORP_KEY             CHAR(32) NULL,
    map_cif.FIN_CIF_ID,
-- ENTITY_TYPE              CHAR(30) NULL,
    'Customer',
-- CORPORATENAME_NATIVE               CHAR(80) NULL,
   --nvl(gfpf.GFCUN,'.'),    
   replace(nvl(gfpf.GFCUN,'ZZZ'),'&',' and '),
--   RELATIONSHIP_STARTDATE    CHAR(11) NULL,
    case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--   STATUS             CHAR(5) NULL,    
       --case when gfpf.GFCUD='Y' then 'DCSED' else 'ACTVE' end,
       case when trim(gfc5r)='DC' then 'DCSED' else 'ACTVE' end, -- changed As per Vijay mail confirmation on 20-03-2017
--   LEGALENTITY_TYPE         CHAR(30) NULL,
     -- gfpf.gfctp,
     case when trim(GFC3R)='SO' then '03' else 'ZZZ' end, ---changed on 31-05-2017 as per vijay mail dt 31-05-2017.
--   SEGMENT              CHAR(150) NULL,
    --'MIGR', 
    case 
	when trim(SEG_CODE) is not null and  nrd.officer_code is not null and trim(nrd.division)='001' then '3001'
	when trim(SEG_CODE) is not null and  trim(dv.DIVISION)='Corporate' then '3001'
	when trim(SEG_CODE) is null then '1001' else convert_codes('SEGMENT',trim(wmtype)) end,--- changed on 12-06-2017 based mk4a observation.--ZZZ to 1001(mass retail ) changed on 28-01-2017 as per vijay confirmation 
-- SUBSEGMENT              CHAR(150) NULL,
    case when trim(SEG_CODE)='J' then 'ZZZ' else to_char(nvl(trim(SEG_CODE),'ZZZ')) end,--NEED TO CHECK BPD AND LOV MAPPING
--   WEBSITE_ADDRESS         CHAR(100) NULL,
    '',
--   KEYCONTACT_PERSONNAME    CHAR(30) NULL,
   --case when trim(BGX1NM) is not null then substr(to_char(trim(BGX1NM)),1,30)
   --else 'MIGR'end,-- need to put data cleansing item
   case 
   when trim(cifid) is not null then substr(to_char(trim(key_person)),1,30)
   when trim(BGX1NM) is not null then substr(to_char(trim(BGX1NM)),1,30)
   else 'ZZZ'end,
--   PHONECITYCODE         CHAR(15) NULL,
    '.',-- as per dicussion with sandeep on 06-06-2017 mk4a observation
--   PHONELOCALCODE         CHAR(15) NULL,
'.',-- as per dicussion with sandeep on 06-06-2017 mk4a observation
--   PHONECOUNTRYCODE         CHAR(15) NULL,
   -- 'ZZZ',
   '.',-- as per dicussion with sandeep on 06-06-2017 mk4a observation
--   NOTES             CHAR(255) NULL,
    --'NULL',
	'',-- as per dicussion with sandeep on 06-06-2017 mk4a observation
--   PRINCIPLE_PLACEOPERATION    CHAR(30) NULL,
     	 case when trim(gfpf.GFCNAR)='AN' then 'AN'
              when trim(gfpf.GFCNAR)='CS' then 'CZ'    
              when trim(gfpf.GFCNAR)='WT' then 'TL'
              when trim(gfpf.GFCNAR)='CS' then 'CZ'
              when trim(gfpf.GFCNAR)='DD' then 'DE'
              when trim(gfpf.GFCNAR)='SU' then 'RU'
              when trim(gfpf.GFCNAR) is not null then TO_CHAR(gfpf.GFCNAR)
              else 'ZZZ' end,
--   BUSINESS_GROUP         CHAR(30) NULL,
     -- nvl(gfpf.GFGRP,'BG1'),
     --nvl(gfpf.GFGRP,'ZZZ'),
     'BG1',
-- PRIMARYRM_ID             CHAR(15) NULL,
case when nrd.officer_code is not null and trim(nrd.loginid) is not null  then to_char(trim(nrd.loginid))
when trim(gfpf.gfaco)='199' then '199'
when WMCUS is not null then convert_codes('RMCODE',trim(WMOFCOD))
		  else convert_codes('RMCODE',trim(gfpf.gfaco)) end,
--   DATE_OF_INCORPORATION    CHAR(11) NULL,
    case when bgpf.BGINDT<>0 and  length(bgpf.BGINDT)=8 then to_char(to_date(bgpf.BGINDT,'YYYYMMDD'),'DD-MON-YYYY') 
	when INCORPORATION_DATE is not null then to_char(to_date(INCORPORATION_DATE,'DD/MM/YYYY'),'DD-MON-YYYY') 
	when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
	else case  when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY') end end,------chaged on 16-07-2017 as per vijay confirmation based mk5 observation by darine mail DT 15-07-2017
--case when INCORPORATION_DATE is not null then to_char(to_date(INCORPORATION_DATE,'DD/MM/YYYY'),'DD-MON-YYYY') 
--when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
--when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
--end, --- changed as per vijay mail confirmation on 20-01-2017        
-- DATE_OF_COMMENCEMENT        CHAR(11) NULL,
    '',--need to check ABK IT
--   PRIMARY_SERVICE_CENTER    CHAR(30) NULL,
    map_cif.fin_sol_id,
--   RELATIONSHIP_CREATEDBY    CHAR(30) NULL,
    'UBSADMIN',
--  SECTOR_CODE             CHAR(5) NULL,    
    case when trim(gfpf.gfca2)='WA' and trim(gfpf.GFC2R) is null  then 'K' ---added on 24-09-2017 as per discussion with anegha,sebi and ragul. 
	 else convert_codes('SECTOR_CODE',trim(gfpf.GFC2R)) end,
--   SUBSECTOR_CODE         CHAR(5) NULL,    
    --nvl(gfpf.GFCA2,'99999'),
    case when trim(gfpf.gfca2)='WA' and trim(gfpf.GFC2R) is null  then 'WA' ---added on 24-09-2017 as per discussion with anegha,sebi and ragul.
	else to_char(nvl(trim(gfpf.GFC2R),'ZZZ')) end,
--   TAXID             CHAR(50) NULL,
    '999',--As per sandeep conformation defaulted to 999
-- ENTITYCLASS             CHAR(30) NULL,
    --'MIG',--need to check with BPD and ABK IT
    'ZZZ',
-- AVERAGE_ANNUALINCOME        CHAR(20) NULL,
   --'0',--need to check with BPD and ABK IT
   '999',
--   SOURCE_OF_FUNDS         CHAR(50) NULL,
   --'0',--need to check with BPD and ABK IT
   '999',
--   GROUP_ID             CHAR(50) NULL,
    '', -- Need to check with Business/Infosys
--   GROUP_ID_CODE         CHAR(50) NULL,
    '', -- Need to check with Business/Infosys
--   PARENT_CIF             CHAR(38) NULL,
    '',
-- CUSTOMER_RATING_CODE        CHAR(5) NULL,
    --'',-- Need to check with Business/Infosys, can be captured from the P and C codes in Equation
	replace(trim(BGGRCD),'.',''),-- based on edwin mail dt 30-04-2017 script changed.
-- HEALTH_CODE             CHAR(5) NULL,
    --'777',              
    --'1',
	case when SCAIG7='N' and  SCAIJ6='N' then '1'
when SCAIG7='N' and  SCAIJ6='Y' then '2'
when SCAIG7='Y' and  SCAIJ6='N' then '4'
when SCAIG7='Y' and  SCAIJ6='Y' then '5'
else '1' end,-----BASED ON VIJAY MAIL DATED 10-07-2017 script changed
--   RECORD_STATUS         CHAR(150) NULL,
    '',
--   EFFECTIVE_DATE         CHAR(11) NULL,
    '',
--   LINE_OF_ACTIVITY_DESC    CHAR(50) NULL,
    nvl(trim(gfpf.gfca2),'ZZZ'), -- Need more clarification on the same
--   CUST_MGR_OPIN         CHAR(240) NULL,
    '',
--   CUST_TYPE_DESC         CHAR(50) NULL,
    '',
-- CUST_STAT_CHG_DATE         CHAR(11) NULL,
    '',
-- TDS_TBL_DESC             CHAR(50) NULL,
    '',
--   CUST_SWIFT_CODE         CHAR(12) NULL,
    case when trim(swift.swift_code) is not null then to_char(swift.swift_code) 
    else '' end,
--   IS_SWIFT_CODE_OF_BANK 
    'N',    
--   CUSTDEPOSITSINOTHERBANKS     CHAR(20) NULL,
    '',
--   TOTALFUNDBASE         CHAR(25) NULL,
    '',
--   TOTALNONFUNDBASE         CHAR(25) NULL,
    '',
--   ADVANCEASONDATE         CHAR(11) NULL,
    '',
--   CUST_CONST             CHAR(5) NULL, --Default to YM    
    '',
--   DOCUMENT_RECEIVED_FLAG    CHAR(1) NULL,
    'Y',
-- CRNCY_CODE_CORPORATE        CHAR(5) NULL,
    'KWD',
--  TRADE_SERVICES_AVAILED    CHAR(1) NULL,
    --case when GFYTRI='Y' then  'Y'  else 'N' end,--need to check with santhos
    case when tf_party.cif_id is not null then 'Y' else 'N' end,
-- PRIMARYSOLID             CHAR(8) NULL,
    map_cif.fin_sol_id,
--   CHRG_DR_FORACID         CHAR(16) NULL,
    '',
--   CHRG_DR_SOL_ID         CHAR(8) NULL,
    '',
--   CUST_CHRG_HISTORY_FLG    CHAR(1) NULL,
    '',
--  TOT_TOD_ALWD_TIMES         CHAR(5) NULL,
    '',
--   SMALL_STR1             CHAR(50) NULL,
    '',
--   SMALL_STR2             CHAR(50) NULL,
    '',
--   SMALL_STR3             CHAR(50) NULL,
    '',
--   SMALL_STR4             CHAR(50) NULL,
    '',
--   SMALL_STR5             CHAR(50) NULL,
    '',
--   SMALL_STR6             CHAR(50) NULL,
    '',
--   SMALL_STR7             CHAR(50) NULL,
    '',
--   SMALL_STR8             CHAR(50) NULL,
    '',
--   SMALL_STR9             CHAR(50) NULL,
    '',
-- SMALL_STR10             CHAR(50) NULL,
    '',
--   MED_STR1             CHAR(100) NULL,
    '',
--   MED_STR2             CHAR(100) NULL,
    '',
--   MED_STR3             CHAR(100) NULL,
    '',
--   MED_STR4             CHAR(100) NULL,
    '',
--   MED_STR5             CHAR(100) NULL,
    '',
--   MED_STR6             CHAR(100) NULL,
    '',
--   MED_STR7             CHAR(100) NULL,
    '',
--   MED_STR8             CHAR(100) NULL,
    '',
--   MED_STR9             CHAR(100) NULL,
    '',
--   MED_STR10             CHAR(100) NULL,
    '',
--   LARGE_STR1             CHAR(250) NULL,
    '',
--   LARGE_STR2             CHAR(250) NULL,
    '',
--   LARGE_STR3             CHAR(250) NULL,
    '',
--   LARGE_STR4             CHAR(250) NULL,
    '',
--   LARGE_STR5             CHAR(250) NULL,
    '',
--   DATE1             CHAR(8) NULL,
    '',
--   DATE2             CHAR(8) NULL,
    '',
--   DATE3             CHAR(8) NULL,
    case when FA01DTE is not null then to_char(to_date(get_date_fm_btrv(FA01DTE),'YYYYMMDD'),'DD-MON-YYYY') 
	when scj7.scaij7='Y' then to_char(Add_months(si_next_exec_date(case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_date(BGCODT,'YYYYMMDD') when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD') end,'Y'),-12),'DD-MON-YYYY')--- changed on 11-07-2017 as per vijay confirmation based on sandeep mail dt 11-07-2017
	else to_char(Add_months(si_next_exec_date(case when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_date(BGCODT,'YYYYMMDD') when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD') end,'X'),-36),'DD-MON-YYYY') end,--- changed on 11-07-2017 as per vijay confirmation based on sandeep mail dt 11-07-2017
	--else '' end, --- as per discussion with vijay on 30-04-2017 script added.
--   DATE4             CHAR(8) NULL,
    '',
--   DATE5             CHAR(8) NULL,
    '',
--   DATE6             CHAR(8) NULL,
    '',
--   DATE7             CHAR(8) NULL,
    '',
--   DATE8             CHAR(8) NULL,
    '',
--   DATE9             CHAR(8) NULL,
    '',
--   DATE10             CHAR(8) NULL,
    '',
--   NUMBER1             CHAR(38) NULL,
    '',
--   NUMBER2             CHAR(38) NULL,
    '',
--   NUMBER3             CHAR(38) NULL,
    '',
--   NUMBER4             CHAR(38) NULL,
    '',
--   NUMBER5             CHAR(38) NULL,
    '',
--   NUMBER6             CHAR(38) NULL,
    '',
--   NUMBER7             CHAR(38) NULL,
    '',
--   NUMBER8             CHAR(38) NULL,
    '',
--   NUMBER9             CHAR(38) NULL,
    '',
--   NUMBER10             CHAR(38) NULL,
    '',
--   DECIMAL1             CHAR(25) NULL,
    '',
--   DECIMAL2             CHAR(25) NULL,
    '',
--   DECIMAL3             CHAR(25) NULL,
    '',
--   DECIMAL4             CHAR(25) NULL,
    '',
--   DECIMAL5             CHAR(25) NULL,
    '',
--   DECIMAL6             CHAR(25) NULL,
    '',
--   DECIMAL7             CHAR(25) NULL,
    '',
--   DECIMAL8             CHAR(25) NULL,
    '',
--   DECIMAL9             CHAR(25) NULL,
    '',
--   DECIMAL10             CHAR(25) NULL,
    '',
-- CORE_CUST_ID             CHAR(9) NULL,
    '',
--   CIFID             CHAR(32) NULL,
    map_cif.fin_cif_id,
--   CREATEDBYSYSTEMID         CHAR(50) NULL,
    '',
--   CORPORATENAME_NATIVE1    CHAR(80) NULL,
    '',
-- SHORT_NAME_NATIVE1         CHAR(10) NULL,
    '',
--   OWNERAGENT             CHAR(38) NULL,
    '',
--   PRIMARYRMLOGIN_ID         CHAR(50) NULL,
    --'FIVUSR',   -- No field called Managerid in customer table
    case when nrd.officer_code is not null and trim(nrd.loginid) is not null  then to_char(trim(nrd.loginid))
	when trim(gfpf.gfaco)='199' then '199'
	when WMCUS is not null then convert_codes('RMCODE',trim(WMOFCOD))
		  else convert_codes('RMCODE',trim(gfpf.gfaco)) end,
--   SecondRMLogin_ID         CHAR(50) NULL,
    '',
-- TERTIARYRMLOGIN_ID         CHAR(50) NULL,
    '',
--   ACCESSOWNERGROUP         CHAR(38) NULL,
    '',
-- ACCESSOWNERSEGMENT         CHAR(50) NULL,
    '',
--   ACCESSOWNERBC         CHAR(38) NULL,
    '',
--   ACCESSOWNERAGENT         CHAR(38) NULL,
    '',
-- ACCESSASSIGNEEAGENT         CHAR(38) NULL,
    '',
-- PRIMARYPARENTCOMPANY        CHAR(80) NULL,
    '',
-- COUNTRYOFPRINCIPALOPERATION    CHAR(100) NULL, 
    --nvl(gfpf.GFCNAL,'ZZZ')
    case when trim(gfpf.GFCNAP)='AN' then 'AN'
              when trim(gfpf.GFCNAP)='CS' then 'CZ'    
              when trim(gfpf.GFCNAP)='WT' then 'TL'
              when trim(gfpf.GFCNAP)='CS' then 'CZ'
              when trim(gfpf.GFCNAP)='DD' then 'DE'
              when trim(gfpf.GFCNAP)='SU' then 'RU'
              when trim(gfpf.GFCNAP) is not null then TO_CHAR(gfpf.GFCNAP)
              else 'ZZZ' end,
-- PARENTCIF_ID             CHAR(50) NULL,
    '',
--   CHARGELEVELCODE         CHAR(50) NULL,
    '',
--   COUNTRYOFORIGIN         CHAR(50) NULL,
--    nvl(gfpf.GFCNAP,'ZZZ'),
case when trim(gfpf.GFCNAP)='AN' then 'AN'
              when trim(gfpf.GFCNAP)='CS' then 'CZ'    
              when trim(gfpf.GFCNAP)='WT' then 'TL'
              when trim(gfpf.GFCNAP)='CS' then 'CZ'
              when trim(gfpf.GFCNAP)='DD' then 'DE'
              when trim(gfpf.GFCNAP)='SU' then 'RU'
              when trim(gfpf.GFCNAP) is not null then TO_CHAR(gfpf.GFCNAP)
              else 'ZZZ' end,
--   COUNTRYOFINCORPORATION    CHAR(50) NULL,
--    nvl(gfpf.GFCNAP,'ZZZ'),
case when trim(gfpf.GFCNAL)='AN' then 'AN'
              when trim(gfpf.GFCNAL)='CS' then 'CZ'    
              when trim(gfpf.GFCNAL)='WT' then 'TL'
              when trim(gfpf.GFCNAL)='CS' then 'CZ'
              when trim(gfpf.GFCNAL)='DD' then 'DE'
              when trim(gfpf.GFCNAL)='SU' then 'RU'
              when trim(gfpf.GFCNAL) is not null then TO_CHAR(gfpf.GFCNAL)
              else 'ZZZ' end,          
--   INTUSERFIELD1         CHAR(38) NULL,
    '',
--   INTUSERFIELD2         CHAR(38) NULL,
    '',
--   INTUSERFIELD3         CHAR(38) NULL,
    '',
--   INTUSERFIELD4         CHAR(38) NULL,
    '',
--   INTUSERFIELD5         CHAR(38) NULL,
    '',
--   v_StrUserField1            CHAR(100)
            case 
			when nrd.officer_code is not null and trim(nrd.division)  is not null then to_char(trim(nrd.division))
			when trim(dv.DIVISION)='Corporate' then '001'
when trim(dv.DIVISION)='International' then '002'
when trim(dv.DIVISION)='Retail' then '003'
when trim(dv.DIVISION)='Treasury' then '005'
else '003' end,  ---as per vijay mapping by mail on 09-03-2017. changed.  --Changed on 26-7-2017 after discussion with Vijay
--   v_StrUserField2            CHAR(100)
            case when nrd.officer_code is not null and trim(SUBDIVISION)  is not null  then to_char(nrd.subdivision)
			when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='CBD' then '00109'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Contracting' then '00130'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Financial Institutions' then '00160'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Infrastructure' then '00110'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Investment' then '00100'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Remedial' then '00180'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='SME' then '00120'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Services' then '00140'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Structured Workout' then '00170'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Trading' then '00150'
when trim(dv.DIVISION)='International' and trim(dv.unit)='Financial Institutions' then '00203'
when trim(dv.DIVISION)='International' and trim(dv.unit)='IBD' then '00200'
when trim(dv.DIVISION)='International' and trim(dv.unit)='Multinational & Oil' then '00204'
when trim(dv.DIVISION)='International' and trim(dv.unit)='NPL' then '00200'
when trim(dv.DIVISION)='Retail' and trim(dv.unit)='RBD' then '00339'  --Changed on 26-7-2017 after discussion with Vijay
when trim(dv.DIVISION)='Treasury' and trim(dv.unit)='TRSY' then '00500'
else '00339' end,  ---as per vijay mapping by mail on 09-03-2017. changed.  --Changed on 26-7-2017 after discussion with Vijay
    --   StrUserField3         CHAR(100) NULL,
    nvl(mosal,'999'),
--   StrUserField4         CHAR(100) NULL,    
    --case when trim(FA01GIIN) is not null then to_char(substr(trim(FA01EC),4,10)) else 'OTHER' end,
    case when trim(FA01EC)='01-REGFFI' and trim(FA01GIIN) is null then 'OTHER'
    when trim(FA01EC) is not null then to_char(substr(trim(FA01EC),4,10))  else 'OTHER' end,--changed on 23-03-2017 as per Vijay mail 20-03-2017. 
--   StrUserField5         CHAR(100) NULL,
    case when trim(FA01GIIN) is not null then to_char(trim(FA01GIIN))
    else '' end,
--   StrUserField6         CHAR(100) NULL,
    convert_codes('SUNDRY_ANALYSIS_CODE',trim(gfpf.GFSAC)),
--   StrUserField7         CHAR(100) NULL,
    --'IN PERSON',
	case when trim(KYACCO)='1' then 'InPerson' --added the conditions based on the email confirmation from Vijay on 09-05-2017
	     when trim(KYACCO)='2' then 'POA' 
		 when trim(KYACCO)='3' then 'JOINT'
         else 'InPerson' end, --Based on sandeep mail confirmation script changed on 22-01-2017.
--   StrUserField8         CHAR(100) NULL,
    MOODYS_GRADE, 
--   StrUserField9         CHAR(100) NULL,
    FI_LT,
--   StrUserField10         CHAR(100) NULL, -- Sensitivity
    S_P_LT,
--   StrUserField11         CHAR(100) NULL,
    orr.RISK_RATING,
--   StrUserField12         CHAR(100) NULL,
    --'Branches',                                      -- DEFAULT BLANK
            '001', --Based on sandeep mail confirmation script changed on 22-01-2017.
--   StrUserField13         CHAR(100) NULL,
    BANK_FINAL_RATING,
--   StrUserField14         CHAR(100) NULL,
    '',
--   StrUserField15         CHAR(100) NULL,
     --   'CURRENT ACCOUNT',                                      -- DEFAULT BLANK
         case when ef_account is not null then 'EF' else 'CA' end, --Based on sandeep mail confirmation script changed on 22-01-2017.-- Based on Vijay and nagi discussed with hiyam on 29-08-2017 'EF' passed for AL amil customer
--   StrUserField16         CHAR(100) NULL,
--case when trim(ias24.Status)='Associate' then 'A' when trim(ias24.Status)='Chairman' then  'B' when trim(ias24.Status)='Director' then 'D' when trim(ias24.Status)='EXECUTIVE' then 'F'
--when trim(ias24.Status)='Related Party - Associate' then 'G' when trim(ias24.Status)='Related Party - Chairman' then 'I' when trim(ias24.Status)='Related Party - Director' then 'J'
--when trim(ias24.Status)='Shareholder' then 'M' else '' end,   ----IAS24 condition added as per sandeep mail dt 03-07-2017
CONVERT_CODES('IAS24',UPPER(IAS24.STATUS)),---CHANGED ON 10-08-2017 -- BASED ON uat ISSUE
--   StrUserField17         CHAR(100) NULL,
    '',
--   StrUserField18         CHAR(100) NULL,
    '',
--   StrUserField19         CHAR(100) NULL,
    '',
--   StrUserField20         CHAR(100) NULL,
    '',
--   StrUserField21         CHAR(100) NULL,
    '',
--   StrUserField22         CHAR(100) NULL,
    '',
--   StrUserField23         CHAR(100) NULL,
    '',
--   StrUserField24         CHAR(100) NULL,
    '',
--   StrUserField25         CHAR(100) NULL,
    '',
--   StrUserField26         CHAR(100) NULL,
    '',
--   StrUserField27         CHAR(100) NULL,
    '',
--   StrUserField28         CHAR(100) NULL,----CBK secret no
    BGCSNO,    
--   StrUserField29         CHAR(100) NULL,
     '',
--   StrUserField30         CHAR(100) NULL,
    '',
--   DateUserField1         CHAR(8) NULL,
--case  when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
--when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')end,--- changed as per vijay mail confirmation on 20-01-2017             
case when scj7.scaij7='Y' then to_char(Add_months(si_next_exec_date(case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_date(BGCODT,'YYYYMMDD') when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD') end,'Y'),-12),'DD-MON-YYYY')
  else to_char(Add_months(si_next_exec_date(case when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_date(BGCODT,'YYYYMMDD') when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD') end,'X'),-36),'DD-MON-YYYY') end,	  --- changed as per vijay mail confirmation on 26-04-2017            
--   DateUserField2         CHAR(8) NULL,
       --  case when scj7.scaij7='Y' then to_char(add_months(to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),12),'DD-MON-YYYY') else to_char(add_months(to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),36),'DD-MON-YYYY') end,
  case when scj7.scaij7='Y' then to_char(si_next_exec_date(case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_date(BGCODT,'YYYYMMDD') when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD') end,'Y'),'DD-MON-YYYY')
  else to_char(si_next_exec_date(case when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_date(BGCODT,'YYYYMMDD') when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD') end,'X'),'DD-MON-YYYY') end,	  
--   DateUserField3         CHAR(8) NULL,
    '',
--   DateUserField4         CHAR(8) NULL,
    '',
--   DateUserField5         CHAR(8) NULL,
    '',
--   NATIVELANGCODE         CHAR(10) NULL,
     'INFENG',
--   CUST_HLTH             CHAR(200) NULL,
    --'777',
    '999',
--   LASTSUBMITTEDDATE         CHAR(11) NULL,
    '',
-- RISK_PROFILE_SCORE         CHAR(38) NULL,
    '',
--   RISK_PROFILE_EXPIRY_DATE    CHAR(11) NULL,
    '',
-- OUTSTANDING_MORTAGE         CHAR(20) NULL,
    '',
--   CORPORATE_NAME         CHAR(100) NULL,
    --nvl(trim(gfpf.GFCUN),'.'),
    nvl(trim(gfpf.GFCUN),'ZZZ'),
--   SHORT_NAME             CHAR(10) NULL,
	case when trim(regexp_replace(upper(gfpf.GFDAS),'[-,_,.,<,`,@,&,=,#,+,/,(,),;,'']','')) is not null then to_char(substr(regexp_replace(upper(gfpf.GFDAS),'[-,_,.,<,`,@,&,=,#,+,/,(,),;,'']',''),1,10)) when trim(regexp_replace(upper(gfpf.GFCUN),'[-,_,.,<,`,@,&,=,#,+,/,(,),;,'']','')) is not null  then 
			to_char(substr(regexp_replace(upper(gfpf.GFCUN),'[-,_,.,<,`,@,&,=,#,+,/,(,),;,'']',''),1,10)) else 'ZZZ' end,
--   SHORT_NAME_NATIVE         CHAR(10) NULL,
    '',
-- REGISTRATION_NUMBER         CHAR(38) NULL,
    --case  when trim(gfpf.GFCRF)='REG' then 'MIGR123'
        --  when trim(gfpf.GFCRF)='REG.' then 'MIGR123'
       --  when trim(gfpf.GFCRF) is not null then to_char(trim(gfpf.GFCRF))
    --else 'MIGR123' end,
    case  when trim(gfpf.GFCRF)='REG' then 'ZZZ999'
          when trim(gfpf.GFCRF)='REG.' then 'ZZZ999'
          when trim(gfpf.GFCRF) is not null then to_char(trim(gfpf.GFCRF))
    else 'ZZZ999' end,
--   CHANNELSACCESSED         CHAR(500) NULL,
    '',
-- ZIP                 CHAR(100) NULL,
    '',
--   BACKENDID             CHAR(50) NULL,
    '',
--   DELINQUENCYFLAG         CHAR(3) NULL,
    '',
-- SUSPEND_FLAG             CHAR(1) NULL,
--case when trim(gfc5r)is not null and trim(gfc5r) = 'BL' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'BM' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'BN' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'BP' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'BW' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'CF' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'DC' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'DD' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'DE' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'DF' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'DG' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'DL' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'DT' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'DW' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'IF' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'LA' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'LC' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'LD' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'LE' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'LG' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'LH' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'LI' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'LP' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'LR' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'NL' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'PL' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'RA' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'RB' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'RC' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'SL' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'UL' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'UM' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'US' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'UT' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'UV' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'UX' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'WA' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'WC' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'WL' then  'Y'
--    when trim(gfc5r)is not null and trim(gfc5r) = 'XX' then  'Y'
--    else 'N'end,
     case when susp_cif.fin_cif_id is not null then 'Y'
	 	 when trim(gfc5r) in ('AL','BK','BL','BW','CF','DC','LA','LC','LD','LE','LG','LH','LI','LP','LR','PL','SL','UL','US','UT','WL','XX') then 'Y' --IF and Nl removed al,bk added on 15-09-2017 based on nagi mail dt 07-09-2017
		 when trim(gfc3r) ='NF' then 'Y' -- added on 6-Sep-2017 on mail from Hiyam dated  6-Sep-2017
		 else  'N' end,
--   SUSPEND_NOTES         CHAR(2000) NULL,
    '',
--   SUSPEND_REASON         CHAR(2000) NULL,
     --case when trim(gfc5r)is not null and trim(gfc5r) in('BL', 'BM', 'BN','BP', 'BW', 'CF', 'DC', 'DD', 'DE', 'DF', 'DG', 'DL', 'DT', 'DW', 'IF', 'LA', 'LC', 'LD', 'LE', 'LG', 'LH', 'LI', 'LP', 'LR', 'NL', 'PL', 'RA', 'RB', 'RC', 'SL', 'UL', 'UM', 'US', 'UT', 'UV', 'UX', 'WA', 'WC', 'WL', 'XX')
     --then convert_codes('GFC5R',trim(gfc5r))    
     --else '' end,                                      -- DEFAULT BLANK
      case 
	  when trim(gfc5r) in ('AL','BK','BL','BW','CF','DC','LA','LC','LD','LE','LG','LH','LI','LP','LR','PL','SL','UL','US','UT','WL','XX')  then to_char(trim(gfc5r))  --IF and Nl removed al,bk added on 15-09-2017 based on nagi mail dt 07-09-2017
	   when trim(gfc3r) ='NF' then 'NF' -- added on 6-Sep-2017 on mail from Hiyam dated  6-Sep-2017
	   else '' end,
--   BLACKLIST_FLAG         CHAR(1) NULL,
    '',
--   BLACKLIST_NOTES         CHAR(2000) NULL,
    '',
--   BLACKLIST_REASON         CHAR(2000) NULL,
    '',
--   NEGATIVE_FLAG         CHAR(1) NULL,
    '',
--   NEGATIVE_NOTES         CHAR(2000) NULL,
    '',
--   NEGATIVE_REASON         CHAR(2000) NULL,
    '',
--   DSAID             CHAR(50) NULL,
    '999',--As per sandeep conformation defaulted to 999
--   CUSTASSET_CLASSIFICATION    CHAR(5) NULL,
    'S', --- as per mail dt 26-03-2017 by sandeep and spira ticket number 5525.  
--   CLASSIFIED_ON         CHAR(11) NULL,
    '',
-- CUST_CREATION_MODE         CHAR(1) NULL,
    '',
--   INCREMENTALDATEUPDATE    CHAR(11) NULL,
    '',
--   LANG_CODE             CHAR(50) NULL,
    'INFENG', -- No proper value for the same
--  TDS_CUST_ID             CHAR(9) NULL,
    '',
-- OTHERLIMITS             CHAR(20) NULL,
    '',
-- CORE_INTROD_CUST_ID         CHAR(9) NULL,
    '',
-- INTROD_NAME             CHAR(40) NULL,
    '',
--   INTROD_STAT_CODE         CHAR(5) NULL,
    '',
-- ENTITY_STAGE             CHAR(200) NULL,
    '',
-- ENTITY_STEP_STATUS         CHAR(50) NULL,
    '',
--   EMAIL2             CHAR(50) NULL,
    '',
--   CUST_GRP             CHAR(50) NULL,
    '',
--   CUST_CONST_CODE         CHAR(5) NULL, 
     nvl(trim(gfpf.gfca2),'ZZZ'),
--   CUSTASSET_CLSFTION_CODE    CHAR(5) NULL,
    '',
--   LEGALENTITY_TYPE_CODE    CHAR(5) NULL,
       -- gfctp,
       '',
-- REGION_CODE             CHAR(5) NULL,
     '999',--need to get Legacy field mapping 
--   PRIORITY_CODE         CHAR(8) NULL,
     --'MEDIUM',--need to get Legacy field mapping 
     'Normal',
-- BUSINESS_TYPE_CODE         CHAR(45) NULL,
  gfctp,
--   RELATIONSHIP_TYPE_CODE    CHAR(45) NULL,
    --'New', -- Need to clarify on the same
    'New',
--   CRNCY_CODE             CHAR(5) NULL,
    'KWD',
-- STR1                 CHAR(1) NULL,
    '',
-- STR2                 CHAR(8) NULL,
    '',
-- STR3                 CHAR(1) NULL,
   '',
-- STR4                 CHAR(1) NULL,
    '',
-- STR5                 CHAR(8) NULL,
    '',
-- STR6                 CHAR(100) NULL,
    '',
-- STR7                 CHAR(100) NULL,
    '',
-- STR8                 CHAR(100) NULL,
    '',
-- STR9                 CHAR(100) NULL,
    '',
--   STR10             CHAR(100) NULL,
    '',
--   STR11             CHAR(200) NULL,
    '',
--   STR12             CHAR(200) NULL,
    '',
--   STR13             CHAR(200) NULL,
    '',
--   STR14             CHAR(200) NULL,
    '',
--   STR15             CHAR(200) NULL,
    '',
--   AMOUNT1             CHAR(20) NULL,
    --'0',--need to get Legacy field mapping 
    '999',
--   AMOUNT2             CHAR(20) NULL,
    '',
--   AMOUNT3             CHAR(20) NULL,
    '',
--   AMOUNT4             CHAR(20) NULL,
    '',
--   AMOUNT5             CHAR(20) NULL,
    '',
-- INT1                 CHAR(38) NULL,
    '',
-- INT2                 CHAR(38) NULL,
    '',
-- INT3                 CHAR(38) NULL,
    '',
-- INT4                 CHAR(38) NULL,
    '',
-- INT5                 CHAR(38) NULL,
    '',
--   Flag1             CHAR(10) NULL,
    '',
--   Flag2             CHAR(10) NULL,
    '',
--   Flag3             CHAR(10) NULL,
    'Y', --defaulted to Yes as per the email from Vijay on 04/06/2017 
--   Flag4             CHAR(10) NULL,
    case when KYC_PEP.customer_no is not null then 'Y' when trim(gfctp) in ('EB','ET') then 'Y'  else 'N' end,--EB customer type also added on 26-04-2017 based on vijay confirmation
--   Flag5             CHAR(10) NULL,
case when high.cust_no is not null then 'Y' else 'N' end, ------changed on 26-07-2017 as per vijay mail dt on 25-07-2017--Sandeep has provided to to populate
-- MLUSERFIELD1             CHAR(80) NULL,
    '',
-- MLUSERFIELD2             CHAR(80) NULL,
    '',
-- MLUSERFIELD3             CHAR(80) NULL,
    '',
-- MLUSERFIELD4             CHAR(80) NULL,
    '',
-- MLUSERFIELD5             CHAR(80) NULL,
    '',
-- MLUSERFIELD6             CHAR(80) NULL,
    '',
-- MLUSERFIELD7             CHAR(80) NULL,
    '',
--MLUSERFIELD8             CHAR(80) NULL,
    '',
-- MLUSERFIELD9             CHAR(80) NULL,
    '',
-- MLUSERFIELD10         CHAR(100) NULL,
    '',
--   UNIQUEGROUPFLAG         CHAR(1) NULL,
    '',
--   BANK_ID             CHAR(8) NULL,
    get_param('BANK_ID'),
--   ZAKAT_DEDUCTION         CHAR(1) NULL,
    '',
-- ASSET_CLASSIFICATION        CHAR(1) NULL,
    'S', --- as per mail dt 26-03-2017 by sandeep and spira ticket number 5525.  
--  CUSTOMER_LEVEL_PROVISIONING    CHAR(1) NULL,
    '',
--   ISLAMIC_BANKING_CUSTOMER    CHAR(1) NULL,
    '',
--   PREFERREDCALENDAR         CHAR(50) NULL,
    --'GREGORIAN',
    '00',
--   IDTYPEC1             CHAR(50) NULL,
    map_cif.fin_cif_id,--as per sandeep conformation.
--   IDTYPEC2             CHAR(50) NULL,
    '',
--   IDTYPEC3             CHAR(50) NULL,
    '',
--   IDTYPEC4             CHAR(50) NULL,
    '',
--   IDTYPEC5             CHAR(50) NULL,
    '',
--   IDTYPEC6             CHAR(50) NULL,
    '',
--   IDTYPEC7             CHAR(50) NULL,
    '',
--   IDTYPEC8             CHAR(50) NULL,
    '',
--   IDTYPEC9             CHAR(50) NULL,
    '',
--   IDTYPEC10             CHAR(50) NULL,
    '',
-- CORPORATE_NAME_ALT1         CHAR(80) NULL,
    '',
--   short_Name_alt1          CHAR(99) NULL,
    '',
--   KEYCONTACT_PERSONNAME_ALT1    CHAR(30) NULL,
    '',
--   PARENT_CIF_ALT1          CHAR(38) NULL,
    '',
-- BOCREATEDDBYLOGINID         CHAR(50) NULL
     '',
-- submit_for_kyc                NVARCHAR2(11) NULL,
     '',
-- kyc_rev_date          NVARCHAR2(11) NULL,
      '',
-- kyc_date              NVARCHAR2(11) NULL,
      '',
-- riskrating                    NVARCHAR2(11) NULL,
   case when scj7.scaij7='Y' then 'HIGH'  else 'LOW' end,--changed on 28-02-2017.
-- FATCA_Required                 NVARCHAR2(11) NULL,
   '',
-- forgn_tax_rep_req_cuntry    NVARCHAR2(11) NULL,
      '',
-- forgn_tax_rep_req_status    NVARCHAR2(11) NULL,
      '',
-- last_forgn_tax_revw_date     NVARCHAR2(11) NULL,
      '',
-- next_forgn_tax_revw_date     NVARCHAR2(11) NULL,
      '',
-- TIN_EIN                        NVARCHAR2(11) NULL,
   '',      
-- GIIN                         NVARCHAR2(11) NULL,
      '',
--cust_type_code  Nvarchar2(5) Null,
''    ,
--Purge_text
--case when trim(salary.cif) is not null then 'SALARY' else 'ZZZ' end -- changed on 9 april based on vijays mail dated 12 March
case  when trim(fin_value) is not null then to_char(fin_value) else 'BUSINESS' end
from map_cif 
inner join gfpf   on trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=bgpf.BGCUS 
left join YUFA01PF on nvl(trim(FA01CLC),' ')=nvl(trim(gfpf.GFCLC),' ') and FA01CUS=trim(gfpf.gfcus) and trim(FA01RCT) is not NULL
left join (select distinct scan ,scaij7 from scpf where  scaij7='Y')scj7 on scj7.scan=gfpf.gfcpnc
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(gfaco)
left join rm_code_mapping dv on RESPONSIBILITY_CODE =trim(gfaco)
left join RM_Segment_Mapping vip_rmcode on nvl(trim(WMCLC),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(WMCUS)=trim(map_cif.gfcus)
left join propreitorship_date on substr(acc_num,1,10)=fin_cif_id
left join (select distinct cust_no from hv_accounts_corp) high on high.cust_no=fin_cif_id
--left join (select distinct customer_no from KYC_PEP where trim(PEP)='YES') KYC_PEP on replace(trim(KYC_PEP.customer_no),'-','')=fin_cif_id
left join pep_customer KYC_PEP on to_number(replace(trim(customer_no),'-',''))=nvl(trim(map_cif.gfclc),' ')||trim(map_cif.gfcus)--- based on vijay mail dt 06-07-2017 changed
left join (select * from corp_swift_code where seq in (select  max(seq) from corp_swift_code group by gfcus,gfclc)) swift on trim(swift.gfclc)=trim(map_cif.gfclc) and  trim(swift.gfcus)=trim(map_cif.gfcus)
left join rating_data on map_cif.fin_cif_id =replace(trim(rating_data.customer_no),'-','')
left join  sub_segment on trim(clc)=map_cif.gfclc and trim(cus)=map_cif.gfcus
left join ORR_MANUAL_DATA orr on orr.cif_id = map_cif.fin_cif_id
left join (select distinct trim(cif_id) cif_id from tf_cif_address)tf_party on trim(tf_party.cif_id)=fin_cif_id  
left join (select distinct fin_cif_id cif from map_acc where trim(leg_branch_id)||trim(leg_scan)||trim(leg_scas) in(select trim(acc_num) from salary_acc))salary on salary.cif=fin_cif_id
left join (select distinct fin_cif_id,Scan,scaig7,scaij6  from scpf inner join map_cif on scan=gfcpnc where scai30 <> 'Y'  and individual='Y' and (scaig7='Y' or scaij6='Y')) thump on thump.fin_cif_id=map_cif.fin_cif_id
left join (select substr(trim(company_ac),1,10) cif,max(mosal) mosal from COMP_MOSAL group by substr(trim(company_ac),1,10)) mos on mos.cif=map_cif.fin_cif_id
left join  ukyc01pf a  on nvl(a.kyclc,' ')=nvl(map_cif.gfclc,' ')  and  a.kycus=map_cif.gfcus 
left join acc_ope_pur_map b on trim(a.KYPUR1)=trim(b.KYPUR1)
left join ias24 on ias24.cust_no=lpad(trim(map_cif.gfclc),4,'0')||trim(map_cif.gfcus)
left join (select * from last_dormant_dt where fin_cif_id in (
select fin_cif_id from (select distinct fin_cif_id,scai85 from last_dormant_dt) group by fin_cif_id having count(*) =1) and scai85='Y') susp_cif on susp_cif.fin_cif_id=map_cif.fin_cif_id
--left join (select distinct cust_no from hv_accounts) high on cust_no=fin_cif_id
--left join (select distinct fin_cif_id sal_cif from map_acc where schm_code in ('CASTF','CAALR','CAPRE','SBAPL','SBAML','CAAPR','CAPPR'))sal on sal_cif =map_cif.fin_cif_id
--left join (select distinct fin_cif_id busi_cif from map_acc where schm_code in ('CAPOS','CAPRM','CAALT' ,'CAAA','CARPR','CATPR','CAMPR','CARET')) busi on busi_cif =map_cif.fin_cif_id
--left join (select distinct fin_cif_id savi_busi from map_acc where schm_code in ('SCALR','SBGER','SBKID','SBDAL','SBAMG','SBMNR')) savi on savi_cif =map_cif.fin_cif_id
left join (select distinct fin_cif_id ef_account from map_acc where schm_code='SBAML') amil on  ef_account=map_cif.fin_cif_id
left join key_person on cifid=map_cif.fin_cif_id
where map_cif.individual='N' and map_cif.del_flg<>'Y'; 
commit;
DELETE from cu1corp_o_table where rowid not in (select min(rowid) from cu1corp_o_table group by corp_key );
commit;
exit; 

  
 