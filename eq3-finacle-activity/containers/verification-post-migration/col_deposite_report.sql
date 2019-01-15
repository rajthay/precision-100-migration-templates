select  distinct trim(hydbnm)||trim(hydlp)||trim(hydlr) LEG_DEAL_NUM,
TRIM(HYCLR) LEG_COLLATERAL_REFERENCE,
HYCLP LEG_COL_CODE,CASE WHEN HYDPC='199' THEN 'RDEP-'||trim(HYCCY) ELSE 'DEP-'||trim(HYCCY) END FIN_MAPPED_COL_CODE,SECU_CODE FIN_SECU_CODE, case when CASE WHEN HYDPC='199' THEN 'RDEP-'||trim(HYCCY) ELSE 'DEP-'||trim(HYCCY) END = SECU_CODE then 'TRUE' ELSE 'FALSE' END MATCH_SECU_CODE,
to_char(FIN_COL_DEP.MAX_CEILING_LIM,'9999999999999999999.999') FIN_CEILING_LIMIT,
hypf.hyccy LEG_CCY_CODE,FIN_COL_DEP.CRNCY_CODE FIN_CRNCY_CODE,case when hypf.hyccy = FIN_COL_DEP.CRNCY_CODE THEN 'TRUE' ELSE 'FALSE' END MATCH_CCY_CODE,
to_char(to_number((hypf.hyclv)/power(10,c8ced)),'9999999999999999999.999') LEG_COLLATERAL_VALUE,to_char(SECU_VALUE,'9999999999999999999.999') FIN_SECU_VALUE,case when to_number((hypf.hyclv)/power(10,c8ced))  =SECU_VALUE then 'TRUE' ELSE 'FALSE' END MATCH_SECU_VALUE, 
case when HYSVM='99.999' then '100' else to_char(HYSVM) end  LEG_MARGIN,FIN_COL_DEP.RETAIN_MARGIN_PCNT FIN_RETAIN_MARGIN_PCNT,CASE WHEN case when HYSVM='99.999' then '100' else to_char(HYSVM) end  = FIN_COL_DEP.RETAIN_MARGIN_PCNT THEN 'TRUE' ELSE 'FALSE' END MATCH_MARGIN,
map_acc.LEG_BRANCH_ID||map_acc.LEG_SCAN||map_acc.LEG_SCAS LEG_DEPOSIT_ACCOUNT_NUMBER,FIN_COL_DEP.FORACID FIN_DEPOSIT_ACCOUNT_NUMBER,
TO_DATE(case    when hycxd='9999999' then '31-12-2099' else       
      to_char(to_date(get_date_fm_btrv(hycxd),'YYYYMMDD'),'DD-MM-YYYY')
end,'DD-MM-YYYY') LEG_DUE_DATE,FIN_COL_DEP.ITEM_DUE_DATE FIN_ITEM_DUE_DATE, CASE WHEN TO_DATE(case    when hycxd='9999999' then '31-12-2099' else       
      to_char(to_date(get_date_fm_btrv(hycxd),'YYYYMMDD'),'DD-MM-YYYY')
end,'DD-MM-YYYY') = FIN_COL_DEP.ITEM_DUE_DATE THEN 'TRUE' ELSE 'FALSE' END MATCH_DUE_DATE,
map_acc.LEG_BRANCH_ID||map_acc.LEG_CUST_ID LEG_CIF_ID,case when map_cif.INDIVIDUAL='Y' then orgkey  else CORP_KEY end FIN_CUST_ID,
gfpf.GFACO LEG_RM_CODE,
trim(HYNR1)||' '||trim(HYNR2)||' '||trim(HYNR3)||' '||trim(HYNR4) LEG_NOTES,FIN_COL_DEP.FREE_TEXT FIN_NOTES,CASE WHEN trim(TRIM(trim(HYNR1)||' '||trim(HYNR2)||' '||trim(HYNR3)||' '||trim(HYNR4))) =TRIM(FIN_COL_DEP.FREE_TEXT) THEN 'TRUE' ELSE 'FALSE' END MATCH_NOTES
from hypf
inner join map_acc on trim(hydbnm)||trim(hydlp)||trim(hydlr)=leg_acc_num
inner join c8pf on c8ccy = hyccy
inner join gfpf on trim(gfpf.gfcus)= trim(hycus) and nvl(trim(gfpf.gfclc),' ') = nvl(trim(hyclc),' ') 
inner join map_cif on trim(gfpf.gfcus)= trim(map_cif.gfcus) and nvl(trim(gfpf.gfclc),' ') = nvl(trim(map_cif.gfclc),' ')
LEFT JOIN (SELECT SCMT.MAX_CEILING_LIM,scmt.SECU_VALUE,SCMT.RETAIN_MARGIN_PCNT,GAM.FORACID,SCMT.ITEM_DUE_DATE,SCMT.FREE_TEXT,accounts.orgkey,corporate.CORP_KEY,SCMT.CRNCY_CODE,scmt.SECU_CODE  FROM TBAADM.SCMT INNER JOIN TBAADM.GAM 
ON GAM.ACID = SCMT.LIEN_ACID  and  SCMT.SECU_TYPE_IND='D' AND SCMT.BANK_ID=get_param('BANK_ID')
left join crmuser.accounts on accounts.CORE_CUST_ID =SCMT.CUST_ID 
left join crmuser.corporate on corporate.CORE_CUST_ID =SCMT.CUST_ID) FIN_COL_DEP
 ON trim(FIN_COL_DEP.FORACID) = trim(map_acc.fin_acc_num)
