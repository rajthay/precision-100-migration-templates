========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
ns_pca.sql 
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/KW_NONSTAFF_ODA.dat
select
'EXTERNAL_ACC_NO'||'|'||
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
'LEG_NET_RATE'||'|'||
'FIN_NET_RATE'||'|'||
'NET_RATE_MATCH'||'|'||
'LEG_ACCT_OPENDATE'||'|'||
'FINACLE_OPENDATE'||'|'||
'OPENDATE_MATCH'||'|'||
'LEG_LAST_TRANSACTION_DATE' ||'|'||
'FINACLE_LAST_TRANSACTION_DATE' ||'|'||
'LAST_TRANSACTION_DATE_MATCH' ||'|'||
--'LEG_CREDIT_PREF_RATE'||'|'||
'FIN_CREDIT_PREF_RATE'||'|'||
--'CREDIT_PREF_RATE_MATCH'||'|'||
--'LEG_DEBIT_PREF_RATE'||'|'||
'FIN_DEBIT_PREF_RATE'||'|'||
--'DEBIT_PREF_RATE_MATCH'||'|'||
'FIN_BASE_INTEREST_RATE'||'|'||
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
--'LEG_PAST_DUE_DATE'||'|'||
--'FIN_PAST_DUE_DATE'||'|'||
--'LEG_DUE_AMT'||'|'||
--'FIN_DUE_AMT'||'|'||
--'DUE_AMT_MATCH'||'|'||
'C5_CODE'||'|'||
'MANAGER_CODE'||'|'||
'LEG_STATEMENT_FREQUENCY'||'|'||
'FIN_STATEMENT_FREQUENCY'||'|'||
'STATEMENT_FREQUENCY_MATCH'||'|'||
'LEG_INT_FREQ'||'|'||
'FIN_INT_FREQ'||'|'||
--'INT_FREQ_MATCH'||'|'||
'C3_CODE'||'|'||
'ASSET_CLASSIFICATION'||'|'||
'LEG_ACCRUED_AMT'||'|'||
'FIN_ACCRUED_AMT'||'|'||
'ACCRUED_AMT_MATCH'
from dual
union all
select distinct
to_char(map_acc.EXTERNAL_ACC)||'|'||
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
TO_CHAR(map_acc.leg_branch_id||map_acc.leg_scan||map_acc.leg_scas)||'|'||
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
to_char(nvl(trim(DR_BASE_RATE),0)+nvl(trim(DR_MARGIN_RATE),0)+nvl(trim(TIER_BASE_RATE),0)+nvl(trim(TIER_DIFF_RATE),0)+nvl(trim(inte.S5RATD),0))||'|'||
to_char(nvl(trim(BASE_PCNT_DR),0)+nvl(trim(DR_PREF_RATE),0)+nvl(trim(DR_NRML_INT_PCNT),0))||'|'||
case when (to_char(nvl(trim(DR_BASE_RATE),0)+nvl(trim(DR_MARGIN_RATE),0)+nvl(trim(TIER_BASE_RATE),0)+nvl(trim(TIER_DIFF_RATE),0)))=(to_char(nvl(trim(BASE_PCNT_DR),0)+nvl(trim(DR_PREF_RATE),0)+nvl(trim(DR_NRML_INT_PCNT),0))) then 'TRUE' else 'FALSE' end ||'|'||
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
case     when ext_acc is not null then to_char(add_months(to_date(modify_date,'MM/DD/YYYY'),-12),'DD-MM-YYYY')
    when scdle <>0 and get_date_fm_btrv(scdle) <> 'ERROR' then
           lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        else lpad(' ',10,' ') end||'|'||
TO_CHAR(GAM.LAST_TRAN_DATE,'DD-MM-YYYY') ||'|'||
CASE WHEN (case     when ext_acc is not null then to_char(add_months(to_date(modify_date,'MM/DD/YYYY'),-12),'DD-MM-YYYY')
    when scdle <>0 and get_date_fm_btrv(scdle) <> 'ERROR' then
           lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
        else lpad(' ',10,' ') end)     = nvl(TO_CHAR(GAM.LAST_TRAN_DATE,'DD-MM-YYYY'),' ')  THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(inte.S5RATC)||'|'||
