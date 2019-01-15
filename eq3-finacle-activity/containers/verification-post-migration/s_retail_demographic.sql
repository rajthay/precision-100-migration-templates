set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/cif/s_retail_demographic.dat
select
'LEG_BRANCH'||'|'||
  'LEG_CUST_NUMBER'||'|'||
  'FINACLE_SOL_ID'||'|'||
  'FINACLE_CIF_ID'||'|'||
  'LEG_MARITAL_STATUS'||'|'||
  'FINACLE_MARITAL_STATUS'||'|'||
  'FINACLE_MARITAL_DESC'||'|'||
  'FINACLE_EMPLOYMENT_STATUS'       ||'|'||
  'FINACLE_EMPLOYMENT_STATUS_DESC'  ||'|'||
  'LEG_NATIONALITY'                 ||'|'||
  'FINACLE_NATIONALITY_CODE'        ||'|'||
  'NATIONALITY_MATCH'               ||'|'||
  'LEG_RESIDENT_COUNTRY'            ||'|'||
  'FIN_RESIDENT_COUNTRY'            ||'|'||
  'RESIDENT_COUNTRY_MATCH'          ||'|'||
  'LEG_MANAGER'                   ||'|'||
  'FIN_MANAGER'
from dual
union all
select distinct
TO_CHAR(map_cif.LEG_CUST_BRANCH)||'|'||
TO_CHAR(map_cif.LEG_CUST_NUMBER)||'|'||
TO_CHAR(map_cif.FIN_SOL_ID)||'|'||
TO_CHAR(map_cif.FIN_CIF_ID)||'|'||
TO_CHAR(trim(BGMART))||'|'||
to_char(B.marital_status)||'|'||
to_char(f.localetext)||'|'||
to_char(b.EMPLOYMENT_STATUS)||'|'||
to_char(emps.localetext)||'|'||
to_char(TO_CHAR(GFPF.GFCNAP))||'|'||
to_char(B.nationality_code)||'|'||
case when  trim(TO_CHAR(GFPF.GFCNAP)) = trim(B.nationality_code) then 'TRUE' ELSE 'FALSE' END||'|'||
to_char(TO_CHAR(GFPF.GFCNAP))||'|'||
to_char(b.RESIDENCECOUNTRY_CODE)||'|'||
case when  trim(TO_CHAR(GFPF.GFCNAP)) = trim(b.RESIDENCECOUNTRY_CODE) then 'TRUE' ELSE 'FALSE' END||'|'||
to_char(gfaco)||'|'||
to_char(manager)
from (select * from map_cif where individual ='Y' and IS_JOINT<>'Y')map_cif 
inner join gfpf on nvl(trim(gfpf.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf on nvl(GFPF.GFCLC,' ')=nvl(BGPF.BGCLC,' ') and GFPF.GFCUS=BGPF.BGCUS
left join (select * from crmuser.accounts where bank_id='01')crm on crm.orgkey= map_cif.fin_cif_id
left JOIN (select * from crmuser.demographic where bank_id='01') B ON map_cif.fin_cif_id = B.orgkey
LEFT JOIN (SELECT localetext,VALUE,categorytype FROM crmuser.categories a, crmuser.category_lang b WHERE a.categoryid = b.categoryid
AND categorytype = 'EMPLOYMENT_STATUS' AND a.bank_id = b.bank_id AND a.bank_id = get_param('BANK_ID')) emps ON emps.VALUE = TRIM (B.employment_status)
LEFT JOIN (SELECT localetext, VALUE, categorytype FROM crmuser.categories a, crmuser.category_lang b WHERE a.categoryid = b.categoryid
AND categorytype = 'MARITAL_STATUS' AND a.bank_id = b.bank_id AND a.bank_id =get_param('BANK_ID')) f ON f.VALUE = B.marital_status
where trim(gfctp) in ('EC','EV','NW');
exit; 
