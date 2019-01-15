========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Guarantor.sql 
SELECT EXTERNAL_ACCOUNT,MAP_ACC.LEG_ACC_NUM DEAL_NUM,MAP_ACC.LEG_ACCT_TYPE,MAP_ACC.SCHM_CODE,MAP_ACC.FIN_ACC_NUM dEAL_FIN_ACC_NUM,GUARANTOR_ACCOUNT,relation.FIN_ACC_NUM GUARANTOR_FIN_ACC_NUM
from RETAIL_GUAR_ACCOUNT
inner join map_acc on map_acc.EXTERNAL_ACC= EXTERNAL_ACCOUNT
inner join scpf on scab=map_acc.leg_branch_id and scan=map_acc.leg_scan and scas=map_acc.leg_scas
left join otpf on map_acc.LEG_ACC_NUM=trim(otbrnm)||trim(otdlp)||trim(otdlr)
inner join map_acc relation on trim(replace(GUARANTOR_ACCOUNT,'-',''))=relation.EXTERNAL_ACC
 
