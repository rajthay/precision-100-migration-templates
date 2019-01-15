
-- File Name		: spool CA1
-- File Created for	: Creation of source table
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
spool $MIG_PATH/output/finacle/core/KW/CORE005.txt
select INDICATOR||ACCOUNT_NUMBER||AMOUNT||TRANSACTION_DATE||CURRENCY_CODE||SERVICE_OUTLET||DUMMY from AC_BALANCE_O_TABLE;
exit;
 
