select * from fxdh where CCYSETTDATE!= CTRSETTDATE and trim(dealno) in(select trim(deal_identifier) from FX_SPOT_DEALS_O_TABLE);

select * from fxdh where CCYSETTDATE!= CTRSETTDATE and trim(dealno) in(select trim(deal_identifier) from FX_OUTRIGHT_DEALS_O_TABLE);

select * from fxdh where CCYSETTDATE!= CTRSETTDATE and trim(dealno) in(select trim(deal_identifier) from FX_SWAP_O_TABLE);

Find POINTS deal

--Partial principle amount paid deals
select DEALNO,PRINAMT,SIDE_SIDE_1_NOTNAL_AMT_VALUE from schd
inner join COM_LOAN_O_TABLE on trim(DEAL_IDENTIFIER) = trim(dealno)
where --INTENDDTE > to_date('31-03-2017','dd-mm-yyyy')and 
abs(PRINAMT) !=SIDE_SIDE_1_NOTNAL_AMT_VALUE;


--Group limit
select distinct COUNTERPARTY_STRING,LIMIT_CCY,LIMIT_AMOUNT,EXPDATE,PRODGROUPID,crgm.*,cust.cmne,cust.sn from CPTY_CUST_GROUP_LIMIT_TBL_BCK
LEFT JOIN CRLM ON TRIM(LIMITMEMBER) = TRIM(REPLACE(trim(COUNTERPARTY_STRING),'GRP','')) AND LIMIT_NAME LIKE '%'||MTYDATE||'%'
left join crgm on trim(GRPID) =  REPLACE(trim(COUNTERPARTY_STRING),'GRP','')
left join cust on trim(cno) = trim(grpmember)
where LIMIT_NAME like '%_G_%';

drop table treasury_all_cpty;

create table treasury_all_cpty as
select trim(TREASURY_COUNTERPARTY_MNEMONIC) cmne from (
select TREASURY_COUNTERPARTY_MNEMONIC from CORP_COREINTERFACE
union 
select to_char(TREASURY_COUNTERPARTY_MNEMONIC) from RETAIL_COREINTERFACE
union 
select to_char(MNEMONIC) from TR_NOT_MIG_CPTY_CORE_O_TABLE
)

---------------------------------------------------------------------------------

select * from TREASURY_PAY_SSI_O_TABLE where trim(CPTY_NAME) not in(select * from treasury_all_cpty);

select * from CPTY_CUST_GROUP_LIMIT_O_TABLE where trim(COUNTERPARTY_STRING) not in(select * from treasury_all_cpty) and LIMIT_NAME like '%_C_01';

select * from CPTY_CUST_GROUP_LIMIT_O_TABLE where trim(COUNTERPARTY_STRING) not in(select trim(MNEMONIC) from TREASURY_GROUP_O_TABLE) and LIMIT_NAME like '%_G_01';

select * from TREASURY_PAY_SSI_O_TABLE where trim(CPTY_NAME) not in(select trim(CMNE) from cust where trim(bic) is not null);

-------------------------------------------------------------------------------

--CURRENCY PAIR
SELECT * FROM FX_OUTRIGHT_DEALS_O_TABLE WHERE MAIN_LEG_CCY_PAIR IN(SELECT OPICS_CCY_PAIR FROM TREASURY_QUOTED_CCY_PAIR);

SELECT * FROM FX_SPOT_DEALS_O_TABLE WHERE MAIN_LEG_CCY_PAIR IN(SELECT OPICS_CCY_PAIR FROM TREASURY_QUOTED_CCY_PAIR);

SELECT * FROM FX_SWAP_O_TABLE WHERE NEAR_LEG_CCY_PAIR IN(SELECT OPICS_CCY_PAIR FROM TREASURY_QUOTED_CCY_PAIR);

SELECT * FROM SPOT_POSITION_DEALS_O_TABLE WHERE MAIN_LEG_CCY_PAIR IN(SELECT OPICS_CCY_PAIR FROM TREASURY_QUOTED_CCY_PAIR);

--Custmer RISK Country
select mnemonic,GFCNAR,name,coi,ccode ,cour,uccode
 from treasury_cpty_o_table
 left join gfpf on '0'||gfclc||gfcus = mnemonic
 left join cust on trim(cmne) = trim(name) where trim(cour) != trim(uccode) 

--NOSTRO 
SELECT * FROM (
SELECT * FROM TREASURY_PAY_SSI_O_TABLE
UNION
SELECT * FROM TREASURY_REC_SSI_O_TABLE
) WHERE TRIM(NOSTRO_ID) IN(SELECT TRIM(NAME) FROM SD_NOSTRO@FTMIG WHERE ACTION!='DLT')


