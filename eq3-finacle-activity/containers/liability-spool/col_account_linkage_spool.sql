
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/collateral/UAE/COL_ACCOUNT_LINKAGE.txt
SELECT    RPAD (COLLATERAL_CODE, 13, ' ')
       || RPAD (APPORTIONED_VALUE, 20, ' ')
       || RPAD (FORACID, 16, ' ')
       || RPAD (MARGIN_PERCENT, 9, ' ')
       || RPAD (PRIMARY_SECONDARY, 1, ' ')
  FROM COLL_ACCOUNT_LINKAGE;
exit;
 
