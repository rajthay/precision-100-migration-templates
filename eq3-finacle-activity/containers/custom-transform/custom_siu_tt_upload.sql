
-- File Name         : SIU_TT_UPLOAD.sql
-- File Created for  : Upload file for SI TT upload
-- Created By        : Alavudeen Ali Badusha.R
-- Client        	 : ABK
-- Created On        : 05-07-2017
-------------------------------------------------------------------
truncate table siu_tt_o_table;
insert into siu_tt_o_table
select 
--PR_SRL_NUM                   
--FUND_ACCT_NUM||TRIM(SO_REF),
r5ab||r5an||r5as||R5SOR,
--SERIAL_NUM                   
'',
--ENTITY_CRE_FLG
'',
--REG_TYPE                     
'FORT',
--REG_SUB_TYPE                 
'',
--PAYSYS_ID                    
'SWIFT',
--OPER_CHARGE_ACCT 
FUND_ACCOUNT,
--REMIT_ORIGIN_REF             
'',
--REMIT_ORIGIN_TYPE            
'',
--REMIT_CRNCY                  
'KWD',
--REMIT_CNTRY_CODE             
'KW',
--PURPOSE_OF_REM               
--'120',
'15',---- Based on sandeep mail dt 17-10-2017 changed from 120 to 15.
--RATE_CODE                    
'MID',
--PARTY_CODE                   
'',
--PARTY_NAME                   
Details,
--PARTY_ADDR_1                 
--'AB',
'Kuwait',---- Based on sandeep mail dt 17-10-2017 changed from AB to kuwait.
--PARTY_ADDR_2                 
'BC',
--PARTY_ADDR_3                 
'CD',
--PARTY_CITY_CODE              
'',
--PARTY_STATE_CODE             
'',
--PARTY_CNTRY_CODE             
'',
--PARTY_PIN_CODE               
'',
--OTHER_PARTY_CODE             
'',
--OTHER_PARTY_NAME             
iban,
--OTHER_PARTY_ADDR_1           
--'AB',
data1,
--OTHER_PARTY_ADDR_2           
'BC',
--OTHER_PARTY_ADDR_3           
'CD',
--OTHER_PARTY_CNTRY            
'KW',
--PAYEE_BANK_CODE              
BENEF_BANK,
--PAYEE_BR_CODE                
BENEF_BRANCH,
--PAYEE_BANK_NAME              
'',
--UNQ_BANK_IDENTIFIER          
'',
--PAYEE_BANK_ADDR_1            
'ZZZ',
--PAYEE_BANK_ADDR_2            
'',
--PAYEE_BANK_ADDR_3            
'',
--PAYEE_BANK_CITY              
'',
--PAYEE_BANK_STATE             
'',
--PAYEE_BANK_CNTRY             
'',
--PAYEE_BANK_PIN_CODE          
'',
--LOCAL_CORRESP_BANK_CODE      
'999',
--LOCAL_CORRESP_BRANCH_CODE    
'0',
--RECEIVER_CORRESP_BANK_CODE   
'',
--RECEIVER_CORRESP_BRANCH_CODE 
'',
--RECEIVER_CORRES_BANK_NAME    
'',
--RECEIVER_CORRES_ADDR_1       
'',
--RECEIVER_CORRES_ADDR_2       
'',
--RECEIVER_CORRES_ADDR_3       
'',
--RECEIVER_CORRES_BANK_CNTRY   
'',
--CORR_COLL_BANK_CODE          
'999',
--CORR_COLL_BR_CODE            
'0', ---- Based on sandeep mail dt 17-10-2017 changed from null to 0.
--SERIAL_COVER_FLAG            
'',
--SLA_CATEGORY                 
'CRED',
--DTLS_OF_CHARGE               
'OUR',
--SENDER_TO_RECVR_INFO         
'',
--RECVR_ACCT_TYPE              
'',
--FREE_CODE1                   
'',
--FREE_CODE2                   
'',
--FREE_CODE3                   
'',
--FREE_CODE4                   
'',
--FREE_CODE5                   
'',
--FREE_TEXT                    
'',
--LCHG_USER_ID                 
'',
--LCHG_TIME                    
'',
--RCRE_USER_ID                 
'',
--RCRE_TIME                    
'',
--TS_CNT                       
'',
--DEL_FLG                      
'N',
--TREA_RATE_CODE               
'',
--NOSTRO_ACCT                  
'',
--BANK_ID                      
'01'
from ACTIVE_SI 
inner join siu_tt ON trim(FUND_ACCOUNT)||TRIM(R5SOR) =trim(FUND_ACCT_NUM)||TRIM(SO_REF)
inner join SIU_TT_BANK on BANK_NAME=BENEF_ACCT_NAME
inner join scpf on r5ab||r5an||r5as=scab||scan||scas
WHERE trim(FUND_CCY) = trim(RECV_CCY) and  R5NPR>get_param('EODCYYMMDD') and r5fld>get_param('EODCYYMMDD');
commit;
exit;
 
