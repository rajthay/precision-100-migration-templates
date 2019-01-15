-- File Name        : cu4_upload.sql
-- File Created for    : Upload file for cu4
-- Created By        : Jgadeesh M
-- Client            : Emirates Islamic Bank
-- Created On        : 25-05-2015
-------------------------------------------------------------------
drop table cif_relation;
create table cif_relation
as 
select rjpf_kw.*,a.fin_cif_id PARENT_CIF,b.fin_cif_id child_cif,b.individual child_indi,a.individual parent_indi
from rjpf rjpf_kw
left join (select fin_cif_id fin_cif_id,gfcus gfcus,gfclc gfclc,individual individual from map_cif where del_flg<>'Y') a on a.gfcus = rjcus and a.gfclc = rjclc
left join (select * from map_cif where del_flg<>'Y') b on b.gfcus = RJRCUS and b.gfclc = RJRCLC
where a.fin_cif_id is not null and b.fin_cif_id is not null;
drop table bgcus_minor; 
create table bgcus_minor 
as
select bgpf_kw.*, gfcod,
case when bgpf_kw.BGDTOB<>0 and  length(bgpf_kw.BGDTOB)=8 and trim(bgdtob) is not null
       and to_number(substr(bgpf_kw.BGDTOB,1,4)) between 1900 and 2017
       and to_number(substr(bgpf_kw.BGDTOB,5,2)) between 1 and 12
       and to_number(substr(bgpf_kw.BGDTOB,7,2)) between 1 and 31
       and check_minor(to_date(bgpf_kw.BGDTOB,'YYYYMMDD')) = 'Y' then 'Y' else 'N' end isminor 
from bgpf bgpf_kw
inner join gfpf gfpf_kw on gfcus = bgcus and trim(gfclc) = trim(bgclc)
where bgcus <> '674068';
truncate table CU4_O_TABLE;
INSERT into CU4_O_TABLE
 SELECT distinct
--    V_ORGKEY            CHAR(50)
PARENT_CIF,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
CHILD_CIF,
--    V_RELATIONSHIP        CHAR(50)
convert_codes('RELATION',rjrel),
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
CHILD_CIF,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
--to_char(CUSTOMERS.START_DATE_WITH_EBG,'DD-MON-YYYY'),
'',--chnaged on 18-01-2016
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
--'RETAIL',
--'Retail',--changed on 19-01-2016
case when child_indi='Y' then 'Retail' else 'Corporate' end,
--'CUSTOMER',
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
--case when parent_indi='Y' and child_indi='Y' then 'Social' 
--when parent_indi='Y' and child_indi='N' then 'Banking' 
--else ' ' end,
case when parent_indi='Y' and trim(rjrel) in ('JAC','JNC','JNP') then 'Social' 
when parent_indi='N' and trim(rjrel) in ('JAC','JNC','JNP') then 'Corporate' 
when  trim(rjrel) in ('OWN') then 'Banking' 
when parent_indi='N' and trim(rjrel) in ('PGP','PRS','PSP','PTC','PTP') then 'ShareHolder' ---shareholder to shareHolder changed on 20-08-2017 as per discussion with sandeep and vijay 
else 'XXX' end --- changed on 30-05-2017 as per 23-05-2017 mail dated
--CIF_CHILD_RELATIONSHIP a
from cif_relation where  (trim(rjrel) in ('JAC','JNC','JNP','OWN') or (parent_indi='N' and trim(rjrel) in ('PGP','PRS','PSP','PTC','PTP')) ) and PARENT_CIF <> CHILD_CIF
union
--------------------Excel sheet provided in shared folder------------------------------- 
 SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
c.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
--convert_codes('RELATION',trim(REL_GROUP_CODE)),
'ShareHolder', --Defaulted As per vijay confirmation on 12-04-2017 --mock3b observation ------shareholder to shareHolder changed on 20-08-2017 as per discussion with sandeep and vijay 
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
c.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
--to_char(CUSTOMERS.START_DATE_WITH_EBG,'DD-MON-YYYY'),
'',--chnaged on 18-01-2016
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
--'RETAIL',
case when c.individual='N' then 'Corporate' else 'Retail' end,--changed on 19-01-2016 changed on 20-08-2017 as per discussion with sandeep requirement
--'CUSTOMER',
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'ShareHolder' ---changed on 30-05-2017 as per mail dt 23-05-2017-----shareholder to shareHolder changed on 20-08-2017 as per discussion with sandeep and vijay 
--CIF_CHILD_RELATIONSHIP a
from related_parties 
inner join map_cif p on p.fin_cif_id=replace(MAIN_ACC_NO,'-')
inner join map_cif c on c.fin_cif_id=replace(REL_ACC_NO,'-')
where p.individual='N';
commit;
INSERT into CU4_O_TABLE
 SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
