========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
treasury_cpty_report.sql 
select cmne OPICS_MNEMONIC,sd_cpty.name, case when trim(cmne) =trim(sd_cpty.name) then 'TRUE' else 'FALSE' end match_mnemonic,
UCCODE,CODE FIN_MNEMONIC, case when trim(UCCODE) =trim(CODE) then 'TRUE' else 'FALSE' end match_UCCODE,
SN,SHORT_NAME_1,case when SN =SHORT_NAME_1 then 'TRUE' else 'FALSE' end MATCH_SHORT_NAME_1,
CFN1,SHORT_NAME_2,case when CFN1 = SHORT_NAME_2 then 'TRUE' else 'FALSE' end MATCH_SHORT_NAME_2
 from cust
left join sd_cpty@ftmig on trim(cmne) = trim(name) and ACTION!='DLT'
left join sd_country@ftmig on sd_country.FBO_ID_NUM = COUR_FBO_ID_NUM
 where trim(cmne) in(
select trim(TREASURY_COUNTERPARTY_MNEMONIC)  from (
select TRIM(TREASURY_COUNTERPARTY_MNEMONIC) TREASURY_COUNTERPARTY_MNEMONIC from corp_COREINTERFACE
union 
select TRIM(TREASURY_COUNTERPARTY_MNEMONIC) from RETAIL_COREINTERFACE
union 
select to_char(NAME) from tr_not_mig_cpty_core_o_table
)
);




select TRIM(cmne)||'-'||TRIM(UCCODE)||'-'||TRIM(SN)||'-'||TRIM(CFN1) OPICS_DATA,
TRIM(sd_cpty.name)||'-'||TRIM(CODE)||'-'||TRIM(SHORT_NAME_1)||'-'||TRIM(SHORT_NAME_2) FIN_DAT,
CASE WHEN TRIM(TRIM(cmne)||'-'||TRIM(UCCODE)||'-'||TRIM(SN)||'-'||TRIM(CFN1)) = TRIM(TRIM(sd_cpty.name)||'-'||TRIM(CODE)||'-'||TRIM(SHORT_NAME_1)||'-'||TRIM(SHORT_NAME_2)) THEN 'TRUE' ELSE 'FALSE' END MATCH_DATA
 from cust
left join sd_cpty@ftmig on trim(cmne) = trim(name) and ACTION!='DLT'
left join sd_country@ftmig on sd_country.FBO_ID_NUM = COUR_FBO_ID_NUM
 where trim(cmne) in(
select trim(TREASURY_COUNTERPARTY_MNEMONIC)  from (
select TRIM(TREASURY_COUNTERPARTY_MNEMONIC) TREASURY_COUNTERPARTY_MNEMONIC from corp_COREINTERFACE
union 
select TRIM(TREASURY_COUNTERPARTY_MNEMONIC) from RETAIL_COREINTERFACE
union 
select to_char(NAME) from tr_not_mig_cpty_core_o_table
)
);




select 
TRIM(cmne) OPICS_MNEMONIC,TRIM(sd_cpty.name) FIN_MNEMONIC, CASE WHEN  TRIM(cmne) = TRIM(sd_cpty.name) THEN 'TRUE' ELSE 'FALSE' END MATCH_MNEMONIC,
TRIM(UCCODE) OPICS_UCCODE,TRIM(CODE) FIN_UCCODE, CASE WHEN  nvl(TRIM(UCCODE),' ') = nvl(TRIM(CODE),' ') THEN 'TRUE' ELSE 'FALSE' END MATCH_UCCODE,
TRIM(CFN1) OPICS_SHORT_NAME1,TRIM(SHORT_NAME_1) FIN_SHORT_NAME1, CASE WHEN  nvl(TRIM(CFN1),' ') = nvl(TRIM(SHORT_NAME_1),' ') THEN 'TRUE' ELSE 'FALSE' END MATCH_SHORT_NAME1,
TRIM(CFN2) OPICS_SHORT_NAME2,TRIM(SHORT_NAME_2) FIN_SHORT_NAME2, CASE WHEN  nvl(TRIM(CFN2),' ') = nvl(TRIM(SHORT_NAME_2),' ') THEN 'TRUE' ELSE 'FALSE' END MATCH_SHORT_NAME2,
TRIM(cmne)||'-'||TRIM(UCCODE)||'-'||TRIM(CFN1)||'-'||TRIM(CFN2) OPICS_DATA,
TRIM(sd_cpty.name)||'-'||TRIM(CODE)||'-'||TRIM(SHORT_NAME_1)||'-'||TRIM(SHORT_NAME_2) FIN_DAT,
CASE WHEN TRIM(TRIM(cmne)||'-'||TRIM(UCCODE)||'-'||TRIM(CFN1)||'-'||TRIM(CFN2)) = TRIM(TRIM(sd_cpty.name)||'-'||TRIM(CODE)||'-'||TRIM(SHORT_NAME_1)||'-'||TRIM(SHORT_NAME_2)) THEN 'TRUE' ELSE 'FALSE' END MATCH_DATA
 from cust
left join sd_cpty@ftmig on trim(cmne) = trim(name) and ACTION!='DLT'
left join sd_country@ftmig on sd_country.FBO_ID_NUM = COUR_FBO_ID_NUM
 where trim(cmne) in(
select trim(TREASURY_COUNTERPARTY_MNEMONIC)  from (
select TRIM(TREASURY_COUNTERPARTY_MNEMONIC) TREASURY_COUNTERPARTY_MNEMONIC from corp_COREINTERFACE
union 
select TRIM(TREASURY_COUNTERPARTY_MNEMONIC) from RETAIL_COREINTERFACE
union 
select to_char(NAME) from tr_not_mig_cpty_core_o_table
)
)