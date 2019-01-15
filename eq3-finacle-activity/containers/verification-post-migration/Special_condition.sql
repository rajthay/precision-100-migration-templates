========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Special_condition.sql 
  select EXTERNAL_ACC EXTERNAL_ACC,map_acc.LEG_BRANCH_ID,map_acc.LEG_SCAN,map_acc.LEG_SCAS,map_acc.LEG_ACC_NUM,map_acc.FIN_ACC_NUM,map_acc.LEG_CUST_TYPE,map_acc.SCHM_TYPE,
map_acc.SCHM_CODE,SCAI17 SC017,SCAI81 SC081,SCAI83 SC083,SCAI84 SC084,FREZ_CODE,FREZ_REASON_CODE,REF_DESC,SCAI85 SC085,nvl(corp.STATUS,acct.status) STATUS,SCAIC7 ,SCAI92  SC092, MODE_OF_OPER_CODE,
scaig4 SC164,scaij2 SCAI192,scaij3 SCAI193,FREE_TEXT_6 FIN_TAJER,scaij4 SCAI194,FREE_TEXT_7 FIN_CHANGE_SIGNATURE,scaig7 SCAI167,SCAIJ6 SCAI196,acct.CUST_HLTH CUST_HLTH,
case when value=nvl(corp.HEALTH_DESC,acct.CUST_HLTH) then 'TRUE' else 'FALSE' end HEALTH_CODE_MATCH,
lang.LOCALETEXT,
scaco
from map_acc 
left join scpf on trim(scab)||trim(scan)||trim(scas)=trim(LEG_BRANCH_ID)||trim(LEG_SCAN)||trim(LEG_SCAS)
left join (select * from tbaadm.gam where bank_id='01')gam on gam.foracid=map_acc.fin_acc_num
left join (select * from tbaadm.rct where bank_id='01' and  REF_REC_TYPE='31')rct on gam.FREZ_REASON_CODE=REF_CODE
left join (select * from tbaadm.gac where bank_id='01')gac on gac.acid=gam.acid
left join map_cif on map_cif.fin_cif_id=map_acc.fin_cif_id
left join crmuser.accounts acct on map_cif.fin_cif_id=orgkey
left join crmuser.corporate corp on map_cif.fin_cif_id=corp.corp_key
left join (select * from crmuser.categories where CATEGORYTYPE='HEALTH_CODE' and bank_id='01')cat on value=nvl(corp.HEALTH_DESC,acct.CUST_HLTH)
left join CRMUSER.CATEGORY_LANG lang on lang.CATEGORYID=cat.CATEGORYID
where map_acc.schm_type in ('SBA','CAA','ODA','PCA')  