to_char(itc.ID_CR_PREF_PCNT)||'|'||
--case when nvl(to_char(trim(inte.S5RATC)),'0')=nvl(to_char(itc.CUST_CR_PREF_PCNT),' ') then 'TRUE' else 'FALSE' end ||'|'||
--to_char(inte.S5RATD)||'|'||
to_char(itc.ID_DR_PREF_PCNT)||'|'||
--case when nvl(to_char(trim(inte.S5RATD)),'0') = nvl(to_char(itc.CUST_DR_PREF_PCNT),' ') then 'TRUE' else 'FALSE' end ||'|'||
to_char(inte.BASE_PCNT_DR)||'|'||
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
--to_char(to_date(pass_due_dt,'YYYYMMDD'),'DD-MM-YYYY')||'|'||
--to_char(gac.PD_XFER_DATE)||'|'||
--to_char(case when past.acc_num is not null then to_char(nvl(iis.amt,0)) else '0' end)||'|'||
--to_char(Suspence_amt)||'|'||
--INT_SUSPENSE_AMT||'|'||
--case when nvl(abs(to_char(case when past.acc_num is not null then to_char(nvl(iis.amt,0)) else '0' end)),0)=nvl(abs(INT_SUSPENSE_AMT),0) then 'TRUE' else 'FALSE' end||'|'||
to_char(scc5r)||'|'||
to_char(scaco)||'|'||
--sa.PS_FREQ_TYPE||'|'||
to_char(SCSFC)||'|'||
ast.PS_FREQ_TYPE||'|'||
case when nvl(trim(case when scaiG6='Y' then ''      
when substr(SCSFC,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then 'Y'
         when substr(SCSFC,0,1) in ('Z') then 'D'
         when substr(SCSFC,0,1) in ('V') then 'M'
         when substr(SCSFC,0,1) in ('W') then 'W'
         when substr(SCSFC,0,1) in ('Y') then 'F'
         when substr(SCSFC,0,1) in ('S','T','U') then 'Q'
         when substr(SCSFC,0,1) in ('M','N','O','P','Q','R') then 'H'
         else to_char(gsp.ps_freq_type)
    end),'*') = nvl(trim(ast.PS_FREQ_TYPE),'*') then 'TRUE' else 'FALSE' end||'|'||
S5IFQD||'|'||
to_char(eit.INT_FREQ_TYPE_DR)||'|'||
to_char(trim(scc3r)) ||'|'||
SUB_CLASSIFICATION_USER ||'|'||
nvl(leit.NORMAL_CREDIT_ACCRUED_AMT,0)||'|'||
eit.NRML_ACCRUED_AMOUNT_CR ||'|'||
case when nvl(leit.NORMAL_CREDIT_ACCRUED_AMT,0) = (eit.NRML_ACCRUED_AMOUNT_CR) then 'TRUE' else 'FALSE' end
from (select * from map_acc where schm_type='PCA')map_acc
inner join scpf  on scab=map_acc.leg_branch_id and scan=leg_scan and scas=leg_scas
inner join c8pf  on c8ccy = scccy
left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
left join acct_interest_tbl_rep inte on inte.s5ab=scab and inte.s5an=scan and inte.s5as=scas 
left join  chqbk on dtabc=scab and dtanc=scan and dtasc=scas
left join r4pf on r4ab=leg_branch_id and r4an=leg_scan and r4as=leg_scas
left join acct_addr_type_ret addr_ret on addr_ret.leg_acc_num=scab||scan||scas
left join acct_addr_type_corp addr_corp on addr_corp.leg_acc_num=scab||scan||scas
left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
left join (select distinct GFCUS,GFCLC,SWIFT_CODE from swift_code2) swift on nvl(trim(swift.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(swift.gfcus)=map_cif.gfcus
left join gfpf gf on trim(gf.gfcus)=map_cif.gfcus and nvl(trim(gf.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and gf.gfcpnc=MAP_CIF.GFCPNC
left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code =map_acc.CURRENCY     
left join (select *  from tbaadm.gsp   where bank_id = get_param('BANK_ID') and del_flg = 'N')gsp on  map_acc.schm_code = gsp.schm_code
left join (select map_acc.fin_acc_num fin_num, oper.fin_acc_num operative_acc_num  from ubpf inner join map_acc on ubab=leg_branch_id and uban=leg_scan and ubas=leg_scas
inner join (select leg_branch_id||leg_Scan||leg_Scas leg_acc_num,fin_acc_num from map_acc where SCHM_TYPE<>'OOO') oper on ubnab||ubnan||ubnas=oper.leg_acc_num 
where map_acc.schm_type<>'OOO') oper on oper.fin_num=fin_acc_num
left join (select distinct main.fin_acc_num Main_fin,main.schm_type main_schm,oper.fin_acc_num oper_fin,oper.schm_type oper_type from gvpf_ods
inner join map_cif on nvl(gvclc,' ')=nvl(map_cif.gfclc,' ') and  gvcus=map_cif.gfcus 
inner join map_acc main on main.fin_cif_id=map_cif.fin_cif_id and schm_type='PCA' AND GVCCY=MAIN.CURRENCY
inner join map_acc oper on oper.leg_branch_id||oper.leg_Scan||oper.leg_Scas=trim(GVABF)||trim(GVANF)||trim(GVASF) AND GVCCY=OPER.CURRENCY and oper.schm_type <> 'OOO') oper1 on oper1.main_fin=map_acc.fin_acc_num 
left join (select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from ret_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id
union 
select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from corp_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id) cntr on cntr.fin_cif_id=map_acc.fin_cif_id 
left join (
select lp10_acct acc_num,'Y' past_due_flg, LP10_LBD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where to_number(LP10_LMT_C)=0 
union all
select lp10_acct acc_num,'Y' past_due_flg, case when LP10_LXD <> 0 then LP10_LXD else LP10_LED end  pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0
union all
select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt,to_char( to_number(LP10_LGR_K)-to_number(LP10_LMT_K)) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXCESS' and to_number(LP10_LMT_C)<> 0)past on fin_acc_num=trim(acc_num)
left join Acc_dormant  on lpad(trim(ext_Acc),13,0)=fin_acc_num
left join dormant_acc on  leg_branch_id||leg_scan||leg_scas=dormant_acc.scab||dormant_acc.scan||dormant_acc.scas --code changed for dormant account from Excel file based on the email from Vijay on 17-May-2017,Code chage date on 21/May 
left join freetext on map_acc.fin_acc_num=freetext.acid
left join gfpf on gfpf.gfcpnc = scpf.scan
left join capf on CABBN = scpf.scab
left join sanction_limit on sanction_num=map_acc.fin_acc_num
INNER JOIN (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam ON gam.foracid = fin_acc_num
--left join statements_accounts sa on sa.account_number=foracid
LEFT JOIN (select * from tbaadm.cam where bank_id=get_param('BANK_ID'))cam ON cam.acid = gam.acid
LEFT JOIN (select * from tbaadm.gac where bank_id=get_param('BANK_ID'))gac ON gac.acid = gam.acid
left join casaod_eit leit on trim(leit.account_number)=gam.foracid
LEFT JOIN (select * from tbaadm.itc where bank_id=get_param('BANK_ID'))itc ON itc.entity_id =gam.acid
LEFT JOIN (select * from TBAADM.SOL where bank_id=get_param('BANK_ID'))sol ON sol.SOL_ID = MAP_ACC.FIN_SOL_ID
left join crmuser.accounts b on b.orgkey = map_acc.fin_cif_id
LEFT JOIN(SELECT localetext, VALUE, categorytype FROM crmuser.categories a, crmuser.category_lang b WHERE a.categoryid = b.categoryid
AND categorytype = 'SECTOR_CODE' AND a.bank_id = b.bank_id AND a.bank_id =get_param('BANK_ID') ) d ON d.VALUE = gac.sector_code
LEFT JOIN(SELECT localetext, VALUE, categorytype FROM crmuser.categories a, crmuser.category_lang b WHERE a.categoryid = b.categoryid
AND categorytype = 'SUB_SECTOR_CODE' AND a.bank_id = b.bank_id AND a.bank_id = get_param('BANK_ID')) E ON E.VALUE = gac.sub_sector_code
left join (select *  from tbaadm.gsp   where bank_id = get_param('BANK_ID') and del_flg = 'N')gsp on  map_acc.schm_code = gsp.schm_code
left join (select * from tbaadm.mpt where bank_id=get_param('BANK_ID'))mpt on mpt.acid=gam.acid
left join (select * from tbaadm.eit where bank_id=get_param('BANK_ID'))eit on gam.acid=eit.entity_id
left join tbaadm.acd on B2K_ID=gam.acid
left join (select acid,INT_SUSPENSE_AMT,DATE_NON_ACCRUE from tbaadm.ta_cot where bank_id=get_param('BANK_ID') )ldt on ldt.acid=gam.acid
left join iis_account iis on map_acc.fin_acc_num=iis.account
left join (select * from tbaadm.ast where bank_id=get_param('BANK_ID'))ast on ast.acid=gam.acid
where (B.STAFFFLAG ='N' or b.staffflag is NULL);
exit; 
