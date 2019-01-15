========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
col_tradable_report.sql 

select distinct ASSET_CODE LEG_COLL_REFERENCE,LEG_COL_CODE,COL_CODE FIN_MAPPED_COL_CODE,SECU_CODE FIN_SECU_CODE,case when COL_CODE = SECU_CODE then 'TRUE' ELSE 'FALSE' END MATCH_SECU_CODE,
gfpf.GFCLC||gfpf.GFCUS LEG_CIF_ID,FIN_CIF_ID,
gfpf.GFACO LEG_RM_CODE,
a.UNIT_VALUE LEG_UNIT_VALUE,b.UNIT_VALUE FIN_UNIT_VALUE,case when a.UNIT_VALUE  = b.UNIT_VALUE then 'TRUE' ELSE 'FALSE' END MATCH_UNIT_VALUE,
a.NO_OF_UNITS LEG_NUM_OF_UNITS,b.NUM_OF_UNITS FIN_NUM_OF_UNITS,case when a.NO_OF_UNITS = b.NUM_OF_UNITS then 'TRUE' ELSE 'FALSE' END MATCH_NUM_OF_UNITS,
TOTAL_COLLATERAL_VALUE LEG_TOTAL_COLLATERAL_VALUE,SECU_VALUE FIN_COLLATERAL_VALUE,case when TOTAL_COLLATERAL_VALUE  =SECU_VALUE then 'TRUE' ELSE 'FALSE' END MATCH_COLLATERAL_VALUE,
NOTES LEG_NOTES,FREE_TEXT FIN_NOTES,case when trim(NOTES) =trim(FREE_TEXT) then 'TRUE' ELSE 'FALSE' END MATCH_NOTES,
a.CLIENT_ID LEG_CLIENT_ID,b.CLIENT_ID,case when nvl(trim(a.CLIENT_ID),' ') = nvl(trim(b.CLIENT_ID),' ') then 'TRUE' ELSE 'FALSE' END MATCH_CLIENT_ID,
a.DP_ID LEG_CLIENT_ID,b.DEPOSITORY_ID,case when nvl(trim(a.DP_ID),' ') = nvl(trim(b.DEPOSITORY_ID),' ') then 'TRUE' ELSE 'FALSE' END MATCH_DP_ID
 from COL_TRADEABLE_O_TABLE a
left join (select distinct FIN_COL_CODE,LEG_COL_CODE from COLLATERAL_MAPPING) lm on  FIN_COL_CODE = COL_CODE
left join (
SELECT scmt.UNIT_VALUE,SRL_NUM,scmt.NUM_OF_UNITS,SCMT.SECU_CODE,SCMT.MAX_CEILING_LIM,SCMT.RETAIN_MARGIN_PCNT,GAM.FORACID,SCMT.ITEM_DUE_DATE,SCMT.FREE_TEXT,csd.CUST_ID,
accounts.orgkey,SECU_VALUE,corporate.CORP_KEY,SCMT.CRNCY_CODE,csd.DEPOSITORY_ID,csd.CLIENT_ID FROM TBAADM.SCMT
left join MIGADM.C_COLLTRADE b on b.SECU_SRL_NUM = scmt.SECU_SRL_NUM 
left join tbaadm.csd  on csd.SECU_SRL_NUM = scmt.SECU_SRL_NUM and csd.SECU_LINKAGE_TYPE=scmt.SECU_LINKAGE_TYPE
left join crmuser.accounts on accounts.CORE_CUST_ID =csd.CUST_ID
left join crmuser.corporate on corporate.CORE_CUST_ID =csd.CUST_ID
left join tbaadm.csd on csd.SECU_SRL_NUM = scmt.SECU_SRL_NUM 
LEFT JOIN TBAADM.GAM 
ON GAM.ACID = SCMT.LIEN_ACID WHERE SCMT.SECU_TYPE_IND='S' AND SCMT.BANK_ID=GET_PARAM('BANK_ID')
) b on a.SERIAL_NUMBER = b.SRL_NUM
left join map_cif on CIF_ID = FIN_CIF_ID
left join gfpf on gfpf.GFCUS||gfpf.GFCLC = map_cif.GFCUS||map_cif.GFCLC 
