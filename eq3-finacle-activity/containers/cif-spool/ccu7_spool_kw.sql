-- File Name		: cu1crop.sql
-- File Created for	: Creation of source table
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 26-05-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 800
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cifkw/CC007.txt
select
trim(CORP_KEY)||'|'||
trim(CORP_REP_KEY)||'|'||
trim(BENEFICIALOWNERKEY)||'|'||
trim(ENTITYTYPE)||'|'||
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
trim(BANK_ID)||'|'||
trim(IDISSUEORGANISATION)
from CU7CORP_O_TABLE; 
exit;
 