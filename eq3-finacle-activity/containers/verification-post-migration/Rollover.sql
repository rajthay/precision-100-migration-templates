========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Rollover.sql 
select fin_cif_id CUSTOMER_NUMBER,leg_branch_id||leg_scan||leg_scas INTERNAL_ACC_NO,external_acc EXTERNAL_NUMBER, fin_acc_num FINACLE_ACC_NO,leg_acc_num DEAL_REF_NO, ossrc ROLLOVER_CODE,
case when map_acc.schm_code='LFR' and trim(ossrc)='A'  and isnumber(substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6))=1 and substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6) is not null and (substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6)) not like '%.%' then to_char('.'||substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6)) 
       when map_acc.schm_code='LFR' and trim(ossrc)='A' then '.250000'
       else ' ' end  ROLLOVER_FEE_PERCENTAGE,
round(((to_date(LIMIT_EXPIRY_DATE,'YYYYMMDD')-to_date(ACCT_OPEN_DATE,'YYYYMMDD'))-10)/30,0) ROLLOVER_MONTHS
from map_acc 
inner join cl001_o_table on trim(acc_num)=fin_acc_num
inner join ospf on osbrnm||trim(osdlp)||trim(osdlr)=leg_acc_num
left join ldpf on ldbrnm||trim(lddlp)||trim(lddlr)=leg_acc_num
left join lcpf on trim(lccmr)=trim(ldcmr)
where map_acc.schm_code='LFR' 
