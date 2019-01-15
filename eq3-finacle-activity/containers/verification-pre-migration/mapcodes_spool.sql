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
spool $MIG_PATH/output/finacle/verificationrep/premigr/mapcodes.dat
select
'CODE_TYPE' ||'|'||
'LEG_CODE' ||'|'||
'LEG_CODE_DESC' ||'|'||
'FIN_CODE' ||'|'||
'FIN_CODE_DESC' ||'|'||
'IS_DEFAULT'
from dual
union all
select 
to_char(CODE_TYPE) ||'|'||
to_char(LEG_CODE) ||'|'||
to_char(LEG_CODE_DESC) ||'|'||
to_char(FIN_CODE) ||'|'||
to_char(FIN_CODE_DESC) ||'|'||
to_char(IS_DEFAULT)
 from map_codes;
 spool off;
 exit;
