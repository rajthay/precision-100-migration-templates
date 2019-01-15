
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/tda/KW/TD004.txt
select 
TRANSACTION_TYPE||
TRANSACTION_SUB_TYPE||
ACCOUNT_NUMBER||
CURRENCY_CODE||
AMOUNT||
PART_TRANSACTION_TYPE||
VALUE_DATE||
AGENT_EMPLOYEE_INDICATOR||
AGENT_EMPLOYEE_CODE||
FLOW_CODE||
TRANSACTION_END_INDICATOR||';TD004_'||sol_code||'_'||currency_code||'.txt'
from tdt_o_table
order by sol_code,currency_code,part_transaction_type,transaction_end_indicator ;
exit;
 
