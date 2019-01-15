-- File Name        : cc2_upload.sql
-- File Created for : calling upload proc
-- Created By       : Jagadeesh.M
-- Client           : Emirates Islamic Bank
-- Created On       : 20-05-2011
-------------------------------------------------------------------
drop table  corp_addr_step1;
create table corp_addr_step1
as
select distinct to_char(sxcus)sxcus,to_char(sxclc)sxclc,svseq
from svpf 
inner join (select * from sxpf where trim(sxprim)<>'6' or trim(sxprim) is null)sxpf on sxseq = svseq
union
select gfcus,gfclc,syseq from sypf
inner join map_acc on syab||syan||syas = leg_branch_id||leg_scan||leg_scas
inner join (select * from map_cif )map_cif on map_acc.fin_cif_id = map_cif.fin_cif_id
where trim(syprim)<>'6' or trim(syprim) is null;
---Step 2-------------- Taking only customer address thats prime
drop table corp_addr_step2;
create table corp_addr_step2 as
select distinct a.sxcus,a.sxclc,svseq,trim(sxprim) sxprim,'Prime' addr_type from corp_addr_step1 a
inner join sxpf on sxseq = svseq and a.sxcus = sxpf.sxcus and nvl(a.sxclc,' ') = nvl(sxpf.sxclc,' ')
where trim(sxprim) is null ;
create index corp_addr_step2_idx on corp_addr_step2(sxcus,sxclc,svseq);
drop table corp_addr_step2_temp;
create table corp_addr_step2_temp
as
select distinct a.sxcus,a.sxclc,a.svseq,trim(sxpf.sxprim) sxprim
from corp_addr_step1 a
inner join sxpf on sxpf.sxseq = a.svseq and a.sxcus = sxpf.sxcus and nvl(a.sxclc,' ') = nvl(sxpf.sxclc,' ')
left join corp_addr_step2 c on c.svseq = a.svseq and a.sxcus = c.sxcus and nvl(a.sxclc,' ') = nvl(c.sxclc,' ')
where trim(sxpf.sxprim) is not null and c.sxcus is null; 
---inserting recods that are not prime and remove duplicate address types
insert into corp_addr_step2
select distinct corp_addr_step2_temp.*,' ' from corp_addr_step2_temp where svseq in
(
select max(svseq)
from corp_addr_step2_temp
group by sxcus,sxclc,svseq
);
commit;
---------------step 3 Take from first table those that are not in address table 2 and sypf records that are not duplicate address types
drop table corp_addr_step3_temp;
create table corp_addr_step3_temp
as
select distinct b.*
--,syprim    this is removed because duplicate address svseq comming
from sypf a
inner join corp_addr_step1 b on syseq= b.svseq
left join corp_addr_step2 c on a.syseq = c.svseq
where c.sxcus is null;
insert into corp_addr_step2
select distinct corp_addr_step3_temp.*,' ',' ' from corp_addr_step3_temp where svseq in
(
select max(svseq)
from corp_addr_step3_temp
group by sxcus,sxclc,svseq
);
commit;
-----------------------------------------------------------
DECLARE
CURSOR c1
is
select distinct sxcus,sxclc,svseq,sxprim from corp_addr_step2
where trim(addr_type) is null
order by sxcus,sxclc,svseq;
cus_no nvarchar2(12):= ' ';
v_seq_no number;
v_addr_type nvarchar2(25); 
 BEGIN
v_seq_no:=1;
FOR l_record IN c1
LOOP   
    if cus_no  = l_record.sxcus || nvl(l_record.sxclc,' ') then v_seq_no:= v_seq_no + 1;
    else
    v_seq_no:= 1;
    end if;
    v_addr_type := 'Add'||v_seq_no;
    cus_no :=  l_record.sxcus || nvl(l_record.sxclc,' ');
    update corp_addr_step2 set addr_type = v_addr_type where sxcus = l_record.sxcus and nvl(sxclc, ' ') = nvl(l_record.sxclc,' ')
    and nvl(sxprim, ' ') = nvl(l_record.sxprim, ' ') and svseq = l_record.svseq;
    commit;  
end loop;
commit;
end;
/
------------Phone numbers migrating to one address category--------------------
drop table corp_cust_address_ph;
create table corp_cust_address_ph as 
select distinct sxcus,sxclc,trim(sxprim) sxprim,'ADDR_TYPE' ADDR_TYPE,svpf_kw.svseq, fin_cif_id,gfcod,BGCODT,svpf_kw.SVPZIP, 
 trim(SVNA1)||' '||trim(SVNA2)||' '||trim(SVNA3)||' '||trim(SVNA4)||' '|| trim(SVNA5)||' '|| trim(SVPHN)||' '|| trim(SVFAX)||' '|| trim(SVTLX)||' '|| trim(SVC08) full_address 
