-- File Name		: cu3_upload.sql
-- File Created for	: Upload file for cu3
-- Created By		: Jagadeesh M
-- Client			: Emiretes Islamic Bank
-- Created On		: 27-05-2015
-------------------------------------------------------------------
drop table cust_currency;
create table cust_currency
as
--   SELECT DISTINCT fin_cif_id, to_char(scccy) currency, individual, del_flg FROM scpf scpf_kw INNER JOIN map_cif  ON scan = gfcpnc
SELECT DISTINCT fin_cif_id, to_char(nvl(scccy,'KWD')) currency, individual, del_flg FROM map_cif  
       left JOIN scpf scpf_kw 
                   ON scan = gfcpnc
   UNION  					
   SELECT DISTINCT fin_cif_id, leg_code, individual, del_flg
              FROM map_cif a,
                   (SELECT leg_code
                      FROM map_codes
                     WHERE code_type = 'CCY');
create index cust_ccy_idx on cust_currency(individual,del_flg);			   
truncate table CU3_O_TABLE;
INSERT INTO CU3_O_TABLE
 SELECT  distinct
--   v_ORGKEY               CHAR(32)
    fin_cif_id,
    --products.seqid,    
--   v_CIF_ID              CHAR(32)
    fin_cif_id,
    --products.seqid,
--   v_STRTEXT1          CHAR(255)
    '',
--   v_STRTEXT2           CHAR(255)
    '',
--   v_TYPE              CHAR(50)
    'CURRENCY',
--   v_CUSTOMERCURRENCY         CHAR(3)
--	 trim(CURRENCY), 
  CCY,-- Script changed on 30-05-2017 based on Vijay confirmation and mail dt on 29-05-2017
--   v_CREDITDISCOUNTPERCENT     CHAR(9)
    '',    
--   v_DEBITDISCOUNTPERCENT       CHAR(9)
    '',
--   v_WITHHOLDTAXPCNT       CHAR(9)
    '',
--   v_WITHHOLDTAXFLOORLMT     CHAR(20)
    '',
--   v_DTDATE1             CHAR(17)
    '31-DEC-2099',
--   v_DTDATE2             CHAR(17)
    '',
--   v_countryofissue_code       CHAR(5)
    '',
--   v_SMALL_STR1           CHAR(50)
    '',
--   v_SMALL_STR2           CHAR(50)
    '',
--   v_SMALL_STR3         CHAR(50)
    '',
--   v_SMALL_STR4         CHAR(50)
    '',
--   v_SMALL_STR5         CHAR(50)
    '',
--   v_SMALL_STR6         CHAR(50)
    '',
--   v_SMALL_STR7         CHAR(50)
    '',
--   v_SMALL_STR8         CHAR(50)
    '',
--   v_SMALL_STR9         CHAR(50)
    '',
--   v_SMALL_STR10         CHAR(50)
    '',
--   v_MED_STR1             CHAR(100)
    '',
--   v_MED_STR2             CHAR(100)
    '',
--   v_MED_STR3             CHAR(100)
    '',
--   v_MED_STR4             CHAR(100)
    '',
--   v_MED_STR5             CHAR(100)
    '',
--   v_MED_STR6             CHAR(100)
    '',
--   v_MED_STR7             CHAR(100)
    '',
--   v_MED_STR8             CHAR(100)
    '',
--   v_MED_STR9             CHAR(100)
    '',
--   v_MED_STR10         CHAR(100)
    '',
--   v_LARGE_STR1         CHAR(250)
    '',
--   v_LARGE_STR2         CHAR(250)
    '',
--   v_LARGE_STR3         CHAR(250)
    '',
--   v_LARGE_STR4         CHAR(250)
    '',
--   v_LARGE_STR5         CHAR(250)
    '',
--   v_DATE1             CHAR(17)
    '',
--   v_DATE2             CHAR(17)
    '',
--   v_DATE3             CHAR(17)
    '',
--   v_DATE4             CHAR(17)
    '',
--   v_DATE5             CHAR(17)
    '',
--   v_DATE6             CHAR(17)
    '',
--   v_DATE7             CHAR(17)
    '',
--   v_DATE8             CHAR(17)
    '',
--   v_DATE9             CHAR(17)
    '',
--   v_DATE10             CHAR(17)
    '',
--   v_NUMBER1             CHAR(38)
    '',
--   v_NUMBER2             CHAR(38)
    '',
--   v_NUMBER3             CHAR(38)
    '',
--   v_NUMBER4             CHAR(38)
    '',
--   v_NUMBER5             CHAR(38)
    '',
--   v_NUMBER6             CHAR(38)
    '',
--   v_NUMBER7             CHAR(38)
    '',
--   v_NUMBER8             CHAR(38)
    '',
--   v_NUMBER9             CHAR(38)
    '',
--   v_NUMBER10             CHAR(38)
    '',
--   v_DECIMAL1             CHAR(25)
    '',
--   v_DECIMAL2             CHAR(25)
    '',
--   v_DECIMAL3             CHAR(25)
    '',
--   v_DECIMAL4             CHAR(25)
    '',
--   v_DECIMAL5             CHAR(25)
    '',
--   v_DECIMAL6             CHAR(25)
    '',
--   v_DECIMAL7             CHAR(25)
    '',
--   v_DECIMAL8             CHAR(25)
    '',
--   v_DECIMAL9             CHAR(25)
    '',
--   v_DECIMAL10         CHAR(25)
    '',
--   v_STRTEXT3             CHAR(255)
     gfpf.gfca2,
--   v_STRTEXT4             CHAR(255)
    '',
--   v_STRTEXT5             CHAR(255)
    '',
--   v_STRTEXT6             CHAR(255)
    '',
--   v_STRTEXT7             CHAR(255)
    '',
--   v_STRTEXT8             CHAR(255)
    '',
--   v_STRTEXT9             CHAR(255)
    '',
--   v_STRTEXT10         CHAR(255)
    CCY,-- Script changed on 30-05-2017 based on Vijay confirmation and mail dt on 29-05-2017
--   v_INTINTEGER1         CHAR(38)
    '',
--   v_INTINTEGER2         CHAR(38)
    '',
--   v_INTINTEGER3         CHAR(38)
    '',
--   v_INTINTEGER4         CHAR(38)
    '',
--   v_INTINTEGER5         CHAR(38)
    '',
--   v_INTINTEGER6         CHAR(38)
    '',
