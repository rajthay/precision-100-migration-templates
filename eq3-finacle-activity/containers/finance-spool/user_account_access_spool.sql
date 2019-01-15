-- File Name		: user_account_access_spool.sql
-- File Created for	: user account access
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 18-06-2017
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 3000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/ebanking/user_account_access.txt
SELECT TRIM(DB_TS)||'~'||
       TRIM(BANK_ID)||'~'||
       TRIM(AC_BANK_ID)||'~'||
       TRIM(AC_BRANCH_ID)||'~'||
       TRIM(BAY_USER_ID)||'~'||
       TRIM(CORP_USER)||'~'||
       TRIM(DEL_FLG)||'~'||
       TRIM(ACID)||'~'||
       TRIM(AC_ACCESS_FLG)||'~'||
       TRIM(AC_INQ_ACCESS_FLG)||'~'||
       TRIM(AC_TXN_ACCESS)||'~'||
       TRIM(AC_AUTH_ACCESS)||'~'||
       TRIM(R_MOD_ID)||'~'||
       TRIM(R_MOD_TIME)||'~'||
       TRIM(R_CRE_ID)||'~'||
       TRIM(R_CRE_TIME)
  FROM USER_ACCOUNT_ACCESS_O_TABLE;
  exit;