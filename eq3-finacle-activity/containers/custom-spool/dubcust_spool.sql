-- File Name		: ACCOUNT_fax_held_spool.sql
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
set trimspool off
spool $MIG_PATH/output/finacle/dubdatafiles/dubcust.txt
SELECT
  BRANCH||
  GFCUS||
  GFCPNC||
  GFCUN||
  BGDID1|| 
  BGDID2||
  BGCSNO||
  BGDTOB||
  BGGRCD||
  GFSAC||
  GFACO||
  GFCA2||
  GFCNAP||
  GFCNAL||
  GFC1R||
  GFC2R||
  GFC3R||
  GFC4R||
  GFC5R||
  GFP1R||
  GFP2R||
  GFP3R||
  GFP4R||
  GFP5R
  FROM DUBCUST;
exit;
 
