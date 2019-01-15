set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/cif/s_retail_doc.dat
select
'LEG_CLIENT_BRANCH'||'|'||
'LEG_CUST_NUMBER'||'|'||
'FINACLE_SOL_ID'||'|'||
'FINACLE_CIF_ID'||'|'||
'LEG_DOC_CREATION_DATE'||'|'||
'FINACLE_DOC_DATE'||'|'||
'DOC_DATE_MATCH'||'|'||
'LEG_EXP_DATE'||'|'||
'FINACLE_EXP_DATE'||'|'||
'EXP_DATE_MATCH'||'|'||
'LEG_DOCCODE'||'|'||
'FINACLE_DOCCODE'||'|'||
'DOCCODE_MATCH'||'|'||
'LEGACY_DOCDESCR'||'|'||
'FINACLE_DOCDESCR'||'|'||
'LEG_COUNTRYOFISSUE'||'|'||
'FINACLE_COUNTRYOFISSUE'||'|'||
'COUNTRYOFISSUE_MATCH'||'|'||
'LEG_PLACEOFISSUE'||'|'||
'FINACLE_PLACEOFISSUE'||'|'||
'DOCDELFLAG'||'|'||
'LEG_REFERENCENUMBER'||'|'||
'FIN_REFERENCENUMBER'||'|'||
'REFERENCENUMBER_MATCH'||'|'||
'TYPE'||'|'||
'LEG_ISMANDATORY'||'|'||
'FIN_ISMANDATORY'||'|'||
'DOCTYPECODE'||'|'||
'DOCTYPEDESCR'||'|'||
'DOCISSUEDATE'||'|'||
'IDENTIFICATIONTYPE'
from dual
union all
select
to_char(LEG_CLIENT_BRANCH)||'|'||
to_char(LEG_CUST_NUMBER)||'|'||
to_char(FINACLE_SOL_ID)||'|'||
to_char(FINACLE_CIF_ID)||'|'||
to_char(LEG_CLIENT_CREATION_DATE)||'|'||
to_char(FINACLE_DOC_DATE)||'|'||
to_char(DOC_DATE_MATCH)||'|'||
to_char(LEG_EXP_DATE)||'|'||
to_char(FINACLE_EXP_DATE)||'|'||
to_char(EXP_DATE_MATCH)||'|'||
to_char(LEG_DOCCODE)||'|'||
to_char(FINACLE_DOCCODE)||'|'||
to_char(DOCCODE_MATCH)||'|'||
to_char(LEGACY_DOCDESCR)||'|'||
to_char(FINACLE_DOCDESCR)||'|'||
to_char(LEG_COUNTRYOFISSUE)||'|'||
to_char(FINACLE_COUNTRYOFISSUE)||'|'||
to_char(COUNTRYOFISSUE_MATCH)||'|'||
to_char(LEG_PLACEOFISSUE)||'|'||
to_char(FINACLE_PLACEOFISSUE)||'|'||
to_char(DOCDELFLAG)||'|'||
to_char(LEG_REFERENCENUMBER)||'|'||
to_char(FIN_REFERENCENUMBER)||'|'||
to_char(REFERENCENUMBER_MATCH)||'|'||
to_char(TYPE)||'|'||
to_char(LEG_ISMANDATORY)||'|'||
to_char(FIN_ISMANDATORY)||'|'||
to_char(DOCTYPECODE)||'|'||
to_char(DOCTYPEDESCR)||'|'||
to_char(DOCISSUEDATE)||'|'||
to_char(IDENTIFICATIONTYPE)
from rep_doc where trim(SORT1)='STAFF';
exit; 
