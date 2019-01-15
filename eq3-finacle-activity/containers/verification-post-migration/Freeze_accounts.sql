========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Freeze_accounts.sql 
select map_acc.LEG_BRANCH_ID,map_acc.LEG_SCAN,map_acc.LEG_SCAS,map_acc.LEG_ACC_NUM,map_acc.FIN_ACC_NUM,map_acc.LEG_CUST_TYPE,map_acc.SCHM_TYPE,
map_acc.SCHM_CODE,SCAI17 SC017,SCAI81 SC081,SCAI83 SC083,SCAI84 SC084,SCAI85 SC085,SCAI92  SC092,scaig4 SC164,
FREZ_CODE,FREZ_REASON_CODE,REF_DESC
from map_acc 
left join scpf on trim(scab)||trim(scan)||trim(scas)=trim(LEG_BRANCH_ID)||trim(LEG_SCAN)||trim(LEG_SCAS)
left join (select * from tbaadm.gam where bank_id='01')gam on gam.foracid=map_acc.fin_acc_num
left join (select * from tbaadm.rct where bank_id='01' and  REF_REC_TYPE='31')rct on gam.FREZ_REASON_CODE=REF_CODE
where map_acc.schm_type in ('SBA','CAA','ODA','PCA') and trim(FREZ_REASON_CODE) is not null 
