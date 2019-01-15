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
spool $MIG_PATH/output/finacle/cifkw/CC002.txt
select
trim(CORP_KEY)||'|'||
trim(CIF_ID)||'|'||
trim(CORP_REP_KEY)||'|'||
trim(ADDRESSCATEGORY)||'|'||
trim(START_DATE)||'|'||
trim(PhoneNo1LocalCode)||'|'||
trim(PhoneNo1CityCode)||'|'||
trim(PhoneNo1CountryCode)||'|'||
trim(PhoneNo2LocalCode)||'|'||
trim(PhoneNo2CityCode)||'|'||
trim(PhoneNo2CountryCode)||'|'||
trim(FaxNoLocalCode)||'|'||
trim(FaxNoCityCode)||'|'||
trim(FaxNoCountryCode)||'|'||
trim(Email)||'|'||
trim(PagerNoLocalCode)||'|'||
trim(PagerNoCityCode)||'|'||
trim(PagerNoCountryCode)||'|'||
trim(TelexLocalCode)||'|'||
trim(TelexCityCode)||'|'||
trim(TelexCountryCode)||'|'||
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
trim(SMALL_STR1)||'|'||
trim(SMALL_STR2)||'|'||
trim(SMALL_STR3)||'|'||
trim(SMALL_STR4)||'|'||
trim(SMALL_STR5)||'|'||
trim(SMALL_STR6)||'|'||
trim(SMALL_STR7)||'|'||
trim(SMALL_STR8)||'|'||
trim(SMALL_STR9)||'|'||
trim(SMALL_STR10)||'|'||
trim(MED_STR1)||'|'||
trim(MED_STR2)||'|'||
trim(MED_STR3)||'|'||
trim(MED_STR4)||'|'||
trim(MED_STR5)||'|'||
trim(MED_STR6)||'|'||
trim(MED_STR7)||'|'||
trim(MED_STR8)||'|'||
trim(MED_STR9)||'|'||
trim(MED_STR10)||'|'||
trim(LARGE_STR1)||'|'||
trim(LARGE_STR2)||'|'||
trim(LARGE_STR3)||'|'||
trim(LARGE_STR4)||'|'||
trim(LARGE_STR5)||'|'||
trim(DATE1)||'|'||
trim(DATE2)||'|'||
trim(DATE3)||'|'||
trim(DATE4)||'|'||
trim(DATE5)||'|'||
trim(DATE6)||'|'||
trim(DATE7)||'|'||
trim(DATE8)||'|'||
trim(DATE9)||'|'||
trim(DATE10)||'|'||
trim(NUMBER1)||'|'||
trim(NUMBER2)||'|'||
trim(NUMBER3)||'|'||
trim(NUMBER4)||'|'||
trim(NUMBER5)||'|'||
trim(NUMBER6)||'|'||
trim(NUMBER7)||'|'||
trim(NUMBER8)||'|'||
trim(NUMBER9)||'|'||
trim(NUMBER10)||'|'||
trim(DECIMAL1)||'|'||
trim(DECIMAL2)||'|'||
trim(DECIMAL3)||'|'||
trim(DECIMAL4)||'|'||
trim(DECIMAL5)||'|'||
trim(DECIMAL6)||'|'||
trim(DECIMAL7)||'|'||
trim(DECIMAL8)||'|'||
trim(DECIMAL9)||'|'||
trim(DECIMAL10)||'|'||
trim(preferredAddrss)||'|'||
trim(HoldMailInitiatedBy)||'|'||
trim(HoldMailFlag)||'|'||
trim(BusinessCenter)||'|'||
trim(HoldMailReason)||'|'||
trim(PreferredFormat)||'|'||
trim(FreeTextAddress)||'|'||
trim(FreeTextLabel)||'|'||
trim(ADDRESS_PROOF_RCVD)||'|'||
trim(LASTUPDATE_DATE)||'|'||
trim(ADDRESS_LINE1)||'|'||
trim(ADDRESS_LINE2)||'|'||
trim(ADDRESS_LINE3)||'|'||
trim(BANK_ID)
from CU2CORP_O_TABLE ;
exit;
 