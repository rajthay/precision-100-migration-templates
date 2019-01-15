========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
reference_rate_report.sql 
SELECT 
 A."Rate Code" OPICS_RATE_CODE, B.RATE_CODE FIN_RATE_CODE,CASE WHEN A."Rate Code" = B.RATE_CODE THEN 'TRUE' ELSE 'FALSE' END MATCH_RATE_CODE,
 A."Rate Currency" OPICS_RATE_CCY,B.RATE_CCY FIN_RATE_CCY,CASE WHEN A."Rate Currency" = B.RATE_CCY THEN 'TRUE' ELSE 'FALSE' END MATCH_RATE_CCY,
 TO_DATE(A."Effective Date",'DD-MON-YYYY') OPICS_EFFECTIVE_DATE, B.EFFECTIVE_DATE FIN_EFFECTIVE_DATE,CASE WHEN TO_DATE(A."Effective Date",'DD-MON-YYYY') = B.EFFECTIVE_DATE THEN 'TRUE' ELSE 'FALSE' END MATCH_EFFECTIVE_DATE,
 ROUND(A."Rate Value",8) OPICS_RATE , ROUND(B.RATE_VALUE*100,8) FIN_RATE,CASE WHEN round(A."Rate Value",8) = round(B.RATE_VALUE*100,8) THEN 'TRUE' ELSE 'FALSE' END MATCH_RATE,
 A."Rate Code"||'-'||A."Rate Currency"||'-'||TO_DATE(A."Effective Date",'DD-MON-YYYY')||'-'||ROUND(A."Rate Value",8) OPICS_DATA,
 B.RATE_CODE||'-'||B.RATE_CCY||'-'||B.EFFECTIVE_DATE||'-'||ROUND(B.RATE_VALUE*100,8) FIN_DATA,
 CASE WHEN 
 A."Rate Code"||'-'||A."Rate Currency"||'-'||TO_DATE(A."Effective Date",'DD-MON-YYYY')||'-'||ROUND(A."Rate Value",8)
 =
 B.RATE_CODE||'-'||B.RATE_CCY||'-'||B.EFFECTIVE_DATE||'-'||ROUND(B.RATE_VALUE*100,8)
 THEN 'TRUE' ELSE 'FALSE' END MATCH_DATA
 FROM REFERENCE_RATE_O_TABLE A
LEFT JOIN (
SELECT RATE_CODE,RATE_CCY,RATE_VALUE,EFFECTIVE_DATE FROM SD_REF_RATE_VALUE@FTMIG A
LEFT JOIN SD_REF_RATE@FTMIG B ON B.FBO_ID_NUM = A.REF_RATE_FBO_ID_NUM
) B ON A."Rate Code" = B.RATE_CODE AND B.RATE_CCY =A."Rate Currency" AND B.EFFECTIVE_DATE = TO_DATE(A."Effective Date",'DD-MON-YYYY') 
