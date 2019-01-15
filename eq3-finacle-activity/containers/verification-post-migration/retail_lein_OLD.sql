========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
retail_lein_OLD.sql 
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/KW_LIEN.dat
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
'REQUEST_DEPT_DESCRIPTION'||'|'||
'LEG_CONTACT_NUM' ||'|'||
'FINACLE_CONTACT_NUM' ||'|'||
'CONTACT_NUM_MATCH' ||'|'||
'SCHEME_TYPE'||'|'||
'SCHEME_CODE'||'|'||
'LIEN_REASON_CODE'||'|'||
'LIEN_REASON'
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
TO_CHAR(C2RNM)||'|'||
TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||trim(JUHDD3)||trim(JUHDD4),1,80),80,' ')
                 end) ||'|'||
TO_CHAR(alt.CONTACT_NUM)  ||'|'||
case when nvl(trim((TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
                end))),'.')=nvl(trim((TO_CHAR(alt.CONTACT_NUM))),'.') then 'TRUE' else 'FALSE' end ||'|'||
to_char(map_acc.SCHM_TYPE)||'|'||
to_char(map_acc.SCHM_CODE)||'|'||
to_char(alt.LIEN_REASON_CODE)||'|'||
TO_CHAR(RCT.REF_DESC)
from map_acc
  inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
  inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas  
  inner join c8pf on c8ccy = scccy
  inner join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam on gam.foracid = map_acc.fin_acc_num
  inner JOIN crmuser.accounts b ON map_acc.fin_cif_id = b.orgkey
  INNER JOIN (select * from tbaadm.alt where bank_id=get_param('BANK_ID'))alt ON alt.acid = gam.acid AND trim(alt.lien_amt) = to_number(trim(juhamt)/POWER(10,C8CED)) and alt.LIEN_START_DATE=to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YYYY') and to_char(trim(JUHDD1))=alt.lien_remarks
  and  case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  and to_char(to_date(get_date_fm_btrv(trim(jusdte)),'YYYYMMDD'),'DD-MON-YYYY')  = TO_CHAR (alt.lien_start_date, 'DD-MON-YYYY')
  left JOIN (SELECT * FROM TBAADM.RCT WHERE BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='BF')RCT ON ALT.LIEN_REASON_CODE=RCT.REF_CODE
  LEFT JOIN C2PF ON C2ACO=trim(JUACO)
  where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
  and map_acc.schm_type not in('OOO','TDA','TFS','OAB')
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
to_char(map_acc.FIN_ACC_NUM) ||'|'||
trim(to_char(lpad(to_number((juhamt)/POWER(10,C8CED)),17,' '))) ||'|'||
to_char(alt.LIEN_AMT) ||'|'||
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
TO_CHAR(C2RNM)||'|'||
TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||trim(JUHDD3)||trim(JUHDD4),1,80),80,' ')
                 end) ||'|'||
TO_CHAR(alt.CONTACT_NUM)  ||'|'||
case when nvl(trim((TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
                end))),'.')=nvl(trim((TO_CHAR(alt.CONTACT_NUM))),'.') then 'TRUE' else 'FALSE' end ||'|'||
to_char(map_acc.SCHM_TYPE)||'|'||
to_char(map_acc.SCHM_CODE)||'|'||
to_char(alt.LIEN_REASON_CODE)||'|'||
TO_CHAR(RCT.REF_DESC)  
  from map_acc
  inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
  inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas
    inner join (select * from lien_depo where LIEN_ACCOUNT in( 
    select LIEN_ACCOUNT from lien_depo
    group by LIEN_ACCOUNT
    having count(*)=1))dep_lien on dep_lien.LIEN_ACCOUNT=leg_branch_id||leg_scan||leg_scas  
  inner join c8pf on c8ccy = scccy
  inner join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam on gam.foracid = map_acc.fin_acc_num
  inner JOIN crmuser.accounts b ON map_acc.fin_cif_id = b.orgkey
  INNER JOIN (select * from tbaadm.alt where bank_id=get_param('BANK_ID'))alt ON alt.acid = gam.acid AND trim(alt.lien_amt) = to_number(trim(juhamt)/POWER(10,C8CED)) and alt.LIEN_START_DATE=to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YYYY') and to_char(trim(JUHDD1))=alt.lien_remarks
  and  case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  and to_char(to_date(get_date_fm_btrv(trim(jusdte)),'YYYYMMDD'),'DD-MON-YYYY')  = TO_CHAR (alt.lien_start_date, 'DD-MON-YYYY')
  left JOIN (SELECT * FROM TBAADM.RCT WHERE BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='BF')RCT ON ALT.LIEN_REASON_CODE=RCT.REF_CODE
  LEFT JOIN C2PF ON C2ACO=trim(JUACO)
  where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
  and map_acc.schm_type ='TDA'
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
to_char(map_acc.FIN_ACC_NUM) ||'|'||
trim(to_char(lpad(to_number((juhamt)/POWER(10,C8CED)),17,' '))) ||'|'||
to_char(alt.LIEN_AMT) ||'|'||
to_char(case when trim((to_char(lpad(to_number((DEPOSIT_AMOUNT)/POWER(10,C8CED)),17,' '))))=(to_char(alt.LIEN_AMT)) then 'TRUE' else 'FALSE' end) ||'|'||
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
TO_CHAR(C2RNM)||'|'||
TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||trim(JUHDD3)||trim(JUHDD4),1,80),80,' ')
                 end) ||'|'||