--   v_INTINTEGER7         CHAR(38)
    '',
--   v_INTINTEGER8         CHAR(38)
    '',
--   v_INTINTEGER9         CHAR(38)
    '',
--   v_INTINTEGER10         CHAR(38)
    '',
--   v_INTINTEGER11         CHAR(38)
    '',
--   v_INTINTEGER12         CHAR(38)
    '',
--   v_INTINTEGER13         CHAR(38)
    '',
--   v_INTINTEGER14         CHAR(38)
    '',
--   v_INTINTEGER15         CHAR(38)
    '',
--   v_DTDATE3             CHAR(17)
    '',
--   v_DTDATE4             CHAR(17)
    '',
--   v_DTDATE5             CHAR(17)
    '',
--   v_DBFLOAT1             CHAR(17)
    '0',
--   v_DBFLOAT2             CHAR(17)
    '0',
--   v_DBFLOAT3             CHAR(17)
    '0',
--   v_DBFLOAT4             CHAR(17)
    '0',
--   v_DBFLOAT5             CHAR(17)
    '',
--   v_STRTEXT11         CHAR(50)
    '',
--   v_STRTEXT12         CHAR(50)
    '',
--   v_STRTEXT13         CHAR(50)
    '',
--   v_STRTEXT14         CHAR(50)
    '',
--   v_STRTEXT15         CHAR(50)
    '',
--   v_STRTEXT16         CHAR(50)
    '',
--   v_STRTEXT17         CHAR(50)
    '',
--   v_STRTEXT18         CHAR(50)
    '',
--   v_STRTEXT19         CHAR(50)
    '',
--   v_STRTEXT20         CHAR(50)
    '',
--   v_STRTEXT21         CHAR(50)
    '',
--   v_STRTEXT22         CHAR(50)
    '',
--   v_STRTEXT23         CHAR(50)
    '',
--   v_STRTEXT24         CHAR(50)
    '',
--   v_STRTEXT25         CHAR(50)
    '',
--   v_STRTEXT26         CHAR(50)
    '',
--   v_STRTEXT27         CHAR(50)
    '',
--   v_EmployerID         CHAR(50)
    '',
--   v_EmployeeID         CHAR(10)
    '',
--   v_STRTEXT1_CODE         CHAR(5)
    '',
--   v_STRTEXT2_CODE         CHAR(5)
    '',
--   v_strText28         CHAR(99)
    '',
--   v_BANK_ID             CHAR(99)
    get_param('BANK_ID'),
--   v_STRTEXT4_alt1         CHAR(99)
    ''
--from cust_currency a
--inner join map_cif on map_cif.fin_cif_id=a.fin_cif_id
from map_cif 
inner join currency on 1=1
left join gfpf on gfpf.gfcpnc=map_cif.gfcpnc
where INDIVIDUAL='Y' and del_flg<>'Y'; 
--and is_joint<>'Y'-------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--------------------Occupation code --------------------------------------------------
INSERT INTO CU3_O_TABLE
 SELECT  distinct
--   v_ORGKEY               CHAR(32)
    a.fin_cif_id,
    --products.seqid,    
--   v_CIF_ID              CHAR(32)
    a.fin_cif_id,
    --products.seqid,
--   v_STRTEXT1          CHAR(255)
    '',
--   v_STRTEXT2           CHAR(255)
    convert_codes('OCCUPATION_CODE',trim(GFSAC)),
--   v_TYPE              CHAR(50)
    'CURRENT_EMPLOYMENT',
--   v_CUSTOMERCURRENCY         CHAR(3)
	 '', 
--   v_CREDITDISCOUNTPERCENT     CHAR(9)
    '',    
--   v_DEBITDISCOUNTPERCENT       CHAR(9)
    '',
--   v_WITHHOLDTAXPCNT       CHAR(9)
    '',
--   v_WITHHOLDTAXFLOORLMT     CHAR(20)
    '',
--   v_DTDATE1             CHAR(17)
    '31-DEC-2099',
--   v_DTDATE2             CHAR(17)
    '',
--   v_countryofissue_code       CHAR(5)
    '',
--   v_SMALL_STR1           CHAR(50)
    '',
--   v_SMALL_STR2           CHAR(50)
    '',
--   v_SMALL_STR3         CHAR(50)
    '',
--   v_SMALL_STR4         CHAR(50)
    '',
--   v_SMALL_STR5         CHAR(50)
    '',
--   v_SMALL_STR6         CHAR(50)
    '',
--   v_SMALL_STR7         CHAR(50)
    '',
--   v_SMALL_STR8         CHAR(50)
    '',
--   v_SMALL_STR9         CHAR(50)
    '',
--   v_SMALL_STR10         CHAR(50)
    '',
--   v_MED_STR1             CHAR(100)
    '',
--   v_MED_STR2             CHAR(100)
    '',
--   v_MED_STR3             CHAR(100)
    '',
--   v_MED_STR4             CHAR(100)
    '',
--   v_MED_STR5             CHAR(100)
    '',
--   v_MED_STR6             CHAR(100)
    '',
--   v_MED_STR7             CHAR(100)
    '',
--   v_MED_STR8             CHAR(100)
    '',
--   v_MED_STR9             CHAR(100)
    '',
--   v_MED_STR10         CHAR(100)
    '',
--   v_LARGE_STR1         CHAR(250)
    '',
--   v_LARGE_STR2         CHAR(250)
    '',
--   v_LARGE_STR3         CHAR(250)
    '',
--   v_LARGE_STR4         CHAR(250)
    '',
--   v_LARGE_STR5         CHAR(250)
    '',
--   v_DATE1             CHAR(17)
    '',
--   v_DATE2             CHAR(17)
    '',
--   v_DATE3             CHAR(17)
    '',
--   v_DATE4             CHAR(17)
    '',
--   v_DATE5             CHAR(17)
    '',
--   v_DATE6             CHAR(17)
    '',
--   v_DATE7             CHAR(17)
    '',
--   v_DATE8             CHAR(17)
    '',
--   v_DATE9             CHAR(17)
    '',
--   v_DATE10             CHAR(17)
    '',
--   v_NUMBER1             CHAR(38)
    '',
--   v_NUMBER2             CHAR(38)
    '',
--   v_NUMBER3             CHAR(38)
    '',
--   v_NUMBER4             CHAR(38)
    '',
--   v_NUMBER5             CHAR(38)
    '',
--   v_NUMBER6             CHAR(38)
    '',
