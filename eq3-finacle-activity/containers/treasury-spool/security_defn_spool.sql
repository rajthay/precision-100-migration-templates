-- File Name		: security_defn_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 28-09-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/treasury/SECURITY_DEFN.TXT
SELECT 
'RESPONSE'||'|'||
'TEMPLATE_NAME'||'|'||
'NAME'||'|'||
'ISSUE_CCY'||'|'||
'SECURITY_TYPE'||'|'||
'TYPE'||'|'||
'TAX_FREE'||'|'||
'INSTRUMENT_CLASS_DATA_NAME'||'|'||
'YIELD_METHOD'||'|'||
'YIELD_BASIS'||'|'||
'EFFECTIVE_YIELD_METHOD'||'|'||
'EFFECTIVE_YIELD_BASIS'||'|'||
'ALT_ID1'||'|'||
'ISSUE_DATE'||'|'||
'MATURITY_DATE'||'|'||
'SIDE.$1.CASH_FLOW_SIDE_TYPE'||'|'||
'SIDE.$1.FIX_RATE'||'|'||
'SIDE.$1.REFERENCE_RATE'||'|'||
'REDEMPTION_VALUE'||'|'||
'SIDE.$1.CREATION_FREQUENCY'||'|'||
'ISSUER_STRING'||'|'||
'ACTIVE_STATUS'||'|'||
'ENTITY_PERM_GROUP'||'|'||
'MTM_VALUATION'||'|'||
'DESCRIPTION'||'|'||
'SHORT_SALES_ACTION'||'|'||
'MIN_QTY_METHOD'||'|'||
'MINIMUM_AMOUNT'||'|'||
'QTY_MULTIPLE'||'|'||
'REALIZATION_METHOD'||'|'||
'AMORTISATION_METHOD'||'|'||
'DATE_TO_REALIZE'||'|'||
'AMORT_APPLICABILITY'||'|'||
'ISSUE_PRICE'||'|'||
'ISSUANCE_FACE'||'|'||
'PRICE_METHOD'||'|'||
'PRICE_BASIS'||'|'||
'ACC_COUPON_METHOD'||'|'||
'TRADED_ACCRUED_COUPON'||'|'||
'TRADED_BASIS_CODE'||'|'||
'YIELD_COMPOUNDING_FREQUENCY'||'|'||
'PRICE_QUOTATION'||'|'||
'PRICE_ROUNDING_DIGITS'||'|'||
'YIELD_DISPLAY_PLACES'||'|'||
'SETTLEMENT_CALENDAR_SET'||'|'||
'SETTLEMENT_DAY_CONVENTION'||'|'||
'SETTLEMENT_DELAY'||'|'||
'IS_SPLITABLE'||'|'||
'IS_REPOABLE'||'|'||
'AUTO_REALIZE'||'|'||
'LAST_COUPON_AS_MM'||'|'||
'MRS_PRICE_YIELD'||'|'||
'TAXABLE'||'|'||
'WH_TAX_PERCENT'||'|'||
'CASH_FLOW.$1.WH_TAX_PERCENT'||'|'||
'SIDE.$1.WH_TAX_PERCENT'||'|'||
'IS_COUPON_BEARING'||'|'||
'INDEX_SETT_CCY'||'|'||
'INDEX_SETTLEMENT_GAP'||'|'||
'SIDE.$1.NOTIONAL_AMOUNT.CURRENCY'||'|'||
'SIDE.$1.NOTIONAL_AMOUNT.VALUE'||'|'||
'SIDE.$1.BASIS_CODE'||'|'||
'SIDE.$1.CASH_FLOW_CALENDAR_SET_NAME'||'|'||
'SIDE.$1.CASH_FLOW_DAY_CONVENTION'||'|'||
'SIDE.$1.START_DATE_DAY_CONVENTION'||'|'||
'SIDE.$1.END_DATE_DAY_CONVENTION'||'|'||
'SIDE.$1.ROUNDING_METHOD'||'|'||
'SIDE.$1.AMOUNT_ROUNDING_METHOD'||'|'||
'SIDE.$1.RELATIVE_SETTLEMENT_DELAY'||'|'||
'SETTLEMENT_DAY_CONVENTION'||'|'||
'SIDE.$1.CURVE_DATA.FX_FWD_CURVE_ID'||'|'||
'SIDE.$1.CURVE_DATA.DISC_CURVE_ID'||'|'||
'SIDE.$1.CURVE_DATA.IRR_CURVE_ID'||'|'||
'GENERATE_CASH_FLOWS_BUTTON'||'|'||
'GUARANTEED_BY'||'|'||
'SIDE.CURREC.STUB_PERIOD_TYPE'||'|'||
'SIDE.CURREC.INITIAL_STUB_END_DATE'||'|'||
'SIDE.$1.MARGIN'
FROM DUAL
UNION ALL
select
TO_CHAR(TRIM(RESPONSE)||'|'||
TRIM(TEMPLATE_NAME)||'|'||
TRIM(NAME)||'|'||
TRIM(ISSUE_CCY)||'|'||
TRIM(SECURITY_TYPE)||'|'||
TRIM(A_TYPE)||'|'||
TRIM(TAX_FREE)||'|'||
TRIM(INSTRUMENT_CLASS_DATA_NAME)||'|'||
TRIM(YIELD_METHOD)||'|'||
TRIM(YIELD_BASIS)||'|'||
TRIM(EFFECTIVE_YIELD_METHOD)||'|'||
TRIM(EFFECTIVE_YIELD_BASIS)||'|'||
TRIM(ALT_ID1)||'|'||
TRIM(ISSUE_DATE)||'|'||
TRIM(MATURITY_DATE)||'|'||
TRIM(SIDE_$1_CASH_FLOW_SIDE_TYPE)||'|'||
TRIM(SIDE_$1_FIX_RATE)||'|'||
TRIM(SIDE_$1_REFERENCE_RATE)||'|'||
TRIM(REDEMPTION_VALUE)||'|'||
TRIM(SIDE_$1_CREATION_FREQUENCY)||'|'||
TRIM(ISSUER_STRING)||'|'||
TRIM(ACTIVE_STATUS)||'|'||
TRIM(ENTITY_PERM_GROUP)||'|'||
TRIM(MTM_VALUATION)||'|'||
TRIM(DESCRIPTION)||'|'||
TRIM(SHORT_SALES_ACTION)||'|'||
TRIM(MIN_QTY_METHOD)||'|'||
TRIM(MINIMUM_AMOUNT)||'|'||
TRIM(QTY_MULTIPLE)||'|'||
TRIM(REALIZATION_METHOD)||'|'||
TRIM(AMORTISATION_METHOD)||'|'||
TRIM(DATE_TO_REALIZE)||'|'||
TRIM(AMORT_APPLICABILITY)||'|'||
TRIM(ISSUE_PRICE)||'|'||
TRIM(ISSUANCE_FACE)||'|'||
TRIM(PRICE_METHOD)||'|'||
TRIM(PRICE_BASIS)||'|'||
TRIM(ACC_COUPON_METHOD)||'|'||
TRIM(TRADED_ACCRUED_COUPON)||'|'||
TRIM(TRADED_BASIS_CODE)||'|'||
TRIM(YIELD_COMPOUNDING_FREQUENCY)||'|'||
TRIM(PRICE_QUOTATION)||'|'||
TRIM(PRICE_ROUNDING_DIGITS)||'|'||
TRIM(YIELD_DISPLAY_PLACES)||'|'||
TRIM(SETTLEMENT_CALENDAR_SET)||'|'||
TRIM(SETTLEMENT_DAY_CONVENTION)||'|'||
TRIM(SETTLEMENT_DELAY)||'|'||
TRIM(IS_SPLITABLE)||'|'||
TRIM(IS_REPOABLE)||'|'||
TRIM(AUTO_REALIZE)||'|'||
TRIM(LAST_COUPON_AS_MM)||'|'||
TRIM(MRS_PRICE_YIELD)||'|'||
TRIM(TAXABLE)||'|'||
TRIM(WH_TAX_PERCENT)||'|'||
TRIM(CASH_FLOW_$1_WH_TAX_PERCENT)||'|'||
TRIM(SIDE_$1_WH_TAX_PERCENT)||'|'||
TRIM(IS_COUPON_BEARING)||'|'||
TRIM(INDEX_SETT_CCY)||'|'||
TRIM(INDEX_SETTLEMENT_GAP)||'|'||
TRIM(SIDE_NOTIONAL_AMOUNT_CURRENCY)||'|'||
TRIM(SIDE_$1_NOTIONAL_AMOUNT_VALUE)||'|'||
TRIM(SIDE_$1_BASIS_CODE)||'|'||
TRIM(SIDE_CASH_FLOW_CALDAR_SET_NAME)||'|'||
TRIM(SIDE_CASH_FLOW_DAY_CONVENTION)||'|'||
TRIM(SIDE_START_DATE_DAY_CONVENTION)||'|'||
TRIM(SIDE_END_DATE_DAY_CONVENTION)||'|'||
TRIM(SIDE_$1_ROUNDING_METHOD)||'|'||
TRIM(SIDE_$1_AMOUNT_ROUNDING_METHOD)||'|'||
TRIM(SIDE_RELATIVE_SETTLEMENT_DELAY)||'|'||
TRIM(SETTLEMENT_DAY_CONVENTION_1)||'|'||
TRIM(SIDE_CRV_DATA_FX_FWD_CURVE_ID)||'|'||
TRIM(SIDE_CURVE_DATA_DISC_CURVE_ID)||'|'||
TRIM(SIDE_CURVE_DATA_IRR_CURVE_ID)||'|'||
TRIM(GENERATE_CASH_FLOWS_BUTTON)||'|'||
TRIM(GUARANTEED_BY)||'|'||
TRIM(STUB_PERIOD_TYPE)||'|'||
TRIM(INITIAL_STUB_END_DATE)||'|'||
trim(margin)
)
from SECURITY_DEFN_O_TABLE;
exit; 