set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/cif/ns_retail_phone.dat
select
'LEG_CUST_BRANCH'||'|'||
'LEG_CUST_NUMBER'||'|'||
'FIN_SOL_ID'||'|'||
'FIN_CIF_ID'||'|'||
'LEG_PHONEEMAILTYPE'||'|'||
'FIN_PHONEEMAILTYPE'||'|'||
'PHONEEMAILTYPE_MATCH'||'|'||
'LEG_PHONELOC_NO'||'|'||
'FIN_PHONELOC_NO'||'|'||
'PHONE_NO_MATCH'||'|'||
'FIN_PHONENO'
from dual
union all
select  
to_char(map_cif.LEG_CUST_BRANCH)||'|'||
to_char(map_cif.LEG_CUST_NUMBER)||'|'||
to_char(map_cif.FIN_SOL_ID)||'|'||
to_char(map_cif.FIN_CIF_ID)||'|'||
to_char(cu8.PHONEEMAILTYPE)||'|'||
to_char(trim(ph.PHONEEMAILTYPE))||'|'||
case when to_char(cu8.PHONEEMAILTYPE)=trim(ph.PHONEEMAILTYPE) then 'TRUE' else 'FALSE' end||'|'||
case when cu8.PHONENOLOCALCODE='99999999' then '' else to_char(trim(cu8.PHONENOLOCALCODE)) end||'|'||
to_char(ph.PHONENOLOCALCODE)||'|'||
case when (case when cu8.PHONENOLOCALCODE='99999999' then '' else to_char(trim(cu8.PHONENOLOCALCODE)) end)=(to_char(ph.PHONENOLOCALCODE)) then 'TRUE' else 'FALSE' end||'|'||
to_char(ph.PHONENO)
from cu6_o_table cu8
inner join map_cif on trim(cu8.orgkey)=fin_cif_id
inner join (select * from gfpf where gfpf.gfctp NOT in('EC','EV','EW'))gfpf on trim(map_cif.gfclc)=trim(gfpf.gfclc) and  trim(map_cif.gfcus)=trim(gfpf.gfcus)
inner JOIN (select * from crmuser.phoneemail where bank_id=get_param('BANK_ID') and PHONEEMAILTYPE<>'REGEML' )ph ON ph.orgkey = trim(MAP_CIF.FIN_CIF_ID) and to_char(cu8.PHONEEMAILTYPE)=trim(ph.PHONEEMAILTYPE);
--select
--'LEG_BRANCH'||'|'||
--'LEG_CLIENT_NO'||'|'||
--'FINACLE_SOL_ID'||'|'||
--'FINACLE_CIF_ID'||'|'||
--'FINACLE_PHONEOREMAIL'||'|'||
--'FINACLE_PHONE_TYPE'||'|'||
--'LEG_PHONE_NO'||'|'||
--'FIN_PHONE_NO'||'|'||
--'PHONE_NO_MATCH'||'|'||
--'TYPE'
--from dual
--union all
--select
--to_char(LEG_BRANCH)||'|'||
--to_char(LEG_CLIENT_NO)||'|'||
--to_char(FINACLE_SOL_ID)||'|'|| 
--to_char(FINACLE_CIF_ID)||'|'||
--to_char(FINACLE_PHONEOREMAIL)||'|'|| 
--to_char(FINACLE_PHONE_TYPE)||'|'||   
--to_char(LEG_PHONE_NO)||'|'||         
--to_char(FIN_PHONE_NO)||'|'||         
--to_char(PHONE_NO_MATCH)||'|'||       
--to_char(TYPE)
--from rep_phone where trim(type)<>'STAFF';
exit; 
