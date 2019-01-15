========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
equity_price_report.sql 
select SECURITY OPICS_SECID,NAME FIN_SECID, CASE WHEN TRIM(SECURITY) =TRIM(NAME) THEN 'TRUE' ELSE 'FALSE' END MATCH_SECID,
BID OPICS_TRADED_PRICE,TRADED_PRICE FIN_BID_RATE, CASE WHEN round(TRIM(BID),8) =round(TRIM(TRADED_PRICE),8) THEN 'TRUE' ELSE 'FALSE' END MATCH_TRADED_PRICE,
TO_DATE(BASE_DATE,'dd-Mon-yyyy') OPICS_BASE_DATE,FIN_BASE_DATE , CASE WHEN TO_DATE(BASE_DATE,'dd-Mon-yyyy') =TRIM(FIN_BASE_DATE) THEN 'TRUE' ELSE 'FALSE' END MATCH_BASE_DATE
 from EQUITY_PRICES_O_TABLE a
left join(
select a.NAME,TRADED_PRICE,c.BASE_DATE FIN_BASE_DATE from SD_EQUITY_MF_DEFN@ftmig a
inner join MRS_EQUITY_MF_PRICES@ftmig b on a.FBO_ID_NUM = b.EQUITY_MF_DEFN_FBO_ID_NUM
inner join MRS_NAMES@ftmig c on c.NAME = b.NAME
) b on case when trim(a.SECURITY)='MUBADALA AAYAN CO 2' then 'MUBADALA AAYAN 2' else  trim(substr(trim(a.SECURITY),1,15)) end = trim(b.NAME)


select SECURITY OPICS_SECID,NAME FIN_SECID, CASE WHEN TRIM(SECURITY) =TRIM(NAME) THEN 'TRUE' ELSE 'FALSE' END MATCH_SECID,
PRICE OPICS_TRADED_PRICE,TRADED_PRICE FIN_TRADED_PRICE, CASE WHEN round(TRIM(PRICE),8) =round(TRIM(TRADED_PRICE),8) THEN 'TRUE' ELSE 'FALSE' END MATCH_TRADED_PRICE
 from EQUITY_PRICES_O_TABLE a
left join(
select a.NAME,TRADED_PRICE,c.BASE_DATE FIN_BASE_DATE from SD_EQUITY_MF_DEFN@ftmig a
inner join MRS_EQUITY_MF_PRICES@ftmig b on a.FBO_ID_NUM = b.EQUITY_MF_DEFN_FBO_ID_NUM
inner join MRS_NAMES@ftmig c on c.NAME = b.NAME
) b on case when trim(a.SECURITY)='MUBADALA AAYAN CO 2' then 'MUBADALA AAYAN2' else  trim(substr(trim(a.SECURITY),1,15)) end = trim(b.NAME) 
