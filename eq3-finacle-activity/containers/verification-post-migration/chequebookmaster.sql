========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
chequebookmaster.sql 
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/KW_CHEQUEBOOK.dat
drop table cbt_rep;
create table cbt_rep as
select * from tbaadm.cbt where bank_id=get_param('BANK_ID');
CREATE INDEX IDX_CBT_DATE ON CBT_REP(TO_NUMBER("BEGIN_CHQ_NUM"), CHQ_ISSU_DATE);
select 
'LEG_BRANCH_ID'||'|'||
'LEG_CLIENT_NO'||'|'||
'LEG_SUFFIX'||'|'||
'LEG_CUST_ID'||'|'||
'LEG_CURRENCY'||'|'||
'FIN_CURRENCY'||'|'||
'CURRENCY_MATCH'||'|'||
'FINACLE_ACC_NUM'||'|'||
'LEG_CUSTOMER_NAME' ||'|'||
'FINACLE_CUSTOMER_NAME' ||'|'||
'CUSTOMER_NAME_MATCH' ||'|'||
'LEG_CUST_TYPE' ||'|'||
'LEG_ACCOUNT_TYPE' ||'|'||
'ACCOUNT_STATUS' ||'|'||
'LEG_CHEQ_NUMBER'||'|'||
'FINACLE_CHEQ_NUMBER'||'|'||
'CHEQ_NUMBER_MATCH'||'|'||
'LEG_NO_CHEQ_LEAVES'||'|'||
'FINACLE_NO_CHEQ_LEAVES'||'|'||
'NO_CHEQ_LEAVES_MATCH'||'|'||
'LEG_CHEQ_ISS_DATE'||'|'||
'FINACLE_CHEQ_ISS_DATE'||'|'||
'CHEQ_ISS_DATE_MATCH'||'|'||
'LEG_CHQUE_LEAF_STATUS'||'|'||
'FINACLE_CHQUE_LEAF_STATUS' ||'|'||
'CHQUE_LEAF_STATUS_MATCH' ||'|'||
'INDIVIDUAL/CORPORATE'
from dual
union all
select
to_char(map_acc.leg_branch_id)||'|'||
to_char(map_acc.leg_scan)||'|'||
to_char(map_acc.LEG_SCAS)||'|'||
to_char(map_acc.leg_cust_id)||'|'||
to_char(map_acc.CURRENCY)||'|'||
to_char(ACCT_CRNCY_CODE)||'|'||
case when (to_char(map_acc.CURRENCY)) = (to_char(ACCT_CRNCY_CODE)) then 'TRUE' else 'FALSE' end ||'|'||
to_char(g.foracid)||'|'||
to_char(g.acct_name) ||'|'||
to_char(g.acct_name) ||'|'||
'TRUE' ||'|'||
TO_CHAR(MAP_ACC.LEG_CUST_TYPE) ||'|'||
TO_CHAR(MAP_ACC.LEG_ACCT_TYPE) ||'|'||
--CASE WHEN MAP_ACC.SCHM_TYPE ='ODA' THEN to_char(cam.ACCT_STATUS)
--WHEN  MAP_ACC.SCHM_TYPE = 'SBA' THEN TO_CHAR(SMT.ACCT_STATUS) END ||'|'||
case when to_number(BEGIN_CHEQUE_NUMBER)=0 then '1' else to_char(BEGIN_CHEQUE_NUMBER) end ||'|'||
to_char(trim(b.begin_chq_num))||'|'||
CASE WHEN trim((case when to_number(BEGIN_CHEQUE_NUMBER)=0 then '1' else to_char(BEGIN_CHEQUE_NUMBER) end )) = to_char(trim(b.begin_chq_num)) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(NUMBER_OF_CHEQUE_LEAVES)||'|'||
to_char(b.chq_num_of_lvs)||'|'||
CASE WHEN to_number(NUMBER_OF_CHEQUE_LEAVES) = to_number(b.chq_num_of_lvs) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
case when to_date(rpad(DATE_OF_ISSUE,10,' '),'DD-MM-YYYY')< to_date(get_date_fm_btrv(scoad),'YYYYMMDD')
        then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY')
        else to_char(to_date(rpad(DATE_OF_ISSUE,10,' '),'DD-MM-YYYY'),'DD-MM-YYYY') end ||'|'||
to_char(Chq_issu_date,'DD-MM-YYYY') ||'|'||
CASE WHEN (case when to_date(rpad(DATE_OF_ISSUE,10,' '),'DD-MM-YYYY')< to_date(get_date_fm_btrv(scoad),'YYYYMMDD')
        then to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY')
        else to_char(to_date(rpad(DATE_OF_ISSUE,10,' '),'DD-MM-YYYY'),'DD-MM-YYYY') end) = to_char(Chq_issu_date,'DD-MM-YYYY')  THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(CHEQUE_LEAF_STATUS)||'|'||
to_char(b.chq_lvs_stat) ||'|'||
CASE WHEN trim(to_char(CHEQUE_LEAF_STATUS)) = trim(to_char(b.chq_lvs_stat)) THEN 'TRUE' ELSE 'FALSE' END ||'|'|| 
case when individual = 'Y' then 'RETAIL' else 'CORPORATE' end
from cbs_o_table
inner join map_acc on map_acc.fin_acc_num=trim(account_number)
inner join scpf on map_acc.leg_branch_id =scab and leg_scan=scan and leg_scas=scas
INNER join map_cif on MAP_CIF.FIN_CIF_ID=MAP_ACC.FIN_CIF_ID 
INNER JOIN (select * from tbaadm.gam where bank_id=get_param('BANK_ID') and schm_type in('CAA','SBA','ODA')) g ON g.foracid = map_acc.fin_acc_num
--LEFT JOIN (select * from tbaadm.cam where bank_id=get_param('BANK_ID'))cam ON cam.acid = g.acid
--LEFT JOIN (select * from tbaadm.smt where bank_id=get_param('BANK_ID'))smt ON smt.acid = g.acid
left JOIN (select * from cbt_rep where bank_id=get_param('BANK_ID')) b ON b.acid = g.acid and to_number(cbs_o_table.BEGIN_CHEQUE_NUMBER)=to_number(b.begin_chq_num) and to_date(cbs_o_table.DATE_OF_ISSUE,'DD-MM-YYYY')=b.CHQ_ISSU_DATE
where map_acc.schm_type in('CAA','SBA','ODA');
exit;
--from cbs_o_table
--inner join map_acc on map_acc.fin_acc_num=trim(account_number)
--inner join scpf on map_acc.leg_branch_id =scab and leg_scan=scan and leg_scas=scas
--INNER join map_cif on MAP_CIF.FIN_CIF_ID=MAP_ACC.FIN_CIF_ID 
--INNER JOIN (select * from tbaadm.gam where bank_id=get_param('BANK_ID') and schm_type in('CAA','SBA','ODA')) g ON g.foracid = map_acc.fin_acc_num
----LEFT JOIN (select * from tbaadm.cam where bank_id=get_param('BANK_ID'))cam ON cam.acid = g.acid
----LEFT JOIN (select * from tbaadm.smt where bank_id=get_param('BANK_ID'))smt ON smt.acid = g.acid
--left JOIN (select * from cbt_rep where bank_id=get_param('BANK_ID')) b ON b.acid = g.acid and to_number(cbs_o_table.BEGIN_CHEQUE_NUMBER)=to_number(b.begin_chq_num) and to_date(cbs_o_table.DATE_OF_ISSUE,'DD-MM-YYYY')=b.CHQ_ISSU_DATE
--where map_acc.schm_type in('CAA','SBA','ODA');
 
