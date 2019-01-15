SET SERVEROUTPUT ON buffer 10000000
SET pages 0
SET VERIFY OFF
SET ECHO OFF
SET FLUSH OFF
SET EMBEDDED OFF
SET FEED OFF
SET TERM OFF
SET TRIM ON
SET HEADING OFF
SET LINES 3000
SET TIMING OFF
Set Trimspool On
spool $MIG_PATH/output/finacle/verificationrep/premigr/customeraccts.dat
select
'LEG_BRANCH_ID'||'|'|| 
'LEG_SCAN'||'|'|| 
'LEG_SCAS'||'|'|| 
'LEG_ACC_NUM'||'|'|| 
'LEG_CUST_ID'||'|'|| 
'LEG_CUST_TYPE'||'|'|| 
'LEG_ACCT_TYPE'||'|'|| 
'FIN_ACC_NUM'||'|'|| 
'FIN_CIF_ID'||'|'|| 
'FIN_SOL_ID'||'|'|| 
'INT_TBL_CODE'||'|'|| 
'ACCT_PREF_INT_CR'||'|'|| 
'ACCT_PREF_INT_DR'||'|'|| 
'GL_SUB_HEADCODE'||'|'|| 
'SCHM_TYPE'||'|'|| 
'SCHM_CODE'||'|'|| 
'CURRENCY'||'|'|| 
'DUBAI_ACC_NUM'||'|'|| 
'IBAN_NUM'
from dual
union all
select
to_char(LEG_BRANCH_ID)  ||'|'||
to_char(LEG_SCAN)  ||'|'||
to_char(LEG_SCAS)  ||'|'||
to_char(LEG_ACC_NUM)  ||'|'||
to_char(LEG_CUST_ID)  ||'|'||
to_char(LEG_CUST_TYPE)  ||'|'||
to_char(LEG_ACCT_TYPE)  ||'|'||
to_char(FIN_ACC_NUM)  ||'|'||
to_char(FIN_CIF_ID)  ||'|'||
to_char(FIN_SOL_ID)  ||'|'||
to_char(INT_TBL_CODE)  ||'|'||
to_char(ACCT_PREF_INT_CR)  ||'|'||
to_char(ACCT_PREF_INT_DR)  ||'|'||
to_char(GL_SUB_HEADCODE)  ||'|'||
to_char(SCHM_TYPE)  ||'|'||
to_char(SCHM_CODE)  ||'|'||
to_char(CURRENCY)  ||'|'||
to_char(DUBAI_ACC_NUM)  ||'|'||
to_char(IBAN_NUM)
from map_acc 
where schm_type <> 'OOO';
spool off;
exit;