--   v_NUMBER7             CHAR(38)
    '',
--   v_NUMBER8             CHAR(38)
    '',
--   v_NUMBER9             CHAR(38)
    '',
--   v_NUMBER10             CHAR(38)
    '',
--   v_DECIMAL1             CHAR(25)
    '',
--   v_DECIMAL2             CHAR(25)
    '',
--   v_DECIMAL3             CHAR(25)
    '',
--   v_DECIMAL4             CHAR(25)
    '',
--   v_DECIMAL5             CHAR(25)
    '',
--   v_DECIMAL6             CHAR(25)
    '',
--   v_DECIMAL7             CHAR(25)
    '',
--   v_DECIMAL8             CHAR(25)
    '',
--   v_DECIMAL9             CHAR(25)
    '',
--   v_DECIMAL10         CHAR(25)
    '',
--   v_STRTEXT3             CHAR(255)
     '',
--   v_STRTEXT4             CHAR(255)
    RS04_EMPYR,
--   v_STRTEXT5             CHAR(255)
    '',
--   v_STRTEXT6             CHAR(255)
    '',
--   v_STRTEXT7             CHAR(255)
    '',
--   v_STRTEXT8             CHAR(255)
    '',
--   v_STRTEXT9             CHAR(255)
--    RS04_DSGNT,
	case when trim(RS04_DSGNT)='EXECUTIVE MANAGER' then 'EM'
	     when trim(RS04_DSGNT)='GENERAL MANAGER' then 'GM'
		 when trim(RS04_DSGNT)='SENIOR MANAGER' then 'SM'
		 WHEN trim(RS04_DSGNT)='MANAGER' THEN 'MANAGER'
--		 else to_char(trim(RS04_DSGNT)) end, --code changed based on the Error accoured in Mock4A on 6/6/2017
		 ELSE 'OTHER' END, --'OTHER' CODE DEFAULTED AS PER VIJAY CONFIRMATION ON 08-07-2017 IN MOCK5 OBSERVATION
--   v_STRTEXT10         CHAR(255)
	 '', 
--   v_INTINTEGER1         CHAR(38)
    '',
--   v_INTINTEGER2         CHAR(38)
    '',
--   v_INTINTEGER3         CHAR(38)
    '',
--   v_INTINTEGER4         CHAR(38)
    '',
--   v_INTINTEGER5         CHAR(38)
    '',
--   v_INTINTEGER6         CHAR(38)
    '',
--   v_INTINTEGER7         CHAR(38)
    '',
--   v_INTINTEGER8         CHAR(38)
    '',
--   v_INTINTEGER9         CHAR(38)
    '',
--   v_INTINTEGER10         CHAR(38)
    '',
--   v_INTINTEGER11         CHAR(38)
    '',
--   v_INTINTEGER12         CHAR(38)
    '',
--   v_INTINTEGER13         CHAR(38)
    '',
--   v_INTINTEGER14         CHAR(38)
    '',
--   v_INTINTEGER15         CHAR(38)
    '',
--   v_DTDATE3             CHAR(17)
    '',
--   v_DTDATE4             CHAR(17)
    '',
--   v_DTDATE5             CHAR(17)
    '',
--   v_DBFLOAT1             CHAR(17)
    '0',
--   v_DBFLOAT2             CHAR(17)
    '0',
--   v_DBFLOAT3             CHAR(17)
    '0',
--   v_DBFLOAT4             CHAR(17)
    '0',
--   v_DBFLOAT5             CHAR(17)
    '',
--   v_STRTEXT11         CHAR(50)
    '',
--   v_STRTEXT12         CHAR(50)
    '',
--   v_STRTEXT13         CHAR(50)
    '',
--   v_STRTEXT14         CHAR(50)
    '',
--   v_STRTEXT15         CHAR(50)
    '',
--   v_STRTEXT16         CHAR(50)
    '',
--   v_STRTEXT17         CHAR(50)
    '',
--   v_STRTEXT18         CHAR(50)
    '',
--   v_STRTEXT19         CHAR(50)
    '',
--   v_STRTEXT20         CHAR(50)
    '',
--   v_STRTEXT21         CHAR(50)
    '',
--   v_STRTEXT22         CHAR(50)
    '',
--   v_STRTEXT23         CHAR(50)
    '',
--   v_STRTEXT24         CHAR(50)
    '',
--   v_STRTEXT25         CHAR(50)
    '',
--   v_STRTEXT26         CHAR(50)
    '',
--   v_STRTEXT27         CHAR(50)
    '',
--   v_EmployerID         CHAR(50)
    scp5r, ----added on 27-09-2017 as per sandeep and anegha confirmation removed from cu8 and provided here
--   v_EmployeeID         CHAR(10)
    '',
--   v_STRTEXT1_CODE         CHAR(5)
    '',
--   v_STRTEXT2_CODE         CHAR(5)
    convert_codes('OCCUPATION_CODE',trim(GFSAC)),
--   v_strText28         CHAR(99)
    '',
--   v_BANK_ID             CHAR(99)
    get_param('BANK_ID'),
--   v_STRTEXT4_alt1         CHAR(99)
    ''
from map_cif a
inner join gfpf on gfpf.gfcpnc=a.gfcpnc
left join YRCS04PF on RS04_CLC=a.gfclc and  RS04_CUS=a.gfcus
left join (select distinct fin_cif_id,scp5r from map_acc
inner join scpf  on leg_branch_id||leg_Scan||leg_scas=scab||scan||scas
where trim(scp5r) is not null) scp5r on  scp5r.fin_cif_id=a.fin_cif_id
where a.INDIVIDUAL='Y' and a.del_flg<>'Y';
--commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
--and is_joint<>'Y'
commit;
---------------------------Qualification----------------------------------------------------
INSERT INTO CU3_O_TABLE
 SELECT  distinct
--   v_ORGKEY               CHAR(32)
    a.fin_cif_id,
    --products.seqid,    
--   v_CIF_ID              CHAR(32)
    a.fin_cif_id,
    --products.seqid,
--   v_STRTEXT1          CHAR(255)
    '',
--   v_STRTEXT2           CHAR(255)
    '',
--   v_TYPE              CHAR(50)
    'EDU_DET',
--   v_CUSTOMERCURRENCY         CHAR(3)
	 '', 
--   v_CREDITDISCOUNTPERCENT     CHAR(9)
    '',    
--   v_DEBITDISCOUNTPERCENT       CHAR(9)
    '',
