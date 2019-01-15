set head off
set feedback off
set term off
set lines 300
set pagesize 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cifkw/RC005.txt
SELECT trim(ORGKEY)||'|'||
trim(DOCDUEDATE)||'|'||
trim(DOCRECEIVEDDATE)||'|'||
trim(DOCEXPIRYDATE)||'|'||
trim(DOCDELFLG)||'|'||
trim(DOCREMARKS)||'|'||
trim(SCANNED)||'|'||
trim(DOCCODE)||'|'||
trim(DOCDESCR)||'|'||
trim(REFERENCENUMBER)||'|'||
trim(TYPE)||'|'||
trim(ISMANDATORY)||'|'||
trim(SCANREQUIRED)||'|'||
trim(ROLE)||'|'||
trim(DOCTYPECODE)||'|'||
trim(DOCTYPEDESCR)||'|'||
trim(MINDOCSREQD)||'|'||
trim(WAIVEDORDEFEREDDATE)||'|'||
trim(COUNTRYOFISSUE)||'|'||
trim(PLACEOFISSUE)||'|'||
trim(DOCISSUEDATE)||'|'||
trim(IDENTIFICATIONTYPE)||'|'||
trim(CORE_CUST_ID)||'|'||
trim(IS_DOCUMENT_VERIFIED)||'|'||
trim(BEN_OWN_KEY)||'|'||
trim(BANK_ID)||'|'||
trim(DOCTYPEDESCR_ALT1)||'|'||
trim(DOCDESCR_ALT1)||'|'||
trim(IDISSUEORGANISATION)
FROM CU5_O_TABLE; 
spool off;
exit;