c.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
--convert_codes('RELATION',trim(REL_GROUP_CODE)),
'ShareHolder', --Defaulted As per vijay confirmation on 12-04-2017 --mock3b observation -----shareholder to shareHolder changed on 20-08-2017 as per discussion with sandeep and vijay 
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
c.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
--to_char(CUSTOMERS.START_DATE_WITH_EBG,'DD-MON-YYYY'),
'',--chnaged on 18-01-2016
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
--'RETAIL',
case when c.individual='N' then 'Corporate' else 'Retail' end,--changed on 19-01-2016 changed on 20-08-2017 as per discussion with sandeep requirement
--'CUSTOMER',
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'ShareHolder' ---changed on 30-05-2017 as per mail dt 23-05-2017-----shareholder to shareHolder changed on 20-08-2017 as per discussion with sandeep and vijay 
--CIF_CHILD_RELATIONSHIP a
from related_parties 
inner join map_cif p on p.fin_cif_id=replace(REL_ACC_NO,'-')
inner join map_cif c on c.fin_cif_id=replace(MAIN_ACC_NO,'-')
where p.individual='N';
commit;
---------------------------POA for joint cif details avaialble --------------------------------
INSERT into CU4_O_TABLE
 SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
c.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
--convert_codes('RELATION',substr(trim(BGRLTN),1,3)),
'POA', --Defaulted As per vijay confirmation on 12-04-2017 --mock3b observation 
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
c.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
'',
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
case when c.individual='N' then 'Corporate' else 'Retail' end,--changed on 19-01-2016 changed on 20-08-2017 as per discussion with sandeep requirement
--'CUSTOMER',
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'Social'
--CIF_CHILD_RELATIONSHIP a
from (SELECT DISTINCT * FROM POA_CUSTOMER) poa 
inner  join map_cif p on nvl(p.GFCLC,'')=nvl(poa.gfCLC,'') and p.GFCUS=poa.gfCUS
inner join map_cif c on nvl(c.GFCLC,'')=nvl(BGCLC,'') and c.GFCUS=BGCUS;
commit;
---------------------------Guarantor for joint cif details avaialble --------------------------------
INSERT into CU4_O_TABLE
 SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
c.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
'GUARANTOR',
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
c.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
'',
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
case when c.individual='N' then 'Corporate' else 'Retail' end,--changed on 19-01-2016 changed on 20-08-2017 as per discussion with sandeep requirement
--'CUSTOMER',
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'Banking'
--CIF_CHILD_RELATIONSHIP a
from (select distinct * from guarantor_customer) gtr 
inner  join map_cif p on nvl(p.GFCLC,'')=nvl(trim(LOC),'') and p.GFCUS=trim(gtr.customer)
inner join map_cif c on nvl(c.GFCLC,'')=nvl(trim(loc1),'') and c.GFCUS=trim(cust_no);
commit;
-------------------------------Guardian-----------------------------------------------------------------
INSERT into CU4_O_TABLE
 SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
c.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
'Guardian',
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
c.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
'',
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
case when c.individual='N' then 'Corporate' else 'Retail' end,--changed on 19-01-2016 changed on 20-08-2017 as per discussion with sandeep requirement
--'CUSTOMER',
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'Social'
--CIF_CHILD_RELATIONSHIP a
from (select distinct * from guardian_customer) gtr 
inner  join map_cif p on nvl(p.GFCLC,'')=nvl(trim(LOC),'') and p.GFCUS=trim(gtr.cus)
inner join cu1_o_table  on p.fin_cif_id =orgkey
inner join map_cif c on nvl(c.GFCLC,'')=nvl(trim(guar_loc),'') and c.GFCUS=trim(guar_cust)
where CUSTOMER_MINOR='Y';
commit;
-------------------------------CONTACT details-----------------------------------------------------------------
INSERT into CU4_O_TABLE
 SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
