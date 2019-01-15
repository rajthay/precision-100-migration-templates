========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
stop_cheque.sql 
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/KW_STOP_CHEQUE.dat
select
--'LEG_CHEQUE_REF_NO' ||'|'||
'FINACLE_CHEQUE_REF_NO' ||'|'||
'LEG_BRANCH_ID'||'|'||
'LEG_CLIENT_NO'||'|'||
'LEG_SUFFIX'||'|'||
'LEG_CRNC_CODE'||'|'||
'FINACLE_CRNC_CODE'||'|'||
'CURRENCY_CODE_MATCH'||'|'||
'FINACLE_SOL_ID'||'|'||
'FINACLE_CIF_ID'||'|'||
'FINACLE_ACCOUNT_NUMBER'||'|'||
'LEG_CHEQUE_NUMBER'||'|'||
'FINACLE_CHEQUE_NUMBER'||'|'||
'CHEQUE_NUMBER_MATCH'||'|'||
'LEG_CHEQUE_AMOUNT'||'|'||
'FINACLE_CHEQUE_AMOUNT'||'|'||
'CHEQUE_AMOUNT_MATCH'  ||'|'||
'LEG_ACCEPTANCE_DATE'  ||'|'||
'FINACLE_ACCEPTANCE_DATE'  ||'|'||
'ACCEPTANCE_DATE_MATCH' ||'|'||
'LEG_CHEQUE_DATE'  ||'|'||
'FINACLE_CHEQUE_DATE'  ||'|'||
'CHEQUE_DATE_MATCH'||'|'||
'LEG_REASON_CODE'||'|'||
'FIN_REASON_CODE'||'|'||
'REASON_CODE_MATCH'||'|'||
'LEG_REASON'||'|'||
'FIN_REASON'
from dual
union all
select distinct
--TO_CHAR(LEG_REF_NO) ||'|'||
TO_CHAR(REF_NUM) ||'|'||
to_char(map_acc.LEG_BRANCH_ID) ||'|'||
to_char( map_acc.LEG_SCAN) ||'|'||
to_char(map_acc.LEG_SCAS) ||'|'||
to_char(rpad(map_acc.currency,3,' '))||'|'||
to_char(ACCT_CRNCY_CODE)||'|'||
case when to_char(rpad(map_acc.currency,3,' ')) = to_char(ACCT_CRNCY_CODE) then 'TRUE' else 'FALSE' end  ||'|'||
to_char(map_acc.fin_sol_id) ||'|'||
to_char(map_acc.fin_cif_id) ||'|'||
to_char(foracid) ||'|'||
to_char(lpad(START_NO,16,' '))||'|'||
to_char(begin_chq_num)||'|'||
case when to_number(spt.begin_chq_num)= to_number((lpad(START_NO,16,' '))) then 'TRUE' else 'FALSE' end   ||'|'||
to_char(trim(case when trim(AMOUNT) is not null and  trim(AMOUNT)<>0  then
            lpad(AMOUNT/power(10,c8ced),17,' ') 
            else lpad('0',17,' ') end))  ||'|'||
to_char(chq_amt)||'|'||
case when nvl(trim(case when trim(AMOUNT) is not null and  trim(AMOUNT)<>0  then
            lpad(AMOUNT/power(10,c8ced),17,' ') 
            else lpad(' ',17,' ') end),'0') = nvl(trim(chq_amt),'0') then 'TRUE' else 'FALSE' end ||'|'||
to_char(POSTDT) ||'|'||
to_char(ACPT_DATE,'DD-MON-YYYY') ||'|'||
CASE WHEN to_char(POSTDT) = to_char(ACPT_DATE,'DD-MM-YYYY')  THEN 'TRUE' ELSE 'FALSE' END ||'|'||
case when trim(rpad(' ',10,' ')) is not null then to_char(to_date(rpad(' ',10,' '),'DD-MM-YYYY'),'DD-MON-YYYY') else ' ' end  ||'|'||
to_char(CHQ_DATE,'DD-MON-YYYY') ||'|'||
CASE WHEN (case when trim(rpad(' ',10,' ')) is not null then nvl(to_char(to_date(rpad(' ',10,' '),'DD-MM-YYYY'),'DD-MON-YYYY'),' ') else ' ' end) = nvl(to_char(CHQ_DATE,'DD-MON-YYYY'),' ') THEN 'TRUE' ELSE 'FALSE' END||'|'||
to_char(FIN_STOP_PAY_REASON_CODE)||'|'||
to_char(rct.REF_CODE)||'|'||
CASE WHEN NVL(to_char(FIN_STOP_PAY_REASON_CODE),'.') = NVL(to_char(rct.REF_CODE),'.') THEN 'TRUE' ELSE 'FALSE' END||'|'||
TO_CHAR(NARRATION)||'|'||
rct.REF_DESC
from spt_temp
left join map_acc on map_acc.fin_acc_num=spt_temp.fin_acc_num
inner join c8pf on c8ccy=spt_temp.CURRENCY
left join stop_reason_code on trim(LEG_STOP_REASON_CODE)=trim(narration)
left JOIN (select * from tbaadm.gam where BANK_ID=get_param('BANK_ID'))gam  ON gam.foracid = spt_temp.fin_acc_num 
left JOIN (SELECT * FROM TBAADM.RCT WHERE BANK_ID=get_param('BANK_ID') AND REF_REC_TYPE='08')RCT ON trim(FIN_STOP_PAY_REASON_CODE)=trim(RCT.REF_CODE)
left join (select * from tbaadm.spt where BANK_ID=get_param('BANK_ID'))spt on spt.acid = gam.acid  and to_number(spt.begin_chq_num) =  to_number((START_NO));
exit; 
