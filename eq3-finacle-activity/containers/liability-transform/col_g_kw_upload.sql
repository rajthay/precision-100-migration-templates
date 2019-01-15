
-- File Name           : COL_G_upload.sql
-- File Created for    : Upload file for Collateral for Guarantor
-- Created By          : B.Kumaresan
-- Client              : ENBD
-- Created On          : 10-11-2015
-------------------------------------------------------------------
truncate table COL_G_O_TABLE;
insert into COL_G_O_TABLE
select 
--COL_TYPE           CHAR(1 BYTE),
'R',
--COL_CODE           CHAR(8 BYTE),
'BGT-KWD',
--CEILING_LIMIT      CHAR(17 BYTE),
'9999999999999',
--COL_CLASS          CHAR(5 BYTE),
'',
--COL_GROUP          CHAR(5 BYTE),
'',
--MARGIN_PCNT        CHAR(16 BYTE),
'0',
--LTV_PCNT           CHAR(16 BYTE),
HYSVM,
--DR_ACC_FOR_FEES    CHAR(11 BYTE),
'',
--LAST_VALUATION_DT  CHAR(10 BYTE),
'',
--GUARANTOR_TYPE     CHAR(1 BYTE),
case when map_cif1.individual='Y' then 'P'
else 'C' end,
--GUARANTOR_ID       CHAR(9 BYTE),
cg.cif,
--GUARANTOR_NAME
cg.NAME,
--GUARANTEE_TYPE     CHAR(5 BYTE),
'FLG', --NFG --FLG
--REVIEW_DT          CHAR(10 BYTE),
CASE WHEN HYNRD<>0 AND GET_DATE_FM_BTRV(HYNRD)<> 'ERROR' THEN TO_CHAR(TO_DATE(GET_DATE_FM_BTRV(HYNRD),'YYYYMMDD'),'DD-MM-YYYY') 
     WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN TO_CHAR(TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY')
     ELSE ''
END,
--ADDRESS_LINE1      CHAR(45 BYTE),
NVL(TRN1,'ZZZ'),
--ADDRESS_LINE2      CHAR(45 BYTE),
TRN2,
--CITY_CODE          CHAR(5 BYTE),
'ZZZ',
--STATE_CODE         CHAR(5 BYTE),
'',
--COUNTRY_CODE       CHAR(5 BYTE),
'',
--POSTAL_CODE        CHAR(10 BYTE),
'',
--LODGED_DATE
GET_PARAM('EOD_DATE'),
--CIF_ID             CHAR(32 BYTE),
map_cif.fin_cif_id,
--NOTES              CHAR(240 BYTE),
TRIM(REPLACE(REPLACE(TRIM(TRIM(HYNR1)||' '||TRIM(HYNR2)||' '||TRIM(HYNR3)||' '||TRIM(HYNR4)||' '||
CASE WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') END ),CHR(10),' '),CHR(13),' ')) ,
--GUARANTEE_PCNT     CHAR(16 BYTE),
'',
--GUARANTEE_AMT      CHAR(17 BYTE),
'',
--RECEIVED_DT        CHAR(10 BYTE),
'',
--COL_VALUE          CHAR(17 BYTE),
--CASE WHEN HYPF.HYCLV=0 THEN 0.001 ELSE TO_NUMBER((HYPF.HYCLV)/POWER(10,C8CED)) END ,
TO_NUMBER((HYPF.HYCLV)/POWER(10,C8CED)),
--DUE_DATE           CHAR(10 BYTE)
CASE WHEN HYCXD='9999999' THEN '31-12-2099'
     WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN get_param('EOD_DATE')
ELSE       
     NVL(TO_CHAR(TO_DATE(GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD'),'DD-MM-YYYY'),'31-12-2099')
END,
--Linkage Type
'',
--COLL_STATUS
'',
--FORACID
'',
--DP_CONTRBTN
'',
--Account to be Linked
'',
--Limit Prefix
'',
--Limit Suffix
'',
--UPLOAD_STATUS
'0',
--Serial Number
'',
--FORACID_COLL_VALUE
'',
--CC_FINONE_ACCNT
TRIM(HYCLR),
--finacle_collateral_id
--'',
--COL_DOC_ID
--''
--ASSET_CODE
TRIM(HYCLR),
--COL_LOCATION
trim(HYCLO),
--LAST_REVIEW_DATE
CASE WHEN HYLRD<>0 AND GET_DATE_FM_BTRV(HYLRD)<> 'ERROR' THEN TO_DATE(GET_DATE_FM_BTRV(HYLRD),'YYYYMMDD') END
from (select DISTINCT HYCUS,HYCLC,HYCCY,HYCLR,HYCLP,HYCLV,HYSVM,HYBKV,HYNRD,HYCXD,HYCLO,HYLRD,HYNR1,HYNR2,HYNR3,HYNR4,org,lent,trn1,len_trn1,
case when lent <=90 then substrc(org,len_trn1+1,45) 
else substrc(org,len_trn1+1,
decode(instrc(substrc(org,len_trn1+1,45),' ',-1),0,45,instrc(substrc(org,len_trn1+1,45),' ',-1))) 
end trn2,
length(case when lent <=90 then substrc(org,len_trn1+1,45) 
else substrc(org,len_trn1+1,
decode(instrc(substrc(org,len_trn1+1,45),' ',-1),0,45,instrc(substrc(org,len_trn1+1,45),' ',-1))) 
end ) len_trn2
from 
(select HYCUS,HYCLC,HYCCY,HYCLR,HYCLP,HYCLV,HYSVM,HYBKV,HYNRD,HYCXD,HYCLO,HYLRD,HYNR1,HYNR2,HYNR3,HYNR4,length(TRIM(HYNR2)||TRIM(HYNR3)) lent,TRIM(HYNR2)||TRIM(HYNR3) org,
case when length(TRIM(HYNR2)||TRIM(HYNR3))<45 then TRIM(HYNR2)||TRIM(HYNR3)
when INSTRc(substrc(TRIM(HYNR2)||TRIM(HYNR3),1,45),' ',-1) = 0 then substrc(TRIM(HYNR2)||TRIM(HYNR3),1,45)
else substrc(TRIM(HYNR2)||TRIM(HYNR3),1,INSTRc(substrc(TRIM(HYNR2)||TRIM(HYNR3),1,45),' ',-1))
end
trn1,length(case when length(TRIM(HYNR2)||TRIM(HYNR3))<45 then TRIM(HYNR2)||TRIM(HYNR3)
when INSTRc(substrc(TRIM(HYNR2)||TRIM(HYNR3),1,45),' ',-1) = 0 then substrc(TRIM(HYNR2)||TRIM(HYNR3),1,45)
else substrc(TRIM(HYNR2)||TRIM(HYNR3),1,INSTRc(substrc(TRIM(HYNR2)||TRIM(HYNR3),1,45),' ',-1))
end)len_trn1
from HYPF)aa)hypf
inner join c8pf on c8ccy=hyccy 
inner join map_cif  on trim(hycus)=trim(gfcus) and nvl(trim(hyclc),' ')=nvl(trim(gfclc),' ')
left join COL_GUARANTOR cg on cg.name = trim(replace(upper(HYNR1),'.',''))
left join map_cif map_cif1 on trim(cg.CIF) = trim(map_cif1.FIN_CIF_ID)
where hyclp ='002';
commit;
update COL_G_O_TABLE set SERIAL_NUMBER='G'||rownum;
UPDATE  COL_G_O_TABLE SET REVIEW_DT=GET_PARAM('EOD_DATE') WHERE TO_DATE(REVIEW_DT,'DD-MM-YYYY')<TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')  or TRIM(REVIEW_DT) is null;
commit;
exit; 
