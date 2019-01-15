select  distinct CC_FINONE_ACCNT LEG_COLL_REFERENCE,HYCLP LEG_COL_CODE, case when hyclp ='010' then 'REL-KWD' when hyclp ='011' then 'RES-KWD' when hyclp ='025' then 'FRA-KWD'end FIN_MAPPED_COL_CODE , 
trim(FIN_COL_IP_RE.SECU_CODE) FIN_SECU_CODE,case when case when hyclp ='010' then 'REL-KWD' when hyclp ='011' then 'RES-KWD' when hyclp ='025' then 'FRA-KWD' end = trim(SECU_CODE) then 'TRUE' ELSE 'FALSE' END MATCH_SECU_CODE,
hypf.hyccy LEG_CCY_CODE,FIN_COL_IP_RE.CRNCY_CODE FIN_CRNCY_CODE,case when hypf.hyccy = FIN_COL_IP_RE.CRNCY_CODE THEN 'TRUE' ELSE 'FALSE' END MATCH_CCY_CODE, 
--to_number((hypf.HYTOTA)/power(10,c8ced)) LEG_ASSESSED_VALUE,
--to_number((hypf.HYBKV)/power(10,c8ced)) LEG_MARKET_VALUE,
to_char(to_number((hypf.hyclv)/power(10,c8ced)),'9999999999999999999.999') LEG_COLLATERAL_VALUE,to_char(SECU_VALUE,'9999999999999999999.999') FIN_SECU_VALUE,case when to_number((hypf.hyclv)/power(10,c8ced))  =SECU_VALUE then 'TRUE' ELSE 'FALSE' END MATCH_SECU_VALUE,
--map_cif.LEG_CUST_NUMBER LEG_CIF_ID,
hyclc||hycus LEG_CIF_ID ,case when map_cif.INDIVIDUAL='Y' then orgkey  else CORP_KEY end FIN_CIF_ID ,
gfpf.GFACO LEG_RM_CODE,
TRIM(REPLACE(REPLACE(TRIM(TRIM(HYNR1)||' '||TRIM(HYNR2)||' '||TRIM(HYNR3)||' '||TRIM(HYNR4)||' '||
CASE WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') END ),CHR(10),' '),CHR(13),' ')) LEG_NOTES,trim(FREE_TEXT) FIN_NOTES,case when TRIM(REPLACE(REPLACE(TRIM(TRIM(HYNR1)||' '||TRIM(HYNR2)||' '||TRIM(HYNR3)||' '||TRIM(HYNR4)||' '||
CASE WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') END ),CHR(10),' '),CHR(13),' ')) = TRIM(FIN_COL_IP_RE.FREE_TEXT) then 'TRUE' ELSE 'FALSE' END MATCH_NOTES
--,case when map_acc.fin_Acc_num is not null then 
--map_acc.fin_Acc_num else '' end LEG_ACCOUNT_NUMBER
 from hypf  
inner join c8pf on c8ccy=hyccy 
inner join gfpf on trim(gfpf.gfcus)= trim(hycus) and nvl(trim(gfpf.gfclc),' ') = nvl(trim(hyclc),' ')
left join map_cif on trim(hycus)=trim(map_cif.gfcus) and nvl(trim(hyclc),' ')=nvl(trim(map_cif.gfclc),' ') 
left join YCCLC5PF01 on   trim(HYCLR)=trim(CCC5_CLR)
left join (select * from map_acc where schm_type<>'OOO')map_acc on leg_branch_id||leg_scan||leg_scas=lpad(CCC5_CLC,4,0)||CCC5_CUS||lpad(CCC5_CSEQ,3,0)
LEFT JOIN (SELECT CC_FINONE_ACCNT,SCMT.SECU_CODE,SCMT.MAX_CEILING_LIM,SCMT.RETAIN_MARGIN_PCNT,SCMT.ITEM_DUE_DATE,SCMT.FREE_TEXT,accounts.orgkey,SECU_VALUE,corporate.CORP_KEY,SCMT.CRNCY_CODE FROM TBAADM.SCMT 
left join crmuser.accounts on accounts.CORE_CUST_ID =SCMT.CUST_ID
left join crmuser.corporate on corporate.CORE_CUST_ID =SCMT.CUST_ID 
left join MIGADM.C_COLLIMMOV mic on mic.SECU_SRL_NUM = scmt.SECU_SRL_NUM
 WHERE  SCMT.SECU_TYPE_IND='I' AND SCMT.BANK_ID=GET_PARAM('BANK_ID' )) FIN_COL_IP_RE
 ON TRIM(FIN_COL_IP_RE.orgkey) = TRIM(map_cif.FIN_CIF_ID) 
 and trim(HYCLR) = trim(CC_FINONE_ACCNT) 
where hyclp in('010','011','025')
--and to_number((hypf.hyclv)/power(10,c8ced)) <> 0
--AND (CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') > to_date(get_param('EOD_DATE'),'dd-mm-yyyy') or HYCXD='9999999' OR TRIM(HYCXD) IS NULL)


select  distinct CC_FINONE_ACCNT LEG_COLL_REFERENCE,HYCLP LEG_COL_CODE, case when hyclp ='010' then 'REL-KWD' when hyclp ='011' then 'RES-KWD' when hyclp ='025' then 'FRA-KWD'end FIN_MAPPED_COL_CODE , 
trim(FIN_COL_IP_RE.SECU_CODE) FIN_SECU_CODE,case when case when hyclp ='010' then 'REL-KWD' when hyclp ='011' then 'RES-KWD' when hyclp ='025' then 'FRA-KWD' end = trim(SECU_CODE) then 'TRUE' ELSE 'FALSE' END MATCH_SECU_CODE,
hypf.hyccy LEG_CCY_CODE,FIN_COL_IP_RE.CRNCY_CODE FIN_CRNCY_CODE,case when hypf.hyccy = FIN_COL_IP_RE.CRNCY_CODE THEN 'TRUE' ELSE 'FALSE' END MATCH_CCY_CODE, 
--to_number((hypf.HYTOTA)/power(10,c8ced)) LEG_ASSESSED_VALUE,
--to_number((hypf.HYBKV)/power(10,c8ced)) LEG_MARKET_VALUE,
to_char(to_number((hypf.hyclv)/power(10,c8ced)),'9999999999999999999.999') LEG_COLLATERAL_VALUE,to_char(SECU_VALUE,'9999999999999999999.999') FIN_SECU_VALUE,case when to_number((hypf.hyclv)/power(10,c8ced))  =SECU_VALUE then 'TRUE' ELSE 'FALSE' END MATCH_SECU_VALUE,
--map_cif.LEG_CUST_NUMBER LEG_CIF_ID,
hyclc||hycus LEG_CIF_ID ,case when map_cif.INDIVIDUAL='Y' then orgkey  else CORP_KEY end FIN_CIF_ID ,
gfpf.GFACO LEG_RM_CODE,
TRIM(REPLACE(REPLACE(TRIM(TRIM(HYNR1)||' '||TRIM(HYNR2)||' '||TRIM(HYNR3)||' '||TRIM(HYNR4)||' '||
CASE WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') END ),CHR(10),' '),CHR(13),' ')) LEG_NOTES,trim(FREE_TEXT) FIN_NOTES,case when TRIM(REPLACE(REPLACE(TRIM(TRIM(HYNR1)||' '||TRIM(HYNR2)||' '||TRIM(HYNR3)||' '||TRIM(HYNR4)||' '||
CASE WHEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') THEN CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') END ),CHR(10),' '),CHR(13),' ')) = TRIM(FIN_COL_IP_RE.FREE_TEXT) then 'TRUE' ELSE 'FALSE' END MATCH_NOTES
--,case when map_acc.fin_Acc_num is not null then 
--map_acc.fin_Acc_num else '' end LEG_ACCOUNT_NUMBER
,case when  trim(HYISV) <> 0 then trim(HYISV)/c8pwd end leg_Insurance_valuation_amount,POLICY_AMT fin_POLICY_AMT,case when nvl(case when  trim(HYISV) <> 0 then trim(HYISV)/c8pwd end,0) = nvl(POLICY_AMT,0) THEN 'TRUE' ELSE 'FALSE' END MATCH_Insurance_val_amount,
case when trim(HYISV) <> 0 and trim(HYIXD)='9999999' THEN to_date('31-12-2099','dd-mm-yyyy') when trim(HYISV) <> 0 then TO_DATE(GET_DATE_FM_BTRV(trim(HYIXD)),'YYYYMMDD')end leg_Insurance_expiry_date,RISK_COVER_END_DATE fin_Insurance_expiry_date,
case when nvl(case when trim(HYISV) <> 0 and trim(HYIXD)='9999999' THEN to_date('31-12-2099','dd-mm-yyyy') when trim(HYISV) <> 0 then TO_DATE(GET_DATE_FM_BTRV(trim(HYIXD)),'YYYYMMDD')end,sysdate) = nvl(RISK_COVER_END_DATE,sysdate) THEN 'TRUE' ELSE 'FALSE' END MATCH_Insurance_expiry_date
 from hypf  
inner join c8pf on c8ccy=hyccy 
inner join gfpf on trim(gfpf.gfcus)= trim(hycus) and nvl(trim(gfpf.gfclc),' ') = nvl(trim(hyclc),' ')
left join map_cif on trim(hycus)=trim(map_cif.gfcus) and nvl(trim(hyclc),' ')=nvl(trim(map_cif.gfclc),' ') 
left join YCCLC5PF01 on   trim(HYCLR)=trim(CCC5_CLR)
left join (select * from map_acc where schm_type<>'OOO')map_acc on leg_branch_id||leg_scan||leg_scas=lpad(CCC5_CLC,4,0)||CCC5_CUS||lpad(CCC5_CSEQ,3,0)
LEFT JOIN (SELECT CC_FINONE_ACCNT,SCMT.SECU_CODE,SCMT.MAX_CEILING_LIM,SCMT.RETAIN_MARGIN_PCNT,SCMT.ITEM_DUE_DATE,SCMT.FREE_TEXT,accounts.orgkey,SECU_VALUE,corporate.CORP_KEY,SCMT.CRNCY_CODE,sip.POLICY_AMT,sip.RISK_COVER_END_DATE FROM TBAADM.SCMT 
left join tbaadm.sip on SCMT.SECU_SRL_NUM = sip.SECU_SRL_NUM and sip.bank_id='01'
left join crmuser.accounts on accounts.CORE_CUST_ID =SCMT.CUST_ID
left join crmuser.corporate on corporate.CORE_CUST_ID =SCMT.CUST_ID 
left join MIGADM.C_COLLIMMOV mic on mic.SECU_SRL_NUM = scmt.SECU_SRL_NUM
 WHERE  SCMT.SECU_TYPE_IND='I' AND SCMT.BANK_ID=GET_PARAM('BANK_ID' )) FIN_COL_IP_RE
 ON TRIM(FIN_COL_IP_RE.orgkey) = TRIM(map_cif.FIN_CIF_ID) 
 and trim(HYCLR) = trim(CC_FINONE_ACCNT) 
where hyclp in('010','011','025')
--and to_number((hypf.hyclv)/power(10,c8ced)) <> 0
--AND (CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') > to_date(get_param('EOD_DATE'),'dd-mm-yyyy') or HYCXD='9999999' OR TRIM(HYCXD) IS NULL) 
