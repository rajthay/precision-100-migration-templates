-- File Name		: spool memopad
-- File Created for	: Spool file of memopad
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 26-05-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/core/KW/CORE010.txt
select 
MEMO_PAD_TITLE||
FUNCTION_CODE||
INTENT||
SECURITY||
TEXT_MESSAGE||
ACCOUNT_NO||
TRANSACTION_ID||
TRANSACTION_DATE||
TRX_SERIAL_NO||
CIF_ID||
STANDING_ORDER_SERIAL_NO||
INSTRUMENT_TYPE||
INSTRUMENT_ID||
EMPLOYEE_ID||
SIGNATORY||
INVENTORY_CLASS||
INVENTORY_TYPE||
INVENTORY_SERIAL_NO||
INVENTORY_LOCATION_CLASS||
INVENTORY_LOCATION_CODE||
KEY_WORD||
AUDIT_REF_NO||
SOL_ID||
TEXT_MESSAGE_IN_THE_ALT_LANG||
MEMO_PAD_TITLE_IN_ALT_LANG
from MEMOPAD_O_TABLE;
exit;
 
