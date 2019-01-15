-- File Name		: treasury_country_limit_spool.sql
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
spool $MIG_PATH/output/finacle/treasurylimit/TREASURY_COUNTRY_LIMIT.TXT
SELECT 
'Response' ||'|'||
'FBO_TYPE' ||'|'||
'LIMIT_NAME' ||'|'||
'USER_LIMIT_TYPE' ||'|'||
'USER_LIMIT_TYPE.SYSTEM_LIMIT_TYPE' ||'|'||
'LIMIT_CCY' ||'|'||
'ALLOCATED_LIMIT' ||'|'||
'EXCESS_ACTION' ||'|'||
'BREACH_LEVEL_TYPE' ||'|'||
'USER_LIMIT_TYPE.EXPOSURE_AGGREGATION_METHOD' ||'|'||
'EXPIRY_DATE' ||'|'||
'ENTITY' ||'|'||
'SUBTYPE' ||'|'||
'DEPT_NAME' ||'|'||
'COUNTRY_CODE' ||'|'||
'COUNTRY_RISK_TYPE' ||'|'||
'ENTITY_NAME' ||'|'||
'ALERT_USER_GROUP' ||'|'||
'EXC_AUTH_PRIV_GROUP' ||'|'||
'REPORT_PRIV_GROUP' ||'|'||
'EMAIL_ID' ||'|'||
'TENOR_START_CODE' ||'|'||
'TENOR_START_YEARS' ||'|'||
'TENOR_START_MONTHS' ||'|'||
'TENOR_START_DAYS' ||'|'||
'TENOR_END_CODE' ||'|'||
'TENOR_END_YEARS' ||'|'||
'TENOR_END_MONTHS' ||'|'||
'TENOR_END_DAYS' 
FROM DUAL
UNION ALL
select
TO_CHAR(
TRIM(RESPONSE                         )||'|'||
TRIM(FBO_TYPE                         )||'|'||
TRIM(LIMIT_NAME                       )||'|'||
TRIM(USER_LIMIT_TYPE                  )||'|'||
TRIM(USER_LIMIT_TYPE_SYS_LIMIT_TYPE   )||'|'||
TRIM(LIMIT_CCY                        )||'|'||
TRIM(LIMIT_AMOUNT                     )||'|'||
TRIM(EXCESS_ACTION                    )||'|'||
TRIM(BREACH_LEVEL_TYPE                )||'|'||
TRIM(USER_LIMIT_TYP_EXP_AGGR_METHOD   )||'|'||
TRIM(EXPIRY_DATE                      )||'|'||
TRIM(ENTITY                           )||'|'||
TRIM(SUBTYPE                          )||'|'||
TRIM(DEPT_NAME                        )||'|'||
TRIM(COUNTRY_CODE                     )||'|'||
TRIM(COUNTRY_RISK_TYPE                )||'|'||
TRIM(ENTITY_NAME                      )||'|'||
TRIM(ALERT_USER_GROUP                 )||'|'||
TRIM(EXC_AUTH_PRIV_GROUP              )||'|'||
TRIM(REPORT_PRIV_GROUP                )||'|'||
TRIM(EMAIL_ID                         )||'|'||
TRIM(TENOR_START_CODE                 )||'|'||
TRIM(TENOR_START_YEARS                )||'|'||
TRIM(TENOR_START_MONTHS               )||'|'||
TRIM(TENOR_START_DAYS                 )||'|'||
TRIM(TENOR_END_CODE                   )||'|'||
TRIM(TENOR_END_YEARS                  )||'|'||
TRIM(TENOR_END_MONTHS                 )||'|'||
TRIM(TENOR_END_DAYS                   )
)
from CPTY_COUNTRY_LIMIT_O_TABLE;
exit; 