--FX LIMIT VALIDATION
SELECT * FROM(
select * from 
(
SELECT TRIM(LIMITMEMBER) LIMITMEMBER,CREQLIMAMT,CREQLIMAMT/10 CREQLIMAMT_FWD_10 ,'FORWARD' type FROM CRLM_MIG WHERE 
PRODGROUPID='FX DEALS' AND TRIM(MTYDATE) not in('TOT','DS') AND (TO_DATE(EXPDATE,'YYYY-MM-DD')>to_date(get_param('EOD_DATE'),'dd-mm-yyyy')  OR TRIM(EXPDATE) IS NULL) and trim(STARTDATE) is null
) a
inner join 
(
SELECT TRIM(LIMITMEMBER) LIMITMEMBER_1, CREQLIMAMT CREQLIMAMT_SPOT,'SPOT' type FROM CRLM_MIG WHERE 
PRODGROUPID='FX DEALS' AND TRIM(MTYDATE) in('TOT','DS') AND (TO_DATE(EXPDATE,'YYYY-MM-DD')>to_date(get_param('EOD_DATE'),'dd-mm-yyyy')  OR TRIM(EXPDATE) IS NULL) and trim(STARTDATE) is null
) b on a.LIMITMEMBER = b.LIMITMEMBER_1 
) WHERE CREQLIMAMT_FWD_10 != CREQLIMAMT_SPOT and CREQLIMAMT_FWD_10 <>0


--SSI counterparty check
select * from TREASURY_PAY_SSI_O_TABLE where trim(CPTY_NAME) not in(select trim(TREASURYCOUNTERPARTYMNE) from CRMUSER.COREINTERFACE where bank_id='01' and TREASURYCOUNTERPARTY='Y')

select * from TREASURY_PAY_SSI_O_TABLE where trim(CPTY_NAME) not in(select trim(TREASURYCOUNTERPARTYMNE) from CRMUSER.COREINTERFACE where bank_id='01' and TREASURYCOUNTERPARTY='Y')

--PREMOCK FINACLE TREASURY COUNT CHECK

select * from (
SELECT 'TT_COM_LOAN' table_name ,count(1) count FROM TT_COM_LOAN@FTMIG where ENTITY_FBO_ID_NUM in(select FBO_ID_NUM from sd_entity@FTMIG where NAME='ABKKWT')
union
SELECT 'TT_FXP_DEAL' table_name ,count(1) count FROM TT_FXP_DEAL@FTMIG where ENTITY_FBO_ID_NUM in(select FBO_ID_NUM from sd_entity@FTMIG where NAME='ABKKWT')
union
SELECT 'TT_SEC_BS' table_name ,count(1) count FROM TT_SEC_BS@FTMIG where ENTITY_FBO_ID_NUM in(select FBO_ID_NUM from sd_entity@FTMIG where NAME='ABKKWT')
union
SELECT 'TT_EQUITY_MF' table_name ,count(1) count FROM TT_EQUITY_MF@FTMIG where ENTITY_FBO_ID_NUM in(select FBO_ID_NUM from sd_entity@FTMIG where NAME='ABKKWT')
union
SELECT 'TT_FX_ARB' table_name ,count(1) count FROM TT_FX_ARB@FTMIG where ENTITY_FBO_ID_NUM in(select FBO_ID_NUM from sd_entity@FTMIG where NAME='ABKKWT')
union
SELECT 'TT_SWAP' table_name ,count(1) count FROM TT_SWAP@FTMIG where ENTITY_FBO_ID_NUM in(select FBO_ID_NUM from sd_entity@FTMIG where NAME='ABKKWT')
union
SELECT 'SD_CPTY_SSI' table_name ,count(1) count FROM SD_CPTY_SSI@FTMIG where ENTITY_FBO_ID_NUM in(select FBO_ID_NUM from sd_entity@FTMIG where NAME='ABKKWT')
union
SELECT 'SD_CPTY' table_name ,count(1) count FROM SD_CPTY@FTMIG where ENTITY_PERM_GROUP_FBO_ID_NUM in(SELECT FBO_ID_NUM FROM SD_ENTITY_PERM_GROUP@FTMIG where NAME in('EPG_KWT'))
union
SELECT 'SD_EQUITY_MF_DEFN' table_name ,count(1) count FROM SD_EQUITY_MF_DEFN@FTMIG  where ENTITY_PERM_GROUP_FBO_ID_NUM in(SELECT FBO_ID_NUM FROM SD_ENTITY_PERM_GROUP@FTMIG where NAME in('EPG_KWT'))
union
SELECT 'SD_SEC_DEFN' table_name ,count(1) count FROM SD_SEC_DEFN@FTMIG  where ENTITY_PERM_GROUP_FBO_ID_NUM in(SELECT FBO_ID_NUM FROM SD_ENTITY_PERM_GROUP@FTMIG where NAME in('EPG_KWT'))
)

--INVESTMENT PRICE
SELECT * FROM SECP WHERE LSTMNTDATE =TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')


select max(length(trim(NAME))) from EQUITY_DEFN_O_TABLE ;


select max(length(trim(EQUITY_MF_DEFN_NAME))) from EQUITY_MF_O_TABLE;


select max(length(trim(SECURITY)))  from EQUITY_PRICES_O_TABLE;

--check spaces in counterparty mnemonic

