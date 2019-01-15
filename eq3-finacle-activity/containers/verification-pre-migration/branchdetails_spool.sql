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
spool $MIG_PATH/output/finacle/verificationrep/premigr/branchdetails.dat
select 
'LEG_BRANCH_ID'  ||'|'||
'FINACLE_BRANCH_ID' ||'|'||
'LEG_BRANCH_NAME' ||'|'||
'FINACLE_BRANCH_NAME' ||'|'||
'LEG_ADDR1' ||'|'||
'LEG_ADDR2' ||'|'||
'LEG_ADDR3' ||'|'||
'LEG_ADDR4' ||'|'||
'FINACLE_ADDR1' ||'|'||
'FINACLE_ADDR2' ||'|'||
'FINACLE_ADDR3'
FROM DUAL
UNION ALL
SELECT
TO_CHAR(CABBN)   ||'|'||
TO_CHAR(SOL_ID) ||'|'||
TO_CHAR(CABRN) ||'|'||
TO_CHAR(SOL_DESC)  ||'|'||
TO_CHAR(CABAD1) ||'|'||
TO_CHAR(CABAD2)  ||'|'||
TO_CHAR(CABAD3) ||'|'||
TO_CHAR(CABAD4) ||'|'||
TO_CHAR(ADDR_1) ||'|'||
TO_CHAR(ADDR_2)||'|'||
TO_CHAR(ADDR_3)
 from map_sol
inner join capf on CABBN = map_sol.br_code
left join tbaadm.sol on sol.BR_CODE = map_sol.fin_Sol_id;
spool off;
exit;