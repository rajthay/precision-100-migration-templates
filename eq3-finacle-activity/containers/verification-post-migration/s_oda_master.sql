========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
s_oda_master.sql 
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/KW_STAFF_ODA.dat
select
'LEG_BRANCH_ID'||'|'||
'LEG_BRANCH_NAME'  ||'|'||
'FINACLE_BRANCH_NAME' ||'|'||
'LEG_CLIENTNO'||'|'||
'LEG_SUFFIX'||'|'||
'LEG_CURRENCY'||'|'||
'FINACLE_CURRENCY'||'|'||
'CURRENCY_MATCH'||'|'||
'FINACLE_SOL_ID'||'|'||
'FINACLE_CIF_ID'||'|'||
'LEG_ACC_NUMBER'||'|'||
'FINACLE_ACCOUNT_NUM'||'|'||
'LEG_CUST_TYPE' ||'|'||
'LEG_ACCOUNT_TYPE'||'|'||
'FINACLE_SCHM_CODE'||'|'||
'FINACLE_SCHM_CODE_DESC' ||'|'||
'LEG_ACCOUNT_STATUS' ||'|'||
'FINACLE_ACCOUNT_STATUS' ||'|'||
'ACCOUNT_STATUS_MATCH' ||'|'||
'LEG_SEGMENT'||'|'||
'LEG_ACCT_OPENDATE'||'|'||
'FINACLE_OPENDATE'||'|'||
'OPENDATE_MATCH'||'|'||
'LEG_LAST_TRANSACTION_DATE' ||'|'||
'FINACLE_LAST_TRANSACTION_DATE' ||'|'||
'LAST_TRANSACTION_DATE_MATCH' ||'|'||
'LEG_CREDIT_PREF_RATE'||'|'||
'FIN_CREDIT_PREF_RATE'||'|'||
'CREDIT_PREF_RATE_MATCH'||'|'||
'LEG_DEBIT_PREF_RATE'||'|'||
'FIN_DEBIT_PREF_RATE'||'|'||
'DEBIT_PREF_RATE_MATCH'||'|'||
'LEG_BASE_INTEREST_RATE'||'|'||
'FIN_BASE_INTEREST_RATE'||'|'||
'BASE_INTEREST_RATE_MATCH'||'|'||
'INT_TABLE_CODE'||'|'||
'LEG_SECTOR_CODE'||'|'||
'FINACLE_SECTOR_CODE'||'|'||
'FINACLE_SECTOR_CODE_DESC'||'|'||
'LEG_SUB_SECTOR_CODE'||'|'||
'FINACLE_SUB_SECTOR_CODE'||'|'||
'FINACLE_SUB_SECTOR_CODE_DESC'||'|'||
'FINACLE_DPD_CNT' ||'|'||
'LEG_HOLDMAIL_FLAG' ||'|'||
'LEG_UNDELSTMT_FLAG' ||'|'||
'LEG_CURRENT_BALANCE'||'|'||
'FINACLE_CURRENT_BALANCE'||'|'||
'CURRENT_BALANCE_MATCH'||'|'||
'LEG_LEGDER_BALANCE'||'|'||
'FIN_LEDGER_BALANCE'||'|'||
'LEDGER_BALANCE_MATCH'||'|'||
'MEMOPAD FLAG'||'|'||
'LEG_PAST_DUE_DATE'||'|'||
'FIN_PAST_DUE_DATE'||'|'||
'DUE_AMT'||'|'||
'C5_CODE'||'|'||
'MANAGER_CODE'||'|'||
'LEG_STATEMENT_FREQUENCY'||'|'||
'FIN_STATEMENT_FREQUENCY'||'|'||
'STATEMENT_FREQUENCY_MATCH'||'|'||
'LEG_INT_FREQ'||'|'||
'FIN_INT_FREQ'||'|'||
'INT_FREQ_MATCH'
from dual
union all
select distinct
to_char(map_acc.leg_branch_id) ||'|'||
to_char(CABRN) ||'|'||
to_char(SOL_DESC) ||'|'||
to_char(map_acc.leg_scan) ||'|'||
to_char(map_acc.leg_scas) ||'|'||
to_char(map_acc.CURRENCY) ||'|'||
to_char(gam.acct_crncy_code)||'|'||
case when map_acc.CURRENCY=gam.acct_crncy_code then 'TRUE' else 'FALSE' end  ||'|'||
to_char(gam.sol_id) ||'|'||
to_char(gam.cif_id) ||'|'||
TO_CHAR(MAP_ACC.LEG_ACC_NUM)||'|'||
to_char(gam.foracid)||'|'||
TO_CHAR(MAP_ACC.LEG_CUST_TYPE) ||'|'||
to_char(map_acc.leg_acct_type) ||'|'|| 
to_char(gam.schm_code)||'|'||
TO_CHAR(GSP.SCHM_DESC) ||'|'||
case when scai85 = 'Y' and get_param('BANK_ID')= '01' then 'D'
      when scai94 = 'Y' and get_param('BANK_ID')= '02' then 'D'
           when scai20 = 'Y' then 'I'                           
           else 'A' end ||'|'||
         TO_CHAR(CAM.ACCT_STATUS) ||'|'||
