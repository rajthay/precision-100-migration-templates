-- File Name		: custom_pdc_spool.sql
-- File Created for	: Creation of PDC spool file
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 13-01-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 623
set page size 0
set pages 0
#set trimspool on
spool $MIG_PATH/output/finacle/custom/custom_pdc.txt
select
ACCOUNT_NUMBER||
NEXT_PDC_DATE||
PDC_TYPE||
PDC_PAYMENT_TYPE||
START_PDC_NUMBER||
NO_OF_PDCS||
PDC_LEAVES_STATUS||
PDC_AMT||
BANK_CODE||
BRANCH_CODE||
BANK_MICR_CODE||
TRANSFER_OPERATING_ACCT||
REMARKS||
PDC_FREQUENCY_TYPE||
PDC_CURRENCY_CODE||
DP_MARGIN_PERCENT||
CHARG_EVENT_ID||
PD_PRESENTATION_DATE||
FUNDING_FLAG||
ISSUER_CIF_ID||
ISSUER_NAME||
issuer_business_id||
IBAN_ACCOUN_NO||
PDC_CLEARING_FLAG_TYPE||
PDCT_FREE_TEXT1||
PDCT_FREE_TEXT2||
PDCT_FREE_TEXT3
from PDC_O_TABLE;
exit; 
