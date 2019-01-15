
-- File Name           : COL_G_upload.sql
-- File Created for    : Upload file for Collateral for Guarantor
-- Created By          : B.Kumaresan
-- Client              : ENBD
-- Created On          : 10-11-2015
-------------------------------------------------------------------
update hypf set hyclr = rpad(trim(hyclr),35,' ') ;
commit;
TRUNCATE TABLE COL_OTHERS_O_TABLE;
INSERT INTO COL_OTHERS_O_TABLE
SELECT distinct
--COL_TYPE                    NVARCHAR2(1),
'O',
--COL_CODE                    NVARCHAR2(8),
case when HYCLP in ('003','004') then 'PORTFOLI'
when HYCLP in ('022','026') then 'OTH-KWD'
end,
--CEILING_LIMIT               NVARCHAR2(17),
'9999999999999',
--COL_CLASS                   NVARCHAR2(5),
'',
--COL_GROUP                   NVARCHAR2(5),
'',
--MARGIN                      NVARCHAR2(8),
'0',
--LTV_PCNT                    NVARCHAR2(8),
HYSVM,
--DR_ACC_FOR_FEES             NVARCHAR2(16),
'',
--LAST_VALUATION_DT           NVARCHAR2(10),
'',
--REASON_CODE                 NVARCHAR2(5),
'',
--NATURE_OF_CHARGE            NVARCHAR2(5),
case when HYCLP in ('003','004') then '006'
when HYCLP in ('022','026') then case when trim(HYNR4) like '%F' then '005' when trim(HYNR4) like '%S' then '007' else '999' end
end,
--COL_VALUE                   NVARCHAR2(17),
--CASE WHEN HYPF.HYCLV=0 THEN 0.001 ELSE TO_NUMBER((HYPF.HYCLV)/POWER(10,C8CED)) END,
CASE WHEN HYPF.HYCLV!=0 THEN TO_NUMBER((HYPF.HYCLV)/POWER(10,C8CED)) ELSE 0.01 END ,
--REVIEW_DATE                 NVARCHAR2(10),
CASE WHEN HYNRD<>0 AND GET_DATE_FM_BTRV(HYNRD)<> 'ERROR' THEN TO_CHAR(TO_DATE(GET_DATE_FM_BTRV(HYNRD),'YYYYMMDD'),'DD-MM-YYYY') 
     WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN TO_CHAR(TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY')
     ELSE ''
END,
--RECEIVED_DATE               NVARCHAR2(10),
'',
--DUE_DATE                    NVARCHAR2(10),
CASE WHEN HYCXD='9999999' THEN '31-12-2099'
     WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN get_param('EOD_DATE')
ELSE       
     NVL(TO_CHAR(TO_DATE(GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD'),'DD-MM-YYYY'),'31-12-2099')
END,
--LODGED_DATE                 NVARCHAR2(10),
GET_PARAM('EOD_DATE'),
--CIF_ID                      NVARCHAR2(12),
MAP_CIF.FIN_CIF_ID,
--NOTES0                      NVARCHAR2(240),
'',
--INSPECTION_TYPE             NVARCHAR2(5),
'',
--ADDRESSLINE_1               NVARCHAR2(45),
NVL(TRN1,'ZZZ'),
--ADDRESLINE_2                NVARCHAR2(45),
TRN2,
--CITY_CODE                   NVARCHAR2(5),
'',
--STATE_CODE                  NVARCHAR2(5),
'',
--ZIP_CODE                    NVARCHAR2(6),
'',
--TELEPHONE_NUMBER            NVARCHAR2(20),
'',
--DATE_OF_VISIT               NVARCHAR2(10),
'31-12-2099' ,
--DUE_DATE_OF_VISIT           NVARCHAR2(10),
'31-12-2099' ,
--INSPECTED_VALUE             NVARCHAR2(17),
'',
--INSPECTED_EMP_ID            NVARCHAR2(10),
'',
--NOTES1                      NVARCHAR2(240),
TRIM(REPLACE(REPLACE(TRIM(TRIM(HYNR1)||' '||TRIM(HYNR2)||' '||TRIM(HYNR3)||' '||TRIM(HYNR4)||' '||
CASE WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') END ),CHR(10),' '),CHR(13),' ')) ,
--NOTES2                      NVARCHAR2(240),
'',
--INSURANCE_TYPE              NVARCHAR2(5),
'',
--INSURER_DETAILS             NVARCHAR2(80),
'',
--INSURANCE_POLICY_NUMBER     NVARCHAR2(15),
'',
--INSURANCE_POLICY_AMOUNT     NVARCHAR2(17),
'',
--RISK_COVER_START_DATE       NVARCHAR2(10),
'',
--RISK_COVER_END_DATE         NVARCHAR2(10),
'',
--LAST_PREMIUM_PAID_DATE      NVARCHAR2(10),
'',
--PREMIUM_AMOUNT              NVARCHAR2(17),
'',
--FREQUENCY_OF_THE_STATEMENT  NVARCHAR2(1),
'',
--ITEMS_INSURED               NVARCHAR2(80),
'',
--NOTES                       NVARCHAR2(240)
'',
--LINKAGE TYPE
'',
--COLL_STATUS
'',
--ACCOUNT TO BE LINKED
CASE WHEN MAP_ACC.FIN_ACC_NUM IS NOT NULL
THEN MAP_ACC.FIN_ACC_NUM ELSE '' END,
--DP_CONTRBTN
'',
--LIMIT PREFIX
'',
--LIMIT SUFFIX
'',
--UPLOAD_STATUS
'0',
--PRIMARYSECNDRY
'',
--SERIAL NUMBER
'',
--FORACID_COLL_VALUE
'',
--CC_FINONE_ACCNT
TRIM(HYCLR),
---FINACLE_COLLATERAL_ID
--'',
--COL_DOC_ID
--''
--ASSET_CODE
TRIM(HYCLR),
--COL_LOCATION
trim(HYCLO),
--LAST_REVIEW_DATE
CASE WHEN HYLRD<>0 AND GET_DATE_FM_BTRV(HYLRD)<> 'ERROR' THEN TO_DATE(GET_DATE_FM_BTRV(HYLRD),'YYYYMMDD') END
FROM (select DISTINCT HYCUS,HYCLC,HYCCY,HYCLR,HYCLP,HYCLV,HYSVM,HYBKV,HYNRD,HYCXD,HYCLO,HYLRD,HYNR1,HYNR2,HYNR3,HYNR4,org,lent,trn1,len_trn1,
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
from HYPF)aa)HYPF   
INNER JOIN C8PF ON C8CCY=HYCCY 
INNER JOIN MAP_CIF ON TRIM(HYCUS)=TRIM(GFCUS) AND NVL(TRIM(HYCLC),' ')=NVL(TRIM(GFCLC),' ') 
LEFT JOIN YCCLC5PF01 ON   TRIM(HYCLR)=TRIM(CCC5_CLR)
LEFT JOIN (SELECT * FROM MAP_ACC WHERE SCHM_TYPE<>'OOO')MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=LPAD(CCC5_CLC,4,0)||CCC5_CUS||LPAD(CCC5_CSEQ,3,0)
WHERE ((trim(HYCLP) in ('003','004') and SUBSTR(HYCLR,32,4) in('QUOT','UNQT','CASH')) or (trim(HYCLP) IN('022','026')))
--AND TO_NUMBER((HYPF.HYCLV)/POWER(10,C8CED)) <> 0  AND (CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') > to_date(get_param('EOD_DATE'),'dd-mm-yyyy') or HYCXD='9999999' OR TRIM(HYCXD) IS NULL)
and HYPF.HYCLV >= 0
;
COMMIT;
UPDATE COL_OTHERS_O_TABLE SET SERIAL_NUMBER='O'||(ROWNUM);
UPDATE  COL_OTHERS_O_TABLE SET REVIEW_DATE=GET_PARAM('EOD_DATE') WHERE TO_DATE(REVIEW_DATE,'DD-MM-YYYY')<TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')  or TRIM(REVIEW_DATE) is null;
COMMIT;
EXIT;
--delete COL_PORTFOLIO_DATA where trim(ACC) is null and trim(TOTAL_PORT) is null and trim(OFFICER) is null
-- select CIF_ID,sum(PFOLIO_CCY_AMT) from COL_OTHER_PORTFOLIO_O_TABLE
--  left join COL_OTHERS_O_TABLE on  COL_OTHER_PORTFOLIO_O_TABLE.SECU_SRL_NUM = COL_OTHERS_O_TABLE.SERIAL_NUMBER group by CIF_ID
--select ACC,sum(to_number(nvl(trim(AMOUNT),0))) from COL_PORTFOLIO_DATA where trim(TOTAL_PORT) =0 or trim(TOTAL_PORT) is null group by ACC
--COL_OTHER_PRTFLIO_CASH_O_TABLE 
