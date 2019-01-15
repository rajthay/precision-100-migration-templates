-- File Name		: DUBDEALS_spool.sql
-- File Created for	: Spooling file for Account fax held.
-- Created By		: Kumaresan.B
-- Client		    : EIB
-- Created On		: 19-10-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/dubdatafiles/dubdeals.txt
SELECT
EXT_ACC||
INT_ACC||
SHORT_NAME||
DEAL_TYPE||
DEAL_REF||
CUST_TYPE||
ACC_TYPE||
OFFICER||
CCY||
START_DATE||
FIELD_13||
MATURITY_DATE||
DEAL_AMOUNT||
DEAL_AMOUNT_KWD||
INTEREST||
INTEREST_KWD||
INTEREST_RATE         
FROM DUBDEALS_OTP;
exit;
 
