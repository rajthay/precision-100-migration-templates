========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
yield_curve_report.sql 
select DISTINCT CONTRIBRATE OPICS_CONTRIBRATE,CCY_CALENDAR_LIST FINACLE_CCY_CALENDAR_LIST,
YC.CCY OPICS_CCY,CURV.CCY FINACLE_CCY, CURV.CCY_CALENDAR_LIST FINACLE_CCY_CALENDAR_LIST from  YCRS YC
LEFT join MRS_CURVES@FTMIG CURV on TRIM(CCY_CALENDAR_LIST) = SUBSTR(TRIM(CONTRIBRATE),1,3) AND TRIM(ID) ='LIBOR'
where BR='01'