c.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
'ShareHolder',---changed from contact to shareHolder on 03-10-2017 as per vijay confirmation
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
c.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
'',
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
case when c.individual='N' then 'Corporate' else 'Retail' end,--changed on 19-01-2016 changed on 20-08-2017 as per discussion with sandeep requirement
--'CUSTOMER',
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'Contact' ----changed on 30-05-2017 as per mail date 23-05-2017
--CIF_CHILD_RELATIONSHIP a
from (select distinct * from shareholder_retail) shr 
inner  join map_cif p on nvl(p.GFCLC,'')=nvl(trim(shr.gfclc),'') and p.GFCUS=trim(shr.gfcus)
inner join map_cif c on nvl(c.GFCLC,'')=nvl(trim(bgclc),'') and c.GFCUS=trim(bgcus);
commit;
---------------------------POA for joint cif details avaialble only name avaialble--------------------------------
INSERT into CU4_O_TABLE
SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
jnt.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
--case when PRIM_GFCUS='POA' then 'POA' when PRIM_GFCUS='GTR' then 'GUARANTOR'  when PRIM_GFCUS='GTR' then 'Guardian' end,
'POA',
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
jnt.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
'',
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
'Retail',--changed on 19-01-2016
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'Social'
--CIF_CHILD_RELATIONSHIP a
FROM MAP_CIF_JOINT JNT
inner join (SELECT DISTINCT * FROM poa_customer) poa on trim(poa.BGDIRL)=trim(jnt.doc_id) and trim(cif_name)=trim(BGRLNM)
inner  join map_cif p on nvl(p.GFCLC,'')=nvl(poa.GFCLC,'') and p.GFCUS=poa.GFCUS;
--WHERE PRIM_GFCUS NOT IN ('GUAR','SHARE')
commit;
---------------------------Guarantor for joint cif details avaialble only name avaialble--------------------------------
INSERT into CU4_O_TABLE
SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
jnt.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
--case when PRIM_GFCUS='POA' then 'POA' when PRIM_GFCUS='GTR' then 'GUARANTOR'  when PRIM_GFCUS='GTR' then 'Guardian' end,
'GUARANTOR',
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
jnt.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
'',
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
'Retail',--changed on 19-01-2016
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'Social'
--CIF_CHILD_RELATIONSHIP a
FROM MAP_CIF_JOINT JNT
inner join (SELECT DISTINCT * FROM guarantor_customer) gtr on trim(nvl(trim(cid_no),nvl(trim(COMMERCIAL_REG),passport_no)))=trim(jnt.doc_id) and trim(cif_name)=trim(GUARANTOR_NAME)
inner  join map_cif p on nvl(p.GFCLC,'')=nvl(gtr.loc,'') and p.GFCUS=gtr.customer;
--WHERE PRIM_GFCUS NOT IN ('GUAR','SHARE')
commit;
---------------------------guardian for joint cif details avaialble only name avaialble--------------------------------
INSERT into CU4_O_TABLE
SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
jnt.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
--case when PRIM_GFCUS='POA' then 'POA' when PRIM_GFCUS='GTR' then 'GUARANTOR'  when PRIM_GFCUS='GTR' then 'Guardian' end,
'Guardian',
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
jnt.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
'',
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
'Retail',--changed on 19-01-2016
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'Social'
--CIF_CHILD_RELATIONSHIP a
FROM MAP_CIF_JOINT JNT
inner join (SELECT DISTINCT * FROM guardian_customer) guar on trim(GUARDIAN_CID)=trim(jnt.doc_id) and trim(cif_name)=trim(GUARDIAN_NAME)
inner  join map_cif p on nvl(p.GFCLC,'')=nvl(guar.loc,'') and p.GFCUS=guar.cus
inner join cu1_o_table  on p.fin_cif_id =orgkey
where CUSTOMER_MINOR='Y';
--WHERE PRIM_GFCUS NOT IN ('GUAR','SHARE')
commit;
-------------------------------CONTACT details only name avaialble -----------------------------------------------------------------
INSERT into CU4_O_TABLE
 SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
jnt.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
'ShareHolder',---changed from contact to shareHolder on 03-10-2017 as per vijay confirmation
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
jnt.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
'',
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
'Retail',
--'CUSTOMER',
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'Contact' ----changed on 30-05-2017 as per mail date 23-05-2017
--CIF_CHILD_RELATIONSHIP a
FROM MAP_CIF_JOINT JNT
inner join (SELECT DISTINCT * FROM shareholder_retail) shr on trim(shr.doc_id)=trim(jnt.doc_id) and trim(cif_name)=trim(name)
inner  join map_cif p on nvl(p.GFCLC,'')=nvl(shr.GFCLC,'') and p.GFCUS=shr.GFCUS;
--from map_cif_joint shr inner  join map_cif p on nvl(p.GFCLC,' ')=nvl(shr.GFCLC,'') and p.GFCUS=shr.GFCUS where prim_gfcus='SHARE'
commit;
-------------------------------GUARANTOR Account from mehdi data received-----------------------------------------------------------------
INSERT into CU4_O_TABLE
 SELECT distinct
