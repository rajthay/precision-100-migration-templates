-- File Name        : cu8_upload.sql
-- File Created for : Upload file for cu7
-- Created By       : Jagadeesh M
-- Client           : ABK
-- Created On       : 11-05-2016
-------------------------------------------------------------------
truncate table CU8_O_TABLE;
INSERT INTO CU8_O_TABLE
SELECT distinct
--     V_ORGKEY    CHAR(50)
MAP_CIF.FIN_CIF_ID,
--     V_MARITAL_STATUS_CODE    CHAR(5)
convert_codes('MARITAL',upper(trim(BGMART))),
--     V_EMPLOYMENT_STATUS    CHAR(50)
convert_codes('EMPLOYMENT_STATUS',''),
--     V_ANNUAL_SALARY_INCOME    CHAR(20)
case when RS04_NETSL is not null then to_char(RS04_NETSL) when bgpf_kw.BGSLTO is not null then to_char(bgpf_kw.BGSLTO)  else '' end,
--     V_TDSEXCEMPTENDDATE    CHAR(11)
'',
--     V_TDSEXCEMPTSUBMITDATE    CHAR(11)
'',
--     V_TDSEXCEMPTREFNUM    CHAR(30)
'',
--     V_TDSEXCEMPTREMARKS    CHAR(80)
'',
--     V_CUSTCASTE    CHAR(50)
'',
--     V_CUSTBUSINESSASSETS    CHAR(20)
'',
--     V_CUSTPROPERTYASSETS    CHAR(20)
'',
--     V_CUSTINVESTMENTS    CHAR(20)
'',
--     V_CUSTNETWORTH    CHAR(20)
'',
--     V_CUSTDEPOSITSINOTHERBANKS    CHAR(20)
'',
--     V_ADVANCEASONDATE    CHAR(11)
'',
--     V_TOTALFUNDBASE    CHAR(25)
'',
--     V_TOTALNONFUNDBASE    CHAR(25)
'',
--     V_CUSTFINYEARENDMONTH    CHAR(2)
'',
--     V_NATIONALITY_CODE    CHAR(5)
 case when GFPF_KW.GFCNAP='AN' then 'AN'
			  when GFPF_KW.GFCNAP='CS' then 'CZ'	
	          when trim(gfpf_kw.GFCNAP)='WT' then 'XX' --- Based on Vijay and Ranjithe input on 7th Sep 2017 'TL' to 'XX'
			  when trim(GFPF_KW.GFCNAP) is not null then TO_CHAR(GFPF_KW.GFCNAP)
			  else 'ZZZ' end,
--     V_RESIDENCECOUNTRY_CODE    CHAR(5)
--nvl(GFCNAL,'ZZZ'),
 case when GFPF_KW.GFCNAP='AN' then 'AN'
			  when GFPF_KW.GFCNAP='CS' then 'CZ'	
              when GFPF_KW.GFCNAP='XX' then 'KW'
			  when GFPF_KW.GFCNAP='WT' then 'TL'
			  when trim(GFPF_KW.GFCNAP) is not null then TO_CHAR(GFPF_KW.GFCNAP)
			  else 'ZZZ' end,
--     V_NRERELATIVENAME    CHAR(40)
'',
--     V_NRECOUNTRYTYPE    CHAR(1)
'',
--     V_DEMOGRAPHICTYPE    CHAR(50)
'',
--     V_PHONE_HOME    CHAR(20)
'',
--     V_PHONE_WORK    CHAR(20)
'',
--     V_EXTENSION    CHAR(10)
'',
--     V_PHONE_CELL    CHAR(20)
'',
--     V_FAX_WORK    CHAR(20)
'',
--     V_EMAIL_HOME    CHAR(50)
'',
--     V_EMAIL_WORK    CHAR(50)
'',
--     V_EMAIL_PALM    CHAR(50)
'',
--     V_URL    CHAR(50)
'',
--     V_CUSTOMER_SEGMENT    CHAR(50)
'',
--     V_CUSTOMER_TYPE    CHAR(50)
'',
--     V_NATIONALITY    CHAR(50)
 case when GFPF_KW.GFCNAP='AN' then 'AN'
			  when GFPF_KW.GFCNAP='CS' then 'CZ'	
			  when trim(gfpf_kw.GFCNAP)='WT' then 'XX' --- Based on Vijay and Ranjithe input on 7th Sep 2017 'TL' to 'XX'
			  when trim(GFPF_KW.GFCNAP) is not null then TO_CHAR(GFPF_KW.GFCNAP)
			  else 'ZZZ' end,
