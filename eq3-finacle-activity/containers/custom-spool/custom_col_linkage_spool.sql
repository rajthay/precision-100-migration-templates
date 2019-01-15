-- File Name		: CUSTOM_COL_LINKAGE_spool.sql
-- File Created for	: Upload file for col
-- Created By		: Revathi
-- Client		    : Emirates Islamic Bank
-- Created On		: 28-12-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/custom/collinkage_new.txt
select 
trim(SECU_LINKAGE_TYPE)    ||'|'||
trim(SECU_SRL_NUM)    ||'|'||
trim(BANK_ID)    ||'|'||
trim(COLLATERAL_TYPE_VALUE)    ||'|'||
trim(ENTITY_CRE_FLG)    ||'|'||
trim(DEL_FLG)    ||'|'||
trim(FREE_FIELD1)    ||'|'||
trim(FREE_FIELD2)    ||'|'||
trim(FREE_FIELD3)    ||'|'||
trim(FREE_FIELD4)    ||'|'||
trim(HOLDER)    ||'|'||
trim(HOLDER_NAME)    ||'|'||
trim(SHARED_OTHER_CUST)    ||'|'||
trim(TYPE_PROP)    ||'|'||
trim(RESI_COMM)    ||'|'||
trim(TITLE_DEED)    ||'|'||
trim(VALUE_ON_COST_AED)    ||'|'||
trim(APPROVED_FLG)    ||'|'||
trim(VALUATION_FREQ)    ||'|'||
trim(TYPE_ASSET)    ||'|'||
trim(NOTORIZED)    ||'|'||
trim(FORCED_SALE_VALUE)    ||'|'||
trim(VALUATOR_NAME)    ||'|'||
trim(TYPE_OF_INV)    ||'|'||
trim(NO_UNITS)    ||'|'||
trim(UNIT_VALUE)    ||'|'||
trim(NAV)    ||'|'||
trim(LETTER_INS_TO_EREF)    ||'|'||
trim(HOLDER_ACCT)    ||'|'||
trim(DETAIL_ASSETS)    ||'|'||
trim(EIFB_CLIENTID)    ||'|'||
trim(COVER_RATIO)    ||'|'||
trim(TRADING_ACCOUNT)    ||'|'||
trim(CASH_AMOUNT_AED)    ||'|'||
trim(HOLDING_VALUE_AED)    ||'|'||
trim(DEVELOPER_NAME)    ||'|'||
trim(PROP_OWNER_NAME)    ||'|'||
trim(FLATPLOTNO)    ||'|'||
trim(BUILDING_NAME)    ||'|'||
trim(AREA)    ||'|'||
trim(EMIRATE)    ||'|'||
trim(TRIPARTITE_EXEC_DATE)    ||'|'||
trim(TRIPARTITE_EXPIRY_DATE)    ||'|'||
trim(TRIPARTITE_AMOUNT)    ||'|'||
trim(PROPERTY_VAL_DATE)    ||'|'||
trim(REFERENCENO)    ||'|'||
trim(TYPE_FACILITY_LETTER)    ||'|'||
trim(BENEFICARY)    ||'|'||
trim(GUARANTEE_TYPE)    ||'|'||
trim(GUARANTEE_ISSUE_DATE)    ||'|'||
trim(GURANTEE_AMT)    ||'|'||
trim(GURANTEE_AMT_AED)    ||'|'||
trim(NAME_CONTRACTOR)    ||'|'||
trim(CONTRACT_REFNO)    ||'|'||
trim(CONTRACT_DETAILS)    ||'|'||
trim(RENTAL_AMT)    ||'|'||
trim(DRAWNON_BANK)    ||'|'||
trim(ACCT_TITLE)    ||'|'||
trim(CHQNO)    ||'|'||
trim(INSURANCE_COMPANY)    ||'|'||
trim(ASSIGN_TYPE)    ||'|'||
trim(ASSIGN_AMOUNT)    ||'|'||
trim(AMOUNT_EIB)    ||'|'||
trim(PREM_RECEIPT)    ||'|'||
trim(COMPANY_NAME)    ||'|'||
trim(COMPANY_COUNTRY)    ||'|'||
trim(NOTARIZEDBY)    ||'|'||
trim(NAME_INSURER)    ||'|'||
trim(TYPE_INSURANCE)    ||'|'||
trim(PREM_PAY_FREQ)    ||'|'||
trim(NEXT_PREM_DUE)    ||'|'||
trim(TANGIBLE)    ||'|'||
trim(RM)    ||'|'||
trim(CREDIT_MANAGER)    ||'|'||
trim(MAINCLASSIFICATION)    ||'|'||
trim(SUBCLASSIFICATION)    ||'|'||
trim(COLLATERAL_STATUS)    ||'|'||
trim(DOC_DATE)    ||'|'||
trim(EXPEC_DATE)    ||'|'||
trim(APPR_DATE)    ||'|'||
trim(REC_DATE)    ||'|'||
trim(APPR_BY)    ||'|'||
trim(REMARKS)    
from CUSTOM_COL_LINKAGE_O_TABLE 
where COL_DOC_ID in ('34','35','36','37','38','39','40','41','42','43','46','47','48','49','50','51','52','53','32','33','30','31');
exit;
 