from svpf svpf_kw 
inner join sxpf sxpf_kw  on sxpf_kw.sxseq=svpf_kw.svseq
inner join gfpf gfpf_kw  on gfpf_kw.gfcus=sxpf_kw.sxcus and nvl(gfpf_kw.gfclc,' ') = nvl(sxpf_kw.sxclc,' ')
left join  bgpf  on nvl(gfpf_kw.GFCLC,' ')=nvl(bgpf.BGCLC,' ') and gfpf_kw.GFCUS=bgpf.BGCUS
inner join map_cif on map_cif.gfcus = sxpf_kw.sxcus and nvl(map_cif.gfclc,' ') = nvl(sxpf_kw.sxclc,' ')
where trim(sxprim)='6' and MAP_CIF.INDIVIDUAL='N' and del_flg<>'Y' 
and trim(trim(SVNA1)||' '||trim(SVNA2)||' '||trim(SVNA3)||' '||trim(SVNA4)||' '|| trim(SVNA5)||' '|| trim(SVPHN)||' '|| trim(SVFAX)||' '|| trim(SVTLX)||' '|| trim(SVC08))  is not null;
------------Phone numbers migrating to one address category and spliting in to  addr1.addr2 and addr3--------------------
drop table corp_cust_address_ph1;
create table corp_cust_address_ph1 as
select distinct SXCUS,SXCLC,SXPRIM,svseq,ADDR_TYPE,FIN_CIF_ID,gfcod,BGCODT,svpzip,FULL_ADDRESS,trn1,trn2,substrc(org,len_trn1+len_trn2+1,45) trn3
from( 
select SXCUS,SXCLC,SXPRIM,svseq,ADDR_TYPE,FIN_CIF_ID,gfcod,BGCODT,svpzip,FULL_ADDRESS,org,lent,trn1,len_trn1,
case when lent <=90 then substrc(org,len_trn1+1,45) 
else substrc(org,len_trn1+1,
decode(instrc(substrc(org,len_trn1+1,45),' ',-1),0,45,instrc(substrc(org,len_trn1+1,45),' ',-1))) 
end trn2,
length(case when lent <=90 then substrc(org,len_trn1+1,45) 
else substrc(org,len_trn1+1,
decode(instrc(substrc(org,len_trn1+1,45),' ',-1),0,45,instrc(substrc(org,len_trn1+1,45),' ',-1))) 
end ) len_trn2
from 
(select SXCUS,SXCLC,SXPRIM,svseq,ADDR_TYPE,FIN_CIF_ID,gfcod,BGCODT,svpzip,FULL_ADDRESS,length(trim(full_address)) lent,trim(full_address) org,
case when length(trim(full_address))<45 then trim(full_address)
when INSTRc(substrc(trim(full_address),1,45),' ',-1) = 0 then substrc(trim(full_address),1,45)
else substrc(trim(full_address),1,INSTRc(substrc(trim(full_address),1,45),' ',-1))
end
trn1,length(case when length(trim(full_address))<45 then trim(full_address)
when INSTRc(substrc(trim(full_address),1,45),' ',-1) = 0 then substrc(trim(full_address),1,45)
else substrc(trim(full_address),1,INSTRc(substrc(trim(full_address),1,45),' ',-1))
end)len_trn1
from corp_cust_address_ph)aa)bb;
---------------------------------------------------------------------------------------------------
drop table corp_cust_address;
create table corp_cust_address as
select distinct sxcus,sxclc,sxprim,ADDR_TYPE,a.svseq, fin_cif_id,gfcod,BGCODT,b.SVPZIP, 
to_char(trim(svna2)||' '||trim(svna3)||' '||trim(svna4)||' '||trim(svna5)) full_address from corp_addr_step2 a
inner join svpf b on a.svseq=b.svseq
inner join gfpf on  gfpf.gfcus = a.sxcus and nvl(gfpf.gfclc,' ') = nvl(a.sxclc,' ')
left join  bgpf  on nvl(sxclc,' ')=nvl(BGCLC,' ') and sxCUS=BGCUS --added bcoz of error on 10/4/2017
left join map_cif on map_cif.gfcus = a.sxcus and nvl(map_cif.gfclc,' ') = nvl(a.sxclc,' ')
where INDIVIDUAL='N' and trim(trim(svna2)||' '||trim(svna3)||' '||trim(svna4)||' '||trim(svna5)) is not null ;
drop table corp_cust_address1;
create table corp_cust_address1 as
select distinct SXCUS,SXCLC,SXPRIM,svseq,ADDR_TYPE,FIN_CIF_ID,gfcod,BGCODT,svpzip,FULL_ADDRESS,trn1,trn2,substrc(org,len_trn1+len_trn2+1,45) trn3
from( 
select SXCUS,SXCLC,SXPRIM,svseq,ADDR_TYPE,FIN_CIF_ID,gfcod,BGCODT,svpzip,FULL_ADDRESS,org,lent,trn1,len_trn1,
case when lent <=90 then substrc(org,len_trn1+1,45) 
else substrc(org,len_trn1+1,
decode(instrc(substrc(org,len_trn1+1,45),' ',-1),0,45,instrc(substrc(org,len_trn1+1,45),' ',-1))) 
end trn2,
length(case when lent <=90 then substrc(org,len_trn1+1,45) 
else substrc(org,len_trn1+1,
decode(instrc(substrc(org,len_trn1+1,45),' ',-1),0,45,instrc(substrc(org,len_trn1+1,45),' ',-1))) 
end ) len_trn2
from 
(select SXCUS,SXCLC,SXPRIM,svseq,ADDR_TYPE,FIN_CIF_ID,gfcod,BGCODT,svpzip,FULL_ADDRESS,length(trim(full_address)) lent,trim(full_address) org,
case when length(trim(full_address))<45 then trim(full_address)
when INSTRc(substrc(trim(full_address),1,45),' ',-1) = 0 then substrc(trim(full_address),1,45)
else substrc(trim(full_address),1,INSTRc(substrc(trim(full_address),1,45),' ',-1))
end
trn1,length(case when length(trim(full_address))<45 then trim(full_address)
when INSTRc(substrc(trim(full_address),1,45),' ',-1) = 0 then substrc(trim(full_address),1,45)
else substrc(trim(full_address),1,INSTRc(substrc(trim(full_address),1,45),' ',-1))
end)len_trn1
from corp_cust_address)aa)bb;
truncate table CU2CORP_O_TABLE;
INSERT INTO CU2CORP_O_TABLE
select 
--   CORP_KEY         CHAR(50) NULL,
    corp_cust_address1.fin_cif_id,
--   CIF_ID         CHAR(32) NULL,
    corp_cust_address1.fin_cif_id,
-- CORP_REP_KEY         CHAR(38) NULL,
    '',
--   ADDRESSCATEGORY       CHAR(100) NULL,
    case when upper(ADDR_TYPE)= 'PRIME' then 'Registered' 
    --when addr_type='Add6' then to_char('Add'|| to_char(to_number(addr_num)+1)) --- Add6 validation removed becuase sanjay given confirmation on 19-04-2017 for not to migrate.
