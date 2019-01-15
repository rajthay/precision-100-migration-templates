set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/cif/corp_master.dat
select
'LEG_BRANCH'||'|'||
'LEG_CLIENT_NO'||'|'||
'FINACLE_SOL_ID'||'|'||
'SOL_DESCRIPTION'||'|'||
'LEG_CUST_TYPE'||'|'||
'FIN_CUST_TYPE'||'|'||
'CUST_TYPE_MATCH'||'|'||
'FINACLE_CIF_ID'||'|'||
'LEG_CORPORATE_NAME'||'|'||
'FINACLE_CORPORATE_NAME'||'|'||
'CORPORATE_NAME_MATCH'||'|'||
'LEG_SHORT_NAME'||'|'||
'FINACLE_SHORT_NAME'||'|'||
'LEG_RELATIONSHIP_START_DATE'||'|'||
'FIN_RELATIONSHIP_START_DATE'||'|'||
'RELATIONSHIP_START_DATE_MATCH'||'|'||
'LEG_DATE_OF_INCORPORATION'||'|'||
'FINACLE_DATE_OF_INCORPORATION'||'|'||
'DATE_OF_INCORPORATION_MATCH'||'|'||
'LEG_CUST_STATUS'||'|'||
'FINACLE_CUST_STATUS'||'|'||
'LEG_MANAGER'||'|'||
'FINACLE_MANAGER'||'|'||
'LEG_PRIN_PLACEOPERATION'||'|'||
'FINACLE_PRIN_PLACEOPERATION'||'|'||
'PRIN_PLACEOPERATION_MATCH'||'|'||
'LEG_COUNTRYOFINCORPORATION'||'|'||
'FINACLE_COUNTRYOFINCORPORATION'||'|'||
'COUNTRYOFINCORPORATION_MATCH'||'|'||
'LEG_CBK_SECRET_NO'||'|'||
'FIN_CBK_SECRET_NO'||'|'||
'CBK_SECRET_NO_MATCH'||'|'||
'LEG_MOSAL'||'|'||
'FIN_MOSAL'||'|'||
'MOSAL_MATCH'||'|'||
'LEG_LEGALENTITY_TYPE'||'|'||
'FIN_LEGALENTITY_TYPE'||'|'||
'LEGALENTITY_TYPE_MATCH'||'|'||
'LEG_SUSPENDED'||'|'||
'FIN_SUSPENDED'||'|'||
'SUSPEND_MATCH'||'|'||
'SUSPEND_REASON'||'|'||
'LEG_SECTOR'||'|'||
'FIN_SECTOR'||'|'||
'LEG_SUB_SECTOR'||'|'||
'FIN_SUB_SECTOR'||'|'||
'LEG_DIVISION'||'|'||
'FIN_DIVISION'||'|'||
'LEG_SUB_DIVISION'||'|'||
'FIN_SUB_DIVISION'||'|'||
'LEG_SUNDRY_ANALYSIS_CODE'||'|'||
'FIN_SUNDRY_ANALYSIS_CODE'                   
from dual
union all
select
to_char(LEG_BRANCH)||'|'||
to_char(LEG_CLIENT_NO)||'|'||
to_char(FINACLE_SOL_ID)||'|'||
to_char(SOL_DESCRIPTION)||'|'||
to_char(LEG_CUST_TYPE)||'|'||
to_char(FIN_CUST_TYPE)||'|'||
to_char(CUST_TYPE_MATCH)||'|'||
to_char(FINACLE_CIF_ID)||'|'||
to_char(LEG_CORPORATE_NAME)||'|'||
to_char(FINACLE_CORPORATE_NAME)||'|'||
to_char(CORPORATE_NAME_MATCH)||'|'||
to_char(LEG_SHORT_NAME)||'|'||
to_char(FINACLE_SHORT_NAME)||'|'||
to_char(LEG_RELATIONSHIP_START_DATE)||'|'||
to_char(FIN_RELATIONSHIP_START_DATE)||'|'||
to_char(RELATIONSHIP_START_DATE_MATCH)||'|'||
to_char(LEG_DATE_OF_INCORPORATION)||'|'||
to_char(FINACLE_DATE_OF_INCORPORATION)||'|'||
to_char(DATE_OF_INCORPORATION_MATCH)||'|'||
to_char(LEG_CUST_STATUS)||'|'||
to_char(FINACLE_CUST_STATUS)||'|'||
to_char(LEG_MANAGER)||'|'||
to_char(FINACLE_MANAGER)||'|'||
to_char(LEG_PRIN_PLACEOPERATION)||'|'||
to_char(FINACLE_PRIN_PLACEOPERATION)||'|'||
to_char(PRIN_PLACEOPERATION_MATCH)||'|'||
to_char(LEG_COUNTRYOFINCORPORATION)||'|'||
to_char(FINACLE_COUNTRYOFINCORPORATION)||'|'||
to_char(COUNTRYOFINCORPORATION_MATCH)||'|'||
to_char(LEG_CBK_SECRET_NO)||'|'||
to_char(FIN_CBK_SECRET_NO)||'|'||
to_char(CBK_SECRET_NO_MATCH)||'|'||
to_char(LEG_MOSAL)||'|'||
to_char(FIN_MOSAL)||'|'||
to_char(MOSAL_MATCH)||'|'||
to_char(LEG_LEGALENTITY_TYPE)||'|'||
to_char(FIN_LEGALENTITY_TYPE)||'|'||
to_char(LEGALENTITY_TYPE_MATCH)||'|'||
to_char(LEG_SUSPENDED)||'|'||
to_char(FIN_SUSPENDED)||'|'||
to_char(SUSPEND_MATCH)||'|'||
to_char(SUSPEND_REASON)||'|'||
to_char(LEG_SECTOR)||'|'||
to_char(FIN_SECTOR)||'|'||
to_char(LEG_SUB_SECTOR)||'|'||
to_char(FIN_SUB_SECTOR)||'|'||
to_char(LEG_DIVISION)||'|'||
to_char(FIN_DIVISION)||'|'||
to_char(LEG_SUB_DIVISION)||'|'||
to_char(FIN_SUB_DIVISION)||'|'||
to_char(LEG_SUNDRY_ANALYSIS_CODE)||'|'||
to_char(FIN_SUNDRY_ANALYSIS_CODE)
from CORP_MASTER;
exit; 
