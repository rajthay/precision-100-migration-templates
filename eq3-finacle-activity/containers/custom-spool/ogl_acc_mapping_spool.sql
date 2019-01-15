-- File Name		: Ogl Mapping
-- File Created for	: Ogl old acc to new acc Mapping
-- Created By		: Aditya Sharma
-- Client		    : ENBD
-- Created On		: 23-03-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/subsystem/Ogl_Mapping.txt
select
'Bank_Name'||'|'||
'Branch_Name'||'|'||
'Customer_Name'  ||'|'||
'Type_of_Account'||'|'||
'Old_Account_Number'||'|'||
'Currency'||'|'||
'New_Account_number'
from dual
union all
select 
distinct 'EIB' ||'|'||
c.CABRN ||'|'||
trim(GFCUN) ||'|'||
b.SCACT ||'|'||
SCAB||SCAN||SCAS ||'|'||
case when b.SCCCY='DH' then 'AED'
else b.SCCCY end ||'|'||
to_char(a.FIN_ACC_NUM)
from map_acc a
inner join scpf b on LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=SCAB||SCAN||SCAS
inner join capf c on SCAB=CABBN
inner join gfpf on gfcpnc=scan
where SCHM_TYPE in ('ODA','SBA')
union all
select 
distinct 'EIB' ||'|'||
f.CABRN ||'|'||
GFCUN ||'|'||
e.SCACT ||'|'||
SCAB||SCAN||SCAS ||'|'||
case when e.SCCCY='DH' then 'AED'
else e.SCCCY end ||'|'||
to_char(d.FIN_ACC_NUM)
from map_off_acc d
inner join scpf e on LEG_ACC_NUM=SCAB||SCAN||SCAS
inner join capf f on SCAB=CABBN
inner join gfpf on gfcpnc=scan;
spool off;
exit;
 
