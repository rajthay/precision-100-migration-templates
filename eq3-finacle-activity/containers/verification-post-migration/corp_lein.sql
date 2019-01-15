========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
corp_lein.sql 
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/corp_lein.dat
select
'LIEN_TYPE' ||'|'||
'LEG_BRANCH_ID'||'|'||
'LEG_CLIENT_NO'||'|'||
'LEG_SUFFIX'||'|'||
'LEG_ACCOUNT_TYPE'||'|'||
'FINACLE_SOL_ID'||'|'||
'FINACLE_CIF_ID'||'|'||
'LEG_CUST_TYPE'||'|'||
'FINACLE_ACC_NUM'||'|'||
'LEG_LIEN_AMT'||'|'||
'FINACLE_LIEN_AMT'||'|'||
'FINACLE_FUTURE_LIEN_AMT'||'|'||
'LIEN_AMT_MATCH'||'|'||
'LEG_CCY'||'|'||
'FINACLE_CCY'||'|'||
'CCY_MATCH'||'|'||
'LEG_START_DATE'||'|'||
'FINACLE_START_DATE'||'|'||
'START_DATE_MATCH'||'|'||
'LEG_EXP_DATE'||'|'||
'FINACLE_LIEN_EXP_DATE'||'|'||
'LEG_REQUESTED_BY_DESC' ||'|'||
'FINACLE_REQUESTED_BY_DESC' ||'|'||
'REQUESTED_BY_DESC_MATCH' ||'|'||
'LEG_LIEN_REMARK'||'|'||
'FINACLE_LIEN_REMARK'||'|'||
'LIEN_REMARK_MATCH'||'|'||
'LEG_REQUEST_DEPT' ||'|'||
'FINACLE_REQUEST_DEPT' ||'|'||
'REQUEST_DEPT_MATCH' ||'|'||
'LEG_CONTACT_NUM' ||'|'||
'FINACLE_CONTACT_NUM' ||'|'||
'CONTACT_NUM_MATCH' ||'|'||
'SCHEME_TYPE'||'|'||
'SCHEME_CODE'
from dual
union all
select
to_char('ULIEN') ||'|'||
to_char(map_acc.LEG_BRANCH_ID) ||'|'||
to_char(map_acc.LEG_SCAN) ||'|'||
to_char(map_acc.LEG_SCAS) ||'|'||
to_char(map_acc.LEG_ACCT_TYPE) ||'|'||
to_char(map_acc.FIN_SOL_ID) ||'|'||
to_char(map_acc.FIN_CIF_ID) ||'|'||
to_char(map_acc.LEG_CUST_TYPE) ||'|'||
to_char(FIN_ACC_NUM) ||'|'||
trim(to_char(lpad(to_number((juhamt)/POWER(10,C8CED)),17,' '))) ||'|'||
to_char(alt.LIEN_AMT) ||'|'||
to_char(alt.FUTURE_ULIEN_AMT) ||'|'||
to_char(case when trim((to_char(lpad(to_number((juhamt)/POWER(10,C8CED)),17,' '))))=(to_char(alt.LIEN_AMT)) then 'TRUE' else 'FALSE' end) ||'|'||
to_char(map_acc.CURRENCY) ||'|'||
to_char(gam.ACCT_CRNCY_CODE)||'|'||
to_char(case when (map_acc.CURRENCY)=(gam.ACCT_CRNCY_CODE) then 'TRUE' else 'FALSE' end)||'|'||
to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YYYY')||'|'||
to_char(alt.lien_start_date)||'|'||
case when trim((to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YY')))=trim((to_char(alt.lien_start_date))) then 'TRUE' else 'FALSE' end||'|'||
to_char(case
        when juhed = '9999999' then ''
        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end)||'|'||
to_char(alt.LIEN_EXPIRY_DATE)||'|'||
trim(to_char(lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
                 else ' ' end||
                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
                  else ' ' end,80,' ')))||'|'||
to_char(alt.REQUESTED_BY_DESC)||'|'||
to_char(case when (trim(to_char(lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
                 else ' ' end||
                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
                  else ' ' end,80,' '))))=trim((to_char(alt.REQUESTED_BY_DESC))) then 'TRUE' else 'FALSE' end)||'|'||
to_char(trim(JUHDD1))||'|'||
to_char(alt.lien_remarks)||'|'||
case when trim(to_char(trim(JUHDD1)))=trim(to_char(alt.lien_remarks)) then 'TRUE' else 'FALSE' end||'|'||                  
trim(TO_CHAR(lpad(trim(JUACO),80,' '))) ||'|'||
TO_CHAR(alt.REQUEST_DEPARTMENT)  ||'|'||
TO_CHAR(case when trim((TO_CHAR(lpad(trim(JUACO),80,' '))))=(TO_CHAR(alt.REQUEST_DEPARTMENT)) then 'TRUE' else 'FALSE' end)  ||'|'||
TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||trim(JUHDD3)||trim(JUHDD4),1,80),80,' ')
                 end) ||'|'||
TO_CHAR(alt.CONTACT_NUM)  ||'|'||
case when nvl(trim((TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||trim(JUHDD3)||trim(JUHDD4),1,80),80,' ')
                 end))),' ')=nvl(trim((TO_CHAR(alt.CONTACT_NUM))),' ') then 'TRUE' else 'FALSE' end ||'|'||
to_char(map_acc.SCHM_TYPE)||'|'||
to_char(map_acc.SCHM_CODE)
from map_acc
  inner join map_cif on map_acc.fin_cif_id=map_cif.fin_cif_id
  inner join jupf on trim(jupf.jubbn)=leg_branch_id and jupf.jubno=leg_scan and jupf.jusfx=leg_scas  
  inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas  
  inner join c8pf on c8ccy = scccy
  inner join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam on gam.foracid = map_acc.fin_acc_num
  inner JOIN crmuser.accounts b ON map_acc.fin_cif_id = b.orgkey
  INNER JOIN (select * from tbaadm.alt where bank_id=get_param('BANK_ID'))alt ON alt.acid = gam.acid AND trim(alt.lien_amt) = to_number(trim(juhamt)/POWER(10,C8CED))
  and  case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  and to_char(to_date(get_date_fm_btrv(trim(jusdte)),'YYYYMMDD'),'DD-MON-YYYY')  = TO_CHAR (alt.lien_start_date, 'DD-MON-YYYY')
  AND case when trim(JUHDD1) is not null then
            lpad(to_char(trim(JUHDD1)),50,' ')
            else lpad('Migrated Lien',50,' ')
            end = lpad(alt.lien_remarks,50,' ')
   and trim(lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
                 else ' ' end||
                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
                  else ' ' end,80,' '))=requested_by_desc  
      and trim(JUACO)=request_department 
      and nvl(trim(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||trim(JUHDD3)||trim(JUHDD4),1,80),80,' ')
                end),' ')   =nvl(CONTACT_NUM,' ')               
  where  map_acc.schm_type not in('OOO','TUA','TDA') and trim(map_cif.individual)='N';
  exit;
 
