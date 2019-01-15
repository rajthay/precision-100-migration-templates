-- File Name		: cu9_upload.sql
-- File Created for	: Upload file for cu9
-- Created By		: Kumaresan.B
-- Client		    : EmiratesNBD Bank
-- Created On		: 22-07-2015
-------------------------------------------------------------------
truncate table CU9_O_TABLE;
INSERT INTO CU9_O_TABLE 
SELECT  distinct
--     V_ORGKEY		CHAR(50)
MAP_CIF.FIN_CIF_ID,
--     V_COMMUNICATION_LANGUAGE	CHAR(50)
	'INFENG',
--     V_PREFERRED_ADDRESS_MODE	CHAR(50)
'',
--     V_BEHAVIOURAL_SCORE  CHAR(100)
'',
--     V_RISK_BEHAVIOUR	CHAR(100)
'',
--     V_OTHER_BEHAVIOURAL_PROFILE	CHAR(100)
'',
--     V_LIFE_CYCLE_STAGE 	CHAR(100)
'',
--     V_SERVICE_PERSONALISE	CHAR(200)
'',
--     V_PSYCHOGRAPHICTYPE	CHAR(50)
'',
--     V_PRIORITY_IDENTIFIER	CHAR(25)
'', 
--     V_HOUSEHOLD_NUMBER	CHAR(10)
'',
--     V_PREFERRED_REP		CHAR(38)
'',
--     V_SEGMENTATION_CLASS	CHAR(100)
'',
--     V_PREFERREDNAME		CHAR(50)
nvl(gfpf_kw.GFCUN,'ZZZ'),
--     V_NUMBEROFDEPENDANTS	CHAR(38)
'',
--     V_NUMBEROFDEPENDANTCHILDREN	CHAR(38)
'',
--     V_STMTDATEFORCOMBSTMT	CHAR(10)
'',
--     V_SUBSEGMENT	CHAR(50)
'',
--     V_HOBBYFIELD1	CHAR(50)
'',
--     V_HOBBYFIELD2	CHAR(50)
'',
--     V_HOBBYFIELD3	CHAR(50)
'',
--     V_HOBBYFIELD4	CHAR(50)
'',
--     V_HOBBYFIELD5	CHAR(50)
'',
--     V_HOBBYFIELD6	CHAR(50)
'',
--     V_PROFILE_FIELD1	CHAR(200)
'',
--     V_PROFILE_FIELD2	CHAR(200)
'',
--     V_PROFILE_FIELD3	CHAR(200)
'',
--     V_PROFILE_FIELD4	CHAR(200)
'',
--     V_ALERT1	CHAR(100)
'',
--     V_ALERT2	CHAR(100)
'',
--     V_ALERT3	CHAR(100)
'',
--     V_ALERT4	CHAR(100)
'',
--     V_ALERT5	CHAR(100)
'',
--     V_FLAG1	CHAR(5)
'',
--     V_FLAG2	CHAR(5)
'',
--     V_FLAG3	CHAR(5)
'',
--     V_FLAG4	CHAR(5)
'',
--     V_FLAG5	CHAR(5)
'',
--     V_BANK_DEFINED_PREFER_VAR1	CHAR(20)
'',
--     V_BANK_DEFINED_PREFER_VAR2	CHAR(20)
'',
--     V_BANK_DEFINED_PREFER_VAR3	CHAR(20)
'',
--     V_BANK_DEFINED_PREFER_DATE1	CHAR(10)
'',
--     V_BANK_DEFINED_PREFER_DATE2	CHAR(10)
'',
--     V_BANK_DEFINED_PREFER_DATE3	CHAR(10)
'',
--     V_USERFIELD1	CHAR(50)
'',
--     V_USERFIELD2	CHAR(50)
'',
--     V_USERFIELD3	CHAR(50)
'',
--     V_USERFIELD4	CHAR(50)
'',
--     V_USERFIELD5	CHAR(50)
'',
--     V_USERFIELD6	CHAR(50)
'',
--     V_SPSERVICEREQUIRED1	CHAR(25)
'',
--     V_SPSERVICEREQUIRED2	CHAR(25)
'',
--     V_SPSERVICEREQUIRED3	CHAR(25)
'',
--     V_SPSERVICEREQUIRED4	CHAR(25)
'',
--     V_SPSERVICEREQUIRED5	CHAR(25)
'',
--     V_USERFLAG1	CHAR(1)
'',
--     V_USERFLAG2	CHAR(1)
'',
--     V_PREFRELSHIPDISCOUNT1	CHAR(20)
'',
--     V_PREFRELSHIPDISCOUNT2	CHAR(20)
'',
--     V_PREFRELSHIPDISCOUNTPERCENT1	CHAR(9)
'',
--     V_PREFRELSHIPDISCOUNTPERCENT2	CHAR(9)
'',
--     V_USERFIELD7	CHAR(50)
'',
--     V_USERFIELD8	CHAR(50)
'',
--     V_USERFIELD9	CHAR(50)
'',
--     V_USERFIELD10	CHAR(50)
'',
--     V_USERFIELD11	CHAR(50)
'',
--     V_USERFIELD12	CHAR(50)
'',
--     V_USERFIELD13	CHAR(50)
'',
--     V_AMOUNT1	CHAR(20)
to_number(KYCADA)/1000, --Below amounts divided by 1000 by Jagadeesh based on Email confirmation from Vijay for spira 6047
--     V_AMOUNT2	CHAR(20)
to_number(KYCAWA)/1000,
--     V_AMOUNT3	CHAR(20)
to_number(KYCQDA)/1000,
--     V_AMOUNT4	CHAR(20)
to_number(KYIFTA)/1000,
--     V_AMOUNT5	CHAR(20)
to_number(KYOFTA)/1000,
--     V_AMOUNT6	CHAR(20)
'',
--     V_AMOUNT7	CHAR(20)
'',
--     V_INTFIELD1	CHAR(38)
KYCADN,
--     V_INTFIELD2	CHAR(38)
KYCAWN,
--     V_INTFIELD3	CHAR(38)
KYCQDN,
--     V_INTFIELD4	CHAR(38)
KYIFTN,
--     V_INTFIELD5	CHAR(38)
KYOFTN,
--     V_STATEMENTTYPE	CHAR(5)
'',
--     V_STATEMENTFREQUENCY	CHAR(5)
'',
--     V_STMTDATEWEEKDAY	CHAR(1)
'',
--     V_STMTMONTHLYSTARTDATE	CHAR(2)
'',
--     V_ACTIONDURINGHOLIDAY	CHAR(10)
'',
--     V_DESPATCHMODE	CHAR(5)
'',
--     V_CALENDERTYPE	CHAR(5)
'',
--     V_DISCOUNTAVAILED	CHAR(1)
'',
--     V_DISCOUNTTYPE	CHAR(5)
'',
--     V_PREFEFFECTIVEDATE	CHAR(11)
'',
--     V_PREFEXPIRYDATE	CHAR(11)
'',
--     V_LASTCONTACTEDDATE	CHAR(11)
'',
--     V_LASTCONTACTEDCHANNEL	CHAR(20)
'',
--     V_FAMILYTYPE	CHAR(50)
'',
--     V_NOOFEARNERS	CHAR(2)
'',
--     V_REMARKS	CHAR(50)
'',
--     V_COMMUNITY	CHAR(50)
'',
--     V_LTVINDICATOR	CHAR(5)
'',
--     V_ASSETCLASSIFICATION	CHAR(5)
'',
--     V_ASSETCLASSIFICATIONDESC	CHAR(50)
'',
--     V_ASSETCLASSIFIEDON	CHAR(11)
'',
--     V_CUSTHEALTHCODE	CHAR(5)
'',
--     V_CREDITDISCOUNTPERCENT	CHAR(9)
'',
--     V_DEBITDISCOUNTPERCENT	CHAR(9)
'',
--     V_PREFERRENTIALEXPIRYDATE	CHAR(11)
'',
--     V_INTERESTDESCRIPTION	CHAR(20)
'',
--     V_STMTWEEKOFMONTH	CHAR(1)
'',
--     V_CUSTCHARGECODE	CHAR(5)
'',
--     V_CUSTCHARGE	CHAR(50)
'',
--     V_CHARGEDEBITFORACID	CHAR(16)
'',
--     V_CHARGEDEBITSOLID	CHAR(8)
'',
--     V_CHARGEHISTORYFLAG	CHAR(1)
'',
--     V_CUSTOMERCURRENCY	CHAR(3)
'KWD',
--     V_LOANSSTATEMENTTYPE	CHAR(1)
'',
--     V_TDSSTATEMENTTYPE	CHAR(1)
'',
--     V_COMBSTMTCHARGECODE	CHAR(5)
'',
--     V_TDSCUSTFLOORLIMIT	CHAR(20)
'',
--     V_COMMUNITY_CODE	CHAR(5)
'',
--     V_CUST_HEALTH_REF_CODE	CHAR(5)
'',
--     V_CUST_PREF_TILL_DATE	CHAR(11)
'',
--     V_CU_TDSCUSTFLOORLIMIT	CHAR(3)
'',
--     V_CHECKSUM	CHAR(100)
'',
--     V_PREFERRED_LOCALE	CHAR(50)
'en_US',
--     V_BANK_ID	CHAR(8)
get_param('BANK_ID'),
--     V_NATURE_OF_ACT	CHAR(50)
replace(kyctr,'-','')
from map_cif 
inner join gfpf gfpf_kw  on   nvl(gfpf_kw.gfclc,' ')=nvl(map_cif.gfclc,' ')  and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw  on nvl(GFPF_KW.GFCLC,' ')=nvl(BGPF_KW.BGCLC,' ') and GFPF_KW.GFCUS=BGPF_KW.BGCUS 
left join  ukyc01pf a  on nvl(a.kyclc,' ')=nvl(map_cif.gfclc,' ')  and  a.kycus=map_cif.gfcus
left join (select kycus,kyclc, LISTAGG(trim(kyctr), ',')  WITHIN GROUP (ORDER BY kycus,kyclc) kyctr from ( 
select kycus,kyclc,kyctr1 kyctr from UKYC01PF where trim(kyctr1) is not null union select kycus,kyclc,kyctr2 kyctr from UKYC01PF where trim(kyctr2) is not null
union select kycus,kyclc,kyctr3 kyctr from UKYC01PF where trim(kyctr3) is not null union select kycus,kyclc,kyctr4 kyctr from UKYC01PF where trim(kyctr4) is not null
union select kycus,kyclc,kyctr5 kyctr from UKYC01PF where trim(kyctr5) is not null ) group by kycus,kyclc
) act on nvl(act.kyclc,' ')=nvl(map_cif.gfclc,' ')  and  act.kycus=map_cif.gfcus
where map_cif.individual='Y' and map_cif.del_flg<>'Y'; 
--and is_joint<>'Y'-------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
-------------------------------------------------POA and Guarantor new cif_id------------------------------
INSERT INTO CU9_O_TABLE 
SELECT  distinct
--     V_ORGKEY		CHAR(50)
FIN_CIF_ID,
--     V_COMMUNICATION_LANGUAGE	CHAR(50)
	'INFENG',
