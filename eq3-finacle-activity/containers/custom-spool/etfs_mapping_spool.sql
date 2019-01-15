-- File Name		: ETFS Mapping
-- File Created for	: ETFS Mapping
-- Created By		: Aditya Sharma
-- Client		    : ENBD
-- Created On		: 24-03-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/subsystem/Etfs_Mapping.txt
select
'old_cif'||'|'||
'new_cif_id'||'|'||
'Branch'  ||'|'||
'old_account_number'||'|'||
'Currency'||'|'||
'New_account_number'||'|'||
'segment_code' ||'|'||
'sub_segment'||'|'||
'Analysis_code'
from dual
union all
select 
distinct to_char(leg_cust_number) 	||'|'||
to_char(a.FIN_CIF_ID) 	||'|'||
to_char(LEG_BRANCH_ID) 	||'|'||
to_char(b.LEG_ACC_NUM) 	||'|'||
to_char(case when CURRENCY='DH' then 'AED' else CURRENCY end) 	||'|'||
to_char(b.FIN_ACC_NUM) 	||'|'||
to_char(SEGMENT) 	||'|'||
to_char(SUBSEGMENT)	||'|'||
to_char(scacd) 
from map_cif a
inner join (select * from map_acc_rep where schm_type in('SBA','ODA','TDA','TUA')) b on a.FIN_CIF_ID=b.fin_cif_id
inner join crmuser.corporate on corp_key=a.FIN_CIF_ID
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
where a.DEL_FLG<>'Y' and a.INDIVIDUAL='N' 
spool off;
exit;

 
