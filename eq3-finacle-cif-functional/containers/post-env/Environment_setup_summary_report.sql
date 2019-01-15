set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $SPOOL_PATH/Environment_setup_summary.dat
select
'OBJECT_TYPE'||'|'||
'Count'
from dual
union all
 SELECT OBJECT_TYPE ||'|'||
 count(*) 
   FROM USER_OBJECTS
    group by OBJECT_TYPE;
spool off;
exit;

