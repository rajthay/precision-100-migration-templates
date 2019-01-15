-- File Name           : COL_tradable_upload.sql
-- File Created for    : Upload file for Collateral for Tradable Securities
-- Created By          : Revathi
-- Client              : ENBD
-- Created On          : 26-11-2015
-------------------------------------------------------------------
truncate table COL_MUTUAL_FUND_O_TABLE;
insert into COL_MUTUAL_FUND_O_TABLE
select distinct
-- COL_TYPE                 NVARCHAR2(1),
'U',
--  COL_CODE                 NVARCHAR2(8),
FIN_COL_CODE,
--  CEILING_LIMIT            NVARCHAR2(17),
'9999999999999',
--  COL_CLASS                NVARCHAR2(5),
'',
--  COL_GROUP                NVARCHAR2(5),
'',
--  MARGIN                   NVARCHAR2(16),
'0',
--  LTV_PCNT                 NVARCHAR2(16),
HYSVM,
--  DR_ACC_FOR_FEES          NVARCHAR2(11),
'',
--  LAST_VALUATION_DT        NVARCHAR2(10),
'',
--  FROM_DISTINCTIVE_NO      NVARCHAR2(7),
'1',
--  TO_DISTINCTIVE_NO        NVARCHAR2(7),
HYNOU,
--  NO_OF_UNITS              NVARCHAR2(12),
HYNOU,
--  UNIT_VALUE               NVARCHAR2(17),
to_number((hypf.HYUNP)/power(10,c8ced)),
--  TOTAL_COLLATERAL_VALUE   NVARCHAR2(17),
--CASE WHEN HYPF.HYCLV=0 THEN 0.001 ELSE TO_NUMBER((HYPF.HYCLV)/POWER(10,C8CED)) END ,
TO_NUMBER((HYPF.HYCLV)/POWER(10,C8CED)),
--  NOTES                    NVARCHAR2(240),
TRIM(REPLACE(REPLACE(TRIM(TRIM(HYNR1)||' '||TRIM(HYNR2)||' '||TRIM(HYNR3)||' '||TRIM(HYNR4)||' '||
CASE WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') END ),CHR(10),' '),CHR(13),' ')),
--  CIF_ID                   NVARCHAR2(9),
map_cif.fin_cif_id,
--  REVIEW_DATE              NVARCHAR2(10),
CASE WHEN HYNRD<>0 AND GET_DATE_FM_BTRV(HYNRD)<> 'ERROR' THEN TO_CHAR(TO_DATE(GET_DATE_FM_BTRV(HYNRD),'YYYYMMDD'),'DD-MM-YYYY') 
     WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN TO_CHAR(TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY')
     ELSE ''
END,
--  DUE_DATE                 NVARCHAR2(10),
CASE WHEN HYCXD='9999999' THEN '31-12-2099'
     WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN get_param('EOD_DATE')
ELSE       
     NVL(TO_CHAR(TO_DATE(GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD'),'DD-MM-YYYY'),'31-12-2099')
END,
--  NATURE_OF_CHARGE         NVARCHAR2(5),
'006',--case when trim(HYNR4) like '%F' then '005' when trim(HYNR4) like '%S' then '007' else '999' end
--  CLIENT_ID                NVARCHAR2(20),
substr(trim(HYNR1),1,20),
--  DP_ID                    NVARCHAR2(20),
SUBSTR(TRIM(HYCLR),13),
--  HOLDING_PATTERN          NVARCHAR2(24),
trim(HYNR1),
--  WITHDRAW                 NVARCHAR2(1),
'',
--  DEL                      NVARCHAR2(1),
'',
--  REASON_CODE              NVARCHAR2(5),
'',
--  BROKER_NAME              NVARCHAR2(15),
'',
--  SENT_FOR_SALE_ON         NVARCHAR2(10),
'',
--SALES_REVIEW_DATE
'',
--SALES_DUE_DATE
'',
--  EXPECTED_MIN_PRICE       NVARCHAR2(17),
'',
--  PROCEEDS_RECEIVED_ON     NVARCHAR2(10),
'',
--  SALES_PROCEEDS_RECEIVED  NVARCHAR2(17),
'',
--  STOCK_EXCHANGE           NVARCHAR2(15),
'',
--  NOTES_1                  NVARCHAR2(100),
'',
--  NOTES_2                  NVARCHAR2(100)
'',
--COLLATERAL_STATUS
'0',
--Linkage Type
'',
--Account to be Linked
case when map_Acc.fin_Acc_num is not null
then map_acc.fin_Acc_num else '' end,
--Limit Prefix
'',
--Limit Suffix
'',
--Serial Number
'S',--||rownum
--FORACID_COLL_VALUE
'',
--CC_FINONE_ACCNT
TRIM(HYCLR),
--UPLOAD_STATUS
'0',
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
from hypf  
inner join c8pf on c8ccy=hyccy 
inner join map_cif on trim(hycus)=trim(gfcus) and nvl(trim(hyclc),' ')=nvl(trim(gfclc),' ') 
left join YCCLC5PF01 on   trim(HYCLR)=trim(CCC5_CLR)
left join COLLATERAL_MAPPING lm on lm.LEG_COL_CODE = hyclp and TICKER_CODE = substr(HYCLR,10,3) or TICKER_CODE = SUBSTR(HYCLR,32,4)
left join (select * from map_acc where schm_type<>'OOO')map_acc on leg_branch_id||leg_scan||leg_scas=lpad(CCC5_CLC,4,0)||CCC5_CUS||lpad(CCC5_CSEQ,3,0)
where hyclp in('003','004') and substr(HYCLR,10,3) in('ABG','ABK')
--and to_number((hypf.hyclv)/power(10,c8ced)) <> 0  AND (CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') > to_date(get_param('EOD_DATE'),'dd-mm-yyyy') or HYCXD='9999999' OR TRIM(HYCXD) IS NULL)
;
commit;
update COL_MUTUAL_FUND_O_TABLE set SERIAL_NUMBER='U'||rownum;
UPDATE  COL_MUTUAL_FUND_O_TABLE SET REVIEW_DATE=GET_PARAM('EOD_DATE') WHERE TO_DATE(REVIEW_DATE,'DD-MM-YYYY')<TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY') or TRIM(REVIEW_DATE) is null;
commit;
exit; 
