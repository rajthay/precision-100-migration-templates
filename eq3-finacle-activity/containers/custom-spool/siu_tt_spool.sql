-- File Name		: siu_tt_spool.sql
-- File Created for	: Spooling file for SIU TT Spool.
-- Created By		: Kumaresan.B
-- Client		    : EIB
-- Created On		: 21-10-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/core/SIU_TT.txt
select
trim(PR_SRL_NUM)||'|'||
trim(SERIAL_NUM)||'|'||
trim(ENTITY_CRE_FLG)||'|'||
trim(REG_TYPE)||'|'||
trim(REG_SUB_TYPE)||'|'||
trim(PAYSYS_ID)||'|'||
trim(OPER_CHARGE_ACCT)||'|'||
trim(REMIT_ORIGIN_REF)||'|'||
trim(REMIT_ORIGIN_TYPE)||'|'||
trim(REMIT_CRNCY)||'|'||
trim(REMIT_CNTRY_CODE)||'|'||
trim(PURPOSE_OF_REM)||'|'||
trim(RATE_CODE)||'|'||
trim(PARTY_CODE)||'|'||
trim(PARTY_NAME)||'|'||
trim(PARTY_ADDR_1)||'|'||
trim(PARTY_ADDR_2)||'|'||
trim(PARTY_ADDR_3)||'|'||
trim(PARTY_CNTRY_CODE)||'|'||
trim(OTHER_PARTY_CODE)||'|'||
trim(OTHER_PARTY_NAME)||'|'||
trim(OTHER_PARTY_ADDR_1)||'|'||
trim(OTHER_PARTY_ADDR_2)||'|'||
trim(OTHER_PARTY_ADDR_3)||'|'||
trim(OTHER_PARTY_CNTRY)||'|'||
trim(PAYEE_BANK_CODE)||'|'||
trim(PAYEE_BR_CODE)||'|'||
trim(PAYEE_BANK_NAME)||'|'||
trim(PAYEE_BANK_ADDR_1)||'|'||
trim(PAYEE_BANK_ADDR_2)||'|'||
trim(PAYEE_BANK_ADDR_3)||'|'||
trim(PAYEE_BANK_CNTRY)||'|'||
trim(LOCAL_CORRESP_BANK_CODE)||'|'||
trim(LOCAL_CORRESP_BRANCH_CODE)||'|'||
trim(RECEIVER_CORRESP_BANK_CODE)||'|'||
trim(RECEIVER_CORRESP_BRANCH_CODE)||'|'||
trim(RECEIVER_CORRES_BANK_NAME)||'|'||
trim(RECEIVER_CORRES_ADDR_1)||'|'||
trim(RECEIVER_CORRES_ADDR_2)||'|'||
trim(RECEIVER_CORRES_ADDR_3)||'|'||
trim(RECEIVER_CORRES_BANK_CNTRY)||'|'||
trim(CORR_COLL_BANK_CODE)||'|'||
trim(CORR_COLL_BR_CODE)||'|'||
trim(SERIAL_COVER_FLAG)||'|'||
trim(SLA_CATEGORY)||'|'||
trim(DTLS_OF_CHARGE)||'|'||
trim(FREE_CODE1)||'|'||
trim(FREE_CODE2)||'|'||
trim(FREE_CODE3)||'|'||
trim(FREE_CODE4)||'|'||
trim(FREE_CODE5)||'|'||
trim(LCHG_USER_ID)||'|'||
trim(LCHG_TIME)||'|'||
trim(RCRE_USER_ID)||'|'||
trim(RCRE_TIME)||'|'||
trim(TS_CNT)||'|'||
trim(DEL_FLG)||'|'||
trim(TREA_RATE_CODE)||'|'||
trim(NOSTRO_ACCT)||'|'||
trim(BANK_ID)||'|'||
trim(RECEIVER_ACCOUNT_NUMBER)||'|'||
trim(NARRATION_PAYMENT_DETAILS)
from siu_tt_o_table;
exit;
 
