select distinct trim(HYCLR) LEG_COLLATERAL_REFERANCE,HYCLP LEG_COL_CODE, 'BGT-KWD'  FIN_MAPPED_COL_CODE,SECU_CODE FIN_SECU_CODE, case when 'BGT-KWD' = SECU_CODE then 'TRUE' ELSE 'FALSE' END MATCH_SECU_CODE,
hyclc||hycus LEG_BENEFICIARY,
trim(CIF) LEG_GUARANTOR,case when map_cif.INDIVIDUAL='Y' then orgkey  else CORP_KEY end FIN_GUARANTOR,
gfpf.GFACO LEG_RM_CODE,
hypf.hyccy LEG_CCY_CODE,FIN_COL_IP_RE.CRNCY_CODE FIN_CRNCY_CODE,case when hypf.hyccy = FIN_COL_IP_RE.CRNCY_CODE THEN 'TRUE' ELSE 'FALSE' END MATCH_CCY_CODE, 
to_char(to_number((hypf.hyclv)/power(10,c8ced)),'9999999999999999999.999') LEG_TOTAL_COLLATERAL_VALUE,to_char(SECU_VALUE,'9999999999999999999.999') FIN_SECU_VALUE,case when to_number((hypf.hyclv)/power(10,c8ced))  =SECU_VALUE then 'TRUE' ELSE 'FALSE' END MATCH_CEILING_LIMIT,
trim(HYNR1)||' '||trim(HYNR2)||' '||trim(HYNR3)||' '||trim(HYNR4) LEG_NOTES,FIN_COL_IP_RE.FREE_TEXT FIN_NOTES,case when TRIM(trim(HYNR1)||' '||trim(HYNR2)||' '||trim(HYNR3)||' '||trim(HYNR4)) = TRIM(FIN_COL_IP_RE.FREE_TEXT) then 'TRUE' ELSE 'FALSE' END MATCH_NOTES
from hypf
inner join c8pf on c8ccy=hyccy 
inner join gfpf on trim(gfpf.gfcus)= trim(hycus) and nvl(trim(gfpf.gfclc),' ') = nvl(trim(hyclc),' ') 
left join map_cif on trim(hycus)=trim(map_cif.gfcus) and nvl(trim(hyclc),' ')=nvl(trim(map_cif.gfclc),' ') 
left join COL_GUARANTOR cg on cg.name = trim(replace(upper(HYNR1),'.','')) 
LEFT JOIN (SELECT SCMT.SECU_CODE,SCMT.MAX_CEILING_LIM,SCMT.RETAIN_MARGIN_PCNT,GAM.FORACID,SCMT.ITEM_DUE_DATE,SCMT.FREE_TEXT,SCMT.CUST_ID,accounts.orgkey,SECU_VALUE,corporate.CORP_KEY,SCMT.CRNCY_CODE FROM TBAADM.SCMT 
left join crmuser.accounts on accounts.CORE_CUST_ID =SCMT.CUST_ID
left join crmuser.corporate on corporate.CORE_CUST_ID =SCMT.CUST_ID 
LEFT JOIN TBAADM.GAM 
ON GAM.ACID = SCMT.LIEN_ACID WHERE  SCMT.SECU_TYPE_IND='R' AND SCMT.BANK_ID=GET_PARAM('BANK_ID')) FIN_COL_IP_RE
 ON --TRIM(FIN_COL_IP_RE.orgkey) = TRIM(map_cif.fin_cif_id) -- AND trim(trim(HYNR1)||' '||trim(HYNR2)||' '||trim(HYNR3)||' '||trim(HYNR4)) like TRIM(FREE_TEXT)||'%'
 --AND 
 round(to_number((hypf.hyclv)/power(10,c8ced)))  = round(FIN_COL_IP_RE.SECU_VALUE)--
where hyclp ='002'; 