--     V_RESIDENCE_COUNTRY    CHAR(50)
--nvl(trim(GFCNAL),'ZZZ'), --Second nationality field in Frontend hence passing as Null from Mock4 . Changed on 25-Apr-2017
 --case when GFPF_KW.GFCNAP='AN' then 'AN'
			  --when GFPF_KW.GFCNAP='CS' then 'CZ'	
			  --when GFPF_KW.GFCNAP='WT' then 'TL'
			  --when trim(GFPF_KW.GFCNAP) is not null then TO_CHAR(GFPF_KW.GFCNAP)
			  --else 'ZZZ' end,
'',--Second nationality field in Frontend hence passing as Null from Mock4 but code was changed hence rechanged on 15/5/2017 by Jagadeesh. 
--     V_RESIDENCE_SINCE    CHAR(11)
'',
--     V_MARITAL_STATUS    CHAR(50)
convert_codes('MARITAL',upper(trim(BGMART))),
--     V_ANNIVERSARY_DATE    CHAR(11)
'',
--     V_INCOME_NATURE    CHAR(50)
'Stable',
--     V_PAYMENT_MODE    CHAR(50)
'',
--     V_ANNUAL_RENTAL_INCOME    CHAR(20)
'',
--     V_ANNUAL_STOCK_BOND_INCOME    CHAR(20)
'',
--     V_ANNUAL_OTHERS_INCOME    CHAR(20)
'',
--     V_ANNUAL_TOTAL_INCOME    CHAR(20)
'',
--     V_REFERENCE_CURRENCY_INCOME    CHAR(50)
'',
--     V_BASE_CURRENCY_INCOME    CHAR(50)
'',
--     V_ANNUAL_OPERATING_EXP    CHAR(20)
'',
--     V_ANNUAL_LOAN_INSTAL    CHAR(20)
'',
--     V_ANNUAL_INTPROD_EXP    CHAR(20)
'',
--     V_ANNUAL_EXTPROD_EXP    CHAR(20)
'',
--     V_ANNUAL_COMMIT_EXP    CHAR(20)
'',
--     V_ANNUAL_OTHER_EXP    CHAR(20)
'',
--     V_REFERENCE_CURRENCY_EXP    CHAR(50)
'',
--     V_BASE_CURRENCY_EXP    CHAR(50)
'',
--     V_ANNUAL_TOTAL_EXP    CHAR(20)
'',
--     V_HOMEPHONEOPTIONALCOUNTRYCODE    CHAR(20)
'',
--     V_HOMEPHONEOPTIONALCITYCODE    CHAR(20)
'',
--     V_HOMEPHONEOPTIONALLOCALCODE    CHAR(20)
'',
--     V_WORKPHONEOPTIONALCOUNTRYCODE    CHAR(20)
'',
--     V_WORKPHONEOPTIONALCITYCODE    CHAR(20)
'',
--     V_WORKPHONEOPTIONALLOCALCODE    CHAR(20)
'',
--     V_CELLPHONEOPTIONALCOUNTRYCODE    CHAR(20)
'',
--     V_CELLPHONEOPTIONALCITYCODE    CHAR(20)
'',
--     V_CELLPHONEOPTIONALLOCALCODE    CHAR(20)
'',
--     V_FAXOPTIONALCOUNTRYCODE    CHAR(20)
'',
--     V_FAXOPTIONALCITYCODE    CHAR(20)
'',
--     V_FAXOPTIONALLOCALCODE    CHAR(20)
'',
--     V_PAGEROPTIONAL    CHAR(20)
'',
--     V_PAGEROPTIONALCOUNTRYCODE    CHAR(20)
'',
--     V_PAGEROPTIONALAREACODE    CHAR(20)
'',
--     V_PAGEROPTIONALLOCALCODE    CHAR(20)
'',
--     V_SALALLOWANCES    CHAR(20)
RS04_EOSCO,
--     V_SALPRORATAMONTHLYINCENTIVE    CHAR(20)
RS04_OTHIC,
--     V_SALINTERESTSUBSIDY    CHAR(20)
'',
--     V_SALOTHERINCOME2    CHAR(20)
'',
--     V_SALOTHERINCOME3    CHAR(20)
'',
--     V_TOTALESTACCOUNTVALUE    CHAR(20)
'',
--     V_TOTALINVESTMENT    CHAR(20)
'',
--     V_TOTALMONTHLYDEBTSERVICEAMT    CHAR(20)
'',
--     V_SELFEMPTAXRETURNFIELD    CHAR(20)
'N',
--     V_SELFEMPGROSSRECIPTCURRENTYR    CHAR(20)
'',
--     V_SELFEMPGROSSRECEIPTPRIORYEAR    CHAR(20)
'',
--     V_SELFEMPNETPROFITCURRENTYR    CHAR(20)
'',
--     V_SELFEMPNETPROFITPRIORYR    CHAR(20)
'',
--     V_SELFEMPDEPRECIATIONCURRENTY    CHAR(20)
'',
--     V_SELFEMPDEPRECIATIONPRIORYEAR    CHAR(20)
'',
--     V_SELFEMPAVERAGEANNUALTURNOVER    CHAR(20)
'',
--     V_TOTALHOUSEHOLDINCM    CHAR(20)
'',
--     V_DOOPTIONALTMAILFLAG    CHAR(1)
'N',
--     V_DOOPTIONALTCALLFLAG    CHAR(1)
'N',
--     V_HOLDMAILFLAG    CHAR(1)
'N',
--     V_HOLDMAILDESCRIPTION    CHAR(100)
'',
--     V_DONOTSENDEMAILFLG    CHAR(1)
'N',
--     V_HOLDMAILSTARTDATE    CHAR(11)
'',
--     V_HOLDMAILENDDATE    CHAR(11)
'',
--     V_PREFCONTTIME    CHAR(50)
'',
--     V_PREFDAYTIMECONTOPTIONAL    CHAR(20)
'',
--     V_PREFDAYTIMECONTOPTIONALLOCAL    CHAR(20)
'',
--     V_PREFDAYTIMECONTOPTIONALAREA    CHAR(20)
'',
--     V_PREFDAYTIMECONTOPTIONALCOUN    CHAR(20)
'',
--     V_PHONEOTHER    CHAR(20)
'',
--     V_PHONEOTHERLOCAL    CHAR(20)
'',
--     V_PHONEOTHERAREA    CHAR(20)
'',
--     V_PHONEOTHERCOUNTRY    CHAR(20)
'',
--     V_CU_ANNUAL_SALARY_INCOME    CHAR(3)
'KWD',
--     V_CU_ANNUAL_RENTAL_INCOME    CHAR(3)
'',
--     V_CU_ANNUAL_STOCK_BOND_INCOME    CHAR(3)
'',
--     V_CU_ANNUAL_OTHERS_INCOME    CHAR(3)
'',
--     V_CU_ANNUAL_TOTAL_INCOME    CHAR(3)
'',
--     V_CU_ANNUAL_OPERATING_EXP    CHAR(3)
'',
--     V_CU_ANNUAL_LOAN_INSTAL    CHAR(3)
'',
--     V_CU_ANNUAL_INTPROD_EXP    CHAR(3)
'',
--     V_CU_ANNUAL_EXTPROD_EXP    CHAR(3)
'',
--     V_CU_ANNUAL_COMMIT_EXP    CHAR(3)
'',
--     V_CU_ANNUAL_OTHER_EXP    CHAR(3)
'',
--     V_CU_ANNUAL_TOTAL_EXP    CHAR(3)
'',
--     V_CU_SALWANCES    CHAR(3)
'',
--     V_CU_SALPRORATAMONTHLYINCENTI    CHAR(3)
'',
--     V_CU_SALINTERESTSUBSIDY    CHAR(3)
'',
--     V_CU_SALOTHERINCOME2    CHAR(3)
'',
--     V_CU_SALOTHERINCOME3    CHAR(3)
'',
--     V_CU_TOTALESTACCOUNTVALUE    CHAR(3)
'',
--     V_CU_TOTALINVESTMENT    CHAR(3)
'',
--     V_CU_TOTALMONTHLYDEBTSERVICE    CHAR(3)
'',
--     V_CU_SELFEMPTAXRETURNFIELD    CHAR(3)
'',
--     V_CU_SELFEMPGROSSRECIPTCURREN    CHAR(3)
'',
--     V_CU_SELFEMPGROSSRECEIPTPRIOR    CHAR(3)
'',
--     V_CU_SELFEMPNETPROFITCURRENTY    CHAR(3)
'',
--     V_CU_SELFEMPNETPROFITPRIORYR    CHAR(3)
'',
--     V_CU_SELFEMPDEPRCURRYR    CHAR(3)
'',
--     V_CU_SELFEMPDEPRPRIORYR    CHAR(3)
'',
--     V_CU_SELFEMPAVGANNUALTUROPTIO    CHAR(3)
'',
--     V_CU_TOTALHOUSEHOLDINCM    CHAR(3)
'',
--     V_CU_INVESTMENTSHARESANDUNITS    CHAR(3)
'',
--     V_USERFIELD1    CHAR(50)
'',
--     V_USERFIELD2    CHAR(50)
'',
--     V_USERFIELD3    CHAR(50)
'',
--     V_USERFLAG1    CHAR(1)
case when trim(RS04_SALAB)='YES' then 'Y' else 'N' end,
--     V_USERFLAG2    CHAR(1)
'',
--     V_ALERT1    CHAR(150)
'',
--     V_ALERT2    CHAR(150)
'',
--     V_ALERT3    CHAR(150)
'',
--     V_ALERT4    CHAR(150)
'',
--     V_ALERT5    CHAR(150)
'',
--     V_BANK_DEFINED_DEMO_VAR1    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR2    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR3    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR4    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR5    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR6    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR7    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR8    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR9    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_DATE1    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE2    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE3    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE4    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE5    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE6    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE7    CHAR(11)
'',
--     V_USERFIELD4    CHAR(50)
BGACBK,
--     V_USERFIELD5    CHAR(50)
'',
--     V_USERFIELD6    CHAR(50)
'',
--     V_USERFIELD7    CHAR(50)
'',
--     V_USERFIELD8    CHAR(50)
'',
--     V_USERFIELD9    CHAR(50)
'',
--     V_USERFIELD10    CHAR(50)
'',
--     V_AMOUNT1    CHAR(20)
'',
--     V_AMOUNT2    CHAR(20)
'',
--     V_AMOUNT3    CHAR(20)
'',
--     V_AMOUNT4    CHAR(20)
'',
--     V_AMOUNT5    CHAR(20)
'',
--     V_AMOUNT6    CHAR(20)
'',
--     V_AMOUNT7    CHAR(20)
'',
--     V_INTFIELD1    CHAR(38)
'',
--     V_INTFIELD2    CHAR(38)
'',
--     V_INTFIELD3    CHAR(38)
'',
--     V_INTFIELD4    CHAR(38)
'',
--     V_INTFIELD5    CHAR(38)
'',
--     V_TOTAL_DEDUCTIONS    CHAR(20)
'',
--     V_CU_TOTAL_DEDUCTIONS    CHAR(3)
'',
--     V_NET_SAVINGS    CHAR(20)
'',
--     V_CU_NET_SAVINGS    CHAR(3)
'',
--     V_NET_HOUSEHOLD_INCOME    CHAR(20)
'',
--     V_CU_NETHOUSEHOLDINCOME    CHAR(3)
'',
--     V_SHAREHOLDERTYPE    CHAR(5)
'N',
--     V_SHAREHOLDEREFFECTIVEDATE    CHAR(11)
'',
--     V_TOTALSHARESVALUE    CHAR(20)
'',
--     V_CU_TOTALSHARESVALUE    CHAR(3)
'',
--     V_NUMBEROFSHARES    CHAR(10)
'',
--     V_CUSTOTHERBANKCODE    CHAR(5)
'',
--     V_CU_CUSTDEPOSITSIOPTHERBANKS    CHAR(3)
'',
--     V_CU_CUSTBUSINESSASSETS    CHAR(3)
'',
--     V_CU_CUSTPROPERTYASSETS    CHAR(3)
'',
--     V_CU_CUSTINVESTMENTS    CHAR(3)
'',
--     V_CU_CUSTNETWORTH    CHAR(3)
'',
--     V_CUSTASSETSASONDATE    CHAR(20)
'',
--     V_CU_CUSTASSETSASONDATE    CHAR(3)
'',
--     V_EMPLOYERSNAME    CHAR(50)
--GFP5R,
GUP5D,----changed on 09-05-2017 as per our validation
--     V_SOURCEOFINCOME    CHAR(50)
bgsoic,
--     V_CU_TOTALFUNDBASE    CHAR(3)
'',
--     V_CU_TOTALOPTIONALNFUNDBASE    CHAR(3)
'',
--     V_OTHERLIMITS    CHAR(20)
'',
--     V_CU_OTHERLIMITS    CHAR(3)
'',
--     V_TDSTABLECODE    CHAR(5)
'',
--     V_TDSTABLE    CHAR(50)
'',
--     V_TDSCUSTID    CHAR(9)
'',
--     V_EMPLOYERID    CHAR(12)
--scp5r,-- added on 11-09-2017 as per vijay discussion with nancy and sandeep
'', ---removed on 27-09-2017 as per sandeep and anegha confirmation and provided in cu3 upload
--     V_NRERELATIVECODE    CHAR(5)
'',
--     V_NRERELATIVE    CHAR(50)
'',
--     V_EMPLOYERID_CODE    CHAR(12)
'',
--     V_CHANNELSACCESSED    CHAR(500)
'',
--     V_OUTSTANDING_MORTAGE    CHAR(20)
'',
--     V_CU_OUTSTANDING_MORTGAGE    CHAR(3)
'',
--     V_BANK_ID    CHAR(8)
get_param('BANK_ID'),
--     V_EMPLOYERSNAME_ALT1    CHAR(10)
'',
--     V_NRERELATIVENAME_ALT1    CHAR(40)
''
from map_cif 
inner join gfpf gfpf_kw  on gfpf_kw.gfclc=map_cif.gfclc and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw  on nvl(GFPF_KW.GFCLC,'')=nvl(BGPF_KW.BGCLC,'') and GFPF_KW.GFCUS=BGPF_KW.BGCUS 
left join YRCS04PF on RS04_CLC=map_cif.gfclc and  RS04_CUS=map_cif.gfcus
left join gupf on trim(gfp5r)=trim(GUP5R)
left join (select distinct fin_cif_id,scp5r from map_acc
inner join scpf  on leg_branch_id||leg_Scan||leg_scas=scab||scan||scas
where trim(scp5r) is not null) scp5r on  scp5r.fin_cif_id=map_cif.fin_cif_id
where map_cif.individual='Y' and map_cif.del_flg<>'Y'; 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
-------------------------------------------------POA and Guarantor new cif_id------------------------------
INSERT INTO CU8_O_TABLE
SELECT distinct
--     V_ORGKEY    CHAR(50)
FIN_CIF_ID,
--     V_MARITAL_STATUS_CODE    CHAR(5)
convert_codes('MARITAL',''),
--     V_EMPLOYMENT_STATUS    CHAR(50)
convert_codes('EMPLOYMENT_STATUS',''),
--     V_ANNUAL_SALARY_INCOME    CHAR(20)
'',
--     V_TDSEXCEMPTENDDATE    CHAR(11)
'',
--     V_TDSEXCEMPTSUBMITDATE    CHAR(11)
'',
--     V_TDSEXCEMPTREFNUM    CHAR(30)
'',
--     V_TDSEXCEMPTREMARKS    CHAR(80)
'',
--     V_CUSTCASTE    CHAR(50)
'',
--     V_CUSTBUSINESSASSETS    CHAR(20)
'',
--     V_CUSTPROPERTYASSETS    CHAR(20)
'',
--     V_CUSTINVESTMENTS    CHAR(20)
'',
--     V_CUSTNETWORTH    CHAR(20)
'',
--     V_CUSTDEPOSITSINOTHERBANKS    CHAR(20)
'',
--     V_ADVANCEASONDATE    CHAR(11)
'',
--     V_TOTALFUNDBASE    CHAR(25)
'',
--     V_TOTALNONFUNDBASE    CHAR(25)
'',
--     V_CUSTFINYEARENDMONTH    CHAR(2)
'',
--     V_NATIONALITY_CODE    CHAR(5)
 'ZZZ',
