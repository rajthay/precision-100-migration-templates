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
spool $MIG_PATH/output/finacle/verificationrep/premigr/cifmapping.dat
select 'CIF_SEQ' ||'|'||
'BASIC_NUMBER' ||'|'||
'EQUATION_BRANCH' ||'|'||
'EQUATION_NEUMONIC_BRANCH' ||'|'||
'FINACLE_CIF_ID' ||'|'||
'CUSTOMER_TYPE' 
FROM DUAL
UNION ALL
select
case when CIF_SEQ = 'Y' then leg_cust_number else '' end ||'|'||
TO_CHAR(gfcpnc) ||'|'||
TO_CHAR(gfbrnm) ||'|'||
TO_CHAR(gfclc) ||'|'||
TO_CHAR(fin_cif_id) ||'|'||
case when individual = 'Y' then 'RETAIL' 
when individual = 'N' then  'CORPORATE' end
from map_cif where del_flg<>'Y';
spool off;
exit;