TO_CHAR(alt.CONTACT_NUM)  ||'|'||
case when nvl(trim((TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
                end))),'.')=nvl(trim((TO_CHAR(alt.CONTACT_NUM))),'.') then 'TRUE' else 'FALSE' end ||'|'||
to_char(map_acc.SCHM_TYPE)||'|'||
to_char(map_acc.SCHM_CODE)||'|'||
to_char(alt.LIEN_REASON_CODE)||'|'||
TO_CHAR(RCT.REF_DESC) 
 from map_acc
inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas
inner join (select *  from lien_depo where LIEN_ACCOUNT in( 
    select LIEN_ACCOUNT from lien_depo
    group by LIEN_ACCOUNT ,LIEN_AMT
    having count(*)>1 AND SUM(DEPOSIT_AMOUNT)=LIEN_AMT ))dep_lien on dep_lien.FIN_ACC_NUM=map_acc.fin_acc_num  
  inner join c8pf on c8ccy = map_acc.currency
  inner join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam on gam.foracid = map_acc.fin_acc_num
  inner JOIN crmuser.accounts b ON map_acc.fin_cif_id = b.orgkey
  INNER JOIN (select * from tbaadm.alt where bank_id=get_param('BANK_ID'))alt ON alt.acid = gam.acid AND trim(alt.lien_amt) = to_number((DEPOSIT_AMOUNT)/POWER(10,C8CED)) and alt.LIEN_START_DATE=to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YYYY') and to_char(trim(JUHDD1))=alt.lien_remarks
  and  case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  and to_char(to_date(get_date_fm_btrv(trim(jusdte)),'YYYYMMDD'),'DD-MON-YYYY')  = TO_CHAR (alt.lien_start_date, 'DD-MON-YYYY')
  left JOIN (SELECT * FROM TBAADM.RCT WHERE BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='BF')RCT ON ALT.LIEN_REASON_CODE=RCT.REF_CODE
  LEFT JOIN C2PF ON C2ACO=trim(JUACO)
where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
and map_acc.schm_type ='TDA'
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
to_char(LIEN_AMOUNT) ||'|'||
to_char(alt.LIEN_AMT) ||'|'||
case when trim(to_char(LIEN_AMOUNT))=(to_char(alt.LIEN_AMT)) then 'TRUE' else 'FALSE' end ||'|'||
to_char(map_acc.CURRENCY) ||'|'||
to_char(gam.ACCT_CRNCY_CODE)||'|'||
to_char(case when (map_acc.CURRENCY)=(gam.ACCT_CRNCY_CODE) then 'TRUE' else 'FALSE' end)||'|'||
to_char(to_date(lb.LIEN_START_DATE,'dd-mm-yyyy'),'DD-MON-YYYY')||'|'||
to_char(alt.lien_start_date)||'|'||
case when trim(to_char(to_date(lb.LIEN_START_DATE,'dd-mm-yyyy'),'DD-MON-YY'))=trim((to_char(alt.lien_start_date))) then 'TRUE' else 'FALSE' end||'|'||
to_char(lb.LIEN_EXPIRY_DATE)||'|'||
to_char(alt.LIEN_EXPIRY_DATE)||'|'||
to_char(lb.REQUESTED_BY_DESC)||'|'||
to_char(alt.REQUESTED_BY_DESC)||'|'||
to_char(case when trim(lb.REQUESTED_BY_DESC)=trim((to_char(alt.REQUESTED_BY_DESC))) then 'TRUE' else 'FALSE' end)||'|'||
to_char(lb.LIEN_REMARKS)||'|'||
to_char(alt.lien_remarks)||'|'||
case when trim(lb.LIEN_REMARKS)=trim(to_char(alt.lien_remarks)) then 'TRUE' else 'FALSE' end||'|'||                  
to_char(trim(REQUESTED_DEPARTMENT)) ||'|'||
TO_CHAR(alt.REQUEST_DEPARTMENT)  ||'|'||
case when trim(TO_CHAR(REQUESTED_DEPARTMENT))=(TO_CHAR(alt.REQUEST_DEPARTMENT)) then 'TRUE' else 'FALSE' end ||'|'||
TO_CHAR(C2RNM)||'|'||
to_char(lb.CONTACT_NUM) ||'|'||
TO_CHAR(alt.CONTACT_NUM)  ||'|'||
case when nvl(trim(to_char(lb.CONTACT_NUM)),'.') = nvl(trim(TO_CHAR(alt.CONTACT_NUM)),'.') then 'TRUE' else 'FALSE' end ||'|'||
to_char(map_acc.SCHM_TYPE)||'|'||
to_char(map_acc.SCHM_CODE)||'|'||
to_char(alt.LIEN_REASON_CODE)||'|'||
TO_CHAR(RCT.REF_DESC)
from map_acc
inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas  
inner join c8pf on c8ccy = scccy
inner join lien_o_table_bkp lb on trim(account_number)=trim(map_acc.fin_acc_num)
inner join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam on gam.foracid = map_acc.fin_acc_num
inner JOIN crmuser.accounts b ON map_acc.fin_cif_id = b.orgkey
left JOIN (select * from tbaadm.alt where bank_id=get_param('BANK_ID'))alt ON alt.acid = gam.acid
left JOIN (SELECT * FROM TBAADM.RCT WHERE BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='BF')RCT ON ALT.LIEN_REASON_CODE=RCT.REF_CODE
LEFT JOIN C2PF ON C2ACO=trim(REQUESTED_DEPARTMENT);
exit; 