--     V_RESIDENCECOUNTRY_CODE    CHAR(5)
'ZZZ',
--     V_NRERELATIVENAME    CHAR(40)
'',
--     V_NRECOUNTRYTYPE    CHAR(1)
'',
--     V_DEMOGRAPHICTYPE    CHAR(50)
'',
--     V_PHONE_HOME    CHAR(20)
'',
--     V_PHONE_WORK    CHAR(20)
'',
--     V_EXTENSION    CHAR(10)
'',
--     V_PHONE_CELL    CHAR(20)
'',
--     V_FAX_WORK    CHAR(20)
'',
--     V_EMAIL_HOME    CHAR(50)
'',
--     V_EMAIL_WORK    CHAR(50)
'',
--     V_EMAIL_PALM    CHAR(50)
'',
--     V_URL    CHAR(50)
'',
--     V_CUSTOMER_SEGMENT    CHAR(50)
'',
--     V_CUSTOMER_TYPE    CHAR(50)
'',
--     V_NATIONALITY    CHAR(50)
 'ZZZ',
--     V_RESIDENCE_COUNTRY    CHAR(50)
'',
--     V_RESIDENCE_SINCE    CHAR(11)
'',
--     V_MARITAL_STATUS    CHAR(50)
convert_codes('MARITAL',''),
--     V_ANNIVERSARY_DATE    CHAR(11)
'',
--     V_INCOME_NATURE    CHAR(50)
'Stable',
--     V_PAYMENT_MODE    CHAR(50)
'',
--     V_ANNUAL_RENTAL_INCOME    CHAR(20)
'',
--     V_ANNUAL_STOCK_BOND_INCOME    CHAR(20)
'',
--     V_ANNUAL_OTHERS_INCOME    CHAR(20)
'',
--     V_ANNUAL_TOTAL_INCOME    CHAR(20)
'',
--     V_REFERENCE_CURRENCY_INCOME    CHAR(50)
'',
--     V_BASE_CURRENCY_INCOME    CHAR(50)
'',
--     V_ANNUAL_OPERATING_EXP    CHAR(20)
'',
--     V_ANNUAL_LOAN_INSTAL    CHAR(20)
'',
--     V_ANNUAL_INTPROD_EXP    CHAR(20)
'',
--     V_ANNUAL_EXTPROD_EXP    CHAR(20)
'',
--     V_ANNUAL_COMMIT_EXP    CHAR(20)
'',
--     V_ANNUAL_OTHER_EXP    CHAR(20)
'',
--     V_REFERENCE_CURRENCY_EXP    CHAR(50)
'',
--     V_BASE_CURRENCY_EXP    CHAR(50)
'',
--     V_ANNUAL_TOTAL_EXP    CHAR(20)
'',
--     V_HOMEPHONEOPTIONALCOUNTRYCODE    CHAR(20)
'',
--     V_HOMEPHONEOPTIONALCITYCODE    CHAR(20)
'',
--     V_HOMEPHONEOPTIONALLOCALCODE    CHAR(20)
'',
--     V_WORKPHONEOPTIONALCOUNTRYCODE    CHAR(20)
'',
--     V_WORKPHONEOPTIONALCITYCODE    CHAR(20)
'',
--     V_WORKPHONEOPTIONALLOCALCODE    CHAR(20)
'',
--     V_CELLPHONEOPTIONALCOUNTRYCODE    CHAR(20)
'',
--     V_CELLPHONEOPTIONALCITYCODE    CHAR(20)
'',
--     V_CELLPHONEOPTIONALLOCALCODE    CHAR(20)
'',
--     V_FAXOPTIONALCOUNTRYCODE    CHAR(20)
'',
--     V_FAXOPTIONALCITYCODE    CHAR(20)
'',
--     V_FAXOPTIONALLOCALCODE    CHAR(20)
'',
--     V_PAGEROPTIONAL    CHAR(20)
'',
--     V_PAGEROPTIONALCOUNTRYCODE    CHAR(20)
'',
--     V_PAGEROPTIONALAREACODE    CHAR(20)
'',
--     V_PAGEROPTIONALLOCALCODE    CHAR(20)
'',
--     V_SALALLOWANCES    CHAR(20)
'',
--     V_SALPRORATAMONTHLYINCENTIVE    CHAR(20)
'',
--     V_SALINTERESTSUBSIDY    CHAR(20)
'',
--     V_SALOTHERINCOME2    CHAR(20)
'',
--     V_SALOTHERINCOME3    CHAR(20)
'',
--     V_TOTALESTACCOUNTVALUE    CHAR(20)
'',
--     V_TOTALINVESTMENT    CHAR(20)
'',
--     V_TOTALMONTHLYDEBTSERVICEAMT    CHAR(20)
'',
--     V_SELFEMPTAXRETURNFIELD    CHAR(20)
'N',
--     V_SELFEMPGROSSRECIPTCURRENTYR    CHAR(20)
'',
--     V_SELFEMPGROSSRECEIPTPRIORYEAR    CHAR(20)
'',
--     V_SELFEMPNETPROFITCURRENTYR    CHAR(20)
'',
--     V_SELFEMPNETPROFITPRIORYR    CHAR(20)
'',
--     V_SELFEMPDEPRECIATIONCURRENTY    CHAR(20)
'',
--     V_SELFEMPDEPRECIATIONPRIORYEAR    CHAR(20)
'',
--     V_SELFEMPAVERAGEANNUALTURNOVER    CHAR(20)
'',
--     V_TOTALHOUSEHOLDINCM    CHAR(20)
'',
--     V_DOOPTIONALTMAILFLAG    CHAR(1)
'N',
--     V_DOOPTIONALTCALLFLAG    CHAR(1)
'N',
--     V_HOLDMAILFLAG    CHAR(1)
'N',
--     V_HOLDMAILDESCRIPTION    CHAR(100)
'',
--     V_DONOTSENDEMAILFLG    CHAR(1)
'N',
--     V_HOLDMAILSTARTDATE    CHAR(11)
'',
--     V_HOLDMAILENDDATE    CHAR(11)
'',
--     V_PREFCONTTIME    CHAR(50)
'',
--     V_PREFDAYTIMECONTOPTIONAL    CHAR(20)
'',
--     V_PREFDAYTIMECONTOPTIONALLOCAL    CHAR(20)
'',
--     V_PREFDAYTIMECONTOPTIONALAREA    CHAR(20)
'',
--     V_PREFDAYTIMECONTOPTIONALCOUN    CHAR(20)
'',
--     V_PHONEOTHER    CHAR(20)
'',
--     V_PHONEOTHERLOCAL    CHAR(20)
'',
--     V_PHONEOTHERAREA    CHAR(20)
'',
--     V_PHONEOTHERCOUNTRY    CHAR(20)
'',
--     V_CU_ANNUAL_SALARY_INCOME    CHAR(3)
'KWD',
--     V_CU_ANNUAL_RENTAL_INCOME    CHAR(3)
'',
--     V_CU_ANNUAL_STOCK_BOND_INCOME    CHAR(3)
'',
--     V_CU_ANNUAL_OTHERS_INCOME    CHAR(3)
'',
--     V_CU_ANNUAL_TOTAL_INCOME    CHAR(3)
'',
--     V_CU_ANNUAL_OPERATING_EXP    CHAR(3)
'',
--     V_CU_ANNUAL_LOAN_INSTAL    CHAR(3)
'',
--     V_CU_ANNUAL_INTPROD_EXP    CHAR(3)
'',
--     V_CU_ANNUAL_EXTPROD_EXP    CHAR(3)
'',
--     V_CU_ANNUAL_COMMIT_EXP    CHAR(3)
'',
--     V_CU_ANNUAL_OTHER_EXP    CHAR(3)
'',
--     V_CU_ANNUAL_TOTAL_EXP    CHAR(3)
'',
--     V_CU_SALWANCES    CHAR(3)
'',
--     V_CU_SALPRORATAMONTHLYINCENTI    CHAR(3)
'',
--     V_CU_SALINTERESTSUBSIDY    CHAR(3)
'',
--     V_CU_SALOTHERINCOME2    CHAR(3)
'',
--     V_CU_SALOTHERINCOME3    CHAR(3)
'',
--     V_CU_TOTALESTACCOUNTVALUE    CHAR(3)
'',
--     V_CU_TOTALINVESTMENT    CHAR(3)
'',
--     V_CU_TOTALMONTHLYDEBTSERVICE    CHAR(3)
'',
--     V_CU_SELFEMPTAXRETURNFIELD    CHAR(3)
'',
--     V_CU_SELFEMPGROSSRECIPTCURREN    CHAR(3)
'',
--     V_CU_SELFEMPGROSSRECEIPTPRIOR    CHAR(3)
'',
--     V_CU_SELFEMPNETPROFITCURRENTY    CHAR(3)
'',
--     V_CU_SELFEMPNETPROFITPRIORYR    CHAR(3)
'',
--     V_CU_SELFEMPDEPRCURRYR    CHAR(3)
'',
--     V_CU_SELFEMPDEPRPRIORYR    CHAR(3)
'',
--     V_CU_SELFEMPAVGANNUALTUROPTIO    CHAR(3)
'',
--     V_CU_TOTALHOUSEHOLDINCM    CHAR(3)
'',
--     V_CU_INVESTMENTSHARESANDUNITS    CHAR(3)
'',
--     V_USERFIELD1    CHAR(50)
'',
--     V_USERFIELD2    CHAR(50)
'',
--     V_USERFIELD3    CHAR(50)
'',
--     V_USERFLAG1    CHAR(1)
'N',
--     V_USERFLAG2    CHAR(1)
'',
--     V_ALERT1    CHAR(150)
'',
--     V_ALERT2    CHAR(150)
'',
--     V_ALERT3    CHAR(150)
'',
--     V_ALERT4    CHAR(150)
'',
--     V_ALERT5    CHAR(150)
'',
--     V_BANK_DEFINED_DEMO_VAR1    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR2    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR3    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR4    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR5    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR6    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR7    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR8    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_VAR9    CHAR(200)
'',
--     V_BANK_DEFINED_DEMO_DATE1    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE2    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE3    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE4    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE5    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE6    CHAR(11)
'',
--     V_BANK_DEFINED_DEMO_DATE7    CHAR(11)
'',
--     V_USERFIELD4    CHAR(50)
'',
--     V_USERFIELD5    CHAR(50)
'',
--     V_USERFIELD6    CHAR(50)
'',
--     V_USERFIELD7    CHAR(50)
'',
--     V_USERFIELD8    CHAR(50)
'',
--     V_USERFIELD9    CHAR(50)
'',
--     V_USERFIELD10    CHAR(50)
'',
--     V_AMOUNT1    CHAR(20)
'',
--     V_AMOUNT2    CHAR(20)
'',
--     V_AMOUNT3    CHAR(20)
'',
--     V_AMOUNT4    CHAR(20)
'',
--     V_AMOUNT5    CHAR(20)
'',
--     V_AMOUNT6    CHAR(20)
'',
--     V_AMOUNT7    CHAR(20)
'',
--     V_INTFIELD1    CHAR(38)
'',
--     V_INTFIELD2    CHAR(38)
'',
--     V_INTFIELD3    CHAR(38)
'',
--     V_INTFIELD4    CHAR(38)
'',
--     V_INTFIELD5    CHAR(38)
'',
--     V_TOTAL_DEDUCTIONS    CHAR(20)
'',
--     V_CU_TOTAL_DEDUCTIONS    CHAR(3)
'',
--     V_NET_SAVINGS    CHAR(20)
'',
--     V_CU_NET_SAVINGS    CHAR(3)
'',
--     V_NET_HOUSEHOLD_INCOME    CHAR(20)
'',
--     V_CU_NETHOUSEHOLDINCOME    CHAR(3)
'',
--     V_SHAREHOLDERTYPE    CHAR(5)
'N',
--     V_SHAREHOLDEREFFECTIVEDATE    CHAR(11)
'',
--     V_TOTALSHARESVALUE    CHAR(20)
'',
--     V_CU_TOTALSHARESVALUE    CHAR(3)
'',
--     V_NUMBEROFSHARES    CHAR(10)
'',
--     V_CUSTOTHERBANKCODE    CHAR(5)
'',
--     V_CU_CUSTDEPOSITSIOPTHERBANKS    CHAR(3)
'',
--     V_CU_CUSTBUSINESSASSETS    CHAR(3)
'',
--     V_CU_CUSTPROPERTYASSETS    CHAR(3)
'',
--     V_CU_CUSTINVESTMENTS    CHAR(3)
'',
--     V_CU_CUSTNETWORTH    CHAR(3)
'',
--     V_CUSTASSETSASONDATE    CHAR(20)
'',
--     V_CU_CUSTASSETSASONDATE    CHAR(3)
'',
--     V_EMPLOYERSNAME    CHAR(50)
'',
--     V_SOURCEOFINCOME    CHAR(50)
'',
--     V_CU_TOTALFUNDBASE    CHAR(3)
'',
--     V_CU_TOTALOPTIONALNFUNDBASE    CHAR(3)
'',
--     V_OTHERLIMITS    CHAR(20)
'',
--     V_CU_OTHERLIMITS    CHAR(3)
'',
--     V_TDSTABLECODE    CHAR(5)
'',
--     V_TDSTABLE    CHAR(50)
'',
--     V_TDSCUSTID    CHAR(9)
'',
--     V_EMPLOYERID    CHAR(12)
'',
--     V_NRERELATIVECODE    CHAR(5)
'',
--     V_NRERELATIVE    CHAR(50)
'',
--     V_EMPLOYERID_CODE    CHAR(12)
'',
--     V_CHANNELSACCESSED    CHAR(500)
'',
--     V_OUTSTANDING_MORTAGE    CHAR(20)
'',
--     V_CU_OUTSTANDING_MORTGAGE    CHAR(3)
'',
--     V_BANK_ID    CHAR(8)
get_param('BANK_ID'),
--     V_EMPLOYERSNAME_ALT1    CHAR(10)
'',
--     V_NRERELATIVENAME_ALT1    CHAR(40)
''
FROM MAP_CIF_JOINT JNT;
--LEFT JOIN (SELECT DISTINCT * FROM POA_CUSTOMER) POA ON POA.GFCLC||POA.GFCUS=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='POA' AND CIF_NAME=BGRLNM
--LEFT JOIN guarantor_customer gtr ON gtr.LOC||gtr.CUSTOMER=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='GTR' AND CIF_NAME=GUARANTOR_NAME
--LEFT JOIN guardian_customer guar ON guar.LOC||guar.CUS=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='GUAR' AND CIF_NAME=GUARDIAN_NAME
--left join (SELECT DISTINCT GFCLC,GFCUS,DOC_ID,NAME,bgclc,bgcus   FROM shareholder_retail) shr on shr.GFCLC||shr.GFCUS=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='SHARE' and CIF_NAME=name
commit; 
exit; 