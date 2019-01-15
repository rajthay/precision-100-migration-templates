
-- File Name		: DUBAV_spool.sql
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
spool $MIG_PATH/output/finacle/dubdatafiles/dubav.txt
SELECT
AVINTACCNO||
AVEXTACCNO||
AVNAME||
AVACT||
AVCCY||
AVMTDFC||
AVMTDKD||
AVYTDFC||
AVYTDKD  
FROM  DUBAV;
exit;
 
