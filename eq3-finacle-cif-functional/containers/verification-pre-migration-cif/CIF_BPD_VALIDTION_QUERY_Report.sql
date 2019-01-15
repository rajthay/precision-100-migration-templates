set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $SPOOL_PATH/CIF_BPD_VALIDTION_QUERY.dat
select
'CODE_VALUE' ||'|'||
'DESCRIPTION' ||'|'||
'MODULE' ||'|'||
'TABLE_NAME' ||'|'||
'Field_Type' ||'|'||
'categorytype'
from dual
union all
 SELECT to_char(CODE_VALUE) ||'|'||
to_char(DESCRIPTION) ||'|'||
to_char(MODULE) ||'|'||
to_char(TABLE_NAME) ||'|'||
to_char(Field_Type) ||'|'||
to_char(categorytype)
   FROM CIF_BPD_VALIDTION_QUERY;
spool off;
exit;
