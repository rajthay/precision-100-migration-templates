
set head off
set feedback off
set term off
set lines 300
set pagesize 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cifkw/RC006.txt
SELECT trim(ORGKEY)||'|'||
trim(PHONEEMAILTYPE)||'|'||
trim(PHONEOREMAIL)||'|'||
trim(PHONE_NO)||'|'||
trim(PHONENOLOCALCODE)||'|'||
trim(PHONENOCITYCODE)||'|'||
trim(PHONENOCOUNTRYCODE)||'|'||
trim(WORKEXTENSION)||'|'||
trim(EMAIL)||'|'||
trim(EMAILPALM)||'|'||
trim(URL)||'|'||
trim(PREFERRED_FLAG)||'|'||
trim(START_DATE)||'|'||
trim(END_DATE)||'|'||
trim(USERFIELD1)||'|'||
trim(USERFIELD2)||'|'||
trim(USERFIELD3)||'|'||
trim(DATE1)||'|'||
trim(DATE2)||'|'||
trim(DATE3)||'|'||
trim(BANK_ID)
FROM CU6_O_TABLE;
spool off;
exit;
 