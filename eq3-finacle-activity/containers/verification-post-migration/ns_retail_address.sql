set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/cif/ns_retail_address.dat
Select  
'LEG_CUST_BRANCH'||'}'||
'LEG_CLIENT_NO'||'}'||
'FINACLE_SOL_ID'||'}'||
'FINACLE_CIF_ID'||'}'||
'LEG_ADDRESS_CATEGORY'||'}'||
'FINACLE_ADDRESS_CATEGORY'||'}'||
'ADDRESS_CATEGORY_MATCH'||'}'||
'LEG_ADDRESS_LINE1'||'}'||
'FINACLE_ADDRESS_LINE1'||'}'||
'ADDRESS_LINE1_MATCH'||'}'||
'LEG_ADDRESS_LINE2'||'}'||
'FINACLE_ADDRESS_LINE2'||'}'||
'ADDRESS_LINE2_MATCH'||'}'||
'LEG_ADDRESS_LINE3'||'}'||
'FINACLE_ADDRESS_LINE3'||'}'||
'ADDRESS_LINE3_MATCH'||'}'||
'LEG_ZIP'||'}'||
'FIN_ZIP'||'}'||
'ZIP_MATCH'||'}'||
'FINACLE_PREFERRED_ADDRESS'||'}'||
'FREETEXT_ADDRESS'||'}'||
'FREETEXTLABEL'||'}'||
'LEG_MANAGER'||'}'||
'FIN_MANAGER'||'}'||
'TYPE'
from dual
union all
select
to_char(LEG_CUST_BRANCH)||'}'||
to_char(LEG_CLIENT_NO)||'}'||
to_char(FINACLE_SOL_ID)||'}'||
to_char(FINACLE_CIF_ID)||'}'||
to_char(LEG_ADDRESS_CATEGORY)||'}'||
to_char(FINACLE_ADDRESS_CATEGORY)||'}'||
to_char(ADDRESS_CATEGORY_MATCH)||'}'||
to_char(LEG_ADDRESS_LINE1)||'}'||
to_char(FINACLE_ADDRESS_LINE1)||'}'||
to_char(ADDRESS_LINE1_MATCH)||'}'||
to_char(LEG_ADDRESS_LINE2)||'}'||
to_char(FINACLE_ADDRESS_LINE2)||'}'||
to_char(ADDRESS_LINE2_MATCH)||'}'||
to_char(LEG_ADDRESS_LINE3)||'}'||
to_char(FINACLE_ADDRESS_LINE3)||'}'||
to_char(ADDRESS_LINE3_MATCH)||'}'||
to_char(LEG_ZIP)||'}'||
to_char(FIN_ZIP)||'}'||
to_char(ZIP_MATCH)||'}'||
to_char(FINACLE_PREFERRED_ADDRESS)||'}'||
to_char(FIN_FREETEXT_ADDRESS)||'}'||
to_char(FREETEXTLABEL)||'}'||
to_char(LEG_MANAGER)||'}'||
to_char(FIN_MANAGER)||'}'||
to_char(TYPE)
from rep_address where trim(type)<>'STAFF';
exit; 