--   v_WITHHOLDTAXPCNT       CHAR(9)
    '',
--   v_WITHHOLDTAXFLOORLMT     CHAR(20)
    '',
--   v_DTDATE1             CHAR(17)
    '31-DEC-2099',
--   v_DTDATE2             CHAR(17)
    '',
--   v_countryofissue_code       CHAR(5)
    '',
--   v_SMALL_STR1           CHAR(50)
    '',
--   v_SMALL_STR2           CHAR(50)
    '',
--   v_SMALL_STR3         CHAR(50)
    '',
--   v_SMALL_STR4         CHAR(50)
    '',
--   v_SMALL_STR5         CHAR(50)
    '',
--   v_SMALL_STR6         CHAR(50)
    '',
--   v_SMALL_STR7         CHAR(50)
    '',
--   v_SMALL_STR8         CHAR(50)
    '',
--   v_SMALL_STR9         CHAR(50)
    '',
--   v_SMALL_STR10         CHAR(50)
    '',
--   v_MED_STR1             CHAR(100)
    '',
--   v_MED_STR2             CHAR(100)
    '',
--   v_MED_STR3             CHAR(100)
    '',
--   v_MED_STR4             CHAR(100)
    '',
--   v_MED_STR5             CHAR(100)
    '',
--   v_MED_STR6             CHAR(100)
    '',
--   v_MED_STR7             CHAR(100)
    '',
--   v_MED_STR8             CHAR(100)
    '',
--   v_MED_STR9             CHAR(100)
    '',
--   v_MED_STR10         CHAR(100)
    '',
--   v_LARGE_STR1         CHAR(250)
    '',
--   v_LARGE_STR2         CHAR(250)
    '',
--   v_LARGE_STR3         CHAR(250)
    '',
--   v_LARGE_STR4         CHAR(250)
    '',
--   v_LARGE_STR5         CHAR(250)
    '',
--   v_DATE1             CHAR(17)
    '',
--   v_DATE2             CHAR(17)
    '',
--   v_DATE3             CHAR(17)
    '',
--   v_DATE4             CHAR(17)
    '',
--   v_DATE5             CHAR(17)
    '',
--   v_DATE6             CHAR(17)
    '',
--   v_DATE7             CHAR(17)
    '',
--   v_DATE8             CHAR(17)
    '',
--   v_DATE9             CHAR(17)
    '',
--   v_DATE10             CHAR(17)
    '',
--   v_NUMBER1             CHAR(38)
    '',
--   v_NUMBER2             CHAR(38)
    '',
--   v_NUMBER3             CHAR(38)
    '',
--   v_NUMBER4             CHAR(38)
    '',
--   v_NUMBER5             CHAR(38)
    '',
--   v_NUMBER6             CHAR(38)
    '',
--   v_NUMBER7             CHAR(38)
    '',
--   v_NUMBER8             CHAR(38)
    '',
--   v_NUMBER9             CHAR(38)
    '',
--   v_NUMBER10             CHAR(38)
    '',
--   v_DECIMAL1             CHAR(25)
    '',
--   v_DECIMAL2             CHAR(25)
    '',
--   v_DECIMAL3             CHAR(25)
    '',
--   v_DECIMAL4             CHAR(25)
    '',
--   v_DECIMAL5             CHAR(25)
    '',
--   v_DECIMAL6             CHAR(25)
    '',
--   v_DECIMAL7             CHAR(25)
    '',
--   v_DECIMAL8             CHAR(25)
    '',
--   v_DECIMAL9             CHAR(25)
    '',
--   v_DECIMAL10         CHAR(25)
    '',
--   v_STRTEXT3             CHAR(255)
     '',
--   v_STRTEXT4             CHAR(255)
    'ZZZ', --defaulted based on the Infosys request and confirmation from bank to defualt on 25-Mar-2017
--   v_STRTEXT5             CHAR(255)
    '',
--   v_STRTEXT6             CHAR(255)
    '',
--   v_STRTEXT7             CHAR(255)
    '',
--   v_STRTEXT8             CHAR(255)
    '',
--   v_STRTEXT9             CHAR(255)
    '',
--   v_STRTEXT10         CHAR(255)
	 convert_codes('QUALIFICATION',regexp_replace(BGEDUC,'[`,.,\,\, ]','')),
--   v_INTINTEGER1         CHAR(38)
    '',
--   v_INTINTEGER2         CHAR(38)
    '',
--   v_INTINTEGER3         CHAR(38)
    '',
--   v_INTINTEGER4         CHAR(38)
    '',
--   v_INTINTEGER5         CHAR(38)
    '',
--   v_INTINTEGER6         CHAR(38)
    '',
--   v_INTINTEGER7         CHAR(38)
    '',
--   v_INTINTEGER8         CHAR(38)
    '',
--   v_INTINTEGER9         CHAR(38)
    '',
--   v_INTINTEGER10         CHAR(38)
    '',
--   v_INTINTEGER11         CHAR(38)
    '',
--   v_INTINTEGER12         CHAR(38)
    '',
--   v_INTINTEGER13         CHAR(38)
    '',
--   v_INTINTEGER14         CHAR(38)
    '',
--   v_INTINTEGER15         CHAR(38)
    '',
--   v_DTDATE3             CHAR(17)
    '',
--   v_DTDATE4             CHAR(17)
    --'ZZZ',--- as per mail confirmation from edwin there is no graduation day details from legacy data. Defaulted to 'ZZZ'
	'',   -- There is no data in legacy and  also no mandatory field. Hence values not populated . as per discussion vith niraj Script modified on 30-04-2017.
--   v_DTDATE5             CHAR(17)
    '',
--   v_DBFLOAT1             CHAR(17)
    '0',
--   v_DBFLOAT2             CHAR(17)
    '0',
--   v_DBFLOAT3             CHAR(17)
    '0',
--   v_DBFLOAT4             CHAR(17)
    '0',
--   v_DBFLOAT5             CHAR(17)
    '',
--   v_STRTEXT11         CHAR(50)
    '',
--   v_STRTEXT12         CHAR(50)
    '',
--   v_STRTEXT13         CHAR(50)
    '',
--   v_STRTEXT14         CHAR(50)
    '',
--   v_STRTEXT15         CHAR(50)
    '',
--   v_STRTEXT16         CHAR(50)
    '',
--   v_STRTEXT17         CHAR(50)
    '',
--   v_STRTEXT18         CHAR(50)
    '',
