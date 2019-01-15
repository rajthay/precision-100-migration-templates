-- File Name         : cu2_upload.sql
-- File Created for  : calling upload proc
-- Created By        : Jagadeesh M    
-- Client             : Emirates islamic Bank
-- Created On        : 19-05-2015
-------------------------------------------------------------------
drop table  ret_addr_step1;
create table ret_addr_step1
as
select distinct to_char(sxcus)sxcus,to_char(sxclc)sxclc,svseq
from svpf 
inner join (select * from sxpf where trim(sxprim)<>'6' or trim(sxprim) is null)sxpf on sxseq = svseq
union
select gfcus,gfclc,syseq from sypf
inner join map_acc on syab||syan||syas = leg_branch_id||leg_scan||leg_scas
inner join (select * from map_cif --where  is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
)map_cif on map_acc.fin_cif_id = map_cif.fin_cif_id
where trim(syprim)<>'6' or trim(syprim) is null;
---Step 2-------------- Taking only customer address thats prime
drop table ret_addr_step2;
create table ret_addr_step2 as
select distinct a.sxcus,a.sxclc,svseq,trim(sxprim) sxprim,'Prime' addr_type from ret_addr_step1 a
inner join sxpf on sxseq = svseq and a.sxcus = sxpf.sxcus and nvl(a.sxclc,' ') = nvl(sxpf.sxclc,' ')
where trim(sxprim) is null ;
create index ret_addr_step2_idx on ret_addr_step2(sxcus,sxclc,svseq);
drop table ret_addr_step2_temp;
create table ret_addr_step2_temp
as
select distinct a.sxcus,a.sxclc,a.svseq,trim(sxpf.sxprim) sxprim
from ret_addr_step1 a
inner join sxpf on sxpf.sxseq = a.svseq and a.sxcus = sxpf.sxcus and nvl(a.sxclc,' ') = nvl(sxpf.sxclc,' ')
left join ret_addr_step2 c on c.svseq = a.svseq and a.sxcus = c.sxcus and nvl(a.sxclc,' ') = nvl(c.sxclc,' ')
where trim(sxpf.sxprim) is not null and c.sxcus is null; 
---inserting recods that are not prime and remove duplicate address types
insert into ret_addr_step2
select distinct ret_addr_step2_temp.*,' ' from ret_addr_step2_temp where svseq in
(
select max(svseq)
from ret_addr_step2_temp
group by sxcus,sxclc,svseq
);
commit;
---------------step 3 Take from first table those that are not in address table 2 and sypf records that are not duplicate address types
drop table ret_addr_step3_temp;
create table ret_addr_step3_temp
as
select distinct b.*
--,syprim   this is removed because duplicate address svseq comming
from sypf a
inner join ret_addr_step1 b on syseq= b.svseq
left join ret_addr_step2 c on a.syseq = c.svseq
where c.sxcus is null;
insert into ret_addr_step2
select distinct ret_addr_step3_temp.*,' ',' ' from ret_addr_step3_temp where svseq in
(
select max(svseq)
from ret_addr_step3_temp
group by sxcus,sxclc,svseq
);
commit;
-----------------------------------------------------------
DECLARE
CURSOR c1
is
select sxcus,sxclc,svseq,sxprim from ret_addr_step2
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
    update ret_addr_step2 set addr_type = v_addr_type where sxcus = l_record.sxcus and nvl(sxclc, ' ') = nvl(l_record.sxclc,' ')
    and nvl(sxprim, ' ') = nvl(l_record.sxprim, ' ') and svseq = l_record.svseq;
    commit;  
end loop;
commit;
end;
/
drop table ret_cust_address;
create table ret_cust_address as
select distinct sxcus,sxclc,sxprim,trim(ADDR_TYPE) ADDR_TYPE,a.svseq, fin_cif_id,gfcod,BGCODT,b.SVPZIP, 
to_char(trim(svna2)||' '||trim(svna3)||' '||trim(svna4)||' '||trim(svna5)) full_address from ret_addr_step2 a
inner join svpf b on a.svseq=b.svseq
inner join gfpf on  gfpf.gfcus = a.sxcus and nvl(gfpf.gfclc,' ') = nvl(a.sxclc,' ')
left join  bgpf  on nvl(gfpf.GFCLC,'')=nvl(bgpf.BGCLC,'') and gfpf.GFCUS=bgpf.BGCUS
left join map_cif on map_cif.gfcus = a.sxcus and nvl(map_cif.gfclc,' ') = nvl(a.sxclc,' ')
where INDIVIDUAL='Y' and trim(trim(svna2)||' '||trim(svna3)||' '||trim(svna4)||' '||trim(svna5)) is not null; 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
CREATE INDEX MIGAPPKW.SXINDDD ON MIGAPPKW.RET_CUST_ADDRESS
(FIN_CIF_ID, SVSEQ);
drop table ret_cust_address1;
create table ret_cust_address1 as
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
from ret_cust_address)aa)bb;
----------------------------------------------------------------------------------------------------------------------------------------------------------
------------Phone numbers migrating to one address category--------------------
drop table ret_cust_address_ph;
create table ret_cust_address_ph as 
select distinct sxcus,sxclc,trim(sxprim) sxprim,'ADDR_TYPE' ADDR_TYPE,svpf_kw.svseq, fin_cif_id,gfcod,BGCODT,svpf_kw.SVPZIP, 
 trim(SVNA1)||' '||trim(SVNA2)||' '||trim(SVNA3)||' '||trim(SVNA4)||' '|| trim(SVNA5)||' '|| trim(SVPHN)||' '|| trim(SVFAX)||' '|| trim(SVTLX)||' '|| trim(SVC08) full_address 
from svpf svpf_kw 
inner join sxpf sxpf_kw  on sxpf_kw.sxseq=svpf_kw.svseq
inner join gfpf gfpf_kw  on gfpf_kw.gfcus=sxpf_kw.sxcus and nvl(gfpf_kw.gfclc,' ') = nvl(sxpf_kw.sxclc,' ')
left join  bgpf  on nvl(gfpf_kw.GFCLC,'')=nvl(bgpf.BGCLC,'') and gfpf_kw.GFCUS=bgpf.BGCUS
inner join map_cif on map_cif.gfcus = sxpf_kw.sxcus and nvl(map_cif.gfclc,' ') = nvl(sxpf_kw.sxclc,' ')
where trim(sxprim)='6' and MAP_CIF.INDIVIDUAL='Y' and del_flg<>'Y' 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
 and trim(trim(SVNA1)||' '||trim(SVNA2)||' '||trim(SVNA3)||' '||trim(SVNA4)||' '|| trim(SVNA5)||' '|| trim(SVPHN)||' '|| trim(SVFAX)||' '|| trim(SVTLX)||' '|| trim(SVC08)) is not null;
