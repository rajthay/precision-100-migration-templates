-- File Name		: ACCOUNT_fax_held_spool.sql
-- File Created for	: Spooling file for Account fax held.
-- Created By		: Kumaresan.B
-- Client		    : EIB
-- Created On		: 19-10-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 297
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/dubdatafiles/dubdatafd.txt
SELECT
AINTACCNO||
AEXTACCNO||
ASEQNO||
ASHRNAME||
ACBKC||
AACT||
AACL||
ACTP||
AANL||
ANATC||
ARESC||
ACCYC||
ACBAL||
AKBAL||
ANDEC||
ADSTR||
ADMAT||
ADFMAT||
ADRT||
AOFC||
AOFCE||
ACRDTE||
ACRLIM||
AACRFC||
AACRKD||
AORGAM||
AORGDT||
ADLP||
ADLR||
ALCD||
ANCD||
ACLO||
APRA||
AWLST||
AWOFF||
APRV||
ADDATE
FROM  DUBDATAFD_OTP ;
exit;
 
