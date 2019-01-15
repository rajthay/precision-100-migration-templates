========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
security_price_report.sql 
select SECURITY OPICS_SECID,NAME FIN_SECID, CASE WHEN TRIM(SECURITY) =TRIM(NAME) THEN 'TRUE' ELSE 'FALSE' END MATCH_SECID,
BID OPICS_BIC_RATE,BID_RATE FIN_BID_RATE, CASE WHEN TRIM(BID) =TRIM(BID_RATE) THEN 'TRUE' ELSE 'FALSE' END MATCH_BID_RATE,
OFFER OPICS_OFFER_RATE,OFFER_RATE FIN_OFFER_RATE, CASE WHEN TRIM(OFFER) =TRIM(OFFER_RATE) THEN 'TRUE' ELSE 'FALSE' END MATCH_OFFER_RATE,
TO_DATE(BASE_DATE,'dd-Mon-yyyy') OPICS_BASE_DATE,FIN_BASE_DATE , CASE WHEN TO_DATE(BASE_DATE,'dd-Mon-yyyy') =TRIM(FIN_BASE_DATE) THEN 'TRUE' ELSE 'FALSE' END MATCH_BASE_DATE
 from SECURITY_PRICES_O_TABLE a
left join(
select a.NAME,BID_RATE,OFFER_RATE,c.BASE_DATE FIN_BASE_DATE from SD_SEC_DEFN@ftmig a
inner join MRS_SECURITY_PRICES@ftmig b on a.FBO_ID_NUM = b.SEC_DEFN_FBO_ID_NUM
inner join MRS_NAMES@ftmig c on c.NAME = b.NAME
) b on trim(a.SECURITY) = trim(b.NAME) 