--   v_STRTEXT19         CHAR(50)
    '',
--   v_STRTEXT20         CHAR(50)
    '',
--   v_STRTEXT21         CHAR(50)
    '',
--   v_STRTEXT22         CHAR(50)
    '',
--   v_STRTEXT23         CHAR(50)
    '',
--   v_STRTEXT24         CHAR(50)
    '',
--   v_STRTEXT25         CHAR(50)
    '',
--   v_STRTEXT26         CHAR(50)
    '',
--   v_STRTEXT27         CHAR(50)
    '',
--   v_EmployerID         CHAR(50)
    '',
--   v_EmployeeID         CHAR(10)
    '',
--   v_STRTEXT1_CODE         CHAR(5)
    '',
--   v_STRTEXT2_CODE         CHAR(5)
    '',
--   v_strText28         CHAR(99)
    '',
--   v_BANK_ID             CHAR(99)
    get_param('BANK_ID'),
--   v_STRTEXT4_alt1         CHAR(99)
    ''
from map_cif a
inner join gfpf on gfpf.gfcpnc=a.gfcpnc
inner join  bgpf  on nvl(gfpf.GFCLC,'')=nvl(bgpf.BGCLC,'') and gfpf.GFCUS=bgpf.BGCUS 
where a.INDIVIDUAL='Y' and a.del_flg<>'Y' and regexp_replace(BGEDUC,'[`,.,\,\, ]','') is not null; 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
------------------POA/Guarantor customer----------------------------------
INSERT INTO CU3_O_TABLE
 SELECT  distinct
--   v_ORGKEY               CHAR(32)
    fin_cif_id,
    --products.seqid,    
--   v_CIF_ID              CHAR(32)
    fin_cif_id,
    --products.seqid,
--   v_STRTEXT1          CHAR(255)
    '',
--   v_STRTEXT2           CHAR(255)
    '',
--   v_TYPE              CHAR(50)
    'CURRENCY',
--   v_CUSTOMERCURRENCY         CHAR(3)
	 'KWD', 
--   v_CREDITDISCOUNTPERCENT     CHAR(9)
    '',    
--   v_DEBITDISCOUNTPERCENT       CHAR(9)
    '',
--   v_WITHHOLDTAXPCNT       CHAR(9)
    '',
--   v_WITHHOLDTAXFLOORLMT     CHAR(20)
    '',
--   v_DTDATE1             CHAR(17)
    '31-DEC-2099',
--   v_DTDATE2             CHAR(17)
    '',
--   v_countryofissue_code       CHAR(5)
    '',
--   v_SMALL_STR1           CHAR(50)
    '',
--   v_SMALL_STR2           CHAR(50)
    '',
--   v_SMALL_STR3         CHAR(50)
    '',
--   v_SMALL_STR4         CHAR(50)
    '',
--   v_SMALL_STR5         CHAR(50)
    '',
--   v_SMALL_STR6         CHAR(50)
    '',
--   v_SMALL_STR7         CHAR(50)
    '',
--   v_SMALL_STR8         CHAR(50)
    '',
--   v_SMALL_STR9         CHAR(50)
    '',
--   v_SMALL_STR10         CHAR(50)
    '',
--   v_MED_STR1             CHAR(100)
    '',
--   v_MED_STR2             CHAR(100)
    '',
--   v_MED_STR3             CHAR(100)
    '',
--   v_MED_STR4             CHAR(100)
    '',
--   v_MED_STR5             CHAR(100)
    '',
--   v_MED_STR6             CHAR(100)
    '',
--   v_MED_STR7             CHAR(100)
    '',
--   v_MED_STR8             CHAR(100)
    '',
--   v_MED_STR9             CHAR(100)
    '',
--   v_MED_STR10         CHAR(100)
    '',
--   v_LARGE_STR1         CHAR(250)
    '',
--   v_LARGE_STR2         CHAR(250)
    '',
--   v_LARGE_STR3         CHAR(250)
    '',
--   v_LARGE_STR4         CHAR(250)
    '',
--   v_LARGE_STR5         CHAR(250)
    '',
--   v_DATE1             CHAR(17)
    '',
--   v_DATE2             CHAR(17)
    '',
--   v_DATE3             CHAR(17)
    '',
--   v_DATE4             CHAR(17)
    '',
--   v_DATE5             CHAR(17)
    '',
--   v_DATE6             CHAR(17)
    '',
--   v_DATE7             CHAR(17)
    '',
--   v_DATE8             CHAR(17)
    '',
--   v_DATE9             CHAR(17)
    '',
--   v_DATE10             CHAR(17)
    '',
--   v_NUMBER1             CHAR(38)
    '',
--   v_NUMBER2             CHAR(38)
    '',
--   v_NUMBER3             CHAR(38)
    '',
--   v_NUMBER4             CHAR(38)
    '',
--   v_NUMBER5             CHAR(38)
    '',
--   v_NUMBER6             CHAR(38)
    '',
--   v_NUMBER7             CHAR(38)
    '',
--   v_NUMBER8             CHAR(38)
    '',
--   v_NUMBER9             CHAR(38)
    '',
--   v_NUMBER10             CHAR(38)
    '',
--   v_DECIMAL1             CHAR(25)
    '',
--   v_DECIMAL2             CHAR(25)
    '',
--   v_DECIMAL3             CHAR(25)
    '',
--   v_DECIMAL4             CHAR(25)
    '',
--   v_DECIMAL5             CHAR(25)
    '',
--   v_DECIMAL6             CHAR(25)
    '',
--   v_DECIMAL7             CHAR(25)
    '',
--   v_DECIMAL8             CHAR(25)
    '',
--   v_DECIMAL9             CHAR(25)
    '',
--   v_DECIMAL10         CHAR(25)
    '',
--   v_STRTEXT3             CHAR(255)
     '',
--   v_STRTEXT4             CHAR(255)
    '',
--   v_STRTEXT5             CHAR(255)
    '',
--   v_STRTEXT6             CHAR(255)
    '',
--   v_STRTEXT7             CHAR(255)
    '',
--   v_STRTEXT8             CHAR(255)
    '',
--   v_STRTEXT9             CHAR(255)
    '',
--   v_STRTEXT10         CHAR(255)
    --convert_codes('CCY',CURRENCY),
	 'KWD', 
--   v_INTINTEGER1         CHAR(38)
    '',
--   v_INTINTEGER2         CHAR(38)
    '',
