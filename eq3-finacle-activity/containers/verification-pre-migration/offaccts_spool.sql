SET SERVEROUTPUT ON buffer 10000000
SET pages 0
SET VERIFY OFF
SET ECHO OFF
SET FLUSH OFF
SET EMBEDDED OFF
SET FEED OFF
SET TERM OFF
SET TRIM ON
SET HEADING OFF
SET LINES 3000
SET TIMING OFF
Set Trimspool On
spool $MIG_PATH/output/finacle/verificationrep/premigr/offaccts.dat
select 
'LEG_ACC_NUM'   ||'|'||
'FIN_ACC_NUM'   ||'|'||
'SOL_ID'   ||'|'||
'CCY'   ||'|'||
'FIN_SCHEME_CODE'   ||'|'||
'FIN_SCHEME_TYPE'   ||'|'||
'FIN_GL_SUB_HEAD'   ||'|'||
'ACCOUNT_NAME'   ||'|'||
'FIN_PLACE_HOLDER'
from dual
union all
select 
to_char(LEG_ACC_NUM)   ||'|'||
to_char(FIN_ACC_NUM)   ||'|'||
to_char(SOL_ID)   ||'|'||
to_char(CCY)   ||'|'||
to_char(FIN_SCHEME_CODE)   ||'|'||
to_char(FIN_SCHEME_TYPE)   ||'|'||
to_char(FIN_GL_SUB_HEAD)   ||'|'||
to_char(ACCOUNT_NAME)   ||'|'||
to_char(FIN_PLACE_HOLDER)
 from map_off_acc;
 spool off;
 exit;
