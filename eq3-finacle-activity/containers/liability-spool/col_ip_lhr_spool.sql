set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/others/COL2.txt
select 
trim(COL_TYPE)   ||'|'||
trim(COL_CODE)   ||'|'||
trim(CEILING_LIMIT)   ||'|'||
trim(COL_CLASS)   ||'|'||
trim(COL_GROUP)   ||'|'||
trim(MARGIN)   ||'|'||
trim(LTV_PCNT)   ||'|'||
trim(DR_ACC_FOR_FEES)   ||'|'||
trim(LAST_VALUATION_DT)   ||'|'||
trim(REASON_CODE)   ||'|'||
trim(NATURE_OF_CHARGE)   ||'|'||
trim(THIRD_PARTY_LIEN_VALUE)   ||'|'||
trim(DERIVE_VALUE_FROM)   ||'|'||
trim(ASSESSED_VALUE)   ||'|'||
trim(INVOICE_VALUE)   ||'|'||
trim(MARKET_VALUE)   ||'|'||
trim(WRITTEN_DOWN_VALUE)   ||'|'||
trim(APPORTIONED_VALUE)   ||'|'||
trim(COLLATERAL_VALUE)   ||'|'||
trim(PROPERTY_DOCUMENT_NO)   ||'|'||
trim(LODGED_DATE)   ||'|'||
trim(REVIEW_DATE)   ||'|'||
trim(RECEIVED_DATE)   ||'|'||
trim(DUE_DATE)   ||'|'||
trim(DATE_OF_PURCHASE)   ||'|'||
trim(BUILT_AREA)   ||'|'||
trim(UNIT_OF_MEASUREMENT_1)   ||'|'||
trim(LAND_AREA)   ||'|'||
trim(UNIT_OF_MEASUREMENT_2)   ||'|'||
trim(BUILDER_NAME)   ||'|'||
trim(PROPERTY_RATING)   ||'|'||
trim(YEAR_OF_CONSTRUCTION)   ||'|'||
trim(ADDRESSLINE_1)   ||'|'||
trim(ADDRESSLINE_2)   ||'|'||
trim(CITY_CODE_1)   ||'|'||
trim(STATE_CODE_1)   ||'|'||
trim(COUNTRY_CODE_1)   ||'|'||
trim(PIN_CODE)   ||'|'||
trim(PROPERTY_OWNER)   ||'|'||
trim(LEASED)   ||'|'||
trim(LEASE_EXPIRY_DATE)   ||'|'||
trim(CIF_ID)   ||'|'||
trim(AGE_OF_BUILDING)   ||'|'||
trim(NOTES0)   ||'|'||
trim(INSPECTION_TYPE)   ||'|'||
trim(ADDRESS_LINE1)   ||'|'||
trim(ADDRESS_LINE2)   ||'|'||
trim(CITY_CODE_2)   ||'|'||
trim(STATE_CODE_2)   ||'|'||
trim(ZIP_CODE_2)   ||'|'||
trim(TELEPHONE_NUMBER)   ||'|'||
trim(DATE_OF_VISIT)   ||'|'||
trim(DUE_DATE_OF_VISIT)   ||'|'||
trim(INSPECTED_VALUE)   ||'|'||
trim(INSPECTED_EMP_ID)   ||'|'||
trim(NOTES1)   ||'|'||
trim(NOTES2)   ||'|'||
trim(DUMMY_FIELD)   ||'|'||
trim(INSURANCE_TYPE)   ||'|'||
trim(INSURER_DETAILS)   ||'|'||
trim(INSURANCE_POLICY_NUMBER)   ||'|'||
trim(INSURANCE_POLICY_AMOUNT)   ||'|'||
trim(RISK_COVER_START_DATE)   ||'|'||
trim(RISK_COVER_END_DATE)   ||'|'||
trim(LAST_PREMIUM_PAID_DATE)   ||'|'||
trim(PREMIUM_AMOUNT)   ||'|'||
trim(FREQUENCY_OF_THE_STATEMENT)   ||'|'||
trim(ITEMS_INSURED)   ||'|'||
trim(NOTES)   ||'|'||
trim(COLLATERAL_STATUS)   
from COL_IP_LHR_O_TABLE;
exit;

 
