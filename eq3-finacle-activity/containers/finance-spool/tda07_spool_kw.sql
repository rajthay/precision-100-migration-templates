--FileName:SCU1.sql
--FileCreatedfor:spooldatatofile
--CreatedBy:Revathi
--Client:ENBD
--CreatedOn:03-23-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 1200
set page size 0
set pages 0
set trimspool on
CHARACTERSET UTF8
spool $MIG_PATH/output/finacle/tda/KW/TD007.txt
select 
SOL_ID||
TD_ACCOUNT||
FLOW_CODE||
AMOUNT_INDICATOR||
CURRENCY_CODE||
FIXED_AMOUNT||
BALANCE_INDICATOR||
EXCESS_SHORT_IND||
ACCOUNT_NUMBER||
ACCOUNT_BALANCE||
PERCENTAGE||
AMT_ROUND_OFF_TYPE||
ROUND_OFF_VALUE||
RATE_CODE||
COLLECT_CHARGES||
REPORT_CODE||
REFERENCE_NUMBER||
TRANSACTION_PARTICULARS||
TRANSACTION_REMARKS||
INTENT_CODE||
DD_PAYABLE_BKCODE||
DD_PAYABLE_BRCODE||
PAYEE_NAME||
PURCHASE_ACCT_NUMBER||
PURCHASE_NAME
from tda07_o_table;
exit;
 
