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
spool $MIG_PATH/output/finacle/verificationrep/premigr/branchmapping.dat
select
'BR_CODE' ||'|'||
'BR_NAME' ||'|'||
'LOCATION' ||'|'||
'FIN_SOL_ID' ||'|'||
'FIN_BR_CODE'
from dual
union all
select 
to_char(BR_CODE)  ||'|'||
to_char(BR_NAME)  ||'|'||
to_char(LOCATION)  ||'|'||
to_char(FIN_SOL_ID)  ||'|'||
to_char(FIN_BR_CODE) 
from map_sol;
spool off;
exit;