where map_acc.schm_type='TDA' and hyclp ='021'


select  distinct trim(hydbnm)||trim(hydlp)||trim(hydlr) LEG_DEAL_NUM,
TRIM(HYCLR) LEG_COLLATERAL_REFERENCE,
HYCLP LEG_COL_CODE,CASE WHEN HYDPC='199' THEN 'RDEP-'||trim(HYCCY) ELSE 'DEP-'||trim(HYCCY) END FIN_MAPPED_COL_CODE,SECU_CODE FIN_SECU_CODE, case when CASE WHEN HYDPC='199' THEN 'RDEP-'||trim(HYCCY) ELSE 'DEP-'||trim(HYCCY) END = SECU_CODE then 'TRUE' ELSE 'FALSE' END MATCH_SECU_CODE,
to_char(FIN_COL_DEP.MAX_CEILING_LIM,'9999999999999999999.999') FIN_CEILING_LIMIT,
hypf.hyccy LEG_CCY_CODE,FIN_COL_DEP.CRNCY_CODE FIN_CRNCY_CODE,case when hypf.hyccy = FIN_COL_DEP.CRNCY_CODE THEN 'TRUE' ELSE 'FALSE' END MATCH_CCY_CODE,
to_char(to_number((hypf.hyclv)/power(10,c8ced)),'9999999999999999999.999') LEG_COLLATERAL_VALUE,to_char(SECU_VALUE,'9999999999999999999.999') FIN_SECU_VALUE,case when to_number((hypf.hyclv)/power(10,c8ced))  =SECU_VALUE then 'TRUE' ELSE 'FALSE' END MATCH_SECU_VALUE, 
case when HYSVM='99.999' then '100' else to_char(HYSVM) end  LEG_MARGIN,FIN_COL_DEP.NET_LTV_PCNT1 FIN_LTV_PCNT,CASE WHEN case when HYSVM='99.999' then '100' else to_char(HYSVM) end  = FIN_COL_DEP.NET_LTV_PCNT1 THEN 'TRUE' ELSE 'FALSE' END MATCH_MARGIN,
map_acc.LEG_BRANCH_ID||map_acc.LEG_SCAN||map_acc.LEG_SCAS LEG_DEPOSIT_ACCOUNT_NUMBER,FIN_COL_DEP.FORACID FIN_DEPOSIT_ACCOUNT_NUMBER,
TO_DATE(case    when hycxd='9999999' then '31-12-2099' else       
      to_char(to_date(get_date_fm_btrv(hycxd),'YYYYMMDD'),'DD-MM-YYYY')
end,'DD-MM-YYYY') LEG_DUE_DATE,FIN_COL_DEP.ITEM_DUE_DATE FIN_ITEM_DUE_DATE, CASE WHEN TO_DATE(case    when hycxd='9999999' then '31-12-2099' else       
      to_char(to_date(get_date_fm_btrv(hycxd),'YYYYMMDD'),'DD-MM-YYYY')
end,'DD-MM-YYYY') = FIN_COL_DEP.ITEM_DUE_DATE THEN 'TRUE' ELSE 'FALSE' END MATCH_DUE_DATE,
map_acc.LEG_BRANCH_ID||map_acc.LEG_CUST_ID LEG_CIF_ID,case when map_cif.INDIVIDUAL='Y' then orgkey  else CORP_KEY end FIN_CUST_ID,
gfpf.GFACO LEG_RM_CODE,
trim(HYNR1)||' '||trim(HYNR2)||' '||trim(HYNR3)||' '||trim(HYNR4) LEG_NOTES,FIN_COL_DEP.FREE_TEXT FIN_NOTES,CASE WHEN trim(TRIM(trim(HYNR1)||' '||trim(HYNR2)||' '||trim(HYNR3)||' '||trim(HYNR4))) =TRIM(FIN_COL_DEP.FREE_TEXT) THEN 'TRUE' ELSE 'FALSE' END MATCH_NOTES
from hypf
inner join map_acc on trim(hydbnm)||trim(hydlp)||trim(hydlr)=leg_acc_num
inner join c8pf on c8ccy = hyccy
inner join gfpf on trim(gfpf.gfcus)= trim(hycus) and nvl(trim(gfpf.gfclc),' ') = nvl(trim(hyclc),' ') 
inner join map_cif on trim(gfpf.gfcus)= trim(map_cif.gfcus) and nvl(trim(gfpf.gfclc),' ') = nvl(trim(map_cif.gfclc),' ')
LEFT JOIN (SELECT SCMT.MAX_CEILING_LIM,scmt.SECU_VALUE,SCMT.RETAIN_MARGIN_PCNT,NET_LTV_PCNT1,GAM.FORACID,SCMT.ITEM_DUE_DATE,SCMT.FREE_TEXT,accounts.orgkey,corporate.CORP_KEY,SCMT.CRNCY_CODE,scmt.SECU_CODE  FROM TBAADM.SCMT INNER JOIN TBAADM.GAM 
ON GAM.ACID = SCMT.LIEN_ACID  and  SCMT.SECU_TYPE_IND='D' AND SCMT.BANK_ID=get_param('BANK_ID')
left join crmuser.accounts on accounts.CORE_CUST_ID =SCMT.CUST_ID 
left join crmuser.corporate on corporate.CORE_CUST_ID =SCMT.CUST_ID) FIN_COL_DEP
 ON trim(FIN_COL_DEP.FORACID) = trim(map_acc.fin_acc_num)