--     V_PREFERRED_ADDRESS_MODE	CHAR(50)
'',
--     V_BEHAVIOURAL_SCORE  CHAR(100)
'',
--     V_RISK_BEHAVIOUR	CHAR(100)
'',
--     V_OTHER_BEHAVIOURAL_PROFILE	CHAR(100)
'',
--     V_LIFE_CYCLE_STAGE 	CHAR(100)
'',
--     V_SERVICE_PERSONALISE	CHAR(200)
'',
--     V_PSYCHOGRAPHICTYPE	CHAR(50)
'',
--     V_PRIORITY_IDENTIFIER	CHAR(25)
'', 
--     V_HOUSEHOLD_NUMBER	CHAR(10)
'',
--     V_PREFERRED_REP		CHAR(38)
'',
--     V_SEGMENTATION_CLASS	CHAR(100)
'',
--     V_PREFERREDNAME		CHAR(50)
'ZZZ',
--     V_NUMBEROFDEPENDANTS	CHAR(38)
'',
--     V_NUMBEROFDEPENDANTCHILDREN	CHAR(38)
'',
--     V_STMTDATEFORCOMBSTMT	CHAR(10)
'',
--     V_SUBSEGMENT	CHAR(50)
'',
--     V_HOBBYFIELD1	CHAR(50)
'',
--     V_HOBBYFIELD2	CHAR(50)
'',
--     V_HOBBYFIELD3	CHAR(50)
'',
--     V_HOBBYFIELD4	CHAR(50)
'',
--     V_HOBBYFIELD5	CHAR(50)
'',
--     V_HOBBYFIELD6	CHAR(50)
'',
--     V_PROFILE_FIELD1	CHAR(200)
'',
--     V_PROFILE_FIELD2	CHAR(200)
'',
--     V_PROFILE_FIELD3	CHAR(200)
'',
--     V_PROFILE_FIELD4	CHAR(200)
'',
--     V_ALERT1	CHAR(100)
'',
--     V_ALERT2	CHAR(100)
'',
--     V_ALERT3	CHAR(100)
'',
--     V_ALERT4	CHAR(100)
'',
--     V_ALERT5	CHAR(100)
'',
--     V_FLAG1	CHAR(5)
'',
--     V_FLAG2	CHAR(5)
'',
--     V_FLAG3	CHAR(5)
'',
--     V_FLAG4	CHAR(5)
'',
--     V_FLAG5	CHAR(5)
'',
--     V_BANK_DEFINED_PREFER_VAR1	CHAR(20)
'',
--     V_BANK_DEFINED_PREFER_VAR2	CHAR(20)
'',
--     V_BANK_DEFINED_PREFER_VAR3	CHAR(20)
'',
--     V_BANK_DEFINED_PREFER_DATE1	CHAR(10)
'',
--     V_BANK_DEFINED_PREFER_DATE2	CHAR(10)
'',
--     V_BANK_DEFINED_PREFER_DATE3	CHAR(10)
'',
--     V_USERFIELD1	CHAR(50)
'',
--     V_USERFIELD2	CHAR(50)
'',
--     V_USERFIELD3	CHAR(50)
'',
--     V_USERFIELD4	CHAR(50)
'',
--     V_USERFIELD5	CHAR(50)
'',
--     V_USERFIELD6	CHAR(50)
'',
--     V_SPSERVICEREQUIRED1	CHAR(25)
'',
--     V_SPSERVICEREQUIRED2	CHAR(25)
'',
--     V_SPSERVICEREQUIRED3	CHAR(25)
'',
--     V_SPSERVICEREQUIRED4	CHAR(25)
'',
--     V_SPSERVICEREQUIRED5	CHAR(25)
'',
--     V_USERFLAG1	CHAR(1)
'',
--     V_USERFLAG2	CHAR(1)
'',
--     V_PREFRELSHIPDISCOUNT1	CHAR(20)
'',
--     V_PREFRELSHIPDISCOUNT2	CHAR(20)
'',
--     V_PREFRELSHIPDISCOUNTPERCENT1	CHAR(9)
'',
--     V_PREFRELSHIPDISCOUNTPERCENT2	CHAR(9)
'',
--     V_USERFIELD7	CHAR(50)
'',
--     V_USERFIELD8	CHAR(50)
'',
--     V_USERFIELD9	CHAR(50)
'',
--     V_USERFIELD10	CHAR(50)
'',
--     V_USERFIELD11	CHAR(50)
'',
--     V_USERFIELD12	CHAR(50)
'',
--     V_USERFIELD13	CHAR(50)
'',
--     V_AMOUNT1	CHAR(20)
'',
--     V_AMOUNT2	CHAR(20)
'',
--     V_AMOUNT3	CHAR(20)
'',
--     V_AMOUNT4	CHAR(20)
'',
--     V_AMOUNT5	CHAR(20)
'',
--     V_AMOUNT6	CHAR(20)
'',
--     V_AMOUNT7	CHAR(20)
'',
--     V_INTFIELD1	CHAR(38)
'',
--     V_INTFIELD2	CHAR(38)
'',
--     V_INTFIELD3	CHAR(38)
'',
--     V_INTFIELD4	CHAR(38)
'',
--     V_INTFIELD5	CHAR(38)
'',
--     V_STATEMENTTYPE	CHAR(5)
'',
--     V_STATEMENTFREQUENCY	CHAR(5)
'',
--     V_STMTDATEWEEKDAY	CHAR(1)
'',
--     V_STMTMONTHLYSTARTDATE	CHAR(2)
'',
--     V_ACTIONDURINGHOLIDAY	CHAR(10)
'',
--     V_DESPATCHMODE	CHAR(5)
'',
--     V_CALENDERTYPE	CHAR(5)
'',
--     V_DISCOUNTAVAILED	CHAR(1)
'',
--     V_DISCOUNTTYPE	CHAR(5)
'',
--     V_PREFEFFECTIVEDATE	CHAR(11)
'',
--     V_PREFEXPIRYDATE	CHAR(11)
'',
--     V_LASTCONTACTEDDATE	CHAR(11)
'',
--     V_LASTCONTACTEDCHANNEL	CHAR(20)
'',
--     V_FAMILYTYPE	CHAR(50)
'',
--     V_NOOFEARNERS	CHAR(2)
'',
--     V_REMARKS	CHAR(50)
'',
--     V_COMMUNITY	CHAR(50)
'',
--     V_LTVINDICATOR	CHAR(5)
'',
--     V_ASSETCLASSIFICATION	CHAR(5)
'',
--     V_ASSETCLASSIFICATIONDESC	CHAR(50)
'',
--     V_ASSETCLASSIFIEDON	CHAR(11)
'',
--     V_CUSTHEALTHCODE	CHAR(5)
'',
--     V_CREDITDISCOUNTPERCENT	CHAR(9)
'',
--     V_DEBITDISCOUNTPERCENT	CHAR(9)
'',
--     V_PREFERRENTIALEXPIRYDATE	CHAR(11)
'',
--     V_INTERESTDESCRIPTION	CHAR(20)
'',
--     V_STMTWEEKOFMONTH	CHAR(1)
'',
--     V_CUSTCHARGECODE	CHAR(5)
'',
--     V_CUSTCHARGE	CHAR(50)
'',
--     V_CHARGEDEBITFORACID	CHAR(16)
'',
--     V_CHARGEDEBITSOLID	CHAR(8)
'',
--     V_CHARGEHISTORYFLAG	CHAR(1)
'',
--     V_CUSTOMERCURRENCY	CHAR(3)
'KWD',
--     V_LOANSSTATEMENTTYPE	CHAR(1)
'',
--     V_TDSSTATEMENTTYPE	CHAR(1)
'',
--     V_COMBSTMTCHARGECODE	CHAR(5)
'',
--     V_TDSCUSTFLOORLIMIT	CHAR(20)
'',
--     V_COMMUNITY_CODE	CHAR(5)
'',
--     V_CUST_HEALTH_REF_CODE	CHAR(5)
'',
--     V_CUST_PREF_TILL_DATE	CHAR(11)
'',
--     V_CU_TDSCUSTFLOORLIMIT	CHAR(3)
'',
--     V_CHECKSUM	CHAR(100)
'',
--     V_PREFERRED_LOCALE	CHAR(50)
'en_US',
--     V_BANK_ID	CHAR(8)
get_param('BANK_ID'),
--     V_NATURE_OF_ACT	CHAR(50)
''
FROM MAP_CIF_JOINT JNT;
--LEFT JOIN (SELECT DISTINCT * FROM POA_CUSTOMER) POA ON POA.GFCLC||POA.GFCUS=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='POA' AND CIF_NAME=BGRLNM
--LEFT JOIN guarantor_customer gtr ON gtr.LOC||gtr.CUSTOMER=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='GTR' AND CIF_NAME=GUARANTOR_NAME
--LEFT JOIN guardian_customer guar ON guar.LOC||guar.CUS=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='GUAR' AND CIF_NAME=GUARDIAN_NAME
--left join (SELECT DISTINCT GFCLC,GFCUS,DOC_ID,NAME,bgclc,bgcus   FROM shareholder_retail) shr on shr.GFCLC||shr.GFCUS=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='SHARE' and CIF_NAME=name
commit; 
exit; 