set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $SPOOL_PATH/Environment_volumn_check.dat
select
'Mock' ||'|'||
'file_name' ||'|'||
'expected_count' ||'|'||
'Actual_count' ||'|'||
'Match' 
from dual
union all
 SELECT to_char(Mock) ||'|'||
to_char(file_name) ||'|'||
to_char(expected_count) ||'|'||
to_char(Actual_count) ||'|'||
to_char(Match) 
   FROM Environment_Volume_O_table;
spool off;
exit;