--   v_INTINTEGER3         CHAR(38)
    '',
--   v_INTINTEGER4         CHAR(38)
    '',
--   v_INTINTEGER5         CHAR(38)
    '',
--   v_INTINTEGER6         CHAR(38)
    '',
--   v_INTINTEGER7         CHAR(38)
    '',
--   v_INTINTEGER8         CHAR(38)
    '',
--   v_INTINTEGER9         CHAR(38)
    '',
--   v_INTINTEGER10         CHAR(38)
    '',
--   v_INTINTEGER11         CHAR(38)
    '',
--   v_INTINTEGER12         CHAR(38)
    '',
--   v_INTINTEGER13         CHAR(38)
    '',
--   v_INTINTEGER14         CHAR(38)
    '',
--   v_INTINTEGER15         CHAR(38)
    '',
--   v_DTDATE3             CHAR(17)
    '',
--   v_DTDATE4             CHAR(17)
    '',
--   v_DTDATE5             CHAR(17)
    '',
--   v_DBFLOAT1             CHAR(17)
    '0',
--   v_DBFLOAT2             CHAR(17)
    '0',
--   v_DBFLOAT3             CHAR(17)
    '0',
--   v_DBFLOAT4             CHAR(17)
    '0',
--   v_DBFLOAT5             CHAR(17)
    '',
--   v_STRTEXT11         CHAR(50)
    '',
--   v_STRTEXT12         CHAR(50)
    '',
--   v_STRTEXT13         CHAR(50)
    '',
--   v_STRTEXT14         CHAR(50)
    '',
--   v_STRTEXT15         CHAR(50)
    '',
--   v_STRTEXT16         CHAR(50)
    '',
--   v_STRTEXT17         CHAR(50)
    '',
--   v_STRTEXT18         CHAR(50)
    '',
--   v_STRTEXT19         CHAR(50)
    '',
--   v_STRTEXT20         CHAR(50)
    '',
--   v_STRTEXT21         CHAR(50)
    '',
--   v_STRTEXT22         CHAR(50)
    '',
--   v_STRTEXT23         CHAR(50)
    '',
--   v_STRTEXT24         CHAR(50)
    '',
--   v_STRTEXT25         CHAR(50)
    '',
--   v_STRTEXT26         CHAR(50)
    '',
--   v_STRTEXT27         CHAR(50)
    '',
--   v_EmployerID         CHAR(50)
    '',
--   v_EmployeeID         CHAR(10)
    '',
--   v_STRTEXT1_CODE         CHAR(5)
    '',
--   v_STRTEXT2_CODE         CHAR(5)
    '',
--   v_strText28         CHAR(99)
    '',
--   v_BANK_ID             CHAR(99)
    get_param('BANK_ID'),
--   v_STRTEXT4_alt1         CHAR(99)
    ''
FROM MAP_CIF_JOINT JNT;
commit; 
----------------------------------Default current employment records for map_cif_joint----------------------------------------------------------
INSERT INTO CU3_O_TABLE
 SELECT  distinct
--   v_ORGKEY               CHAR(32)
    a.fin_cif_id,
    --products.seqid,    
--   v_CIF_ID              CHAR(32)
    a.fin_cif_id,
    --products.seqid,
--   v_STRTEXT1          CHAR(255)
    '',
--   v_STRTEXT2           CHAR(255)
    '020',
--   v_TYPE              CHAR(50)
    'CURRENT_EMPLOYMENT',
--   v_CUSTOMERCURRENCY         CHAR(3)
	 '', 
--   v_CREDITDISCOUNTPERCENT     CHAR(9)
    '',    
--   v_DEBITDISCOUNTPERCENT       CHAR(9)
    '',
--   v_WITHHOLDTAXPCNT       CHAR(9)
    '',
--   v_WITHHOLDTAXFLOORLMT     CHAR(20)
    '',
--   v_DTDATE1             CHAR(17)
    '31-DEC-2099',
--   v_DTDATE2             CHAR(17)
    '',
--   v_countryofissue_code       CHAR(5)
    '',
--   v_SMALL_STR1           CHAR(50)
    '',
--   v_SMALL_STR2           CHAR(50)
    '',
--   v_SMALL_STR3         CHAR(50)
    '',
--   v_SMALL_STR4         CHAR(50)
    '',
--   v_SMALL_STR5         CHAR(50)
    '',
--   v_SMALL_STR6         CHAR(50)
    '',
--   v_SMALL_STR7         CHAR(50)
    '',
--   v_SMALL_STR8         CHAR(50)
    '',
--   v_SMALL_STR9         CHAR(50)
    '',
--   v_SMALL_STR10         CHAR(50)
    '',
--   v_MED_STR1             CHAR(100)
    '',
--   v_MED_STR2             CHAR(100)
    '',
--   v_MED_STR3             CHAR(100)
    '',
--   v_MED_STR4             CHAR(100)
    '',
--   v_MED_STR5             CHAR(100)
    '',
--   v_MED_STR6             CHAR(100)
    '',
--   v_MED_STR7             CHAR(100)
    '',
--   v_MED_STR8             CHAR(100)
    '',
--   v_MED_STR9             CHAR(100)
    '',
--   v_MED_STR10         CHAR(100)
    '',
--   v_LARGE_STR1         CHAR(250)
    '',
--   v_LARGE_STR2         CHAR(250)
    '',
--   v_LARGE_STR3         CHAR(250)
    '',
--   v_LARGE_STR4         CHAR(250)
    '',
--   v_LARGE_STR5         CHAR(250)
    '',
--   v_DATE1             CHAR(17)
    '',
--   v_DATE2             CHAR(17)
    '',
--   v_DATE3             CHAR(17)
    '',
--   v_DATE4             CHAR(17)
    '',
--   v_DATE5             CHAR(17)
    '',
--   v_DATE6             CHAR(17)
    '',
--   v_DATE7             CHAR(17)
    '',
--   v_DATE8             CHAR(17)
    '',
--   v_DATE9             CHAR(17)
    '',
--   v_DATE10             CHAR(17)
    '',
--   v_NUMBER1             CHAR(38)
    '',
--   v_NUMBER2             CHAR(38)
    '',
--   v_NUMBER3             CHAR(38)
    '',
--   v_NUMBER4             CHAR(38)
    '',
--   v_NUMBER5             CHAR(38)
    '',
--   v_NUMBER6             CHAR(38)
    '',
--   v_NUMBER7             CHAR(38)
    '',