------------Phone numbers migrating to one address category and spliting in to  addr1.addr2 and addr3--------------------
drop table ret_cust_address_ph1;
create table ret_cust_address_ph1 as
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
from ret_cust_address_ph)aa)bb;
------------------------------------------START TRADE FINANCE CUSTOMER BLOCK----------------------------------------------------------------------------------------------------------------
--DROP TABLE TF_CIF_ADDRESS;
--CREATE TABLE TF_CIF_ADDRESS AS
--select DISTINCT CIF_ID,NVL(TRIM(P.ADDRESS2),'ZZZ999') ADDR1,NVL(TRIM(P.ADDRESS3),'ZZZ999') ADDR2,NVL(TRIM(TRIM(P.ADDRESS4)||' '||TRIM(P.ADDRESS5)),'ZZZ999') ADDR3,COUNTRY COUNTRY,TRIM(ZIPCODE) ZIPCODE
--FROM MASTER_ODS M
--INNER JOIN TF001 T1 ON TRIM(REPLACE(M.MASTER_REF,'/','-'))=TRIM(BG_NUM)
--LEFT JOIN PARTYDTLS_ODS P ON P.KEY97=PCP_PTY
--WHERE FUNC_CODE='A'
--UNION
--select DISTINCT CIF_ID,NVL(TRIM(P.ADDRESS2),'ZZZ999'),NVL(TRIM(P.ADDRESS3),'ZZZ999'),NVL(TRIM(TRIM(P.ADDRESS4)||' '||TRIM(P.ADDRESS5)),'ZZZ999'),COUNTRY,TRIM(ZIPCODE)
--FROM MASTER_ODS M
--INNER JOIN TF002 T2 ON TRIM(REPLACE(M.MASTER_REF,'/','-'))=TRIM(BG_NUM)
--LEFT JOIN PARTYDTLS_ODS P ON P.KEY97=PCP_PTY
--WHERE FUNC_CODE='A'
--UNION
--select DISTINCT DC_CIF_ID,NVL(TRIM(P.ADDRESS2),'ZZZ999'),NVL(TRIM(P.ADDRESS3),'ZZZ999'),NVL(TRIM(TRIM(P.ADDRESS4)||' '||TRIM(P.ADDRESS5)),'ZZZ999'),COUNTRY,TRIM(ZIPCODE)
--FROM MASTER_ODS M
--INNER JOIN TF004 T4 ON TRIM(REPLACE(M.MASTER_REF,'/','-'))=TRIM(DC_NUM)
--LEFT JOIN PARTYDTLS_ODS P ON P.KEY97=PCP_PTY
--WHERE FUNC_CODE='S'
--UNION
--select DISTINCT DC_CIF_ID,NVL(TRIM(P.ADDRESS2),'ZZZ999'),NVL(TRIM(P.ADDRESS3),'ZZZ999'),NVL(TRIM(TRIM(P.ADDRESS4)||' '||TRIM(P.ADDRESS5)),'ZZZ999'),COUNTRY,TRIM(ZIPCODE)
--FROM MASTER_ODS M
--INNER JOIN TF005 T5 ON TRIM(REPLACE(M.MASTER_REF,'/','-'))=TRIM(DC_NUM)
--LEFT JOIN PARTYDTLS_ODS P ON P.KEY97=PCP_PTY
--WHERE FUNC_CODE='S'
--UNION
--select DISTINCT CIFID,NVL(TRIM(P.ADDRESS2),'ZZZ999'),NVL(TRIM(P.ADDRESS3),'ZZZ999'),NVL(TRIM(TRIM(P.ADDRESS4)||' '||TRIM(P.ADDRESS5)),'ZZZ999'),P.COUNTRY,TRIM(P.ZIPCODE)
--FROM MASTER_ODS M
--INNER JOIN TF009 T9 ON TRIM(REPLACE(M.MASTER_REF,'/','-'))=TRIM(BILLID)
--LEFT JOIN COLLMASTER_ODS CO ON CO.KEY97=M.KEY97
--LEFT JOIN PARTYDTLS_ODS P ON P.KEY97=PCP_PTY
--WHERE FUNC_CODE='G'
--UNION
--select DISTINCT CIFID,NVL(TRIM(P.ADDRESS2),'ZZZ999'),NVL(TRIM(P.ADDRESS3),'ZZZ999'),NVL(TRIM(TRIM(P.ADDRESS4)||' '||TRIM(P.ADDRESS5)),'ZZZ999'),P.COUNTRY,TRIM(P.ZIPCODE)--,P.CUS_MNM,G.GFCUS1
--FROM MASTER_ODS M
--INNER JOIN TF010 T10 ON TRIM(REPLACE(M.MASTER_REF,'/','-'))=TRIM(BILLID)
--LEFT JOIN COLLMASTER_ODS CO ON CO.KEY97=M.KEY97
--LEFT JOIN PARTYDTLS_ODS P ON P.KEY97=NPCP_PTY
--LEFT JOIN GFPF_ODS G ON TRIM(G.GFCUS1)=TRIM(P.CUS_MNM)
--WHERE FUNCCODE='G'
--UNION
--select DISTINCT DC_CIF_ID,NVL(TRIM(P.ADDRESS2),'ZZZ999') ADDR1,NVL(TRIM(P.ADDRESS3),'ZZZ999') ADDR2,NVL(TRIM(TRIM(P.ADDRESS4)||' '||TRIM(P.ADDRESS5)),'ZZZ999') ADDR3,COUNTRY COUNTRY,TRIM(ZIPCODE) ZIPCODE
--FROM MASTER_ODS M
--INNER JOIN LCMASTER_ODS LC ON LC.KEY97=M.KEY97
--INNER JOIN TF005 T1 ON TRIM(REPLACE(M.MASTER_REF,'/','-'))=TRIM(DC_NUM)
--LEFT JOIN PARTYDTLS_ODS P ON P.KEY97=BEN_PTY
--WHERE FUNC_CODE='E';
--COMMIT;
--DELETE FROM TF_CIF_ADDRESS where rowid not in( select min(rowid) from TF_CIF_ADDRESS group by trim(CIF_ID));
--COMMIT;
--create index TF_CIF_ADDRESS_org on TF_CIF_ADDRESS(cif_id);
------------------------------------------END TRADE FINANCE CUSTOMER BLOCK----------------------------------------------------------------------------------------------------------------
truncate table CU2_O_TABLE;
INSERT INTO CU2_O_TABLE
select distinct
--   v_ORGKEY               CHAR(32)
    FIN_CIF_ID,