CASE WHEN (case when scai85 = 'Y' and get_param('BANK_ID')= '01' then 'D'
      when scai94 = 'Y' and get_param('BANK_ID')= '02' then 'D'
           when scai20 = 'Y' then 'I'                           
           else 'A' end) =     TO_CHAR(CAM.ACCT_STATUS) THEN 'TRUE' ELSE 'FALSE' END ||'|'|| 
to_char(itc.INT_TBL_CODE)||'|'||
case when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' and scdle<>0 and to_date(get_date_fm_btrv(scdle),'YYYYMMDD')<to_date(get_date_fm_btrv(scoad),'YYYYMMDD')
         then to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MON-YYYY')
         when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then
         to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY')
         else ' '    end ||'|'||
TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY')||'|'||
case when (case when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' and scdle<>0 and to_date(get_date_fm_btrv(scdle),'YYYYMMDD')<to_date(get_date_fm_btrv(scoad),'YYYYMMDD')
         then to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MON-YYYY')
         when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then
         to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY')
         else ' '    end)= TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY') then 'TRUE' else 'FALSE' end||'|'||
case when scdle <>0 and get_date_fm_btrv(scdle) <> 'ERROR' then
           to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY')
        else ' '
    end         ||'|'||
TO_CHAR(GAM.LAST_TRAN_DATE,'DD-MM-YYYY') ||'|'||
CASE WHEN (case when scdle <>0 and get_date_fm_btrv(scdle) <> 'ERROR' then
           to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY')
        else ' '
    end    )     = nvl(TO_CHAR(GAM.LAST_TRAN_DATE,'DD-MM-YYYY'),' ')  THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(inte.S5RATC)||'|'||
to_char(itc.CUST_CR_PREF_PCNT)||'|'||
case when nvl(to_char(trim(inte.S5RATC)),'0')=nvl(to_char(itc.CUST_CR_PREF_PCNT),' ') then 'TRUE' else 'FALSE' end ||'|'||
to_char(inte.S5RATD)||'|'||
to_char(itc.CUST_DR_PREF_PCNT)||'|'||
case when nvl(to_char(trim(inte.S5RATD)),'0') = nvl(to_char(itc.CUST_DR_PREF_PCNT),' ') then 'TRUE' else 'FALSE' end ||'|'||
to_char(inte.BASE_PCNT_DR)||'|'||
to_char(icvv.BASE_PCNT_DR)||'|'||
case when nvl(to_char(trim(inte.BASE_PCNT_DR)),'0') = nvl(to_char(icvv.BASE_PCNT_DR),' ') then 'TRUE' else 'FALSE' end ||'|'||
to_char(itc.INT_TBL_CODE) ||'|'||
to_char(gfpf.GFCA2) ||'|'||
to_char(gac.sector_code) ||'|'||
TO_CHAR(D.localetext) ||'|'||
to_char(gfpf.GFCA2)  ||'|'||
to_char(gac.sub_sector_code)||'|'||
TO_CHAR(E.localetext) ||'|'||
to_char(gac.dpd_cntr) ||'|'||
TO_CHAR(SCAI64) ||'|'||
TO_CHAR(SCAIJ1) ||'|'||    
to_char((scbal -(scsum1+scsum2))/POWER(10,C8CED)) ||'|'||
to_char(clr_bal_amt) ||'|'||
case when to_char((scbal -(scsum1+scsum2))/POWER(10,C8CED)) = to_char(clr_bal_amt) then 'TRUE' else 'FALSE' end ||'|'||
to_char((scbal - SCSUMA)/POWER(10,C8CED))||'|'|| 
to_char(clr_bal_amt + future_bal_amt)||'|'||
case when (to_char((scbal - SCSUMA)/POWER(10,C8CED))) = (to_char(clr_bal_amt + future_bal_amt)) then 'TRUE' else 'FALSE' end ||'|'||
to_char(case when mpt.entity_cre_flg='Y' then 'Y' else 'N' end)||'|'||
to_char(pass_due_dt)||'|'||
to_char(gac.PD_XFER_DATE)||'|'||
to_char(Suspence_amt)||'|'||
to_char(scc5r)||'|'||
to_char(gfaco)||'|'||
sa.PS_FREQ_TYPE||'|'||
ast.PS_FREQ_TYPE||'|'||
case when (sa.PS_FREQ_TYPE) = (ast.PS_FREQ_TYPE) then 'TRUE' else 'FALSE' end||'|'||
case  when get_param('BANK_ID')='02' and map_acc.schm_code='360'  and trim(S5IFQD) is null then  'M'
       when trim(S5IFQD) is not null then 
       lpad(MapFrequency(substr(trim(S5IFQD),1,1)),1,' ') 
       else lpad(' ',1,' ') end||'|'||
