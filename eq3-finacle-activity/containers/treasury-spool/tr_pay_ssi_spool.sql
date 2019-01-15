-- File Name		: tr_ssi_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 28-09-2016
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/treasury/TR_PAY_SSI.TXT
SELECT
'RESPONSE'||'|'||
'SSI_ID'||'|'||
'CPTY_NAME'||'|'||
'SSI_SETTLEMENT_ACTION'||'|'||
'CURRENCY'||'|'||
'DEAL_TYPE'||'|'||
'SSI_DEFAULT'||'|'||
'EFFECTIVE_DATE'||'|'||
'SETT_METHOD'||'|'||
'ENTITY_NAME'||'|'||
'SUBTYPE'||'|'||
'CPTY_ROLE'||'|'||
'SSI_TYPE'||'|'||
'AGENT_INST_FORMAT'||'|'||
'AGENT_INST_BIC'||'|'||
'AGENT_INST_ID'||'|'||
'AGENT_INST_ADDRESS'||'|'||
'NOSTRO_ID'||'|'||
'DEPOSITORY'||'|'||
'ALT_BENEF_ID'||'|'||
'ALT_BENEF_FORMAT'||'|'||
'ALT_BENEF_BIC'
FROM DUAL
UNION ALL
select
TO_CHAR(
trim(RESPONSE               )||'|'||
trim(SSI_ID                 )||'|'||
trim(CPTY_NAME              )||'|'||
trim(SSI_SETTLEMENT_ACTION  )||'|'||
trim(CURRENCY               )||'|'||
trim(DEAL_TYPE              )||'|'||
trim(SSI_DEFAULT            )||'|'||
trim(EFFECTIVE_DATE         )||'|'||
trim(SETT_METHOD            )||'|'||
trim(ENTITY_NAME            )||'|'||
trim(SUBTYPE                )||'|'||
trim(CPTY_ROLE              )||'|'||
trim(SSI_TYPE               )||'|'||
trim(AGENT_INST_FORMAT      )||'|'||
trim(AGENT_INST_BIC         )||'|'||
trim(AGENT_INST_ID          )||'|'||
trim(AGENT_INST_ADDRESS     )||'|'||
trim(NOSTRO_ID              )||'|'||
trim(DEPOSITORY             )||'|'||
trim(ALT_BENEF_ID       )||'|'||
trim(ALT_BENEF_FORMAT   )||'|'||
trim(ALT_BENEF_BIC      )
)
from TREASURY_PAY_SSI_O_TABLE;
exit; 
