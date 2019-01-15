set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $SPOOL_PATH/Environment_setup_details_pre.dat
select
'OBJECT_TYPE'||'|'||
'OBJECT_NAME'
from dual
union all
 SELECT OBJECT_TYPE ||'|'||
  OBJECT_NAME
  FROM USER_OBJECTS;
spool off;
exit;

