
Truncate table Environment_Volume_O_table;
    Insert Into Environment_Volume_O_table
   Select Mock,file_name,expected_count,
   nvl(to_number(extractvalue(xmltype(dbms_xmlgen.getxml('select count(*) c from '||owner||'.'||table_name)),'/ROWSET/ROW/C')),0) as Actual_count,
   case when expected_count=to_number(extractvalue(xmltype(dbms_xmlgen.getxml('select count(*) c from '||owner||'.'||table_name)),'/ROWSET/ROW/C')) then 'Matched' else 'Not Matched'
   end Match
      from Environment_Volume_Check
    Inner join (select * from all_tables where owner = 'FRAMWORKDB') on table_name=file_name;
exit;