where map_acc.schm_type='TDA' and hyclp ='021'


select  distinct trim(hydbnm)||trim(hydlp)||trim(hydlr) LEG_DEAL_NUM,
TRIM(HYCLR) LEG_COLLATERAL_REFERENCE,
HYCLP LEG_COL_CODE,CASE WHEN HYDPC='199' THEN 'RDEP-'||trim(HYCCY) ELSE 'DEP-'||trim(HYCCY) END FIN_MAPPED_COL_CODE,SECU_CODE FIN_SECU_CODE, case when CASE WHEN HYDPC='199' THEN 'RDEP-'||trim(HYCCY) ELSE 'DEP-'||trim(HYCCY) END = SECU_CODE then 'TRUE' ELSE 'FALSE' END MATCH_SECU_CODE,
to_char(FIN_COL_DEP.MAX_CEILING_LIM,'9999999999999999999.999') FIN_CEILING_LIMIT,
hypf.hyccy LEG_CCY_CODE,FIN_COL_DEP.CRNCY_CODE FIN_CRNCY_CODE,case when hypf.hyccy = FIN_COL_DEP.CRNCY_CODE THEN 'TRUE' ELSE 'FALSE' END MATCH_CCY_CODE,
to_char(to_number((hypf.hyclv)/power(10,c8ced)),'9999999999999999999.999') LEG_COLLATERAL_VALUE,to_char(SECU_VALUE,'9999999999999999999.999') FIN_SECU_VALUE,case when to_number((hypf.hyclv)/power(10,c8ced))  =SECU_VALUE then 'TRUE' ELSE 'FALSE' END MATCH_SECU_VALUE, 
case when HYSVM='99.999' then '100' else to_char(HYSVM) end  LEG_MARGIN,100-FIN_COL_DEP.RETAIN_MARGIN_PCNT FIN_LTV_PCNT,CASE WHEN case when HYSVM='99.999' then '100' else to_char(HYSVM) end  = 100-FIN_COL_DEP.RETAIN_MARGIN_PCNT THEN 'TRUE' ELSE 'FALSE' END MATCH_MARGIN,
map_acc.LEG_BRANCH_ID||map_acc.LEG_SCAN||map_acc.LEG_SCAS LEG_DEPOSIT_ACCOUNT_NUMBER,FIN_COL_DEP.FORACID FIN_DEPOSIT_ACCOUNT_NUMBER,
TO_DATE(case    when hycxd='9999999' then '31-12-2099' else       
      to_char(to_date(get_date_fm_btrv(hycxd),'YYYYMMDD'),'DD-MM-YYYY')
end,'DD-MM-YYYY') LEG_DUE_DATE,FIN_COL_DEP.ITEM_DUE_DATE FIN_ITEM_DUE_DATE, CASE WHEN TO_DATE(case    when hycxd='9999999' then '31-12-2099' else       
      to_char(to_date(get_date_fm_btrv(hycxd),'YYYYMMDD'),'DD-MM-YYYY')
end,'DD-MM-YYYY') = FIN_COL_DEP.ITEM_DUE_DATE THEN 'TRUE' ELSE 'FALSE' END MATCH_DUE_DATE,
map_acc.LEG_BRANCH_ID||map_acc.LEG_CUST_ID LEG_CIF_ID,orgkey FIN_CUST_ID,
gfpf.GFACO LEG_RM_CODE,
trim(HYNR1)||' '||trim(HYNR2)||' '||trim(HYNR3)||' '||trim(HYNR4) LEG_NOTES,FIN_COL_DEP.FREE_TEXT FIN_NOTES,CASE WHEN trim(TRIM(trim(HYNR1)||' '||trim(HYNR2)||' '||trim(HYNR3)||' '||trim(HYNR4))) =TRIM(FIN_COL_DEP.FREE_TEXT) THEN 'TRUE' ELSE 'FALSE' END MATCH_NOTES
from hypf
inner join map_acc on trim(hydbnm)||trim(hydlp)||trim(hydlr)=leg_acc_num
inner join c8pf on c8ccy = hyccy
inner join gfpf on trim(gfpf.gfcus)= trim(hycus) and nvl(trim(gfpf.gfclc),' ') = nvl(trim(hyclc),' ') 
inner join map_cif on trim(gfpf.gfcus)= trim(map_cif.gfcus) and nvl(trim(gfpf.gfclc),' ') = nvl(trim(map_cif.gfclc),' ')
LEFT JOIN (SELECT SCMT.MAX_CEILING_LIM,scmt.SECU_VALUE,SCMT.RETAIN_MARGIN_PCNT,NET_LTV_PCNT1,GAM.FORACID,SCMT.ITEM_DUE_DATE,SCMT.FREE_TEXT,accounts.orgkey,corporate.CORP_KEY,SCMT.CRNCY_CODE,scmt.SECU_CODE  FROM TBAADM.SCMT INNER JOIN TBAADM.GAM 
ON GAM.ACID = SCMT.LIEN_ACID  and  SCMT.SECU_TYPE_IND='D' AND SCMT.BANK_ID=get_param('BANK_ID')
left join crmuser.accounts on accounts.CORE_CUST_ID =SCMT.CUST_ID 
left join crmuser.corporate on corporate.CORE_CUST_ID =SCMT.CUST_ID) FIN_COL_DEP
 ON trim(FIN_COL_DEP.FORACID) = trim(map_acc.fin_acc_num)
where map_acc.schm_type='TDA' and hyclp ='021' 