--   v_NUMBER8             CHAR(38)
    '',
--   v_NUMBER9             CHAR(38)
    '',
--   v_NUMBER10             CHAR(38)
    '',
--   v_DECIMAL1             CHAR(25)
    '',
--   v_DECIMAL2             CHAR(25)
    '',
--   v_DECIMAL3             CHAR(25)
    '',
--   v_DECIMAL4             CHAR(25)
    '',
--   v_DECIMAL5             CHAR(25)
    '',
--   v_DECIMAL6             CHAR(25)
    '',
--   v_DECIMAL7             CHAR(25)
    '',
--   v_DECIMAL8             CHAR(25)
    '',
--   v_DECIMAL9             CHAR(25)
    '',
--   v_DECIMAL10         CHAR(25)
    '',
--   v_STRTEXT3             CHAR(255)
     '',
--   v_STRTEXT4             CHAR(255)
    '',
--   v_STRTEXT5             CHAR(255)
    '',
--   v_STRTEXT6             CHAR(255)
    '',
--   v_STRTEXT7             CHAR(255)
    '',
--   v_STRTEXT8             CHAR(255)
    '',
--   v_STRTEXT9             CHAR(255)
		  'OTHER', 
--   v_STRTEXT10         CHAR(255)
	 '', 
--   v_INTINTEGER1         CHAR(38)
    '',
--   v_INTINTEGER2         CHAR(38)
    '',
--   v_INTINTEGER3         CHAR(38)
    '',
--   v_INTINTEGER4         CHAR(38)
    '',
--   v_INTINTEGER5         CHAR(38)
    '',
--   v_INTINTEGER6         CHAR(38)
    '',
--   v_INTINTEGER7         CHAR(38)
    '',
--   v_INTINTEGER8         CHAR(38)
    '',
--   v_INTINTEGER9         CHAR(38)
    '',
--   v_INTINTEGER10         CHAR(38)
    '',
--   v_INTINTEGER11         CHAR(38)
    '',
--   v_INTINTEGER12         CHAR(38)
    '',
--   v_INTINTEGER13         CHAR(38)
    '',
--   v_INTINTEGER14         CHAR(38)
    '',
--   v_INTINTEGER15         CHAR(38)
    '',
--   v_DTDATE3             CHAR(17)
    '',
--   v_DTDATE4             CHAR(17)
    '',
--   v_DTDATE5             CHAR(17)
    '',
--   v_DBFLOAT1             CHAR(17)
    '0',
--   v_DBFLOAT2             CHAR(17)
    '0',
--   v_DBFLOAT3             CHAR(17)
    '0',
--   v_DBFLOAT4             CHAR(17)
    '0',
--   v_DBFLOAT5             CHAR(17)
    '',
--   v_STRTEXT11         CHAR(50)
    '',
--   v_STRTEXT12         CHAR(50)
    '',
--   v_STRTEXT13         CHAR(50)
    '',
--   v_STRTEXT14         CHAR(50)
    '',
--   v_STRTEXT15         CHAR(50)
    '',
--   v_STRTEXT16         CHAR(50)
    '',
--   v_STRTEXT17         CHAR(50)
    '',
--   v_STRTEXT18         CHAR(50)
    '',
--   v_STRTEXT19         CHAR(50)
    '',
--   v_STRTEXT20         CHAR(50)
    '',
--   v_STRTEXT21         CHAR(50)
    '',
--   v_STRTEXT22         CHAR(50)
    '',
--   v_STRTEXT23         CHAR(50)
    '',
--   v_STRTEXT24         CHAR(50)
    '',
--   v_STRTEXT25         CHAR(50)
    '',
--   v_STRTEXT26         CHAR(50)
    '',
--   v_STRTEXT27         CHAR(50)
    '',
--   v_EmployerID         CHAR(50)
    '',
--   v_EmployeeID         CHAR(10)
    '',
--   v_STRTEXT1_CODE         CHAR(5)
    '',
--   v_STRTEXT2_CODE         CHAR(5)
    'MIGR',
--   v_strText28         CHAR(99)
    '',
--   v_BANK_ID             CHAR(99)
    get_param('BANK_ID'),
--   v_STRTEXT4_alt1         CHAR(99)
    ''
