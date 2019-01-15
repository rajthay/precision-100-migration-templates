set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $SPOOL_PATH/ns_retail_master.dat
select
'FINACLE_CIF_ID'||'|'||
'ENTITY_TYPE'||'|'||
'LEG_CUSTOMER_TYPE'||'|'||
'FIN_CUSTOMER_TYPE'||'|'||
'CUSTOMER_TYPE_MATCH'||'|'||
'LEG_FIRST_NAME'||'|'||
'FINACLE_FIRST_NAME'||'|'||
'FIRST_NAME_MATCH'||'|'||
'LEG_MIDDLE_NAME'||'|'||
'FINACLE_MIDDLE_NAME'||'|'||
'MIDDLE_NAME_MATCH'||'|'||
'LEG_LAST_NAME'||'|'||
'FINACLE_LAST_NAME'||'|'||
'LAST_NAME_MATCH'||'|'||
'LEG_PREFERRED_NAME'||'|'||
'FINACLE_PREFERRED_NAME'||'|'||
'PREFERRED_NAME_MATCH'||'|'||
'LEG_SHORT_NAME'||'|'||
'FIN_SHORT_NAME'||'|'||
'SHORT_NAME_MATCH'||'|'||
'LEG_CIF_DOB'||'|'||
'FINACLE_DOB'||'|'||
'DOB_MATCH'
from dual
union all
select
to_char(Cu1.ORGKEY)||'|'||
to_char(Cu1.ENTITY_TYPE)||'|'||
'INDIV'||'|'||
to_char(Cu1.CUST_TYPE_CODE)||'|'||
case when trim('INDIV') =(Cu1.CUST_TYPE_CODE) then 'TRUE' else 'FALSE' end ||'|'||
to_char(gfpf.gfcun)||'|'||
to_char(CUST_FIRST_NAME)||'|'||
case when trim(gfpf.gfcun) =(Cu1.CUST_FIRST_NAME) then 'TRUE' else 'FALSE' end ||'|'||
to_char('')||'|'||
to_char('')||'|'||
'TRUE'||'|'||
to_char(gfpf.gfcun)||'|'||
to_char(cu1.CUST_LAST_NAME)||'|'||
case when trim(gfpf.gfcun) =(Cu1.CUST_LAST_NAME) then 'TRUE' else 'FALSE' end ||'|'||
to_char(gfpf.GFCUN)||'|'||
to_char(PREFERREDNAME)||'|'||
case when trim(gfpf.gfcun) =(Cu1.PREFERREDNAME) then 'TRUE' else 'FALSE' end ||'|'||
to_char(gfpf.GFDAS)||'|'||
to_char(SHORT_NAME)||'|'||
case when trim(gfpf.GFDAS) =(Cu1.SHORT_NAME) then 'TRUE' else 'FALSE' end ||'|'||
to_char(gfpf.gfstmp)||'|'||
to_char(CUST_DOB)||'|'||
case when trim(gfpf.gfstmp) =(Cu1.CUST_DOB) then 'TRUE' else 'FALSE' end
from CU1_O_TABLE cu1
Left Join GFPF on trim(gfpf.gfcus)||trim(gfpf.gfcpnc)=cu1.ORGKEY;
spool off;
exit; 