to_char(eit.INT_FREQ_TYPE_DR)||'|'||
case when to_char(case  when get_param('BANK_ID')='02' and map_acc.schm_code='360'  and trim(S5IFQD) is null then  'M'
       when trim(S5IFQD) is not null then 
       lpad(MapFrequency(substr(trim(S5IFQD),1,1)),1,' ') 
       else lpad(' ',1,' ') end) = (to_char(eit.INT_FREQ_TYPE_DR)) then 'TRUE' else 'FALSE' end
from map_acc
inner join scpf on scab=map_acc.leg_branch_id and scan=leg_scan and scas=leg_scas
inner join c8pf on c8ccy = scccy
INNER JOIN (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam ON gam.foracid = fin_acc_num
LEFT JOIN (select * from tbaadm.cam where bank_id=get_param('BANK_ID'))cam ON cam.acid = gam.acid
LEFT JOIN (select * from tbaadm.gac where bank_id=get_param('BANK_ID'))gac ON gac.acid = gam.acid
LEFT JOIN (select * from tbaadm.itc where bank_id=get_param('BANK_ID'))itc ON itc.entity_id =gam.acid
left join  s5pf on s5ab=scab and s5an=scan and s5as=scas
left join capf on CABBN = scpf.scab
left join gfpf on gfpf.gfcpnc = scpf.scan
LEFT JOIN (select * from TBAADM.SOL where bank_id=get_param('BANK_ID'))sol ON sol.SOL_ID = MAP_ACC.FIN_SOL_ID
left join crmuser.accounts b on b.orgkey = map_acc.fin_cif_id
LEFT JOIN(SELECT localetext, VALUE, categorytype FROM crmuser.categories a, crmuser.category_lang b WHERE a.categoryid = b.categoryid
AND categorytype = 'SECTOR_CODE' AND a.bank_id = b.bank_id AND a.bank_id =get_param('BANK_ID') ) d ON d.VALUE = gac.sector_code
LEFT JOIN(SELECT localetext, VALUE, categorytype FROM crmuser.categories a, crmuser.category_lang b WHERE a.categoryid = b.categoryid
AND categorytype = 'SUB_SECTOR_CODE' AND a.bank_id = b.bank_id AND a.bank_id = get_param('BANK_ID')) E ON E.VALUE = gac.sub_sector_code
left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID     
left join (select *  from tbaadm.gsp   where bank_id = get_param('BANK_ID') and del_flg = 'N')gsp on  map_acc.schm_code = gsp.schm_code
left join (select * from tbaadm.mpt where bank_id=get_param('BANK_ID'))mpt on mpt.acid=gam.acid
left join (select * from tbaadm.eit where bank_id=get_param('BANK_ID'))eit on gam.acid=eit.entity_id
left join (select * from tbaadm.ast where bank_id=get_param('BANK_ID'))ast on ast.acid=gam.acid
left join acct_interest_tbl inte on inte.s5ab=scab and inte.s5an=scan and inte.s5as=scas 
left join (
select lp10_acct acc_num,'Y' past_due_flg, LP10_LBD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where to_number(LP10_LMT_C)=0 
union all
select lp10_acct acc_num,'Y' past_due_flg, LP10_LXD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0
union all
select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0
union all
select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt,to_char( to_number(LP10_LGR_K)-to_number(LP10_LMT_K)) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXCESS' and to_number(LP10_LMT_C)<> 0)past on fin_acc_num=trim(acc_num)
left join tbaadm.gct gct on gct.bank_id='01' 
left join(select int_tbl_code,crncy_code,max(int_tbl_ver_num),BASE_PCNT_DR from tbaadm.icv icv where bank_id=get_param('BANK_ID') and int_tbl_code='ODNOR' 
and int_tbl_ver_num=(select max(int_tbl_ver_num) from tbaadm.icv ic where ic.int_tbl_code=icv.int_tbl_code and ic.crncy_code =icv.crncy_code
group by int_tbl_code,crncy_code)
group by int_tbl_code,crncy_code,BASE_PCNT_DR)icvv on itc.INT_TBL_CODE=icvv.INT_TBL_CODE and icvv.crncy_code=trim(scccy)
left join acct_interest_tbl inte on inte.s5ab=scab and inte.s5an=scan and inte.s5as=scas
left join statements_accounts sa on sa.account_number=foracid
where map_acc.schm_type in( 'ODA','PCA') and (B.STAFFFLAG ='Y');
exit; 
