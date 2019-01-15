========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
si_tt.sql 
select
r5ab||r5an||r5as||R5SOR PR_SRL_NUM,
REF_NUM FIN_REF_NO,
'SWIFT' PAYSYS_ID,
'KWD' CURRENCY,
FUND_ACCOUNT LEG_FUND_ACCOUNT,
foracid FIN_FUND_ACC,
Details LEG_NAME,
PARTY_NAME FIN_NAME,
case when trim(Details) = trim(PARTY_NAME) then 'TRUE' else 'FALSE' end DETAILS_MATCH,
iban LEG_IBAN,
OTHER_PARTY_NAME FIN_IBAN,
case when trim(iban)=trim(OTHER_PARTY_NAME) then 'TRUE' else 'FALSE' end IBAN_MATCH,
BENEF_BANK LEG_PAYEE_BANK_CODE,
PAYEE_BANK_CODE FIN_PAYEE_BANK_CODE,
case when trim(BENEF_BANK) = trim(PAYEE_BANK_CODE) then 'TRUE' else 'FALSE' end PAYEE_BANK_CODE_MATCH,
BENEF_BRANCH LEG_PAYEE_BR_BRANCH,
PAYEE_BR_CODE FIN_PAYEE_BR_CODE,
case when trim(BENEF_BRANCH)=trim(PAYEE_BR_CODE) then 'TRUE' else 'FALSE' end PAYEE_BR_CODE_MATCH
from ACTIVE_SI 
inner join siu_tt ON trim(FUND_ACCOUNT)||TRIM(R5SOR) =trim(FUND_ACCT_NUM)||TRIM(SO_REF)
inner join SIU_TT_BANK on BANK_NAME=BENEF_ACCT_NAME
inner join scpf on r5ab||r5an||r5as=scab||scan||scas
left join map_acc on leg_branch_id||leg_scan||leg_scas=scab||scan||scas
--left join tbaadm.gam gam on foracid=fin_acc_num
--left join tbaadm.pyrd pyrd on gam.acid=pyrd.acid
left join (select * from tbaadm.pyrd pd
inner join tbaadm.pyrh ph on pd.PR_SRL_NUM=ph.PR_SRL_NUM 
inner join tbaadm.rstd rs on rs.PR_SRL_NUM=ph.PR_SRL_NUM
left join tbaadm.gam on pd.acid=gam.acid)rstd  on r5ab||r5an||r5as||R5SOR= REF_NUM
--inner join tbaadm.rstd on trim(OTHER_PARTY_NAME)=trim(iban) and trim(PARTY_NAME)=trim(Details)
WHERE trim(FUND_CCY) = trim(RECV_CCY) and  R5NPR>get_param('EODCYYMMDD') and r5fld>get_param('EODCYYMMDD') 