from map_cif_joint a;
commit;
--delete from CU3_O_TABLE where  CUSTOMERCURRENCY in('ATS','BEF','DEM','ESP','FRF','ITL','NLG','DKK','HKD','MYR','NOK','LBP','MAD','PHP','SEK'); 
--commit;
--INSERT INTO CU3_O_TABLE
-- SELECT  distinct
----   v_ORGKEY               CHAR(32)
--    a.orgkey,
--    --products.seqid,    
----   v_CIF_ID              CHAR(32)
--    a.orgkey,
--    --products.seqid,
----   v_STRTEXT1          CHAR(255)
--    '',
----   v_STRTEXT2           CHAR(255)
--    '',
----   v_TYPE              CHAR(50)
--    'CURRENCY',
----   v_CUSTOMERCURRENCY         CHAR(3)
--    --convert_codes('CCY',CURRENCY),
--	 'KWD', 
----   v_CREDITDISCOUNTPERCENT     CHAR(9)
--    '',    
----   v_DEBITDISCOUNTPERCENT       CHAR(9)
--    '',
----   v_WITHHOLDTAXPCNT       CHAR(9)
--    '',
----   v_WITHHOLDTAXFLOORLMT     CHAR(20)
--    '',
----   v_DTDATE1             CHAR(17)
--    '31-DEC-2099',
----   v_DTDATE2             CHAR(17)
--    '',
----   v_countryofissue_code       CHAR(5)
--    '',
----   v_SMALL_STR1           CHAR(50)
--    '',
----   v_SMALL_STR2           CHAR(50)
--    '',
----   v_SMALL_STR3         CHAR(50)
--    '',
----   v_SMALL_STR4         CHAR(50)
--    '',
----   v_SMALL_STR5         CHAR(50)
--    '',
----   v_SMALL_STR6         CHAR(50)
--    '',
----   v_SMALL_STR7         CHAR(50)
--    '',
----   v_SMALL_STR8         CHAR(50)
--    '',
----   v_SMALL_STR9         CHAR(50)
--    '',
----   v_SMALL_STR10         CHAR(50)
--    '',
----   v_MED_STR1             CHAR(100)
--    '',
----   v_MED_STR2             CHAR(100)
--    '',
----   v_MED_STR3             CHAR(100)
--    '',
----   v_MED_STR4             CHAR(100)
--    '',
----   v_MED_STR5             CHAR(100)
--    '',
----   v_MED_STR6             CHAR(100)
--    '',
----   v_MED_STR7             CHAR(100)
--    '',
----   v_MED_STR8             CHAR(100)
--    '',
----   v_MED_STR9             CHAR(100)
--    '',
----   v_MED_STR10         CHAR(100)
--    '',
----   v_LARGE_STR1         CHAR(250)
--    '',
----   v_LARGE_STR2         CHAR(250)
--    '',
----   v_LARGE_STR3         CHAR(250)
--    '',
----   v_LARGE_STR4         CHAR(250)
--    '',
----   v_LARGE_STR5         CHAR(250)
--    '',
----   v_DATE1             CHAR(17)
--    '',
----   v_DATE2             CHAR(17)
--    '',
----   v_DATE3             CHAR(17)
--    '',
----   v_DATE4             CHAR(17)
--    '',
----   v_DATE5             CHAR(17)
--    '',
----   v_DATE6             CHAR(17)
--    '',
----   v_DATE7             CHAR(17)
--    '',
----   v_DATE8             CHAR(17)
--    '',
----   v_DATE9             CHAR(17)
--    '',
----   v_DATE10             CHAR(17)
--    '',
----   v_NUMBER1             CHAR(38)
--    '',
----   v_NUMBER2             CHAR(38)
--    '',
----   v_NUMBER3             CHAR(38)
--    '',
----   v_NUMBER4             CHAR(38)
--    '',
----   v_NUMBER5             CHAR(38)
--    '',
----   v_NUMBER6             CHAR(38)
--    '',
----   v_NUMBER7             CHAR(38)
--    '',
----   v_NUMBER8             CHAR(38)
--    '',
----   v_NUMBER9             CHAR(38)
--    '',
----   v_NUMBER10             CHAR(38)
--    '',
----   v_DECIMAL1             CHAR(25)
--    '',
----   v_DECIMAL2             CHAR(25)
--    '',
----   v_DECIMAL3             CHAR(25)
--    '',
----   v_DECIMAL4             CHAR(25)
--    '',
----   v_DECIMAL5             CHAR(25)
--    '',
----   v_DECIMAL6             CHAR(25)
--    '',
----   v_DECIMAL7             CHAR(25)
--    '',
----   v_DECIMAL8             CHAR(25)
--    '',
----   v_DECIMAL9             CHAR(25)
--    '',
----   v_DECIMAL10         CHAR(25)
--    '',
----   v_STRTEXT3             CHAR(255)
--     '',
----   v_STRTEXT4             CHAR(255)
--    '',
----   v_STRTEXT5             CHAR(255)
--    '',
----   v_STRTEXT6             CHAR(255)
--    '',
----   v_STRTEXT7             CHAR(255)
--    '',
----   v_STRTEXT8             CHAR(255)
--    '',
----   v_STRTEXT9             CHAR(255)
--    '',
----   v_STRTEXT10         CHAR(255)
--    --convert_codes('CCY',CURRENCY),
--	 'KWD', 
----   v_INTINTEGER1         CHAR(38)
--    '',
----   v_INTINTEGER2         CHAR(38)
--    '',
----   v_INTINTEGER3         CHAR(38)
--    '',
----   v_INTINTEGER4         CHAR(38)
--    '',
----   v_INTINTEGER5         CHAR(38)
--    '',
----   v_INTINTEGER6         CHAR(38)
--    '',
----   v_INTINTEGER7         CHAR(38)
--    '',
----   v_INTINTEGER8         CHAR(38)
--    '',
----   v_INTINTEGER9         CHAR(38)
--    '',
----   v_INTINTEGER10         CHAR(38)
--    '',
----   v_INTINTEGER11         CHAR(38)
--    '',
----   v_INTINTEGER12         CHAR(38)
--    '',
----   v_INTINTEGER13         CHAR(38)
--    '',
----   v_INTINTEGER14         CHAR(38)
--    '',
----   v_INTINTEGER15         CHAR(38)
--    '',
----   v_DTDATE3             CHAR(17)
--    '',
----   v_DTDATE4             CHAR(17)
--    '',
----   v_DTDATE5             CHAR(17)
--    '',
----   v_DBFLOAT1             CHAR(17)
--    '0',
----   v_DBFLOAT2             CHAR(17)
--    '0',
----   v_DBFLOAT3             CHAR(17)
--    '0',
----   v_DBFLOAT4             CHAR(17)
--    '0',
----   v_DBFLOAT5             CHAR(17)
--    '',
----   v_STRTEXT11         CHAR(50)
--    '',
----   v_STRTEXT12         CHAR(50)
--    '',
----   v_STRTEXT13         CHAR(50)
--    '',
----   v_STRTEXT14         CHAR(50)
--    '',
----   v_STRTEXT15         CHAR(50)
--    '',
----   v_STRTEXT16         CHAR(50)
--    '',
----   v_STRTEXT17         CHAR(50)
--    '',
----   v_STRTEXT18         CHAR(50)
--    '',
----   v_STRTEXT19         CHAR(50)
--    '',
----   v_STRTEXT20         CHAR(50)
--    '',
----   v_STRTEXT21         CHAR(50)
--    '',
----   v_STRTEXT22         CHAR(50)
--    '',
----   v_STRTEXT23         CHAR(50)
--    '',
----   v_STRTEXT24         CHAR(50)
--    '',
----   v_STRTEXT25         CHAR(50)
--    '',
----   v_STRTEXT26         CHAR(50)
--    '',
----   v_STRTEXT27         CHAR(50)
--    '',
----   v_EmployerID         CHAR(50)
--    '',
----   v_EmployeeID         CHAR(10)
--    '',
----   v_STRTEXT1_CODE         CHAR(5)
--    '',
----   v_STRTEXT2_CODE         CHAR(5)
--    '',
----   v_strText28         CHAR(99)
--    '',
----   v_BANK_ID             CHAR(99)
--    get_param('BANK_ID'),
----   v_STRTEXT4_alt1         CHAR(99)
--    ''
--from CU1_O_TABLE a where not exists(select  distinct orgkey from CU3_O_TABLE b where a.orgkey=b.orgkey and type='CURRENCY' ) ;
--commit;
---------------------------------------------- added LBP,MAD,PHP & SEK based on discussion with Vijay--
exit; 