--   v_ADDRESSCATEGORY         CHAR(100)
   -- trim(fin_addr_type),
       'Mailing',
    --convert_codes('ADDR_CATEGORY',ADDRESSES.ADDRESS_TYPE),    
--   v_START_DATE          CHAR(17)
--to_char(to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD'),'DD-MON-YYYY'),
case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when GFCOD <> 0  and get_date_fm_btrv(GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--   v_PhoneNo1LocalCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CityCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CountryCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2LocalCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CityCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CountryCode      CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_WorkExtension         CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoLocalCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCityCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCountryCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_Email               CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoLocalCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCityCode          CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCountryCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexLocalCode             CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexCityCode          CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexCountryCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_HOUSE_NO              CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_PREMISE_NAME         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_BUILDING_LEVEL         CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_STREET_NO         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_STREET_NAME         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_SUBURB             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_LOCALITY_NAME          CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_TOWN             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_DOMICILE             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_CITY_CODE         CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_STATE_CODE         CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ZIP               CHAR(100)
    --nvl(Regexp_replace(substr(trim(migr.ZIP),1,10),'[|]',''),'000'),
    --nvl(svpzip,'999'),--chnaged on 05-01-2016
    case when Regexp_replace(trim(svpzip),'[-,A-Z,a-z,(,),., ]','') <> '0' then to_char(Regexp_replace(trim(svpzip),'[-,A-Z,a-z,(,),.]','')) else '999' end, --changed on 08-01-2017 as per sandeep and vijay confirmation
--   v_COUNTRY_CODE          CHAR(100)
    --nvl(convert_codes('COUNTRY',' '),'ZZZ'),
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ADDRESS_LINE1          CHAR(45)
    --nvl(Regexp_replace(substr(trim(nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),1,45),'[|]',''),'.'),-- Need to discuss on these values
    --nvl(Regexp_replace(trim(trn1),'[|]',''),'ZZZ999'),
    nvl(Regexp_replace(trim(trn1),'[|]',''),'.'),--default value changed on 03-04-2017 as per vijay confirmation on 02-04-2017
--   v_ADDRESS_LINE2         CHAR(45)
    --nvl(Regexp_replace(substr(trim(nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),46,45),'[|]',''),'.'),-- Need to discuss on these values
     Regexp_replace(trim(trn2),'[|]',''),
--   v_ADDRESS_LINE3         CHAR(45)
    --nvl(Regexp_replace(substr(trim(nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),91,45),'[|]',''),'.'),-- Need to discuss on these values
    Regexp_replace(trim(trn3),'[|]',''),
--   v_END_DATE             CHAR(17)
--to_char(to_date('01-NOV-2099','DD-MON-YYYY') + row_number() over (partition by migr.fin_cif_id order by migr.fin_cif_id,migr.ADDR_TYPE),'DD-MON-YYYY'),
'31-DEC-2099',
--   v_SMALL_STR1         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR2         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR3         CHAR(50)
    '',                                             -- DEFAULT SET TO BLANK
--   v_SMALL_STR4         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR5         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR6         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR7         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR8         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR9         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR10         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR1             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR2             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR3             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR4             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR5             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR6             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR7             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR8             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR9             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR10         CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR1         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR2         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR3         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR4         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR5         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE1             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE2             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE3             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE4             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE5             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE6             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE7             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE8             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE9             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE10             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER1             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER2             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER3             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER4             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER5             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER6             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER7             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER8             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER9             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER10             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL1             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL2             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL3             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL4             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL5             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL6             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL7             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL8             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL9             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL10         CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_CIFID             CHAR(32)
    FIN_CIF_ID,                         -- Need to check for this field
--   v_preferredAddrss         CHAR(50)
    'Y',                                        -- MAPPING TABLE REQUIRED
--   v_HoldMailInitiatedBy     CHAR(50)
    '',                                         -- MAPPING TABLE REQUIRED
--   v_HoldMailFlag         CHAR(50)
    'N',                                         -- MAPPING TABLE REQUIRED
--   v_BusinessCenter         CHAR(50)
    '',                                          -- MAPPING TABLE REQUIRED
--   v_HoldMailReason         CHAR(200)
    '',                                          --  MAPPING TABLE REQUIRED
--   v_PreferredFormat         CHAR(50)
    'FREE_TEXT_FORMAT',                          -- MAPPING TABLE REQUIRED
--   v_FreeTextAddress         CHAR(200)
--Regexp_replace(trim(nvl(svna1,'') || ' ' || nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),'[|]',''),-- Need to discuss on these values    
     Regexp_replace(trim(FULL_ADDRESS),'[|]',''),
--   v_FreeTextLabel         CHAR(200)
     --'MIGRATED',
     --'ZZZ',
	 '.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ADDRESS_PROOF_RCVD     CHAR(1)
    '',                                         -- MAPPING TABLE REQUIRED
--   v_LASTUPDATE_DATE          CHAR(17)
    '',                                         
--   v_BANK_ID              CHAR(8)
    get_param('BANK_ID')                          -- MAPPING TABLE REQUIRED
from  ret_cust_address1 where upper(ADDR_TYPE)='PRIME';
commit;
INSERT INTO CU2_O_TABLE
select distinct
--   v_ORGKEY               CHAR(32)
    ret_cust_address1.FIN_CIF_ID,
--   v_ADDRESSCATEGORY         CHAR(100)   
       --case when trim(addr_type)='Add6' then to_char('Add'|| to_char(addr_num+1)) else trim(ADDR_TYPE) end,
	   ADDR_TYPE,--- Add6 validation removed becuase sanjay given confirmation on 19-04-2017 for not to migrate.
    --convert_codes('ADDR_CATEGORY',ADDRESSES.ADDRESS_TYPE),    
--   v_START_DATE          CHAR(17)
--to_char(case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_date(BGCODT,'YYYYMMDD')
--when GFCOD <> 0  and get_date_fm_btrv(GFCOD) <> 'ERROR' then  to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD')
--end),
case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when GFCOD <> 0  and get_date_fm_btrv(GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end,
--+ row_number() over (partition by ret_cust_address1.FIN_CIF_ID  order by ret_cust_address1.FIN_CIF_ID,trim(ADDR_TYPE) ),'DD-MON-YYYY'),--- changed as per vijay mail confirmation on 20-01-2017--commented on 01-05-2017 start date greaterthan cut offdate
--   v_PhoneNo1LocalCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CityCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CountryCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2LocalCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CityCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CountryCode      CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_WorkExtension         CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoLocalCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCityCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCountryCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_Email               CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoLocalCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCityCode          CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCountryCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexLocalCode             CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexCityCode          CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexCountryCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_HOUSE_NO              CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_PREMISE_NAME         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_BUILDING_LEVEL         CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_STREET_NO         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_STREET_NAME         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_SUBURB             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_LOCALITY_NAME          CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_TOWN             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_DOMICILE             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_CITY_CODE         CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_STATE_CODE         CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ZIP               CHAR(100)
    --nvl(Regexp_replace(substr(trim(migr.ZIP),1,10),'[|]',''),'000'),
    --nvl(svpzip,'999'),--chnaged on 05-01-2016
    case when Regexp_replace(trim(svpzip),'[-,A-Z,a-z,(,),., ]','') <> '0' then to_char(Regexp_replace(trim(svpzip),'[-,A-Z,a-z,(,),.]','')) else '999' end, --changed on 08-01-2017 as per sandeep and vijay confirmation
--   v_COUNTRY_CODE          CHAR(100)
    --nvl(convert_codes('COUNTRY',' '),'ZZZ'),
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ADDRESS_LINE1          CHAR(45)
    --nvl(Regexp_replace(substr(trim(nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),1,45),'[|]',''),'.'),-- Need to discuss on these values
    --nvl(Regexp_replace(trim(trn1),'[|]',''),'ZZZ999'),
    nvl(Regexp_replace(trim(trn1),'[|]',''),'.'),--default value changed on 03-04-2017 as per vijay confirmation on 02-04-2017
--   v_ADDRESS_LINE2         CHAR(45)
    --nvl(Regexp_replace(substr(trim(nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),46,45),'[|]',''),'.'),-- Need to discuss on these values
    Regexp_replace(trim(trn2),'[|]',''),
--   v_ADDRESS_LINE3         CHAR(45)
    --nvl(Regexp_replace(substr(trim(nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),91,45),'[|]',''),'.'),-- Need to discuss on these values
    Regexp_replace(trim(trn3),'[|]',''),
--   v_END_DATE             CHAR(17)
--to_char(to_date('01-NOV-2099','DD-MON-YYYY') + row_number() over (partition by migr.fin_cif_id order by migr.fin_cif_id,migr.ADDR_TYPE),'DD-MON-YYYY'),
'31-DEC-2099',
--   v_SMALL_STR1         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR2         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR3         CHAR(50)
    '',                                             -- DEFAULT SET TO BLANK
--   v_SMALL_STR4         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR5         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR6         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR7         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR8         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR9         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR10         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR1             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR2             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR3             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR4             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR5             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR6             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR7             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR8             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR9             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR10         CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR1         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR2         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR3         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR4         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR5         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE1             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE2             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE3             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE4             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE5             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE6             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE7             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE8             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE9             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE10             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER1             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER2             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER3             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER4             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER5             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER6             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER7             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER8             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER9             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER10             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL1             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL2             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL3             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL4             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL5             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL6             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL7             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL8             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL9             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL10         CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_CIFID             CHAR(32)
    ret_cust_address1.FIN_CIF_ID,                         -- Need to check for this field
--   v_preferredAddrss         CHAR(50)
    'N',                                        -- MAPPING TABLE REQUIRED
--   v_HoldMailInitiatedBy     CHAR(50)
    '',                                         -- MAPPING TABLE REQUIRED
--   v_HoldMailFlag         CHAR(50)
    'N',                                         -- MAPPING TABLE REQUIRED
--   v_BusinessCenter         CHAR(50)
    '',                                          -- MAPPING TABLE REQUIRED
--   v_HoldMailReason         CHAR(200)
    '',                                          --  MAPPING TABLE REQUIRED
--   v_PreferredFormat         CHAR(50)
    'FREE_TEXT_FORMAT',                          -- MAPPING TABLE REQUIRED
--   v_FreeTextAddress         CHAR(200)
--Regexp_replace(trim(nvl(svna1,'') || ' ' || nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),'[|]',''),-- Need to discuss on these values    
     Regexp_replace(trim(FULL_ADDRESS),'[|]',''),
--   v_FreeTextLabel         CHAR(200)
     --'MIGRATED',
     --'ZZZ',
	 '.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ADDRESS_PROOF_RCVD     CHAR(1)
    '',                                         -- MAPPING TABLE REQUIRED
--   v_LASTUPDATE_DATE          CHAR(17)
    '',                                         
--   v_BANK_ID              CHAR(8)
    get_param('BANK_ID')                          -- MAPPING TABLE REQUIRED
from  ret_cust_address1 
left join (select distinct fin_cif_id,max(to_number(substr(addr_type,4,2))) addr_num from ret_cust_address1  where trim(addr_type)<>'Prime' group  by fin_cif_id) cntr on cntr.fin_cif_id=ret_cust_address1.fin_cif_id 
where upper(trim(ADDR_TYPE))<>'PRIME';
commit;
------------------POA/guarantor  customer default address------------------------------------------
INSERT INTO CU2_O_TABLE
select distinct
--   v_ORGKEY               CHAR(32)
    fin_cif_id,
--   v_ADDRESSCATEGORY         CHAR(100)
    'Mailing',
--   v_START_DATE          CHAR(17)
     '01-JAN-1900',
--   v_PhoneNo1LocalCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CityCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CountryCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2LocalCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CityCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CountryCode      CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_WorkExtension         CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoLocalCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCityCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCountryCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_Email               CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoLocalCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCityCode          CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCountryCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexLocalCode             CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexCityCode          CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexCountryCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_HOUSE_NO              CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_PREMISE_NAME         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_BUILDING_LEVEL         CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_STREET_NO         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_STREET_NAME         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_SUBURB             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_LOCALITY_NAME          CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_TOWN             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_DOMICILE             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_CITY_CODE         CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_STATE_CODE         CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ZIP               CHAR(100)
     '999', 
--   v_COUNTRY_CODE          CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ADDRESS_LINE1          CHAR(45)
        '.',
--   v_ADDRESS_LINE2         CHAR(45)
        '',
--   v_ADDRESS_LINE3         CHAR(45)
        '',
--   v_END_DATE             CHAR(17)
'31-DEC-2099',
--   v_SMALL_STR1         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR2         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR3         CHAR(50)
    '',                                             -- DEFAULT SET TO BLANK
--   v_SMALL_STR4         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR5         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR6         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR7         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR8         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR9         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR10         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR1             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR2             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR3             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR4             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR5             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR6             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR7             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR8             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR9             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR10         CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR1         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR2         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR3         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR4         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR5         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE1             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE2             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE3             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE4             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE5             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE6             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE7             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE8             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE9             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE10             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER1             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER2             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER3             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER4             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER5             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER6             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER7             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER8             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER9             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER10             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL1             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL2             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL3             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL4             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL5             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL6             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL7             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL8             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL9             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL10         CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_CIFID             CHAR(32)
    fin_cif_id,                         -- Need to check for this field
--   v_preferredAddrss         CHAR(50)
   -- case when trim(fin_addr_type) = 'Mailing' then 'Y' else 'N' end,                                        -- MAPPING TABLE REQUIRED
      'Y',
--   v_HoldMailInitiatedBy     CHAR(50)
    '',                                         -- MAPPING TABLE REQUIRED
--   v_HoldMailFlag         CHAR(50)
    'N',                                         -- MAPPING TABLE REQUIRED
--   v_BusinessCenter         CHAR(50)
    '',                                          -- MAPPING TABLE REQUIRED
--   v_HoldMailReason         CHAR(200)
    '',                                          --  MAPPING TABLE REQUIRED
--   v_PreferredFormat         CHAR(50)
    'FREE_TEXT_FORMAT',                          -- MAPPING TABLE REQUIRED
--   v_FreeTextAddress         CHAR(200)
--Regexp_replace(trim(nvl(svna1,'') || ' ' || nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),'[|]',''),-- Need to discuss on these values    
     '',
--   v_FreeTextLabel         CHAR(200)
     --'ZZZ',
	 '.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ADDRESS_PROOF_RCVD     CHAR(1)
    '',                                         -- MAPPING TABLE REQUIRED
--   v_LASTUPDATE_DATE          CHAR(17)
    '',                                         
--   v_BANK_ID              CHAR(8)
    get_param('BANK_ID')                          -- MAPPING TABLE REQUIRED
FROM MAP_CIF_JOINT JNT;
commit;    
------Default mailing address----
insert into CU2_O_TABLE
select distinct
        --   v_ORGKEY               CHAR(32)
ORGKEY,
--   v_ADDRESSCATEGORY         CHAR(100)
'Mailing',                             -- for dummy structured address
--   v_START_DATE          CHAR(17)
RELATIONSHIPOPENINGDATE,
--   v_PhoneNo1LocalCode       CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CityCode         CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CountryCode     CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2LocalCode     CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CityCode       CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CountryCode      CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_WorkExtension         CHAR(10)
'',                             -- DEFAULT SET TO BLANK
--   v_FaxNoLocalCode         CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCityCode         CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCountryCode       CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_Email               CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_PagerNoLocalCode       CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCityCode          CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCountryCode     CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_TelexLocalCode             CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_TelexCityCode          CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_TelexCountryCode         CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_HOUSE_NO              CHAR(10)
'',                             -- DEFAULT SET TO BLANK
--   v_PREMISE_NAME         CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_BUILDING_LEVEL         CHAR(10)
'',                             -- DEFAULT SET TO BLANK
--   v_STREET_NO         CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_STREET_NAME         CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_SUBURB             CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_LOCALITY_NAME          CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_TOWN             CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_DOMICILE             CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_CITY_CODE         CHAR(100)
--'ZZZ',                             -- MAPPING TABLE REQUIRED
'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_STATE_CODE         CHAR(100)
--'ZZZ',                             -- MAPPING TABLE REQUIRED
'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ZIP               CHAR(100)
'999',                             -- MAPPING TABLE REQUIRED
--   v_COUNTRY_CODE          CHAR(100)
--'ZZZ',                             -- MAPPING TABLE REQUIRED
'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ADDRESS_LINE1          CHAR(45)
--'ZZZ999',                             -- DEFAULT SET TO BLANK
'.',--default value changed on 03-04-2017 as per vijay confirmation on 02-04-2017
--   v_ADDRESS_LINE2         CHAR(45)
'',
--   v_ADDRESS_LINE3         CHAR(45)
'',                             -- DEFAULT SET TO BLANK
--   v_END_DATE             CHAR(17)
'31-DEC-2099',                     -- DEFAULT SET TO 12/31/2099
--   v_SMALL_STR1         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR2         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR3         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR4         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR5         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR6         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR7         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR8         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR9         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR10         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR1             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR2             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR3             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR4             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR5             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR6             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR7             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR8             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR9             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR10         CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR1         CHAR(250)
'',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR2         CHAR(250)
'',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR3         CHAR(250)
'',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR4         CHAR(250)
'',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR5         CHAR(250)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE1             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE2             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE3             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE4             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE5             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE6             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE7             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE8             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE9             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE10             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER1             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER2             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER3             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER4             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER5             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER6             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER7             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER8             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER9             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER10             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL1             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL2             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL3             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL4             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL5             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL6             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL7             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL8             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL9             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL10         CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_CIFID             CHAR(32)
ORGKEY,
--   v_preferredAddrss         CHAR(50)
'Y',                                         -- MAPPING TABLE REQUIRED
--   v_HoldMailInitiatedBy     CHAR(50)
'',                                         -- MAPPING TABLE REQUIRED
--   v_HoldMailFlag         CHAR(50)
'N',                                         -- MAPPING TABLE REQUIRED
--   v_BusinessCenter         CHAR(50)
'',                                         -- MAPPING TABLE REQUIRED
--   v_HoldMailReason         CHAR(200)
'',                                         -- MAPPING TABLE REQUIRED
--   v_PreferredFormat         CHAR(50)
'FREE_TEXT_FORMAT',                                         -- MAPPING TABLE REQUIRED
--   v_FreeTextAddress         CHAR(200)
--'ZZZ999',                                         -- DEFAULT SET TO BLANK
'.',--default value changed on 03-04-2017 as per vijay confirmation on 02-04-2017
--   v_FreeTextLabel         CHAR(200)
--'ZZZ',
'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ADDRESS_PROOF_RCVD     CHAR(1)
'',                                         -- MAPPING TABLE REQUIRED
--   v_LASTUPDATE_DATE          CHAR(17)
'',                                         --SX20LF.SXDLM, BUT "SXDLM" IS NOT A FIELD IN "SX20LF" TABLE
--   v_BANK_ID              CHAR(8)
get_param('BANK_ID')                                         -- MAPPING TABLE REQUIRED
from cu1_o_table where orgkey not in (select distinct orgkey from cu2_o_table where ADDRESSCATEGORY='Mailing');
commit;
/*------Trade Finance address----
insert into CU2_O_TABLE
select distinct
        --   v_ORGKEY               CHAR(32)
ORGKEY,
--   v_ADDRESSCATEGORY         CHAR(100)
'Add6',                             -- for dummy structured address
--   v_START_DATE          CHAR(17)
to_char(to_date(RELATIONSHIPOPENINGDATE)+2,'DD-MON-YYYY'),
--   v_PhoneNo1LocalCode       CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CityCode         CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CountryCode     CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2LocalCode     CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CityCode       CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CountryCode      CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_WorkExtension         CHAR(10)
'',                             -- DEFAULT SET TO BLANK
--   v_FaxNoLocalCode         CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCityCode         CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCountryCode       CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_Email               CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_PagerNoLocalCode       CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCityCode          CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCountryCode     CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_TelexLocalCode             CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_TelexCityCode          CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_TelexCountryCode         CHAR(20)
'',                             -- DEFAULT SET TO BLANK
--   v_HOUSE_NO              CHAR(10)
'',                             -- DEFAULT SET TO BLANK
--   v_PREMISE_NAME         CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_BUILDING_LEVEL         CHAR(10)
'',                             -- DEFAULT SET TO BLANK
--   v_STREET_NO         CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_STREET_NAME         CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_SUBURB             CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_LOCALITY_NAME          CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_TOWN             CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_DOMICILE             CHAR(50)
'',                             -- DEFAULT SET TO BLANK
--   v_CITY_CODE         CHAR(100)
'ZZZ',            -- MAPPING TABLE REQUIRED
--   v_STATE_CODE         CHAR(100)
'ZZZ',            -- MAPPING TABLE REQUIRED
--   v_ZIP               CHAR(100)
nvl(tf.ZIPCODE,'999'),                             -- MAPPING TABLE REQUIRED
--   v_COUNTRY_CODE          CHAR(100)
nvl(tf.COUNTRY,'ZZZ'),                             -- MAPPING TABLE REQUIRED
--   v_ADDRESS_LINE1          CHAR(45)
substr(trim(tf.ADDR1),1,45),                             -- DEFAULT SET TO BLANK
--   v_ADDRESS_LINE2         CHAR(45)
substr(trim(tf.ADDR2),1,45),
--   v_ADDRESS_LINE3         CHAR(45)
substr(trim(tf.ADDR3),1,45),                             -- DEFAULT SET TO BLANK
--   v_END_DATE             CHAR(17)
'31-DEC-2099',                     -- DEFAULT SET TO 12/31/2099
--   v_SMALL_STR1         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR2         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR3         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR4         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR5         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR6         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR7         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR8         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR9         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR10         CHAR(50)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR1             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR2             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR3             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR4             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR5             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR6             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR7             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR8             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR9             CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR10         CHAR(100)
'',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR1         CHAR(250)
'',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR2         CHAR(250)
'',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR3         CHAR(250)
'',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR4         CHAR(250)
'',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR5         CHAR(250)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE1             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE2             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE3             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE4             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE5             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE6             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE7             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE8             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE9             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_DATE10             CHAR(17)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER1             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER2             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER3             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER4             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER5             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER6             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER7             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER8             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER9             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER10             CHAR(38)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL1             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL2             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL3             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL4             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL5             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL6             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL7             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL8             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL9             CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL10         CHAR(25)
'',                                         -- DEFAULT SET TO BLANK
--   v_CIFID             CHAR(32)
ORGKEY,
--   v_preferredAddrss         CHAR(50)
'N',                                         -- MAPPING TABLE REQUIRED
--   v_HoldMailInitiatedBy     CHAR(50)
'',                                         -- MAPPING TABLE REQUIRED
--   v_HoldMailFlag         CHAR(50)
'N',                                         -- MAPPING TABLE REQUIRED
--   v_BusinessCenter         CHAR(50)
'',                                         -- MAPPING TABLE REQUIRED
--   v_HoldMailReason         CHAR(200)
'',                                         -- MAPPING TABLE REQUIRED
--   v_PreferredFormat         CHAR(50)
'FREE_TEXT_FORMAT',                                         -- MAPPING TABLE REQUIRED
--   v_FreeTextAddress         CHAR(200)
 Regexp_replace(ADDR1||' '||ADDR2||' '||ADDR3,'[|]',''),                                         -- DEFAULT SET TO BLANK
--   v_FreeTextLabel         CHAR(200)
'ZZZ',
--   v_ADDRESS_PROOF_RCVD     CHAR(1)
'',                                         -- MAPPING TABLE REQUIRED
--   v_LASTUPDATE_DATE          CHAR(17)
'',                                         --SX20LF.SXDLM, BUT "SXDLM" IS NOT A FIELD IN "SX20LF" TABLE
--   v_BANK_ID              CHAR(8)
get_param('BANK_ID')                                         -- MAPPING TABLE REQUIRED
from TF_CIF_ADDRESS tf
inner join map_cif on map_cif.fin_cif_id=TRIM(tf.CIF_ID) 
inner join cu1_o_table on orgkey=TRIM(tf.CIF_ID)
where trim(tf.CIF_ID) is not null and INDIVIDUAL='Y';
commit; */
----- Phone numbers migrating to one address category
INSERT INTO CU2_O_TABLE
select distinct
--   v_ORGKEY               CHAR(32)
    FIN_CIF_ID,
--   v_ADDRESSCATEGORY         CHAR(100)
    'PHONENUM',
    --convert_codes('ADDR_CATEGORY',ADDRESSES.ADDRESS_TYPE),    
--   v_START_DATE          CHAR(17)
 --to_char(to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD'),'DD-MON-YYYY'),
case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when GFCOD <> 0  and get_date_fm_btrv(GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--   v_PhoneNo1LocalCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CityCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo1CountryCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2LocalCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CityCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PhoneNo2CountryCode      CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_WorkExtension         CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoLocalCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCityCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_FaxNoCountryCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_Email               CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoLocalCode       CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCityCode          CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_PagerNoCountryCode     CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexLocalCode             CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexCityCode          CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_TelexCountryCode         CHAR(20)
    '',                             -- DEFAULT SET TO BLANK
--   v_HOUSE_NO              CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_PREMISE_NAME         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_BUILDING_LEVEL         CHAR(10)
    '',                             -- DEFAULT SET TO BLANK
--   v_STREET_NO         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_STREET_NAME         CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_SUBURB             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_LOCALITY_NAME          CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_TOWN             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_DOMICILE             CHAR(50)
    '',                             -- DEFAULT SET TO BLANK
--   v_CITY_CODE         CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_STATE_CODE         CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ZIP               CHAR(100)
    case when to_number(Regexp_replace(trim(svpzip),'[-,A-Z,a-z,(,),., ]','0')) <> 0 then to_char(Regexp_replace(trim(svpzip),'[-,A-Z,a-z,(,),.]','')) else '999' end, 
--   v_COUNTRY_CODE          CHAR(100)
    --'ZZZ',
	'.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ADDRESS_LINE1          CHAR(45)
        --nvl(Regexp_replace(trim(trn1),'[|]',''),'ZZZ999'),
        nvl(Regexp_replace(trim(trn1),'[|]',''),'.'),--default value changed on 03-04-2017 as per vijay confirmation on 02-04-2017
--   v_ADDRESS_LINE2         CHAR(45)
        Regexp_replace(trim(trn2),'[|]',''),
--   v_ADDRESS_LINE3         CHAR(45)
        Regexp_replace(trim(trn3),'[|]',''),
--   v_END_DATE             CHAR(17)
'31-DEC-2099',
--   v_SMALL_STR1         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR2         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR3         CHAR(50)
    '',                                             -- DEFAULT SET TO BLANK
--   v_SMALL_STR4         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR5         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR6         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR7         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR8         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR9         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_SMALL_STR10         CHAR(50)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR1             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR2             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR3             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR4             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR5             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR6             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR7             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR8             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR9             CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_MED_STR10         CHAR(100)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR1         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR2         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR3         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR4         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_LARGE_STR5         CHAR(250)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE1             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE2             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE3             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE4             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE5             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE6             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE7             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE8             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE9             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DATE10             CHAR(17)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER1             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER2             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER3             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER4             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER5             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER6             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER7             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER8             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER9             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_NUMBER10             CHAR(38)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL1             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL2             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL3             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL4             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL5             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL6             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL7             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL8             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL9             CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_DECIMAL10         CHAR(25)
    '',                                         -- DEFAULT SET TO BLANK
--   v_CIFID             CHAR(32)
    FIN_CIF_ID,                         -- Need to check for this field
--   v_preferredAddrss         CHAR(50)
   -- case when trim(fin_addr_type) = 'Mailing' then 'Y' else 'N' end,                                        -- MAPPING TABLE REQUIRED
      'N',
--   v_HoldMailInitiatedBy     CHAR(50)
    '',                                         -- MAPPING TABLE REQUIRED
--   v_HoldMailFlag         CHAR(50)
    'N',                                         -- MAPPING TABLE REQUIRED
--   v_BusinessCenter         CHAR(50)
    '',                                          -- MAPPING TABLE REQUIRED
--   v_HoldMailReason         CHAR(200)
    '',                                          --  MAPPING TABLE REQUIRED
--   v_PreferredFormat         CHAR(50)
    'FREE_TEXT_FORMAT',                          -- MAPPING TABLE REQUIRED
--   v_FreeTextAddress         CHAR(200)
--Regexp_replace(trim(nvl(svna1,'') || ' ' || nvl(svna2,'')|| ' ' || nvl(svna3,'')||' ' ||nvl(svna4,'')||' ' ||nvl(svna5,'')),'[|]',''),-- Need to discuss on these values    
     Regexp_replace(trim(FULL_ADDRESS),'[|]',''),
--   v_FreeTextLabel         CHAR(200)
     --'ZZZ',
	 '.',-- changed on 05-06-2017 as per vijay confirmation
--   v_ADDRESS_PROOF_RCVD     CHAR(1)
    '',                                         -- MAPPING TABLE REQUIRED
--   v_LASTUPDATE_DATE          CHAR(17)
    '',                                         
--   v_BANK_ID              CHAR(8)
    get_param('BANK_ID')                          -- MAPPING TABLE REQUIRED
from  ret_cust_address_ph1; 
commit;
------------------------
insert into cu2_o_table 
select 
ORGKEY,'AltLangAdd',START_DATE,PHONENO1LOCALCODE,PHONENO1CITYCODE,PHONENO1COUNTRYCODE,PHONENO2LOCALCODE,PHONENO2CITYCODE,PHONENO2COUNTRYCODE,WORKEXTENSION,FAXNOLOCALCODE,FAXNOCITYCODE,FAXNOCOUNTRYCODE,EMAIL,
PAGERNOLOCALCODE,PAGERNOCITYCODE,PAGERNOCOUNTRYCODE,TELEXLOCALCODE,TELEXCITYCODE,TELEXCOUNTRYCODE,HOUSE_NO,PREMISE_NAME,BUILDING_LEVEL,STREET_NO,STREET_NAME,SUBURB,LOCALITY_NAME,TOWN,DOMICILE,CITY_CODE,STATE_CODE,
ZIP,COUNTRY_CODE,ADDRESS_LINE1,ADDRESS_LINE2,ADDRESS_LINE3,END_DATE,SMALL_STR1,SMALL_STR2,SMALL_STR3,SMALL_STR4,SMALL_STR5,SMALL_STR6,SMALL_STR7,SMALL_STR8,SMALL_STR9,SMALL_STR10,MED_STR1,MED_STR2,MED_STR3,
MED_STR4,MED_STR5,MED_STR6,MED_STR7,MED_STR8,MED_STR9,MED_STR10,LARGE_STR1,LARGE_STR2,LARGE_STR3,LARGE_STR4,LARGE_STR5,DATE1,DATE2,DATE3,DATE4,DATE5,DATE6,DATE7,DATE8,DATE9,DATE10,NUMBER1,NUMBER2,NUMBER3,NUMBER4,
NUMBER5,NUMBER6,NUMBER7,NUMBER8,NUMBER9,NUMBER10,DECIMAL1,DECIMAL2,DECIMAL3,DECIMAL4,DECIMAL5,DECIMAL6,DECIMAL7,DECIMAL8,DECIMAL9,DECIMAL10,CIFID,'N',HOLDMAILINITIATEDBY,HOLDMAILFLAG,BUSINESSCENTER,HOLDMAILREASON,
PREFERREDFORMAT,FREETEXTADDRESS,FREETEXTLABEL,ADDRESS_PROOF_RCVD,LASTUPDATE_DATE,BANK_ID from cu2_o_table  where ADDRESSCATEGORY='Mailing';
commit;
--delete from cu2_o_table where rowid not in (select min(rowid) from cu2_o_table where ADDRESSCATEGORY='Add6' group by orgkey )
--and ADDRESSCATEGORY='Add6';
commit; 
-- Deleteing duplicate addresses added on 29-05-2017 by kumar--
delete from cu2_o_table where rowid not in (select min(rowid) from cu2_o_table group by orgkey,FREETEXTADDRESS ) and addresscategory not in ('AltLangAdd','Mailing','PHONENUM');
commit; 
drop table cu2_o_table_temp;
create table cu2_o_table_temp as select * from cu2_o_table;
truncate table cu2_o_table;
insert into cu2_o_table select * from cu2_o_table_temp where addresscategory in ('AltLangAdd','Mailing','PHONENUM');
commit;
insert into cu2_o_table 
select ORGKEY,'Add'||row_number() over (partition by orgkey order by orgkey) , to_char(to_date(Start_date,'DD-MM-YYYY'),'DD-MON-YYYY'),PHONENO1LOCALCODE,PHONENO1CITYCODE,PHONENO1COUNTRYCODE,PHONENO2LOCALCODE,PHONENO2CITYCODE,PHONENO2COUNTRYCODE,WORKEXTENSION,FAXNOLOCALCODE,FAXNOCITYCODE,FAXNOCOUNTRYCODE,EMAIL,
PAGERNOLOCALCODE,PAGERNOCITYCODE,PAGERNOCOUNTRYCODE,TELEXLOCALCODE,TELEXCITYCODE,TELEXCOUNTRYCODE,HOUSE_NO,PREMISE_NAME,BUILDING_LEVEL,STREET_NO,STREET_NAME,SUBURB,LOCALITY_NAME,TOWN,DOMICILE,CITY_CODE,STATE_CODE,
ZIP,COUNTRY_CODE,ADDRESS_LINE1,ADDRESS_LINE2,ADDRESS_LINE3,END_DATE,SMALL_STR1,SMALL_STR2,SMALL_STR3,SMALL_STR4,SMALL_STR5,SMALL_STR6,SMALL_STR7,SMALL_STR8,SMALL_STR9,SMALL_STR10,MED_STR1,MED_STR2,MED_STR3,
MED_STR4,MED_STR5,MED_STR6,MED_STR7,MED_STR8,MED_STR9,MED_STR10,LARGE_STR1,LARGE_STR2,LARGE_STR3,LARGE_STR4,LARGE_STR5,DATE1,DATE2,DATE3,DATE4,DATE5,DATE6,DATE7,DATE8,DATE9,DATE10,NUMBER1,NUMBER2,NUMBER3,NUMBER4,
NUMBER5,NUMBER6,NUMBER7,NUMBER8,NUMBER9,NUMBER10,DECIMAL1,DECIMAL2,DECIMAL3,DECIMAL4,DECIMAL5,DECIMAL6,DECIMAL7,DECIMAL8,DECIMAL9,DECIMAL10,CIFID,'N',HOLDMAILINITIATEDBY,HOLDMAILFLAG,BUSINESSCENTER,HOLDMAILREASON,
PREFERREDFORMAT,FREETEXTADDRESS,FREETEXTLABEL,ADDRESS_PROOF_RCVD,LASTUPDATE_DATE,BANK_ID 
from cu2_o_table_temp where addresscategory not in ('AltLangAdd','Mailing','PHONENUM');
commit; 
drop table acct_addr_type_ret;
create table acct_addr_type_ret as
select distinct syab||syan||syas leg_acc_num,syseq,addresscategory from ret_addr_step2 a
inner join sypf on a.svseq=syseq
inner join svpf b on b.svseq=syseq
inner join map_acc on syab=leg_branch_id and leg_scan=syan and syas=leg_scas
inner join (select * from cu2_o_table where addresscategory not in ('Mailing','AltLangAdd')) on trim(svna2)||' '||trim(svna3)||' '||trim(svna4)||' '||trim(svna5)=FREETEXTADDRESS and orgkey=fin_cif_id
where schm_type in('SBA','CAA','ODA','PCA') and trim(syprim) is null  and trim(sxprim) is null;
exit; 