--    V_ORGKEY            CHAR(50)
p.fin_cif_id,
--    V_CHILDENTITY        CHAR(50)
'CUSTOMER',
--    V_CHILDENTITYID        CHAR(32)
c.fin_cif_id,
--    V_RELATIONSHIP        CHAR(50)
'GUARANTOR',
--    V_TITLE            CHAR(5)
'',
--    V_FIRSTNAME        CHAR(80)
'',
--    V_MIDDLENAME        CHAR(80)
'',
--    V_LASTNAME        CHAR(80)
'',
--    V_DOB            CHAR(17)
'',
--    V_GENDER            CHAR(10)
'',
--    V_ISDEPENDANT        CHAR(1)
'',
--    V_GAURDIANTYPE        CHAR(50)
'', 
--    V_ISPRIMARY        CHAR(1)
'',
--    V_HOUSE_NO        CHAR(10)
'',
--    V_PREMISE_NAME        CHAR(50)
'',
--    V_BUILDING_LEVEL        CHAR(10)
'',
--    V_STREET_NO        CHAR(50)
'',
--    V_STREET_NAME        CHAR(50)
'',
--    V_SUBURB            CHAR(50)
'',
--    V_LOCALITY_NAME        CHAR(50)
'',
--    V_TOWN            CHAR(50)
'',
--    V_DOMICILE        CHAR(50)
'',
--    V_CITY_CODE        CHAR(5)
'.',
--    V_STATE_CODE        CHAR(5)
'.',
--    V_ZIP            CHAR(100)
'999',
--    V_COUNTRY_CODE        CHAR(5)
'ZZZ',
--    V_STATUS_CODE        CHAR(5)
'',
--    V_NEWCONTACTSKEY        CHAR(38)
c.fin_cif_id,
--    V_CIF_ID            CHAR(32)
'',
--    V_START_DATE        CHAR(17)
'',
--    V_PERCENTAGE_BENEFITTED    CHAR(6)
'',
--    V_PHONENO1LOCALCODE    CHAR(20)
'',
--    V_PHONENO1CITYCODE    CHAR(20)
'',
--    V_PHONENO1COUNTRYCODE    CHAR(20)
'',
--    V_WORKEXTENSION        CHAR(20)
'',
--    V_PHONENO2LOCALCODE    CHAR(20)
'',
--    V_PHONENO2CITYCODE    CHAR(20)
'',
--    V_PHONENO2COUNTRYCODE    CHAR(20)
'',
--    V_TELEXLOCALCODE        CHAR(20)
'',
--    V_TELEXCITYCODE        CHAR(20)
'',
--    V_TELEXCOUNTRYCODE    CHAR(20)
'',
--    V_FAXNOLOCALCODE        CHAR(20)
'',
--    V_FAXNOCITYCODE        CHAR(20)
'',
--    V_FAXNOCOUNTRYCODE    CHAR(20)
'',
--    V_PAGERNOLOCALCODE    CHAR(20)
'',
--    V_PAGERNOCITYCODE        CHAR(20)
'',
--    V_PAGERNOCOUNTRYCODDE    CHAR(20)
'',
--    V_EMAIL            CHAR(50)
'',
--    V_CHILDENTITYTYPE        CHAR(50)
case when D.individual='N' then 'Corporate' else 'Retail' end,--changed on 19-01-2016 changed on 20-08-2017 as per discussion with sandeep requirement
--'CUSTOMER',
--    V_BEN_OWN_KEY        CHAR(50)
'',
--    V_BANK_ID            CHAR(8)
get_param('BANK_ID'),
--    V_RELATIONSHIP_ALT1    CHAR(50)
'',
--    V_RELATIONSHIP_CATEGORY    CHAR(99)
'Banking'
--CIF_CHILD_RELATIONSHIP a
from guarantor_account gtr 
inner join map_acc p on trim(fin_acc_num)=trim(EXTERNAL_ACCT)
inner  join (select distinct fin_acc_num,fin_cif_id from map_acc) c on substr(replace(guarantor_account,'-',''),1,10)=substr(c.fin_acc_num,1,10)
inner join map_cif d on c.fin_cif_id=d.fin_cif_id;
commit;
delete from CU4_O_TABLE where orgkey=childentityid;
commit;
exit;
-----------------------------------------------End of Script----------------------------------------------------------------------------- 
