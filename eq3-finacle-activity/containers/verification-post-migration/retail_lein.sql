========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
retail_lein.sql 
select
'EXTERNAL_ACC_NO'||'|'||
'LIEN_TYPE'||'|'||
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
'EXPIRY_DATE_MATCH'||'|'||    
'LEG_REQUESTED_BY_DESC'||'|'||         
'FINACLE_REQUESTED_BY_DESC'||'|'||     
'REQUESTED_BY_DESC_MATCH'||'|'||       
'LEG_LIEN_REMARK'||'|'||               
'FINACLE_LIEN_REMARK'||'|'||           
'LIEN_REMARK_MATCH'||'|'||             
'LEG_REQUEST_DEPT'||'|'||              
'FINACLE_REQUEST_DEPT'||'|'||          
'REQUEST_DEPT_MATCH'||'|'||            
'REQUEST_DEPT_DESCRIPTION'||'|'||      
'LEG_CONTACT_NUM'||'|'||               
'FINACLE_CONTACT_NUM'||'|'||           
'CONTACT_NUM_MATCH'||'|'||             
'SCHEME_TYPE'||'|'||                   
'SCHEME_CODE'||'|'||                   
'LIEN_REASON_CODE'||'|'||              
'LIEN_REASON'
from dual
union all
select distinct 
to_char(map_acc.EXTERNAL_ACC)||'|'||
to_char(B2K_TYPE)||'|'||
to_char(map_acc.LEG_BRANCH_ID) ||'|'||
to_char(map_acc.LEG_SCAN) ||'|'||
to_char(map_acc.LEG_SCAS) ||'|'||
to_char(map_acc.LEG_ACCT_TYPE) ||'|'||
to_char(map_acc.FIN_SOL_ID) ||'|'||
to_char(map_acc.FIN_CIF_ID) ||'|'||
to_char(map_acc.LEG_CUST_TYPE) ||'|'||
to_char(FIN_ACC_NUM) ||'|'||
to_char(LIEN_AMOUNT)||'|'||
to_char(to_number(alt.LIEN_AMT )+ to_number(alt.FUTURE_ULIEN_AMT)) ||'|'||
case when to_number(LIEN_AMOUNT)=to_number(alt.LIEN_AMT )+ to_number(alt.FUTURE_ULIEN_AMT) then 'TRUE' else 'FALSE' end ||'|'||
to_char(map_acc.CURRENCY) ||'|'||
to_char(gam.ACCT_CRNCY_CODE)||'|'||
to_char(case when (map_acc.CURRENCY)=(gam.ACCT_CRNCY_CODE) then 'TRUE' else 'FALSE' end)||'|'||
to_char(lt.LIEN_START_DATE)||'|'||
to_char(alt.lien_start_date)||'|'||
case when to_date(to_char(lt.LIEN_START_DATE),'dd-mm-yyyy') = (alt.lien_start_date) then 'TRUE' else 'FALSE' end ||'|'||
to_date(to_char(lt.LIEN_EXPIRY_DATE),'dd-mm-yyyy')||'|'||
to_char(alt.LIEN_EXPIRY_DATE)||'|'||
case when to_date(to_char(lt.LIEN_EXPIRY_DATE),'dd-mm-yyyy') = (alt.LIEN_EXPIRY_DATE) then 'TRUE' else 'FALSE' end ||'|'||
to_char(lt.REQUESTED_BY_DESC)||'|'||
to_char(alt.REQUESTED_BY_DESC)||'|'||
case when trim(to_char(lt.REQUESTED_BY_DESC)) = trim(to_char(alt.REQUESTED_BY_DESC)) then 'TRUE' else 'FALSE' end ||'|'||
to_char(lt.LIEN_REMARKS)||'|'||
to_char(alt.lien_remarks) ||'|'||
case when trim(to_char(lt.LIEN_REMARKS))=trim(to_char(alt.lien_remarks)) then 'TRUE' else 'FALSE' end||'|'||
to_char(lt.REQUESTED_DEPARTMENT)||'|'||
TO_CHAR(alt.REQUEST_DEPARTMENT)||'|'||
case when trim(to_char(lt.REQUESTED_DEPARTMENT)) = trim(TO_CHAR(alt.REQUEST_DEPARTMENT)) then 'TRUE' else 'FALSE' end ||'|'||
TO_CHAR(C2RNM)||'|'||
to_char(lt.CONTACT_NUM)||'|'||
TO_CHAR(alt.CONTACT_NUM)||'|'||
case when trim(to_char(lt.CONTACT_NUM))=trim(TO_CHAR(alt.CONTACT_NUM)) then 'TRUE' else 'FALSE' end ||'|'||
to_char(map_acc.SCHM_TYPE)||'|'||
to_char(map_acc.SCHM_CODE)||'|'||
to_char(alt.LIEN_REASON_CODE)||'|'||
TO_CHAR(RCT.REF_DESC)
from (select * from lien_o_table) lt
left join map_acc on map_acc.fin_acc_num=trim(lt.account_number)
left join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam on gam.foracid =trim(lt.account_number) 
left JOIN (select * from tbaadm.alt where bank_id=get_param('BANK_ID'))alt ON alt.acid = gam.acid and to_number(lt.lien_amount)=to_number(alt.LIEN_AMT )+ to_number(alt.FUTURE_ULIEN_AMT) 
and nvl(trim(lt.CONTACT_NUM),'*')=nvl(trim(alt.CONTACT_NUM),'*') and  nvl(trim(lt.REQUESTED_BY_DESC),'*')=nvl(trim(alt.REQUESTED_BY_DESC),'*') and nvl(trim(lt.lien_remarks),'*')=nvl(trim(alt.lien_remarks),'*')
and to_date(lt.LIEN_EXPIRY_DATE,'DD-MM-YYYY')=alt.LIEN_EXPIRY_DATE
left JOIN (SELECT * FROM TBAADM.RCT WHERE BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='BF')RCT ON ALT.LIEN_REASON_CODE=RCT.REF_CODE
LEFT JOIN C2PF ON C2ACO=trim(REQUESTED_DEPARTMENT)
--drop table lien_rpt;
--commit;
--create table lien_rpt
--(
--LIEN_TYPE  NVARCHAR2(90),
--LEG_BRANCH_ID NVARCHAR2(90),
--LEG_CLIENT_NO NVARCHAR2(90),
--LEG_SUFFIX NVARCHAR2(90),
--LEG_ACCOUNT_TYPE NVARCHAR2(90),
--FINACLE_SOL_ID NVARCHAR2(90),
--FINACLE_CIF_ID NVARCHAR2(90),
--LEG_CUST_TYPE NVARCHAR2(90),
--FINACLE_ACC_NUM NVARCHAR2(90),
--LEG_LIEN_AMT NVARCHAR2(90),
--FINACLE_LIEN_AMT NVARCHAR2(90),
--LIEN_AMT_MATCH NVARCHAR2(90),
--LEG_CCY NVARCHAR2(90),
--FINACLE_CCY NVARCHAR2(90),
--CCY_MATCH NVARCHAR2(90),
--LEG_START_DATE NVARCHAR2(90),
--FINACLE_START_DATE NVARCHAR2(90),
--START_DATE_MATCH NVARCHAR2(90),
--LEG_EXP_DATE NVARCHAR2(90),
--FINACLE_LIEN_EXP_DATE NVARCHAR2(90),
--LEG_REQUESTED_BY_DESC  NVARCHAR2(90),
--FINACLE_REQUESTED_BY_DESC  NVARCHAR2(90),
--REQUESTED_BY_DESC_MATCH  NVARCHAR2(90),
--LEG_LIEN_REMARK NVARCHAR2(90),
--FINACLE_LIEN_REMARK NVARCHAR2(90),
--LIEN_REMARK_MATCH NVARCHAR2(90),
--LEG_REQUEST_DEPT  NVARCHAR2(90),
--FINACLE_REQUEST_DEPT  NVARCHAR2(90),
--REQUEST_DEPT_MATCH  NVARCHAR2(90),
--REQUEST_DEPT_DESCRIPTION NVARCHAR2(90),
--LEG_CONTACT_NUM  NVARCHAR2(90),
--FINACLE_CONTACT_NUM  NVARCHAR2(90),
--CONTACT_NUM_MATCH  NVARCHAR2(90),
--SCHEME_TYPE NVARCHAR2(90),
--SCHEME_CODE NVARCHAR2(90),
--LIEN_REASON_CODE NVARCHAR2(90),
--LIEN_REASON NVARCHAR2(90)
--);
--commit;
--insert into lien_rpt
--select
--'LIEN_TYPE' ,
--'LEG_BRANCH_ID',
--'LEG_CLIENT_NO',
--'LEG_SUFFIX',
--'LEG_ACCOUNT_TYPE',
--'FINACLE_SOL_ID',
--'FINACLE_CIF_ID',
--'LEG_CUST_TYPE',
--'FINACLE_ACC_NUM',
--'LEG_LIEN_AMT',
--'FINACLE_LIEN_AMT',
--'LIEN_AMT_MATCH',
--'LEG_CCY',
--'FINACLE_CCY',
--'CCY_MATCH',
--'LEG_START_DATE',
--'FINACLE_START_DATE',
--'START_DATE_MATCH',
--'LEG_EXP_DATE',
--'FINACLE_LIEN_EXP_DATE',
--'LEG_REQUESTED_BY_DESC' ,
--'FINACLE_REQUESTED_BY_DESC' ,
--'REQUESTED_BY_DESC_MATCH' ,
--'LEG_LIEN_REMARK',
--'FINACLE_LIEN_REMARK',
--'LIEN_REMARK_MATCH',
--'LEG_REQUEST_DEPT' ,
--'FINACLE_REQUEST_DEPT' ,
--'REQUEST_DEPT_MATCH' ,
--'REQUEST_DEPT_DESCRIPTION',
--'LEG_CONTACT_NUM' ,
--'FINACLE_CONTACT_NUM' ,
--'CONTACT_NUM_MATCH' ,
--'SCHEME_TYPE',
--'SCHEME_CODE',
--'LIEN_REASON_CODE',
--'LIEN_REASON'
--from dual;
--commit;
--insert into lien_rpt
--select
--to_char('ULIEN') ,
--to_char(map_acc.LEG_BRANCH_ID) ,
--to_char(map_acc.LEG_SCAN) ,
--to_char(map_acc.LEG_SCAS) ,
--to_char(map_acc.LEG_ACCT_TYPE) ,
--to_char(map_acc.FIN_SOL_ID) ,
--to_char(map_acc.FIN_CIF_ID) ,
--to_char(map_acc.LEG_CUST_TYPE) ,
--to_char(FIN_ACC_NUM) ,
--trim(to_char(lpad(to_number((juhamt)/POWER(10,C8CED)),17,' '))) ,
--to_char(alt.LIEN_AMT) ,
--to_char(case when trim((to_char(lpad(to_number((juhamt)/POWER(10,C8CED)),17,' '))))=(to_char(alt.LIEN_AMT)) then 'TRUE' else 'FALSE' end) ,
--to_char(map_acc.CURRENCY) ,
--to_char(gam.ACCT_CRNCY_CODE),
--to_char(case when (map_acc.CURRENCY)=(gam.ACCT_CRNCY_CODE) then 'TRUE' else 'FALSE' end),
--to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YYYY'),
--to_char(alt.lien_start_date),
--case when trim((to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YY')))=trim((to_char(alt.lien_start_date))) then 'TRUE' else 'FALSE' end,
--to_char(case
--        when juhed = '9999999' then ''
--        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end),
--to_char(alt.LIEN_EXPIRY_DATE),
--trim(to_char(lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
--                 else ' ' end||
--                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
--                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
--                  else ' ' end,80,' '))),
--to_char(alt.REQUESTED_BY_DESC),
--to_char(case when (trim(to_char(lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
--                 else ' ' end||
--                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
--                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
--                  else ' ' end,80,' '))))=trim((to_char(alt.REQUESTED_BY_DESC))) then 'TRUE' else 'FALSE' end),
--to_char(trim(JUHDD1)),
--to_char(alt.lien_remarks),
--case when trim(to_char(trim(JUHDD1)))=trim(to_char(alt.lien_remarks)) then 'TRUE' else 'FALSE' end,                  
--trim(TO_CHAR(lpad(trim(JUACO),80,' '))) ,
--TO_CHAR(alt.REQUEST_DEPARTMENT)  ,
--TO_CHAR(case when trim((TO_CHAR(lpad(trim(JUACO),80,' '))))=(TO_CHAR(alt.REQUEST_DEPARTMENT)) then 'TRUE' else 'FALSE' end)  ,
--TO_CHAR(C2RNM),
--TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
--                 then lpad(substr(trim(JUHDD2)||trim(JUHDD3)||trim(JUHDD4),1,80),80,' ')
--                 end) ,
--TO_CHAR(alt.CONTACT_NUM)  ,
--case when nvl(trim((TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
--                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
--                end))),'.')=nvl(trim((TO_CHAR(alt.CONTACT_NUM))),'.') then 'TRUE' else 'FALSE' end ,
--to_char(map_acc.SCHM_TYPE),
--to_char(map_acc.SCHM_CODE),
--to_char(alt.LIEN_REASON_CODE),
--TO_CHAR(RCT.REF_DESC)
--from map_acc
--  inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
--  inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas  
--  inner join c8pf on c8ccy = scccy
--  inner join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam on gam.foracid = map_acc.fin_acc_num
--  inner JOIN crmuser.accounts b ON map_acc.fin_cif_id = b.orgkey
--  INNER JOIN (select * from tbaadm.alt where bank_id=get_param('BANK_ID'))alt ON alt.acid = gam.acid AND trim(alt.lien_amt) = to_number(trim(juhamt)/POWER(10,C8CED)) and alt.LIEN_START_DATE=to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YYYY') and to_char(trim(JUHDD1))=alt.lien_remarks
--  and  case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
--  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  and to_char(to_date(get_date_fm_btrv(trim(jusdte)),'YYYYMMDD'),'DD-MON-YYYY')  = TO_CHAR (alt.lien_start_date, 'DD-MON-YYYY')
--  left JOIN (SELECT * FROM TBAADM.RCT WHERE BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='BF')RCT ON ALT.LIEN_REASON_CODE=RCT.REF_CODE
--  LEFT JOIN C2PF ON C2ACO=trim(JUACO)
--  where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
--  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
--  and map_acc.schm_type not in('OOO','TDA','TFS','OAB');
--  commit;
--insert into lien_rpt
--select
--to_char('ULIEN') ,
--to_char(map_acc.LEG_BRANCH_ID) ,
--to_char(map_acc.LEG_SCAN) ,
--to_char(map_acc.LEG_SCAS) ,
--to_char(map_acc.LEG_ACCT_TYPE) ,
--to_char(map_acc.FIN_SOL_ID) ,
--to_char(map_acc.FIN_CIF_ID) ,
--to_char(map_acc.LEG_CUST_TYPE) ,
--to_char(map_acc.FIN_ACC_NUM) ,
--trim(to_char(lpad(to_number((juhamt)/POWER(10,C8CED)),17,' '))) ,
--to_char(alt.LIEN_AMT) ,
--to_char(case when trim((to_char(lpad(to_number((juhamt)/POWER(10,C8CED)),17,' '))))=(to_char(alt.LIEN_AMT)) then 'TRUE' else 'FALSE' end) ,
--to_char(map_acc.CURRENCY) ,
--to_char(gam.ACCT_CRNCY_CODE),
--to_char(case when (map_acc.CURRENCY)=(gam.ACCT_CRNCY_CODE) then 'TRUE' else 'FALSE' end),
--to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YYYY'),
--to_char(alt.lien_start_date),
--case when trim((to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YY')))=trim((to_char(alt.lien_start_date))) then 'TRUE' else 'FALSE' end,
--to_char(case
--        when juhed = '9999999' then ''
--        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end),
--to_char(alt.LIEN_EXPIRY_DATE),
--trim(to_char(lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
--                 else ' ' end||
--                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
--                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
--                  else ' ' end,80,' '))),
--to_char(alt.REQUESTED_BY_DESC),
--to_char(case when (trim(to_char(lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
--                 else ' ' end||
--                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
--                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
--                  else ' ' end,80,' '))))=trim((to_char(alt.REQUESTED_BY_DESC))) then 'TRUE' else 'FALSE' end),
--to_char(trim(JUHDD1)),
--to_char(alt.lien_remarks),
--case when trim(to_char(trim(JUHDD1)))=trim(to_char(alt.lien_remarks)) then 'TRUE' else 'FALSE' end,                  
--trim(TO_CHAR(lpad(trim(JUACO),80,' '))) ,
--TO_CHAR(alt.REQUEST_DEPARTMENT)  ,
--TO_CHAR(case when trim((TO_CHAR(lpad(trim(JUACO),80,' '))))=(TO_CHAR(alt.REQUEST_DEPARTMENT)) then 'TRUE' else 'FALSE' end)  ,
--TO_CHAR(C2RNM),
--TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
--                 then lpad(substr(trim(JUHDD2)||trim(JUHDD3)||trim(JUHDD4),1,80),80,' ')
--                 end) ,
--TO_CHAR(alt.CONTACT_NUM)  ,
--case when nvl(trim((TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
--                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
--                end))),'.')=nvl(trim((TO_CHAR(alt.CONTACT_NUM))),'.') then 'TRUE' else 'FALSE' end ,
--to_char(map_acc.SCHM_TYPE),
--to_char(map_acc.SCHM_CODE),
--to_char(alt.LIEN_REASON_CODE),
--TO_CHAR(RCT.REF_DESC)  
--  from map_acc
--  inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
--  inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas
--    inner join (select * from lien_depo where LIEN_ACCOUNT in( 
--    select LIEN_ACCOUNT from lien_depo
--    group by LIEN_ACCOUNT
--    having count(*)=1))dep_lien on dep_lien.LIEN_ACCOUNT=leg_branch_id||leg_scan||leg_scas  
--  inner join c8pf on c8ccy = scccy
--  inner join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam on gam.foracid = map_acc.fin_acc_num
--  inner JOIN crmuser.accounts b ON map_acc.fin_cif_id = b.orgkey
--  INNER JOIN (select * from tbaadm.alt where bank_id=get_param('BANK_ID'))alt ON alt.acid = gam.acid AND trim(alt.lien_amt) = to_number(trim(juhamt)/POWER(10,C8CED)) and alt.LIEN_START_DATE=to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YYYY') and to_char(trim(JUHDD1))=alt.lien_remarks
--  and  case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
--  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  and to_char(to_date(get_date_fm_btrv(trim(jusdte)),'YYYYMMDD'),'DD-MON-YYYY')  = TO_CHAR (alt.lien_start_date, 'DD-MON-YYYY')
--  left JOIN (SELECT * FROM TBAADM.RCT WHERE BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='BF')RCT ON ALT.LIEN_REASON_CODE=RCT.REF_CODE
--  LEFT JOIN C2PF ON C2ACO=trim(JUACO)
--  where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
--  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
--  and map_acc.schm_type ='TDA';
--  commit;
--insert into lien_rpt  
--select
--to_char('ULIEN') ,
--to_char(map_acc.LEG_BRANCH_ID) ,
--to_char(map_acc.LEG_SCAN) ,
--to_char(map_acc.LEG_SCAS) ,
--to_char(map_acc.LEG_ACCT_TYPE) ,
--to_char(map_acc.FIN_SOL_ID) ,
--to_char(map_acc.FIN_CIF_ID) ,
--to_char(map_acc.LEG_CUST_TYPE) ,
--to_char(map_acc.FIN_ACC_NUM) ,
--to_char(to_number((DEPOSIT_AMOUNT)/POWER(10,C8CED))) ,
--to_char(alt.LIEN_AMT) ,
--to_char(case when trim((to_char(lpad(to_number((DEPOSIT_AMOUNT)/POWER(10,C8CED)),17,' '))))=(to_char(alt.LIEN_AMT)) then 'TRUE' else 'FALSE' end) ,
--to_char(map_acc.CURRENCY) ,
--to_char(gam.ACCT_CRNCY_CODE),
--to_char(case when (map_acc.CURRENCY)=(gam.ACCT_CRNCY_CODE) then 'TRUE' else 'FALSE' end),
--to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YYYY'),
--to_char(alt.lien_start_date),
--case when trim((to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YY')))=trim((to_char(alt.lien_start_date))) then 'TRUE' else 'FALSE' end,
--to_char(case
--        when juhed = '9999999' then ''
--        else lpad(to_char(to_date(get_date_fm_btrv(juhed),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end),
--to_char(alt.LIEN_EXPIRY_DATE),
--trim(to_char(lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
--                 else ' ' end||
--                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
--                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
--                  else ' ' end,80,' '))),
--to_char(alt.REQUESTED_BY_DESC),
--to_char(case when (trim(to_char(lpad(case when JUINP is not null then 'Date Hold Entered: '||to_char(to_date(get_date_fm_btrv(JUINP),'YYYYMMDD'),'DD-MM-YYYY')
--                 else ' ' end||
--                 case when JUDLM is not null and get_date_fm_btrv(JUDLM)<>'ERROR' then 
--                ' Date Last Maintained: '|| to_char(to_date(get_date_fm_btrv(JUDLM),'YYYYMMDD'),'DD-MM-YYYY')
--                  else ' ' end,80,' '))))=trim((to_char(alt.REQUESTED_BY_DESC))) then 'TRUE' else 'FALSE' end),
--to_char(trim(JUHDD1)),
--to_char(alt.lien_remarks),
--case when trim(to_char(trim(JUHDD1)))=trim(to_char(alt.lien_remarks)) then 'TRUE' else 'FALSE' end,                  
--trim(TO_CHAR(lpad(trim(JUACO),80,' '))) ,
--TO_CHAR(alt.REQUEST_DEPARTMENT)  ,
--TO_CHAR(case when trim((TO_CHAR(lpad(trim(JUACO),80,' '))))=(TO_CHAR(alt.REQUEST_DEPARTMENT)) then 'TRUE' else 'FALSE' end)  ,
--TO_CHAR(C2RNM),
--TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
--                 then lpad(substr(trim(JUHDD2)||trim(JUHDD3)||trim(JUHDD4),1,80),80,' ')
--                 end) ,
--TO_CHAR(alt.CONTACT_NUM)  ,
--case when nvl(trim((TO_CHAR(case when trim(JUHDD2) is not null or trim(JUHDD3) is not null or trim(JUHDD4) is not null 
--                 then lpad(substr(trim(JUHDD2)||' '||trim(JUHDD3)||' '||trim(JUHDD4),1,80),80,' ')
--                end))),'.')=nvl(trim((TO_CHAR(alt.CONTACT_NUM))),'.') then 'TRUE' else 'FALSE' end ,
--to_char(map_acc.SCHM_TYPE),
--to_char(map_acc.SCHM_CODE),
--to_char(alt.LIEN_REASON_CODE),
--TO_CHAR(RCT.REF_DESC) 
-- from map_acc
--inner join jupf on trim(jupf.jubbn)=leg_branch_id and trim(jupf.jubno)=leg_scan and trim(jupf.jusfx)=leg_scas  
--inner join scpf on scpf.scab=leg_branch_id and scan=leg_scan and scas=leg_scas
--inner join (select *  from lien_depo where LIEN_ACCOUNT in( 
--    select LIEN_ACCOUNT from lien_depo
--    group by LIEN_ACCOUNT ,LIEN_AMT
--    having count(*)>1 AND SUM(DEPOSIT_AMOUNT)=LIEN_AMT ))dep_lien on dep_lien.FIN_ACC_NUM=map_acc.fin_acc_num  
--  inner join c8pf on c8ccy = map_acc.currency
--  inner join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam on gam.foracid = map_acc.fin_acc_num
--  inner JOIN crmuser.accounts b ON map_acc.fin_cif_id = b.orgkey
--  INNER JOIN (select * from tbaadm.alt where bank_id=get_param('BANK_ID'))alt ON alt.acid = gam.acid AND trim(alt.lien_amt) = to_number((DEPOSIT_AMOUNT)/POWER(10,C8CED)) and alt.LIEN_START_DATE=to_char(to_date(get_date_fm_btrv(jusdte),'YYYYMMDD'),'DD-MON-YYYY') and to_char(trim(JUHDD1))=alt.lien_remarks
--  and  case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
--  else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  and to_char(to_date(get_date_fm_btrv(trim(jusdte)),'YYYYMMDD'),'DD-MON-YYYY')  = TO_CHAR (alt.lien_start_date, 'DD-MON-YYYY')
--  left JOIN (SELECT * FROM TBAADM.RCT WHERE BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='BF')RCT ON ALT.LIEN_REASON_CODE=RCT.REF_CODE
--  LEFT JOIN C2PF ON C2ACO=trim(JUACO)
--where case when  juhed = '9999999' then to_date('20990101','YYYYMMDD')
--else to_date(get_date_fm_btrv(jupf.juhed),'YYYYMMDD') end > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
--and map_acc.schm_type ='TDA';
--commit; 
--insert into lien_rpt
--select
--to_char('ULIEN') ,
--to_char(map_acc.LEG_BRANCH_ID) ,
--to_char(map_acc.LEG_SCAN) ,
--to_char(map_acc.LEG_SCAS) ,
--to_char(map_acc.LEG_ACCT_TYPE) ,
--to_char(map_acc.FIN_SOL_ID) ,
--to_char(map_acc.FIN_CIF_ID) ,
--to_char(map_acc.LEG_CUST_TYPE) ,
--to_char(FIN_ACC_NUM) ,
-- lpad(case when lien_rpt.FINACLE_ACC_NUM is null then  to_char(CEILING_LIMIT)
--when to_number(CEILING_LIMIT) > to_number(LEG_LIEN_AMT) then to_char(to_number(CEILING_LIMIT) - to_number(LEG_LIEN_AMT))
--end,17,' ') ,
--to_char(alt.LIEN_AMT) ,
--case when trim(lpad(case when lien_rpt.FINACLE_ACC_NUM is null then  to_char(CEILING_LIMIT)
--when to_number(CEILING_LIMIT) > to_number(LEG_LIEN_AMT) then to_char(to_number(CEILING_LIMIT) - to_number(LEG_LIEN_AMT))
--end,17,' '))=(to_char(alt.LIEN_AMT)) then 'TRUE' else 'FALSE' end ,
--to_char(map_acc.CURRENCY) ,
--to_char(gam.ACCT_CRNCY_CODE),
--to_char(case when (map_acc.CURRENCY)=(gam.ACCT_CRNCY_CODE) then 'TRUE' else 'FALSE' end),
--lpad(case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            else  rpad(' ',10,' ')
--            end,10,' '),
--to_char(alt.lien_start_date),
--case when trim(lpad(case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            else  rpad(' ',10,' ')
--            end,10,' '))=trim((to_char(alt.lien_start_date))) then 'TRUE' else 'FALSE' end,
--lpad('01-01-2099',10,' '),
--to_char(alt.LIEN_EXPIRY_DATE),
--' ',
--to_char(alt.REQUESTED_BY_DESC),
--to_char(case when trim('')=trim((to_char(alt.REQUESTED_BY_DESC))) then 'TRUE' else 'FALSE' end),
--'Deposit Lien',
--to_char(alt.lien_remarks),
--case when trim('Deposit Lien')=trim(to_char(alt.lien_remarks)) then 'TRUE' else 'FALSE' end,
--' ',
--TO_CHAR(alt.REQUEST_DEPARTMENT)  ,
--case when trim(' ')=trim(TO_CHAR(alt.REQUEST_DEPARTMENT)) then 'TRUE' else 'FALSE' end ,
--TO_CHAR(' '),
--to_char(lien_rpt.LEG_CONTACT_NUM) ,
--TO_CHAR(alt.CONTACT_NUM)  ,
--case when nvl(trim(to_char(lien_rpt.LEG_CONTACT_NUM)),'.') = nvl(trim(TO_CHAR(alt.CONTACT_NUM)),'.') then 'TRUE' else 'FALSE' end ,
--to_char(map_acc.SCHM_TYPE),
--to_char(map_acc.SCHM_CODE),
--to_char(alt.LIEN_REASON_CODE),
--TO_CHAR(RCT.REF_DESC)
--from col_dep_o_table a
--left join lien_rpt  on   trim(a.DEPOSIT_ACCOUNT_NUMBER)=trim(lien_rpt.FINACLE_ACC_NUM)
--inner join map_acc on fin_acc_num=trim(a.DEPOSIT_ACCOUNT_NUMBER)
--inner join v5pf on LEG_ACC_NUM=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
--left join (select * from otpf where ottdt='D')otpf on v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
--inner join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam on gam.foracid = map_acc.fin_acc_num
--left JOIN (select * from tbaadm.alt where bank_id=get_param('BANK_ID'))alt ON alt.acid = gam.acid and
--trim(lpad(case when lien_rpt.FINACLE_ACC_NUM is null then  to_char(CEILING_LIMIT)
--when to_number(CEILING_LIMIT) > to_number(LEG_LIEN_AMT) then to_char(to_number(CEILING_LIMIT) - to_number(LEG_LIEN_AMT))
--end,17,' '))=(to_char(alt.LIEN_AMT))
--left JOIN (SELECT * FROM TBAADM.RCT WHERE BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='BF')RCT ON ALT.LIEN_REASON_CODE=RCT.REF_CODE
--WHERE  to_number(CEILING_LIMIT) > to_number(LEG_LIEN_AMT) OR trim(lien_rpt.FINACLE_ACC_NUM) IS NULL;
--commit; 