else addr_type end,     
--   START_DATE         CHAR(17) NULL,
    --case when bgpf.BGINDT<>0 and  length(bgpf.BGINDT)=8 and  to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD')<to_date(bgpf.BGINDT,'YYYYMMDD') and to_date(get_param('EOD_DATE'),'DD-MM-YYYY') > to_date(bgpf.BGINDT,'YYYYMMDD')
    --then to_char(to_date(bgpf.BGINDT,'YYYYMMDD'),'DD-MON-YYYY') else to_char(to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD'),'DD-MON-YYYY') end,
    case when length(trim(corp_cust_address1.BGCODT))=8  and conv_to_valid_date(corp_cust_address1.BGCODT,'YYYYMMDD') is not null then to_char(to_date(corp_cust_address1.BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when GFCOD <> 0  and get_date_fm_btrv(GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end,     --- changed as per vijay mail confirmation on 20-01-2017
--   PhoneNo1LocalCode     CHAR(20) NULL,
    '',
--   PhoneNo1CityCode     CHAR(20) NULL,
    '',
-- PhoneNo1CountryCode      CHAR(20) NULL,
    '',
--   PhoneNo2LocalCode     CHAR(20) NULL,
    '',
--   PhoneNo2CityCode     CHAR(20) NULL,
    '',
--  PhoneNo2CountryCode     CHAR(20) NULL,
    '',
--   FaxNoLocalCode     CHAR(20) NULL,
    '',
--   FaxNoCityCode       CHAR(20) NULL,
    '',
--   FaxNoCountryCode     CHAR(20) NULL,
    '',
--   Email         CHAR(50) NULL,
    '',
--   PagerNoLocalCode       CHAR(20) NULL,
    '',
--   PagerNoCityCode     CHAR(20) NULL,
    '',
--   PagerNoCountryCode     CHAR(20) NULL,
    '',
--   TelexLocalCode     CHAR(20) NULL,
    '',
--   TelexCityCode     CHAR(20) NULL,
    '',
--   TelexCountryCode     CHAR(20) NULL,
    '',
--   HOUSE_NO         CHAR(10) NULL,
    '',
-- PREMISE_NAME         CHAR(50) NULL,
    '',
--   BUILDING_LEVEL     CHAR(10) NULL,
    '',
--   STREET_NO         CHAR(50) NULL,
    '',
-- STREET_NAME         CHAR(50) NULL,
    '',
--   SUBURB         CHAR(50) NULL,
    '',
--   LOCALITY_NAME     CHAR(50) NULL,
    --'A',
    '',
-- TOWN             CHAR(50) NULL,
    '',
--   DOMICILE         CHAR(50) NULL,
    '',
--   v_CITY_CODE         CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_STATE_CODE         CHAR(100)
   -- '.',
   --'ZZZ',
   	'.',-- changed on 05-06-2017 as per vijay confirmation
--  ZIP             CHAR(100) NULL,
     --nvl(svpzip,'000'),
    -- nvl(svpzip,'999'),
    case when Regexp_replace(trim(svpzip),'[-,A-Z,a-z,(,),., ]','') <> '0' then to_char(Regexp_replace(trim(svpzip),'[-,A-Z,a-z,(,),.]','')) else '999' end, --changed on 08-01-2017 as per sandeep and vijay confirmation
-- COUNTRY_CODE         CHAR(100) NULL,
    --nvl(convert_codes('COUNTRY',' '),'.'),
    --nvl(convert_codes('COUNTRY',' '),'ZZZ'),
		'.',-- changed on 05-06-2017 as per vijay confirmation
--   SMALL_STR1         CHAR(50) NULL,
    '',
--   SMALL_STR2         CHAR(50) NULL,
    '',
--   SMALL_STR3         CHAR(50) NULL,
    '',
--   SMALL_STR4         CHAR(50) NULL,
    '',
--   SMALL_STR5         CHAR(50) NULL,
    '',
--   SMALL_STR6         CHAR(50) NULL,
    '',
--   SMALL_STR7         CHAR(50) NULL,
    '',
--   SMALL_STR8         CHAR(50) NULL,
    '',
--   SMALL_STR9         CHAR(50) NULL,
    '',
--  SMALL_STR10         CHAR(50) NULL,
    '',
--   MED_STR1         CHAR(100) NULL,
    '',
--   MED_STR2         CHAR(100) NULL,
    '',
--   MED_STR3         CHAR(100) NULL,
    '',
--   MED_STR4         CHAR(100) NULL,
    '',
--   MED_STR5         CHAR(100) NULL,
    '',
--   MED_STR6         CHAR(100) NULL,
    '',
--   MED_STR7         CHAR(100) NULL,
    '',
--   MED_STR8         CHAR(100) NULL,
    '',
--   MED_STR9         CHAR(100) NULL,
    '',
--   MED_STR10         CHAR(100) NULL,
    '',
--   LARGE_STR1         CHAR(250) NULL,
    '',
--   LARGE_STR2         CHAR(250) NULL,
    '',
--   LARGE_STR3         CHAR(250) NULL,
    '',
--   LARGE_STR4         CHAR(250) NULL,
    '',
--   LARGE_STR5         CHAR(250) NULL,
    '',
--   DATE1         CHAR(17) NULL,
    '',
--   DATE2         CHAR(17) NULL,
    '',
--   DATE3         CHAR(17) NULL,
    '',
--   DATE4         CHAR(17) NULL,
    '',
--   DATE5         CHAR(17) NULL,
    '',
--   DATE6         CHAR(17) NULL,
    '',
--   DATE7         CHAR(17) NULL,
    '',
--   DATE8         CHAR(17) NULL,
    '',
--   DATE9         CHAR(17) NULL,
    '',
--   DATE10         CHAR(17) NULL,
    '',
--   NUMBER1         CHAR(38) NULL,
    '',
--   NUMBER2         CHAR(38) NULL,
    '',
--   NUMBER3         CHAR(38) NULL,
    '',
--   NUMBER4         CHAR(38) NULL,
    '',
--   NUMBER5         CHAR(38) NULL,
    '',
--   NUMBER6         CHAR(38) NULL,
    '',
--   NUMBER7         CHAR(38) NULL,
    '',
--   NUMBER8         CHAR(38) NULL,
    '',
--   NUMBER9         CHAR(38) NULL,
    '',
--   NUMBER10         CHAR(38) NULL,
    '',
--   DECIMAL1         CHAR(25) NULL,
    '',
--   DECIMAL2         CHAR(25) NULL,
    '',
--   DECIMAL3         CHAR(25) NULL,
    '',
--   DECIMAL4         CHAR(25) NULL,
    '',
--   DECIMAL5         CHAR(25) NULL,
    '',
--   DECIMAL6         CHAR(25) NULL,
    '',
--   DECIMAL7         CHAR(25) NULL,
    '',
--   DECIMAL8         CHAR(25) NULL,
    '',
--   DECIMAL9         CHAR(25) NULL,
    '',
--   DECIMAL10         CHAR(25) NULL,
    '',
--   preferredAddrss     CHAR(50) NULL,
     case when upper(ADDR_TYPE)= 'PRIME'  then 'Y' else 'N' end,
--  HoldMailInitiatedBy     CHAR(20) NULL,
   '',
-- HoldMailFlag         CHAR(50) NULL,
   'N',   
--   BusinessCenter     CHAR(50) NULL,
   '',     -- MAPPING TABLE REQUIRED
--   HoldMailReason     CHAR(200) NULL,
    '',   
--   PreferredFormat     CHAR(50) NULL,
    'FREE_TEXT_FORMAT',   
 --   FreeTextAddress     CHAR(2000) NULL,     
    Regexp_replace(trim(FULL_ADDRESS),'[|]',''),-- Need to discuss on these values    
 --   FreeTextLabel     CHAR(200) NULL,
     --'MIGRATED',
     --'ZZZ',
	 	'.',-- changed on 05-06-2017 as per vijay confirmation
--   ADDRESS_PROOF_RCVD     CHAR(1) NULL,
    '',
--   LASTUPDATE_DATE     CHAR(17) NULL,
    '',
--   ADDRESS_LINE1     CHAR(45) NULL,
--case when  svna2 is null and svna3 is null and (svna4 is null or svna4='.') and svna5 is null 
--then nvl(Regexp_replace(substr(trim(nvl(svna1,'')||nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),1,45),'[|]',''),'.')
--else nvl(Regexp_replace(substr(trim(nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),1,45),'[|]',''),'.')
--end,-- Need to discuss on these values
-- nvl(Regexp_replace(trim(trn1),'[|]',''),'ZZZ999'),
 nvl(Regexp_replace(trim(trn1),'[|]',''),'.'),--- as per vijay confirmation on 02-04-2017. changed from 'ZZZ999' to '.'
--   v_ADDRESS_LINE2         CHAR(45)
--case when  svna2 is null and svna3 is null and (svna4 is null or svna4='.') and svna5 is null 
--then nvl(Regexp_replace(substr(trim(nvl(svna1,'')||nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),46,45),'[|]',''),'.')
--else nvl(Regexp_replace(substr(trim(nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),46,45),'[|]',''),'.')
--end,-- Need to discuss on these values
Regexp_replace(trim(trn2),'[|]',''),
--   v_ADDRESS_LINE3         CHAR(45)
--case when  svna2 is null and svna3 is null and (svna4 is null or svna4='.') and svna5 is null 
--then nvl(Regexp_replace(substr(trim(nvl(svna1,'')||nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),91,45),'[|]',''),'.')
--else nvl(Regexp_replace(substr(trim(nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),91,45),'[|]',''),'.')
--end,-- Need to discuss on these values
Regexp_replace(trim(trn3),'[|]',''),
--   BANK_ID         CHAR(8) NULL   
get_param('BANK_ID')
from 
corp_cust_address1 
left join (select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from corp_cust_address  where addr_type<>'Prime' group  by fin_cif_id) cntr on cntr.fin_cif_id=corp_cust_address1.fin_cif_id 
left join  bgpf  on nvl(sxclc,' ')=nvl(BGCLC,' ') and sxCUS=BGCUS;
commit;
INSERT INTO CU2CORP_O_TABLE
select  
--   CORP_KEY         CHAR(50) NULL,
    corp_key,
--  CIF_ID         CHAR(32) NULL,
    corp_key,
-- CORP_REP_KEY         CHAR(38) NULL,
    '',
--   ADDRESSCATEGORY       CHAR(100) NULL,
    'Registered',    
--   START_DATE         CHAR(17) NULL,   
    DATE_OF_INCORPORATION,    
--   PhoneNo1LocalCode     CHAR(20) NULL,
    '',
--   PhoneNo1CityCode     CHAR(20) NULL,
    '',
-- PhoneNo1CountryCode      CHAR(20) NULL,
    '',
--   PhoneNo2LocalCode     CHAR(20) NULL,
    '',
--   PhoneNo2CityCode     CHAR(20) NULL,
    '',
--  PhoneNo2CountryCode     CHAR(20) NULL,
    '',
--   FaxNoLocalCode     CHAR(20) NULL,
    '',
--   FaxNoCityCode       CHAR(20) NULL,
    '',
--   FaxNoCountryCode     CHAR(20) NULL,
    '',
--   Email         CHAR(50) NULL,
    '',
--   PagerNoLocalCode       CHAR(20) NULL,
    '',
--   PagerNoCityCode     CHAR(20) NULL,
    '',
--   PagerNoCountryCode     CHAR(20) NULL,
    '',
--   TelexLocalCode     CHAR(20) NULL,
    '',
--   TelexCityCode     CHAR(20) NULL,
    '',
--   TelexCountryCode     CHAR(20) NULL,
    '',
--   HOUSE_NO         CHAR(10) NULL,
    '',
-- PREMISE_NAME         CHAR(50) NULL,
    '',
--   BUILDING_LEVEL     CHAR(10) NULL,
    '',
--   STREET_NO         CHAR(50) NULL,
    '',
-- STREET_NAME         CHAR(50) NULL,
    '',
--   SUBURB         CHAR(50) NULL,
    '',
--   LOCALITY_NAME     CHAR(50) NULL,
    '',
-- TOWN             CHAR(50) NULL,
    '',
--   DOMICILE         CHAR(50) NULL,
    '',
--   v_CITY_CODE         CHAR(100)
    --'.',
    --'ZZZ',
		'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_STATE_CODE         CHAR(100)
    --'.',
    --'ZZZ',
		'.',-- changed on 05-06-2017 as per vijay confirmation
--  ZIP             CHAR(100) NULL,
    --'000',
    '999',
-- COUNTRY_CODE         CHAR(100) NULL,
  --  'KW',
  --'ZZZ',
  	'.',-- changed on 05-06-2017 as per vijay confirmation
--   SMALL_STR1         CHAR(50) NULL,
    '',
--   SMALL_STR2         CHAR(50) NULL,
    '',
--   SMALL_STR3         CHAR(50) NULL,
    '',
--   SMALL_STR4         CHAR(50) NULL,
    '',
--   SMALL_STR5         CHAR(50) NULL,
    '',
--   SMALL_STR6         CHAR(50) NULL,
    '',
--   SMALL_STR7         CHAR(50) NULL,
    '',
--   SMALL_STR8         CHAR(50) NULL,
    '',
--   SMALL_STR9         CHAR(50) NULL,
    '',
--  SMALL_STR10         CHAR(50) NULL,
    '',
--   MED_STR1         CHAR(100) NULL,
    '',
--   MED_STR2         CHAR(100) NULL,
    '',
--   MED_STR3         CHAR(100) NULL,
    '',
--   MED_STR4         CHAR(100) NULL,
    '',
--   MED_STR5         CHAR(100) NULL,
    '',
--   MED_STR6         CHAR(100) NULL,
    '',
--   MED_STR7         CHAR(100) NULL,
    '',
--   MED_STR8         CHAR(100) NULL,
    '',
--   MED_STR9         CHAR(100) NULL,
    '',
--   MED_STR10         CHAR(100) NULL,
    '',
--   LARGE_STR1         CHAR(250) NULL,
    '',
--   LARGE_STR2         CHAR(250) NULL,
    '',
--   LARGE_STR3         CHAR(250) NULL,
    '',
--   LARGE_STR4         CHAR(250) NULL,
    '',
--   LARGE_STR5         CHAR(250) NULL,
    '',
--   DATE1         CHAR(17) NULL,
    '',
--   DATE2         CHAR(17) NULL,
    '',
--   DATE3         CHAR(17) NULL,
    '',
--   DATE4         CHAR(17) NULL,
    '',
--   DATE5         CHAR(17) NULL,
    '',
--   DATE6         CHAR(17) NULL,
    '',
--   DATE7         CHAR(17) NULL,
    '',
--   DATE8         CHAR(17) NULL,
    '',
--   DATE9         CHAR(17) NULL,
    '',
--   DATE10         CHAR(17) NULL,
    '',
--   NUMBER1         CHAR(38) NULL,
    '',
--   NUMBER2         CHAR(38) NULL,
    '',
--   NUMBER3         CHAR(38) NULL,
    '',
--   NUMBER4         CHAR(38) NULL,
    '',
--   NUMBER5         CHAR(38) NULL,
    '',
--   NUMBER6         CHAR(38) NULL,
    '',
--   NUMBER7         CHAR(38) NULL,
    '',
--   NUMBER8         CHAR(38) NULL,
    '',
--   NUMBER9         CHAR(38) NULL,
    '',
--   NUMBER10         CHAR(38) NULL,
    '',
--   DECIMAL1         CHAR(25) NULL,
    '',
--   DECIMAL2         CHAR(25) NULL,
    '',
--   DECIMAL3         CHAR(25) NULL,
    '',
--   DECIMAL4         CHAR(25) NULL,
    '',
--   DECIMAL5         CHAR(25) NULL,
    '',
--   DECIMAL6         CHAR(25) NULL,
    '',
--   DECIMAL7         CHAR(25) NULL,
    '',
--   DECIMAL8         CHAR(25) NULL,
    '',
--   DECIMAL9         CHAR(25) NULL,
    '',
--   DECIMAL10         CHAR(25) NULL,
    '',
--   preferredAddrss     CHAR(50) NULL,
      'Y',                                         -- MAPPING TABLE REQUIRED
--  HoldMailInitiatedBy     CHAR(20) NULL,
   '',
-- HoldMailFlag         CHAR(50) NULL,
   'N',   
--   BusinessCenter     CHAR(50) NULL,
   '',     -- MAPPING TABLE REQUIRED
--   HoldMailReason     CHAR(200) NULL,
    '',   
--   PreferredFormat     CHAR(50) NULL,
    'FREE_TEXT_FORMAT',   
 --   FreeTextAddress     CHAR(2000) NULL,
    'ADDR NOT AVAILABLE IN  EQU', -- Need to discuss on these values
 --   FreeTextLabel     CHAR(200) NULL,
     --'MIGRATED',
     --'ZZZ',
	 	'.',-- changed on 05-06-2017 as per vijay confirmation
--   ADDRESS_PROOF_RCVD     CHAR(1) NULL,
    '',
--   LASTUPDATE_DATE     CHAR(17) NULL,
    '',
--   ADDRESS_LINE1     CHAR(45) NULL,
    --'ADDRESS_LINE1', -- Need to discuss on these values
    --'ZZZ999',
    '.',--- as per vijay confirmation on 02-04-2017. changed from 'ZZZ999' to '.'
--   v_ADDRESS_LINE2         CHAR(45)
    --'ADDRESS_LINE2', -- Need to discuss on these values
    '',
--   v_ADDRESS_LINE3         CHAR(45)
    --'ADDRESS_LINE3', -- Need to discuss on these values
    '',
--   BANK_ID         CHAR(8) NULL   
    get_param('BANK_ID')
from CU1CORP_O_TABLE where CORP_KEY not in(select distinct CORP_KEY from CU2CORP_O_TABLE where ADDRESSCATEGORY='Registered');
commit;
/*--Trade Finance Adddress
INSERT INTO CU2CORP_O_TABLE
select  distinct 
--   CORP_KEY         CHAR(50) NULL,
    corp_key,
--   CIF_ID         CHAR(32) NULL,
    corp_key,
-- CORP_REP_KEY         CHAR(38) NULL,
    '',
--   ADDRESSCATEGORY       CHAR(100) NULL,
    'Add6',    
--   START_DATE         CHAR(17) NULL,   
    DATE_OF_INCORPORATION,         
--   PhoneNo1LocalCode     CHAR(20) NULL,
    '',
--   PhoneNo1CityCode     CHAR(20) NULL,
    '',
-- PhoneNo1CountryCode      CHAR(20) NULL,
    '',
--   PhoneNo2LocalCode     CHAR(20) NULL,
    '',
--   PhoneNo2CityCode     CHAR(20) NULL,
    '',
--  PhoneNo2CountryCode     CHAR(20) NULL,
    '',
--   FaxNoLocalCode     CHAR(20) NULL,
    '',
--   FaxNoCityCode       CHAR(20) NULL,
    '',
--   FaxNoCountryCode     CHAR(20) NULL,
    '',
--   Email         CHAR(50) NULL,
    '',
--   PagerNoLocalCode       CHAR(20) NULL,
    '',
--   PagerNoCityCode     CHAR(20) NULL,
    '',
--   PagerNoCountryCode     CHAR(20) NULL,
    '',
--   TelexLocalCode     CHAR(20) NULL,
    '',
--   TelexCityCode     CHAR(20) NULL,
    '',
--   TelexCountryCode     CHAR(20) NULL,
    '',
--   HOUSE_NO         CHAR(10) NULL,
    '',
-- PREMISE_NAME         CHAR(50) NULL,
    '',
--   BUILDING_LEVEL     CHAR(10) NULL,
    '',
--   STREET_NO         CHAR(50) NULL,
    '',
-- STREET_NAME         CHAR(50) NULL,
    '',
--   SUBURB         CHAR(50) NULL,
    '',
--   LOCALITY_NAME     CHAR(50) NULL,
    '',
-- TOWN             CHAR(50) NULL,
    '',
--   DOMICILE         CHAR(50) NULL,
    '',
--   v_CITY_CODE         CHAR(100)
    --'.',
    --'ZZZ',
		'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_STATE_CODE         CHAR(100)
    --'.',
    --'ZZZ',
		'.',-- changed on 05-06-2017 as per vijay confirmation
--  ZIP             CHAR(100) NULL,
    nvl(tf.ZIPCODE,'999'),
-- COUNTRY_CODE         CHAR(100) NULL,
    --nvl(tf.COUNTRY,'ZZZ'),
		'.',-- changed on 05-06-2017 as per vijay confirmation
--   SMALL_STR1         CHAR(50) NULL,
    '',
--   SMALL_STR2         CHAR(50) NULL,
    '',
--   SMALL_STR3         CHAR(50) NULL,
    '',
--   SMALL_STR4         CHAR(50) NULL,
    '',
--   SMALL_STR5         CHAR(50) NULL,
    '',
--   SMALL_STR6         CHAR(50) NULL,
    '',
--   SMALL_STR7         CHAR(50) NULL,
    '',
--   SMALL_STR8         CHAR(50) NULL,
    '',
--   SMALL_STR9         CHAR(50) NULL,
    '',
--  SMALL_STR10         CHAR(50) NULL,
    '',
--   MED_STR1         CHAR(100) NULL,
    '',
--   MED_STR2         CHAR(100) NULL,
    '',
--   MED_STR3         CHAR(100) NULL,
    '',
--   MED_STR4         CHAR(100) NULL,
    '',
--   MED_STR5         CHAR(100) NULL,
    '',
--   MED_STR6         CHAR(100) NULL,
    '',
--   MED_STR7         CHAR(100) NULL,
    '',
--   MED_STR8         CHAR(100) NULL,
    '',
--   MED_STR9         CHAR(100) NULL,
    '',
--   MED_STR10         CHAR(100) NULL,
    '',
--   LARGE_STR1         CHAR(250) NULL,
    '',
--   LARGE_STR2         CHAR(250) NULL,
    '',
--   LARGE_STR3         CHAR(250) NULL,
    '',
--   LARGE_STR4         CHAR(250) NULL,
    '',
--   LARGE_STR5         CHAR(250) NULL,
    '',
--   DATE1         CHAR(17) NULL,
    '',
--   DATE2         CHAR(17) NULL,
    '',
--   DATE3         CHAR(17) NULL,
    '',
--   DATE4         CHAR(17) NULL,
    '',
--   DATE5         CHAR(17) NULL,
    '',
--   DATE6         CHAR(17) NULL,
    '',
--   DATE7         CHAR(17) NULL,
    '',
--   DATE8         CHAR(17) NULL,
    '',
--   DATE9         CHAR(17) NULL,
    '',
--   DATE10         CHAR(17) NULL,
    '',
--   NUMBER1         CHAR(38) NULL,
    '',
--   NUMBER2         CHAR(38) NULL,
    '',
--   NUMBER3         CHAR(38) NULL,
    '',
--   NUMBER4         CHAR(38) NULL,
    '',
--   NUMBER5         CHAR(38) NULL,
    '',
--   NUMBER6         CHAR(38) NULL,
    '',
--   NUMBER7         CHAR(38) NULL,
    '',
--   NUMBER8         CHAR(38) NULL,
    '',
--   NUMBER9         CHAR(38) NULL,
    '',
--   NUMBER10         CHAR(38) NULL,
    '',
--   DECIMAL1         CHAR(25) NULL,
    '',
--   DECIMAL2         CHAR(25) NULL,
    '',
--   DECIMAL3         CHAR(25) NULL,
    '',
--   DECIMAL4         CHAR(25) NULL,
    '',
--   DECIMAL5         CHAR(25) NULL,
    '',
--   DECIMAL6         CHAR(25) NULL,
    '',
--   DECIMAL7         CHAR(25) NULL,
    '',
--   DECIMAL8         CHAR(25) NULL,
    '',
--   DECIMAL9         CHAR(25) NULL,
    '',
--   DECIMAL10         CHAR(25) NULL,
    '',
--   preferredAddrss     CHAR(50) NULL,
      'N',                                         -- MAPPING TABLE REQUIRED
--  HoldMailInitiatedBy     CHAR(20) NULL,
   '',
-- HoldMailFlag         CHAR(50) NULL,
   'N',   
--   BusinessCenter     CHAR(50) NULL,
   '',     -- MAPPING TABLE REQUIRED
--   HoldMailReason     CHAR(200) NULL,
    '',   
--   PreferredFormat     CHAR(50) NULL,
    'FREE_TEXT_FORMAT',   
 --   FreeTextAddress     CHAR(2000) NULL,
     Regexp_replace(ADDR1||' '||ADDR2||' '||ADDR3,'[|]',''),
 --   FreeTextLabel     CHAR(200) NULL,
     --'MIGRATED',
     --'ZZZ',
	 	'.',-- changed on 05-06-2017 as per vijay confirmation
--   ADDRESS_PROOF_RCVD     CHAR(1) NULL,
    '',
--   LASTUPDATE_DATE     CHAR(17) NULL,
    '',
--   ADDRESS_LINE1     CHAR(45) NULL,
    case when trim(ADDR1) is not null then ADDR1
    else ADDR2 end,
--   v_ADDRESS_LINE2         CHAR(45)
    case when trim(ADDR1) is null then ''
    else ADDR2 end,
--   v_ADDRESS_LINE3         CHAR(45)
    substr(ADDR3,1,45),
--   BANK_ID         CHAR(8) NULL   
    get_param('BANK_ID')
from TF_CIF_ADDRESS tf
inner join map_cif on map_cif.fin_cif_id=trim(tf.CIF_ID) 
inner join cu1corp_o_table on corp_key=trim(tf.CIF_ID)
where trim(tf.CIF_ID) is not null and INDIVIDUAL='N';
commit; */
-------------------------Phone numbers migrated in to one separate address category--------------------
INSERT INTO CU2CORP_O_TABLE
select distinct 
--   CORP_KEY         CHAR(50) NULL,
    fin_cif_id,
--   CIF_ID         CHAR(32) NULL,
    fin_cif_id,
-- CORP_REP_KEY         CHAR(38) NULL,
    '',
--   ADDRESSCATEGORY       CHAR(100) NULL,
    'PHONENUM',    
--   START_DATE         CHAR(17) NULL,
 --case when bgpf.BGINDT<>0 and  length(bgpf.BGINDT)=8 and  to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD')<to_date(bgpf.BGINDT,'YYYYMMDD') and to_date(get_param('EOD_DATE'),'DD-MM-YYYY') > to_date(bgpf.BGINDT,'YYYYMMDD')
--    then to_char(to_date(bgpf.BGINDT,'YYYYMMDD'),'DD-MON-YYYY') else to_char(to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD'),'DD-MON-YYYY') end,
case when length(trim(corp_cust_address_ph1.BGCODT))=8 and conv_to_valid_date(corp_cust_address_ph1.BGCODT,'YYYYMMDD') is not null then to_char(to_date(corp_cust_address_ph1.BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when GFCOD <> 0  and get_date_fm_btrv(GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end,     --- changed as per vijay mail confirmation on 20-01-2017     
--   PhoneNo1LocalCode     CHAR(20) NULL,
    '',
--   PhoneNo1CityCode     CHAR(20) NULL,
    '',
-- PhoneNo1CountryCode      CHAR(20) NULL,
    '',
--   PhoneNo2LocalCode     CHAR(20) NULL,
    '',
--   PhoneNo2CityCode     CHAR(20) NULL,
    '',
--  PhoneNo2CountryCode     CHAR(20) NULL,
    '',
--   FaxNoLocalCode     CHAR(20) NULL,
    '',
--   FaxNoCityCode       CHAR(20) NULL,
    '',
--   FaxNoCountryCode     CHAR(20) NULL,
    '',
--   Email         CHAR(50) NULL,
    '',
--   PagerNoLocalCode       CHAR(20) NULL,
    '',
--   PagerNoCityCode     CHAR(20) NULL,
    '',
--   PagerNoCountryCode     CHAR(20) NULL,
    '',
--   TelexLocalCode     CHAR(20) NULL,
    '',
--   TelexCityCode     CHAR(20) NULL,
    '',
--   TelexCountryCode     CHAR(20) NULL,
    '',
--   HOUSE_NO         CHAR(10) NULL,
    '',
-- PREMISE_NAME         CHAR(50) NULL,
    '',
--   BUILDING_LEVEL     CHAR(10) NULL,
    '',
--   STREET_NO         CHAR(50) NULL,
    '',
-- STREET_NAME         CHAR(50) NULL,
    '',
--   SUBURB         CHAR(50) NULL,
    '',
--   LOCALITY_NAME     CHAR(50) NULL,
    --'A',
    '',
-- TOWN             CHAR(50) NULL,
    '',
--   DOMICILE         CHAR(50) NULL,
    '',
--   v_CITY_CODE         CHAR(100)
    --'ZZZ' ,                             -- MAPPING TABLE REQUIRED
		'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_STATE_CODE         CHAR(100)
    --'ZZZ',            -- MAPPING TABLE REQUIRED
		'.',-- changed on 05-06-2017 as per vijay confirmation
    --  ZIP             CHAR(100) NULL,
case when Regexp_replace(trim(svpzip),'[-,A-Z,a-z,(,),., ]','') <> '0' then to_char(Regexp_replace(trim(svpzip),'[-,A-Z,a-z,(,),.]','')) else '999' end, --changed on 06-01-2017 as per sandeep and vijay confirmation
-- COUNTRY_CODE         CHAR(100) NULL,
    --'ZZZ',
		'.',-- changed on 05-06-2017 as per vijay confirmation
--   SMALL_STR1         CHAR(50) NULL,
    '',
--   SMALL_STR2         CHAR(50) NULL,
    '',
--   SMALL_STR3         CHAR(50) NULL,
    '',
--   SMALL_STR4         CHAR(50) NULL,
    '',
--   SMALL_STR5         CHAR(50) NULL,
    '',
--   SMALL_STR6         CHAR(50) NULL,
    '',
--   SMALL_STR7         CHAR(50) NULL,
    '',
--   SMALL_STR8         CHAR(50) NULL,
    '',
--   SMALL_STR9         CHAR(50) NULL,
    '',
--  SMALL_STR10         CHAR(50) NULL,
    '',
--   MED_STR1         CHAR(100) NULL,
    '',
--   MED_STR2         CHAR(100) NULL,
    '',
--   MED_STR3         CHAR(100) NULL,
    '',
--   MED_STR4         CHAR(100) NULL,
    '',
--   MED_STR5         CHAR(100) NULL,
    '',
--   MED_STR6         CHAR(100) NULL,
    '',
--   MED_STR7         CHAR(100) NULL,
    '',
--   MED_STR8         CHAR(100) NULL,
    '',
--   MED_STR9         CHAR(100) NULL,
    '',
--   MED_STR10         CHAR(100) NULL,
    '',
--   LARGE_STR1         CHAR(250) NULL,
    '',
--   LARGE_STR2         CHAR(250) NULL,
    '',
--   LARGE_STR3         CHAR(250) NULL,
    '',
--   LARGE_STR4         CHAR(250) NULL,
    '',
--   LARGE_STR5         CHAR(250) NULL,
    '',
--   DATE1         CHAR(17) NULL,
    '',
--   DATE2         CHAR(17) NULL,
    '',
--   DATE3         CHAR(17) NULL,
    '',
--   DATE4         CHAR(17) NULL,
    '',
--   DATE5         CHAR(17) NULL,
    '',
--   DATE6         CHAR(17) NULL,
    '',
--   DATE7         CHAR(17) NULL,
    '',
--   DATE8         CHAR(17) NULL,
    '',
--   DATE9         CHAR(17) NULL,
    '',
--   DATE10         CHAR(17) NULL,
    '',
--   NUMBER1         CHAR(38) NULL,
    '',
--   NUMBER2         CHAR(38) NULL,
    '',
--   NUMBER3         CHAR(38) NULL,
    '',
--   NUMBER4         CHAR(38) NULL,
    '',
--   NUMBER5         CHAR(38) NULL,
    '',
--   NUMBER6         CHAR(38) NULL,
    '',
--   NUMBER7         CHAR(38) NULL,
    '',
--   NUMBER8         CHAR(38) NULL,
    '',
--   NUMBER9         CHAR(38) NULL,
    '',
--   NUMBER10         CHAR(38) NULL,
    '',
--   DECIMAL1         CHAR(25) NULL,
    '',
--   DECIMAL2         CHAR(25) NULL,
    '',
--   DECIMAL3         CHAR(25) NULL,
    '',
--   DECIMAL4         CHAR(25) NULL,
    '',
--   DECIMAL5         CHAR(25) NULL,
    '',
--   DECIMAL6         CHAR(25) NULL,
    '',
--   DECIMAL7         CHAR(25) NULL,
    '',
--   DECIMAL8         CHAR(25) NULL,
    '',
--   DECIMAL9         CHAR(25) NULL,
    '',
--   DECIMAL10         CHAR(25) NULL,
    '',
--   preferredAddrss     CHAR(50) NULL,
    'N',
--  HoldMailInitiatedBy     CHAR(20) NULL,
   '',
-- HoldMailFlag         CHAR(50) NULL,
   'N',   
--   BusinessCenter     CHAR(50) NULL,
   '',     -- MAPPING TABLE REQUIRED
--   HoldMailReason     CHAR(200) NULL,
    '',   
--   PreferredFormat     CHAR(50) NULL,
    'FREE_TEXT_FORMAT',   
 --   FreeTextAddress     CHAR(2000) NULL,     
    Regexp_replace(trim(FULL_ADDRESS),'[|]',''),
 --   FreeTextLabel     CHAR(200) NULL,
     --'MIGRATED',
     --'ZZZ',
	 	'.',-- changed on 05-06-2017 as per vijay confirmation
--   ADDRESS_PROOF_RCVD     CHAR(1) NULL,
    '',
--   LASTUPDATE_DATE     CHAR(17) NULL,
    '',
--   ADDRESS_LINE1     CHAR(45) NULL,
--nvl(Regexp_replace(trim(trn1),'[|]',''),'ZZZ999'),
nvl(Regexp_replace(trim(trn1),'[|]',''),'.'),--- as per vijay confirmation on 02-04-2017. changed from 'ZZZ999' to '.'
--   v_ADDRESS_LINE2         CHAR(45)
Regexp_replace(trim(trn2),'[|]',''),
--   v_ADDRESS_LINE3         CHAR(45)
Regexp_replace(trim(trn3),'[|]',''),
--   BANK_ID         CHAR(8) NULL   
get_param('BANK_ID')
from corp_cust_address_ph1
left join  bgpf   on nvl(trim(sxCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(sxCUS)=trim(bgpf.BGCUS);
commit;
insert into cu2corp_o_table 
select CORP_KEY,CIF_ID,CORP_REP_KEY,'AltLangAdd',START_DATE,PHONENO1LOCALCODE,PHONENO1CITYCODE,PHONENO1COUNTRYCODE,PHONENO2LOCALCODE,PHONENO2CITYCODE,PHONENO2COUNTRYCODE,FAXNOLOCALCODE,FAXNOCITYCODE,FAXNOCOUNTRYCODE,
EMAIL,PAGERNOLOCALCODE,PAGERNOCITYCODE,PAGERNOCOUNTRYCODE,TELEXLOCALCODE,TELEXCITYCODE,TELEXCOUNTRYCODE,HOUSE_NO,PREMISE_NAME,BUILDING_LEVEL,STREET_NO,STREET_NAME,SUBURB,LOCALITY_NAME,TOWN,DOMICILE,CITY_CODE,
STATE_CODE,ZIP,COUNTRY_CODE,SMALL_STR1,SMALL_STR2,SMALL_STR3,SMALL_STR4,SMALL_STR5,SMALL_STR6,SMALL_STR7,SMALL_STR8,SMALL_STR9,SMALL_STR10,MED_STR1,MED_STR2,MED_STR3,MED_STR4,MED_STR5,MED_STR6,MED_STR7,MED_STR8,
MED_STR9,MED_STR10,LARGE_STR1,LARGE_STR2,LARGE_STR3,LARGE_STR4,LARGE_STR5,DATE1,DATE2,DATE3,DATE4,DATE5,DATE6,DATE7,DATE8,DATE9,DATE10,NUMBER1,NUMBER2,NUMBER3,NUMBER4,NUMBER5,NUMBER6,NUMBER7,NUMBER8,NUMBER9,
NUMBER10,DECIMAL1,DECIMAL2,DECIMAL3,DECIMAL4,DECIMAL5,DECIMAL6,DECIMAL7,DECIMAL8,DECIMAL9,DECIMAL10,'N',HOLDMAILINITIATEDBY,HOLDMAILFLAG,BUSINESSCENTER,HOLDMAILREASON,PREFERREDFORMAT,FREETEXTADDRESS,FREETEXTLABEL,
ADDRESS_PROOF_RCVD,LASTUPDATE_DATE,ADDRESS_LINE1,ADDRESS_LINE2,ADDRESS_LINE3,BANK_ID from cu2corp_o_table where ADDRESSCATEGORY='Registered';
commit;
--update cu2corp_o_table set ADDRESSCATEGORY='Registered' where corp_key in(
--select FIN_CIF_ID from corp_cust_address where individual='N' and not exists(select * from 
--cu2corp_o_table where ADDRESSCATEGORY='Registered' and fin_cif_id=corp_key)) and ADDRESSCATEGORY='Head Office';
--commit;
--delete from cu2corp_o_table where rowid not in (select min(rowid) from cu2corp_o_table where ADDRESSCATEGORY='Add6' group by corp_key )
--and ADDRESSCATEGORY='Add6';
commit;
-- Deleteing duplicate addresses added on 29-05-2017 by kumar--
delete from cu2corp_o_table where rowid not in (select min(rowid) from cu2corp_o_table group by corp_key,FREETEXTADDRESS ) and addresscategory not in ('AltLangAdd','Registered','PHONENUM');
commit; 
drop table cu2corp_o_table_temp;
create table cu2corp_o_table_temp as select * from cu2corp_o_table;
truncate table cu2corp_o_table;
insert into cu2corp_o_table select * from cu2corp_o_table_temp where addresscategory in ('AltLangAdd','Registered','PHONENUM');
commit;
insert into cu2corp_o_table 
select CORP_KEY,CIF_ID,CORP_REP_KEY,'Add'||row_number() over (partition by corp_key order by corp_key),to_char(to_date(Start_date,'DD-MM-YYYY'),'DD-MON-YYYY'),PHONENO1LOCALCODE,PHONENO1CITYCODE,PHONENO1COUNTRYCODE,PHONENO2LOCALCODE,PHONENO2CITYCODE,PHONENO2COUNTRYCODE,FAXNOLOCALCODE,FAXNOCITYCODE,FAXNOCOUNTRYCODE,
EMAIL,PAGERNOLOCALCODE,PAGERNOCITYCODE,PAGERNOCOUNTRYCODE,TELEXLOCALCODE,TELEXCITYCODE,TELEXCOUNTRYCODE,HOUSE_NO,PREMISE_NAME,BUILDING_LEVEL,STREET_NO,STREET_NAME,SUBURB,LOCALITY_NAME,TOWN,DOMICILE,CITY_CODE,
STATE_CODE,ZIP,COUNTRY_CODE,SMALL_STR1,SMALL_STR2,SMALL_STR3,SMALL_STR4,SMALL_STR5,SMALL_STR6,SMALL_STR7,SMALL_STR8,SMALL_STR9,SMALL_STR10,MED_STR1,MED_STR2,MED_STR3,MED_STR4,MED_STR5,MED_STR6,MED_STR7,MED_STR8,
MED_STR9,MED_STR10,LARGE_STR1,LARGE_STR2,LARGE_STR3,LARGE_STR4,LARGE_STR5,DATE1,DATE2,DATE3,DATE4,DATE5,DATE6,DATE7,DATE8,DATE9,DATE10,NUMBER1,NUMBER2,NUMBER3,NUMBER4,NUMBER5,NUMBER6,NUMBER7,NUMBER8,NUMBER9,
NUMBER10,DECIMAL1,DECIMAL2,DECIMAL3,DECIMAL4,DECIMAL5,DECIMAL6,DECIMAL7,DECIMAL8,DECIMAL9,DECIMAL10,'N',HOLDMAILINITIATEDBY,HOLDMAILFLAG,BUSINESSCENTER,HOLDMAILREASON,PREFERREDFORMAT,FREETEXTADDRESS,FREETEXTLABEL,
ADDRESS_PROOF_RCVD,LASTUPDATE_DATE,ADDRESS_LINE1,ADDRESS_LINE2,ADDRESS_LINE3,BANK_ID from cu2corp_o_table_temp where ADDRESSCATEGORY not in ('AltLangAdd','Registered','PHONENUM');
commit;
drop table acct_addr_type_corp;
create table acct_addr_type_corp as
select distinct syab||syan||syas leg_acc_num,syseq,addresscategory from ret_addr_step2 a
inner join sypf on a.svseq=syseq
inner join svpf b on b.svseq=syseq
inner join map_acc on syab=leg_branch_id and leg_scan=syan and syas=leg_scas
inner join (select * from cu2corp_o_table where addresscategory not in ('Registered','AltLangAdd')) on trim(svna2)||' '||trim(svna3)||' '||trim(svna4)||' '||trim(svna5)=FREETEXTADDRESS and corp_key=fin_cif_id
where schm_type in('SBA','CAA','ODA','PCA') and trim(syprim) is null  and trim(sxprim) is null ;
exit;
--------------------------------------------------End of Dummy address for Corporate----------------------------------------------------------------------------- 
