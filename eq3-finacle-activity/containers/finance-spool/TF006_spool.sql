
set head off
set feedback off
set term off
set lines 5000
set pages 0
set colsep ''
set trimspool on
spool $MIG_PATH/output/TF/MOCK4A/TF006.txt
SELECT
FUNC_CODE,
SOL_ID,
DC_NUM,
EVENT_AMT,
EVENT_DATE,
EVENT_REMARKS,
REINSTATEMENT_DAY
FROM TF006
ORDER BY TO_DATE(EVENT_DATE,'DD-MM-YYYY');
spool off;
 
