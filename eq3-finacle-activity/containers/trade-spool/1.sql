
select
  'LEG_BRANCH',
  'FINACLE_SOL_ID',
  'BRANCH_ID_MATCH',
  'LEG_CLIENTNO',
  'LEG_SUFFIX',
  'LEG_CURRENCY',
  'FINACLE_CURRENCY',
  'CURRENCY_MATCH',
  'FINACLE_CIF_ID',
  'FINACLE_ACCOUNT_NUMBER',
  'LEG_CUST_TYPE',
  'LEG_ACCOUNT_TYPE',
  'FINACLE_SCHM_CODE',
  'SCHM_DESC',
  'LEG_ACCOUNT_STATUS' ,
  'FINACLE_ACCOUNT_STATUS' ,
  'ACCOUNT_STATUS_MATCH' ,
  'LEG_ACCOUNT_OPENDATE',
  'FINACLE_ACCOUNT_OPENDATE',
  'ACCOUNT_OPENDATE_MATCH',
  'LEG_LAST_TRANSACTION_DATE' ,
  'FINACLE_LAST_TRANSACTION_DATE' ,
  'LAST_TRANSACTION_DATE_MATCH' ,
  'LEG_HOLDMAIL_FLAG' ,
  'LEG_UNDELSTMT_FLAG' ,
  'FINACLE_HOLDMAIL/UNDELSTMT_FLAG' ,
  'LEG_MODE_OF_OPERATION' ,
  'FINACLE_MODE_OF_OPERATION' ,
  'MODE_OF_OPERATION_MATCH' ,
  'LEG_CREDIT_PREF_RATE',
  'FIN_CREDIT_PREF_RATE',
  'CREDIT_PREF_RATE_MATCH',
  'LEG_DEBIT_PREF_RATE',
  'FIN_DEBIT_PREF_RATE',
  'DEBIT_PREF_RATE_MATCH',
  'FIN_BASE_INTEREST_RATE',
  'INT_TABLE_CODE',
  'LEG_CURRENT_BALANCE',
  'FINACLE_CURRENT_BALANCE',
  'CURRENT_BALANCE_MATCH',
  'LEG_LEGDER_BALANCE' ,
  'FIN_LEDGER_BALANCE',
  'LEDGER_BALANCE_MATCH',
  'MEMOPAD FLAG',
  'LEG_PAST_DUE_DATE',
  'FIN_PAST_DUE_AMOUNT',
  'DUE_AMT',
  'C5_CODE',
  'MANAGER_CODE',
  'LEG_STATEMENT_FREQUENCY',
  'FIN_STATEMENT_FREQUENCY',
  'CR_INT_FREQ_FIELD',
  'LEG_CR__INT_FREQ',
  'FIN_CR_INT_FREQ',
  'CR_INT_FREQ_MATCH' ,
  'LEG_C3CODE',
  'FIN_ASSET_CLASS',
  'CREDIT_TIER_CODE',
  'DEBIT_TIER_CODE',
  'LEG_ACCRUED_AMT',
  'FIN_ACCRUED_AMT',
  'ACCRUED_AMT_MATCH'
  from dual
  union all
  select distinct
  to_char(map_acc.leg_branch_id) ,
  to_char(gam.sol_id) ,
  case when substr(to_char(map_acc.leg_branch_id),2,4) = (to_char(gam.sol_id)) then 'TRUE' else 'FALSE' end ,
  to_char(map_acc.leg_scan) ,
  to_char(map_acc.LEG_SCAS) ,
  to_char(scccy),
  to_char(gam.acct_crncy_code),
  case when to_char(scccy) = gam.acct_crncy_code then 'TRUE' else 'FALSE' end ,
  to_char(gam.cif_id),
  to_char(gam.foracid),
  TO_CHAR(MAP_ACC.LEG_CUST_TYPE),
  to_char(map_acc.leg_acct_type),
  to_char(gam.schm_code),
  to_char(gsp.SCHM_DESC),
  case when scai85 = 'Y' and get_param('BANK_ID')= '01' then 'D'
                   when scai20 = 'Y' then 'I'                           
             else 'A' end ,
  TO_CHAR(SMT.ACCT_STATUS) ,
  CASE WHEN (case when scai85 = 'Y' and get_param('BANK_ID')= '01' then 'D'
                   when scai20 = 'Y' then 'I'                           
             else 'A' end)    =       TO_CHAR(SMT.ACCT_STATUS) THEN 'TRUE' ELSE 'FALSE' END , 
  case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
           then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY'),11,' ')          
           else ''
      end ,
  TO_CHAR(gam.acct_opn_date,'DD-MON-YYYY'),
  CASE WHEN trim(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
           then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY'),11,' ')          
           else ''
      end)=TO_CHAR(gam.acct_opn_date,'DD-MON-YYYY') THEN 'TRUE' else 'FALSE' end ,
  case when ext_acc is not null and add_months(to_date(modify_date,'MM/DD/YYYY'),-12) > case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(modify_date,'MM/DD/YYYY'),-12),'DD-MM-YYYY')---changed on 07-06-2017 sa per mk4a observation from sandeep
       when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
             lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
          else lpad(' ',10,' ')
      end,
  TO_CHAR(GAM.LAST_TRAN_DATE,'DD-MM-YYYY')   , 
  case when (case when ext_acc is not null and add_months(to_date(modify_date,'MM/DD/YYYY'),-12) > case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(modify_date,'MM/DD/YYYY'),-12),'DD-MM-YYYY')---changed on 07-06-2017 sa per mk4a observation from sandeep
       when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
             lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
          else lpad(' ',10,' ')
      end) = nvl(TO_CHAR(GAM.LAST_TRAN_DATE,'DD-MM-YYYY'),' ') THEN 'TRUE' ELSE 'FALSE' END ,
  TO_CHAR(SCAI64) ,
  TO_CHAR(SCAIJ1) ,    
  to_char(alr.ACCT_LABEL)    ,
  case when SCAIC7='Y' then lpad('006',5,' ')
                   when scai92='Y' then lpad('011',5,' ')
              else lpad('999',5,' ') end ,
  TO_CHAR(GAM.MODE_OF_OPER_CODE) ,
  CASE WHEN (case when SCAIC7='Y' then '006'
                   when scai92='Y' then '011'
              else '999' end) = TO_CHAR(GAM.MODE_OF_OPER_CODE) THEN 'TRUE' ELSE 'FALSE' END ,
  to_char(inte.S5RATC),
  to_char(itc.CUST_CR_PREF_PCNT),
  case when nvl(to_char(trim(inte.S5RATC)),'0')=nvl(to_char(itc.CUST_CR_PREF_PCNT),' ') then 'TRUE' else 'FALSE' end, 
  to_char(inte.S5RATD),
  to_char(itc.CUST_DR_PREF_PCNT),
  case when nvl(to_char(trim(inte.S5RATD)),'0') = nvl(to_char(itc.CUST_DR_PREF_PCNT),' ') then 'TRUE' else 'FALSE' end, 
  to_char(inte.BASE_PCNT_DR),
  to_char(itc.INT_TBL_CODE) ,
  to_char((scbal -(scsum1+scsum2))/POWER(10,C8CED)) ,
  to_char(clr_bal_amt) ,
  case when to_char((scbal -(scsum1+scsum2))/POWER(10,C8CED)) = to_char(clr_bal_amt) then 'TRUE' else 'FALSE' end ,
  to_char((scbal - SCSUMA)/POWER(10,C8CED)), 
  to_char(clr_bal_amt + FUTURE_BAL_AMT),
  case when to_char((scbal - SCSUMA)/POWER(10,C8CED)) = (to_char(clr_bal_amt + FUTURE_BAL_AMT)) then 'TRUE' else 'FALSE' end,
  to_char(case when mpt.entity_cre_flg='Y' then 'Y' else 'N' end),
  to_char(case when past.acc_num is not null then to_char(to_date(pass_due_dt,'YYYYMMDD'),'DD-MON-YYYY') else lpad(' ',10,' ') end),
  to_char(gac.PD_XFER_DATE),
  to_char(nvl(Suspence_amt,0)),
  to_char(scc5r),
  to_char(scaco),
  to_char(SCSFC),
  to_char(ast.PS_FREQ_TYPE),
  to_char(S5IFQC),
  case  when get_param('BANK_ID')='02' and map_acc.schm_code='SCALC' 
             and trim(S5IFQC) is null then  'M'
             when trim(S5IFQC) is not null then lpad(MapFrequency(substr(trim(S5IFQC),1,1)),1,' ')
             when gsp.INT_PAID_FLG='Y' and trim(gsp.INT_FREQ_TYPE_CR) is not null then gsp.INT_FREQ_TYPE_CR --added in Mock3B based on scheme validation Infosys request           
             else lpad(' ',1,' ') end,
  to_char(eit.INT_FREQ_TYPE_CR),
  case when (case  when get_param('BANK_ID')='02' and map_acc.schm_code='SCALC' 
             and trim(S5IFQC) is null then  'M'
             when trim(S5IFQC) is not null then lpad(MapFrequency(substr(trim(S5IFQC),1,1)),1,' ')
             when gsp.INT_PAID_FLG='Y' and trim(gsp.INT_FREQ_TYPE_CR) is not null then gsp.INT_FREQ_TYPE_CR            
             else lpad(' ',1,' ') end) = (to_char(eit.INT_FREQ_TYPE_CR)) then 'TRUE' else 'FALSE' end,
  to_char(trim(scc3r)) ,
  to_char(SUB_CLASSIFICATION_USER),
  to_char(inte.S5TRCC) ,
  to_char(inte.S5TRCD) ,
  to_char(nvl(leit.NRML_ACCRUED_AMOUNT_CR,0)),
  to_char(eit.NRML_ACCRUED_AMOUNT_CR ),
  case when nvl(leit.NRML_ACCRUED_AMOUNT_CR,0) = (eit.NRML_ACCRUED_AMOUNT_CR) then 'TRUE' else 'FALSE' end
  from map_acc
      inner join scpf  on scab=map_acc.leg_branch_id and scan=leg_scan and scas=leg_scas
      inner join c8pf  on c8ccy = scccy
      inner join (select sol_id,acid,acct_crncy_code,foracid,FUTURE_BAL_AMT,clr_bal_amt,MODE_OF_OPER_CODE,LAST_TRAN_DATE,acct_opn_date,schm_code,cif_id from tbaadm.gam where bank_id=get_param('BANK_ID') and schm_type in ('SBA','CAA'))gam on gam.foracid = map_acc.fin_acc_num
  INNER JOIN (select orgkey,staffflag from crmuser.accounts where staffflag='Y') acct ON acct.orgkey = map_acc.fin_cif_id
      left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
      left join  chqbk on dtabc=scab and dtanc=scan and dtasc=scas
      left join r4pf on r4ab=leg_branch_id and r4an=leg_scan and r4as=leg_scas
      left join acct_interest_tbl inte on inte.s5ab=scab and inte.s5an=scan and inte.s5as=scas 
      LEFT JOIN (select i1.entity_id,i1.INT_TBL_CODE_SRL_NUM,i1.INT_TBL_CODE,i1.CUST_DR_PREF_PCNT,i1.CUST_CR_PREF_PCNT from tbaadm.itc i1 
  left join (select * from tbaadm.itc where bank_id='01')i2 on  (i1.entity_id=i2.entity_id and i1.INT_TBL_CODE_SRL_NUM>i2.INT_TBL_CODE_SRL_NUM)
  where i1.bank_id='01' and i2.entity_id is null )itc ON itc.entity_id =gam.acid
  LEFT JOIN (select acid,PD_XFER_DATE from tbaadm.gac where bank_id=get_param('BANK_ID'))gac ON gac.acid = gam.acid
  left join (select * from map_cif where del_flg<>'Y' and IS_JOINT<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
             left join acct_addr_type_ret addr_ret on addr_ret.leg_acc_num=scab||scan||scas
      left join acct_addr_type_corp addr_corp on addr_corp.leg_acc_num=scab||scan||scas
      left join (select distinct GFCUS,GFCLC,SWIFT_CODE from swift_code2) swift on nvl(trim(swift.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(swift.gfcus)=map_cif.gfcus
      LEFT JOIN (select acid,ACCT_STATUS from tbaadm.smt where bank_id=get_param('BANK_ID'))smt ON smt.acid = gam.acid
  left join (select acid,ACCT_LABEL from tbaadm.alr where bank_id=get_param('BANK_ID'))alr on alr.acid = gam.acid
  left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'Y' group by schm_code)gss  on map_acc.schm_code = gss.schm_code
  left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'N' group by schm_code)gss1  on map_acc.schm_code = gss1.schm_code
  left join (select schm_code,crncy_code from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code =map_acc.CURRENCY     
  left join (select schm_code,INT_PAID_FLG,INT_FREQ_TYPE_CR,SCHM_DESC  from tbaadm.gsp   where bank_id = get_param('BANK_ID') and del_flg = 'N')gsp on  map_acc.schm_code = gsp.schm_code
  left join (select INT_FREQ_TYPE_CR,entity_id,NRML_ACCRUED_AMOUNT_CR from tbaadm.eit where bank_id=get_param('BANK_ID'))eit on gam.acid=eit.entity_id
  left join (select distinct acid,ENTITY_CRE_FLG from tbaadm.mpt where bank_id=get_param('BANK_ID'))mpt on mpt.acid=gam.acid
      left join (select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from ret_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id
      union 
      select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from corp_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id) cntr on cntr.fin_cif_id=map_acc.fin_cif_id 
      left join (
      select lp10_acct acc_num,'Y' past_due_flg, LP10_LBD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where to_number(LP10_LMT_C)=0 
      union all
      select lp10_acct acc_num,'Y' past_due_flg, case when LP10_LXD <> 0 then LP10_LXD else LP10_LED end  pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0
      union all
      select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt,to_char( to_number(LP10_LGR_K)-to_number(LP10_LMT_K)) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXCESS' and to_number(LP10_LMT_C)<> 0)past on fin_acc_num=trim(acc_num)
      left join (select acid from tbaadm.ta_cot where bank_id='01') cot on gam.acid=cot.acid
      left join Acc_dormant  on lpad(trim(ext_Acc),13,0)=fin_acc_num
      left join dormant_acc on  leg_branch_id||leg_scan||leg_scas=dormant_acc.scab||dormant_acc.scan||dormant_acc.scas--code changed for dormant account from Excel file based on the email from Vijay on 17-May-2017,Code chage date on 21/May 
      left join freetext free on map_acc.fin_acc_num=free.acid
      left join custom_eit leit on trim(leit.foracid)=gam.foracid
      left join tbaadm.acd on B2K_ID=gam.acid
      left join (select * from tbaadm.ast where bank_id=get_param('BANK_ID'))ast on ast.acid=gam.acid
      where map_acc.schm_type in( 'SBA','CAA') and map_acc.schm_code<>'PISLA' 
      and individual='Y' and (acct.staffflag='N' or acct.staffflag is NULL)
      union all
  select  distinct
  to_char(map_acc.leg_branch_id) ,
  to_char(gam.sol_id) ,
  case when substr(to_char(map_acc.leg_branch_id),2,4) = (to_char(gam.sol_id)) then 'TRUE' else 'FALSE' end ,
  to_char(map_acc.leg_scan) ,
  to_char(map_acc.LEG_SCAS) ,
  to_char(scccy),
  to_char(gam.acct_crncy_code),
  case when to_char(scccy) = gam.acct_crncy_code then 'TRUE' else 'FALSE' end ,
  to_char(gam.cif_id),
  to_char(gam.foracid),
  TO_CHAR(MAP_ACC.LEG_CUST_TYPE),
  to_char(map_acc.leg_acct_type),
  to_char(gam.schm_code),
  to_char(gsp.SCHM_DESC),
  case when scai85 = 'Y' and get_param('BANK_ID')= '01' then 'D'
        when scai94 = 'Y' and get_param('BANK_ID')= '02' then 'D'
             when scai20 = 'Y' then 'I'                           
             else 'A' end ,
  TO_CHAR(SMT.ACCT_STATUS) ,
  CASE WHEN (case when scai85 = 'Y' and get_param('BANK_ID')= '01' then 'D'
        when scai94 = 'Y' and get_param('BANK_ID')= '02' then 'D'
             when scai20 = 'Y' then 'I'                           
             else 'A' end)    =       TO_CHAR(SMT.ACCT_STATUS) THEN 'TRUE' ELSE 'FALSE' END , 
  case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
           then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY'),11,' ')          
           else ''   end ,
  TO_CHAR(gam.acct_opn_date,'DD-MON-YYYY'),
  CASE WHEN trim(case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
           then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MON-YYYY'),11,' ')          
           else ''
      end)=TO_CHAR(gam.acct_opn_date,'DD-MON-YYYY') THEN 'TRUE' else 'FALSE' end ,
  case when ext_acc is not null and add_months(to_date(modify_date,'MM/DD/YYYY'),-12) > case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(modify_date,'MM/DD/YYYY'),-12),'DD-MM-YYYY')---changed on 07-06-2017 sa per mk4a observation from sandeep
       when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
             lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
          else lpad(' ',10,' ')
      end,
  TO_CHAR(GAM.LAST_TRAN_DATE,'DD-MM-YYYY'),    
  case when (case when ext_acc is not null and add_months(to_date(modify_date,'MM/DD/YYYY'),-12) > case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end then to_char(add_months(to_date(modify_date,'MM/DD/YYYY'),-12),'DD-MM-YYYY')---changed on 07-06-2017 sa per mk4a observation from sandeep
       when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
             lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
          else lpad(' ',10,' ')
      end) = nvl(TO_CHAR(GAM.LAST_TRAN_DATE,'DD-MM-YYYY'),' ') THEN 'TRUE' ELSE 'FALSE' END ,
  TO_CHAR(SCAI64) ,
  TO_CHAR(SCAIJ1) ,    
  to_char(alr.ACCT_LABEL)    ,
  case when SCAIC7='Y' then lpad('006',5,' ')
                   when scai92='Y' then lpad('011',5,' ')
              else lpad('999',5,' ') end ,
  TO_CHAR(GAM.MODE_OF_OPER_CODE) ,
  CASE WHEN (case when SCAIC7='Y' then '006'
                   when scai92='Y' then '011'
              else '999' end) = TO_CHAR(GAM.MODE_OF_OPER_CODE) THEN 'TRUE' ELSE 'FALSE' END ,
  to_char(inte.S5RATC),
  to_char(itc.CUST_CR_PREF_PCNT),
  case when nvl(to_char(trim(inte.S5RATC)),'0')=nvl(to_char(itc.CUST_CR_PREF_PCNT),' ') then 'TRUE' else 'FALSE' end, 
  to_char(inte.S5RATD),
  to_char(itc.CUST_DR_PREF_PCNT),
  case when nvl(to_char(trim(inte.S5RATD)),'0') = nvl(to_char(itc.CUST_DR_PREF_PCNT),' ') then 'TRUE' else 'FALSE' end, 
  to_char(inte.BASE_PCNT_DR),
  to_char(itc.INT_TBL_CODE), 
  to_char(to_number(V5BAL)/power(10,c8pf.c8ced)), 
  to_char(clr_bal_amt) ,
  case when to_char(to_number(V5BAL)/power(10,c8pf.c8ced)) = to_char(clr_bal_amt) then 'TRUE' else 'FALSE' end ,
  to_char((V5BAL)/POWER(10,C8CED)), 
  to_char(clr_bal_amt + FUTURE_BAL_AMT),
  case when to_char((V5BAL)/POWER(10,C8CED)) = (to_char(clr_bal_amt + FUTURE_BAL_AMT)) then 'TRUE' else 'FALSE' end,
  to_char(case when mpt.entity_cre_flg='Y' then 'Y' else 'N' end),
  to_char(' '),
  to_char(gac.PD_XFER_DATE),
  to_char(nvl(' ',0)),
  to_char(scc5r),
  to_char(scaco),
  to_char(SCSFC),
  to_char(ast.PS_FREQ_TYPE),
  to_char(S5IFQC),
  case  when get_param('BANK_ID')='02' and map_acc.schm_code='SCALC' 
             and trim(S5IFQC) is null then  'M'
             when trim(S5IFQC) is not null then lpad(MapFrequency(substr(trim(S5IFQC),1,1)),1,' ')
             when gsp.INT_PAID_FLG='Y' and trim(gsp.INT_FREQ_TYPE_CR) is not null then gsp.INT_FREQ_TYPE_CR --added in Mock3B based on scheme validation Infosys request           
             else lpad(' ',1,' ') end,
  to_char(eit.INT_FREQ_TYPE_CR),
  case when (case  when get_param('BANK_ID')='02' and map_acc.schm_code='SCALC' 
             and trim(S5IFQC) is null then  'M'
             when trim(S5IFQC) is not null then lpad(MapFrequency(substr(trim(S5IFQC),1,1)),1,' ')
             when gsp.INT_PAID_FLG='Y' and trim(gsp.INT_FREQ_TYPE_CR) is not null then gsp.INT_FREQ_TYPE_CR            
             else lpad(' ',1,' ') end) = (to_char(eit.INT_FREQ_TYPE_CR)) then 'TRUE' else 'FALSE' end,
  to_char(trim(scc3r)) ,
  to_char(SUB_CLASSIFICATION_USER),
  to_char(inte.S5TRCC) ,
  to_char(inte.S5TRCD) ,
  to_char(nvl(leit.NRML_ACCRUED_AMOUNT_CR,0)),
  to_char(eit.NRML_ACCRUED_AMOUNT_CR ),
  case when nvl(leit.NRML_ACCRUED_AMOUNT_CR,0) = (eit.NRML_ACCRUED_AMOUNT_CR) then 'TRUE' else 'FALSE' end
  from v5pf
  inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr) 
  inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
  inner join (select sol_id,acid,acct_crncy_code,foracid,FUTURE_BAL_AMT,clr_bal_amt,MODE_OF_OPER_CODE,LAST_TRAN_DATE,acct_opn_date,schm_code,cif_id from tbaadm.gam where bank_id=get_param('BANK_ID') and schm_type in ('SBA','CAA'))gam on gam.foracid = map_acc.fin_acc_num
  INNER JOIN (select orgkey,staffflag from crmuser.accounts where staffflag='Y') acct ON acct.orgkey = map_acc.fin_cif_id
  inner join c8pf  on c8ccy = scccy
  LEFT JOIN (select acid,acct_status from tbaadm.smt where bank_id=get_param('BANK_ID'))smt ON smt.acid = gam.acid
  left join (select acct_label,acid from tbaadm.alr where bank_id=get_param('BANK_ID'))alr on alr.acid = gam.acid
  LEFT JOIN (select i1.entity_id,i1.INT_TBL_CODE_SRL_NUM,i1.INT_TBL_CODE,i1.CUST_DR_PREF_PCNT,i1.CUST_CR_PREF_PCNT from tbaadm.itc i1 
  left join (select * from tbaadm.itc where bank_id='01')i2 on  (i1.entity_id=i2.entity_id and i1.INT_TBL_CODE_SRL_NUM>i2.INT_TBL_CODE_SRL_NUM)
  where i1.bank_id='01' and i2.entity_id is null )itc ON itc.entity_id =gam.acid
  LEFT JOIN (select acid,PD_XFER_DATE from tbaadm.gac where bank_id=get_param('BANK_ID'))gac ON gac.acid = gam.acid
  left join  s5pf  on s5pf.s5ab=scab and s5pf.s5an=scan and s5pf.s5as=scas
  left join (select * from tbaadm.eit where bank_id=get_param('BANK_ID'))eit on gam.acid=eit.entity_id
  left join  chqbk on dtabc=scab and dtanc=scan and dtasc=scas
  left join (select distinct acid,ENTITY_CRE_FLG from tbaadm.mpt where bank_id=get_param('BANK_ID'))mpt on mpt.acid=gam.acid
  left join (select * from tbaadm.ast where bank_id=get_param('BANK_ID'))ast on ast.acid=gam.acid
  left join r4pf on r4ab=leg_branch_id and r4an=leg_scan and r4as=leg_scas
  left join acct_interest_tbl inte on inte.s5ab=scab and inte.s5an=scan and inte.s5as=scas 
  left join (select * from map_cif where del_flg<>'Y' and IS_JOINT<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
  left join (select distinct GFCUS,GFCLC,SWIFT_CODE from swift_code2) swift on nvl(trim(swift.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(swift.gfcus)=map_cif.gfcus
  left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code =map_acc.CURRENCY     
  left join (select *  from tbaadm.gsp   where bank_id = get_param('BANK_ID') and del_flg = 'N')gsp on  map_acc.schm_code = gsp.schm_code
  left join (select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from ret_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id
  union 
  select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from corp_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id) cntr on cntr.fin_cif_id=map_acc.fin_cif_id 
  left join Acc_dormant  on lpad(trim(ext_Acc),13,0)=fin_acc_num
  inner join gfpf  on nvl(trim(gfpf.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
  left join dormant_acc on  leg_branch_id||leg_scan||leg_scas=dormant_acc.scab||dormant_acc.scan||dormant_acc.scas --code changed for dormant account from Excel file based on the email from Vijay on 17-May-2017,Code chage date on 21/May 
  left join freetext free on map_acc.fin_acc_num=free.acid
  left join (select * from tbaadm.icv where bank_id=get_param('BANK_ID') and int_tbl_code||crncy_code||int_tbl_ver_num in (select int_tbl_code||crncy_code||max(int_tbl_ver_num)  from tbaadm.icv where bank_id=get_param('BANK_ID') and start_date <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
  group by int_tbl_code,crncy_code))icv on itc.INT_TBL_CODE=icv.INT_TBL_CODE and icv. crncy_code=trim(scccy)
  left join acct_addr_type_ret addr_ret on addr_ret.leg_acc_num=scpf.scab||scpf.scan||scpf.scas
  left join acct_addr_type_corp addr_corp on addr_corp.leg_acc_num=scpf.scab||scpf.scan||scpf.scas
  left join tbaadm.acd on B2K_ID=gam.acid
  left join custom_eit leit on trim(leit.foracid)=gam.foracid
  where map_acc.schm_type in('CAA')  and v5pf.v5bal<>0;
 
