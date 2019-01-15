set head off
set feedback off
set term off
set lines 1200
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cifkw/RC004.txt
SELECT trim(ORGKEY)||'|'||
trim(CHILDENTITY)||'|'||
trim(CHILDENTITYID)||'|'||
trim(RELATIONSHIP)||'|'||
trim(TITLE)||'|'||
trim(FIRSTNAME)||'|'||
trim(MIDDLENAME)||'|'||
trim(LASTNAME)||'|'||
trim(DOB)||'|'||
trim(GENDER)||'|'||
trim(ISDEPENDANT)||'|'||
trim(GAURDIANTYPE)||'|'||
trim(ISPRIMARY)||'|'||
trim(HOUSE_NO)||'|'||
trim(PREMISE_NAME)||'|'||
trim(BUILDING_LEVEL)||'|'||
trim(STREET_NO)||'|'||
trim(STREET_NAME)||'|'||
trim(SUBURB)||'|'||
trim(LOCALITY_NAME)||'|'||
trim(TOWN)||'|'||
trim(DOMICILE)||'|'||
trim(CITY_CODE)||'|'||
trim(STATE_CODE)||'|'||
trim(ZIP)||'|'||
trim(COUNTRY_CODE)||'|'||
trim(STATUS_CODE)||'|'||
trim(NEWCONTACTSKEY)||'|'||
trim(CIF_ID)||'|'||
trim(START_DATE)||'|'||
trim(PERCENTAGE_BENEFITTED)||'|'||
trim(PHONENO1LOCALCODE)||'|'||
trim(PHONENO1CITYCODE)||'|'||
trim(PHONENO1COUNTRYCODE)||'|'||
trim(WORKEXTENSION)||'|'||
trim(PHONENO2LOCALCODE)||'|'||
trim(PHONENO2CITYCODE)||'|'||
trim(PHONENO2COUNTRYCODE)||'|'||
trim(TELEXLOCALCODE)||'|'||
trim(TELEXCITYCODE)||'|'||
trim(TELEXCOUNTRYCODE)||'|'||
trim(FAXNOLOCALCODE)||'|'||
trim(FAXNOCITYCODE)||'|'||
trim(FAXNOCOUNTRYCODE)||'|'||
trim(PAGERNOLOCALCODE)||'|'||
trim(PAGERNOCITYCODE)||'|'||
trim(PAGERNOCOUNTRYCODDE)||'|'||
trim(EMAIL)||'|'||
trim(CHILDENTITYTYPE)||'|'||
trim(BEN_OWN_KEY)||'|'||
trim(BANK_ID)||'|'||
trim(RELATIONSHIP_ALT1)||'|'||
trim(RELATIONSHIP_CATEGORY)
FROM cu4_o_table; 
spool off;
exit;
 