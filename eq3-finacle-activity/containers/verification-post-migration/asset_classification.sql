========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
asset_classification.sql 
select 
fin_acc_num,
map_acc.schm_type,
scc3r LEG_CODE,
MAIN_CLASSIFICATION_USER,
SUB_CLASSIFICATION_USER
from map_acc 
inner join scpf on leg_branch_id||leg_Scan||leg_scas= scab||Scan||Scas
left join (select * from tbaadm.gam where bank_id='01') gam on foracid=fin_acc_num
left join (select * from tbaadm.acd where bank_id='01')acd on gam.acid=acd.B2K_ID
where map_acc.schm_type <> 'OOO' and trim(acc_closed) is null 
